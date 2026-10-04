#!/usr/bin/env bash
set -euo pipefail

STRICT=0
if [[ "${1:-}" == "--strict" ]]; then
  STRICT=1
elif [[ $# -gt 0 ]]; then
  echo "[RH] RED unknown argument: $1"
  exit 2
fi

echo "[RH] PREKERNEL"
echo "[RH] STRICT=$STRICT"

files=(
  lean/MCore/RH/NB/LogMajorantTendsto.lean
  lean/MCore/RH/Analytic/MellinConcrete.lean
  lean/MCore/RH/R0/ConcreteZeroObstruction.lean
  lean/MCore/RH/R0/ConcreteGramLogRate.lean
  lean/MCore/RH/R0/HardFrontierReduction.lean
  lean/MCore/RH/R0/FrontierExposure.lean
  lean/MCore/RH/R0/GramExplicit.lean
  lean/MCore/RH/R0/LinearIndependentReduction.lean
  lean/MCore/RH/R0/ExponentialUniqueness.lean
  lean/MCore/RH/R0/GramInverse.lean
  lean/MCore/RH/Analytic/MellinTarget.lean
  lean/MCore/RH/Analytic/MellinRhoReduction.lean
  lean/MCore/RH/Analytic/MellinTailPartial.lean
  lean/MCore/RH/Analytic/MellinTailRight.lean
  lean/MCore/RH/Analytic/MellinTailContinuation.lean
  lean/MCore/RH/Analytic/D1KernelEntry.lean
  lean/MCore/RH/Analytic/MellinResidualAlgebra.lean
  lean/MCore/RH/Analytic/MellinPlancherelReduction.lean
  lean/MCore/RH/Analytic/D3SingleGap.lean
  lean/MCore/RH/Analytic/MellinPlancherelEasyLaws.lean
  lean/MCore/RH/Analytic/MellinPlancherelDecomposition.lean
  lean/MCore/RH/Analytic/MellinCriticalDensity.lean
  lean/MCore/RH/Analytic/CriticalLineBasic.lean
  lean/MCore/RH/Analytic/MellinTargetConvergence.lean
  lean/MCore/RH/Analytic/MellinRhoConvergence.lean
  lean/MCore/RH/Analytic/MellinRhoClosedForm.lean
  lean/MCore/RH/Analytic/MellinTailContinuationReduction.lean
  lean/MCore/RH/Analytic/RegularizedZeta.lean
  lean/MCore/RH/Analytic/MellinTailSeriesLimit.lean
  lean/MCore/RH/Analytic/MellinTailRightReduction.lean
  lean/MCore/RH/Analytic/MellinTailBlocks.lean
  lean/MCore/RH/Analytic/MellinNearZero.lean
  lean/MCore/RH/R0/GramAutocorrelation.lean
  lean/MCore/RH/R0/TargetClosedForm.lean
  lean/MCore/RH/R0/FractionalTailEuler.lean
  lean/MCore/RH/R0/FractionalTailBlocks.lean
  lean/MCore/RH/R0/TargetClosedFormReduction.lean
  lean/MCore/RH/R0/GramIntegral.lean
  lean/MCore/RH/R0/LinearIndependent.lean
  lean/MCore/RH/R0/BaseMellinPositive.lean
  lean/MCore/RH/R0/WeightedScaling.lean
  lean/MCore/RH/R0/WeightedIntegralLinearity.lean
  lean/MCore/RH/R0/WeightedIntegrability.lean
  lean/MCore/RH/R0/LpToAE.lean
  lean/MCore/RH/R0/RhoBasicFacts.lean
  lean/MCore/RH/NB/OrthogonalWitnessObstruction.lean
  lean/MCore/RH/R0/ConcreteVanishingProducer.lean
  lean/MCore/RH/R0/ConcreteLogMajorantProducer.lean
  lean/MCore/RH/R0/HardFrontier.lean
  lean/MCore/RH/R0/FinalKernelComposition.lean
  lean/MCore/RH/R0/ConcreteInhabitantKernelAudit.lean
  lean/MCore/RH/R0/RHKernelEntry.lean
  audit/RHKernelAxiomAudit.lean
)

for f in "${files[@]}"; do
  test -f "$f" || { echo "[RH] RED missing: $f"; exit 1; }
done

if grep -nE '^[[:space:]]*(axiom|constant|constants)[[:space:]]|(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)' "${files[@]}"; then
  echo "[RH] RED: proof escape detected"
  exit 1
fi

echo "[RH] SOURCE_HYGIENE=PASS"

lake env lean lean/MCore/RH/NB/LogMajorantTendsto.lean
lake env lean lean/MCore/RH/Analytic/MellinConcrete.lean
lake env lean lean/MCore/RH/R0/ConcreteZeroObstruction.lean
lake env lean lean/MCore/RH/R0/ConcreteGramLogRate.lean
lake env lean lean/MCore/RH/R0/HardFrontierReduction.lean
lake env lean lean/MCore/RH/R0/FrontierExposure.lean
lake env lean lean/MCore/RH/R0/GramExplicit.lean
lake env lean lean/MCore/RH/R0/LinearIndependentReduction.lean
lake env lean lean/MCore/RH/Analytic/MellinTailContinuation.lean
lake env lean lean/MCore/RH/Analytic/D1KernelEntry.lean
lake env lean lean/MCore/RH/Analytic/MellinResidualAlgebra.lean
lake env lean lean/MCore/RH/Analytic/MellinPlancherelReduction.lean
lake env lean lean/MCore/RH/Analytic/D3SingleGap.lean
lake env lean lean/MCore/RH/Analytic/MellinPlancherelEasyLaws.lean
lake env lean lean/MCore/RH/Analytic/MellinPlancherelDecomposition.lean
lake env lean lean/MCore/RH/Analytic/MellinCriticalDensity.lean
lake env lean lean/MCore/RH/Analytic/CriticalLineBasic.lean
lake env lean lean/MCore/RH/Analytic/MellinTargetConvergence.lean
lake env lean lean/MCore/RH/Analytic/MellinRhoConvergence.lean
lake env lean lean/MCore/RH/Analytic/MellinRhoClosedForm.lean
lake env lean lean/MCore/RH/Analytic/MellinTailContinuationReduction.lean
lake env lean lean/MCore/RH/Analytic/RegularizedZeta.lean
lake env lean lean/MCore/RH/NB/OrthogonalWitnessObstruction.lean
lake env lean lean/MCore/RH/R0/ConcreteVanishingProducer.lean
lake env lean lean/MCore/RH/R0/ConcreteLogMajorantProducer.lean
lake env lean lean/MCore/RH/R0/HardFrontier.lean
lake env lean lean/MCore/RH/R0/FinalKernelComposition.lean
lake env lean lean/MCore/RH/R0/ConcreteInhabitantKernelAudit.lean
lake env lean lean/MCore/RH/R0/RHKernelEntry.lean
lake env lean audit/RHKernelAxiomAudit.lean

echo "[RH] MODULE_KERNEL=PASS"

lake build MCore

echo "[RH] MCORE_BUILD=PASS"
echo "[RH] STRUCTURAL_OPEN_GAPS=0"
echo "[RH] MATERIAL_OPEN_GAPS=1"
echo "[RH] KERNEL_STRUCTURE=CLOSED_TO_SINGLE_PRODUCER"
echo "[RH] RHMaterialProducer=ConcreteUniformLogDNBound"
echo "[RH] BUILD_PREFIX=GREEN"
echo "[RH] TERMINAL_PROMOTION=FORBIDDEN_WITHOUT_MATERIAL_INHABITANT"
echo "[RH] OPEN_MATH=RHMaterialProducer"

if [[ "$STRICT" -eq 1 ]]; then
  test -f audit/RH_FINAL_MATERIAL_LEDGER.json || {
    echo "[RH] RED missing material ledger"
    exit 1
  }
  grep -q '"structural_gaps": 0' audit/RH_FINAL_MATERIAL_LEDGER.json
  grep -q '"material_gaps": 1' audit/RH_FINAL_MATERIAL_LEDGER.json
  grep -q '"material_producer": "MCore.RH.R0.RHMaterialProducer"' audit/RH_FINAL_MATERIAL_LEDGER.json
  grep -q '"definitional_target": "MCore.RH.R0.ConcreteUniformLogDNBound"' audit/RH_FINAL_MATERIAL_LEDGER.json
  echo "[RH] STRICT_LEDGER=PASS"
fi

echo "[RH] STATUS=GREEN_PREFIX_OPEN_MATH"

echo "[RH] MATERIAL_GATE_COMMAND=bash audit/rh_material_gate.sh"
