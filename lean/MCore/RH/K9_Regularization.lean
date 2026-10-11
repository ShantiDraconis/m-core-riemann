import MCore.A14_Formal

namespace MCore

/-- A regularized system is a new object, not an assertion that path dependence vanished. -/
structure RegularizedMCoreSystem where
  source : MCoreSystem
  regularizedLimit : ZeroDirection → ℝ
  scaleRegularized : ℝ → ℝ
  selfRefEliminated : Prop

/-- The regularized limits are path-independent.  A value of this structure is a proof
certificate for the A3 inversion; defining the structure does not construct one.
The common limit is existentially quantified: a `Prop`-valued structure cannot carry
a real number as a data field. -/
structure PathIndependenceCertificate (reg : RegularizedMCoreSystem) : Prop where
  commonLimit_exists :
    ∃ commonLimit : ℝ,
      reg.regularizedLimit .K0 = commonLimit ∧
      reg.regularizedLimit .RHO = commonLimit ∧
      reg.regularizedLimit .ETA = commonLimit

/-- Regularization must preserve the scale information used downstream. -/
structure ScalePreservationCertificate (reg : RegularizedMCoreSystem) : Prop where
  scale_eq : ∀ t : ℝ, 0 < t → reg.scaleRegularized t = reg.source.baseVal

/-- A2 detects a cycle.  Closing the firewall requires a separate proof that the
regularized object no longer uses that circular dependency. -/
structure SelfReferenceEliminationCertificate (reg : RegularizedMCoreSystem) : Prop where
  eliminated : reg.selfRefEliminated

/-- Complete regularization certificate.  This is intentionally uninhabited until the
three mathematical obligations are proved. -/
structure RegularizationCertificate (reg : RegularizedMCoreSystem) : Prop where
  pathIndependent : PathIndependenceCertificate reg
  scalePreserved : ScalePreservationCertificate reg
  selfReferenceRemoved : SelfReferenceEliminationCertificate reg

end MCore
