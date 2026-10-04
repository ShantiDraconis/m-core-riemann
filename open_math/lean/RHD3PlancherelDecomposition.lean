import MCore.RH.Analytic.MellinPlancherelDecomposition
import MCore.RH.Analytic.MellinFrequencyRescale
import MCore.RH.Analytic.MellinLogPullback
import MCore.RH.Analytic.MellinResidualNormBridge
import MCore.RH.Analytic.D3GaussianKernel
import Mathlib.Analysis.Fourier.Inversion
import Mathlib.Analysis.SpecialFunctions.Gaussian.FourierTransform
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
Pinned-Mathlib D3.2 decomposition.

The pinned revision has Fourier integrals, Gaussian transforms and inversion,
but no packaged L2 Fourier extension.  We therefore use the standard
non-circular Gaussian regularization proof of Plancherel for the specific
criticalLogPullback family.
-/

/-- D3.2.0: the logarithmic pullback is L1. -/
def D3_LogPullbackIntegrable : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    Integrable (criticalLogPullback c)

/-- D3.2.1: the logarithmic pullback is L2. -/
def D3_LogPullbackMemL2 : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    MemLp (criticalLogPullback c) 2 volume

/-- Reuse the canonical Gaussian multiplier/kernel from D3GaussianKernel.lean. -/
abbrev d3GaussianMultiplier := d3GaussianMultiplierReal
abbrev d3HeatKernel := d3HeatKernelReal

/-- Heat regularization K_ε * f. -/
noncomputable def d3HeatRegularization
    {N : ℕ} (c : Fin N → ℝ) (ε u : ℝ) : ℂ :=
  ∫ v : ℝ, (d3HeatKernel ε (u - v) : ℂ) * criticalLogPullback c v

/--
D3.2.2: Gaussian/Fourier convolution identity.  This is a direct Fourier
integral computation and does not invoke L2 Plancherel.
-/
def D3_GaussianConvolutionIdentity : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ) (ε : ℝ), 0 < ε →
    ∀ u : ℝ,
      𝓕 (d3HeatRegularization c ε) u =
        (d3GaussianMultiplier ε u : ℂ) * 𝓕 (criticalLogPullback c) u

/--
D3.2.3: regularized energy identity obtained from the pinned bilinear Fourier
identity (not from Plancherel).
-/
def D3_RegularizedEnergyIdentity : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ) (ε : ℝ), 0 < ε →
    (∫ t : ℝ,
      d3GaussianMultiplier ε t *
        Complex.normSq (𝓕 (criticalLogPullback c) t)) =
    Complex.re
      (∫ u : ℝ,
        criticalLogPullback c u *
          conj (d3HeatRegularization c ε u))

/--
D3.2.4: heat regularization converges to f in the L2 pairing needed on the
spatial side.
-/
def D3_HeatPairingLimit : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    Tendsto
      (fun ε : ℝ =>
        Complex.re
          (∫ u : ℝ,
            criticalLogPullback c u *
              conj (d3HeatRegularization c ε u)))
      (𝓝[>] 0)
      (𝓝 (∫ u : ℝ, Complex.normSq (criticalLogPullback c u)))

/--
D3.2.5: remove the frequency Gaussian. Since 0<=m_ε<=1 and m_ε↑1 as
ε↓0, this is the monotone/dominated convergence step.
-/
def D3_RemoveGaussianFrequency : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    Tendsto
      (fun ε : ℝ =>
        ∫ t : ℝ,
          d3GaussianMultiplier ε t *
            Complex.normSq (𝓕 (criticalLogPullback c) t))
      (𝓝[>] 0)
      (𝓝 (∫ t : ℝ, Complex.normSq (𝓕 (criticalLogPullback c) t)))

/-- The two limits and the regularized identity imply the required Fourier Plancherel bridge. -/
theorem d3_fourierPlancherel_of_regularized
    (hreg : D3_RegularizedEnergyIdentity)
    (hspace : D3_HeatPairingLimit)
    (hfreq : D3_RemoveGaussianFrequency) :
    D3_FourierPlancherelBridge := by
  intro N c
  let F : ℝ → ℝ := fun ε =>
    ∫ t : ℝ,
      d3GaussianMultiplier ε t *
        Complex.normSq (𝓕 (criticalLogPullback c) t)
  let G : ℝ → ℝ := fun ε =>
    Complex.re
      (∫ u : ℝ,
        criticalLogPullback c u *
          conj (d3HeatRegularization c ε u))
  have hFG : F =ᶠ[𝓝[>] (0 : ℝ)] G := by
    filter_upwards [self_mem_nhdsWithin] with ε hε
    exact hreg N c ε hε
  have hF := hfreq N c
  have hG := hspace N c
  exact tendsto_nhds_unique hF (hG.congr' hFG.symm)

theorem DISCOVER_D3_LOG_L1 : D3_LogPullbackIntegrable := by
  unfold D3_LogPullbackIntegrable
  d3_gap "LOG_PULLBACK_L1"
  exact ?_

theorem DISCOVER_D3_LOG_L2 : D3_LogPullbackMemL2 := by
  unfold D3_LogPullbackMemL2
  d3_gap "LOG_PULLBACK_L2"
  exact ?_

theorem DISCOVER_D3_GAUSSIAN_CONVOLUTION :
    D3_GaussianConvolutionIdentity := by
  unfold D3_GaussianConvolutionIdentity
  d3_gap "GAUSSIAN_CONVOLUTION"
  exact ?_

theorem DISCOVER_D3_REGULARIZED_ENERGY :
    D3_RegularizedEnergyIdentity := by
  unfold D3_RegularizedEnergyIdentity
  d3_gap "REGULARIZED_ENERGY_IDENTITY"
  exact ?_

theorem DISCOVER_D3_HEAT_PAIRING_LIMIT :
    D3_HeatPairingLimit := by
  unfold D3_HeatPairingLimit
  d3_gap "HEAT_PAIRING_LIMIT"
  exact ?_

theorem DISCOVER_D3_REMOVE_GAUSSIAN_FREQ :
    D3_RemoveGaussianFrequency := by
  unfold D3_RemoveGaussianFrequency
  d3_gap "REMOVE_GAUSSIAN_FREQUENCY"
  exact ?_

end MCore.RH.R0
