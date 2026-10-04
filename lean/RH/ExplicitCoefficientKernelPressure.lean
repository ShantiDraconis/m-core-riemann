import MCore.RH.NB.ExplicitCoefficientProducer
import MCore.RH.R0.RhoConcrete

namespace RH

open Filter Topology
open MCore.RH.NB
open MCore.RH.R0

/--
Kernel-pressure form of the remaining RH coefficient route.

There is deliberately no new endpoint wrapper here.  The only mathematical
input is the literal asymptotic L2 statement for one explicit coefficient
family.  All downstream transport is reused from the certified coefficient
pipeline.
-/
example
    (c : ℕ → ℕ → ℝ)
    (hzero :
      Tendsto
        (fun N =>
          ‖concreteNBData.chi -
            concreteNBData.finiteCoefficientApproximant
              concreteGeneratorFamily c N‖)
        atTop
        (nhds 0)) :
    concreteNBData.DNLimit concreteGeneratorFamily = 0 :=
  concreteDNLimit_eq_zero_of_coefficient_error_tendsto_zero c hzero

#check MCore.RH.NB.NBHilbertData.finiteCoefficientApproximant
#check MCore.RH.NB.NBHilbertData.finiteSpanApproximatesChi_of_coefficient_error_tendsto_zero
#check MCore.RH.NB.NBHilbertData.DNLimit_eq_zero_of_coefficient_error_tendsto_zero
#check MCore.RH.R0.concreteDNLimit_eq_zero_of_coefficient_error_tendsto_zero

#print axioms MCore.RH.R0.concreteDNLimit_eq_zero_of_coefficient_error_tendsto_zero

end RH
