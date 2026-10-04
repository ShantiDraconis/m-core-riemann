import MCore.RH.Analytic.D3SingleGap
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

theorem DISCOVER_D3_FOURIER_PLANCHEREL :
    FourierPlancherelForLogPullback := by
  d3_gap "FOURIER_PLANCHEREL_LOG_PULLBACK"
  exact ?_

theorem DISCOVER_D3_MELLIN_PLANCHEREL
    (h : FourierPlancherelForLogPullback) :
    MellinPlancherelProducer :=
  mellinPlancherel_of_fourier_only h

end MCore.RH.R0
