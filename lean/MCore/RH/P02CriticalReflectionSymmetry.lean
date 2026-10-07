import MCore.RH.P02DeterministicRejectionZero

namespace MCore

/-!
# Critical-reflection zeta symmetry

Lean 4.19 / Mathlib v4.19.0 does not yet export the later
`riemannZeta_conj` theorem.  Therefore conjugation-zero transport is exposed
as an explicit analytic sub-obligation instead of being silently assumed.
-/

/-- The frozen critical reflection is conjugated functional reflection. -/
theorem criticalReflect_eq_star_functionalReflect (s : ℂ) :
    criticalReflect s = starRingEnd ℂ (functionalReflect s) := by
  apply Complex.ext <;> simp [criticalReflect, functionalReflect]

/-- Exact conjugation-zero symmetry needed by the v4.19 chain. -/
def RiemannZetaConjugationZeroSymmetry : Prop :=
  ∀ z : ℂ,
    riemannZeta z = 0 →
    riemannZeta (starRingEnd ℂ z) = 0

/-- Functional equation + conjugation-zero symmetry transport a zero to the
critical reflection.  All assumptions are explicit and independently auditable. -/
theorem criticalReflect_zeta_zero_of_symmetries
    (hconj : RiemannZetaConjugationZeroSymmetry)
    {s : ℂ}
    (hz : riemannZeta s = 0)
    (hneg : ∀ n : ℕ, s ≠ -(n : ℂ))
    (h1 : s ≠ 1) :
    riemannZeta (criticalReflect s) = 0 := by
  have hfun : riemannZeta (functionalReflect s) = 0 :=
    functionalReflect_zero_closed_of_not_neg_nat hz hneg h1
  rw [criticalReflect_eq_star_functionalReflect]
  exact hconj (functionalReflect s) hfun

/-- Exact functional-equation side-condition package needed for an arbitrary
probe nontrivial zero. -/
def ProbeFunctionalSideConditions : Prop :=
  ∀ s : ℂ, ProbeNontrivialZetaZero s →
    (∀ n : ℕ, s ≠ -(n : ℂ)) ∧ s ≠ 1

/-- Zero-value closure across the critical reflection follows from the two
independent symmetry ingredients. -/
theorem criticalReflect_zero_value_closed
    (hconj : RiemannZetaConjugationZeroSymmetry)
    (hside : ProbeFunctionalSideConditions)
    {s : ℂ}
    (hs : ProbeNontrivialZetaZero s) :
    riemannZeta (criticalReflect s) = 0 := by
  rcases hside s hs with ⟨hneg, h1⟩
  exact criticalReflect_zeta_zero_of_symmetries hconj hs.1 hneg h1

end MCore
