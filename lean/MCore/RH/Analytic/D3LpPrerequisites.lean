import MCore.RH.Analytic.D3FourierReduction
import Mathlib.MeasureTheory.Function.L2Space

namespace MCore.RH.R0

open Complex MeasureTheory Set

/-- L1 producer for the logarithmic residual pullback. -/
def ResidualLogPullbackMemL1 : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    MemLp (residualLogPullback c) 1 volume

/-- L2 producer for the logarithmic residual pullback. -/
def ResidualLogPullbackMemL2 : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    MemLp (residualLogPullback c) 2 volume

/--
The L1 statement is exactly the critical-line Mellin absolute convergence
after the logarithmic substitution.
-/
def ResidualCriticalMellinL1 : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    Integrable
      (fun x : ℝ =>
        ((x : ℂ) ^ ((1 / 2 : ℂ) - 1)) * concreteResidualC c x)
      (volume.restrict (Ioi 0))

/--
The L2 statement is exactly square-integrability of the residual transported
through the already closed logarithmic isometry.
-/
def ResidualOriginalMemL2 : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    MemLp (concreteResidualC c) 2 (volume.restrict (Ioi 0))

/-- Critical-strip convergence already supplies the original weighted L1 integrability. -/
theorem residualCriticalMellinL1_realized :
    ResidualCriticalMellinL1 := by
  intro N c
  have h := concreteResidualC_mellinConvergent
    c (1 / 2 : ℂ) (by norm_num) (by norm_num)
  simpa [MellinConvergent, smul_eq_mul] using h

#print axioms MCore.RH.R0.residualCriticalMellinL1_realized

end MCore.RH.R0
