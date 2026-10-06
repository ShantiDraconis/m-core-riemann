# RH Terminal Publication Manifest

Status date: 2026-10-06

## Frozen chain

The rejection-zero structural chain is forward-only. Earlier parameters and routes are not reopened by the terminal publication layer.

## Zero-hole publication wrappers

- `MCore.RH.P02TerminalFrontier`
- `MCore.RH.P02FinalRoot`
- `MCore.RH.P02FinalGlobal`
- `MCore.RH.P02ExternalEndpoint`

These modules introduce no `sorry`, `admit`, `sorryAx`, or new axiom.

## Unique open-math frontier

The only intentionally exposed proof hole is:

`MCore.RH.P02LastOpenMath.criticalOrbitCollapse_material : CriticalOrbitCollapse`

where

`CriticalOrbitCollapse := ∀ s : ℂ, ProbeNontrivialZetaZero s → criticalReflect s = s`.

This is the RH-strength mathematical obligation. The FINAL_ROOT / FINAL_GLOBAL / EXTERNAL theorems are kernel-checkable implications from this terminal proposition; they are not an unconditional proof of the Riemann Hypothesis until the terminal proposition itself has a kernel-checked proof.

## Audit rule

No publication claim may relabel the terminal assumption/hole as a proved theorem. No equivalent formulation, hypothesis wrapper, axiom, or hidden placeholder counts as closure.

The publication gate must:
1. build the terminal wrapper chain;
2. find zero proof holes in the publication wrappers;
3. find exactly one explicit hole in `P02LastOpenMath.lean`.

