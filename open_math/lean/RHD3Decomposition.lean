import MCore.RH.Analytic.MellinPlancherelReduction
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/--
After D1/D2 and finite Mellin linearity, D3 has exactly one remaining
analytic producer: Mellin-Plancherel for the residual norm.
-/
theorem DISCOVER_D3_PLANCHEREL_CORE :
    ResidualMellinPlancherelCore := by
  unfold ResidualMellinPlancherelCore
  d3_gap "RESIDUAL_MELLIN_PLANCHEREL_CORE"
  exact ?_

end MCore.RH.R0
