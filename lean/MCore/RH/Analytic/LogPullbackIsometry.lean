import MCore.RH.Analytic.MellinFourierBridge
import Mathlib.MeasureTheory.Integral.IntegralEqImproper
import Mathlib.MeasureTheory.Group.Integral

namespace MCore.RH.R0

open Complex MeasureTheory Set

/-- Squared norm of the logarithmic pullback after reflection u -> -u. -/
theorem residualLogPullback_norm_sq_neg
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) :
    ‖residualLogPullback c (-u)‖ ^ 2 =
      Real.exp u * ‖concreteResidualC c (Real.exp u)‖ ^ 2 := by
  simp [residualLogPullback]
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)]
  rw [← Real.exp_nat_mul]
  congr 2
  ring

/-- Logarithmic substitution is an exact L2 isometry for the residual. -/
theorem residualLogPullbackIsometry_realized :
    ResidualLogPullbackIsometry := by
  intro N c
  unfold ResidualLogPullbackIsometry
  rw [← integral_neg_eq_self]
  simp_rw [residualLogPullback_norm_sq_neg c]
  simpa [smul_eq_mul] using
    (integral_comp_exp
      (fun x : ℝ => ‖concreteResidualC c x‖ ^ 2)).symm

#print axioms MCore.RH.R0.residualLogPullbackIsometry_realized

end MCore.RH.R0
