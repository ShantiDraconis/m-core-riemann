import MCore.RH.Analytic.FourierCompatibilityReduction
import Mathlib.Analysis.Distribution.TemperedDistribution
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.Analysis.Distribution.SchwartzSpace.Fourier

namespace MCore.RH.R0

open MeasureTheory

/--
Pairing identity for the concrete log-pullback. It is the standard L1/L2
compatibility theorem, proved by comparing both Fourier transforms as
tempered distributions against Schwartz tests.
-/
theorem residualFourierTestPairingCompatibility_realized :
    ResidualFourierTestPairingCompatibility := by
  intro N c h1 h2 φ hφsmooth hφcompact
  let ψ : 𝓢(ℝ, ℂ) :=
    (hφcompact.comp_left rfl).toSchwartzMap
      (Complex.ofRealCLM.contDiff.comp hφsmooth)
  have hLpDist := MeasureTheory.Lp.fourier_toTemperedDistribution_eq
    (h2.toLp (residualLogPullback c))
  have hLpPair :
      ∫ y : ℝ,
        (φ y : ℂ) *
          (((𝓕 (h2.toLp (residualLogPullback c)) : Lp ℂ 2 volume) : ℝ → ℂ) y) =
      (𝓕 ((h2.toLp (residualLogPullback c) : Lp ℂ 2 volume) : 𝓢'(ℝ, ℂ))) ψ := by
    rw [hLpDist]
    simp [ψ, mul_comm]
  have hL1 : Integrable (residualLogPullback c) := by
    exact memLp_one_iff_integrable.mp h1
  have hψ : Integrable (fun y : ℝ => (φ y : ℂ)) := by
    exact ψ.integrable
  have hFubini :
      ∫ y : ℝ,
        (𝓕 (residualLogPullback c) y) * (φ y : ℂ) =
      ∫ x : ℝ,
        residualLogPullback c x * (𝓕 (fun y : ℝ => (φ y : ℂ)) x) := by
    simpa [Real.fourier_eq, mul_comm] using
      (VectorFourier.integral_bilin_fourierIntegral_eq_flip
        (ContinuousLinearMap.mul ℂ ℂ)
        (L := innerₗ ℝ)
        Real.continuous_fourierChar continuous_inner hL1 hψ)
  have hDistPair :
      (𝓕 ((h2.toLp (residualLogPullback c) : Lp ℂ 2 volume) : 𝓢'(ℝ, ℂ))) ψ =
      ∫ y : ℝ, (𝓕 (residualLogPullback c) y) * (φ y : ℂ) := by
    -- Fourier on L2 agrees with Fourier on tempered distributions; evaluating
    -- on ψ gives the same self-adjoint Fourier pairing as the ordinary L1 transform.
    rw [TemperedDistribution.fourier_apply]
    simp only [ψ, hFubini]
    rfl
  have heq :
      ∫ y : ℝ,
        (φ y : ℂ) *
          (((𝓕 (h2.toLp (residualLogPullback c)) : Lp ℂ 2 volume) : ℝ → ℂ) y) =
      ∫ y : ℝ,
        (φ y : ℂ) * (𝓕 (residualLogPullback c) y) := by
    rw [hLpPair, hDistPair]
    apply integral_congr_ae
    filter_upwards with y
    ring
  rw [integral_sub]
  · simpa [smul_eq_mul, mul_sub] using sub_eq_zero.mpr heq
  · exact (Lp.memLp
      (𝓕 (h2.toLp (residualLogPullback c)) : Lp ℂ 2 volume)).locallyIntegrable
        (by norm_num) |>.integrable_of_hasCompactSupport hφcompact
  · exact (ordinaryFourier_locallyIntegrable h1).integrable_of_hasCompactSupport hφcompact

#print axioms MCore.RH.R0.residualFourierTestPairingCompatibility_realized

end MCore.RH.R0
