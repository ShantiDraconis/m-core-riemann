#!/usr/bin/env bash
set -euo pipefail

run_lean() {
  local f="$1"
  echo "=== KERNEL: $f ==="
  lake env lean "$f"
}

echo "RH FULL FORWARD-ONLY KERNEL MATRIX"
echo "No GREEN/FROZEN/CERTIFIED promotion is performed by this script."

# K0 — pinned-Mathlib foundation
run_lean lean/MCore/RH/Analytic/MellinTarget.lean
run_lean lean/MCore/RH/R0/WeightedIntegrability.lean
run_lean lean/MCore/RH/Analytic/MellinStripConvergence.lean
run_lean lean/MCore/RH/Analytic/MellinRhoReduction.lean

# K1 — D1 exact Mellin generator law
run_lean lean/MCore/RH/Analytic/MellinRhoClosedForm.lean
run_lean lean/MCore/RH/Analytic/D1KernelEntry.lean

# K2 — finite Gram / source algebra
run_lean lean/MCore/RH/R0/LinearIndependent.lean
run_lean lean/MCore/RH/R0/GramInverse.lean
run_lean lean/MCore/RH/R0/TargetClosedForm.lean
run_lean lean/MCore/RH/R0/GramAutocorrelation.lean

# K3 — residual Mellin algebra
run_lean lean/MCore/RH/Analytic/ResidualMellin.lean
run_lean lean/MCore/RH/Analytic/ResidualMellinAlgebra.lean

# K4 — physical/log-coordinate norm bridges
run_lean lean/MCore/RH/Analytic/ResidualNormBridge.lean
run_lean lean/MCore/RH/Analytic/LogPullbackIsometry.lean
run_lean lean/MCore/RH/Analytic/D3LogLiftIsometry.lean

# K5 — exact Fourier representative frontier
run_lean lean/MCore/RH/Analytic/FourierCompatibilityReduction.lean
run_lean lean/MCore/RH/Analytic/LogResidualMembership.lean
run_lean lean/MCore/RH/Analytic/FourierCompatibility.lean
run_lean lean/MCore/RH/Analytic/FourierAeBridgeReduction.lean
run_lean lean/MCore/RH/Analytic/FourierL1L2AgreementReduction.lean

# K6 — D3 terminal spectral identity
run_lean lean/MCore/RH/Analytic/D3PlancherelReduction.lean
run_lean lean/MCore/RH/Analytic/D3ResidualCompleteReduction.lean
run_lean lean/MCore/RH/Analytic/D3FromFourierPlancherel.lean

# K7 — E1 off-critical witness route
run_lean lean/MCore/RH/Analytic/E1EvaluationReduction.lean

# K8 — finite Vasyunin / Gram reduction
run_lean lean/MCore/RH/R0/ExplicitGramRate.lean
run_lean lean/MCore/RH/R0/VasyuninFormulaReduction.lean
run_lean lean/MCore/RH/R0/VasyuninGCD.lean
run_lean lean/MCore/RH/R0/VasyuninRateReduction.lean

# K9 — exact axiom / hygiene gate
run_lean audit/RHKernelAxiomAudit.lean
bash audit/rh_preflight_kernel.sh --strict

# K10 — root composition
lake build MCore

echo "=== SOURCE HYGIENE ==="
if grep -RInE '(^|[[:space:]])(sorry|admit)([[:space:]]|$)|^[[:space:]]*axiom[[:space:]]' lean/MCore/RH; then
  echo "RH SOURCE HYGIENE: RED"
  exit 1
fi

echo "RH FULL KERNEL MATRIX: GREEN"
