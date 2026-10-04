import MCore.RH.Analytic.MellinResidual
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.LpSpace

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Critical-line parameter in the Mellin normalization used by Mathlib. -/
noncomputable def criticalLine (t : ℝ) : ℂ :=
  (1 / 2 : ℂ) + (t : ℂ) * I

/-- Squared modulus of the explicit residual Mellin transform. -/
noncomputable def residualCriticalDensity
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) : ℝ :=
  Complex.normSq
    ((1 + riemannZeta (criticalLine t) *
      concreteDirichletPolynomial c (criticalLine t)) /
      criticalLine t)

/--
The one remaining analytic isometry needed for D3.

It is exactly Mellin--Plancherel at sigma = 1/2 in Mathlib's Fourier
normalization. The factor 1/(2*pi) comes from the Fourier frequency
`s.im / (2*pi)` in Mathlib's Mellin-to-Fourier identity.
-/
def CriticalLineMellinPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ, residualCriticalDensity c t

/-- The critical-line Mellin value of the residual is already closed algebraically. -/
theorem mellin_residual_on_critical_line
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLine t) =
      (1 + riemannZeta (criticalLine t) *
        concreteDirichletPolynomial c (criticalLine t)) /
      criticalLine t := by
  apply mellin_residualRepresentativeC
  · simp [criticalLine]
  · simp [criticalLine]

/-- Rewrite the denominator on the critical line as 1/4 + t^2. -/
theorem criticalLine_normSq (t : ℝ) :
    Complex.normSq (criticalLine t) = (1 / 4 : ℝ) + t ^ 2 := by
  simp [criticalLine, Complex.normSq_apply]
  ring

/-- D3 explicit formula follows from the single critical-line Plancherel producer. -/
theorem residual_plancherel_explicit_of_criticalLine
    (hpl : CriticalLineMellinPlancherel)
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ x : ℝ in Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLine t) *
              concreteDirichletPolynomial c (criticalLine t)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  rw [hpl c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  unfold residualCriticalDensity
  rw [Complex.normSq_div]
  rw [criticalLine_normSq]
  rfl

/-- Mathlib's pointwise Mellin-to-Fourier bridge, recorded for the D3 producer. -/
theorem residual_mellin_eq_fourier
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) :
    mellin (residualRepresentativeC c) s =
      𝓕 (fun u : ℝ =>
        Real.exp (-s.re * u) •
          residualRepresentativeC c (Real.exp (-u)))
        (s.im / (2 * Real.pi)) := by
  exact mellin_eq_fourier (residualRepresentativeC c)

#print axioms MCore.RH.R0.mellin_residual_on_critical_line
#print axioms MCore.RH.R0.residual_plancherel_explicit_of_criticalLine
#print axioms MCore.RH.R0.residual_mellin_eq_fourier

end MCore.RH.R0
