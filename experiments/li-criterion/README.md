# Li's criterion — finite core and truncated criterion for ζ (kernel-checked)

Isolated Lake project. It does not touch the rest of `m-core-riemann`. It uses Lean v4.35.0 and Mathlib v4.35.0,
pinned to `56a005855ea17e0b0958f73ec801ae140b0a1679`; it was ported from v4.19.0 without changing any statement.
CI: `.github/workflows/li-zeta-v435.yml`.

## `LiCriterion/Finite.lean`

Uses no hypothesis beyond `ρ ≠ 1`:

* the Möbius map ρ ↦ ρ/(ρ−1) sends the critical line onto the unit circle;
* for any finite family, all Li coefficients have Re ≥ 0 ⟺ every point has Re ≤ 1/2;
* for a finite family closed under ρ ↦ 1 − ρ, all Li coefficients are ≥ 0 ⟺ every point is on the critical line.

## `LiCriterion/Zeta.lean`: application to the real `riemannZeta`

Two results new in Mathlib v4.35.0 make the finite core apply to ζ itself:

* `IsCompact.inter_riemannZetaZeros_finite` gives finitely many zeros up to each height;
* `hardyZ` and `hardyZ_eq_zero_iff` relate the zeros on the critical line to Hardy's Z.

Truncated Li coefficients: `λₙ(T) = Σ (1 − (ρ/(ρ−1))ⁿ)`, summed over the zeros of ζ with 0 < Re ρ < 1 and
|Im ρ| ≤ T, each counted once.

| Theorem | Statement |
|---|---|
| `liTrunc_criterion T` | `(∀ n, 0 ≤ Re λₙ(T)) ↔` every zero up to height T is on the critical line |
| `trivial_of_re_nonpos` | zeros of ζ with Re s ≤ 0 are exactly the trivial ones −2(n+1) |
| `riemannHypothesis_iff_liTrunc` | **Mathlib's `RiemannHypothesis` ↔ ∀ T n, 0 ≤ Re λₙ(T)** |
| `exists_lowest_offline_zero` | if RH fails, there is a lowest off-line zero |
| `liTrunc_threshold_of_not_RH` | if RH fails, there is a finite height T₀ with all λₙ(T) ≥ 0 for T < T₀ and some λₙ(T₀) < 0 |
| `li_two_worlds` | either ∀ T n, 0 ≤ Re λₙ(T) (RH), or such a finite threshold T₀ exists |
| `liTrunc_eq_li_original` | λₙ(T) = Σ (1 − (1 − 1/ρ)ⁿ), Li's original form |
| `hardyZ_im_eq_zero`, `stripZero_of_hardyZ` | zeros on the line ⟷ zeros of Hardy's Z |

What this does **not** do:

* It does not prove RH. Every statement is an equivalence or a dichotomy.
* It is not Li's original criterion. That criterion sums over all zeros with multiplicity and needs
  the Hadamard product (Bombieri–Lagarias), which is not in Mathlib. Here every sum is finite and each zero is
  counted once.
