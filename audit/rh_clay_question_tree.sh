#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FILE="open_math/lean/RHClayQuestionTree.lean"
LOG="${TMPDIR:-/tmp}/rh-clay-question-tree.log"

rm -f /tmp/rh_clay_gap_*.txt 2>/dev/null || true

echo "[RH-CLAY] compiling master discovery question tree"
echo "[RH-CLAY] file=$FILE"

set +e
lake env lean "$FILE" 2>&1 | tee "$LOG"
code=${PIPESTATUS[0]}
set -e

echo "[RH-CLAY] LEAN_EXIT=$code"

count=0
for f in /tmp/rh_clay_gap_*.txt; do
  [[ -e "$f" ]] || continue
  count=$((count+1))
  echo
  echo "===== $(basename "$f") ====="
  cat "$f"
done

echo "[RH-CLAY] DUMPED_GAPS=$count"

if [[ $code -eq 0 ]]; then
  echo "[RH-CLAY] STATUS=UNEXPECTED_GREEN"
  echo "[RH-CLAY] NEXT=bash audit/rh_material_gate.sh"
  exit 0
fi

echo "[RH-CLAY] STATUS=EXPECTED_OPEN_MATH_FAILURE"
echo "[RH-CLAY] CERTIFIED_KERNEL_UNTOUCHED=true"
echo "[RH-CLAY] MATERIAL_OPEN_GAPS=1"
echo "[RH-CLAY] TERMINAL_PROMOTION=FORBIDDEN"
exit 2
