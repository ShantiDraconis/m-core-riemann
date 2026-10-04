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

/-- The logarithmic residual pullback is integrable on the whole real line. -/
theorem residualLogPullback_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    Integrable (residualLogPullback c) volume := by
  have hcrit := residualCriticalMellinL1_realized c
  have hexp :
      Integrable
        (fun u : ℝ =>
          Real.exp u •
            (((Real.exp u : ℂ) ^ ((1 / 2 : ℂ) - 1)) *
              concreteResidualC c (Real.exp u))) volume := by
    exact (integrable_comp_exp
      (fun x : ℝ =>
        ((x : ℂ) ^ ((1 / 2 : ℂ) - 1)) * concreteResidualC c x)).2 hcrit
  have hneg :
      Integrable (fun u : ℝ => residualLogPullback c (-u)) volume := by
    apply hexp.congr
    filter_upwards with u
    simp [residualLogPullback, smul_eq_mul]
    rw [ofReal_cpow]
    · rw [Real.log_exp]
      simp
      ring_nf
    · positivity
  have hmp := Measure.measurePreserving_neg (volume : Measure ℝ)
  have hcomp :
      Integrable ((residualLogPullback c) ∘ fun u : ℝ => -u) volume := by
    simpa [Function.comp_def] using hneg
  exact (hmp.integrable_comp
    (Homeomorph.neg ℝ).measurableEmbedding
    (residualLogPullback c)).mp hcomp

/-- L1 prerequisite for Fourier compatibility is now realized. -/
theorem residualLogPullbackMemL1_realized :
    ResidualLogPullbackMemL1 := by
  intro N c
  rw [memLp_one_iff_integrable]
  exact residualLogPullback_integrable c

#print axioms MCore.RH.R0.residualCriticalMellinL1_realized
#print axioms MCore.RH.R0.residualLogPullback_integrable
#print axioms MCore.RH.R0.residualLogPullbackMemL1_realized

end MCore.RH.R0
