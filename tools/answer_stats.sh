#!/usr/bin/env bash
# FILE: tools/answer_stats.sh — замер срабатываний проверки ответа (К-22, ADR-123 §4)
#
# Зачем. До этого замера у проекта не было ни одной цифры о том, насколько ответы тяжелы:
# признак V-01 плана метода описывал положительную ветку и по К-34 признаком не являлся.
# Лог копит по строке на ответ; этот скрипт сворачивает его в «какое правило нарушается чаще».
# Правило чинится по замеру, а не по памяти.
#
# Запуск: bash tools/answer_stats.sh [число последних замечаний судьи, по умолчанию 5]
set -u
LOG=".claude/answer_check.log"
TAIL="${1:-5}"

[ -f "$LOG" ] || { echo "answer_stats: замера ещё нет — $LOG не создан"; exit 0; }

# Строки с меткой ПОВТОР- относятся ко второму проходу по одному и тому же ответу и считаются
# отдельно: по ним видно ИСХОД возврата, а не только его факт (ADR-125 §3).
OK=$(grep -c '	OK	' "$LOG" 2>/dev/null || true);                   OK=${OK:-0}
BACK=$(grep -c '	ВОЗВРАТ	' "$LOG" 2>/dev/null || true);             BACK=${BACK:-0}
WARN=$(grep -c '	ПРЕДУПРЕЖДЕНИЕ	' "$LOG" 2>/dev/null || true);      WARN=${WARN:-0}
R_OK=$(grep -c '	ПОВТОР-OK	' "$LOG" 2>/dev/null || true);           R_OK=${R_OK:-0}
R_WARN=$(grep -c '	ПОВТОР-ПРЕДУПРЕЖДЕНИЕ	' "$LOG" 2>/dev/null || true); R_WARN=${R_WARN:-0}
R_BACK=$(grep -c '	ПОВТОР-ВОЗВРАТ	' "$LOG" 2>/dev/null || true);     R_BACK=${R_BACK:-0}
TOTAL=$((OK + BACK + WARN))
REPEATS=$((R_OK + R_WARN + R_BACK))

echo "Замер по $LOG"
echo
if [ "$TOTAL" -eq 0 ]; then
  echo "ответов с проверкой формы: 0"
else
  echo "ответов с проверкой формы: $TOTAL, из них возвращено на переписывание: $BACK, с предупреждением упаковки: $WARN"
fi

echo
echo "исход возвратов (второй проход по тому же ответу):"
if [ "$REPEATS" -eq 0 ]; then
  echo "  вторых проходов 0"
else
  echo "  переписанных чисто: $R_OK · с предупреждением: $R_WARN · всё ещё с нарушением формы: $R_BACK"
fi

echo
echo "срабатывания по правилам (код — сколько раз):"
if [ $((BACK + WARN + REPEATS)) -eq 0 ]; then
  echo "  срабатываний 0"
else
  grep -e '	ВОЗВРАТ	' -e '	ПРЕДУПРЕЖДЕНИЕ	' "$LOG" | cut -f4 | tr ',' '\n' | sed '/^$/d' | sort | uniq -c | sort -rn | sed 's/^/  /'
fi

echo
echo "судья упаковки (К-42):"
J_OK=$(grep -c '	СУДЬЯ	OK' "$LOG" 2>/dev/null || true);            J_OK=${J_OK:-0}
J_BAD=$(grep -c '	СУДЬЯ-ЗАМЕЧАНИЕ	' "$LOG" 2>/dev/null || true);   J_BAD=${J_BAD:-0}
J_OFF=$(grep -c '	СУДЬЯ-ОТКАЗ	' "$LOG" 2>/dev/null || true);       J_OFF=${J_OFF:-0}
if [ $((J_OK + J_BAD + J_OFF)) -eq 0 ]; then
  echo "  не запускался: включается файлом .claude/answer_judge.on после авторизации CLI"
else
  echo "  разборов без замечаний: $J_OK · с замечанием: $J_BAD · отказов запуска: $J_OFF"
fi

if [ "$J_BAD" -gt 0 ]; then
  echo
  echo "последние замечания судьи (до $TAIL; строки печатаются целиком — К-28):"
  grep '	СУДЬЯ-ЗАМЕЧАНИЕ	' "$LOG" | tail -"$TAIL" | cut -f1,3 | sed 's/^/  /'
fi
