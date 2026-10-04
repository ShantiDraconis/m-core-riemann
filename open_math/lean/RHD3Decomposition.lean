import MCore.RH.Analytic.ResidualNormBridge
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/-- The sole remaining D3 producer: Mellin--Plancherel for the concrete residual. -/
theorem DISCOVER_D3_MELLIN_PLANCHEREL : ResidualMellinPlancherel := by
  unfold ResidualMellinPlancherel
  d3_gap "MELLIN_PLANCHEREL_ISOMETRY"
  exact ?_

/-- Once the single Plancherel producer is supplied, the full zeta formula is automatic. -/
theorem D3_EXPLICIT_OF_PLANCHEREL
    (hMP : ResidualMellinPlancherel) :
    ExplicitResidualMellinPlancherel := by
  exact explicitResidualMellinPlancherel_of_bridges
    residualRepresentativeNormBridge_realized hMP

end MCore.RH.R0
