import Mathlib.Analysis.Distribution.FourierSchwartz
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap

namespace MCore.RH.R0

open MeasureTheory Complex Real
open scoped FourierTransform ComplexConjugate

/--
For scalar functions on the real line, Fourier of the conjugate is the
conjugate of the inverse Fourier transform.  This is the semilinear identity
missing from the pinned Fourier API.
-/
theorem fourier_conj_eq_conj_fourierInv
    {h : ℝ → ℂ} (hh : Integrable h) (ξ : ℝ) :
    𝓕 (fun x : ℝ => conj (h x)) ξ = conj (𝓕⁻ h ξ) := by
  rw [Real.fourierIntegral_real_eq_integral_exp_smul]
  rw [Real.fourierIntegralInv_eq']
  rw [← integral_conj]
  apply integral_congr_ae
  filter_upwards with x
  simp only [map_mul, map_exp, conj_ofReal, conj_I, mul_neg, neg_mul]
  ring_nf
  congr 2
  ring

/--
Plancherel for Schwartz functions, backported from the ingredients already
available in the pinned Mathlib revision.
-/
theorem pinned_schwartz_plancherel
    (f : 𝓢(ℝ, ℂ)) :
    (∫ ξ : ℝ, Complex.normSq (𝓕 (f : ℝ → ℂ) ξ)) =
      ∫ x : ℝ, Complex.normSq (f x) := by
  let F : 𝓢(ℝ, ℂ) := SchwartzMap.fourierTransformCLM ℂ f
  have hFint : Integrable (F : ℝ → ℂ) := F.integrable
  have hfint : Integrable (f : ℝ → ℂ) := f.integrable
  have hconjF : Integrable (fun ξ : ℝ => conj (F ξ)) := by
    exact hFint.clm_apply (RCLike.conjLIE.toContinuousLinearMap)
  have hbilin := VectorFourier.integral_bilin_fourierIntegral_eq_flip
    (ContinuousLinearMap.mul ℂ ℂ)
    (e := Real.fourierChar)
    (μ := volume)
    (ν := volume)
    (L := LinearMap.mul ℝ ℝ)
    continuous_fourierChar
    (by fun_prop)
    hfint
    hconjF
  have hFcoe : (F : ℝ → ℂ) = 𝓕 (f : ℝ → ℂ) := by
    rfl
  have hinv : 𝓕⁻ (F : ℝ → ℂ) = (f : ℝ → ℂ) := by
    rw [hFcoe]
    exact f.continuous.fourierInv_fourier_eq f.integrable F.integrable
  calc
    (∫ ξ : ℝ, Complex.normSq (𝓕 (f : ℝ → ℂ) ξ))
        = ∫ ξ : ℝ,
            (𝓕 (f : ℝ → ℂ) ξ) * conj (F ξ) := by
          apply integral_congr_ae
          filter_upwards with ξ
          rw [hFcoe]
          simp [Complex.normSq, mul_comm]
    _ = ∫ x : ℝ,
          (f x) * 𝓕 (fun ξ : ℝ => conj (F ξ)) x := by
          simpa [hFcoe] using hbilin
    _ = ∫ x : ℝ,
          (f x) * conj (𝓕⁻ (F : ℝ → ℂ) x) := by
          apply integral_congr_ae
          filter_upwards with x
          rw [fourier_conj_eq_conj_fourierInv hFint x]
    _ = ∫ x : ℝ, Complex.normSq (f x) := by
          apply integral_congr_ae
          filter_upwards with x
          rw [hinv]
          simp [Complex.normSq, mul_comm]

#print axioms MCore.RH.R0.fourier_conj_eq_conj_fourierInv
#print axioms MCore.RH.R0.pinned_schwartz_plancherel

end MCore.RH.R0
