import MCore.RH.Analytic.MellinPlancherelDecomposition
import Mathlib.MeasureTheory.Measure.Haar.NormedSpace

namespace MCore.RH.R0

open MeasureTheory Complex

/-- D3.3 is a plain frequency change of variables t = 2*pi*y. -/
theorem d3_frequencyRescale_realized :
    D3_FrequencyRescaleBridge := by
  intro N c
  let F : ℝ → ℝ :=
    fun y => Complex.normSq (𝓕 (criticalLogPullback c) y)
  have h2pi : 0 < 2 * Real.pi := by positivity
  have hscale := Measure.integral_comp_mul_left F ((2 * Real.pi)⁻¹)
  have habs : |((2 * Real.pi)⁻¹)⁻¹| = 2 * Real.pi := by
    rw [inv_inv, abs_of_pos h2pi]
  rw [habs] at hscale
  have harg :
      (fun t : ℝ => F (((2 * Real.pi)⁻¹) * t)) =
        fun t : ℝ => F (t / (2 * Real.pi)) := by
    funext t
    congr 1
    field_simp
  rw [harg] at hscale
  change (∫ y : ℝ, F y) =
    (1 / (2 * Real.pi)) * ∫ t : ℝ, F (t / (2 * Real.pi))
  rw [hscale]
  field_simp
  ring

#print axioms MCore.RH.R0.d3_frequencyRescale_realized

end MCore.RH.R0
