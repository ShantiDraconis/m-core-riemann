import MCore.RH.Analytic.LogResidualMembership
import MCore.RH.Analytic.MellinPlancherelDecomposition
import MCore.RH.Analytic.ResidualMellin

namespace MCore.RH.R0

open MeasureTheory

/-- Exact membership package needed before invoking the Fourier compatibility theorem. -/
structure LogResidualL1L2Data (N : ℕ) (c : Fin N → ℝ) where
  integrable : Integrable (logResidualC c) volume
  memL2 : MemLp (logResidualC c) 2 volume

/-- Membership producer for every finite residual. -/
def LogResidualL1L2Producer : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ), Nonempty (LogResidualL1L2Data N c)

/--
Generic Fourier representation theorem actually missing from the current Mathlib API:
an L1∩L2 function has classical Fourier integral equal a.e. to the L2 Fourier extension.
-/
def L1L2FourierCompatibility : Prop :=
  ∀ (f : ℝ → ℂ), Integrable f volume → MemLp f 2 volume →
    ((MeasureTheory.Lp.fourierTransformₗᵢ ℝ ℂ)
        ((show MemLp f 2 volume from ‹MemLp f 2 volume›).toLp f) : ℝ → ℂ)
      =ᵐ[volume] fun y : ℝ => 𝓕 f y

/-- The two narrow producers imply the previous D3 compatibility wrapper. -/
theorem fourierIntegralLpCompatibility_of_L1L2
    (hmem : LogResidualL1L2Producer)
    (hcompat : L1L2FourierCompatibility) :
    FourierIntegralLpCompatibility := by
  intro N c
  rcases hmem N c with ⟨d⟩
  exact ⟨d.memL2, hcompat (logResidualC c) d.integrable d.memL2⟩

/-- The residual-specific Fourier wrapper now depends only on the generic L1∩L2 theorem. -/
theorem fourierIntegralLpCompatibility_of_generic
    (hcompat : L1L2FourierCompatibility) :
    FourierIntegralLpCompatibility :=
  fourierIntegralLpCompatibility_of_L1L2
    logResidualL1L2Producer_realized hcompat

#print axioms MCore.RH.R0.fourierIntegralLpCompatibility_of_L1L2
#print axioms MCore.RH.R0.fourierIntegralLpCompatibility_of_generic

end MCore.RH.R0
