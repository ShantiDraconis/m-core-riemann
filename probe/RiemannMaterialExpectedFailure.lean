import MCore.RH.NB.ZeroLimitFrontier

namespace MCore.RH.NB.MaterialProbe

/-
EXPECTED-FAILURE TARGET:
produce DNToZero from the concrete arithmetic construction, without assuming
DNToZero, DNLimit = 0, FiniteSpanApproximatesChi, or a vanishing upper bound.
This file records the exact target only; it deliberately supplies no oracle.
-/

def MaterialTarget (D : NBHilbertData) (rho : D.GeneratorFamily) : Prop :=
  D.DNToZero rho

end MCore.RH.NB.MaterialProbe
