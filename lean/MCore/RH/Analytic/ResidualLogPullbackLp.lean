import MCore.RH.Analytic.MellinLogIsometry
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- The literal real residual is itself an L2 representative on the frozen half-line. -/
theorem realResidualRepresentative_memLp
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (realResidualRepresentative c) 2 zeroInfinityMeasure := by
  have hLp :
      MemLp
        ((concreteNBData.chi - concreteFiniteCombination c : concreteNBData.H) : ℝ → ℝ)
        2 zeroInfinityMeasure :=
    Lp.memLp _
  exact hLp.congr (concreteResidual_coeFn_ae c)

/-- Square integrability of the real residual as a Lebesgue set-integral statement. -/
theorem realResidualRepresentative_sq_integrableOn
    {N : ℕ} (c : Fin N → ℝ) :
    IntegrableOn
      (fun x : ℝ => (realResidualRepresentative c x) ^ 2)
      (Ioi 0) volume := by
  simpa [zeroInfinityMeasure] using
    (realResidualRepresentative_memLp c).integrable_sq

/-- The logarithmic pullback is strongly measurable. -/
theorem residualLogPullback_aestronglyMeasurable
    {N : ℕ} (c : Fin N → ℝ) :
    AEStronglyMeasurable (residualLogPullback c) volume := by
  unfold residualLogPullback residualRepresentativeC rhoCombinationC
  fun_prop

/-- The norm-square of the logarithmic pullback is integrable on the full line. -/
theorem residualLogPullback_normSq_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (fun u : ℝ => normSq (residualLogPullback c u)) volume := by
  have hexp :
      Integrable
        (fun v : ℝ =>
          Real.exp v * (realResidualRepresentative c (Real.exp v)) ^ 2) volume := by
    exact (integrable_comp_exp
      (fun x : ℝ => (realResidualRepresentative c x) ^ 2)).2
      (realResidualRepresentative_sq_integrableOn c)
  have hneg :
      Integrable
        (fun u : ℝ =>
          Real.exp (-u) * (realResidualRepresentative c (Real.exp (-u))) ^ 2) volume := by
    have hcomp := hexp.comp_mul_left' (show (-1 : ℝ) ≠ 0 by norm_num)
    simpa using hcomp
  exact hneg.congr (Eventually.of_forall fun u =>
    (normSq_residualLogPullback c u).symm)

/-- The logarithmic pullback belongs to L2. -/
theorem residualLogPullback_memLp
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (residualLogPullback c) 2 volume := by
  rw [memLp_two_iff_integrable_sq_norm
    (residualLogPullback_aestronglyMeasurable c)]
  exact (residualLogPullback_normSq_integrable c).congr
    (Eventually.of_forall fun u => by
      rw [normSq_apply]
      rfl)

#print axioms MCore.RH.R0.realResidualRepresentative_memLp
#print axioms MCore.RH.R0.residualLogPullback_memLp

end MCore.RH.R0
