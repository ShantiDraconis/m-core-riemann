#!/usr/bin/env bash
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

FILE="open_math/lean/RHAllGaps.lean"
LOG="${TMPDIR:-/tmp}/rh-all-gaps.log"

rm -f /tmp/rh_gap_*.txt 2>/dev/null || true

echo "[RH-ALL-GAPS] compiling intentional discovery tree"
echo "[RH-ALL-GAPS] file=$FILE"

set +e
lake env lean "$FILE" 2>&1 | tee "$LOG"
code=${PIPESTATUS[0]}
set -e

echo "[RH-ALL-GAPS] LEAN_EXIT=$code"

found=0
for f in /tmp/rh_gap_*.txt; do
  [[ -e "$f" ]] || continue
  found=1
  echo
  echo "===== $(basename "$f") ====="
  cat "$f"
done

if [[ $found -eq 0 ]]; then
  echo "[RH-ALL-GAPS] WARNING=NO_STRUCTURED_GAPS_DUMPED"
fi

if [[ $code -eq 0 ]]; then
  echo "[RH-ALL-GAPS] STATUS=UNEXPECTED_GREEN"
  echo "[RH-ALL-GAPS] NEXT=bash audit/rh_material_gate.sh"
  exit 0
fi

echo "[RH-ALL-GAPS] STATUS=EXPECTED_OPEN_MATH_FAILURE"
echo "[RH-ALL-GAPS] STRUCTURAL_KERNEL_UNTOUCHED=true"
echo "[RH-ALL-GAPS] MATERIAL_OPEN_GAPS=1"
echo "[RH-ALL-GAPS] TERMINAL_PROMOTION=FORBIDDEN"
exit 2
