import MCore.RH.Analytic.MellinPlancherelDecomposition
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

namespace MCore.RH.R0

open MeasureTheory Complex

/-- Pointwise square norm of the logarithmic pullback. -/
theorem logPullback_norm_sq (f : ℝ → ℂ) (u : ℝ) :
    ‖logPullback f u‖ ^ 2 =
      Real.exp (-u) * ‖f (Real.exp (-u))‖ ^ 2 := by
  unfold logPullback
  rw [norm_mul, Complex.norm_real, Real.norm_eq_abs,
    abs_of_pos (Real.exp_pos _), mul_pow]
  rw [sq, Real.exp_mul, ← Real.exp_add]
  ring_nf

/-- L2 norm preservation under x = exp(-u). -/
theorem logPullbackIsometry_realized :
    LogPullbackIsometry := by
  intro f hf
  have hneg :
      (∫ u : ℝ,
        Real.exp (-u) * ‖f (Real.exp (-u))‖ ^ 2) =
      ∫ v : ℝ,
        Real.exp v * ‖f (Real.exp v)‖ ^ 2 := by
    have h := Measure.integral_comp_mul_left
      (fun v : ℝ => Real.exp v * ‖f (Real.exp v)‖ ^ 2) (-1)
    simpa using h
  rw [show (∫ u : ℝ, ‖logPullback f u‖ ^ 2) =
      ∫ u : ℝ, Real.exp (-u) * ‖f (Real.exp (-u))‖ ^ 2 by
        apply integral_congr_ae
        filter_upwards with u
        exact logPullback_norm_sq f u]
  rw [hneg]
  simpa [smul_eq_mul] using
    (integral_comp_exp (fun x : ℝ => ‖f x‖ ^ 2)).symm

/-- On the critical line the Mellin transform is the Fourier integral of the log-pullback. -/
theorem mellin_critical_eq_fourier
    (f : ℝ → ℂ) (t : ℝ) :
    mellin f (criticalLine t) =
      𝓕 (logPullback f) (t / (2 * Real.pi)) := by
  rw [mellin_eq_fourierIntegral]
  congr 1
  funext u
  simp [logPullback, criticalLine]
  ring_nf

/-- The 2π frequency change converts Fourier height into Mellin height. -/
theorem criticalFrequencyScaling_realized :
    CriticalFrequencyScaling := by
  intro f hf
  let q : ℝ → ℝ := fun t =>
    ‖mellin f (criticalLine t)‖ ^ 2
  have hpoint :
      ∀ ξ : ℝ,
        ‖𝓕 (logPullback f) ξ‖ ^ 2 =
          q ((2 * Real.pi) * ξ) := by
    intro ξ
    unfold q
    rw [mellin_critical_eq_fourier]
    have h2pi : (2 * Real.pi : ℝ) ≠ 0 := by positivity
    rw [mul_div_cancel_left₀ ξ h2pi]
  rw [show (∫ ξ : ℝ, ‖𝓕 (logPullback f) ξ‖ ^ 2) =
      ∫ ξ : ℝ, q ((2 * Real.pi) * ξ) by
        apply integral_congr_ae
        filter_upwards with ξ
        exact hpoint ξ]
  rw [Measure.integral_comp_mul_left q (2 * Real.pi)]
  have hpi : 0 < 2 * Real.pi := by positivity
  rw [abs_of_pos (inv_pos.mpr hpi)]
  change (2 * Real.pi)⁻¹ * (∫ t : ℝ, q t) =
    (1 / (2 * Real.pi)) * ∫ t : ℝ, ‖mellin f (criticalLine t)‖ ^ 2
  simp [q, one_div]

#print axioms MCore.RH.R0.logPullbackIsometry_realized
#print axioms MCore.RH.R0.criticalFrequencyScaling_realized

end MCore.RH.R0
