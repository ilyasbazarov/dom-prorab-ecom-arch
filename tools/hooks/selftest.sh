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
- ADR-099 [ARCH]: запись списочной формой
  Текст записи.
  Статус: proposed
EOF
  cat > "$R/docs/02_ADR_INDEX.md" <<'EOF'
# FILE: docs/02_ADR_INDEX.md
| ADR-001 | базовое решение | proposed |
| ADR-099 | запись списочной формой | proposed |
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
  # Смерть хука по сигналу (rc > 128, напр. 141 = SIGPIPE) — ВСЕГДА провал, даже когда кейс
  # ждал fail: коммит не прошёл, но ни одной причины не названо, а отказ проверки обязан быть
  # громким. Без этой ветки самотест зеленел на хуке, который умирал молча на большом файле.
  if [ $rc -gt 128 ]; then
    FAILED=$((FAILED+1))
    echo "ПРОВАЛ [$LOC] $name (хук убит сигналом, rc=$rc — отказ проверки тихий)"; printf '%s\n' "$out" | sed 's/^/    /'
  elif { [ "$expect" = pass ] && [ $rc -eq 0 ]; } || { [ "$expect" = fail ] && [ $rc -ne 0 ]; }; then
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

  new_repo; sed -i.bak 's/^  Статус: proposed$/  Статус: accepted/' "$R/docs/02_ADR_LOG.md"; rm -f "$R/docs/02_ADR_LOG.md.bak"
  run_case pass "правка строки статуса списочной записи разрешена (ADR-016, ADR-073 §2)" ""

  new_repo
  printf '%s\n' '- ADR-002 [ARCH]: списочная запись без индекса' '  Статус: proposed' >> "$R/docs/02_ADR_LOG.md"
  run_case fail "append ADR списочной формой без строки индекса (ADR-073 §1)" ""

  new_repo
  printf '%s\n' '- ADR-002 [ARCH]: списочная запись с индексом' '  Статус: proposed' >> "$R/docs/02_ADR_LOG.md"
  printf '%s\n' '| ADR-002 | списочная запись | proposed |' >> "$R/docs/02_ADR_INDEX.md"
  run_case pass "append ADR списочной формой вместе со строкой индекса (ADR-073 §1)" ""

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

  # Лимит стенд-апа (ADR-126). Ветка останова: раздел длиннее лимита валит коммит. Положительная
  # ветка тут не украшение — она удостоверяет, что нормальный стенд-ап из пяти полей проходит,
  # иначе проверка запретила бы саму форму, которую предписывает протокол.
  new_repo
  { printf '%s\n' '### Стенд-ап' '**Где мы.** одна строка' '**Прошлый шаг.** одна строка' \
      '**Следующий шаг.** одна строка' '**Идёт своей дорожкой.** одна строка' '**На Owner лично.** одна строка'
  } >> "$R/docs/00_STATE.md"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case pass "стенд-ап из пяти полей проходит" ""

  new_repo
  { printf '%s\n' '### Стенд-ап'
    i=1; while [ $i -le 21 ]; do printf 'строка полотна номер %d\n' "$i"; i=$((i+1)); done
  } >> "$R/docs/00_STATE.md"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case fail "стенд-ап длиннее лимита валит коммит" ""

  new_repo
  LONGV=$(printf 'ц%.0s' $(seq 1 1000))   # 2000 байт: лимит считается в байтах в обеих локалях
  sed -i.bak "s/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02 · $LONGV/" "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case fail "строка Версия длиннее лимита валит коммит" ""

  # Большой STATE: ровно то условие, при котором проверка 6b умирала по SIGPIPE — блоб не влезал
  # в буфер пайпа, а читающая сторона закрывалась раньше. Фикстура на 8 килострок это ловит,
  # маленькая — нет: дефект был зелёным на коротком файле.
  new_repo
  { printf '%s\n' '## Хвост фикстуры'
    i=1; while [ $i -le 8000 ]; do printf 'строка хвоста номер %d\n' "$i"; i=$((i+1)); done
  } >> "$R/docs/00_STATE.md"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case pass "большой STATE не роняет проверку по SIGPIPE" ""

  # Правило выхода остальных разделов STATE (ADR-137). У каждого лимита прогоняется ветка
  # ОСТАНОВА (К-34): положительная ветка наступает всегда и не удостоверяет ничего.
  new_repo
  ORPH=$(printf 'ц%.0s' $(seq 1 1400))    # 2800 байт рядом со строкой версии — прежний класс дефекта
  awk -v o="$ORPH" '/^\*\*Версия:/{print; print o; next} {print}' "$R/docs/00_STATE.md" > "$R/s.tmp" && mv "$R/s.tmp" "$R/docs/00_STATE.md"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case fail "хвост шапки рядом со строкой Версия валит коммит (ADR-137 §4)" ""

  new_repo
  { printf '%s\n' '### Подробности для модели'
    i=1; while [ $i -le 151 ]; do printf '| 2026-01-01 | s_%d | предмет | журнал решений |\n' "$i"; i=$((i+1)); done
  } >> "$R/docs/00_STATE.md"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case fail "§Подробности длиннее лимита индекса валит коммит (ADR-137 §2)" ""

  new_repo
  { printf '%s\n' '## Открытые вопросы'
    i=1; while [ $i -le 16 ]; do printf -- '- наблюдение номер %d без владельца\n' "$i"; i=$((i+1)); done
  } >> "$R/docs/00_STATE.md"
  sed -i.bak 's/^\*\*Версия:.*$/**Версия:** v2 · **updated:** 2026-01-02/' "$R/docs/00_STATE.md"; rm -f "$R/docs/00_STATE.md.bak"
  run_case fail "§Открытые вопросы длиннее лимита указателей валит коммит (ADR-137 §3)" ""

  PSV=0
  new_repo; printf '%s\n' '#!/usr/bin/env bash' 'echo "VERIFY: RED (stub)"; exit 1' > "$R/tools/verify.sh"
  printf '# FILE: docs/03_NEW_DOC.md\nтекст\n' > "$R/docs/03_NEW_DOC.md"
  run_case fail "verify RED валит коммит" ""

  new_repo; printf 'новая версия\n' > "$R/l3-external/raw/seed2.docx.txt"
  PSV=1 run_case fail "staged-файл в l3-external/raw без санкции" ""

  new_repo; printf 'новая версия\n' > "$R/l3-external/raw/seed2.docx.txt"
  PSV=1 run_case pass "l3-external/raw с ALLOW_RAW_CHANGE=1 (К-12)" "ALLOW_RAW_CHANGE=1"
