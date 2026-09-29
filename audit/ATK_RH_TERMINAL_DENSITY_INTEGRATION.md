# ATK RH terminal density integration

Status: IN_PROGRESS until CI is GREEN.

Branch: `atk/rh-terminal-density-integration-20260929`

## Reused frozen material

- NB zero-limit / finite-span equivalence from commit `d6a291b4563f9021f74ab63cc983d44f079472da`.
- Concrete R0 Hilbert model and Báez-Duarte generator family from the certified R2 research line.

## New forward-only producer

`ExplicitCoefficientProducer.lean` proves that for any coefficient table
`c : ℕ → ℕ → ℝ`, the finite sum over the first N concrete generators lies in
the canonical finite span. If the L2 error of this explicit sequence tends to
zero, then `FiniteSpanApproximatesChi` follows and hence `DNLimit = 0`.

This does **not** assert the missing convergence. The remaining material
obligation is exactly an unconditional proof of that L2 convergence for a
specific explicit coefficient family (for example a rigorously selected
Möbius/BCF family).

No RH theorem is promoted by this integration alone.
