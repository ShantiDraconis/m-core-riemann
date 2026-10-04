import MCore.RH.Analytic.ResidualLogPullbackLp
import MCore.RH.Analytic.FourierPointwiseBridgeReduction

namespace MCore.RH.R0

open MeasureTheory Complex
open scoped FourierTransform

/--
The unique remaining D3 representation gap:
the pointwise Fourier integral agrees almost everywhere with Mathlib's abstract L2 Fourier transform.
-/
structure ResidualPointwiseFourierAeBridge where
  aeEq : ∀ {N : ℕ} (c : Fin N → ℝ),
    (fun ξ : ℝ => 𝓕 (residualLogPullback c) ξ) =ᵐ[volume]
      ((𝓕 ((residualLogPullback_memLp c).toLp
        (residualLogPullback c))) : ℝ → ℂ)

/-- The a.e. bridge automatically gives L2 membership of the pointwise Fourier integral. -/
theorem pointwiseFourier_memLp_of_aeBridge
    (h : ResidualPointwiseFourierAeBridge)
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (fun ξ : ℝ => 𝓕 (residualLogPullback c) ξ) 2 volume := by
  let F : Lp (α := ℝ) ℂ 2 volume :=
    𝓕 ((residualLogPullback_memLp c).toLp (residualLogPullback c))
  have hF : MemLp (F : ℝ → ℂ) 2 volume := Lp.memLp F
  exact (memLp_congr_ae (h.aeEq c)).mpr hF

/-- The corresponding pointwise toLp element is exactly the abstract Fourier transform. -/
theorem pointwiseFourier_toLp_eq_of_aeBridge
    (h : ResidualPointwiseFourierAeBridge)
    {N : ℕ} (c : Fin N → ℝ) :
    (pointwiseFourier_memLp_of_aeBridge h c).toLp
        (fun ξ : ℝ => 𝓕 (residualLogPullback c) ξ) =
      𝓕 ((residualLogPullback_memLp c).toLp (residualLogPullback c)) := by
  apply Lp.ext
  exact (pointwiseFourier_memLp_of_aeBridge h c).coeFn_toLp.trans
    ((h.aeEq c).trans
      (Lp.coeFn_toLp (Lp.memLp
        (𝓕 ((residualLogPullback_memLp c).toLp
          (residualLogPullback c))))).symm)

/-- The one-field a.e. bridge realizes the previous full pointwise/L2 bridge. -/
theorem pointwiseFourierLpBridge_of_aeBridge
    (h : ResidualPointwiseFourierAeBridge) :
    ResidualPointwiseFourierLpBridge where
  memLpInput := fun c => residualLogPullback_memLp c
  memLpFourier := fun c => pointwiseFourier_memLp_of_aeBridge h c
  toLp_eq := fun c => pointwiseFourier_toLp_eq_of_aeBridge h c

/-- Therefore D3 is implied by exactly one a.e. Fourier representation statement. -/
theorem residualCriticalLinePlancherel_of_aeBridge
    (h : ResidualPointwiseFourierAeBridge) :
    ResidualCriticalLinePlancherel :=
  residualCriticalLinePlancherel_of_pointwiseBridge
    (pointwiseFourierLpBridge_of_aeBridge h)

#print axioms MCore.RH.R0.pointwiseFourier_memLp_of_aeBridge
#print axioms MCore.RH.R0.pointwiseFourier_toLp_eq_of_aeBridge
#print axioms MCore.RH.R0.residualCriticalLinePlancherel_of_aeBridge

end MCore.RH.R0
