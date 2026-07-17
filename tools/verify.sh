#!/usr/bin/env bash
# tools/verify.sh — детерминированный гейт целостности репо. Запуск: bash tools/verify.sh (из корня).
set -u
fail=0
err(){ echo "FAIL: $*"; fail=1; }
ok(){ echo "  ok: $*"; }

test -f docs/02_ADR_LOG.md || { echo "FAIL: запускай из корня dom-prorab-ecom-arch"; exit 1; }

# 1. Обязательные файлы
for f in README.md docs/00_STATE.md docs/01_CONVENTIONS.md docs/02_ADR_LOG.md docs/03_ROLES.md \
         docs/04_SESSION_PROTOCOL.md docs/05_ROADMAP.md docs/06_BRIEF_TEMPLATE.md \
         prompts/business.md prompts/architect.md prompts/executor.md prompts/applier.md \
         l3-external/MANIFEST.md l2-registers/problem_register.md l2-registers/contractor_questions.md \
         l2-registers/open_questions.md l2-registers/assumptions.md tools/verify.sh; do
  [ -f "$f" ] || err "отсутствует $f"
done
[ $fail -eq 0 ] && ok "структура: все обязательные файлы на месте"

# 2. Хэши md-фрагментов сходятся с MANIFEST + нет неучтённых файлов
python3 - << 'PY' || fail=1
import hashlib, re, sys, os
rows = []
for line in open('l3-external/MANIFEST.md', encoding='utf-8'):
    m = re.match(r'\| md/(\S+\.md) \|.*`([0-9a-f]{16})`', line)
    if m: rows.append(m.groups())
if not rows:
    print("FAIL: в MANIFEST не найдено ни одной строки фрагментов"); sys.exit(1)
bad = 0
disk = {f for f in os.listdir('l3-external/md') if f.endswith('.md')}
listed = {f for f, _ in rows}
for extra in sorted(disk - listed):
    print(f"FAIL: md/{extra} есть на диске, но отсутствует в MANIFEST"); bad += 1
for fname, sha16 in rows:
    try:
        h = hashlib.sha256(open('l3-external/md/' + fname, 'rb').read()).hexdigest()[:16]
    except FileNotFoundError:
        print(f"FAIL: в MANIFEST есть md/{fname}, файла нет"); bad += 1; continue
    if h != sha16:
        print(f"FAIL: хэш md/{fname}: {h} != {sha16} (фрагмент изменён — нарушение immutable, К-3)"); bad += 1
if not bad: print(f"  ok: MANIFEST — {len(rows)}/{len(rows)} фрагментов сходятся")
sys.exit(1 if bad else 0)
PY

# 3. ADR: номера уникальны и монотонны
python3 - << 'PY' || fail=1
import re, sys
txt = open('docs/02_ADR_LOG.md', encoding='utf-8').read()
ids = [int(m.group(1)) for m in re.finditer(r'^## ADR-(\d+)', txt, re.M)]
if not ids: print("FAIL: в ADR-логе нет записей"); sys.exit(1)
dup = sorted({i for i in ids if ids.count(i) > 1})
if dup: print(f"FAIL: дубли номеров ADR: {dup}"); sys.exit(1)
if ids != sorted(ids): print("FAIL: номера ADR не монотонны (append-only нарушен)"); sys.exit(1)
print(f"  ok: ADR-лог — {len(ids)} записей (ADR-{min(ids):03d}…ADR-{max(ids):03d}), монотонно, без дублей")
PY

# 4. ADR append-only против предыдущего коммита
if git rev-parse HEAD~1 >/dev/null 2>&1; then
  deleted=$(git diff HEAD~1 HEAD -- docs/02_ADR_LOG.md | grep -cE '^-[^-]' || true)
  if [ "${deleted:-0}" -gt 0 ]; then
    err "ADR-лог: $deleted удалённых/изменённых строк против HEAD~1 (append-only нарушен)"
  else ok "ADR append-only (HEAD~1 → HEAD)"; fi
fi

# 5. l3-external/raw неизменен против предыдущего коммита (immutable, К-3)
# Санкционированное исключение: ALLOW_RAW_CHANGE=1 bash tools/verify.sh (только при явном решении/ADR, см. К-12)
if git rev-parse HEAD~1 >/dev/null 2>&1; then
  if [ "${ALLOW_RAW_CHANGE:-0}" = "1" ]; then
    ok "l3-external/raw: изменение санкционировано (ALLOW_RAW_CHANGE=1)"
  elif git diff --name-only HEAD~1 HEAD -- l3-external/raw/ | grep -q .; then
    err "l3-external/raw изменён (immutable нарушен — новые версии = новые файлы + ADR; санкционировано → ALLOW_RAW_CHANGE=1)"
  else ok "l3-external/raw неизменен"; fi
fi

# 6. STATE: обязательные секции
for s in "Статус фаз" "Блокеры"; do
  grep -q "$s" docs/00_STATE.md || err "в STATE нет секции '$s'"
done
ok "STATE: секции на месте"

echo
if [ $fail -eq 0 ]; then echo "VERIFY: GREEN"; else echo "VERIFY: RED"; exit 1; fi
