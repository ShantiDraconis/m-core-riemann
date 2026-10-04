import MCore.RH.Analytic.ResidualMellin
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.LpSpace

namespace MCore.RH.R0

open scoped FourierTransform
open Complex MeasureTheory Set

/-- Standard critical-line parameter. -/
noncomputable def criticalLine (t : ℝ) : ℂ :=
  (1 / 2 : ℂ) + (t : ℂ) * Complex.I

/-- Logarithmic lift used by Mathlib's Mellin/Fourier identity at Re(s)=1/2. -/
noncomputable def residualLogLift
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) : ℂ :=
  Real.exp (-(1 / 2 : ℝ) * u) *
    residualRepresentativeC c (Real.exp (-u))

@[simp] theorem criticalLine_re (t : ℝ) :
    (criticalLine t).re = 1 / 2 := by
  simp [criticalLine]

@[simp] theorem criticalLine_im (t : ℝ) :
    (criticalLine t).im = t := by
  simp [criticalLine]

@[simp] theorem criticalLine_normSq (t : ℝ) :
    Complex.normSq (criticalLine t) = 1 / 4 + t ^ 2 := by
  simp [criticalLine, Complex.normSq]
  ring

/-- Pointwise Mellin/Fourier identity on the critical line with Mathlib normalization. -/
theorem mellin_residual_eq_fourierIntegral
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLine t) =
      𝓕 (residualLogLift c) (t / (2 * Real.pi)) := by
  simpa [criticalLine, residualLogLift, smul_eq_mul] using
    (mellin_eq_fourierIntegral
      (residualRepresentativeC c)
      (s := criticalLine t))

/-- Closed critical-line formula supplied by D1+D2 plus finite linearity. -/
theorem mellin_residual_critical_closed_form
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLine t) =
      (1 + riemannZeta (criticalLine t) *
        concreteDirichletPolynomial c (criticalLine t)) /
      criticalLine t := by
  exact mellin_residual_closed_form c (criticalLine t)
    (by norm_num [criticalLine])
    (by norm_num [criticalLine])

/--
The sole analytic norm identity left in D3 after the Mellin algebra is closed.
This is exactly Mellin-Plancherel with Mathlib's Fourier normalization.
-/
def ResidualMellinPlancherelCore : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (mellin (residualRepresentativeC c) (criticalLine t))

/-- D3 in fully explicit zeta/Dirichlet-polynomial form follows from the Plancherel core. -/
theorem residual_mellin_plancherel_closed_form
    (hP : ResidualMellinPlancherelCore)
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            ((1 + riemannZeta (criticalLine t) *
                concreteDirichletPolynomial c (criticalLine t)) /
              criticalLine t) := by
  rw [hP c]
  apply congrArg (fun z : ℝ => (1 / (2 * Real.pi)) * z)
  apply integral_congr_ae
  filter_upwards with t
  rw [mellin_residual_critical_closed_form c t]

/-- Final D3 integrand in the usual weighted zeta form. -/
theorem residual_mellin_plancherel_weighted
    (hP : ResidualMellinPlancherelCore)
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLine t) *
              concreteDirichletPolynomial c (criticalLine t)) /
            (1 / 4 + t ^ 2) := by
  rw [residual_mellin_plancherel_closed_form hP c]
  apply congrArg (fun z : ℝ => (1 / (2 * Real.pi)) * z)
  apply integral_congr_ae
  filter_upwards with t
  rw [Complex.normSq_div, criticalLine_normSq]

#print axioms MCore.RH.R0.mellin_residual_eq_fourierIntegral
#print axioms MCore.RH.R0.mellin_residual_critical_closed_form
#print axioms MCore.RH.R0.residual_mellin_plancherel_closed_form
#print axioms MCore.RH.R0.residual_mellin_plancherel_weighted

end MCore.RH.R0
