# FILE: tools/hooks/answer_extract.py — выемка последнего ответа роли из транскрипта (ADR-123 §1)
#
# Используется обеими проверками ответа (answer_check.sh, answer_judge.sh), чтобы разбор
# транскрипта лежал в одном месте: две копии разъезжаются молча.
#
# Вход: JSON хука на stdin, путь выходного файла первым аргументом.
# Коды выхода: 0 — текст записан; 4 — текст записан, но это ПОВТОРНЫЙ заход (stop_hook_active);
#              1 — payload или транскрипт не разобраны.
# Код 3 (повторный заход, текст не выдан) отменён ADR-125 §3.
import io
import json
import sys

out_path = sys.argv[1]
try:
    payload = json.loads(sys.stdin.read())
except Exception:
    sys.exit(1)

# Повторный заход. Раньше здесь стоял выход ДО выемки текста, и замер не видел исхода
# возврата: правило-останов удостоверялось первым проходом, а исправлен ли ответ — ничем
# (К-34, находка №5 захода reviewer_method_gate). Теперь текст извлекается и на втором
# проходе, а код 4 велит проверке идти в предупредительном режиме: вердикт пишется в лог,
# ответ не возвращается. Бесконечной пары «хук ↔ модель» не возникает — второй проход не
# блокирует по построению. Основание: ADR-125 §3.
repeat = bool(payload.get("stop_hook_active"))

last = ""
try:
    with io.open(payload.get("transcript_path") or "", encoding="utf-8") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                obj = json.loads(line)
            except Exception:
                continue
            if obj.get("type") != "assistant":
                continue
            blocks = (obj.get("message") or {}).get("content") or []
            text = "\n".join(
                b.get("text", "") for b in blocks
                if isinstance(b, dict) and b.get("type") == "text"
            ).strip()
            if text:
                last = text
except Exception:
    sys.exit(1)

with io.open(out_path, "w", encoding="utf-8") as fh:
    fh.write(last)

sys.exit(4 if repeat else 0)
