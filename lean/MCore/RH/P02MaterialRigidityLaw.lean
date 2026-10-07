import MCore.RH.P02RPAEndpointLattice
import MCore.RH.P02CriticalReflectionSymmetry

namespace MCore

/-!
# RH material rigidity frontier

This module separates the kernel-checked structural lattice from the one
remaining RH-strength mathematical obligation.

Nothing here assumes `ProbeCriticalLineStatement`, `CriticalOrbitCollapse`,
or `RiemannHypothesis` as a field.  No inhabitant of the certificate below is
constructed in this file.
-/

/-- Closure of the probe nontrivial-zero predicate under reflection across
Re(s)=1/2.  This is a genuine analytic/symmetry obligation. -/
def CriticalReflectionZeroClosure : Prop :=
  ∀ s : ℂ,
    ProbeNontrivialZetaZero s →
    ProbeNontrivialZetaZero (criticalReflect s)

/-- Material rigidity law: an off-critical-line zero and its reflected partner
cannot both satisfy the probe nontrivial-zero predicate.

This proposition is intentionally exposed as the remaining material law.  It
is not manufactured by the RPA endpoint lattice and is not proved here. -/
def OffLineReflectedPairExclusion : Prop :=
  ∀ s : ℂ,
    ProbeNontrivialZetaZero s →
    ProbeNontrivialZetaZero (criticalReflect s) →
    s.re ≠ (1 / 2 : ℝ) →
    False

/-- The exact non-circular interface required to turn the structural chain into
a critical-line proof.  Constructing a value of this structure is the remaining
scientific task. -/
structure RHMaterialRigidityCertificate : Prop where
  zeroClosure : CriticalReflectionZeroClosure
  excludeOffLinePair : OffLineReflectedPairExclusion

/-- Once zero closure and off-line-pair exclusion are both supplied, every
probe zero is fixed by critical reflection. -/
theorem criticalOrbitCollapse_of_material_rigidity
    (cert : RHMaterialRigidityCertificate) :
    CriticalOrbitCollapse := by
  intro s hs
  have hre : s.re = (1 / 2 : ℝ) := by
    by_contra hoff
    exact cert.excludeOffLinePair s hs (cert.zeroClosure s hs) hoff
  exact (criticalReflect_fixed_iff s).mpr hre

/-- Composition to the exact terminal material proposition used by the payload. -/
theorem probeCriticalLine_of_material_rigidity
    (cert : RHMaterialRigidityCertificate) :
    ProbeCriticalLineStatement :=
  criticalOrbitCollapse_implies_probeCriticalLine
    (criticalOrbitCollapse_of_material_rigidity cert)

/-- The material law is sufficient for the endpoint proposition. -/
theorem endpoint_of_material_rigidity
    (cert : RHMaterialRigidityCertificate) :
    Endpoint := by
  exact (criticalWheelTerminalClosure_iff_orbitCollapse).mpr
    (criticalOrbitCollapse_of_material_rigidity cert)

/-- Audit guard: the structural RPA lattice only transports Endpoint content;
it does not construct the material rigidity certificate. -/
theorem rpa_full_of_material_rigidity
    (cert : RHMaterialRigidityCertificate) :
    RPAFull := by
  have hEndpoint : Endpoint := endpoint_of_material_rigidity cert
  exact ⟨hEndpoint, hEndpoint, Iff.rfl⟩

end MCore
