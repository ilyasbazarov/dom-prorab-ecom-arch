#!/usr/bin/env bash
# BRIEF F4-05 — конвертация l3-external/raw/AlatauCityBank_ecom.pdf в постраничный md
# с маркерами <!-- PAGE N -->. Значения литеральные (К-6).
set -euo pipefail

PDF="l3-external/raw/AlatauCityBank_ecom.pdf"
OUT="l3-external/md/d7_t01_acquiring_api.md"
PAGES=27

: > "$OUT"
for N in $(seq 1 "$PAGES"); do
  echo "<!-- PAGE $N -->" >> "$OUT"
  pdftotext -layout -f "$N" -l "$N" "$PDF" - >> "$OUT"
done
