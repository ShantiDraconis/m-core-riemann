import MCore.RH.P02TerminalTransition
import MCore.RH.P02ExternalEndpoint

namespace MCore

/-!
# RPA dual confirmation certificate

The RPA certificate concerns a transition, not either endpoint in isolation.
OPEN_MATH and CLOSED_MATH are retained simultaneously as the source and target
views of one terminal identity.
-/

abbrev RPAOpenMath : Prop := Endpoint
abbrev RPAClosedMath : Prop := Endpoint

abbrev RPAOpenBridge : Prop := RPAOpenMath
abbrev RPAClosedBridge : Prop := RPAClosedMath

abbrev RPAMath : Prop := Endpoint
abbrev RPAFinalRoot : Prop := RPAMath
abbrev RPAGlobalExternalCertificate : Prop := RPAFinalRoot

structure RPADualTransitionCertificate where
  openWitness : RPAOpenMath
  closedWitness : RPAClosedMath
  openToClosed : RPAOpenMath → RPAClosedMath
  closedToOpen : RPAClosedMath → RPAOpenMath
  identityPreserved : RPAOpenMath ↔ RPAClosedMath

theorem rpa_open_closed_same_identity :
    RPAOpenMath ↔ RPAClosedMath := Iff.rfl

theorem rpa_open_bridge_same :
    RPAOpenMath ↔ RPAOpenBridge := Iff.rfl

theorem rpa_closed_bridge_same :
    RPAClosedMath ↔ RPAClosedBridge := Iff.rfl

theorem rpa_bridges_same_math :
    (RPAOpenBridge ↔ RPAMath) ∧
    (RPAClosedBridge ↔ RPAMath) := by
  exact ⟨Iff.rfl, Iff.rfl⟩

theorem rpa_math_final_root_same :
    RPAMath ↔ RPAFinalRoot := Iff.rfl

theorem rpa_final_root_global_external_same :
    RPAFinalRoot ↔ RPAGlobalExternalCertificate := Iff.rfl

theorem rpa_five_views_same_identity :
    (RPAOpenMath ↔ RPAClosedMath) ∧
    (RPAOpenBridge ↔ RPAClosedBridge) ∧
    (RPAMath ↔ RPAFinalRoot) ∧
    (RPAFinalRoot ↔ RPAGlobalExternalCertificate) := by
  exact ⟨Iff.rfl, Iff.rfl, Iff.rfl, Iff.rfl⟩

/--
The dual certificate can be built exactly when the common endpoint is
inhabited. This theorem is the precise proof-theoretic content of simultaneous
OPEN/CLOSED confirmation.
-/
theorem rpa_certificate_iff_endpoint :
    Nonempty RPADualTransitionCertificate ↔ Endpoint := by
  constructor
  · rintro ⟨c⟩
    exact c.openWitness
  · intro h
    exact ⟨{
      openWitness := h
      closedWitness := h
      openToClosed := id
      closedToOpen := id
      identityPreserved := Iff.rfl
    }⟩

/--
All five views collapse to the same proposition. No view creates a new proof
obligation and no transition loses logical identity.
-/
theorem rpa_chain_exact :
    RPAOpenMath ↔
    RPAClosedMath ∧
    RPAOpenBridge ∧
    RPAClosedBridge ∧
    RPAMath ∧
    RPAFinalRoot ∧
    RPAGlobalExternalCertificate := by
  constructor
  · intro h
    exact ⟨h, h, h, h, h, h⟩
  · rintro ⟨h, _, _, _, _, _⟩
    exact h

end MCore
