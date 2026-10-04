import MCore.RH.R0.FrontierExposure
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

/-- Stage 3: quantitative Gram form of the same open producer. -/
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
    trace_state
    exact ?_

/-- Stage 4: terminal closure becomes automatic once the material inhabitant exists. -/
theorem DISCOVER_terminal : RiemannTerminalCertifies := by
  exact material_gap_closes_terminal DISCOVER_material_inhabitant

end MCore.RH.R0
