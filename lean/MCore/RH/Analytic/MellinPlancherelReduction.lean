import MCore.RH.Analytic.MellinResidual
import MCore.RH.R0.ConcreteGramLogRate
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.Analysis.MellinInversion

namespace MCore.RH.R0

open MeasureTheory Set Complex
open MCore.RH.NB

/-- Standard point on the critical line. -/
noncomputable def criticalLine (t : ℝ) : ℂ :=
  (1 / 2 : ℝ) + t * I

@[simp] theorem criticalLine_re (t : ℝ) :
    (criticalLine t).re = 1 / 2 := by
  simp [criticalLine]

@[simp] theorem criticalLine_im (t : ℝ) :
    (criticalLine t).im = t := by
  simp [criticalLine]

/--
The one genuinely norm-theoretic producer needed for D3.
It is precisely Mellin-Plancherel on the critical line for our finite residuals.
-/
def CriticalLineMellinPlancherel : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    ‖concreteNBData.chi -
      concreteNBData.coefficientApproximantAt
        concreteGeneratorFamily N c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (mellin (residualRepresentativeC c) (criticalLine t))

/-- Closed-form critical-line Mellin transform of the finite residual. -/
theorem mellin_residual_criticalLine
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLine t) =
      (1 + riemannZeta (criticalLine t) *
        concreteDirichletPolynomial c (criticalLine t)) /
      criticalLine t := by
  apply mellin_residual_closed_form c
  · simp [criticalLine]
  · simp [criticalLine]

/-- Norm-square of a critical-line point is exactly 1/4+t^2. -/
theorem normSq_criticalLine (t : ℝ) :
    Complex.normSq (criticalLine t) = (1 / 4 : ℝ) + t ^ 2 := by
  simp [criticalLine, Complex.normSq]
  ring

/-- The explicit zeta/Dirichlet-polynomial integrand appearing in D3. -/
noncomputable def residualSpectralDensity
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) : ℝ :=
  Complex.normSq
      (1 + riemannZeta (criticalLine t) *
        concreteDirichletPolynomial c (criticalLine t)) /
    ((1 / 4 : ℝ) + t ^ 2)

/-- Pointwise conversion from Mellin quotient to the explicit spectral density. -/
theorem normSq_mellin_residual_eq_density
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    Complex.normSq
      (mellin (residualRepresentativeC c) (criticalLine t)) =
      residualSpectralDensity c t := by
  rw [mellin_residual_criticalLine c t]
  unfold residualSpectralDensity
  rw [Complex.normSq_div]
  rw [normSq_criticalLine]
  rfl

/-- Exact D3 statement used downstream once Mellin-Plancherel is supplied. -/
def ResidualMellinPlancherelClosedForm : Prop :=
  ∀ (N : ℕ) (c : Fin N → ℝ),
    ‖concreteNBData.chi -
      concreteNBData.coefficientApproximantAt
        concreteGeneratorFamily N c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ, residualSpectralDensity c t

/-- D3 is reduced to the single critical-line Mellin-Plancherel producer. -/
theorem residualMellinPlancherel_of_critical
    (h : CriticalLineMellinPlancherel) :
    ResidualMellinPlancherelClosedForm := by
  intro N c
  rw [h N c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  exact normSq_mellin_residual_eq_density c t

#print axioms MCore.RH.R0.mellin_residual_criticalLine
#print axioms MCore.RH.R0.normSq_mellin_residual_eq_density
#print axioms MCore.RH.R0.residualMellinPlancherel_of_critical

end MCore.RH.R0
