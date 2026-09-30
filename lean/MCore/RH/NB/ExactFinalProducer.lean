import MCore.RH.NB.FinalExternal
import MCore.RH.NB.QuantitativeUpperBound

namespace MCore.RH.NB
namespace Final

/-- Exact mathematical producer for the final RH zero-limit root.
    The only new content required is an explicit nonnegative majorant eps
    dominating DN and tending to zero. -/
theorem finalExternal_of_vanishingUpperBound
    (D : NBHilbertData)
    (rho : D.GeneratorFamily)
    (h : D.VanishingUpperBound rho) :
    FinalExternalCertificate D rho :=
  D.DNToZero_of_vanishingUpperBound rho h

theorem finalRoot_of_vanishingUpperBound
    (D : NBHilbertData)
    (rho : D.GeneratorFamily)
    (h : D.VanishingUpperBound rho) :
    FINAL_ROOT D rho :=
  finalExternal_to_FINAL_ROOT D rho
    (finalExternal_of_vanishingUpperBound D rho h)

#print axioms MCore.RH.NB.Final.finalExternal_of_vanishingUpperBound
#print axioms MCore.RH.NB.Final.finalRoot_of_vanishingUpperBound

end Final
end MCore.RH.NB
