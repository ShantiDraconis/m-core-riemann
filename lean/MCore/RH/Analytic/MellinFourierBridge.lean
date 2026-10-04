import MCore.RH.Analytic.D3Reduction
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.LpSpace

namespace MCore.RH.R0

open Complex MeasureTheory

/-- Logarithmic critical-line pullback of the residual. -/
noncomputable def residualLogPullback
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) : ℂ :=
  Real.exp (-(1 / 2 : ℝ) * u) *
    concreteResidualC c (Real.exp (-u))

/-- Mellin on the critical line is exactly the Fourier transform of the log pullback. -/
theorem mellin_residual_eq_fourier
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (concreteResidualC c) (criticalLine t) =
      𝓕 (residualLogPullback c) (t / (2 * Real.pi)) := by
  rw [mellin_eq_fourier]
  congr 1
  funext u
  simp [criticalLine, residualLogPullback, smul_eq_mul]
  ring_nf

/-- Norm-square form of the pointwise Mellin-Fourier identity. -/
theorem normSq_mellin_residual_eq_fourier
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    Complex.normSq (mellin (concreteResidualC c) (criticalLine t)) =
      Complex.normSq (𝓕 (residualLogPullback c) (t / (2 * Real.pi))) := by
  rw [mellin_residual_eq_fourier c t]

/--
The remaining non-Fourier part of D3: logarithmic substitution is an L2 isometry.
This is now the only geometric/change-of-variable producer needed before applying
Mathlib's Fourier Plancherel isometry.
-/
def ResidualLogPullbackIsometry : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Set.Ioi 0, ‖concreteResidualC c x‖ ^ 2) =
      ∫ u : ℝ, ‖residualLogPullback c u‖ ^ 2

#print axioms MCore.RH.R0.mellin_residual_eq_fourier
#print axioms MCore.RH.R0.normSq_mellin_residual_eq_fourier

end MCore.RH.R0
