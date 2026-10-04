import MCore.RH.Analytic.FourierPlancherelReduction
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.MeasureTheory.Function.L2Space

namespace MCore.RH.R0

open MeasureTheory

/--
Exact compatibility datum between the ordinary Fourier integral of the concrete
log-pullback and Mathlib's L2 Fourier extension. This is the density bridge,
not Plancherel itself.
-/
structure ResidualFourierCompatibility {N : ℕ} (c : Fin N → ℝ) where
  memLpOne : MemLp (residualLogPullback c) 1 volume
  memLpTwo : MemLp (residualLogPullback c) 2 volume
  ae_fourier :
    ((𝓕 (memLpTwo.toLp (residualLogPullback c)) : Lp ℂ 2 volume) : ℝ → ℂ)
      =ᵐ[volume]
    (fun y : ℝ => 𝓕 (residualLogPullback c) y)

/-- Squared L2 norm of a concrete representative is its norm-square integral. -/
theorem memLpTwo_norm_sq_eq_integral_normSq
    {f : ℝ → ℂ} (hf : MemLp f 2 volume) :
    ‖hf.toLp f‖ ^ 2 = ∫ x : ℝ, Complex.normSq (f x) := by
  rw [← inner_self_eq_norm_sq_to_K]
  rw [MeasureTheory.L2.inner_def]
  apply integral_congr_ae
  filter_upwards [MemLp.coeFn_toLp hf] with x hx
  rw [hx]
  simp [Complex.inner_self, Complex.sq_norm]

/-- The same identity for an L2 object with a chosen a.e. representative. -/
theorem lpTwo_norm_sq_eq_integral_normSq_of_ae
    (F : Lp ℂ 2 volume) (g : ℝ → ℂ)
    (hfg : (F : ℝ → ℂ) =ᵐ[volume] g) :
    ‖F‖ ^ 2 = ∫ x : ℝ, Complex.normSq (g x) := by
  rw [← inner_self_eq_norm_sq_to_K]
  rw [MeasureTheory.L2.inner_def]
  apply integral_congr_ae
  filter_upwards [hfg] with x hx
  rw [hx]
  simp [Complex.inner_self, Complex.sq_norm]

/-- Compatibility with the L2 extension makes ordinary Fourier Plancherel automatic. -/
theorem residualFourierPlancherel_of_compatibility
    (hcompat : ∀ {N : ℕ} (c : Fin N → ℝ),
      ResidualFourierCompatibility c) :
    ResidualFourierPlancherel := by
  intro N c
  let h := hcompat c
  have hsrc :
      ‖h.memLpTwo.toLp (residualLogPullback c)‖ ^ 2 =
        ∫ u : ℝ, Complex.normSq (residualLogPullback c u) :=
    memLpTwo_norm_sq_eq_integral_normSq h.memLpTwo
  have hdst :
      ‖(𝓕 (h.memLpTwo.toLp (residualLogPullback c)) : Lp ℂ 2 volume)‖ ^ 2 =
        ∫ y : ℝ, Complex.normSq (𝓕 (residualLogPullback c) y) :=
    lpTwo_norm_sq_eq_integral_normSq_of_ae
      (𝓕 (h.memLpTwo.toLp (residualLogPullback c)) : Lp ℂ 2 volume)
      (fun y : ℝ => 𝓕 (residualLogPullback c) y)
      h.ae_fourier
  rw [← hsrc, ← hdst]
  rw [MeasureTheory.Lp.norm_fourier_eq]

#print axioms MCore.RH.R0.residualFourierPlancherel_of_compatibility

end MCore.RH.R0
