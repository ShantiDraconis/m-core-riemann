import MCore.RH.Analytic.MellinFourierBridge
import MCore.RH.Analytic.MellinPlancherelReduction

namespace MCore.RH.R0

/-- Change-of-variable x = exp(-u) preserves the L2 norm after the half-density factor. -/
def ResidualLogPullbackNorm : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Set.Ioi 0, Complex.normSq (residualRepresentativeC c x)) =
      ∫ u : ℝ, Complex.normSq (residualLogPullback c u)

/-- Fourier-Plancherel plus the frequency rescaling t = 2πy. -/
def ResidualFourierPlancherelScaled : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ u : ℝ, Complex.normSq (residualLogPullback c u)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (𝓕 (residualLogPullback c) (t / (2 * Real.pi)))

/-- These two pure L2 bridges imply the remaining Mellin-Plancherel producer. -/
theorem residualMellinPlancherel_of_fourier_bridges
    (hlog : ResidualLogPullbackNorm)
    (hfourier : ResidualFourierPlancherelScaled) :
    ResidualMellinPlancherel := by
  intro N c
  rw [hlog c, hfourier c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  rw [mellin_residual_eq_fourierIntegral_logPullback]

#print axioms MCore.RH.R0.residualMellinPlancherel_of_fourier_bridges

end MCore.RH.R0
