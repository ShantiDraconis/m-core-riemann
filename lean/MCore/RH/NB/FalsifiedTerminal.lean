import MCore.RH.NB.ZeroLimitFrontier

namespace MCore.RH.NB
namespace NBHilbertData

/-- FALSIFIED ONLY: exact missing zero-limit inhabitant injected as an axiom. -/
axiom falsified_DNLimit_eq_zero
    (D : NBHilbertData)
    (rho : D.GeneratorFamily) :
    D.DNLimit rho = 0

/-- Propagation test: the falsified terminal inhabitant closes DNToZero. -/
theorem falsified_DNToZero
    (D : NBHilbertData)
    (rho : D.GeneratorFamily) :
    D.DNToZero rho :=
  (D.DNToZero_iff_DNLimit_eq_zero rho).2
    (falsified_DNLimit_eq_zero D rho)

#print axioms MCore.RH.NB.NBHilbertData.falsified_DNToZero

end NBHilbertData
end MCore.RH.NB
