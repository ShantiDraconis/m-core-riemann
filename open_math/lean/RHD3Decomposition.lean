import MCore.RH.Analytic.MellinPlancherelBridge
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

theorem DISCOVER_D3_LOG_ISOMETRY : ResidualLogPullbackIsometry := by
  unfold ResidualLogPullbackIsometry
  d3_gap "LOG_PULLBACK_ISOMETRY"
  exact ?_

theorem DISCOVER_D3_LOG_L1 : ResidualLogPullbackIntegrable := by
  unfold ResidualLogPullbackIntegrable
  d3_gap "LOG_PULLBACK_L1"
  exact ?_

theorem DISCOVER_D3_LOG_L2 : ResidualLogPullbackSqIntegrable := by
  unfold ResidualLogPullbackSqIntegrable
  d3_gap "LOG_PULLBACK_L2_SQ"
  exact ?_

theorem DISCOVER_D3_FOURIER_PLANCHEREL : FourierPlancherelR := by
  unfold FourierPlancherelR
  d3_gap "FOURIER_PLANCHEREL_PINNED_MATHLIB"
  exact ?_

theorem DISCOVER_D3_RESIDUAL
    (hLog : ResidualLogPullbackIsometry)
    (hL1 : ResidualLogPullbackIntegrable)
    (hL2 : ResidualLogPullbackSqIntegrable)
    (hPl : FourierPlancherelR) :
    ResidualMellinPlancherel := by
  exact residualMellinPlancherel_of_fourier hLog hL1 hL2 hPl

end MCore.RH.R0
