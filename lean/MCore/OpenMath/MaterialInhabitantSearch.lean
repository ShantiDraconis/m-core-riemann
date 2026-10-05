import MCore.OpenMath.ForcingKernel

namespace MCore.OpenMath.RH

open MCore.RH.NB

example (D : NBHilbertData) (rho : D.GeneratorFamily) :
    FirstRealOpenMath D rho := by
  unfold FirstRealOpenMath
  unfold NBHilbertData.FiniteSpanApproximatesChi
  intro ε hε

end MCore.OpenMath.RH
