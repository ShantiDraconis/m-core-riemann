import MCore.RH.Analytic.D3PinnedGap
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-PINNED-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/--
Intentional RED discovery theorem.
This is not an RH-specific hypothesis: it asks for the Fourier Plancherel theorem
missing from the pinned Mathlib commit.
-/
theorem DISCOVER_PINNED_FOURIER_PLANCHEREL :
    PinnedFourierPlancherelGap := by
  unfold PinnedFourierPlancherelGap ResidualFourierPlancherel
  d3_gap "PINNED_FOURIER_PLANCHEREL"
  exact ?_

end MCore.RH.R0
