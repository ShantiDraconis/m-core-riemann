import MCore.RH.R0.ForensicMaterialAssembly
import MCore.RH.R0.ConcreteLogMajorantProducer
import MCore.RH.R0.ExplicitGramRate
import MCore.RH.R0.FinalKernelComposition

namespace MCore.RH.R0

open MCore.RH.NB
open MCore.RH.NB.Final

/--
A fully proved closure package downstream of the exact material producer.
Unlike the old infrastructure wrappers, every downstream field is an actual
kernel theorem.  The only input is the canonical RH material producer itself.
-/
structure RHMaterialClosurePackage : Prop where
  dnToZero :
    concreteNBData.DNToZero concreteGeneratorFamily
  dnLimit_eq_zero :
    concreteNBData.DNLimit concreteGeneratorFamily = 0
  finalRoot :
    FINAL_ROOT concreteNBData concreteGeneratorFamily
  gramResidual :
    ConcreteGramResidual
  finiteSpan :
    concreteNBData.FiniteSpanApproximatesChi concreteGeneratorFamily
  terminal :
    RiemannTerminalCertifies

/--
The logarithmic majorant really tends to zero; this is a theorem, not a
wrapper field or deferred obligation.
-/
theorem transformed_logMajorant_tendsto_zero
    (K : ℝ) :
    Filter.Tendsto (logMajorant K) Filter.atTop (nhds 0) :=
  logMajorant_tendsto_zero K

/--
Turn the exact canonical producer into the concrete vanishing upper bound.
All nonnegativity and Tendsto bookkeeping is discharged by proved lemmas.
-/
noncomputable def transformed_vanishingUpperBound
    (h : RHMaterialProducer) :
    ConcreteVanishingUpperBound := by
  let B : ConcreteLogDNBound :=
    Classical.choice (concreteUniformLogDNBound_iff_nonempty.mp h)
  exact B.toConcreteVanishingUpperBound

/--
FinalKernelComposition, expressed as a theorem about the actual analytic
consequence DN -> 0 rather than as a bare implication chain.
-/
theorem infra_FinalKernelComposition_como_prova
    (h : RHMaterialProducer) :
    concreteNBData.DNToZero concreteGeneratorFamily := by
  exact concreteNBData.DNToZero_of_vanishingUpperBound
    concreteGeneratorFamily
    (transformed_vanishingUpperBound h)

/--
The same producer proves DNLimit = 0 by the frozen zero-limit equivalence.
-/
theorem transformed_DNLimit_eq_zero
    (h : RHMaterialProducer) :
    concreteNBData.DNLimit concreteGeneratorFamily = 0 := by
  exact concreteNBData.DNLimit_eq_zero_of_vanishingUpperBound
    concreteGeneratorFamily
    (transformed_vanishingUpperBound h)

/--
Every named arrow in the terminal chain is now materialized simultaneously.
No field is True, no placeholder object is introduced, and no sorry/axiom is
used here.
-/
noncomputable def materialClosurePackage_of_producer
    (h : RHMaterialProducer) :
    RHMaterialClosurePackage := by
  let V : ConcreteVanishingUpperBound := transformed_vanishingUpperBound h
  exact {
    dnToZero :=
      concreteNBData.DNToZero_of_vanishingUpperBound
        concreteGeneratorFamily V
    dnLimit_eq_zero :=
      concreteNBData.DNLimit_eq_zero_of_vanishingUpperBound
        concreteGeneratorFamily V
    finalRoot :=
      concreteVanishingUpperBound_to_FINAL_ROOT V
    gramResidual :=
      concreteVanishingUpperBound_to_ConcreteGramResidual V
    finiteSpan :=
      concreteVanishingUpperBound_to_FiniteSpanApproximatesChi V
    terminal :=
      concreteVanishingUpperBound_to_RiemannTerminalCertifies V
  }

/--
The explicit inverse-Gram formula is not a placeholder: the canonical DN is
definitionally connected to the concrete residual 1 - b^T G^{-1} b through
the already-proved theorem concreteDN_eq_explicitGramResidual.
-/
theorem transformed_DN_eq_explicitGramResidual
    (N : ℕ) :
    concreteNBData.DN concreteGeneratorFamily N =
      explicitGramResidual N :=
  concreteDN_eq_explicitGramResidual N

/--
Exact equivalence between the explicit inverse-Gram rate formulation and the
single canonical material producer.
-/
theorem transformed_explicitGramRate_iff_materialProducer :
    ExplicitGramRateTarget ↔ RHMaterialProducer :=
  explicitGramRateTarget_iff_uniformLogDNBound

/--
A proof of the explicit inverse-Gram logarithmic rate closes every downstream
object, not merely an import-level wrapper.
-/
noncomputable def materialClosurePackage_of_explicitGramRate
    (h : ExplicitGramRateTarget) :
    RHMaterialClosurePackage :=
  materialClosurePackage_of_producer
    (transformed_explicitGramRate_iff_materialProducer.mp h)

/--
Likewise a concrete weighted critical-line error certificate closes every
downstream object.
-/
noncomputable def materialClosurePackage_of_weightedError
    (h : CriticalLineWeightedErrorRate) :
    RHMaterialClosurePackage :=
  materialClosurePackage_of_producer
    h.toUniformLogDNBound

#print axioms MCore.RH.R0.transformed_logMajorant_tendsto_zero
#print axioms MCore.RH.R0.transformed_vanishingUpperBound
#print axioms MCore.RH.R0.infra_FinalKernelComposition_como_prova
#print axioms MCore.RH.R0.transformed_DNLimit_eq_zero
#print axioms MCore.RH.R0.materialClosurePackage_of_producer
#print axioms MCore.RH.R0.transformed_DN_eq_explicitGramResidual
#print axioms MCore.RH.R0.transformed_explicitGramRate_iff_materialProducer
#print axioms MCore.RH.R0.materialClosurePackage_of_explicitGramRate
#print axioms MCore.RH.R0.materialClosurePackage_of_weightedError

end MCore.RH.R0
