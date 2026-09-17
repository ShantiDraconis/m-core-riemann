import MCore.K7
import Mathlib.NumberTheory.LSeries.RiemannZeta

namespace MCore

/-- K8 names Mathlib's exact formal statement of the Riemann hypothesis.
    It is deliberately independent of the K3/K6 audit-node statement. -/
abbrev OfficialSpecRH : Prop :=
  RiemannHypothesis

/-- Scientific bridge interface. This is data, not an axiom: constructing a
value requires supplying the exact endpoint proof. -/
structure RHAdapterObligations where
  main : RiemannHypothesis

/-- Definitionally transparent projection from the bridge package.  Keeping
this endpoint free of rewriting avoids importing proof-irrelevance/extensional
machinery merely to unwrap a field. -/
theorem rh_endpoint_of_adapter (h : RHAdapterObligations) : RiemannHypothesis := by
  exact h.main

/-- K7 remains an audit/open-bridge certificate and supplies no ProofCertificate
    for its frozen target. K8 does not reinterpret that target as RH. -/
theorem k8_preserves_k7_firewall :
    ¬ Nonempty (ProofCertificate k6_dependency.target) :=
  k7_target_not_certified

/-- The K7 target remains open after introducing the scientific contract. -/
theorem k8_k7_target_open :
    k6_dependency.target.status = .openBridge :=
  k7_target_open

end MCore
