import MCore.RH.Analytic.CriticalLineBasic
import MCore.RH.Analytic.MellinResidualAlgebra

namespace MCore.RH.R0

open Complex MeasureTheory

noncomputable def criticalResidualDensity
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) : ℝ :=
  ‖1 + riemannZeta (criticalLine t) *
      complexDirichletPolynomial c (criticalLine t)‖ ^ 2 /
    (1 / 4 + t ^ 2)

theorem residual_mellin_critical_sq
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    ‖mellin (residualRepresentativeC c) (criticalLine t)‖ ^ 2 =
      criticalResidualDensity c t := by
  have hre0 : 0 < (criticalLine t).re := by
    simp [criticalLine]
  have hre1 : (criticalLine t).re < 1 := by
    simp [criticalLine]
  rw [residual_mellin_closed_form c (criticalLine t) hre0 hre1]
  unfold criticalResidualDensity
  rw [norm_div, div_pow]
  rw [criticalLine_norm_sq]
  ring

#print axioms MCore.RH.R0.residual_mellin_critical_sq

end MCore.RH.R0
