import MCore.RH.Analytic.MellinPlancherelReduction
import MCore.RH.Analytic.LogPullbackIsometry
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

open MeasureTheory Set Complex

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/-- Change x = exp(-u): ordinary L2(dx) becomes ordinary L2(du). -/
def D3_LogPullbackIsometry : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    ‖concreteResidual c‖ ^ 2 =
      ∫ u : ℝ, Complex.normSq (criticalLogPullback c u)

/-- Fourier Plancherel in the exact normalization used by Mathlib. -/
def D3_FourierPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ u : ℝ, Complex.normSq (criticalLogPullback c u)) =
      ∫ ξ : ℝ, Complex.normSq (𝓕 (criticalLogPullback c) ξ)

/-- Mellin/Fourier identification plus t = 2*pi*xi. -/
def D3_FourierToMellinLine : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ ξ : ℝ, Complex.normSq (𝓕 (criticalLogPullback c) ξ)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (mellin (residualRepresentativeC c) (criticalLinePoint t))

theorem d3_components_to_plancherel
    (hlog : D3_LogPullbackIsometry)
    (hfourier : D3_FourierPlancherel)
    (hmellin : D3_FourierToMellinLine) :
    CriticalLineMellinPlancherel := by
  intro N c
  rw [hlog c, hfourier c, hmellin c]

theorem DISCOVER_D3_LOG_PULLBACK : D3_LogPullbackIsometry := by
  exact d3_logPullbackIsometry_realized

theorem DISCOVER_D3_FOURIER_PLANCHEREL : D3_FourierPlancherel := by
  unfold D3_FourierPlancherel
  d3_gap "FOURIER_L2_PLANCHEREL"
  exact ?_

theorem DISCOVER_D3_FOURIER_TO_MELLIN : D3_FourierToMellinLine := by
  unfold D3_FourierToMellinLine
  d3_gap "FOURIER_TO_MELLIN_CRITICAL_LINE"
  exact ?_

end MCore.RH.R0
