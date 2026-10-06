import MCore.RH.P02RPAEndpointLattice

namespace MCore

/-!
# RH material payload

Riemann uses its own material payload.  No algebraicity payload from another
lane is reused here.

The payload is inhabited only by a proof that every probe nontrivial zero lies
on the critical line.  The dual/lattice layer does not manufacture that proof.
-/

def RiemannHypothesisMaterial : Prop :=
  ProbeCriticalLineStatement

structure RiemannMaterialPayload where
  criticalLine : RiemannHypothesisMaterial

theorem criticalLine_implies_orbitCollapse
    (h : ProbeCriticalLineStatement) :
    CriticalOrbitCollapse := by
  intro s hs
  exact (criticalReflect_fixed_iff s).mpr (h s hs)

theorem orbitCollapse_iff_materialRH :
    CriticalOrbitCollapse ↔ RiemannHypothesisMaterial := by
  constructor
  · exact criticalOrbitCollapse_implies_probeCriticalLine
  · exact criticalLine_implies_orbitCollapse

theorem endpoint_iff_materialRH :
    Endpoint ↔ RiemannHypothesisMaterial := by
  change CriticalWheelTerminalClosure ↔ RiemannHypothesisMaterial
  exact criticalWheelTerminalClosure_iff_orbitCollapse.trans
    orbitCollapse_iff_materialRH

theorem payload_iff_materialRH :
    Nonempty RiemannMaterialPayload ↔ RiemannHypothesisMaterial := by
  constructor
  · rintro ⟨p⟩
    exact p.criticalLine
  · intro h
    exact ⟨{ criticalLine := h }⟩

theorem payload_iff_endpoint :
    Nonempty RiemannMaterialPayload ↔ Endpoint := by
  rw [payload_iff_materialRH, endpoint_iff_materialRH]

theorem payload_implies_dual_endpoint_state :
    RiemannMaterialPayload → DUAL_ENDPOINT_STATE := by
  intro p
  have hEndpoint : Endpoint :=
    endpoint_iff_materialRH.mpr p.criticalLine
  exact ⟨hEndpoint, hEndpoint, Iff.rfl⟩

theorem dual_endpoint_state_implies_payload :
    DUAL_ENDPOINT_STATE → RiemannMaterialPayload := by
  rintro ⟨hOpen, _, _⟩
  exact { criticalLine := endpoint_iff_materialRH.mp hOpen }

structure RiemannFinalCertificate where
  payload : RiemannMaterialPayload
  dual : DUAL_ENDPOINT_STATE

theorem finalCertificate_iff_materialRH :
    Nonempty RiemannFinalCertificate ↔ RiemannHypothesisMaterial := by
  constructor
  · rintro ⟨c⟩
    exact c.payload.criticalLine
  · intro h
    have p : RiemannMaterialPayload := { criticalLine := h }
    exact ⟨{
      payload := p
      dual := payload_implies_dual_endpoint_state p
    }⟩

theorem finalCertificate_iff_endpoint :
    Nonempty RiemannFinalCertificate ↔ Endpoint := by
  rw [finalCertificate_iff_materialRH, endpoint_iff_materialRH]

/--
This is deliberately an equivalence, not a constructed certificate.
A concrete term of `RiemannFinalCertificate` still requires a material proof
of `RiemannHypothesisMaterial`.
-/
theorem material_gate_exact :
    Nonempty RiemannFinalCertificate ↔
      (RiemannHypothesisMaterial ∧ DUAL_ENDPOINT_STATE) := by
  constructor
  · rintro ⟨c⟩
    exact ⟨c.payload.criticalLine, c.dual⟩
  · rintro ⟨hRH, hDual⟩
    exact ⟨{
      payload := { criticalLine := hRH }
      dual := hDual
    }⟩

end MCore
