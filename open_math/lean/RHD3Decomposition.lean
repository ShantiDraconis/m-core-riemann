import MCore.RH.Analytic.FourierL1L2Bridge
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/--
The only unresolved D3 producer:
the ordinary Fourier integral of each concrete log residual must represent
the same L2 vector as Mathlib's unitary L2 Fourier transform.
-/
theorem DISCOVER_D3_FOURIER_L1_L2 :
    ResidualFourierCompatibilityProducer := by
  d3_gap "FOURIER_L1_L2_COMPATIBILITY"
  exact ?_

/-- Once the standard Fourier bridge is supplied, the whole D3 identity closes. -/
theorem D3_FROM_FOURIER_COMPATIBILITY
    (h : ResidualFourierCompatibilityProducer)
    {N : ℕ} (c : Fin N → ℝ) :
    ‖concreteNBData.chi -
      concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLinePoint t) *
              concreteDirichletPolynomial c (criticalLinePoint t)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  exact d3_of_fourierCompatibility h c

end MCore.RH.R0
