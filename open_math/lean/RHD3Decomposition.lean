import MCore.RH.Analytic.ResidualNormBridge
import MCore.RH.Analytic.MellinPlancherelFourierReduction
import MCore.RH.Analytic.LogPullbackNorm
import MCore.RH.Analytic.FourierPlancherelReduction
import MCore.RH.Analytic.FourierLpCompatibility
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

theorem DISCOVER_D3_FOURIER_COMPATIBILITY :
    ∀ {N : ℕ} (c : Fin N → ℝ), Nonempty (ResidualFourierCompatibility c) := by
  intro N c
  d3_gap "FOURIER_L1_L2_EXTENSION_COMPATIBILITY"
  exact ?_

theorem D3_FOURIER_PLANCHEREL_OF_COMPATIBILITY
    (hcompat : ∀ {N : ℕ} (c : Fin N → ℝ),
      ResidualFourierCompatibility c) :
    ResidualFourierPlancherel := by
  exact residualFourierPlancherel_of_compatibility hcompat

theorem D3_EXPLICIT_OF_COMPATIBILITY
    (hcompat : ∀ {N : ℕ} (c : Fin N → ℝ),
      ResidualFourierCompatibility c) :
    ExplicitResidualMellinPlancherel := by
  have hfourier : ResidualFourierPlancherel :=
    residualFourierPlancherel_of_compatibility hcompat
  have hmp : ResidualMellinPlancherel :=
    residualMellinPlancherel_of_fourierPlancherel hfourier
  exact explicitResidualMellinPlancherel_of_bridges
    residualRepresentativeNormBridge_realized hmp

end MCore.RH.R0
