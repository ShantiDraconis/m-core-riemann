import MCore.RH.Analytic.MellinPlancherelReduction
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.Inversion

namespace MCore.RH.R0

open Complex MeasureTheory Set
open scoped FourierTransform

/-- Logarithmic pullback at sigma=1/2 used to identify Mellin with Fourier. -/
noncomputable def residualLogPullback
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) : ℂ :=
  Real.exp (-(1 / 2 : ℝ) * u) •
    complexResidual c (Real.exp (-u))

/--
The generic Plancherel theorem missing from the pinned Mathlib version.
This is standard Fourier analysis, not RH-specific mathematics.
-/
def FourierPlancherelR : Prop :=
  ∀ g : ℝ → ℂ,
    Integrable g →
    Integrable (fun u : ℝ => normSq (g u)) →
    (∫ u : ℝ, normSq (g u)) =
      ∫ ξ : ℝ, normSq (𝓕 g ξ)

/-- Mellin on the critical line is the Fourier transform of the logarithmic pullback. -/
theorem mellin_residual_eq_fourier
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (complexResidual c) (criticalLine t) =
      𝓕 (residualLogPullback c) (t / (2 * Real.pi)) := by
  rw [mellin_eq_fourierIntegral]
  congr 2
  funext u
  simp [residualLogPullback, criticalLine]

/--
Exact Jacobian identity for the logarithmic change x=exp(-u).
This is the L2-isometry half of Mellin-Plancherel.
-/
def ResidualLogPullbackIsometry : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Ioi 0, normSq (complexResidual c x)) =
      ∫ u : ℝ, normSq (residualLogPullback c u)

/-- The concrete pullbacks are L1; used only to connect with the pinned Fourier integral API. -/
def ResidualLogPullbackIntegrable : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    Integrable (residualLogPullback c)

/-- Their squared norm is integrable because the original residual lies in L2. -/
def ResidualLogPullbackSqIntegrable : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    Integrable (fun u : ℝ => normSq (residualLogPullback c u))

/--
D3 reduces to four standard analytic ingredients; three are concrete change-of-variable/integrability
facts and one is generic Fourier Plancherel.
-/
theorem residualMellinPlancherel_of_fourier
    (hLog : ResidualLogPullbackIsometry)
    (hL1 : ResidualLogPullbackIntegrable)
    (hL2 : ResidualLogPullbackSqIntegrable)
    (hPl : FourierPlancherelR) :
    ResidualMellinPlancherel := by
  intro N c
  rw [hLog c]
  rw [hPl (residualLogPullback c) (hL1 c) (hL2 c)]
  have hpi : 0 < 2 * Real.pi := by positivity
  rw [← Measure.integral_comp_mul_left
    (f := fun ξ : ℝ => normSq (𝓕 (residualLogPullback c) ξ))
    (a := 2 * Real.pi)]
  field_simp [Real.pi_ne_zero]
  apply integral_congr_ae
  filter_upwards with t
  rw [← mellin_residual_eq_fourier c t]
  ring

#print axioms MCore.RH.R0.mellin_residual_eq_fourier
#print axioms MCore.RH.R0.residualMellinPlancherel_of_fourier

end MCore.RH.R0
