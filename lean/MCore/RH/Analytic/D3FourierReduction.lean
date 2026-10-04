import MCore.RH.Analytic.LogPullbackIsometry
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.Analysis.Fourier.FourierTransform

namespace MCore.RH.R0

open Complex MeasureTheory

/--
Compatibility producer between the pointwise Fourier integral used by
the Mellin/Fourier identity and the L2 Fourier isometry used by Plancherel.

This is intentionally isolated because Mathlib exposes the L2 transform
via completion from Schwartz space rather than a one-line L1 ∩ L2 theorem.
-/
def ResidualFourierL2Compatibility : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    MemLp (residualLogPullback c) 1 volume →
    MemLp (residualLogPullback c) 2 volume →
    let h1 : MemLp (residualLogPullback c) 1 volume := by assumption
    let h2 : MemLp (residualLogPullback c) 2 volume := by assumption
    ((MeasureTheory.Lp.fourierTransformₗᵢ ℝ ℂ)
      (h2.toLp (residualLogPullback c)) : ℝ → ℂ)
      =ᵐ[volume]
      (fun t : ℝ => 𝓕 (residualLogPullback c) t)

/--
Once pointwise/L2 Fourier compatibility is supplied, the remaining D3 step
is exactly Fourier Plancherel plus the already closed logarithmic isometry.
-/
def ResidualFourierPlancherelBridge : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ u : ℝ, ‖residualLogPullback c u‖ ^ 2) =
      ∫ t : ℝ, ‖𝓕 (residualLogPullback c) t‖ ^ 2

/-- The logarithmic part of D3 is no longer open. -/
theorem d3_log_isometry_closed :
    ResidualLogPullbackIsometry :=
  residualLogPullbackIsometry_realized

#print axioms MCore.RH.R0.d3_log_isometry_closed

end MCore.RH.R0
