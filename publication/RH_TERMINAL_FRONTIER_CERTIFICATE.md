# RH Terminal Frontier Certificate

Status date: 2026-10-06

This package freezes the forward-only RH rejection-zero lane and does not
reopen any earlier parameter.

## Kernel surfaces

- `MCore.RH.P02DeterministicRejectionZero`
- `MCore.RH.P02TerminalFrontier`
- `MCore.RH.P02FinalRoot`
- `MCore.RH.P02GlobalExternal`

## Unique remaining mathematical obligation

```lean
CriticalOrbitCollapse :=
  ∀ s : ℂ, ProbeNontrivialZetaZero s → criticalReflect s = s
```

The dedicated last-bit workflow run `37497319330` completed SUCCESS and
verified both:
1. the last-bit target builds;
2. the last-bit file contains exactly one explicit open-math proof hole.

## Certification meaning

FINAL_ROOT, GLOBAL, and EXTERNAL are placeholder-free conditional endpoints.
They prove that the unique terminal frontier implies the critical-line endpoint.

This is therefore a certified reduction to one terminal RH-strength obligation,
not a kernel-checked proof of the Riemann Hypothesis.

OPEN_MATH can be marked 0 only after `CriticalOrbitCollapse` is itself proved
without `sorry`, `admit`, or an equivalent unproved axiom.

## Forward-only invariant

No earlier phase may be reopened unless a concrete kernel regression appears.
Renaming or truncating the terminal hole does not constitute a proof.
