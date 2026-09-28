import MCore.RH.NB.ZeroLimitFrontier

namespace MCore.RH.NB.MaterialProbe

/-
EXPECTED FAILURE TARGET.
No DNToZero, DNLimit=0, FiniteSpanApproximatesChi, or vanishing-bound oracle
is supplied.
-/

example (D : NBHilbertData) (rho : D.GeneratorFamily) : D.DNToZero rho := by

end MCore.RH.NB.MaterialProbe
