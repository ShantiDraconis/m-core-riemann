import MCore.RH.Analytic.MellinPlancherelBridges
import MCore.RH.R0.GramIntegral
import MCore.RH.R0.LpToAE
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Real-valued representative of the concrete finite residual. -/
noncomputable def realResidualRepresentative
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℝ :=
  chiRepresentative x - ∑ i : Fin N, c i * rhoRepresentative i x

/-- The Hilbert residual has the literal real residual as an a.e. representative. -/
theorem concreteResidual_coeFn_ae
    {N : ℕ} (c : Fin N → ℝ) :
    ((concreteNBData.chi - concreteFiniteCombination c : concreteNBData.H) : ℝ → ℝ)
      =ᵐ[zeroInfinityMeasure] realResidualRepresentative c := by
  filter_upwards [
    Lp.coeFn_sub concreteNBData.chi (concreteFiniteCombination c),
    concreteChi_coeFn_ae,
    concreteFiniteCombination_coeFn_ae c] with x hsub hchi hcomb
  rw [hsub, hchi, hcomb]
  rfl

/-- L2 norm squared of the residual as a literal set integral on (0,infinity). -/
theorem concreteResidual_norm_sq_eq_integral
    {N : ℕ} (c : Fin N → ℝ) :
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      ∫ x : ℝ in Ioi 0, (realResidualRepresentative c x) ^ 2 := by
  rw [← real_inner_self_eq_norm_sq]
  rw [MeasureTheory.L2.inner_def]
  apply integral_congr_ae
  filter_upwards [concreteResidual_coeFn_ae c] with x hx
  rw [hx]
  simp [real_inner_eq_mul, pow_two, zeroInfinityMeasure]

/-- Complex residual is exactly the complexification of the real residual. -/
theorem residualRepresentativeC_eq_real
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) :
    residualRepresentativeC c x = (realResidualRepresentative c x : ℂ) := by
  simp [residualRepresentativeC, rhoCombinationC, realResidualRepresentative,
    chiRepresentativeC, rhoRepresentativeC]
  push_cast
  ring

/-- Pointwise squared norm of the logarithmic pullback. -/
theorem normSq_residualLogPullback
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) :
    normSq (residualLogPullback c u) =
      Real.exp (-u) * (realResidualRepresentative c (Real.exp (-u))) ^ 2 := by
  rw [residualLogPullback, residualRepresentativeC_eq_real]
  rw [normSq_mul]
  simp
  ring

/-- The logarithmic pullback is exactly an L2 isometry. -/
theorem residualLogPullbackIsometry_realized :
    ResidualLogPullbackIsometry := by
  intro N c
  rw [concreteResidual_norm_sq_eq_integral c]
  have hneg :
      (∫ u : ℝ,
        Real.exp (-u) * (realResidualRepresentative c (Real.exp (-u))) ^ 2) =
      ∫ v : ℝ,
        Real.exp v * (realResidualRepresentative c (Real.exp v)) ^ 2 := by
    have h := MeasureTheory.Measure.integral_comp_mul_left
      (fun v : ℝ =>
        Real.exp v * (realResidualRepresentative c (Real.exp v)) ^ 2)
      (-1 : ℝ)
    simpa using h
  rw [show (∫ u : ℝ, normSq (residualLogPullback c u)) =
      ∫ u : ℝ,
        Real.exp (-u) * (realResidualRepresentative c (Real.exp (-u))) ^ 2 by
      apply integral_congr_ae
      filter_upwards with u
      exact normSq_residualLogPullback c u]
  rw [hneg]
  simpa [smul_eq_mul] using
    (integral_comp_exp (fun x : ℝ => (realResidualRepresentative c x) ^ 2))

#print axioms MCore.RH.R0.concreteResidual_norm_sq_eq_integral
#print axioms MCore.RH.R0.residualLogPullbackIsometry_realized

end MCore.RH.R0
