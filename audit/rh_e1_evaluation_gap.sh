#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

OUT="/tmp/rh_e1_evaluation.log"
G1="/tmp/rh_e1_gap_CAUCHY_REPRODUCING.txt"
G2="/tmp/rh_e1_gap_SPECTRAL_TO_PHYSICAL.txt"
rm -f "$OUT" "$G1" "$G2"

set +e
lake env lean open_math/lean/RHE1EvaluationDiscovery.lean >"$OUT" 2>&1
STATUS=$?
set -e

COUNT=0
[[ -f "$G1" ]] && COUNT=$((COUNT+1))
[[ -f "$G2" ]] && COUNT=$((COUNT+1))

if [[ $COUNT -gt 0 ]]; then
  echo "E1_ANALYTIC_BRIDGE_GAPS=$COUNT"
  [[ -f "$G1" ]] && echo "GAP_1=CriticalEvaluationReproducing"
  [[ -f "$G2" ]] && echo "GAP_2=SpectralToPhysicalWitness"
  echo "MATERIAL_RATE_GAP_UNCHANGED=1"
  echo "TERMINAL_PROMOTION=FORBIDDEN"
  exit 2
fi

if [[ $STATUS -ne 0 ]]; then
  cat "$OUT"
  echo "STATUS=UNEXPECTED_RED"
  exit "$STATUS"
fi

echo "E1_ANALYTIC_BRIDGE_GAPS=0"
echo "STATUS=SOURCE_CLOSED"
