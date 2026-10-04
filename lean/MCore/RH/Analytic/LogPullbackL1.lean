import MCore.RH.Analytic.ResidualL2
import MCore.RH.Analytic.MellinResidual
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

namespace MCore.RH.R0

open MeasureTheory Set Complex

/--
At the critical exponent, Mellin convergence is exactly L1 integrability
of the logarithmic pullback after x = exp(-u).
-/
theorem residual_logPullback_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (logPullback (residualRepresentativeC c)) volume := by
  let s : ℂ := (1 / 2 : ℂ)
  have hM : MellinConvergent (residualRepresentativeC c) s := by
    exact residualRepresentativeC_mellinConvergent c s (by norm_num) (by norm_num)
  rw [MellinConvergent] at hM
  have hweighted :
      IntegrableOn
        (fun x : ℝ =>
          (x : ℂ) ^ ((-1 / 2 : ℝ) : ℂ) • residualRepresentativeC c x)
        (Ioi 0) := by
    simpa [s] using hM
  have hexp :
      Integrable
        (fun u : ℝ =>
          Real.exp u •
            (((Real.exp u : ℂ) ^ ((-1 / 2 : ℝ) : ℂ)) •
              residualRepresentativeC c (Real.exp u))) := by
    simpa using (integrable_comp_exp
      (fun x : ℝ =>
        (x : ℂ) ^ ((-1 / 2 : ℝ) : ℂ) • residualRepresentativeC c x)).2 hweighted
  have hneg :
      Integrable
        ((fun u : ℝ =>
          Real.exp u •
            (((Real.exp u : ℂ) ^ ((-1 / 2 : ℝ) : ℂ)) •
              residualRepresentativeC c (Real.exp u))) ∘ fun u : ℝ => -u) := by
    exact (Measure.measurePreserving_neg (volume : Measure ℝ)).integrable_comp_of_integrable hexp
  apply Integrable.congr hneg
  exact Eventually.of_forall (fun u => by
    unfold Function.comp logPullback
    have hexp0 : Real.exp (-u) > 0 := Real.exp_pos _
    simp only [neg_neg]
    rw [show ((Real.exp (-u) : ℂ) ^ ((-1 / 2 : ℝ) : ℂ)) =
      (Real.exp (u / 2) : ℝ) by
        rw [← Complex.ofReal_exp]
        rw [← Complex.exp_ofReal_mul]
        rw [Complex.ofReal_neg, Complex.ofReal_div, Complex.ofReal_ofNat]
        rw [← Complex.exp_mul]
        congr 1
        ring]
    push_cast
    simp [Real.exp_add]
    congr 1
    ring)

/-- Hence the logarithmic pullback belongs simultaneously to L1 and L2. -/
theorem residual_logPullback_memLp_one
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (logPullback (residualRepresentativeC c)) 1 volume := by
  exact (residual_logPullback_integrable c).memLp_one

#print axioms MCore.RH.R0.residual_logPullback_integrable
#print axioms MCore.RH.R0.residual_logPullback_memLp_one

end MCore.RH.R0
