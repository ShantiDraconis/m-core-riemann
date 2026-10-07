import MCore.RH.P02DeterministicRejectionZero
import Mathlib.NumberTheory.LSeries.Dirichlet

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


/-- The functional-equation side conditions are already consequences of the
probe nontrivial-zero predicate.  Negative even integers are excluded by
definition, zero is not a zeta zero, and negative odd integers are nonzero by
the Bernoulli-value lemma together with nonvanishing on Re(s) > 1. -/
theorem probeFunctionalSideConditions_proved :
    ProbeFunctionalSideConditions := by
  intro s hs
  refine ⟨?_, hs.2.2⟩
  intro n hsn
  rcases Nat.even_or_odd' n with ⟨k, hk | hk⟩
  · subst n
    rcases k with _ | k
    · have hz0 : riemannZeta (0 : ℂ) = 0 := by
        simpa using (congrArg riemannZeta hsn).symm.trans hs.1
      rw [riemannZeta_zero] at hz0
      norm_num at hz0
    · apply hs.2.1
      refine ⟨k, ?_⟩
      simpa [Nat.cast_mul, Nat.cast_add] using hsn
  · subst n
    have hzpos :
        riemannZeta (((2 * (k + 1) : ℕ) : ℂ)) ≠ 0 := by
      apply riemannZeta_ne_zero_of_one_lt_re
      simp
      have hk0 : (0 : ℝ) ≤ k := by positivity
      nlinarith
    have hodd :
        riemannZeta (-((2 * k + 1 : ℕ) : ℂ)) ≠ 0 :=
      riemannZeta_neg_odd_ne_zero_of_pos_even k hzpos
    apply hodd
    rw [← hsn]
    exact hs.1


/-- Conjugation symmetry for Deligne's real Gamma factor.  This is independent
of RH and follows from conjugation of complex powers and the Gamma function. -/
theorem GammaR_star (s : ℂ) :
    Complex.Gammaℝ (starRingEnd ℂ s) =
      starRingEnd ℂ (Complex.Gammaℝ s) := by
  rw [Complex.Gammaℝ_def, Complex.Gammaℝ_def, map_mul]
  have htwo : starRingEnd ℂ (2 : ℂ) = 2 := by simp
  have hGamma :
      Complex.Gamma ((starRingEnd ℂ s) / 2) =
        starRingEnd ℂ (Complex.Gamma (s / 2)) := by
    simpa [htwo] using Complex.Gamma_conj (s / 2)
  have hpi : (Complex.arg (Real.pi : ℂ)) ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg Real.pi_pos.le]
    exact Real.pi_ne_zero.symm
  have hpow :
      (Real.pi : ℂ) ^ (-(starRingEnd ℂ s) / 2) =
        starRingEnd ℂ ((Real.pi : ℂ) ^ (-s / 2)) := by
    simpa [htwo] using
      (Complex.conj_cpow (Real.pi : ℂ) (-(starRingEnd ℂ s) / 2) hpi)
  exact congrArg₂ (· * ·) hpow hGamma

/-- The remaining conjugation theorem can be isolated at the completed-zeta
level.  This is strictly weaker infrastructure than assuming RH. -/
def CompletedRiemannZetaConjugationSymmetry : Prop :=
  ∀ z : ℂ,
    completedRiemannZeta (starRingEnd ℂ z) =
      starRingEnd ℂ (completedRiemannZeta z)

/-- Completed-zeta conjugation plus the Gamma-factor symmetry produce the
zero-level conjugation law needed by the terminal RH chain. -/
theorem riemannZetaConjugationZeroSymmetry_of_completed
    (hcomp : CompletedRiemannZetaConjugationSymmetry) :
    RiemannZetaConjugationZeroSymmetry := by
  intro z hz
  have hz0 : z ≠ 0 := by
    intro h0
    subst z
    rw [riemannZeta_zero] at hz
    norm_num at hz
  have hcz0 : starRingEnd ℂ z ≠ 0 := by
    intro h
    apply hz0
    have h' := congrArg (starRingEnd ℂ) h
    simpa using h'
  rw [riemannZeta_def_of_ne_zero hcz0]
  rw [hcomp z, GammaR_star z]
  have hzdiv : completedRiemannZeta z / Complex.Gammaℝ z = 0 := by
    simpa [riemannZeta_def_of_ne_zero hz0] using hz
  have hmap := congrArg (starRingEnd ℂ) hzdiv
  simpa [map_div₀] using hmap

end MCore
