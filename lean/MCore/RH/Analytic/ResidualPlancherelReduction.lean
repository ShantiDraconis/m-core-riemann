import MCore.RH.Analytic.ResidualMellin
import MCore.RH.NB.CoefficientRealization

namespace MCore.RH.R0

open MeasureTheory Set Complex
open MCore.RH.NB
open scoped BigOperators

/-- Standard critical-line parameterization. -/
noncomputable def criticalLinePoint (t : ℝ) : ℂ :=
  ((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I

@[simp] theorem criticalLinePoint_re (t : ℝ) :
    (criticalLinePoint t).re = 1 / 2 := by
  simp [criticalLinePoint]

@[simp] theorem criticalLinePoint_im (t : ℝ) :
    (criticalLinePoint t).im = t := by
  simp [criticalLinePoint]

theorem criticalLinePoint_normSq (t : ℝ) :
    Complex.normSq (criticalLinePoint t) = 1 / 4 + t ^ 2 := by
  simp [criticalLinePoint, Complex.normSq_apply]
  ring

/-- Pointwise residual Mellin formula on the critical line. -/
theorem mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLinePoint t) =
      (1 + riemannZeta (criticalLinePoint t) *
        dirichletPolynomialC c (criticalLinePoint t)) /
        criticalLinePoint t := by
  exact mellin_residualRepresentativeC c (criticalLinePoint t)
    (by norm_num [criticalLinePoint])
    (by norm_num [criticalLinePoint])

/-- The denominator on the critical line is exactly 1/4+t^2. -/
theorem normSq_mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    Complex.normSq
      (mellin (residualRepresentativeC c) (criticalLinePoint t)) =
      Complex.normSq
        (1 + riemannZeta (criticalLinePoint t) *
          dirichletPolynomialC c (criticalLinePoint t)) /
        (1 / 4 + t ^ 2) := by
  rw [mellin_residual_criticalLine c t]
  rw [Complex.normSq_div]
  rw [criticalLinePoint_normSq]

/-- The R0 finite combination is definitionally the NB coefficient approximant. -/
theorem concreteFiniteCombination_eq_coefficientApproximantAt
    {N : ℕ} (c : Fin N → ℝ) :
    concreteFiniteCombination c =
      concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c := by
  rfl

/--
The sole remaining D3 producer: Mellin-Plancherel for the finite residual.
Everything else in the explicit critical-line integral is already fixed.
-/
def ResidualMellinPlancherelBridge : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (mellin (residualRepresentativeC c) (criticalLinePoint t))

/-- D3 follows mechanically once the sole Plancherel bridge is inhabited. -/
theorem residual_mellin_plancherel_explicit
    (h : ResidualMellinPlancherelBridge)
    (N : ℕ) (c : Fin N → ℝ) :
    ‖concreteNBData.chi -
        concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLinePoint t) *
              dirichletPolynomialC c (criticalLinePoint t)) /
            (1 / 4 + t ^ 2) := by
  rw [← concreteFiniteCombination_eq_coefficientApproximantAt c]
  rw [h N c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  exact normSq_mellin_residual_criticalLine c t

#print axioms MCore.RH.R0.mellin_residual_criticalLine
#print axioms MCore.RH.R0.normSq_mellin_residual_criticalLine
#print axioms MCore.RH.R0.concreteFiniteCombination_eq_coefficientApproximantAt
#print axioms MCore.RH.R0.residual_mellin_plancherel_explicit

end MCore.RH.R0
