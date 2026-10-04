import MCore.RH.Analytic.ResidualLp
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set

theorem complexFiniteCombination_measurable
    {N : ℕ} (c : Fin N → ℝ) :
    Measurable (complexFiniteCombination c) := by
  classical
  unfold complexFiniteCombination
  fun_prop

theorem complexResidual_measurable
    {N : ℕ} (c : Fin N → ℝ) :
    Measurable (complexResidual c) := by
  unfold complexResidual
  exact chiRepresentative_measurable.ofReal.sub
    (complexFiniteCombination_measurable c)

theorem criticalLogTransport_measurable
    (f : ℝ → ℂ) (hf : Measurable f) :
    Measurable (criticalLogTransport f) := by
  unfold criticalLogTransport
  fun_prop

/-- L2 membership is preserved by the critical logarithmic transport for concrete residuals. -/
theorem criticalLogTransport_complexResidual_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (criticalLogTransport (complexResidual c)) 2 volume := by
  have hpos := complexResidual_sq_integrableOn_Ioi c
  have hexp :
      Integrable (fun u : ℝ => Real.exp u *
        ‖complexResidual c (Real.exp u)‖ ^ 2) := by
    simpa [smul_eq_mul] using
      (integrable_comp_exp (fun x : ℝ => ‖complexResidual c x‖ ^ 2)).2 hpos
  have hneg :
      Integrable (fun u : ℝ => Real.exp (-u) *
        ‖complexResidual c (Real.exp (-u))‖ ^ 2) := by
    have hcomp : Integrable
        ((fun u : ℝ => Real.exp u * ‖complexResidual c (Real.exp u)‖ ^ 2) ∘
          fun u : ℝ => -u) := by
      exact ((Measure.measurePreserving_neg (volume : Measure ℝ)).integrable_comp_emb
        (Homeomorph.neg ℝ).measurableEmbedding).2 hexp
    simpa [Function.comp_def] using hcomp
  rw [memLp_two_iff_integrable_sq_norm
    (criticalLogTransport_measurable (complexResidual c)
      (complexResidual_measurable c)).aestronglyMeasurable]
  simpa [normSq_criticalLogTransport] using hneg

#print axioms MCore.RH.R0.criticalLogTransport_complexResidual_memLp_two

end MCore.RH.R0
