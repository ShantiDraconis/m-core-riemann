import MCore.RH.Analytic.FourierCompatibilityReduction
import MCore.RH.Analytic.LogResidualMembership

namespace MCore.RH.R0

/-- The RH residual-specific Fourier bridge now depends only on the generic L1∩L2 theorem. -/
theorem fourierIntegralLpCompatibility_of_generic
    (hcompat : L1L2FourierCompatibility) :
    FourierIntegralLpCompatibility :=
  fourierIntegralLpCompatibility_of_L1L2
    logResidualL1L2Producer_realized hcompat

#print axioms MCore.RH.R0.fourierIntegralLpCompatibility_of_generic

end MCore.RH.R0
