import MCore.RH.Analytic.MellinLogIsometry
import Mathlib.MeasureTheory.Measure.Haar.NormedSpace

namespace MCore.RH.R0

open scoped FourierTransform
open Complex MeasureTheory Set

/--
The only Fourier statement needed after the logarithmic change of variables.
It is ordinary Plancherel on R with Mathlib's Fourier normalization.
-/
def ResidualFourierPlancherelCore : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ u : ℝ, Complex.normSq (residualLogLift c u)) =
      ∫ y : ℝ, Complex.normSq (𝓕 (residualLogLift c) y)

/-- Frequency rescaling t = 2*pi*y. -/
theorem criticalLine_frequency_rescale
    {N : ℕ} (c : Fin N → ℝ) :
    (1 / (2 * Real.pi)) *
        (∫ t : ℝ,
          Complex.normSq
            (mellin (residualRepresentativeC c) (criticalLine t))) =
      ∫ y : ℝ,
        Complex.normSq (𝓕 (residualLogLift c) y) := by
  simp_rw [mellin_residual_eq_fourierIntegral c]
  let a : ℝ := 1 / (2 * Real.pi)
  have ha : 0 < a := by
    dsimp [a]
    positivity
  have hscale := Measure.integral_comp_mul_left
    (fun y : ℝ => Complex.normSq (𝓕 (residualLogLift c) y)) a
  change
    a * (∫ t : ℝ,
      Complex.normSq (𝓕 (residualLogLift c) (a * t))) =
      ∫ y : ℝ, Complex.normSq (𝓕 (residualLogLift c) y)
  rw [hscale]
  rw [abs_of_pos (inv_pos.mpr ha)]
  field_simp [Real.pi_ne_zero]
  ring

/-- Ordinary Fourier Plancherel implies the exact Mellin-Plancherel core. -/
theorem residualMellinPlancherelCore_of_fourier
    (hF : ResidualFourierPlancherelCore) :
    ResidualMellinPlancherelCore := by
  intro N c
  rw [← residualLogLift_integral_normSq c]
  rw [hF c]
  rw [← criticalLine_frequency_rescale c]

#print axioms MCore.RH.R0.criticalLine_frequency_rescale
#print axioms MCore.RH.R0.residualMellinPlancherelCore_of_fourier

end MCore.RH.R0
