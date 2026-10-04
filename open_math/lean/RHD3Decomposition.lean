import MCore.RH.Analytic.ResidualNormBridge
import MCore.RH.Analytic.MellinPlancherelFourierReduction
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

theorem DISCOVER_D3_LOG_PULLBACK_NORM : ResidualLogPullbackNorm := by
  unfold ResidualLogPullbackNorm
  d3_gap "LOG_PULLBACK_L2_NORM"
  exact ?_

theorem DISCOVER_D3_FOURIER_PLANCHEREL_SCALED :
    ResidualFourierPlancherelScaled := by
  unfold ResidualFourierPlancherelScaled
  d3_gap "FOURIER_L2_PLANCHEREL_SCALED"
  exact ?_

theorem DISCOVER_D3_MELLIN_PLANCHEREL
    (hlog : ResidualLogPullbackNorm)
    (hfourier : ResidualFourierPlancherelScaled) :
    ResidualMellinPlancherel := by
  exact residualMellinPlancherel_of_fourier_bridges hlog hfourier

theorem D3_EXPLICIT_OF_FOURIER_BRIDGES
    (hlog : ResidualLogPullbackNorm)
    (hfourier : ResidualFourierPlancherelScaled) :
    ExplicitResidualMellinPlancherel := by
  exact explicitResidualMellinPlancherel_of_bridges
    residualRepresentativeNormBridge_realized
    (residualMellinPlancherel_of_fourier_bridges hlog hfourier)

end MCore.RH.R0
