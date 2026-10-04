import MCore.RH.Analytic.LogPullbackNorm
import MCore.RH.Analytic.MellinPlancherelFourierReduction
import Mathlib.MeasureTheory.Measure.Haar.NormedSpace

namespace MCore.RH.R0

/-- Unscaled Fourier energy equality for the logarithmic pullback. -/
def ResidualFourierPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ u : ℝ, Complex.normSq (residualLogPullback c u)) =
      ∫ y : ℝ, Complex.normSq (𝓕 (residualLogPullback c) y)

/-- Frequency rescaling y=t/(2π). -/
theorem fourier_energy_frequency_rescale
    (f : ℝ → ℂ) :
    (1 / (2 * Real.pi)) *
        (∫ t : ℝ, Complex.normSq (𝓕 f (t / (2 * Real.pi)))) =
      ∫ y : ℝ, Complex.normSq (𝓕 f y) := by
  let a : ℝ := 1 / (2 * Real.pi)
  have ha : 0 < a := by
    dsimp [a]
    positivity
  have hscale := Measure.integral_comp_mul_left
    (fun y : ℝ => Complex.normSq (𝓕 f y)) a
  have habs : |a⁻¹| = 2 * Real.pi := by
    rw [abs_of_pos (inv_pos.mpr ha)]
    dsimp [a]
    field_simp [Real.pi_ne_zero]
  rw [habs] at hscale
  have harg :
      (fun t : ℝ => Complex.normSq (𝓕 f (a * t))) =
        fun t : ℝ => Complex.normSq (𝓕 f (t / (2 * Real.pi))) := by
    funext t
    dsimp [a]
    congr 2
    field_simp [Real.pi_ne_zero]
  rw [harg] at hscale
  rw [hscale]
  field_simp [Real.pi_ne_zero]

/-- Ordinary Fourier Plancherel implies the scaled D3 Fourier producer. -/
theorem residualFourierPlancherelScaled_of_unscaled
    (h : ResidualFourierPlancherel) :
    ResidualFourierPlancherelScaled := by
  intro N c
  rw [h c]
  rw [fourier_energy_frequency_rescale]

/-- Therefore D3 now depends only on ordinary Fourier Plancherel for the log-pullback. -/
theorem residualMellinPlancherel_of_fourierPlancherel
    (h : ResidualFourierPlancherel) :
    ResidualMellinPlancherel := by
  exact residualMellinPlancherel_of_fourier_bridges
    residualLogPullbackNorm_realized
    (residualFourierPlancherelScaled_of_unscaled h)

#print axioms MCore.RH.R0.fourier_energy_frequency_rescale
#print axioms MCore.RH.R0.residualMellinPlancherel_of_fourierPlancherel

end MCore.RH.R0
