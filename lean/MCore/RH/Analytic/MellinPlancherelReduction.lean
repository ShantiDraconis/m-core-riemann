import MCore.RH.Analytic.MellinResidual
import MCore.RH.R0.LinearIndependentReduction
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.Analysis.MellinInversion

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Critical-line parameterization used by the Plancherel endpoint. -/
noncomputable def criticalLine (t : ℝ) : ℂ :=
  (1 / 2 : ℝ) + t * I

@[simp] theorem criticalLine_re (t : ℝ) :
    (criticalLine t).re = 1 / 2 := by
  simp [criticalLine]

@[simp] theorem criticalLine_im (t : ℝ) :
    (criticalLine t).im = t := by
  simp [criticalLine]

/-- Squared modulus of the critical-line denominator. -/
theorem normSq_criticalLine (t : ℝ) :
    normSq (criticalLine t) = (1 / 4 : ℝ) + t ^ 2 := by
  rw [normSq_apply]
  simp [criticalLine]
  ring

/-- Pointwise D3 formula on the critical line, already implied by D1 + D2. -/
theorem mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLine t) =
      (1 + riemannZeta (criticalLine t) *
        concreteDirichletPolynomial c (criticalLine t)) /
        criticalLine t := by
  apply mellin_residualRepresentativeC c (criticalLine t)
  · norm_num [criticalLine]
  · norm_num [criticalLine]

/-- Pointwise squared-modulus form of the D3 integrand. -/
theorem normSq_mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    normSq (mellin (residualRepresentativeC c) (criticalLine t)) =
      normSq
        (1 + riemannZeta (criticalLine t) *
          concreteDirichletPolynomial c (criticalLine t)) /
        ((1 / 4 : ℝ) + t ^ 2) := by
  rw [mellin_residual_criticalLine c t]
  rw [normSq_div]
  rw [normSq_criticalLine]

/--
The sole Plancherel producer still needed for D3.
All zeta/Dirichlet-polynomial algebra has already been removed from this statement.
-/
def ResidualCriticalLinePlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          normSq (mellin (residualRepresentativeC c) (criticalLine t))

/-- Full explicit D3 follows mechanically from the single Plancherel producer. -/
theorem residual_mellin_plancherel_explicit
    (hP : ResidualCriticalLinePlancherel)
    {N : ℕ} (c : Fin N → ℝ) :
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          normSq
            (1 + riemannZeta (criticalLine t) *
              concreteDirichletPolynomial c (criticalLine t)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  rw [hP c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  exact normSq_mellin_residual_criticalLine c t

#print axioms MCore.RH.R0.mellin_residual_criticalLine
#print axioms MCore.RH.R0.normSq_mellin_residual_criticalLine
#print axioms MCore.RH.R0.residual_mellin_plancherel_explicit

end MCore.RH.R0
