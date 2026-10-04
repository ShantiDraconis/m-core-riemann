import MCore.RH.Analytic.MellinCriticalLine
import Mathlib.Analysis.MellinInversion

namespace MCore.RH.R0

open Complex

/-- Logarithmic pullback that converts Mellin on Re(s)=1/2 to Fourier. -/
noncomputable def residualLogPullback
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) : ℂ :=
  Real.exp (-(1 / 2 : ℝ) * u) •
    residualRepresentativeC c (Real.exp (-u))

/-- Mellin on the critical line is the ordinary Fourier integral of the log-pullback. -/
theorem mellin_residual_eq_fourierIntegral_logPullback
    {N : ℕ} (c : Fin N → ℝ) (t : ℝ) :
    mellin (residualRepresentativeC c) (criticalLine t) =
      𝓕 (residualLogPullback c) (t / (2 * Real.pi)) := by
  rw [mellin_eq_fourierIntegral]
  congr 1
  funext u
  unfold residualLogPullback criticalLine
  simp
  ring_nf

#print axioms MCore.RH.R0.mellin_residual_eq_fourierIntegral_logPullback

end MCore.RH.R0
