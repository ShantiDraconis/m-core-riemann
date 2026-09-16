# RH K9 research map

Status: RESEARCH_ONLY / OPEN_BRIDGE. This file does not claim RH.

## Exact endpoint

Mathlib v4.19.0 defines `RiemannHypothesis` as the universal statement that every zero `s` of `riemannZeta` which is not a trivial zero `-2*(n+1)` and is not `1` has `s.re = 1/2`.

Primary formal reference:
- Mathlib, `Mathlib.NumberTheory.LSeries.RiemannZeta`:
  https://leanprover-community.github.io/mathlib4_docs/Mathlib/NumberTheory/LSeries/RiemannZeta.html
- Mathlib, discreteness of zeta zeros:
  https://leanprover-community.github.io/mathlib4_docs/Mathlib/NumberTheory/LSeries/ZetaZeros.html

Already reusable in Mathlib:
- `differentiable_completedZeta₀`: the pole-subtracted completed zeta is entire.
- `differentiableAt_completedZeta`: completed zeta is differentiable away from 0 and 1.
- `differentiableAt_riemannZeta` / `analyticOn_riemannZeta`.
- `completedRiemannZeta₀_one_sub`, `completedRiemannZeta_one_sub`, `riemannZeta_one_sub`.
- `riemannZeta_neg_two_mul_nat_add_one`.
- `riemannZeta_zero : riemannZeta 0 = -1/2`.
- `riemannZetaZeros`, closed/discrete/finiteness-on-compacts results.

## Important correction to the original M-Core narrative

`ζ'/ζ` should not be described as generically `0/0` at a zero of ζ. At a simple zero ρ, ζ(ρ)=0 while ζ'(ρ) is nonzero, and the logarithmic derivative has a pole. Multiple zeros require their own order analysis. Therefore the A3 `0/0` harness cannot be transferred to RH merely by naming `I_RH = ζ'/ζ`; an actual analytic construction is required.

Likewise, the observed numbers 0.309, 0.594, 0.609 are numerical evidence internal to the M-Core harness. No literature result located identifies `Φ≈0.6` with a criterion forcing all nontrivial zeta zeros to the critical line.

## Candidate rigorous bridge families from the literature

### Route NB: Nyman–Beurling / Báez-Duarte

RH is equivalent to an L² closure/approximation statement involving dilations of the fractional-part function. This is structurally the closest established criterion to a `regularization + approximation + uniform control` architecture.

References:
- L. Báez-Duarte, *A strengthening of the Nyman-Beurling criterion for the Riemann Hypothesis*, arXiv:math/0202141, 2002. https://arxiv.org/abs/math/0202141
- L. Báez-Duarte, *New versions of the Nyman-Beurling criterion for the Riemann hypothesis*, IJMMS 31 (2002), 387–406. DOI: 10.1155/S0161171202013248
- L. Báez-Duarte, *A General Strong Nyman-Beurling Criterion for the Riemann Hypothesis*, Publ. Inst. Math. 78(92) (2005). DOI: 10.2298/PIM0578117B

Missing M-Core theorem for this route:
`A1-A4 + regularization -> the exact Nyman-Beurling L² closure condition`.
No such theorem is currently present.

### Route LI: Li positivity criterion

Li's criterion turns RH into positivity of an infinite sequence of coefficients associated with the completed zeta/xi function. This offers a clean universal target but requires positivity for every index, not finitely many numerical tests.

References:
- J. C. Lagarias, *Li coefficients for automorphic L-functions*, Ann. Inst. Fourier 57 (2007), 1689–1740. DOI: 10.5802/AIF.2311
- S. Omar and K. Mazhouda, *The Li positivity criterion for the Selberg class*, C. R. Math. 345 (2007), 245–248. DOI: 10.1016/j.crma.2007.07.008

Missing M-Core theorem for this route:
`A1-A4 + regularization -> ∀ n>=1, LiCoefficient(n) >= 0`.
No such theorem is currently present.

### Route DBN: de Bruijn–Newman deformation

For the de Bruijn–Newman constant Λ, RH is equivalent to Λ <= 0. Rodgers–Tao proved Λ >= 0, so RH would amount to Λ = 0. This route naturally contains a scale/deformation parameter, but it is not the M-Core λ and no identification may be assumed.

References:
- B. Rodgers and T. Tao, *The de Bruijn-Newman constant is non-negative*, arXiv:1801.05914.
- K. Broughan, *Equivalents of the Riemann Hypothesis*, Cambridge University Press, Vol. 2, chapter on the de Bruijn-Newman constant.

Missing M-Core theorem for this route:
`M-Core scale/regularization data -> Λ <= 0`.
No such theorem is currently present.

## Current formal frontier

The research branch deliberately replaces `sorry` by explicit certificate types rather than by assumptions disguised as theorems.

1. Construct a `RegularizedMCoreSystem`.
2. Construct `RegularizationCertificate`:
   - path independence,
   - scale preservation,
   - self-reference elimination.
3. For every arbitrary nontrivial zero `s`, construct `ZetaTransferData sys reg s`.
4. Construct `Step7Certificate sys reg` universally in `s`.
5. Construct `Step8Certificate sys reg`, proving `s.re = 1/2` from the non-circular transferred properties.
6. Only then can `MCoreRHCertificate` be inhabited and `mcore_riemann_hypothesis_of_certificate` yield Mathlib's exact endpoint.

## Falsification rules

Reject a proposed bridge if any of the following occurs:
- it proves only one point `s` rather than all nontrivial zeros;
- `RiemannHypothesis`, `OfficialSpecRH`, or `s.re = 1/2` appears as a scientific premise;
- path independence is asserted directly from path dependence without a proved regularization theorem;
- a finite set of δ, λ, n, zeros, or Φ measurements is substituted for a universal quantifier;
- `ζ'/ζ` is treated as a generic `0/0` at zeta zeros;
- numerical `Φ≈0.6` is used as an endpoint proof;
- a new axiom, `sorry`, or `admit` supplies the scientific bridge.

## Recommended next route

The Nyman–Beurling/Báez-Duarte route is the most structurally aligned candidate to investigate first because it already expresses RH as a closure/approximation problem. This is a research prioritization, not evidence that M-Core implies the criterion. The exact next obligation is to define the Nyman–Beurling Hilbert-space objects in Lean and attempt a non-circular map from the regularized M-Core data to the required L² closure statement.
