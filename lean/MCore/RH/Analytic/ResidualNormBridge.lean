import MCore.RH.Analytic.MellinPlancherelReduction
import MCore.RH.R0.GramIntegral
import Mathlib.MeasureTheory.Function.L2Space

namespace MCore.RH.R0

open MeasureTheory Set

/-- The frozen Hilbert residual has the expected literal real representative a.e. -/
theorem residualLp_coeFn_ae
    {N : ℕ} (c : Fin N → ℝ) :
    ((concreteNBData.chi - concreteFiniteCombination c : concreteNBData.H) : ℝ → ℝ)
      =ᵐ[zeroInfinityMeasure]
    (fun x : ℝ =>
      chiRepresentative x -
        ∑ i : Fin N, c i * rhoRepresentative i x) := by
  filter_upwards [
    Lp.coeFn_sub concreteNBData.chi (concreteFiniteCombination c),
    concreteChi_coeFn_ae,
    concreteFiniteCombination_coeFn_ae c] with x hsub hchi hcomb
  rw [hsub, hchi, hcomb]
  rfl

/-- Complex residual is just the real residual embedded into C. -/
theorem residualRepresentativeC_eq_ofReal
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) :
    residualRepresentativeC c x =
      ((chiRepresentative x -
        ∑ i : Fin N, c i * rhoRepresentative i x : ℝ) : ℂ) := by
  unfold residualRepresentativeC chiRepresentativeC rhoLinearCombinationC rhoRepresentativeC
  push_cast
  ring

/-- D3a: norm of the frozen L2 residual equals the literal representative integral. -/
theorem residualRepresentativeNormBridge_realized :
    ResidualRepresentativeNormBridge := by
  intro N c
  rw [← real_inner_self_eq_norm_sq]
  rw [MeasureTheory.L2.inner_def]
  apply integral_congr_ae
  filter_upwards [residualLp_coeFn_ae c] with x hx
  rw [hx]
  rw [residualRepresentativeC_eq_ofReal c x]
  simp [Complex.normSq_ofReal]
  ring

#print axioms MCore.RH.R0.residualLp_coeFn_ae
#print axioms MCore.RH.R0.residualRepresentativeNormBridge_realized

end MCore.RH.R0
