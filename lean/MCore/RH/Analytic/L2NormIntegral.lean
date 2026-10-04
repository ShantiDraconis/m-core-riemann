import Mathlib.MeasureTheory.Function.L2Space

namespace MCore.RH.R0

open MeasureTheory

/-- Squared L2 norm equals the integral of the pointwise squared norm. -/
theorem lp2_norm_sq_eq_integral_norm_sq
    (f : Lp ℂ 2 (volume : Measure ℝ)) :
    ‖f‖ ^ 2 = ∫ x : ℝ, ‖f x‖ ^ 2 := by
  have hinner := MeasureTheory.L2.inner_def f f
  have hre := congrArg Complex.re hinner
  rw [← integral_re (MeasureTheory.L2.integrable_inner f f)] at hre
  simpa only [← norm_sq_eq_re_inner, inner_self_eq_norm_sq_to_K,
    Complex.ofReal_re] using hre

#print axioms MCore.RH.R0.lp2_norm_sq_eq_integral_norm_sq

end MCore.RH.R0
