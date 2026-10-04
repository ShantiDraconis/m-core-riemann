import MCore.RH.Analytic.MellinPlancherelReduction
import MCore.RH.R0.LpToAE
import MCore.RH.R0.GramIntegral
import Mathlib.MeasureTheory.Function.L2Space

open scoped BigOperators

namespace MCore.RH.R0

open MCore.RH.NB
open MeasureTheory Set Complex

/-- The Hilbert residual has the literal real residual as an a.e. representative. -/
theorem concreteResidual_coeFn_ae
    {N : ℕ} (c : Fin N → ℝ) :
    ((concreteNBData.chi -
        concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c :
        concreteNBData.H) : ℝ → ℝ)
      =ᵐ[zeroInfinityMeasure]
    (fun x : ℝ =>
      chiRepresentative x -
        ∑ i : Fin N, c i * rhoRepresentative i x) := by
  have happrox :
      concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c =
        concreteFiniteCombination c := by
    rfl
  rw [happrox]
  filter_upwards [
    Lp.coeFn_sub concreteNBData.chi (concreteFiniteCombination c),
    concreteChi_coeFn_ae,
    concreteFiniteCombination_coeFn_ae c] with x hsub hchi hcomb
  rw [hsub, hchi, hcomb]

/-- Pointwise identification of the real residual square with complex normSq. -/
theorem realResidual_sq_eq_complex_normSq
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) :
    (chiRepresentative x -
      ∑ i : Fin N, c i * rhoRepresentative i x) ^ 2 =
      Complex.normSq (residualRepresentativeC c x) := by
  unfold residualRepresentativeC rhoCombinationC chiRepresentativeC rhoRepresentativeC
  push_cast
  rw [Complex.normSq_apply]
  simp
  ring

/-- D3 bridge 1 realized: L2 residual norm equals the literal residual integral. -/
theorem residualL2IntegralIdentity_realized :
    ResidualL2IntegralIdentity := by
  intro N c
  change
    ‖concreteNBData.chi -
      concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c‖ ^ 2 =
      ∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)
  rw [← real_inner_self_eq_norm_sq]
  rw [MeasureTheory.L2.inner_def]
  change
    (∫ x : ℝ,
      @inner ℝ ℝ _ _
        ((concreteNBData.chi -
          concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c :
          concreteNBData.H) x)
        ((concreteNBData.chi -
          concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c :
          concreteNBData.H) x)
      ∂zeroInfinityMeasure) =
      ∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)
  rw [show zeroInfinityMeasure = volume.restrict (Ioi 0) by
    rfl]
  apply integral_congr_ae
  filter_upwards [concreteResidual_coeFn_ae c] with x hx
  rw [hx]
  simp only [real_inner_self_eq_norm_sq, Real.norm_eq_abs, sq_abs]
  exact realResidual_sq_eq_complex_normSq c x

#print axioms MCore.RH.R0.concreteResidual_coeFn_ae
#print axioms MCore.RH.R0.realResidual_sq_eq_complex_normSq
#print axioms MCore.RH.R0.residualL2IntegralIdentity_realized

end MCore.RH.R0
