import MCore.RH.Analytic.MellinResidualAlgebra
import MCore.RH.R0.LinearIndependentReduction
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.LpSpace

open scoped BigOperators

namespace MCore.RH.R0

open Complex MeasureTheory Set

/-- Critical-line parameter. -/
noncomputable def criticalLine (t : ℝ) : ℂ :=
  (1 / 2 : ℝ) + (t : ℂ) * I

@[simp] theorem criticalLine_re (t : ℝ) :
    (criticalLine t).re = 1 / 2 := by
  simp [criticalLine]

@[simp] theorem criticalLine_im (t : ℝ) :
    (criticalLine t).im = t := by
  simp [criticalLine]

/-- Norm square of the critical-line parameter. -/
theorem normSq_criticalLine (t : ℝ) :
    normSq (criticalLine t) = 1 / 4 + t ^ 2 := by
  simp [criticalLine, normSq_apply]
  ring

/-- Pointwise D3 formula on the critical line, already forced by D1+D2. -/
theorem mellin_complexResidual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (complexResidual c) (criticalLine t) =
      (1 + riemannZeta (criticalLine t) *
        concreteDirichletPolynomial c (criticalLine t)) /
        criticalLine t := by
  exact mellin_complexResidual c (criticalLine t) (by norm_num) (by norm_num)

/-- Squared norm of the pointwise Mellin residual in explicit zeta form. -/
theorem normSq_mellin_complexResidual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    normSq (mellin (complexResidual c) (criticalLine t)) =
      normSq
        (1 + riemannZeta (criticalLine t) *
          concreteDirichletPolynomial c (criticalLine t)) /
        (1 / 4 + t ^ 2) := by
  rw [mellin_complexResidual_criticalLine c t, normSq_div, normSq_criticalLine]

/--
The only remaining analytic producer for D3: Mellin-Plancherel on the frozen
positive-half-line L2 normalization.
-/
def ResidualMellinPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Ioi 0, normSq (complexResidual c x)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ, normSq (mellin (complexResidual c) (criticalLine t))

/-- Once Mellin-Plancherel is available, D3 has the desired explicit integrand. -/
theorem residual_plancherel_explicit
    (hP : ResidualMellinPlancherel)
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ x : ℝ in Ioi 0, normSq (complexResidual c x)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          normSq
            (1 + riemannZeta (criticalLine t) *
              concreteDirichletPolynomial c (criticalLine t)) /
            (1 / 4 + t ^ 2) := by
  rw [hP c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  exact normSq_mellin_complexResidual_criticalLine c t

#print axioms MCore.RH.R0.mellin_complexResidual_criticalLine
#print axioms MCore.RH.R0.normSq_mellin_complexResidual_criticalLine
#print axioms MCore.RH.R0.residual_plancherel_explicit

end MCore.RH.R0
