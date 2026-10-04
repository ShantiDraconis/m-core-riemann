import MCore.RH.R0.VasyuninFiniteGram
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "vasyunin_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-VASYUNIN-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_vasyunin_gap_{name.getString}.txt" body

/-- Classical identity-formalization gap: integral autocorrelation -> finite cotangent sum. -/
theorem DISCOVER_VASYUNIN_GRAM_FORMULA :
    VasyuninGramFormula := by
  unfold VasyuninGramFormula explicitGramMatrix vasyuninGramMatrix
  unfold vasyuninGramEntry vasyuninSum reducedNumerator reducedDenominator
  vasyunin_gap "GRAM_FORMULA"
  exact ?_

/--
Material rate after the Gram matrix has become completely finite.
This is the actual asymptotic producer, conditional only on the classical Vasyunin identity.
-/
theorem DISCOVER_FINITE_VASYUNIN_RATE
    (hV : VasyuninGramFormula) :
    FiniteVasyuninRateTarget := by
  unfold FiniteVasyuninRateTarget explicitTargetVector
  unfold vasyuninGramMatrix vasyuninGramEntry vasyuninSum
  unfold reducedNumerator reducedDenominator rhoIndex logMajorant
  vasyunin_gap "FINITE_RATE"
  exact ?_

end MCore.RH.R0
