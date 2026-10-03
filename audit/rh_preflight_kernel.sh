#!/usr/bin/env bash
set -euo pipefail

echo "[RH] PREKERNEL"

files=(
  lean/MCore/RH/R0/ConcreteVanishingProducer.lean
  lean/MCore/RH/R0/ConcreteLogMajorantProducer.lean
  lean/MCore/RH/R0/HardFrontier.lean
  lean/MCore/RH/R0/ConcreteInhabitantKernelAudit.lean
  lean/MCore/RH/R0/RHKernelEntry.lean
  audit/RHKernelAxiomAudit.lean
)

for f in "${files[@]}"; do
  test -f "$f" || { echo "[RH] RED missing: $f"; exit 1; }
done

# Reject project-level escapes in the new kernel surface.
if grep -nE '^[[:space:]]*(axiom|constant|constants)[[:space:]]|(^|[^[:alnum:]_])(sorry|admit)([^[:alnum:]_]|$)' "${files[@]}"; then
  echo "[RH] RED: proof escape detected"
  exit 1
fi

echo "[RH] SOURCE_HYGIENE=PASS"

lake env lean lean/MCore/RH/R0/ConcreteVanishingProducer.lean
lake env lean lean/MCore/RH/R0/ConcreteLogMajorantProducer.lean
lake env lean lean/MCore/RH/R0/HardFrontier.lean
lake env lean lean/MCore/RH/R0/ConcreteInhabitantKernelAudit.lean
lake env lean lean/MCore/RH/R0/RHKernelEntry.lean
lake env lean audit/RHKernelAxiomAudit.lean

echo "[RH] MODULE_KERNEL=PASS"

lake build MCore

echo "[RH] MCORE_BUILD=PASS"
echo "[RH] STATUS=GREEN_PREFIX_READY"
echo "[RH] OPEN_MATH=Nonempty ConcreteVanishingUpperBound"
