import MCore.RH.NB.LogMajorantFinalProducer
import MCore.RH.NB.GramEnergy

namespace MCore.RH.NB
namespace Final

open scoped BigOperators

/--
Concrete coefficient-level producer for the logarithmic RH majorant.

Instead of proving an abstract DN inequality directly, supply one explicit
finite coefficient vector at each N whose exact quadratic energy is bounded by
K / log(N+2).  Existing projection minimality then gives the canonical DN
bound automatically.
-/
structure CoefficientLogMajorantCertificate
    (D : NBHilbertData)
    (rho : D.GeneratorFamily) where
  K : ℝ
  hK : 0 ≤ K
  coeff : (N : ℕ) → Fin N → ℝ
  energy_le :
    ∀ N : ℕ,
      D.coefficientEnergy rho N (coeff N) ≤ logMajorant K N

/-- Any coefficient-level log-majorant certificate yields the exact terminal
LogMajorantCertificate. -/
theorem coefficientLogMajorant_to_logMajorant
    (D : NBHilbertData)
    (rho : D.GeneratorFamily)
    (C : CoefficientLogMajorantCertificate D rho) :
    LogMajorantCertificate D rho := by
  refine
    { K := C.K
      hK := C.hK
      dn_le := ?_ }
  intro N
  have hproj :=
    D.DN_le_coefficient_error_sq rho N (C.coeff N)
  have henergy :=
    D.coefficient_error_sq_eq_energy rho N (C.coeff N)
  calc
    D.DN rho N
        ≤ ‖D.chi - D.coefficientApproximantAt rho N (C.coeff N)‖ ^ 2 := hproj
    _ = D.coefficientEnergy rho N (C.coeff N) := henergy
    _ ≤ logMajorant C.K N := C.energy_le N

/-- Therefore the entire RH terminal chain is reduced to the explicit
coefficient-energy estimate. -/
theorem FINAL_ROOT_of_coefficient_logMajorant
    (D : NBHilbertData)
    (rho : D.GeneratorFamily)
    (C : CoefficientLogMajorantCertificate D rho) :
    FINAL_ROOT D rho :=
  FINAL_ROOT_of_logMajorant D rho
    (coefficientLogMajorant_to_logMajorant D rho C)

#print axioms MCore.RH.NB.Final.coefficientLogMajorant_to_logMajorant
#print axioms MCore.RH.NB.Final.FINAL_ROOT_of_coefficient_logMajorant

end Final
end MCore.RH.NB
