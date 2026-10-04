import MCore.RH.Analytic.FourierCompatibilityReduction
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.Analysis.Distribution.AEEqOfIntegralContDiff
import Mathlib.Analysis.Distribution.TemperedDistribution

namespace MCore.RH.R0

open MeasureTheory
open scoped FourierTransform

/-- Classical Fourier transform of an L1 function is locally integrable. -/
def ClassicalFourierLocallyIntegrable : Prop :=
  ∀ (f : ℝ → ℂ), Integrable f volume →
    LocallyIntegrable (fun y : ℝ => 𝓕 f y) volume

/--
The exact missing Fubini/duality identity: the classical Fourier integral
of an L1 function represents the Fourier transform of its associated
tempered distribution when tested against Schwartz functions.
-/
def L1FourierTemperedPairing : Prop :=
  ∀ (f : ℝ → ℂ), Integrable f volume →
    ∀ g : SchwartzMap ℝ ℂ,
      (∫ y : ℝ, g y * 𝓕 f y) =
        ∫ x : ℝ, (𝓕 g) x * f x

/-- Mathlib already supplies the L2-distributional Fourier compatibility. -/
theorem l2FourierTemperedCompatibility_closed
    (F : Lp ℂ 2 volume) :
    𝓕 (F : TemperedDistribution ℝ ℂ) =
      ((MeasureTheory.Lp.fourierTransformₗᵢ ℝ ℂ) F : Lp ℂ 2 volume) := by
  exact MeasureTheory.Lp.fourier_toTemperedDistribution_eq F

/--
After local integrability and the pairing identity, uniqueness of locally
integrable representatives is the only logical step required to recover
the a.e. equality used by L1L2FourierCompatibility.
-/
def FourierRepresentativeUniquenessStep : Prop :=
  ∀ (f : ℝ → ℂ) (hf1 : Integrable f volume) (hf2 : MemLp f 2 volume),
    (∀ g : SchwartzMap ℝ ℂ,
      (∫ y : ℝ, g y * 𝓕 f y) =
        ∫ x : ℝ, (𝓕 g) x * f x) →
    (((MeasureTheory.Lp.fourierTransformₗᵢ ℝ ℂ) (hf2.toLp f) : ℝ → ℂ)
      =ᵐ[volume] fun y : ℝ => 𝓕 f y)

/-- Exact narrowed generic frontier for D3. -/
def D3GenericFourierCore : Prop :=
  ClassicalFourierLocallyIntegrable ∧
  L1FourierTemperedPairing ∧
  FourierRepresentativeUniquenessStep

theorem l1l2FourierCompatibility_of_core
    (hcore : D3GenericFourierCore) :
    L1L2FourierCompatibility := by
  intro f hf1 hf2
  exact hcore.2.2 f hf1 hf2 (hcore.2.1 f hf1)

#print axioms MCore.RH.R0.l2FourierTemperedCompatibility_closed
#print axioms MCore.RH.R0.l1l2FourierCompatibility_of_core

end MCore.RH.R0
