import MCore.RH.R0.RhoConcrete
import MCore.RH.NB.ZeroLimitFrontier
import Mathlib.NumberTheory.LSeries.RiemannZeta

namespace MCore.RH.R2

noncomputable section

/--
The actual final statement of the repository.

This is only a definition of the Riemann hypothesis already provided by the
pinned Mathlib. No inhabitant/proof is asserted here.
-/
def FinalStatement : Prop :=
  RiemannHypothesis

/--
The compressed internal endpoint supplied by the frozen Nyman--Beurling
distance/limit machinery.
-/
def CompressedEndpoint : Prop :=
  MCore.RH.R0.concreteNBData.DNLimit
    MCore.RH.R0.concreteGeneratorFamily = 0

/--
The unique internal open bridge after collapsing the already-certified Lean
wiring: the concrete squared projection defect tends to zero.
-/
def OpenBridge : Prop :=
  MCore.RH.R0.concreteNBData.DNToZero
    MCore.RH.R0.concreteGeneratorFamily

/--
Formal shape of the R1 external interface. Defining this proposition does not
assume it and does not create a project axiom.
-/
def R1ExternalBridge : Prop :=
  CompressedEndpoint ↔ FinalStatement

/--
Frozen NB15 wiring: the internal open bridge is exactly the compressed
DNLimit endpoint. This theorem proves neither side.
-/
theorem openBridge_iff_compressedEndpoint :
    OpenBridge ↔ CompressedEndpoint := by
  simpa [OpenBridge, CompressedEndpoint] using
    (MCore.RH.NB.NBHilbertData.DNToZero_iff_DNLimit_eq_zero
      MCore.RH.R0.concreteNBData
      MCore.RH.R0.concreteGeneratorFamily)

/--
If the separately audited R1 external equivalence is supplied as a hypothesis,
then the compressed Lean wiring composes to the actual final statement.

The external criterion remains explicit in the theorem hypothesis; it is not
introduced as an axiom or theorem of this file.
-/
theorem openBridge_iff_finalStatement_of_r1
    (hR1 : R1ExternalBridge) :
    OpenBridge ↔ FinalStatement := by
  exact openBridge_iff_compressedEndpoint.trans hR1

/--
Generic backward-dense closing lemma.

Any explicit real majorant eps_N which dominates the concrete finite defect
DN_N at every stage and tends to zero forces the internal open bridge.

This theorem is pure order/topology wiring. It does not construct such a
majorant; supplying one unconditionally is exactly the remaining mathematics.
-/
theorem openBridge_of_upper_tendsto_zero
    (eps : ℕ → ℝ)
    (hupper :
      ∀ N : ℕ,
        MCore.RH.R0.concreteNBData.DN
          MCore.RH.R0.concreteGeneratorFamily N ≤ eps N)
    (heps : Filter.Tendsto eps Filter.atTop (nhds 0)) :
    OpenBridge := by
  unfold OpenBridge MCore.RH.NB.NBHilbertData.DNToZero
  exact squeeze_zero
    (fun N =>
      MCore.RH.R0.concreteNBData.DN_nonneg
        MCore.RH.R0.concreteGeneratorFamily N)
    hupper
    heps

/--
The internal falsity endpoint: the certified nonnegative DN limit is strictly
positive. This is a definition only; no claim that it holds is made.
-/
def FalseEndpoint : Prop :=
  0 <
    MCore.RH.R0.concreteNBData.DNLimit
      MCore.RH.R0.concreteGeneratorFamily

/--
Because the frozen DN limit is nonnegative, failure of the compressed zero
endpoint is exactly strict positivity of that limit.
-/
theorem not_compressedEndpoint_iff_falseEndpoint :
    (¬ CompressedEndpoint) ↔ FalseEndpoint := by
  unfold CompressedEndpoint FalseEndpoint
  constructor
  · intro hne
    exact lt_of_le_of_ne
      (MCore.RH.R0.concreteNBData.DNLimit_nonneg
        MCore.RH.R0.concreteGeneratorFamily)
      (Ne.symm hne)
  · intro hpos hzero
    exact (ne_of_gt hpos) hzero

/--
The true and false internal endpoints are exact complements.
-/
theorem falseEndpoint_iff_not_openBridge :
    FalseEndpoint ↔ ¬ OpenBridge := by
  constructor
  · intro hfalse hopen
    exact (not_compressedEndpoint_iff_falseEndpoint.mpr hfalse)
      (openBridge_iff_compressedEndpoint.mp hopen)
  · intro hnot
    apply not_compressedEndpoint_iff_falseEndpoint.mp
    intro hcompressed
    exact hnot (openBridge_iff_compressedEndpoint.mpr hcompressed)

/--
Conditional false-lane composition through the explicit R1 external
interface. Again, R1 is a theorem hypothesis, not a project axiom.
-/
theorem falseEndpoint_iff_not_finalStatement_of_r1
    (hR1 : R1ExternalBridge) :
    FalseEndpoint ↔ ¬ FinalStatement := by
  exact not_compressedEndpoint_iff_falseEndpoint.symm.trans (not_congr hR1)

/--
Research status proposition: the unresolved internal mathematical content is
OpenBridge. The BCF combined-block estimate is a proposed analytic route to
this proposition, not an assumption inserted here.
-/
def MaterialFrontier : Prop := OpenBridge

theorem materialFrontier_iff_openBridge :
    MaterialFrontier ↔ OpenBridge := by
  rfl

#print axioms MCore.RH.R2.openBridge_iff_compressedEndpoint
#print axioms MCore.RH.R2.openBridge_iff_finalStatement_of_r1
#print axioms MCore.RH.R2.openBridge_of_upper_tendsto_zero
#print axioms MCore.RH.R2.not_compressedEndpoint_iff_falseEndpoint
#print axioms MCore.RH.R2.falseEndpoint_iff_not_openBridge
#print axioms MCore.RH.R2.falseEndpoint_iff_not_finalStatement_of_r1
#print axioms MCore.RH.R2.materialFrontier_iff_openBridge

end
end MCore.RH.R2
