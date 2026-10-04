import Lean

open Lean Elab Tactic

/--
Writes the current main goal to /tmp/rh_gap_<name>.txt and also traces it.
Discovery-only utility. It is outside the certified MCore tree.
-/
elab "dump_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_gap_{name.getString}.txt" body
