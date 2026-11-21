#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

REAL_FILE="lean/MCore/RH/R0/HardFrontierReal.lean"
REAL_MODULE="MCore.RH.R0.HardFrontierReal"
REAL_DECL="MCore.RH.R0.explicitGramRateTarget_real"

echo "[RH-MATERIAL] checking structural frontier exposure"
lake build MCore.RH.R0.FrontierExposure
lake env lean lean/MCore/RH/R0/FrontierExposure.lean

if [[ ! -f "$REAL_FILE" ]]; then
  echo "[RH-MATERIAL] MATERIAL_OPEN_GAPS=1"
  echo "[RH-MATERIAL] GAP_ID=ExplicitGramRateTarget"
  echo "[RH-MATERIAL] REQUIRED_FILE=$REAL_FILE"
  echo "[RH-MATERIAL] REQUIRED_DECL=$REAL_DECL"
  echo "[RH-MATERIAL] STATUS=OPEN_MATH"
  echo "[RH-MATERIAL] TERMINAL_PROMOTION=FORBIDDEN_WITHOUT_MATERIAL_INHABITANT"
  exit 2
fi

if grep -nE '(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)|^[[:space:]]*axiom[[:space:]]' "$REAL_FILE"; then
  echo "[RH-MATERIAL] UNSAFE_PLACEHOLDER=FOUND"
  echo "[RH-MATERIAL] STATUS=RED"
  exit 3
fi

lake build "$REAL_MODULE" MCore.RH.R0.RHKernelEntry

TMP="$(mktemp --suffix=.lean)"
LOG="${TMP}.log"
trap 'rm -f "$TMP" "$LOG"' EXIT
cat > "$TMP" <<'LEAN'
import MCore.RH.R0.HardFrontierReal
import MCore.RH.R0.RHKernelEntry

#check MCore.RH.R0.explicitGramRateTarget_real
#print axioms MCore.RH.R0.explicitGramRateTarget_real

example : MCore.RH.R0.ExplicitGramRateTarget :=
  MCore.RH.R0.explicitGramRateTarget_real

example : MCore.RH.R0.ConcreteUniformLogDNBound :=
  MCore.RH.R0.explicitGramRateTarget_iff_uniformLogDNBound.mp
    MCore.RH.R0.explicitGramRateTarget_real
theorem r01_density_certificate : MCore.RH.R0.RiemannTerminalCertifies :=
  MCore.RH.R0.rh_kernel_entry_HardFrontier
    (MCore.RH.R0.explicitGramRateTarget_iff_uniformLogDNBound.mp
      MCore.RH.R0.explicitGramRateTarget_real)

#print axioms r01_density_certificate
LEAN

lake env lean -DwarningAsError=true "$TMP" 2>&1 | tee "$LOG"

python3 - "$LOG" "$REAL_DECL" r01_density_certificate <<'PYTHON'
import pathlib
import re
import sys

output = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
allowed = {"propext", "Classical.choice", "Quot.sound"}

for declaration in sys.argv[2:]:
    reports = re.findall(
        rf"^'{re.escape(declaration)}' (does not depend on any axioms|depends on axioms: \[([^\]]*)\])\s*$",
        output,
        re.MULTILINE,
    )
    if len(reports) != 1:
        sys.exit(f"[RH-MATERIAL] RED: expected one axiom report for {declaration}")
    used = {name.strip() for name in reports[0][1].split(",") if name.strip()}
    unexpected = used - allowed
    if unexpected:
        sys.exit(f"[RH-MATERIAL] RED: {declaration} uses {', '.join(sorted(unexpected))}")
PYTHON

echo "[RH-MATERIAL] MATERIAL_OPEN_GAPS=0"
echo "[RH-MATERIAL] GAP_ID=ExplicitGramRateTarget"
echo "[RH-MATERIAL] REQUIRED_DECL=$REAL_DECL"
echo "[RH-MATERIAL] CERTIFIED_SCOPE=DNLimit_eq_zero"
echo "[RH-MATERIAL] STATUS=GREEN_DENSITY_CANDIDATE"
echo "[RH-MATERIAL] CLASSICAL_RH_ENDPOINT=REQUIRES_SEPARATE_KERNEL_AUDIT"
