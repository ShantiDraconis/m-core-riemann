import MCore.RH.Analytic.MellinLogIsometry
import MCore.RH.Analytic.MellinPlancherelBridges
import Mathlib.Analysis.Fourier.LpSpace

namespace MCore.RH.R0

open MeasureTheory Complex
open scoped FourierTransform

/--
Exact missing bridge between pointwise Fourier integral and the abstract L2 Fourier transform.
This is a generic L1∩L2 representation issue, not RH-specific mathematics.
-/
structure ResidualPointwiseFourierLpBridge where
  memLpInput : ∀ {N : ℕ} (c : Fin N → ℝ),
    MemLp (residualLogPullback c) 2 volume
  memLpFourier : ∀ {N : ℕ} (c : Fin N → ℝ),
    MemLp (fun ξ : ℝ => 𝓕 (residualLogPullback c) ξ) 2 volume
  toLp_eq : ∀ {N : ℕ} (c : Fin N → ℝ),
    (memLpFourier c).toLp
      (fun ξ : ℝ => 𝓕 (residualLogPullback c) ξ) =
      𝓕 ((memLpInput c).toLp (residualLogPullback c))

/-- L2 norm squared of a concrete representative equals its pointwise norm-square integral. -/
theorem memLp_two_norm_sq_eq_integral_normSq
    {f : ℝ → ℂ} (hf : MemLp f 2 volume) :
    ‖hf.toLp f‖ ^ 2 = ∫ x : ℝ, normSq (f x) := by
  rw [← RCLike.re_to_real (𝕜 := ℂ) (⟪hf.toLp f, hf.toLp f⟫_ℂ)]
  rw [inner_self_eq_norm_sq_to_K]
  simp only [RCLike.re_to_real]
  rw [MeasureTheory.L2.inner_def]
  rw [← integral_re]
  · apply integral_congr_ae
    filter_upwards [hf.coeFn_toLp] with x hx
    rw [hx]
    simp [RCLike.inner_apply, normSq_apply]
  · exact MeasureTheory.L2.integrable_inner _ _ |>.re

/--
The pointwise/L2 bridge plus Mathlib's abstract Plancherel theorem gives the exact
pointwise Fourier norm identity needed by D3.
-/
theorem residualFourierPlancherel_of_pointwiseBridge
    (hbridge : ResidualPointwiseFourierLpBridge) :
    ResidualFourierPlancherel := by
  intro N c
  let hg : MemLp (residualLogPullback c) 2 volume := hbridge.memLpInput c
  let hF : MemLp (fun ξ : ℝ => 𝓕 (residualLogPullback c) ξ) 2 volume :=
    hbridge.memLpFourier c
  rw [← memLp_two_norm_sq_eq_integral_normSq hg]
  rw [← memLp_two_norm_sq_eq_integral_normSq hF]
  rw [hbridge.toLp_eq c]
  rw [MeasureTheory.Lp.norm_fourier_eq]

/-- D3 is now implied by one generic Fourier representation bridge. -/
theorem residualCriticalLinePlancherel_of_pointwiseBridge
    (hbridge : ResidualPointwiseFourierLpBridge) :
    ResidualCriticalLinePlancherel :=
  residualCriticalLinePlancherel_of_two_bridges
    residualLogPullbackIsometry_realized
    (residualFourierPlancherel_of_pointwiseBridge hbridge)

#print axioms MCore.RH.R0.memLp_two_norm_sq_eq_integral_normSq
#print axioms MCore.RH.R0.residualFourierPlancherel_of_pointwiseBridge
#print axioms MCore.RH.R0.residualCriticalLinePlancherel_of_pointwiseBridge

end MCore.RH.R0
