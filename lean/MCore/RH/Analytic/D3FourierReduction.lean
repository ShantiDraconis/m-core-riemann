import MCore.RH.Analytic.D3Reduction
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.FourierTransform

namespace MCore.RH.R0

open MeasureTheory Complex Real
open scoped FourierTransform

/-- Logarithmic lift that turns Mellin on Re(s)=1/2 into Fourier. -/
noncomputable def residualLogLift
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) : ℂ :=
  Real.exp (-(1 / 2 : ℝ) * u) *
    residualRepresentativeC c (Real.exp (-u))

/-- Pointwise Mellin/Fourier identification on the critical line. -/
theorem mellin_residual_eq_fourier_logLift
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLinePoint t) =
      𝓕 (residualLogLift c) (t / (2 * Real.pi)) := by
  simpa [criticalLinePoint, residualLogLift, smul_eq_mul,
    mul_comm, mul_left_comm, mul_assoc] using
    (mellin_eq_fourierIntegral
      (residualRepresentativeC c)
      (s := criticalLinePoint t))

/--
Physical/logarithmic L² change of variables.
This is a pure one-dimensional Jacobian statement.
-/
def ResidualLogLiftIsometry : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Set.Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
      ∫ u : ℝ, ‖residualLogLift c u‖ ^ 2

/--
Plancherel for exactly the logarithmic lifts arising from finite NB residuals.
The pinned Mathlib has Fourier inversion but not the later bundled L² isometry API.
-/
def ResidualFourierPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ u : ℝ, ‖residualLogLift c u‖ ^ 2) =
      ∫ ξ : ℝ, ‖𝓕 (residualLogLift c) ξ‖ ^ 2

/--
The remaining frequency rescaling t = 2πξ, separated from Plancherel itself.
-/
def ResidualCriticalFrequencyScaling : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ ξ : ℝ, ‖𝓕 (residualLogLift c) ξ‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          ‖𝓕 (residualLogLift c) (t / (2 * Real.pi))‖ ^ 2

/-- The three classical functional-analytic pieces imply the D3 producer. -/
theorem residualMellinPlancherel_of_fourier
    (hlog : ResidualLogLiftIsometry)
    (hfourier : ResidualFourierPlancherel)
    (hscale : ResidualCriticalFrequencyScaling) :
    ResidualMellinPlancherel := by
  intro N c
  rw [hlog c, hfourier c, hscale c]
  congr 1
  apply integral_congr
  intro t
  rw [← mellin_residual_eq_fourier_logLift c t]

#print axioms MCore.RH.R0.mellin_residual_eq_fourier_logLift
#print axioms MCore.RH.R0.residualMellinPlancherel_of_fourier

end MCore.RH.R0
