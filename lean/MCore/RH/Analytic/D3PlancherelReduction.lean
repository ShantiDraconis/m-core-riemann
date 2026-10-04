import MCore.RH.Analytic.MellinResidual
import Mathlib.Analysis.MellinInversion

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Critical-line parametrization used by the Plancherel formula. -/
noncomputable def criticalLinePoint (t : ℝ) : ℂ :=
  (1 / 2 : ℝ) + t * I

/-- Literal L2 energy of the complex residual representative. -/
noncomputable def residualEnergy
    {N : ℕ} (c : Fin N → ℝ) : ℝ :=
  ∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)

/--
The sole analytic producer remaining in D3: Mellin-Plancherel on Re(s)=1/2
with Mathlib's Fourier normalization.
-/
def CriticalLineMellinPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    residualEnergy c =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (mellin (residualRepresentativeC c) (criticalLinePoint t))

/-- Norm of the critical-line denominator. -/
theorem criticalLinePoint_normSq (t : ℝ) :
    Complex.normSq (criticalLinePoint t) = 1 / 4 + t ^ 2 := by
  unfold criticalLinePoint Complex.normSq
  simp
  ring

/-- Mellin residual closed form specialized to the critical line. -/
theorem mellin_residual_critical
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLinePoint t) =
      (1 + riemannZeta (criticalLinePoint t) *
        concreteDirichletPolynomial c (criticalLinePoint t)) /
        criticalLinePoint t := by
  apply mellin_residual_closed_form
  · unfold criticalLinePoint
    norm_num
  · unfold criticalLinePoint
    norm_num

/--
D3 after all finite Mellin algebra has been eliminated: only the
critical-line Plancherel producer is assumed.
-/
theorem residualEnergy_eq_zeta_integral
    (hP : CriticalLineMellinPlancherel)
    {N : ℕ} (c : Fin N → ℝ) :
    residualEnergy c =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLinePoint t) *
              concreteDirichletPolynomial c (criticalLinePoint t)) /
            (1 / 4 + t ^ 2) := by
  rw [hP c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  rw [mellin_residual_critical c t]
  rw [Complex.normSq_div]
  rw [criticalLinePoint_normSq]

#print axioms MCore.RH.R0.mellin_residual_critical
#print axioms MCore.RH.R0.residualEnergy_eq_zeta_integral

end MCore.RH.R0
