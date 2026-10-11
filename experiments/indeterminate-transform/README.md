# Experiment: the "I = 0/0" transform applied to the Riemann zeta function

Isolated Lake project (does not touch the rest of `m-core-riemann`). It
depends on Mathlib v4.19.0, pinned to commit
`c44e0c8ee63ca166450922a373c7409c5d26b00b` in `lake-manifest.json`.

| File | Purpose |
|---|---|
| `IndeterminateRiemann/MainProofBridgeVerbatim.lean` | the supplied `SDCore` code, verbatim, compiled as given |
| `IndeterminateRiemann/Transform.lean` | same transform and proof, with `noncomputable` added |
| `IndeterminateRiemann/RiemannTest.lean` | the transform applied to Mathlib's `riemannZeta` and `RiemannHypothesis` |
| `IndeterminateRiemann/ZetaTwo.lean` | ζ(2) = π²/6 under the transform |

CI: `.github/workflows/indeterminate-riemann-test.yml`. Results are reported
as annotations on the run (build outcome per module and `#print axioms`).
