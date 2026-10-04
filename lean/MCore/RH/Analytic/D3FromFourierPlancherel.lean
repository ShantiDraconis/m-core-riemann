import MCore.RH.Analytic.FourierIntegralPlancherelReduction
import Mathlib.MeasureTheory.Measure.Haar.NormedSpace

namespace MCore.RH.R0

open MeasureTheory Complex

/-- On the critical line, the Mellin density is the Fourier density at frequency t/(2*pi). -/
theorem residualCriticalDensity_eq_fourier_scaled
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    residualCriticalDensity c t =
      ‖𝓕 (logPullback (residualRepresentativeC c))
        (t / (2 * Real.pi))‖ ^ 2 := by
  unfold residualCriticalDensity
  have hM := mellin_residual_on_critical_line c t
  have hF := residual_mellin_eq_fourier c (criticalLine t)
  have hfun :
      (fun u : ℝ =>
        Real.exp (-(criticalLine t).re * u) •
          residualRepresentativeC c (Real.exp (-u))) =
      logPullback (residualRepresentativeC c) := by
    funext u
    unfold criticalLine logPullback
    simp
    congr 1
    ring
  rw [hfun] at hF
  have him : (criticalLine t).im / (2 * Real.pi) = t / (2 * Real.pi) := by
    simp [criticalLine]
  rw [him] at hF
  rw [← hM, hF]
  exact Complex.normSq_eq_abs _ |>.trans (by simp [Complex.abs])

/-- The 2*pi frequency rescaling converts critical-line integration to Fourier integration. -/
theorem criticalDensity_integral_scaling
    {N : ℕ} (c : Fin N → ℝ) :
    (1 / (2 * Real.pi)) *
      (∫ t : ℝ, residualCriticalDensity c t) =
      ∫ w : ℝ,
        ‖𝓕 (logPullback (residualRepresentativeC c)) w‖ ^ 2 := by
  let g : ℝ → ℝ := fun w =>
    ‖𝓕 (logPullback (residualRepresentativeC c)) w‖ ^ 2
  have hpi : 0 < 2 * Real.pi := by positivity
  have hpoint : residualCriticalDensity c =
      fun t : ℝ => g ((1 / (2 * Real.pi)) * t) := by
    funext t
    rw [residualCriticalDensity_eq_fourier_scaled c t]
    dsimp [g]
    congr 2
    field_simp
  rw [hpoint]
  have hscale := Measure.integral_comp_mul_left g (1 / (2 * Real.pi))
  rw [show |(1 / (2 * Real.pi))⁻¹| = 2 * Real.pi by
    rw [inv_div, one_mul, abs_of_pos hpi]] at hscale
  rw [hscale]
  field_simp [ne_of_gt hpi]

/-- The classical L1-intersection-L2 Plancherel bridge implies the exact D3 producer. -/
theorem criticalLineMellinPlancherel_of_fourierIntegral
    (hP : FourierIntegralPlancherelL1L2) :
    CriticalLineMellinPlancherel := by
  intro N c
  rw [criticalDensity_integral_scaling c]
  exact (residual_fourier_integral_plancherel hP c).symm

/-- Hence the fully explicit zeta/Dirichlet-polynomial D3 identity follows. -/
theorem d3_explicit_of_fourierIntegral
    (hP : FourierIntegralPlancherelL1L2)
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ x : ℝ in Set.Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLine t) *
              concreteDirichletPolynomial c (criticalLine t)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  exact residual_plancherel_explicit_of_criticalLine
    (criticalLineMellinPlancherel_of_fourierIntegral hP) c

#print axioms MCore.RH.R0.criticalDensity_integral_scaling
#print axioms MCore.RH.R0.d3_explicit_of_fourierIntegral

end MCore.RH.R0
