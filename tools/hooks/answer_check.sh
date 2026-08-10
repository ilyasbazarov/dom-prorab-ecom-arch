#!/usr/bin/env bash
# FILE: tools/hooks/answer_check.sh — машинная проверка формы ответа роли (К-39, ADR-122)
#
# Зачем. Текст к Owner — единственный артефакт проекта, который не лежит в репо и потому
# не виден ни pre-commit хуку, ни tools/verify.sh. Правило формы без носителя проверки
# держится на памяти роли и не держится. Этот скрипт даёт форме носитель: хук Stop
# Claude Code читает готовый ответ и возвращает его роли на переписывание.
#
# Режимы запуска:
#   (без аргументов)  — хук Stop: JSON на stdin, текст берётся из transcript_path
#   --text <файл>     — проверка готового текста из файла (самотест, К-34)
#
# Коды выхода: 0 — форма сошлась, либо это повторный заход (stop_hook_active), либо
# внутренний отказ проверки; 2 — нарушение, stderr уходит модели и она переписывает ответ.
#
# Отказ проверки не тихий (CLAUDE.md §Старт п.4): любой внутренний сбой печатается в
# stderr и дописывается в .claude/answer_check.log, но работу не блокирует.
set -u

note() {
  printf 'answer_check: %s\n' "$*" >&2
  [ -d .claude ] && printf '%s\n' "answer_check: $*" >> .claude/answer_check.log 2>/dev/null
  return 0
}

# Локаль задаётся явно (К-35): под байтовой семантикой классы символов в разборе
# занижаются молча, а вердикт при этом печатается тот же.
for cand in ru_RU.UTF-8 en_US.UTF-8 C.UTF-8; do
  if locale -a 2>/dev/null | grep -qix -e "$cand" -e "${cand/UTF-8/utf8}"; then
    export LC_ALL="$cand"; break
  fi
done

TMPS=""
trap '[ -n "$TMPS" ] && rm -f $TMPS' EXIT

if [ "${1:-}" = "--text" ]; then
  TXT="${2:-}"
  [ -f "$TXT" ] || { note "не найден файл текста '${2:-}'"; exit 0; }
else
  command -v python3 >/dev/null 2>&1 || { note "нет python3, форма ответа НЕ проверена"; exit 0; }
  TXT=$(mktemp); PYF=$(mktemp); TMPS="$TXT $PYF"
  cat > "$PYF" <<'PY'
import io, json, sys

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
PY
  python3 "$PYF" "$TXT"; rc=$?
  case "$rc" in
    0) ;;
    3) exit 0 ;;                                     # повторный заход
    *) note "транскрипт не разобран, форма ответа НЕ проверена"; exit 0 ;;
  esac
  [ -s "$TXT" ] || exit 0                            # текста нет — проверять нечего
fi

# ── разбор текста ───────────────────────────────────────────────────────────────
NUM=0                       # порядковый номер непустой строки
H1=""; H2=""; H3=""
AFTER=0                     # непустых строк после шапки (лимит К-39 §2)
PARA=0; MAXPARA=0; MAXPARA_AT=""
FENCE=0
MACHINE=""                  # первая напечатанная в чат строка машинной части

