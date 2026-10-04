import MCore.RH.R0.FrontierExposure
import MCore.RH.R0.GramExplicit
import MCore.RH.R0.LinearIndependentReduction
import MCore.RH.R0.ConcreteGramLogRate
import MCore.RH.R0.CriticalLineWeightedErrorRate
import MCore.RH.NB.OrthogonalWitnessObstruction

namespace MCore.RH.R0

open MCore.RH.NB
open scoped BigOperators

set_option pp.universes true
set_option pp.explicit true
set_option pp.coercions true

/--
DISCOVERY FILE — intentionally does not compile until the material mathematics
is genuinely supplied.  It is not imported by `MCore` and must never be used
as a certificate.

Run it directly to make Lean expose the exact remaining goals.
-/

noncomputable def discover_K : ℝ := 1

/-- Stage 1: force Lean to expose the exact all-N quantitative obligation. -/
theorem DISCOVER_h_bound :
    ∀ N : ℕ,
      concreteNBData.DN concreteGeneratorFamily N ≤
        logMajorant discover_K N := by
  intro N
  trace_state
  exact ?_

/-- Stage 2: once DISCOVER_h_bound is solved, this must close mechanically. -/
theorem DISCOVER_material_inhabitant : ConcreteUniformLogDNBound := by
  refine ⟨discover_K, by norm_num, ?_⟩
  exact DISCOVER_h_bound

/-- Stage 3a: expose the exact finite Gram system solved by the optimum. -/
theorem DISCOVER_gram_system (N : ℕ) :
    concreteGramMatrix N *ᵥ optimalGramCoeff N =
      concreteTargetVector N := by
  exact optimalGramCoeff_mulVec N

/-- Stage 3b.1: expose the analytic L2-to-Mellin bridge needed for independence. -/
theorem DISCOVER_moment_bridge (N : ℕ) :
    ConcreteMomentBridge N := by
  unfold ConcreteMomentBridge
  intro c hzero s hs0 hs1
  set_option pp.all true in
    trace_state
  exact ?_

/-- Stage 3b.2: expose finite exponential uniqueness on the Mellin strip. -/
theorem DISCOVER_moment_uniqueness (N : ℕ) :
    ConcreteMomentUniqueness N := by
  unfold ConcreteMomentUniqueness
  intro c hmom i
  set_option pp.all true in
    trace_state
  exact ?_

/-- Stage 3b.3: positive definiteness then closes mechanically. -/
theorem DISCOVER_gram_posDef (N : ℕ) :
    (concreteGramMatrix N).PosDef := by
  exact concreteGramMatrix_posDef_of_moments N
    (DISCOVER_moment_bridge N)
    (DISCOVER_moment_uniqueness N)

/-- Stage 3c: quantitative Gram form of the same material producer. -/
theorem DISCOVER_gram_rate : Nonempty ConcreteGramLogRate := by
  refine ⟨{
    K := discover_K
    hK := by norm_num
    coeff := optimalGramCoeff
    normal := ?_
    reduced_energy_le := ?_
  }⟩
  · intro N j
    exact optimalGramCoeff_normal N j
  · intro N
    have hsystem :
        concreteGramMatrix N *ᵥ optimalGramCoeff N =
          concreteTargetVector N :=
      optimalGramCoeff_mulVec N
    trace_state
    exact ?_

/-- Stage 4: terminal closure becomes automatic once the material inhabitant exists. -/
theorem DISCOVER_terminal : RiemannTerminalCertifies := by
  exact material_gap_closes_terminal DISCOVER_material_inhabitant

end MCore.RH.R0
