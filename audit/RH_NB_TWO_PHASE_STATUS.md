# RH / Nyman--Beurling two-phase audit

Branch: `research/nb-two-phase-tests`

## Scientific firewall

This branch does **not** claim RH.  It separates:

1. the Hilbert/Nyman--Beurling layer, which must compile before any item is promoted to `PROVED_LEAN`; and
2. the M-Core/NB compatibility layer, where the functional bridge remains open.

## Verified interface fact

The current `MCoreSystem` in `lean/MCore/A14_Formal.lean` is scalar:

- `baseVal : ℝ`
- `amplitude : ℝ → ℝ`
- `scale : ℝ → ℝ`
- `zeroLimit : ZeroDirection → ℝ`
- graph/evidence fields.

There is currently no `State`, no action `ℝ → State → State`, and no map into an NB Hilbert space.  Any formalization assuming those fields is incompatible with the current source interface.

## Decisive A1--A4 test

`MCore.RH.NB.A14NonImplication` constructs one concrete `MCoreSystem` satisfying the exact current A1--A4 signature and attaches two opposite NB observations to the same scalar system.  It proves:

- `same_A14_opposite_NB_observations`
- `A14_alone_not_sufficient_for_covering`
- `A14_alone_not_sufficient_for_testDefect`

Interpretation: the current scalar A1--A4 interface does not determine NB functional decay.  This is an **interface non-implication**, not a refutation of RH and not a refutation of a future strengthened M-Core.  A compatibility law between the scalar M-Core and the NB functional model is necessary before a theorem about `coveringError` or `testDefect` can be derived.

## Status

| Gate | Status |
|---|---|
| current A1--A4 interface located | SOURCE_VERIFIED |
| A1--A4 witness | AWAITING_CI |
| opposite NB observations | AWAITING_CI |
| A1--A4 alone -> covering decay | REFUTED_INTERFACE_IMPLICATION after CI |
| A1--A4 alone -> test-defect decay | REFUTED_INTERFACE_IMPLICATION after CI |
| concrete NB Hilbert model | OPEN / NOT YET CERTIFIED |
| concrete M-Core/NB compatibility law | OPEN_BRIDGE |
| coveringError -> 0 under strengthened model | OPEN_BRIDGE |
| testDefect -> 0 under strengthened model | OPEN_BRIDGE |
| RH_PROVED | FALSE |

## Required next layer

Do not add an arbitrary `encode/decode` and call the bridge proved.  Introduce a concrete compatibility structure only when it has mathematical content, for example a map from a functional M-Core realization to `H_NB` together with explicit intertwining/coercivity laws.  Then test whether those laws imply the two decay limits without importing an RH-equivalent statement.

## CI promotion rule

No `AWAITING_CI` entry becomes `PROVED_LEAN` until the exact commit has:

- successful Lean build on the pinned toolchain;
- no `sorry` / `admit` / custom scientific `axiom`;
- `#print axioms` audit for the named theorems;
- dependency audit showing no RH-equivalent premise was used to prove an upstream bridge.
