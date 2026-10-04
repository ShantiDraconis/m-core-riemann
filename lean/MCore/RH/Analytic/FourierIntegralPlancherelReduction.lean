import MCore.RH.Analytic.LogPullbackL1
import MCore.RH.Analytic.L2NormIntegral
import MCore.RH.Analytic.D3PlancherelReduction
import Mathlib.Analysis.Fourier.LpSpace

namespace MCore.RH.R0

open MeasureTheory

/--
Classical Plancherel theorem in the exact representative form needed here.

Mathlib has the L2 Fourier isometry, but does not expose this L1-intersection-L2
pointwise-integral formulation as a one-line API theorem.
-/
def FourierIntegralPlancherelL1L2 : Prop :=
  ∀ (f : ℝ → ℂ),
    MemLp f 1 volume →
    MemLp f 2 volume →
    (∫ t : ℝ, ‖𝓕 f t‖ ^ 2) =
      ∫ u : ℝ, ‖f u‖ ^ 2

/-- The residual logarithmic pullback satisfies both hypotheses of the classical bridge. -/
theorem residual_logPullback_L1_L2
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (logPullback (residualRepresentativeC c)) 1 volume ∧
    MemLp (logPullback (residualRepresentativeC c)) 2 volume := by
  exact ⟨residual_logPullback_memLp_one c, residual_logPullback_memLp_two c⟩

/--
Once the standard L1∩L2 representative version of Plancherel is available,
the Fourier-side L2 equality for every finite residual is immediate.
-/
theorem residual_fourier_integral_plancherel
    (hP : FourierIntegralPlancherelL1L2)
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ t : ℝ,
      ‖𝓕 (logPullback (residualRepresentativeC c)) t‖ ^ 2) =
      ∫ x : ℝ in Set.Ioi 0, ‖residualRepresentativeC c x‖ ^ 2 := by
  rw [hP _ (residual_logPullback_memLp_one c) (residual_logPullback_memLp_two c)]
  exact residual_logPullback_normSq_integral c

#print axioms MCore.RH.R0.residual_fourier_integral_plancherel

end MCore.RH.R0
