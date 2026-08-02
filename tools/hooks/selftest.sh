#!/usr/bin/env bash
# FILE: tools/hooks/selftest.sh — самотест pre-commit хука на фикстурном репо (ADR-028)
# Запуск: bash tools/hooks/selftest.sh (из корня клона). Ожидание: «провалено 0».
# Урок holika (ADR-074): хук без самотеста хуже отсутствия хука — отказ хука тихий.
# Каждый кейс гоняется в двух локалях: C (байтовая семантика) и первая доступная UTF-8.
set -u
HOOK_SRC="$(cd "$(dirname "$0")" && pwd)/pre-commit"
[ -f "$HOOK_SRC" ] || { echo "selftest: не найден $HOOK_SRC"; exit 1; }

MB_LOCALE=""
for cand in C.UTF-8 en_US.UTF-8 ru_RU.UTF-8; do
  if locale -a 2>/dev/null | grep -qix -e "$cand" -e "${cand/UTF-8/utf8}"; then MB_LOCALE="$cand"; break; fi
done
[ -n "$MB_LOCALE" ] || { echo "selftest: не найдена UTF-8 локаль (locale -a); стоп"; exit 1; }

PASSED=0; FAILED=0

new_repo() {  # свежий фикстурный репо с минимальной структурой и заглушкой verify
  R=$(mktemp -d)
  git -C "$R" init -q -b main
  git -C "$R" config user.email t@t; git -C "$R" config user.name t
  mkdir -p "$R/docs" "$R/tools" "$R/l3-external/raw"
  printf '%s\n' '#!/usr/bin/env bash' 'echo "VERIFY: GREEN (stub)"' > "$R/tools/verify.sh"
  cat > "$R/docs/00_STATE.md" <<'EOF'
# FILE: docs/00_STATE.md
# STATE
**Версия:** v1 · **updated:** 2026-01-01
- [Business] OQ-77 — тестовый открытый вопрос
EOF
  cat > "$R/docs/02_ADR_LOG.md" <<'EOF'
# FILE: docs/02_ADR_LOG.md
# ADR LOG (append-only)
## ADR-001 — базовое решение
**Дата:** 2026-01-01. **Статус:** proposed
Текст решения.
EOF
  cat > "$R/docs/02_ADR_INDEX.md" <<'EOF'
# FILE: docs/02_ADR_INDEX.md
| ADR-001 | базовое решение | proposed |
EOF
  printf '%s\n' '# FILE: docs/00_STATE_ARCHIVE.md' > "$R/docs/00_STATE_ARCHIVE.md"
  printf 'raw-заглушка\n' > "$R/l3-external/raw/seed.docx.txt"
  git -C "$R" add -A
  git -C "$R" -c core.hooksPath=/dev/null commit -qm init
  mkdir -p "$R/.git/hooks"; cp "$HOOK_SRC" "$R/.git/hooks/pre-commit"; chmod +x "$R/.git/hooks/pre-commit"
}

run_case() {  # $1 ожидание pass|fail · $2 имя · $3 env-префикс (может быть пуст)
  local expect="$1" name="$2" envp="$3" rc out
  out=$(cd "$R" && git add -A && env $envp LC_ALL="$LOC" LANG="$LOC" PRECOMMIT_SKIP_VERIFY="${PSV:-0}" \
        git commit -qm "case: $name" 2>&1); rc=$?
  if { [ "$expect" = pass ] && [ $rc -eq 0 ]; } || { [ "$expect" = fail ] && [ $rc -ne 0 ]; }; then
    PASSED=$((PASSED+1))
  else
    FAILED=$((FAILED+1))
    echo "ПРОВАЛ [$LOC] $name (ожидалось $expect, rc=$rc)"; printf '%s\n' "$out" | sed 's/^/    /'
  fi
  rm -rf "$R"
}

