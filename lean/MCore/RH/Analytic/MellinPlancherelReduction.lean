import MCore.RH.Analytic.MellinResidual
import MCore.RH.NB.GramEnergy
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.LpSpace

open scoped BigOperators

namespace MCore.RH.R0

open MCore.RH.NB
open MeasureTheory Complex Set

/-- Critical-line parameter in the normalization used by the Mellin formulas. -/
noncomputable def criticalLinePoint (t : ℝ) : ℂ :=
  (1 / 2 : ℝ) + t * Complex.I

/-- The concrete real L2 residual and the literal complex representative have the same squared norm. -/
def ResidualL2IntegralIdentity : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    ‖concreteNBData.chi -
      concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c‖ ^ 2 =
      ∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)

/-- Mellin-Plancherel at sigma=1/2, with the 2pi scaling made explicit. -/
def CriticalLineMellinPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (mellin (residualRepresentativeC c) (criticalLinePoint t))

/-- Algebraic denominator on the critical line. -/
theorem criticalLinePoint_normSq (t : ℝ) :
    Complex.normSq (criticalLinePoint t) = (1 / 4 : ℝ) + t ^ 2 := by
  unfold criticalLinePoint
  simp [Complex.normSq, pow_two]
  ring

/-- Pointwise residual Mellin formula specialized to the critical line. -/
theorem mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLinePoint t) =
      (1 + riemannZeta (criticalLinePoint t) *
        concreteDirichletPolynomial c (criticalLinePoint t)) /
      criticalLinePoint t := by
  apply mellin_residualRepresentativeC
  · unfold criticalLinePoint
    simp
    norm_num
  · unfold criticalLinePoint
    simp
    norm_num

/-- Norm-square form of the pointwise critical-line formula. -/
theorem normSq_mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    Complex.normSq
      (mellin (residualRepresentativeC c) (criticalLinePoint t)) =
      Complex.normSq
        (1 + riemannZeta (criticalLinePoint t) *
          concreteDirichletPolynomial c (criticalLinePoint t)) /
        ((1 / 4 : ℝ) + t ^ 2) := by
  rw [mellin_residual_criticalLine c t]
  rw [Complex.normSq_div]
  rw [criticalLinePoint_normSq]

/--
D3 follows mechanically once the two genuine L2/Fourier bridges are inhabited.
No zeta algebra remains hidden in this theorem.
-/
theorem residual_mellin_plancherel_of_bridges
    (hL2 : ResidualL2IntegralIdentity)
    (hPl : CriticalLineMellinPlancherel)
    {N : ℕ} (c : Fin N → ℝ) :
    ‖concreteNBData.chi -
      concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLinePoint t) *
              concreteDirichletPolynomial c (criticalLinePoint t)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  rw [hL2 c]
  rw [hPl c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  exact normSq_mellin_residual_criticalLine c t

#print axioms MCore.RH.R0.criticalLinePoint_normSq
#print axioms MCore.RH.R0.mellin_residual_criticalLine
#print axioms MCore.RH.R0.residual_mellin_plancherel_of_bridges

end MCore.RH.R0
