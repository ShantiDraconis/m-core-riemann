import MCore.RH.Analytic.D3Reduction
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/-- The algebraic Mellin identity on the critical line is already source-ready. -/
theorem DISCOVER_D3_POINTWISE
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (concreteResidualC c) (criticalLine t) =
      (1 + riemannZeta (criticalLine t) *
        concreteDirichletPolynomial c (criticalLine t)) /
      (criticalLine t) := by
  exact mellin_residual_on_critical_line c t

/-- The only remaining D3 producer. -/
theorem DISCOVER_D3_PLANCHEREL :
    ResidualMellinPlancherelBridge := by
  d3_gap "RESIDUAL_MELLIN_PLANCHEREL_BRIDGE"
  exact ?_

end MCore.RH.R0
