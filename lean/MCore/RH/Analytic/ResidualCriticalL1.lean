import MCore.RH.Analytic.ResidualCriticalL2
import Mathlib.Analysis.MellinTransform
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

namespace MCore.RH.R0

open MeasureTheory Set Complex

/--
At Re(s)=1/2, Mellin convergence is exactly L1 integrability of the
logarithmic critical transport u ↦ exp(-u/2) f(exp(-u)).
-/
theorem mellinHalf_convergent_implies_criticalLogIntegrable
    (f : ℝ → ℂ)
    (hM : MellinConvergent f ((1 / 2 : ℝ) : ℂ)) :
    Integrable (criticalLogTransport f) volume := by
  have hweighted :
      IntegrableOn
        (fun x : ℝ => (x ^ (-1 / 2 : ℝ) : ℂ) * f x)
        (Ioi 0) volume := by
    apply IntegrableOn.congr_fun hM
    · intro x hx
      have hx0 : 0 ≤ x := le_of_lt hx
      rw [← Complex.ofReal_cpow hx0]
      norm_num
      simp [smul_eq_mul]
    · exact measurableSet_Ioi
  have hexp :
      Integrable
        (fun u : ℝ => Real.exp (u / 2) * f (Real.exp u)) volume := by
    have h := (integrable_comp_exp
      (fun x : ℝ => (x ^ (-1 / 2 : ℝ) : ℂ) * f x)).2 hweighted
    convert h using 1
    funext u
    simp only [smul_eq_mul]
    push_cast
    rw [Real.rpow_def_of_pos (Real.exp_pos u)]
    rw [Real.log_exp]
    rw [← Complex.ofReal_exp]
    push_cast
    congr 1
    ring_nf
  have hneg :
      Integrable
        ((fun u : ℝ => Real.exp (u / 2) * f (Real.exp u)) ∘
          fun u : ℝ => -u) volume := by
    exact ((Measure.measurePreserving_neg (volume : Measure ℝ)).integrable_comp_emb
      (Homeomorph.neg ℝ).measurableEmbedding).2 hexp
  simpa [criticalLogTransport, Function.comp_def] using hneg

/-- The residual Mellin transform converges at the critical real point. -/
theorem complexResidual_mellinConvergent_half
    {N : ℕ} (c : Fin N → ℝ) :
    MellinConvergent (complexResidual c) ((1 / 2 : ℝ) : ℂ) := by
  have hs0 : 0 < (((1 / 2 : ℝ) : ℂ).re) := by norm_num
  have hs1 : (((1 / 2 : ℝ) : ℂ).re) < 1 := by norm_num
  have hchi := chiRepresentativeC_mellinConvergent (((1 / 2 : ℝ) : ℂ)) hs0 hs1
  have hcomb := complexFiniteCombination_mellinConvergent c (((1 / 2 : ℝ) : ℂ)) hs0 hs1
  exact (hasMellin_sub hchi hcomb).1

/-- The logarithmic transform of every finite residual is L1. -/
theorem criticalLogTransport_complexResidual_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (criticalLogTransport (complexResidual c)) volume := by
  exact mellinHalf_convergent_implies_criticalLogIntegrable
    (complexResidual c) (complexResidual_mellinConvergent_half c)

#print axioms MCore.RH.R0.criticalLogTransport_complexResidual_integrable

end MCore.RH.R0
