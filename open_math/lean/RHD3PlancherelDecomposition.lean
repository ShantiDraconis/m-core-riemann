import MCore.RH.Analytic.MellinPlancherelDecomposition
import MCore.RH.Analytic.MellinFrequencyRescale
import MCore.RH.Analytic.MellinLogPullback
import MCore.RH.Analytic.MellinResidualNormBridge
import Lean

namespace MCore.RH.R0

open MeasureTheory Set Complex Filter Topology
open MCore.RH.NB
open Lean Elab Tactic

elab "d3_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-D3-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_d3_gap_{name.getString}.txt" body

/-!
D3.2 decomposition for the pinned Mathlib revision.

The pinned dependency has Fourier integrals and inversion, but no L2 Fourier
extension / Plancherel API. We therefore expose the minimal standard-analysis
obligations needed for the *specific* criticalLogPullback family.
-/

/-- D3.2.0: the logarithmic pullback is L1. -/
def D3_LogPullbackIntegrable : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    Integrable (criticalLogPullback c)

/-- D3.2.1: the logarithmic pullback is L2. -/
def D3_LogPullbackMemL2 : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    MemLp (criticalLogPullback c) 2 volume

/-- Gaussian regularization in frequency. -/
noncomputable def d3GaussianMultiplier (ε t : ℝ) : ℂ :=
  Complex.exp (-(ε : ℂ) * (t : ℂ) ^ 2)

/-- D3.2.2: the Gaussian-regularized Fourier square is integrable. -/
def D3_RegularizedFourierIntegrable : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ) (ε : ℝ), 0 < ε →
    Integrable
      (fun t : ℝ =>
        Complex.normSq
          (d3GaussianMultiplier ε t * 𝓕 (criticalLogPullback c) t))

/--
D3.2.3: regularized Plancherel identity.  This is the finite-epsilon
identity obtainable from Fubini + the explicit Fourier transform of a Gaussian.
-/
def D3_RegularizedPlancherel : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ) (ε : ℝ), 0 < ε →
    (∫ t : ℝ,
      Complex.normSq
        (d3GaussianMultiplier ε t * 𝓕 (criticalLogPullback c) t)) =
    ∫ u : ℝ,
      Complex.normSq
        (∫ v : ℝ,
          Real.exp (-(Real.pi ^ 2 / ε) * (u - v) ^ 2) •
            criticalLogPullback c v)

/--
D3.2.4: Gaussian approximate identity converges in L2 back to the pullback.
-/
def D3_GaussianApproximationL2 : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    Tendsto
      (fun ε : ℝ =>
        ∫ u : ℝ,
          Complex.normSq
            (∫ v : ℝ,
              Real.exp (-(Real.pi ^ 2 / ε) * (u - v) ^ 2) •
                criticalLogPullback c v))
      (𝓝[>] 0)
      (𝓝 (∫ u : ℝ, Complex.normSq (criticalLogPullback c u)))

/--
D3.2.5: remove the Gaussian multiplier on the Fourier side.
-/
def D3_RemoveGaussianFrequency : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    Tendsto
      (fun ε : ℝ =>
        ∫ t : ℝ,
          Complex.normSq
            (d3GaussianMultiplier ε t * 𝓕 (criticalLogPullback c) t))
      (𝓝[>] 0)
      (𝓝 (∫ t : ℝ, Complex.normSq (𝓕 (criticalLogPullback c) t)))

/-- The two limiting statements plus the regularized identity give D3.2. -/
theorem d3_fourierPlancherel_of_regularized
    (hreg : D3_RegularizedPlancherel)
    (hspace : D3_GaussianApproximationL2)
    (hfreq : D3_RemoveGaussianFrequency) :
    D3_FourierPlancherelBridge := by
  intro N c
  have heq :
      ∀ ε : ℝ, 0 < ε →
        (∫ t : ℝ,
          Complex.normSq
            (d3GaussianMultiplier ε t * 𝓕 (criticalLogPullback c) t)) =
        ∫ u : ℝ,
          Complex.normSq
            (∫ v : ℝ,
              Real.exp (-(Real.pi ^ 2 / ε) * (u - v) ^ 2) •
                criticalLogPullback c v) :=
    hreg N c
  exact tendsto_nhds_unique
    (hfreq N c)
    ((hspace N c).congr'
      (filter_mono (𝓝[>] (0 : ℝ)) (𝓝[>] (0 : ℝ))
        (by intro s hs; exact hs)
      |>.filter_mono
        (Eventually.of_forall fun ε hε => (heq ε hε).symm)))

theorem DISCOVER_D3_LOG_L1 : D3_LogPullbackIntegrable := by
  unfold D3_LogPullbackIntegrable
  d3_gap "LOG_PULLBACK_L1"
  exact ?_

theorem DISCOVER_D3_LOG_L2 : D3_LogPullbackMemL2 := by
  unfold D3_LogPullbackMemL2
  d3_gap "LOG_PULLBACK_L2"
  exact ?_

theorem DISCOVER_D3_REGULARIZED_PLANCHEREL : D3_RegularizedPlancherel := by
  unfold D3_RegularizedPlancherel
  d3_gap "REGULARIZED_PLANCHEREL"
  exact ?_

theorem DISCOVER_D3_GAUSSIAN_L2_LIMIT : D3_GaussianApproximationL2 := by
  unfold D3_GaussianApproximationL2
  d3_gap "GAUSSIAN_L2_LIMIT"
  exact ?_

theorem DISCOVER_D3_REMOVE_GAUSSIAN_FREQ : D3_RemoveGaussianFrequency := by
  unfold D3_RemoveGaussianFrequency
  d3_gap "REMOVE_GAUSSIAN_FREQUENCY"
  exact ?_

end MCore.RH.R0
