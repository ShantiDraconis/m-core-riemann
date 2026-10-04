import MCore.RH.Analytic.MellinResidual

namespace MCore.RH.R0

open Complex

/-- Critical-line parametrization used by Mellin--Plancherel. -/
noncomputable def criticalLine (t : ℝ) : ℂ :=
  (1 / 2 : ℂ) + Complex.I * (t : ℂ)

@[simp] theorem criticalLine_re (t : ℝ) :
    (criticalLine t).re = 1 / 2 := by
  simp [criticalLine]

@[simp] theorem criticalLine_normSq (t : ℝ) :
    Complex.normSq (criticalLine t) = (1 / 4 : ℝ) + t ^ 2 := by
  simp [criticalLine, Complex.normSq_apply]
  ring

/-- Mellin transform of the residual on the critical line. -/
theorem mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLine t) =
      (1 + riemannZeta (criticalLine t) *
        concreteDirichletPolynomial c (criticalLine t)) /
      criticalLine t := by
  apply mellin_residual_closed_form
  · simp [criticalLine]
  · simp [criticalLine]

/-- Pointwise spectral density identity; no Plancherel input is used here. -/
theorem normSq_mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    Complex.normSq (mellin (residualRepresentativeC c) (criticalLine t)) =
      Complex.normSq
        (1 + riemannZeta (criticalLine t) *
          concreteDirichletPolynomial c (criticalLine t)) /
        ((1 / 4 : ℝ) + t ^ 2) := by
  rw [mellin_residual_criticalLine]
  rw [Complex.normSq_div]
  rw [criticalLine_normSq]

#print axioms MCore.RH.R0.mellin_residual_criticalLine
#print axioms MCore.RH.R0.normSq_mellin_residual_criticalLine

end MCore.RH.R0
