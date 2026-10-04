import MCore.RH.Analytic.FourierLpCompatibility
import Mathlib.Analysis.Distribution.AEEqOfIntegralContDiff
import Mathlib.MeasureTheory.Function.LocallyIntegrable

namespace MCore.RH.R0

open MeasureTheory

/--
Minimal compatibility statement: the L2 Fourier extension and the ordinary
Fourier integral have identical pairings against every real smooth compactly
supported test function.
-/
def ResidualFourierTestPairingCompatibility : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ)
    (h1 : MemLp (residualLogPullback c) 1 volume)
    (h2 : MemLp (residualLogPullback c) 2 volume)
    (φ : ℝ → ℝ),
    ContDiff ℝ ∞ φ → HasCompactSupport φ →
    ∫ y : ℝ,
      φ y •
        (((𝓕 (h2.toLp (residualLogPullback c)) : Lp ℂ 2 volume) : ℝ → ℂ) y -
          𝓕 (residualLogPullback c) y) = 0

/-- The ordinary Fourier integral of an L1 function is locally integrable. -/
theorem ordinaryFourier_locallyIntegrable
    {f : ℝ → ℂ} (hf : MemLp f 1 volume) :
    LocallyIntegrable (fun y : ℝ => 𝓕 f y) volume := by
  have hcont : Continuous (fun y : ℝ => 𝓕 f y) := by
    simpa [← MeasureTheory.Lp.fourierTransform_toLp hf] using
      (MeasureTheory.Lp.fourierTransform hf.toLp).continuous
  exact hcont.locallyIntegrable

/--
Pairing compatibility implies the desired a.e. equality between the L2
extension and the ordinary Fourier integral.
-/
theorem residualFourier_ae_eq_of_test_pairing
    (hpair : ResidualFourierTestPairingCompatibility)
    {N : ℕ} (c : Fin N → ℝ)
    (h1 : MemLp (residualLogPullback c) 1 volume)
    (h2 : MemLp (residualLogPullback c) 2 volume) :
    ((𝓕 (h2.toLp (residualLogPullback c)) : Lp ℂ 2 volume) : ℝ → ℂ)
      =ᵐ[volume]
    (fun y : ℝ => 𝓕 (residualLogPullback c) y) := by
  rw [← sub_ae_eq_zero]
  apply ae_eq_zero_of_integral_contDiff_smul_eq_zero
  · exact ((Lp.memLp
      (𝓕 (h2.toLp (residualLogPullback c)) : Lp ℂ 2 volume)).locallyIntegrable
        (by norm_num)).sub (ordinaryFourier_locallyIntegrable h1)
  · intro φ hφsmooth hφcompact
    exact hpair c h1 h2 φ hφsmooth hφcompact

/-- Membership plus the single pairing producer gives the full D3 compatibility certificate. -/
theorem residualFourierCompatibility_of_test_pairing
    (hpair : ResidualFourierTestPairingCompatibility)
    {N : ℕ} (c : Fin N → ℝ)
    (h1 : MemLp (residualLogPullback c) 1 volume)
    (h2 : MemLp (residualLogPullback c) 2 volume) :
    ResidualFourierCompatibility c := by
  exact {
    memLpOne := h1
    memLpTwo := h2
    ae_fourier := residualFourier_ae_eq_of_test_pairing hpair c h1 h2
  }

#print axioms MCore.RH.R0.residualFourier_ae_eq_of_test_pairing
#print axioms MCore.RH.R0.residualFourierCompatibility_of_test_pairing

end MCore.RH.R0
