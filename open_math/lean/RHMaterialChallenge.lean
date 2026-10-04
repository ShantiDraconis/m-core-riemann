import MCore.RH.R0.ExplicitGramRate
import MCore.RH.R0.FrontierExposure
import MCore.RH.R0.CriticalLineWeightedErrorRate
import MCore.RH.NB.OrthogonalWitnessObstruction
import Lean

namespace MCore.RH.R0

open MCore.RH.NB
open scoped BigOperators
open Lean Elab Tactic

set_option pp.universes true
set_option pp.explicit true
set_option pp.coercions true

elab "rh_material_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-MATERIAL-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_material_gap_{name.getString}.txt" body

/--
DISCOVERY FILE — intentionally RED until the material estimate is proved.
The first goal is now the fully explicit inverse-Gram/autocorrelation inequality.
-/

/-- Stage H1.1: the exact all-N arithmetic inequality, with no DN/projection notation. -/
theorem DISCOVER_explicit_gram_rate :
    ExplicitGramRateTarget := by
  unfold ExplicitGramRateTarget explicitGramResidual explicitOptimalCoeff
  unfold explicitTargetVector explicitGramMatrix
  rh_material_gap "EXPLICIT_GRAM_RATE"
  exact ?_

/-- Stage H1.2: canonical DN producer closes mechanically from the explicit target. -/
theorem DISCOVER_material_inhabitant :
    ConcreteUniformLogDNBound := by
  exact explicitGramRateTarget_iff_uniformLogDNBound.mp
    DISCOVER_explicit_gram_rate

/-- Stage H1.3: hard frontier closes mechanically. -/
theorem DISCOVER_hard_frontier :
    HardFrontierTarget := by
  rcases DISCOVER_material_inhabitant with ⟨K, hK, hbound⟩
  refine ⟨K + 1, by linarith, ?_⟩
  intro N
  have hlogpos : 0 < Real.log ((N : ℝ) + 2) := Real.log_pos (by positivity)
  exact (hbound N).trans <| by
    unfold logMajorant
    exact div_le_div_of_nonneg_right (by linarith) hlogpos.le

/-- Stage H1.4: terminal closure is automatic after the explicit material estimate. -/
theorem DISCOVER_terminal :
    RiemannTerminalCertifies := by
  exact material_gap_closes_terminal DISCOVER_material_inhabitant

end MCore.RH.R0