while IFS= read -r raw || [ -n "$raw" ]; do
  line=$(printf '%s' "$raw" | sed 's/[[:space:]]*$//')
  trimmed=$(printf '%s' "$line" | sed 's/^[[:space:]]*//')

  case "$trimmed" in '```'*) FENCE=$((1-FENCE)); PARA=0; continue;; esac
  [ -n "$trimmed" ] || { PARA=0; continue; }

  NUM=$((NUM+1))
  norm=$(printf '%s' "$trimmed" | tr -d '*#' | sed 's/^[[:space:]]*//')

  case "$NUM" in
    1) H1="$norm" ;;
    2) H2="$norm" ;;
    3) H3="$norm" ;;
    *) AFTER=$((AFTER+1)) ;;
  esac

  # Носители машинной части, напечатанные в чат (К-39 §7)
  if [ -z "$MACHINE" ]; then
    case "$trimmed" in
      '=== SESSION LOG'*|'=== END SESSION'*|'## SESSION_LOG'*|'## STATE_PATCH'*|\
      '## NEW_DECISIONS'*|'## REGISTER_PATCHES'*|'## FILE_PATCHES'*|\
      '## NEW_CONVENTIONS'*|'## JOURNAL_ROW'*) MACHINE="$trimmed" ;;
    esac
  fi

  # Длина абзаца. Список, таблица, заголовок, цитата, строка внутри блока кода и
  # продолжение с отступом абзацем не являются: К-39 §3 бьёт по слитному тексту.
  [ "$FENCE" = "0" ] || { PARA=0; continue; }
  case "$trimmed" in
    -*|'*'*|'|'*|'#'*|'>'*|'§'*|[0-9].*|[0-9][0-9].*|[0-9]')'*) PARA=0; continue;;
  esac
  case "$line" in '  '*|'	'*) continue;; esac
  PARA=$((PARA+1))
  if [ "$PARA" -gt "$MAXPARA" ]; then MAXPARA="$PARA"; MAXPARA_AT="$trimmed"; fi
done < "$TXT"

# ── вердикты (К-28: печатаются сами нарушения, а не метка PASS/FAIL) ────────────
V=0
OUT=""
viol() { V=$((V+1)); OUT="$OUT
  $V. $1"; }

case "$H1" in "Сделано:"*) ;; *) viol "строка 1 шапки не «Сделано:», а «${H1:-<пусто>}»";; esac
case "$H2" in "Нужно от Owner:"*) ;; *) viol "строка 2 шапки не «Нужно от Owner:», а «${H2:-<пусто>}»";; esac
case "$H3" in
  "Рекомендация:"*)
    rec=$(printf '%s' "$H3" | sed 's/^Рекомендация:[[:space:]]*//')
    if [ -z "$rec" ]; then
      viol "строка «Рекомендация:» пуста"
    else
      # Альтернация целыми словами, а не класс [Сс]: bracket-выражение с кириллицей
      # распадается на байты под байтовой семантикой и молча не срабатывает (К-35).
      case "$rec" in
        'см. ниже'*|'См. ниже'*|'ниже'*|'Ниже'*|'в тексте'*|'В тексте'*|'—'|'-')
          viol "строка «Рекомендация:» отсылает вниз вместо содержания: «${rec}» (К-39 §6, К-25)";;
      esac
    fi ;;
  *) viol "строка 3 шапки не «Рекомендация:», а «${H3:-<пусто>}»";;
esac

[ "$AFTER" -le 25 ] || viol "текст к Owner после шапки — $AFTER непустых строк при лимите 25 (К-39 §2): лишнее уходит в файл репо или в следующую сессию"
[ "$MAXPARA" -le 3 ] || viol "абзац длиной $MAXPARA строк при лимите 3 (К-39 §3), начало: «${MAXPARA_AT}»"
[ -z "$MACHINE" ] || viol "машинная часть напечатана в чат, строка «${MACHINE}» (К-39 §7): её носители — файлы репо и описание коммита"

[ "$V" -eq 0 ] && exit 0

{
  printf 'ФОРМА ОТВЕТА НЕ СОШЛАСЬ — нарушений %d (tools/hooks/answer_check.sh):%s\n' "$V" "$OUT"
  printf '\nПерепиши ответ по К-39 и К-42: шапка из трёх строк, вывод раньше доказательства,\n'
  printf 'не более 25 строк после шапки, абзац не длиннее трёх строк, машинная часть в чат\n'
  printf 'не печатается. Сокращать существенное молча запрещено — выброшенное назови строкой.\n'
} >&2
exit 2
