import MCore.RH.Analytic.LogPullbackL1
import Mathlib.Analysis.Fourier.LpSpace

namespace MCore.RH.R0

open MeasureTheory

/--
Classical L1-intersection-L2 compatibility statement for Fourier.

Mathlib constructs the L2 Fourier transform by dense extension from Schwartz
functions, but does not currently expose this compatibility as a one-line theorem.
This is a formalization bridge, not an RH-specific mathematical assumption.
-/
def L1L2FourierCompatibility : Prop :=
  ∀ (f : ℝ → ℂ) (h1 : MemLp f 1 volume) (h2 : MemLp f 2 volume),
    ∃ hF : MemLp (𝓕 f) 2 volume,
      hF.toLp (𝓕 f) = 𝓕 (h2.toLp f)

/-- The natural embedding of L2 into tempered distributions is injective. -/
theorem l2_toTemperedDistribution_injective :
    Function.Injective
      (MeasureTheory.Lp.toTemperedDistributionCLM ℂ volume 2 :
        Lp ℂ 2 volume →L[ℂ] SchwartzMap.TemperedDistribution ℝ ℂ) := by
  rw [← LinearMap.ker_eq_bot']
  simpa using
    (MeasureTheory.Lp.ker_toTemperedDistributionCLM_eq_bot
      (E := ℝ) (F := ℂ) (μ := volume) (p := 2))

/--
For our residual, the only missing representative step is the generic
L1-intersection-L2 Fourier compatibility theorem.
-/
def ResidualFourierRepresentativeBridge : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    ∃ hF : MemLp
        (𝓕 (logPullback (residualRepresentativeC c))) 2 volume,
      hF.toLp (𝓕 (logPullback (residualRepresentativeC c))) =
        𝓕 ((residual_logPullback_memLp_two c).toLp
          (logPullback (residualRepresentativeC c)))

theorem residualFourierBridge_of_L1L2
    (h : L1L2FourierCompatibility) :
    ResidualFourierRepresentativeBridge := by
  intro N c
  exact h
    (logPullback (residualRepresentativeC c))
    (residual_logPullback_memLp_one c)
    (residual_logPullback_memLp_two c)

#print axioms MCore.RH.R0.l2_toTemperedDistribution_injective
#print axioms MCore.RH.R0.residualFourierBridge_of_L1L2

end MCore.RH.R0
