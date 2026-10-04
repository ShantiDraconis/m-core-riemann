import MCore.RH.Analytic.D3PlancherelReduction
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/-- All finite Mellin algebra is already closed; this is the only D3 producer left. -/
theorem DISCOVER_D3_PLANCHEREL : CriticalLineMellinPlancherel := by
  unfold CriticalLineMellinPlancherel
  d3_gap "CRITICAL_LINE_MELLIN_PLANCHEREL"
  exact ?_

/-- Once Plancherel is supplied, the full zeta/Dirichlet-polynomial residual identity is automatic. -/
theorem DISCOVER_D3_ZETA_FORM
    (hP : CriticalLineMellinPlancherel)
    {N : ℕ} (c : Fin N → ℝ) :
    residualEnergy c =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLinePoint t) *
              concreteDirichletPolynomial c (criticalLinePoint t)) /
            (1 / 4 + t ^ 2) := by
  exact residualEnergy_eq_zeta_integral hP c

end MCore.RH.R0
