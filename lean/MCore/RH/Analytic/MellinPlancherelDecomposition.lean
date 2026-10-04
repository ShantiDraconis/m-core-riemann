import MCore.RH.Analytic.ResidualPlancherelReduction
import MCore.RH.R0.GramIntegral
import MCore.RH.R0.LpToAE
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.LpSpace

namespace MCore.RH.R0

open MeasureTheory Set Complex
open MCore.RH.NB
open scoped BigOperators FourierTransform

/-- Real residual representative attached to a finite coefficient vector. -/
noncomputable def residualRepresentativeR
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℝ :=
  chiRepresentative x - ∑ i : Fin N, c i * rhoRepresentative i x

/-- The Hilbert residual has the literal real residual as an a.e. representative. -/
theorem residualCarrier_coeFn_ae
    {N : ℕ} (c : Fin N → ℝ) :
    ((concreteNBData.chi - concreteFiniteCombination c : concreteNBData.H) : ℝ → ℝ)
      =ᵐ[zeroInfinityMeasure] residualRepresentativeR c := by
  filter_upwards [
    Lp.coeFn_sub concreteNBData.chi (concreteFiniteCombination c),
    concreteChi_coeFn_ae,
    concreteFiniteCombination_coeFn_ae c] with x hsub hchi hcomb
  rw [hsub, hchi, hcomb]
  rfl

/-- Carrier L2 norm squared as the literal residual square integral. -/
theorem residualCarrier_norm_sq_eq_integral
    {N : ℕ} (c : Fin N → ℝ) :
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      ∫ x : ℝ,
        (residualRepresentativeR c x) ^ 2 ∂zeroInfinityMeasure := by
  rw [← real_inner_self_eq_norm_sq]
  rw [MeasureTheory.L2.inner_def]
  apply integral_congr_ae
  filter_upwards [residualCarrier_coeFn_ae c] with x hx
  simp only [real_inner_eq_mul]
  rw [hx]
  ring

/-- Complex residual is just the complexification of the real residual. -/
theorem residualRepresentativeC_eq_ofReal
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) :
    residualRepresentativeC c x = (residualRepresentativeR c x : ℂ) := by
  unfold residualRepresentativeC residualRepresentativeR rhoCombinationC
  simp [chiRepresentativeC, rhoRepresentativeC]
  push_cast
  ring

/-- Pointwise squared modulus is the real residual square. -/
theorem normSq_residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) :
    Complex.normSq (residualRepresentativeC c x) =
      (residualRepresentativeR c x) ^ 2 := by
  rw [residualRepresentativeC_eq_ofReal]
  simp [Complex.normSq_apply]
  ring

/-- Log-coordinate residual used by Mellin/Fourier. -/
noncomputable def logResidualC
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) : ℂ :=
  (Real.exp (-u / 2) : ℂ) *
    residualRepresentativeC c (Real.exp (-u))

/--
Exact change-of-variable target. Once realized, this says x = exp(-u)
is an isometry between L2(dx) and the critical-line Mellin model.
-/
def LogResidualIsometry : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    (∫ u : ℝ, Complex.normSq (logResidualC c u)) =
      ∫ x : ℝ,
        Complex.normSq (residualRepresentativeC c x) ∂zeroInfinityMeasure

/--
The only genuinely Fourier-specific compatibility still needed:
for this L1∩L2 logarithmic residual, the L2 Fourier transform represented by
the Mathlib L2 Fourier isometry agrees a.e. with the classical Fourier integral.
-/
def FourierIntegralLpCompatibility : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    ∃ hL2 : MemLp (logResidualC c) 2 volume,
      ((MeasureTheory.Lp.fourierTransformₗᵢ ℝ ℂ) (hL2.toLp (logResidualC c)) : ℝ → ℂ)
        =ᵐ[volume]
      fun y : ℝ => 𝓕 (logResidualC c) y

/--
Fourier Plancherel in the exact classical-integral form needed downstream.
This is implied by FourierIntegralLpCompatibility plus Mathlib's L2 isometry.
-/
def ClassicalFourierPlancherel : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    (∫ u : ℝ, Complex.normSq (logResidualC c u)) =
      ∫ y : ℝ, Complex.normSq (𝓕 (logResidualC c) y)

/--
After these two representation bridges, the Mellin-Plancherel bridge is purely
a change of Fourier frequency y = t/(2π), with mellin_eq_fourierIntegral.
-/
def MellinPlancherelFrequencyBridge : Prop :=
  LogResidualIsometry ∧ ClassicalFourierPlancherel

#print axioms MCore.RH.R0.residualCarrier_norm_sq_eq_integral
#print axioms MCore.RH.R0.residualRepresentativeC_eq_ofReal
#print axioms MCore.RH.R0.normSq_residualRepresentativeC

end MCore.RH.R0
