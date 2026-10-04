import MCore.RH.Analytic.FourierPlancherelPinnedGap
import MCore.RH.Analytic.LogPullbackIsometry
import Mathlib.MeasureTheory.Function.L2Space

namespace MCore.RH.R0

open MeasureTheory Set

/-- The literal complex residual is strongly measurable. -/
theorem residualRepresentativeC_measurable
    {N : ℕ} (c : Fin N → ℝ) :
    Measurable (residualRepresentativeC c) := by
  unfold residualRepresentativeC rhoCombinationC
  apply Measurable.sub
  · exact chiRepresentative_measurable.ofReal
  · exact Finset.measurable_sum _ (by
      intro i hi
      exact Measurable.const_mul (rhoRepresentative_measurable_public i).ofReal _)

/-- The critical logarithmic pullback is strongly measurable. -/
theorem criticalLogPullback_measurable
    {N : ℕ} (c : Fin N → ℝ) :
    Measurable (criticalLogPullback c) := by
  unfold criticalLogPullback
  exact (measurable_exp.comp
    (measurable_const.mul measurable_id).neg).ofReal.mul
      ((residualRepresentativeC_measurable c).comp
        (measurable_exp.comp measurable_neg))

/--
The squared norm of the critical log pullback is integrable because D3.1
identifies it by change of variables with the squared norm of an actual L2 residual.
-/
theorem criticalLogPullback_normSq_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (fun u : ℝ => Complex.normSq (criticalLogPullback c u)) := by
  have hres :
      MemLp (residualRepresentativeR c) 2 zeroInfinityMeasure := by
    have hmeas :
        AEStronglyMeasurable (residualRepresentativeR c) zeroInfinityMeasure :=
      (Lp.stronglyMeasurable (concreteResidual c)).aestronglyMeasurable.congr
        (concreteResidual_coeFn_ae c)
    exact (Lp.memLp (concreteResidual c)).congr_norm hmeas
      ((concreteResidual_coeFn_ae c).fun_comp norm)
  have hsq :
      Integrable
        (fun x : ℝ => (residualRepresentativeR c x) ^ 2)
        zeroInfinityMeasure :=
    (memLp_two_iff_integrable_sq hres.aestronglyMeasurable).1 hres
  have hsqC :
      IntegrableOn
        (fun x : ℝ => Complex.normSq (residualRepresentativeC c x))
        (Ioi 0) volume := by
    change Integrable
      (fun x : ℝ => Complex.normSq (residualRepresentativeC c x))
      zeroInfinityMeasure
    refine hsq.congr ?_
    filter_upwards with x
    rw [residualRepresentativeC_eq_ofReal]
    simp [Complex.normSq, pow_two]
  let g : ℝ → ℝ :=
    fun x => Complex.normSq (residualRepresentativeC c x)
  have hcv :
      Integrable
        (fun u : ℝ =>
          | -Real.exp (-u) | • g (Real.exp (-u)))
        volume := by
    have himage :=
      (integrableOn_image_iff_integrableOn_abs_deriv_smul
        (s := (Set.univ : Set ℝ))
        MeasurableSet.univ
        rexp_neg_deriv
        rexp_neg_injOn
        g)
    rw [rexp_neg_image] at himage
    exact himage.mpr hsqC
  refine hcv.congr ?_
  filter_upwards with u
  have hp : 0 < Real.exp (-u) := Real.exp_pos _
  simp only [abs_neg, abs_of_pos hp, smul_eq_mul, g]
  rw [criticalLogPullback_normSq]

/-- Mellin convergence at sigma=1/2 makes the critical logarithmic pullback L1. -/
theorem criticalLogPullback_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (criticalLogPullback c) volume := by
  let s0 : ℂ := ((1 / 2 : ℝ) : ℂ)
  have hs0 : 0 < s0.re := by norm_num [s0]
  have hs1 : s0.re < 1 := by norm_num [s0]
  have hm := residualRepresentativeC_mellinConvergent c s0 hs0 hs1
  rw [MellinConvergent] at hm
  have himage :=
    (integrableOn_image_iff_integrableOn_abs_deriv_smul
      (s := (Set.univ : Set ℝ))
      MeasurableSet.univ
      rexp_neg_deriv
      rexp_neg_injOn
      (fun x : ℝ =>
        ((x : ℂ) ^ (s0 - 1)) * residualRepresentativeC c x))
  rw [rexp_neg_image] at himage
  have hu : Integrable
      (fun u : ℝ =>
        | -Real.exp (-u) | •
          (((Real.exp (-u) : ℂ) ^ (s0 - 1)) *
            residualRepresentativeC c (Real.exp (-u)))) := by
    exact himage.mpr hm
  refine hu.congr ?_
  filter_upwards with u
  have hp : 0 < Real.exp (-u) := Real.exp_pos _
  have hne : (Real.exp (-u) : ℂ) ≠ 0 := by
    exact Complex.ofReal_ne_zero.mpr hp.ne'
  rw [criticalLogPullback]
  simp only [abs_neg, abs_of_pos hp, smul_eq_mul, s0]
  have hcpow :
      ((Real.exp (-u) : ℂ) ^ (((1 / 2 : ℝ) : ℂ) - 1)) =
        (Real.exp (u / 2) : ℂ) := by
    rw [Complex.ofReal_cpow hp.le]
    norm_cast
    rw [Real.rpow_def_of_pos hp]
    rw [Real.log_exp]
    rw [← Real.exp_neg]
    congr 1
    ring
  rw [hcpow]
  norm_cast
  rw [← Real.exp_add]
  congr 2
  ring

/-- The L1 producer required by the old pointwise Fourier integral is unconditional. -/
theorem criticalLogPullbackIntegrable_realized :
    CriticalLogPullbackIntegrable := by
  intro N c
  exact criticalLogPullback_integrable c

/-- The critical logarithmic pullback belongs to L2. -/
theorem criticalLogPullback_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (criticalLogPullback c) 2 volume := by
  apply (memLp_two_iff_integrable_sq_norm
    (criticalLogPullback_measurable c).aestronglyMeasurable).2
  simpa [Complex.normSq_eq_norm_sq] using
    criticalLogPullback_normSq_integrable c

/-- The local L2 producer required by D3.2 is unconditional. -/
theorem criticalLogPullbackMemL2_realized :
    CriticalLogPullbackMemL2 := by
  intro N c
  exact criticalLogPullback_memLp_two c

#print axioms MCore.RH.R0.criticalLogPullback_integrable
#print axioms MCore.RH.R0.criticalLogPullbackIntegrable_realized
#print axioms MCore.RH.R0.criticalLogPullback_memLp_two
#print axioms MCore.RH.R0.criticalLogPullbackMemL2_realized

end MCore.RH.R0
