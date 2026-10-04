import MCore.RH.Analytic.D3FourierReduction
import Mathlib.Analysis.MellinInversion

namespace MCore.RH.R0

open Real Complex Set MeasureTheory

private theorem rexp_neg_deriv_public :
    ∀ u ∈ Set.univ,
      HasDerivWithinAt (Real.exp ∘ Neg.neg) (-Real.exp (-u)) Set.univ u :=
  fun u _ =>
    mul_neg_one (Real.exp (-u)) ▸
      ((Real.hasDerivAt_exp (-u)).comp u (hasDerivAt_neg u)).hasDerivWithinAt

private theorem rexp_neg_image_public :
    (Real.exp ∘ Neg.neg) '' Set.univ = Set.Ioi 0 := by
  rw [Set.image_comp, Set.image_univ_of_surjective neg_surjective,
    Set.image_univ, Real.range_exp]

private theorem rexp_neg_injOn_public :
    Set.univ.InjOn (Real.exp ∘ Neg.neg) :=
  Real.exp_injective.injOn.comp neg_injective.injOn (Set.univ.mapsTo_univ _)

/-- Pointwise squared norm of the logarithmic lift. -/
theorem residualLogLift_normSq
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) :
    ‖residualLogLift c u‖ ^ 2 =
      Real.exp (-u) *
        ‖residualRepresentativeC c (Real.exp (-u))‖ ^ 2 := by
  rw [residualLogLift, norm_mul, Complex.norm_real,
    Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  have hexp :
      Real.exp (-(1 / 2 : ℝ) * u) ^ 2 = Real.exp (-u) := by
    rw [pow_two, ← Real.exp_add]
    congr 1
    ring
  rw [mul_pow, hexp]

/-- D3 log-Jacobian isometry x = exp(-u). -/
theorem residualLogLiftIsometry_realized :
    ResidualLogLiftIsometry := by
  intro N c
  let g : ℝ → ℝ := fun x => ‖residualRepresentativeC c x‖ ^ 2
  rw [← rexp_neg_image_public]
  rw [integral_image_eq_integral_abs_deriv_smul
    MeasurableSet.univ rexp_neg_deriv_public rexp_neg_injOn_public]
  apply integral_congr
  intro u
  change |(-Real.exp (-u))| • g (Real.exp (-u)) =
    ‖residualLogLift c u‖ ^ 2
  rw [abs_neg, abs_of_pos (Real.exp_pos _), real_smul]
  rw [residualLogLift_normSq]
  rfl

#print axioms MCore.RH.R0.residualLogLift_normSq
#print axioms MCore.RH.R0.residualLogLiftIsometry_realized

end MCore.RH.R0
