import MCore.RH.Analytic.D3LogLiftIsometry

namespace MCore.RH.R0

open MeasureTheory Complex Real
open scoped FourierTransform

/--
The pinned Mathlib commit predates the bundled L² Fourier isometry.
This proposition is a library-level theorem, not an RH-specific assumption.
-/
def PinnedFourierPlancherelGap : Prop :=
  ResidualFourierPlancherel

/--
Once the pinned-library Plancherel theorem is supplied, D3 is fully realized.
All other D3 transformations are already explicit source theorems.
-/
theorem residualMellinPlancherel_of_pinned_gap
    (hF : PinnedFourierPlancherelGap) :
    ResidualMellinPlancherel := by
  exact residualMellinPlancherel_of_fourier
    residualLogLiftIsometry_realized
    hF
    residualCriticalFrequencyScaling_realized

theorem d3ResidualSpectralIdentity_of_pinned_gap
    (hF : PinnedFourierPlancherelGap) :
    D3ResidualSpectralIdentity := by
  exact d3_of_mellinPlancherel
    (residualMellinPlancherel_of_pinned_gap hF)

#print axioms MCore.RH.R0.residualMellinPlancherel_of_pinned_gap
#print axioms MCore.RH.R0.d3ResidualSpectralIdentity_of_pinned_gap

end MCore.RH.R0
