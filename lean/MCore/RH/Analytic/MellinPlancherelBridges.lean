import MCore.RH.Analytic.MellinPlancherelReduction

namespace MCore.RH.R0

open MeasureTheory Set Complex
open scoped FourierTransform

/-- Logarithmic pullback placing Mellin on the Fourier line Re(s)=1/2. -/
noncomputable def residualLogPullback
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) : ℂ :=
  Real.exp (-(1 / 2 : ℝ) * u) *
    residualRepresentativeC c (Real.exp (-u))

/-- Critical-line Mellin is exactly Fourier of the logarithmic pullback. -/
theorem mellin_residual_critical_eq_fourier
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLine t) =
      𝓕 (residualLogPullback c) (t / (2 * Real.pi)) := by
  rw [mellin_eq_fourierIntegral]
  congr 2
  funext u
  simp [residualLogPullback, criticalLine, smul_eq_mul]

/--
First norm bridge: x=e^{-u} is an L2 isometry after multiplication by e^{-u/2}.
This statement contains no zeta or Mellin algebra.
-/
def ResidualLogPullbackIsometry : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      ∫ u : ℝ, normSq (residualLogPullback c u)

/--
Second norm bridge: Fourier Plancherel for the concrete pullback, in pointwise-integral form.
-/
def ResidualFourierPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ u : ℝ, normSq (residualLogPullback c u)) =
      ∫ ξ : ℝ, normSq (𝓕 (residualLogPullback c) ξ)

/--
Frequency rescaling t = 2πξ, kept explicit so normalization cannot be hidden.
-/
def ResidualFrequencyScaling : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ ξ : ℝ, normSq (𝓕 (residualLogPullback c) ξ)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ, normSq (𝓕 (residualLogPullback c) (t / (2 * Real.pi)))

/-- The three pure L2/Fourier bridges imply the sole D3 Plancherel producer. -/
theorem residualCriticalLinePlancherel_of_log_fourier
    (hlog : ResidualLogPullbackIsometry)
    (hfourier : ResidualFourierPlancherel)
    (hscale : ResidualFrequencyScaling) :
    ResidualCriticalLinePlancherel := by
  intro N c
  rw [hlog c, hfourier c, hscale c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  rw [← mellin_residual_critical_eq_fourier c t]

#print axioms MCore.RH.R0.mellin_residual_critical_eq_fourier
#print axioms MCore.RH.R0.residualCriticalLinePlancherel_of_log_fourier

end MCore.RH.R0
