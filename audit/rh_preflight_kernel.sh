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
