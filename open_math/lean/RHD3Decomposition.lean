import MCore.RH.Analytic.D3FourierReduction
import MCore.RH.Analytic.FourierCompatibilityReduction
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/-- The only remaining theorem in D3 is now generic, not RH-specific. -/
theorem DISCOVER_D3_GENERIC_L1_L2_FOURIER : L1L2FourierCompatibility := by
  unfold L1L2FourierCompatibility
  d3_gap "GENERIC_L1_L2_FOURIER_COMPATIBILITY"
  exact ?_

theorem DISCOVER_D3_FOURIER_REPRESENTATION
    (h : L1L2FourierCompatibility) :
    D3FourierRepresentationGap := by
  exact fourierIntegralLpCompatibility_of_generic h

end MCore.RH.R0
