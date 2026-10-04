import MCore.RH.Analytic.MellinPlancherelReduction
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.FourierTransform

namespace MCore.RH.R0

open MeasureTheory Complex

noncomputable def logPullback (f : ℝ → ℂ) (u : ℝ) : ℂ :=
  Real.exp (-u / 2) * f (Real.exp (-u))

/-- L2 norm preservation under x = exp(-u). -/
def LogPullbackIsometry : Prop :=
  ∀ f : ℝ → ℂ,
    MemLp f 2 zeroInfinityMeasure →
      (∫ x : ℝ in Set.Ioi 0, ‖f x‖ ^ 2) =
        ∫ u : ℝ, ‖logPullback f u‖ ^ 2

/-- Fourier Plancherel on exactly the log-pullback class needed by Mellin. -/
def FourierPlancherelForLogPullback : Prop :=
  ∀ f : ℝ → ℂ,
    MemLp f 2 zeroInfinityMeasure →
      (∫ u : ℝ, ‖logPullback f u‖ ^ 2) =
        ∫ ξ : ℝ, ‖𝓕 (logPullback f) ξ‖ ^ 2

/-- Reparameterization from Fourier frequency ξ to Mellin height t = 2πξ. -/
def CriticalFrequencyScaling : Prop :=
  ∀ f : ℝ → ℂ,
    MemLp f 2 zeroInfinityMeasure →
      (∫ ξ : ℝ, ‖𝓕 (logPullback f) ξ‖ ^ 2) =
        (1 / (2 * Real.pi)) *
          ∫ t : ℝ, ‖mellin f (criticalLine t)‖ ^ 2

theorem mellinPlancherel_of_three_laws
    (hlog : LogPullbackIsometry)
    (hfourier : FourierPlancherelForLogPullback)
    (hscale : CriticalFrequencyScaling) :
    MellinPlancherelProducer := by
  intro f hf
  calc
    (∫ x : ℝ in Set.Ioi 0, ‖f x‖ ^ 2)
        = ∫ u : ℝ, ‖logPullback f u‖ ^ 2 := hlog f hf
    _ = ∫ ξ : ℝ, ‖𝓕 (logPullback f) ξ‖ ^ 2 := hfourier f hf
    _ = (1 / (2 * Real.pi)) *
          ∫ t : ℝ, ‖mellin f (criticalLine t)‖ ^ 2 := hscale f hf

#print axioms MCore.RH.R0.mellinPlancherel_of_three_laws

end MCore.RH.R0
