import MCore.RH.R0.VasyuninGCD
import Lean

namespace MCore.RH.R0

open Lean Elab Tactic

elab "vasyunin_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-VASYUNIN-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_vasyunin_gap_{name.getString}.txt" body

/--
The only remaining C5 formula after gcd extraction.
This is Vasyunin's classical coprime cotangent-sum identity.
-/
theorem DISCOVER_COPRIME_VASYUNIN :
    CoprimeVasyuninFormula := by
  unfold CoprimeVasyuninFormula
  intro h k hh hk hcop
  vasyunin_gap "COPRIME_VASYUNIN_FORMULA"
  exact ?_

/--
Once the coprime formula is supplied, the full matrix formula and finite H1
rewriting are automatic.
-/
theorem COPRIME_VASYUNIN_CLOSES_FULL
    (hcop : CoprimeVasyuninFormula) :
    VasyuninGramFormula :=
  vasyuninGramFormula_of_coprime hcop

#print axioms MCore.RH.R0.COPRIME_VASYUNIN_CLOSES_FULL

end MCore.RH.R0