for LOC in C "$MB_LOCALE"; do
  PSV=1  # кейсы 1–15 проверяют механику хука; verify тестируется отдельно (кейс 16)

  new_repo; printf '# FILE: docs/03_NEW_DOC.md\nтекст\n' > "$R/docs/03_NEW_DOC.md"
  run_case pass "верная FILE-строка нового дока" ""

  new_repo; printf '# NEW DOC\nтекст\n' > "$R/docs/03_NEW_DOC.md"
  run_case fail "неверная FILE-строка нумерованного дока" ""

  new_repo; printf 'просто заметка без FILE-строки\n' > "$R/notes.md"
  run_case pass "файл вне scope проверки FILE-строки" ""

  # Двойники во всех кейсах ниже записаны hex-эскейпами: \xd0\x90 = А, \xd0\x92 = В,
  # \xd0\x9c = М, \xd0\x9e = О. Литеральная буква в исходнике самотеста попадает под
  # проверку 2 этого же хука на коммите, который её вносит, и коммит падает. Не заменять.
  new_repo; printf 'упоминание \xd0\x90DR-002 с кириллической буквой\n' > "$R/notes.md"
  run_case fail "гомоглиф: кириллица в ADR-ID" ""

  new_repo; printf 'упоминание \xd0\x92Q-01 с кириллической буквой\n' > "$R/notes.md"
  run_case fail "гомоглиф: кириллица в BQ-ID" ""

  new_repo; printf '\xd0\x9c1-01 в начале идентификатора\n' > "$R/notes.md"
  run_case fail "гомоглиф: кириллица в начале ID волны M" ""

  new_repo; printf 'M1-\xd0\x9e1 внутри идентификатора\n' > "$R/notes.md"
  run_case fail "гомоглиф: кириллица внутри ID волны M" ""

  new_repo; printf 'чистые ID: ADR-002, BQ-01, P-07, F5-01, M1-01, M2-14\n' > "$R/notes.md"
  run_case pass "чистые латинские ID не срабатывают" ""

  new_repo
  printf '%s\n' '## ADR-002 — второе решение' '**Дата:** 2026-01-02. **Статус:** accepted' 'Текст.' >> "$R/docs/02_ADR_LOG.md"
  printf '%s\n' '| ADR-002 | второе решение | accepted |' >> "$R/docs/02_ADR_INDEX.md"
  run_case pass "append ADR вместе со строкой индекса" ""

  new_repo
  printf '%s\n' '## ADR-002 — второе решение' '**Дата:** 2026-01-02. **Статус:** accepted' 'Текст.' >> "$R/docs/02_ADR_LOG.md"
  run_case fail "append ADR без строки индекса" ""

  new_repo
  printf '%s\n' '## ADR-002 — второе решение' '**Дата:** 2026-01-02. **Статус:** accepted' 'Текст.' >> "$R/docs/02_ADR_LOG.md"
  printf '%s\n' '| прочая строка |' >> "$R/docs/02_ADR_INDEX.md"
  run_case fail "индекс в коммите, но номера ADR в нём нет" ""

  new_repo; sed -i.bak 's/^Текст решения.$/Изменённый текст./' "$R/docs/02_ADR_LOG.md"; rm -f "$R/docs/02_ADR_LOG.md.bak"
  run_case fail "правка содержательной строки ADR-лога (append-only)" ""

  new_repo; sed -i.bak 's/\*\*Статус:\*\* proposed/**Статус:** accepted/' "$R/docs/02_ADR_LOG.md"; rm -f "$R/docs/02_ADR_LOG.md.bak"
  run_case pass "правка строки статуса ADR разрешена (ADR-016)" ""

  new_repo
  sed -i.bak '/OQ-77/d' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case fail "ID исчез из STATE без архива" ""

  new_repo
  sed -i.bak '/OQ-77/d' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  printf '%s\n' '- OQ-77 — закрыт тестом' >> "$R/docs/00_STATE_ARCHIVE.md"
  run_case pass "ID исчез из STATE вместе с архивом" ""

  new_repo
  sed -i.bak 's/тестовый открытый вопрос/переформулированный вопрос/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case pass "переформулировка строки с тем же ID не требует архива" ""

  new_repo
  sed -i.bak 's/тестовый открытый вопрос/уточнённый вопрос/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case fail "правка STATE без обновления строки Версия/updated" ""

  PSV=0
  new_repo; printf '%s\n' '#!/usr/bin/env bash' 'echo "VERIFY: RED (stub)"; exit 1' > "$R/tools/verify.sh"
  printf '# FILE: docs/03_NEW_DOC.md\nтекст\n' > "$R/docs/03_NEW_DOC.md"
  run_case fail "verify RED валит коммит" ""

  new_repo; printf 'новая версия\n' > "$R/l3-external/raw/seed2.docx.txt"
  PSV=1 run_case fail "staged-файл в l3-external/raw без санкции" ""

  new_repo; printf 'новая версия\n' > "$R/l3-external/raw/seed2.docx.txt"
  PSV=1 run_case pass "l3-external/raw с ALLOW_RAW_CHANGE=1 (К-12)" "ALLOW_RAW_CHANGE=1"
done

echo
echo "selftest: пройдено $PASSED, провалено $FAILED (локали: C, $MB_LOCALE)"
[ "$FAILED" -eq 0 ] || exit 1
