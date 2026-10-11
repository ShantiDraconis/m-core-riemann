# Li's criterion — finite core (kernel-checked)

Isolated Lake project (does not touch the rest of `m-core-riemann`). Mathlib
v4.19.0 pinned to `c44e0c8ee63ca166450922a373c7409c5d26b00b`.

`LiCriterion/Finite.lean` proves, with no hypothesis beyond `ρ ≠ 1`:

* the Möbius map ρ ↦ ρ/(ρ−1) sends the critical line onto the unit circle;
* for any finite family: all Li coefficients have Re ≥ 0 ⟺ every point has Re ≤ 1/2;
* for a finite family closed under ρ ↦ 1 − ρ: all Li coefficients ≥ 0 ⟺ every point is on the critical line;
* two concrete examples (on the line / off the line).

Not proved here: the infinite version (Bombieri–Lagarias), the application to
the zeros of ζ (needs the Hadamard product, not in Mathlib), and RH itself,
which is open. CI: `.github/workflows/li-criterion-finite.yml`.
