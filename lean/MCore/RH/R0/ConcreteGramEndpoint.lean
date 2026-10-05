import MCore.RH.R0.RhoConcrete
import MCore.RH.NB.GramEndpoint

open scoped BigOperators

namespace MCore.RH.R0

open MCore.RH.NB

theorem concrete_DNLimit_eq_zero_iff_gram_scalar :
    NBHilbertData.DNLimit concreteNBData concreteGeneratorFamily = 0 ↔
      ∀ ε : ℝ, 0 < ε →
        ∃ N : ℕ, ∃ c : Fin N → ℝ,
          (∀ j : Fin N,
            (∑ i : Fin N,
              c i *
                NBHilbertData.gramEntry
                  concreteNBData concreteGeneratorFamily i j) =
              NBHilbertData.targetEntry
                concreteNBData concreteGeneratorFamily j) ∧
          ‖concreteNBData.chi‖ ^ 2 -
              (∑ i : Fin N,
                c i *
                  NBHilbertData.targetEntry
                    concreteNBData concreteGeneratorFamily i) <
            ε ^ 2 := by
  exact
    NBHilbertData.DNLimit_eq_zero_iff_normal_equation_energy
      concreteNBData concreteGeneratorFamily

#print axioms concrete_DNLimit_eq_zero_iff_gram_scalar

end MCore.RH.R0
