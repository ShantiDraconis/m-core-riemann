import MCore.RH.Analytic.MellinRhoReduction
import MCore.RH.Analytic.MellinTailRightReduction
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

open Complex MeasureTheory Set

elab "d1_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D1-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d1_gap_{name.getString}.txt" body

/-- Tail Euler-summation identity, initially provable on Re(s)>1. -/
def D1_TailFormulaRight : Prop :=
  ∀ s : ℂ, 1 < s.re →
    (∫ t : ℝ in Ioi 1,
      ((t : ℂ) ^ (-s - 1)) * (Int.fract t : ℂ)) =
      1 / (s - 1) - riemannZeta s / s

/-- Holomorphic continuation of the tail integral to Re(s)>0. -/
def D1_TailAnalyticContinuation : Prop :=
  ∀ s : ℂ, 0 < s.re → s ≠ 1 →
    (∫ t : ℝ in Ioi 1,
      ((t : ℂ) ^ (-s - 1)) * (Int.fract t : ℂ)) =
      1 / (s - 1) - riemannZeta s / s

/-- Elementary near-zero piece: fract(t)=t on (0,1). -/
def D1_NearZeroIdentity : Prop :=
  ∀ s : ℂ, s.re < 1 →
    (∫ t : ℝ in Ioo 0 1,
      ((t : ℂ) ^ (-s - 1)) * (Int.fract t : ℂ)) =
      1 / (1 - s)

theorem DISCOVER_D1_TAIL_SERIES_BRIDGE : ComplexTailIntegralSeriesBridge := by
  unfold ComplexTailIntegralSeriesBridge
  d1_gap "TAIL_INTEGRAL_SERIES_BRIDGE"
  exact ?_

theorem DISCOVER_D1_TAIL_SERIES_CLOSED_FORM : ComplexTailSeriesClosedForm := by
  unfold ComplexTailSeriesClosedForm
  d1_gap "TAIL_SERIES_CLOSED_FORM"
  exact ?_

theorem DISCOVER_D1_TAIL_RIGHT
    (hbridge : ComplexTailIntegralSeriesBridge)
    (hclosed : ComplexTailSeriesClosedForm) :
    D1_TailFormulaRight := by
  intro s hs
  exact tailFormulaRight_of_series hbridge hclosed s hs

theorem DISCOVER_D1_ANALYTIC_CONTINUATION : D1_TailAnalyticContinuation := by
  unfold D1_TailAnalyticContinuation
  d1_gap "TAIL_ANALYTIC_CONTINUATION"
  exact ?_

theorem DISCOVER_D1_NEAR_ZERO : D1_NearZeroIdentity := by
  intro s hs
  exact d1_nearZero_identity s hs

theorem DISCOVER_D1_FRACTIONAL_ZETA : FractionalZetaMellinIdentity := by
  unfold FractionalZetaMellinIdentity
  d1_gap "FRACTIONAL_ZETA_MELLIN_IDENTITY"
  exact ?_

end MCore.RH.R0
