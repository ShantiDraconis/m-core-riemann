#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

OUT="/tmp/rh_d3_pinned_gap.log"
GAP="/tmp/rh_d3_gap_PINNED_FOURIER_PLANCHEREL.txt"
rm -f "$OUT" "$GAP"

set +e
lake env lean open_math/lean/RHD3PinnedPlancherel.lean >"$OUT" 2>&1
STATUS=$?
set -e

if [[ -f "$GAP" ]]; then
  echo "PINNED_LIBRARY_GAPS=1"
  echo "GAP_ID=PinnedFourierPlancherelGap"
  echo "GAP_FILE=$GAP"
  echo "MATERIAL_OPEN_GAPS_UNCHANGED=1"
  echo "TERMINAL_PROMOTION=FORBIDDEN_UNTIL_LIBRARY_BRIDGE_EXISTS"
  exit 2
fi

if [[ $STATUS -ne 0 ]]; then
  cat "$OUT"
  echo "STATUS=UNEXPECTED_RED"
  exit "$STATUS"
fi

echo "PINNED_LIBRARY_GAPS=0"
echo "STATUS=SOURCE_CLOSED"
