import MCore.RH.Analytic.D3FourierReduction
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/-- The only remaining Fourier representation obligation in D3. -/
theorem DISCOVER_D3_FOURIER_REPRESENTATION : D3FourierRepresentationGap := by
  unfold D3FourierRepresentationGap FourierIntegralLpCompatibility
  d3_gap "FOURIER_L1_L2_COMPATIBILITY"
  exact ?_

end MCore.RH.R0
