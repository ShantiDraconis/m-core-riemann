import MCore.RH.Analytic.MellinPlancherelBridges
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

theorem DISCOVER_D3_LOG_ISOMETRY :
    ResidualLogPullbackIsometry := by
  unfold ResidualLogPullbackIsometry
  d3_gap "LOG_PULLBACK_ISOMETRY"
  exact ?_

theorem DISCOVER_D3_FOURIER_PLANCHEREL :
    ResidualFourierPlancherel := by
  unfold ResidualFourierPlancherel
  d3_gap "FOURIER_PLANCHEREL_POINTWISE"
  exact ?_

theorem DISCOVER_D3_FREQUENCY_SCALING :
    ResidualFrequencyScaling :=
  residualFrequencyScaling_realized

theorem DISCOVER_D3_COMPLETE
    (hlog : ResidualLogPullbackIsometry)
    (hfourier : ResidualFourierPlancherel) :
    ResidualCriticalLinePlancherel :=
  residualCriticalLinePlancherel_of_two_bridges hlog hfourier

end MCore.RH.R0