done

# ── Проверка формы ответа роли (tools/hooks/answer_check.sh; К-39, ADR-118) ───────
# Признак правила-останова проверяется НЕГАТИВНЫМ прогоном (К-34): кейсы `fail` — по
# ветке останова. Кейсы `pass` тут не украшение: с ADR-125 они несут вторую половину
# признака — законный ответ, который проверка ОБЯЗАНА пропустить. До ADR-125 самотест
# закреплял эталоном обратное, и три законных ответа были возвращены в поле за сутки.
# Гоняются в обеих локалях по тому же мотиву, что и кейсы выше (К-35).
AC="$(cd "$(dirname "$0")" && pwd)/answer_check.sh"
[ -f "$AC" ] || { echo "selftest: не найден $AC"; exit 1; }

ac_case() {  # $1 ожидание pass|fail · $2 имя · stdin — текст ответа
  local expect="$1" name="$2" f rc out
  f=$(mktemp); cat > "$f"
  out=$(LC_ALL="$LOC" LANG="$LOC" bash "$AC" --text "$f" 2>&1); rc=$?
  rm -f "$f"
  if { [ "$expect" = pass ] && [ $rc -eq 0 ]; } || { [ "$expect" = fail ] && [ $rc -eq 2 ]; }; then
    PASSED=$((PASSED+1))
  else
    FAILED=$((FAILED+1))
    echo "ПРОВАЛ [$LOC] форма ответа: $name (ожидалось $expect, rc=$rc)"; printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

ac_warn() {  # $1 ожидаемый код предупреждения · $2 имя · stdin — текст ответа
  # Предупредительный слой (ADR-125 §2): ответ проходит (rc=0), но вердикт напечатан.
  # Проверяются оба свойства сразу: пропуск без вердикта — тихий отказ проверки, а
  # вердикт с возвратом — ровно тот дефект, который эта запись и закрывает.
  local code="$1" name="$2" f rc out
  f=$(mktemp); cat > "$f"
  out=$(LC_ALL="$LOC" LANG="$LOC" bash "$AC" --text "$f" 2>&1); rc=$?
  rm -f "$f"
  if [ $rc -eq 0 ] && printf '%s' "$out" | grep -q "$code"; then
    PASSED=$((PASSED+1))
  else
    FAILED=$((FAILED+1))
    echo "ПРОВАЛ [$LOC] форма ответа: $name (ожидалось rc=0 плюс вердикт $code, rc=$rc)"
    printf '%s\n' "$out" | sed 's/^/    /'
  fi
}

for LOC in C "$MB_LOCALE"; do
  ac_case pass "шапка на месте, абзацы короткие, перечень не считается абзацем" <<'EOF'
**Сделано:** проверка формы собрана и прогнана.
**Нужно от Owner:** апрув записи решения.
**Рекомендация:** армировать проверку сейчас.

Правило держалось на памяти роли, потому что носителя проверки у него не было.

- форма проверяется машинно
- нарушение возвращает ответ роли
- повторный заход пропускается
EOF

  ac_case fail "шапки нет — ответ начинается прозой" <<'EOF'
Разобрался с задачей, ниже подробности по шагам.

Сначала прочитал конвенции, потом поднял запись решения, потом сверил промты.
EOF

  ac_case fail "порядок строк шапки нарушен" <<'EOF'
Сделано: нечто.
Рекомендация: вариант Б.
Нужно от Owner: решение по развилке.
EOF

  ac_case fail "абзац длиннее трёх строк" <<'EOF'
Сделано: нечто.
Нужно от Owner: ничего.
Рекомендация: вариант Б.

Первая строка длинного абзаца, за ней идёт вторая строка,
затем третья строка того же абзаца без разрыва,
и четвёртая строка, из-за которой читателю приходится
собирать вывод самому вместо готового результата.
EOF

  ac_case fail "рекомендация отослана вниз вместо содержания" <<'EOF'
Сделано: нечто.
Нужно от Owner: решение по развилке.
Рекомендация: см. ниже
EOF

  ac_case fail "машинная часть напечатана в чат" <<'EOF'
Сделано: нечто.
Нужно от Owner: ничего.
Рекомендация: вариант Б.

=== SESSION LOG · 2026-01-01 · arch_test ===
## STATE_PATCH
- Фаза: open
EOF

  # Готовится файлом, а не пайпом: пайп уводит ac_case в подоболочку, счётчики
  # PASSED/FAILED теряются, и кейс исчезает из итога молча.
  LONGF=$(mktemp)
  {
    printf '%s\n' 'Сделано: нечто.' 'Нужно от Owner: ничего.' 'Рекомендация: вариант Б.' ''
    i=1; while [ $i -le 26 ]; do printf -- '- пункт номер %d\n' "$i"; i=$((i+1)); done
  } > "$LONGF"
  ac_case fail "текст к Owner длиннее 25 строк" < "$LONGF"

  # Развилка расширяет лимит на 12 строк (ADR-123 §3): 36 строк при одной развилке проходят,
  # те же 36 без развилки падают предыдущим кейсом.
  {
    printf '%s\n' 'Сделано: развилка подготовлена.' 'Нужно от Owner: выбрать вариант.' 'Рекомендация: вариант Б.' ''
    i=1; while [ $i -le 30 ]; do printf -- '- строка отчёта %d\n' "$i"; i=$((i+1)); done
    printf '\n%s\n' '**Развилка Р-1. Чем исполнять задачу.**'
    i=1; while [ $i -le 5 ]; do printf -- '- вариант %d с последствием\n' "$i"; i=$((i+1)); done
  } > "$LONGF"
  ac_case pass "развилка расширяет лимит" < "$LONGF"

  {
    printf '%s\n' 'Сделано: три развилки.' 'Нужно от Owner: выбрать.' 'Рекомендация: вариант Б.' ''
    printf '%s\n' '**Развилка Р-1. Первая.**' '**Развилка Р-2. Вторая.**' '**Развилка Р-3. Третья.**'
  } > "$LONGF"
  ac_case fail "развилок больше двух в одном ответе" < "$LONGF"
  rm -f "$LONGF"

  ac_case fail "вывод спрятан в последнюю строку (К-42 §1)" <<'EOF'
Сделано: разбор выполнен.
Нужно от Owner: решение по развилке.
Рекомендация: вариант Б.

Первое обстоятельство таково.

Второе обстоятельство таково.

Поэтому рекомендация — вариант Б.
EOF

  ac_case fail "журнал собственных действий вместо результата (К-42 §3)" <<'EOF'
Сделано: работа выполнена.
Нужно от Owner: нет.
Рекомендация: нет.

Сначала прочитал конвенции и поднял записи решений.

Затем сверил промты пяти ролей с действующей конвенцией.

Потом прогнал самотест и убедился, что он зелёный.
EOF

  ac_warn 'УПАКОВКА-3' "плотные числа предупреждают, но ответ не возвращают (ADR-125 §1)" <<'EOF'
Сделано: приёмка прогнана.
Нужно от Owner: нет.
Рекомендация: нет.

- шагов 36/36, разделов 36 и 14, запрещённых префиксов 0/0, проверок 4/5, дат 0/0
EOF

  ac_warn 'УПАКОВКА-4' "плотность кодов предупреждает, но ответ не возвращает (ADR-125 §1)" <<'EOF'
Сделано: записи сверены.
Нужно от Owner: нет.
Рекомендация: нет.

Гейт ADR-024 пройден, ADR-083 прецедент прямой, ADR-033 не переоткрывается, К-15 не мешает.
EOF

  # Три законных ответа, возвращённых проверкой в поле 2026-08-11 (заход reviewer_method_gate,
  # находка №1). Каждый обязан ПРОХОДИТЬ: содержание требуют принятые К-36, К-40 и К-28.
  ac_case pass "отчёт К-36 с перечнем адресов проходит" <<'EOF'
Сделано: предмет предъявлен.
Нужно от Owner: нет.
Рекомендация: нет.

Предъявлены адреса: docs/02_ADR_LOG.md:2877-2916, docs/02_ADR_LOG.md:3650-3735, …
EOF

  ac_case pass "вердикт с четырьмя номерами записей в одной строке проходит" <<'EOF'
Сделано: вердикт по пяти записям вынесен.
Нужно от Owner: апрув пачкой.
Рекомендация: переводить четыре записи, пятую держать.

ADR-074, ADR-085, ADR-122 и ADR-123 можно переводить в accepted, ADR-124 тоже.
EOF

  ac_case pass "строка приёмки Owner с числами проходит (К-42 §4 её прямо разрешает)" <<'EOF'
Сделано: приёмка предъявлена числами.
Нужно от Owner: нет.
Рекомендация: нет.

подвопросов CQ-35 в шаге OF-01 — 5 из 5, строк раздела 7 без адреса — 0; самотест 73/0
EOF
done

# Второй проход по одному ответу (ADR-125 §3). Ветка останова здесь двойная: проверка обязана
# НЕ вернуть ответ вторым разом (иначе пара «хук ↔ модель» уходит в цикл) и обязана записать
# исход в замер (иначе цифра возвратов есть, а их результата нет — та же слепота, что до записи).
# Прогон идёт в фикстурном каталоге: писать в реальный `.claude/answer_check.log` самотест не должен.
RT=$(mktemp -d); mkdir -p "$RT/.claude"
printf '%s\n' \
  '{"type":"assistant","message":{"content":[{"type":"text","text":"Разобрался с задачей, ниже подробности по шагам."}]}}' \
  > "$RT/transcript.jsonl"
RT_OUT=$(cd "$RT" && printf '{"stop_hook_active":true,"transcript_path":"%s/transcript.jsonl"}' "$RT" \
         | bash "$AC" 2>&1); RT_RC=$?
if [ "$RT_RC" -eq 0 ] && grep -q 'ПОВТОР-ВОЗВРАТ' "$RT/.claude/answer_check.log" 2>/dev/null; then
  PASSED=$((PASSED+1))
else
  FAILED=$((FAILED+1))
  echo "ПРОВАЛ форма ответа: второй проход (ожидалось rc=0 плюс строка ПОВТОР-ВОЗВРАТ в замере, rc=$RT_RC)"
  printf '%s\n' "$RT_OUT" | sed 's/^/    /'
  [ -f "$RT/.claude/answer_check.log" ] && sed 's/^/    лог: /' "$RT/.claude/answer_check.log"
fi
rm -rf "$RT"

# Замер (ADR-123 §4) не должен наполняться самотестом: прогоны --text в лог не пишутся.
AC_LOG_BEFORE=$( [ -f .claude/answer_check.log ] && wc -l < .claude/answer_check.log | tr -d ' ' || echo 0 )
LOCTMP=$(mktemp); printf '%s\n' 'мусор без шапки' > "$LOCTMP"
LC_ALL=C bash "$AC" --text "$LOCTMP" >/dev/null 2>&1
rm -f "$LOCTMP"
AC_LOG_AFTER=$( [ -f .claude/answer_check.log ] && wc -l < .claude/answer_check.log | tr -d ' ' || echo 0 )
if [ "$AC_LOG_BEFORE" = "$AC_LOG_AFTER" ]; then
  PASSED=$((PASSED+1))
else
  FAILED=$((FAILED+1))
  echo "ПРОВАЛ форма ответа: прогон --text попал в замер ($AC_LOG_BEFORE → $AC_LOG_AFTER строк)"
fi

echo
echo "selftest: пройдено $PASSED, провалено $FAILED (локали: C, $MB_LOCALE)"
[ "$FAILED" -eq 0 ] || exit 1
