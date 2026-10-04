import MCore.RH.Analytic.FourierCompatibilityReduction
import MCore.RH.Analytic.LogResidualIsometry
import MCore.RH.Analytic.ResidualMellin
import Mathlib.MeasureTheory.Integral.IntegralEqImproper
import Mathlib.MeasureTheory.Function.L2Space

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- The literal real residual is L2 in the frozen positive-half-line measure. -/
theorem residualRepresentativeR_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (residualRepresentativeR c) 2 zeroInfinityMeasure := by
  have hcarrier :
      MemLp
        ((concreteNBData.chi - concreteFiniteCombination c : concreteNBData.H) : ℝ → ℝ)
        2 zeroInfinityMeasure :=
    Lp.memLp _
  exact (memLp_congr_ae (residualCarrier_coeFn_ae c)).mp hcarrier

/-- Complexification preserves the L2 residual membership. -/
theorem residualRepresentativeC_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (residualRepresentativeC c) 2 zeroInfinityMeasure := by
  have h := (residualRepresentativeR_memLp_two c).ofReal (K := ℂ)
  exact (memLp_congr_ae (Eventually.of_forall fun x =>
    residualRepresentativeC_eq_ofReal c x)).mpr h

/-- The squared modulus of the residual is integrable on the positive half-line. -/
theorem residual_normSq_integrableOn
    {N : ℕ} (c : Fin N → ℝ) :
    IntegrableOn
      (fun x : ℝ => Complex.normSq (residualRepresentativeC c x))
      (Ioi 0) volume := by
  have h2 := residualRepresentativeC_memLp_two c
  have hsquare :
      Integrable
        (fun x : ℝ => ‖residualRepresentativeC c x‖ ^ 2)
        zeroInfinityMeasure :=
    (memLp_two_iff_integrable_sq_norm h2.aestronglyMeasurable).mp h2
  simpa [zeroInfinityMeasure, IntegrableOn, Complex.normSq_eq_norm_sq] using hsquare

/-- Mellin convergence at 1/2 gives the weighted L1 norm needed in log coordinates. -/
theorem residual_half_weight_norm_integrableOn
    {N : ℕ} (c : Fin N → ℝ) :
    IntegrableOn
      (fun x : ℝ => x ^ (-(1 / 2 : ℝ)) * ‖residualRepresentativeC c x‖)
      (Ioi 0) volume := by
  let s : ℂ := ((1 / 2 : ℝ) : ℂ)
  have hs0 : 0 < s.re := by norm_num [s]
  have hs1 : s.re < 1 := by norm_num [s]
  have hconv := residualRepresentativeC_mellinConvergent c s hs0 hs1
  unfold MellinConvergent at hconv
  have hmeas :
      AEStronglyMeasurable (residualRepresentativeC c)
        (volume.restrict (Ioi 0)) :=
    (hconv.aestronglyMeasurable)
  have hnorm :=
    (mellin_convergent_iff_norm Subset.rfl measurableSet_Ioi hmeas).mp hconv
  simpa [s] using hnorm

/-- The logarithmic residual is integrable on the full real line. -/
theorem logResidualC_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (logResidualC c) volume := by
  have hhalf := residual_half_weight_norm_integrableOn c
  have hexp :
      Integrable
        (fun v : ℝ =>
          Real.exp v *
            ((Real.exp v) ^ (-(1 / 2 : ℝ)) *
              ‖residualRepresentativeC c (Real.exp v)‖)) :=
    (integrable_comp_exp
      (fun x : ℝ => x ^ (-(1 / 2 : ℝ)) *
        ‖residualRepresentativeC c x‖)).2 hhalf
  have hnegNorm :
      Integrable (fun v : ℝ => ‖logResidualC c (-v)‖) volume := by
    apply hexp.congr_fun
    intro v
    have hev : 0 < Real.exp v := Real.exp_pos _
    rw [logResidualC, norm_mul, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _)]
    rw [show -(-v) / 2 = v / 2 by ring]
    rw [Real.rpow_neg hev.le]
    rw [show (1 / 2 : ℝ) = (2 : ℝ)⁻¹ by norm_num]
    rw [← Real.exp_mul, ← Real.exp_mul]
    field_simp
    ring
  have hnorm : Integrable (fun u : ℝ => ‖logResidualC c u‖) volume := by
    exact (integrable_comp_mul_left_iff
      (fun u : ℝ => ‖logResidualC c u‖) (by norm_num : (-1 : ℝ) ≠ 0)).mp
      (by simpa [mul_comm] using hnegNorm)
  exact (integrable_norm_iff
    (by fun_prop : AEStronglyMeasurable (logResidualC c) volume)).mp hnorm

/-- Squared modulus of the logarithmic residual is integrable. -/
theorem logResidualC_normSq_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (fun u : ℝ => Complex.normSq (logResidualC c u)) volume := by
  have hsq := residual_normSq_integrableOn c
  have hexp :
      Integrable
        (fun v : ℝ => Real.exp v *
          Complex.normSq (residualRepresentativeC c (Real.exp v))) :=
    (integrable_comp_exp
      (fun x : ℝ => Complex.normSq (residualRepresentativeC c x))).2 hsq
  have hneg :
      Integrable
        (fun v : ℝ => Complex.normSq (logResidualC c (-v))) volume := by
    apply hexp.congr_fun
    intro v
    rw [logResidualC, Complex.normSq_mul]
    simp [Complex.normSq_apply]
    rw [← Real.exp_add]
    congr 1
    ring
  exact (integrable_comp_mul_left_iff
    (fun u : ℝ => Complex.normSq (logResidualC c u))
    (by norm_num : (-1 : ℝ) ≠ 0)).mp
    (by simpa using hneg)

/-- The logarithmic residual belongs to L2. -/
theorem logResidualC_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (logResidualC c) 2 volume := by
  rw [memLp_two_iff_integrable_sq_norm (by fun_prop)]
  simpa [Complex.normSq_eq_norm_sq] using logResidualC_normSq_integrable c

/-- Full L1∩L2 membership producer for every finite residual. -/
theorem logResidualL1L2Producer_realized : LogResidualL1L2Producer := by
  intro N c
  exact ⟨⟨logResidualC_integrable c, logResidualC_memLp_two c⟩⟩

#print axioms MCore.RH.R0.logResidualC_integrable
#print axioms MCore.RH.R0.logResidualC_memLp_two
#print axioms MCore.RH.R0.logResidualL1L2Producer_realized

end MCore.RH.R0
