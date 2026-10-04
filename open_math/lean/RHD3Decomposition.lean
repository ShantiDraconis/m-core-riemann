import MCore.RH.Analytic.D3PlancherelReduction
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.LpSpace
import Lean

namespace MCore.RH.R0

open MeasureTheory Set Complex Lean Elab Tactic

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/-- Log-coordinate pullback at the critical exponent sigma=1/2. -/
noncomputable def criticalLogPullback
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) : ℂ :=
  Real.exp (-(1 / 2 : ℝ) * u) •
    residualRepresentativeC c (Real.exp (-u))

/-- D3.1: change of variables x=e^{-u} is an L2 isometry at sigma=1/2. -/
def D3_LogCoordinateL2 : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
      ∫ u : ℝ, ‖criticalLogPullback c u‖ ^ 2

/-- D3.2: pointwise Mellin/Fourier identification on the critical line. -/
def D3_MellinFourierPointwise : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ) (t : ℝ),
    mellin (residualRepresentativeC c) (criticalLinePoint t) =
      𝓕 (criticalLogPullback c) (t / (2 * Real.pi))

/--
D3.3: Fourier Plancherel plus the rescaling t=2*pi*y.
This is the exact place where Mathlib's L2 Fourier isometry must be connected
back to pointwise Fourier integrals.
-/
def D3_FourierScaledPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ u : ℝ, ‖criticalLogPullback c u‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ, ‖𝓕 (criticalLogPullback c) (t / (2 * Real.pi))‖ ^ 2

/-- D3 follows from exactly these three transparent bridges. -/
theorem d3_components_to_plancherel
    (hlog : D3_LogCoordinateL2)
    (hmf : D3_MellinFourierPointwise)
    (hfourier : D3_FourierScaledPlancherel) :
    CriticalLineMellinPlancherel := by
  intro N c
  rw [hlog c, hfourier c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  rw [← hmf c t]

/-- D3.2 is already structural: Mathlib supplies Mellin as Fourier after log change. -/
theorem d3_mellinFourierPointwise_realized :
    D3_MellinFourierPointwise := by
  intro N c t
  rw [mellin_eq_fourierIntegral]
  congr 1
  · funext u
    simp [criticalLinePoint, criticalLogPullback]
    ring_nf
  · simp [criticalLinePoint]
    ring

theorem DISCOVER_D3_LOG_COORDINATE : D3_LogCoordinateL2 := by
  unfold D3_LogCoordinateL2
  d3_gap "LOG_COORDINATE_L2"
  exact ?_

theorem DISCOVER_D3_FOURIER_SCALED : D3_FourierScaledPlancherel := by
  unfold D3_FourierScaledPlancherel
  d3_gap "FOURIER_L2_SCALED_PLANCHEREL"
  exact ?_

theorem DISCOVER_D3_PLANCHEREL :
    CriticalLineMellinPlancherel := by
  exact d3_components_to_plancherel
    DISCOVER_D3_LOG_COORDINATE
    d3_mellinFourierPointwise_realized
    DISCOVER_D3_FOURIER_SCALED

#print axioms MCore.RH.R0.d3_mellinFourierPointwise_realized
#print axioms MCore.RH.R0.d3_components_to_plancherel

end MCore.RH.R0
