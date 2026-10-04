import MCore.RH.Analytic.ResidualLogPullbackLp
import MCore.RH.Analytic.MellinResidual
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Mellin convergence of the residual at the central real exponent 1/2. -/
theorem residualRepresentativeC_mellinConvergent_half
    {N : ℕ} (c : Fin N → ℝ) :
    MellinConvergent (residualRepresentativeC c) ((1 / 2 : ℝ) : ℂ) := by
  apply residualRepresentativeC_mellinConvergent c
  · norm_num
  · norm_num

/--
The logarithmic pullback is L1. This is exactly the L1 side of the standard
L1∩L2 Fourier-representation theorem.
-/
theorem residualLogPullback_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (residualLogPullback c) volume := by
  have hM := residualRepresentativeC_mellinConvergent_half c
  rw [MellinConvergent] at hM
  have hexp :
      Integrable
        (fun v : ℝ =>
          Real.exp v •
            (((Real.exp v : ℂ) ^ ((((1 / 2 : ℝ) : ℂ) - 1)) •
              residualRepresentativeC c (Real.exp v))) volume := by
    exact (integrable_comp_exp
      (fun x : ℝ =>
        (x : ℂ) ^ ((((1 / 2 : ℝ) : ℂ) - 1)) •
          residualRepresentativeC c x)).2 hM
  have hsimplified :
      Integrable
        (fun v : ℝ =>
          Real.exp ((1 / 2 : ℝ) * v) *
            residualRepresentativeC c (Real.exp v)) volume := by
    apply hexp.congr
    filter_upwards with v
    simp only [smul_eq_mul]
    have hev : (Real.exp v : ℂ) ≠ 0 := by positivity
    rw [Complex.cpow_def_of_ne_zero hev]
    rw [Complex.log_ofReal (Real.exp_pos v).le]
    rw [Real.log_exp]
    push_cast
    rw [← Complex.ofReal_exp]
    congr 1
    ring_nf
  have hneg := hsimplified.comp_mul_left' (show (-1 : ℝ) ≠ 0 by norm_num)
  simpa [residualLogPullback, mul_assoc] using hneg

#print axioms MCore.RH.R0.residualLogPullback_integrable

end MCore.RH.R0
