import MCore.RH.R0.RhoConcrete
import MCore.RH.NB.ZeroLimitFrontier

namespace MCore.RH.R2

noncomputable section

/--
Backward-dense endpoint for the concrete Riemann/Nyman--Beurling route.

This is a definition of the final mathematical target, not a theorem claiming
that the target holds.
-/
def FinalStatement : Prop :=
  MCore.RH.R0.concreteNBData.DNLimit
    MCore.RH.R0.concreteGeneratorFamily = 0

/--
The unique internal open bridge after collapsing the already-certified wiring:
the concrete squared projection defect tends to zero.
-/
def OpenBridge : Prop :=
  MCore.RH.R0.concreteNBData.DNToZero
    MCore.RH.R0.concreteGeneratorFamily

/--
The backward-dense compression itself is already certified wiring: the
concrete DN sequence tends to zero iff its frozen canonical limit is zero.

This theorem does not prove either side; it only reuses the frozen NB15
equivalence.
-/
theorem openBridge_iff_finalStatement :
    OpenBridge ↔ FinalStatement := by
  simpa [OpenBridge, FinalStatement] using
    (MCore.RH.NB.NBHilbertData.DNToZero_iff_DNLimit_eq_zero
      MCore.RH.R0.concreteNBData
      MCore.RH.R0.concreteGeneratorFamily)

/--
Research status as a proposition: the unresolved mathematical content is
exactly OpenBridge. The BCF combined-block estimate is an analytic route to
this proposition, not an assumption inserted here.
-/
def MaterialFrontier : Prop := OpenBridge

theorem materialFrontier_iff_openBridge :
    MaterialFrontier ↔ OpenBridge := by
  rfl

#print axioms MCore.RH.R2.openBridge_iff_finalStatement
#print axioms MCore.RH.R2.materialFrontier_iff_openBridge

end
end MCore.RH.R2
