import MCore.RH.R0.FinalKernelComposition
import MCore.RH.R0.ConcreteLogMajorantProducer
import MCore.RH.NB.QuantitativeUpperBound

namespace MCore.RH.R0

open MCore.RH.NB
open MCore.RH.NB.Final

/-- All mathematically substantive downstream consequences of the unique
material producer, collected in one kernel-checked object. -/
structure RHMaterialClosureConsequences : Prop where
  dnToZero :
    concreteNBData.DNToZero concreteGeneratorFamily
  dnLimitZero :
    concreteNBData.DNLimit concreteGeneratorFamily = 0
  finalRoot :
    FINAL_ROOT concreteNBData concreteGeneratorFamily
  gramResidual :
    ConcreteGramResidual
  finiteSpan :
    concreteNBData.FiniteSpanApproximatesChi concreteGeneratorFamily
  terminal :
    RiemannTerminalCertifies

/-- The infrastructure is a proof, not merely an import graph: once the exact
uniform logarithmic bound is supplied, every downstream arrow is derived
inside Lean. -/
noncomputable theorem materialProducer_closes_all
    (h : RHMaterialProducer) :
    RHMaterialClosureConsequences := by
  let B : ConcreteLogDNBound :=
    Classical.choice (concreteUniformLogDNBound_iff_nonempty.mp h)
  let V : ConcreteVanishingUpperBound :=
    B.toConcreteVanishingUpperBound
  exact {
    dnToZero :=
      concreteNBData.DNToZero_of_vanishingUpperBound
        concreteGeneratorFamily V
    dnLimitZero :=
      concreteNBData.DNLimit_eq_zero_of_vanishingUpperBound
        concreteGeneratorFamily V
    finalRoot :=
      concreteLogDNBound_to_FINAL_ROOT B
    gramResidual :=
      concreteLogDNBound_to_ConcreteGramResidual B
    finiteSpan :=
      concreteLogDNBound_to_FiniteSpanApproximatesChi B
    terminal :=
      concreteLogDNBound_to_RiemannTerminalCertifies B
  }

/-- Explicit squeeze theorem in the concrete lane. -/
theorem concreteDN_tendsto_zero_of_uniformLogBound
    (h : ConcreteUniformLogDNBound) :
    Filter.Tendsto
      (fun N => concreteNBData.DN concreteGeneratorFamily N)
      Filter.atTop (nhds 0) :=
  (materialProducer_closes_all h).dnToZero

/-- Explicit terminal theorem with no skipped arrows. -/
theorem concreteUniformLogDNBound_closes_terminal_without_skip
    (h : ConcreteUniformLogDNBound) :
    RiemannTerminalCertifies :=
  (materialProducer_closes_all h).terminal

/-- The explicit inverse-Gram representation is already the concrete DN;
there is no placeholder ConcreteNBData in this lane. -/
theorem concreteDN_is_real_explicitGramResidual
    (N : ℕ) :
    concreteNBData.DN concreteGeneratorFamily N =
      explicitGramResidual N :=
  concreteDN_eq_explicitGramResidual N

#print axioms MCore.RH.R0.materialProducer_closes_all
#print axioms MCore.RH.R0.concreteDN_tendsto_zero_of_uniformLogBound
#print axioms MCore.RH.R0.concreteUniformLogDNBound_closes_terminal_without_skip
#print axioms MCore.RH.R0.concreteDN_is_real_explicitGramResidual

end MCore.RH.R0
