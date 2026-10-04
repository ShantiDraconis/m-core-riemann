import MCore.RH.Analytic.FourierPlancherelBridge
import MCore.RH.Analytic.LogResidualIsometry

namespace MCore.RH.R0

/--
All metric content of D3 is closed once the single Fourier representation
compatibility is supplied. The logarithmic coordinate change is already realized,
and Mathlib supplies the L2 Fourier isometry.
-/
theorem mellinPlancherelFrequencyBridge_of_fourierCompatibility
    (hcompat : FourierIntegralLpCompatibility) :
    MellinPlancherelFrequencyBridge := by
  exact ⟨logResidualIsometry_realized,
    classicalFourierPlancherel_of_compatibility hcompat⟩

/--
The exact remaining representation statement. This is deliberately not wrapped
in a broader Plancherel assumption.
-/
def D3FourierRepresentationGap : Prop :=
  FourierIntegralLpCompatibility

theorem d3_fourier_gap_suffices
    (h : D3FourierRepresentationGap) :
    MellinPlancherelFrequencyBridge :=
  mellinPlancherelFrequencyBridge_of_fourierCompatibility h

#print axioms MCore.RH.R0.mellinPlancherelFrequencyBridge_of_fourierCompatibility
#print axioms MCore.RH.R0.d3_fourier_gap_suffices

end MCore.RH.R0
