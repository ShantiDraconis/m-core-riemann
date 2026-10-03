#!/usr/bin/env bash
set -euo pipefail

echo "[RH] producer-first kernel audit"

# 1. Fail closed on project-level proof escapes in the new terminal files.
if grep -nE '^[[:space:]]*(axiom|constant|constants)[[:space:]]|\bsorry\b|\badmit\b' \
  lean/MCore/RH/R0/ConcreteVanishingProducer.lean \
  lean/MCore/RH/R0/ConcreteInhabitantKernelAudit.lean; then
  echo "[RH] RED: proof escape detected"
  exit 1
fi

# 2. Compile the already-certified producer/consumer chain plus the concrete specialization.
lake env lean lean/MCore/RH/NB/ZeroLimitFrontier.lean
lake env lean lean/MCore/RH/NB/QuantitativeUpperBound.lean
lake env lean lean/MCore/RH/NB/ExactFinalProducer.lean
lake env lean lean/MCore/RH/R0/ConcreteFinalProducer.lean
lake env lean lean/MCore/RH/R0/ConcreteGramClosure.lean
lake env lean lean/MCore/RH/R0/TerminalLaw.lean
lake env lean lean/MCore/RH/R0/ConcreteVanishingProducer.lean
lake env lean lean/MCore/RH/R0/ConcreteInhabitantKernelAudit.lean

# 3. Compile the aggregate library entry point.
lake build MCore

echo "[RH] GREEN_PREFIX_READY: all downstream kernel maps compile."
echo "[RH] OPEN_MATH remains exactly: construct ConcreteVanishingUpperBound."
