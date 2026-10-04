import MCore.RH.Analytic.E1EvaluationReduction
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "e1_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-E1-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_e1_gap_{name.getString}.txt" body

/-- Intentional RED: exact Cauchy/Hardy reproduction on the critical line. -/
theorem DISCOVER_E1_CAUCHY_REPRODUCING :
    ∀ z : RightStripZero, CriticalEvaluationReproducing z.rho := by
  intro z
  unfold CriticalEvaluationReproducing criticalEvaluationPairing
  e1_gap "CAUCHY_REPRODUCING"
  exact ?_

/--
Intentional RED: unitary transport of the complex spectral witness back to the real
physical Hilbert carrier used by the certified orthogonal obstruction.
-/
theorem DISCOVER_E1_SPECTRAL_TO_PHYSICAL :
    SpectralToPhysicalWitness := by
  unfold SpectralToPhysicalWitness
  e1_gap "SPECTRAL_TO_PHYSICAL"
  exact ?_

end MCore.RH.R0
