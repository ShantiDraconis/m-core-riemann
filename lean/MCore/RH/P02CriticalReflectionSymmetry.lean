import MCore.RH.P02DeterministicRejectionZero
import Mathlib.NumberTheory.Harmonic.ZetaAsymp

namespace MCore

/-!
# Critical-reflection zeta symmetry

Concrete analytic progress toward the material RH frontier.  This file proves
that the frozen critical reflection is conjugated functional reflection and
uses Mathlib's functional equation plus conjugation symmetry to transport a
zeta zero whenever the exact functional-equation side conditions hold.
-/

theorem criticalReflect_eq_conj_functionalReflect (s : ℂ) :
    criticalReflect s = conj (functionalReflect s) := by
  apply Complex.ext <;> simp [criticalReflect, functionalReflect]

theorem criticalReflect_zeta_zero_of_functional_side_conditions
    {s : ℂ}
    (hz : riemannZeta s = 0)
    (hneg : ∀ n : ℕ, s ≠ -(n : ℂ))
    (h1 : s ≠ 1) :
    riemannZeta (criticalReflect s) = 0 := by
  have hfun : riemannZeta (functionalReflect s) = 0 :=
    functionalReflect_zero_closed_of_not_neg_nat hz hneg h1
  rw [criticalReflect_eq_conj_functionalReflect, riemannZeta_conj, hfun]
  simp

/-- Exact remaining side-condition package needed to promote zero-value
reflection closure for an arbitrary probe nontrivial zero. -/
def ProbeFunctionalSideConditions : Prop :=
  ∀ s : ℂ, ProbeNontrivialZetaZero s →
    (∀ n : ℕ, s ≠ -(n : ℂ)) ∧ s ≠ 1

theorem criticalReflect_zero_value_closed_of_probe_side_conditions
    (hside : ProbeFunctionalSideConditions)
    {s : ℂ}
    (hs : ProbeNontrivialZetaZero s) :
    riemannZeta (criticalReflect s) = 0 := by
  rcases hside s hs with ⟨hneg, h1⟩
  exact criticalReflect_zeta_zero_of_functional_side_conditions hs.1 hneg h1

end MCore
