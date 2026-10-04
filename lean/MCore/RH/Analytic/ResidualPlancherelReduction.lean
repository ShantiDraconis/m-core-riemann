import MCore.RH.Analytic.CriticalFrequencyScaling
import MCore.RH.Analytic.ResidualMellin

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Integral-form Plancherel for functions for which the classical Fourier integral is defined. -/
def FourierIntegralPlancherel : Prop :=
  ∀ g : ℝ → ℂ,
    Integrable g volume →
    MemLp g 2 volume →
    (∫ y : ℝ, ‖𝓕 g y‖ ^ 2) = ∫ u : ℝ, ‖g u‖ ^ 2

/-- Mellin--Plancherel at the critical line, reduced to Fourier Plancherel. -/
theorem critical_mellin_plancherel_of_fourier
    (hFourier : FourierIntegralPlancherel)
    (f : ℝ → ℂ)
    (hL1 : Integrable (criticalLogTransport f) volume)
    (hL2 : MemLp (criticalLogTransport f) 2 volume) :
    (1 / (2 * Real.pi)) *
      (∫ t : ℝ, ‖mellin f ((1 / 2 : ℝ) + t * I)‖ ^ 2) =
      ∫ x : ℝ in Ioi 0, ‖f x‖ ^ 2 := by
  calc
    (1 / (2 * Real.pi)) *
        (∫ t : ℝ, ‖mellin f ((1 / 2 : ℝ) + t * I)‖ ^ 2)
        = (1 / (2 * Real.pi)) *
            (∫ t : ℝ,
              ‖𝓕 (criticalLogTransport f) (t / (2 * Real.pi))‖ ^ 2) := by
              congr 1
              apply integral_congr_ae
              filter_upwards with t
              rw [mellin_criticalLine_eq_fourier]
    _ = ∫ y : ℝ, ‖𝓕 (criticalLogTransport f) y‖ ^ 2 := by
          exact criticalLine_frequency_scale f
    _ = ∫ u : ℝ, ‖criticalLogTransport f u‖ ^ 2 := by
          exact hFourier (criticalLogTransport f) hL1 hL2
    _ = ∫ x : ℝ in Ioi 0, ‖f x‖ ^ 2 := by
          exact criticalLogTransport_integral_norm_sq f

/-- Critical-line residual formula in the exact scalar denominator form. -/
theorem residual_mellin_norm_sq
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    ‖mellin (complexResidual c) ((1 / 2 : ℝ) + t * I)‖ ^ 2 =
      Complex.normSq
        (1 + riemannZeta ((1 / 2 : ℝ) + t * I) *
          concreteDirichletPolynomial c ((1 / 2 : ℝ) + t * I)) /
        ((1 / 4 : ℝ) + t ^ 2) := by
  have hs0 : 0 < (((1 / 2 : ℝ) + t * I : ℂ).re) := by norm_num
  have hs1 : (((1 / 2 : ℝ) + t * I : ℂ).re) < 1 := by norm_num
  rw [mellin_complexResidual c _ hs0 hs1]
  rw [norm_div, sq_div, Complex.sq_norm]
  have hden :
      ‖((1 / 2 : ℝ) + t * I : ℂ)‖ ^ 2 = (1 / 4 : ℝ) + t ^ 2 := by
    rw [Complex.sq_norm]
    simp [Complex.normSq, pow_two]
    ring
  rw [hden]

/-- D3 at integral level: only Fourier Plancherel remains as an operator input. -/
theorem residual_mellin_plancherel_integral
    (hFourier : FourierIntegralPlancherel)
    {N : ℕ} (c : Fin N → ℝ)
    (hL1 : Integrable (criticalLogTransport (complexResidual c)) volume)
    (hL2 : MemLp (criticalLogTransport (complexResidual c)) 2 volume) :
    (∫ x : ℝ in Ioi 0, ‖complexResidual c x‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta ((1 / 2 : ℝ) + t * I) *
              concreteDirichletPolynomial c ((1 / 2 : ℝ) + t * I)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  rw [← critical_mellin_plancherel_of_fourier hFourier
    (complexResidual c) hL1 hL2]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  exact residual_mellin_norm_sq c t

#print axioms MCore.RH.R0.critical_mellin_plancherel_of_fourier
#print axioms MCore.RH.R0.residual_mellin_norm_sq
#print axioms MCore.RH.R0.residual_mellin_plancherel_integral

end MCore.RH.R0
