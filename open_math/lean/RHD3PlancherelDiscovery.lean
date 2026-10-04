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

theorem DISCOVER_D3_MELLIN_PLANCHEREL :
    MellinPlancherelProducer := by
  d3_gap "MELLIN_PLANCHEREL_L2"
  exact ?_

end MCore.RH.R0
