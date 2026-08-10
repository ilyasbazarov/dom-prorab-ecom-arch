# FILE: tools/hooks/answer_extract.py — выемка последнего ответа роли из транскрипта (ADR-123 §1)
#
# Используется обеими проверками ответа (answer_check.sh, answer_judge.sh), чтобы разбор
# транскрипта лежал в одном месте: две копии разъезжаются молча.
#
# Вход: JSON хука на stdin, путь выходного файла первым аргументом.
# Коды выхода: 0 — текст записан; 3 — повторный заход (stop_hook_active), проверять нечего;
#              1 — payload или транскрипт не разобраны.
import io
import json
import sys

out_path = sys.argv[1]
try:
    payload = json.loads(sys.stdin.read())
except Exception:
    sys.exit(1)

# Повторный заход: один принудительный переписыв на ответ, дальше пропускаем.
# Без этого пара «хук ↔ модель» уходит в бесконечный цикл.
if payload.get("stop_hook_active"):
    sys.exit(3)

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
