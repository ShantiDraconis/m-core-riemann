import MCore.RH.Analytic.ResidualLogIsometry
import MCore.RH.Analytic.ResidualL2Integral
import MCore.RH.Analytic.MellinPlancherelBridge
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.Analysis.MellinInversion
import Mathlib.MeasureTheory.Function.L2Space

namespace MCore.RH.R0

open MeasureTheory Set Complex
open scoped FourierTransform

/--
Exact standard Fourier bridge still needed for D3:
for the concrete log-residual, the pointwise L1 Fourier integral and the
unitary L2 Fourier transform represent the same L2 class.
-/
structure ResidualFourierL1L2Compatibility
    {N : ℕ} (c : Fin N → ℝ) where
  memLp_one : MemLp (residualLogTransform c) 1 volume
  memLp_two : MemLp (residualLogTransform c) 2 volume
  fourier_memLp_two : MemLp (𝓕 (residualLogTransform c)) 2 volume
  compatibility :
    (MeasureTheory.Lp.fourierTransformₗᵢ ℝ ℂ)
        (memLp_two.toLp (residualLogTransform c)) =
      fourier_memLp_two.toLp (𝓕 (residualLogTransform c))

/-- Global producer form, isolated from all RH-specific Mellin algebra. -/
def ResidualFourierCompatibilityProducer : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    Nonempty (ResidualFourierL1L2Compatibility c)

/--
Once the L1/L2 compatibility theorem is available, ordinary L2 Plancherel
gives the exact integral identity needed by D3.
-/
theorem residualFourierPlancherel_of_compatibility
    (hcomp : ResidualFourierCompatibilityProducer) :
    ResidualFourierPlancherel := by
  intro N c
  rcases hcomp c with ⟨H⟩
  have hnorm :
      ‖H.fourier_memLp_two.toLp (𝓕 (residualLogTransform c))‖ =
        ‖H.memLp_two.toLp (residualLogTransform c)‖ := by
    rw [← H.compatibility]
    exact MeasureTheory.Lp.norm_fourier_eq
      (H.memLp_two.toLp (residualLogTransform c))
  have hleft :
      ‖H.memLp_two.toLp (residualLogTransform c)‖ ^ 2 =
        ∫ u : ℝ, Complex.normSq (residualLogTransform c u) := by
    rw [← Complex.normSq_eq_norm_sq]
    rw [← @MeasureTheory.L2.inner_def ℝ ℂ ℂ _ _ _ _ _
      (H.memLp_two.toLp (residualLogTransform c))
      (H.memLp_two.toLp (residualLogTransform c))]
    apply integral_congr_ae
    filter_upwards [H.memLp_two.coeFn_toLp] with u hu
    rw [hu]
    simp [RCLike.inner_apply', Complex.normSq_eq_norm_sq]
  have hright :
      ‖H.fourier_memLp_two.toLp (𝓕 (residualLogTransform c))‖ ^ 2 =
        ∫ y : ℝ, Complex.normSq (𝓕 (residualLogTransform c) y) := by
    rw [← Complex.normSq_eq_norm_sq]
    rw [← @MeasureTheory.L2.inner_def ℝ ℂ ℂ _ _ _ _ _
      (H.fourier_memLp_two.toLp (𝓕 (residualLogTransform c)))
      (H.fourier_memLp_two.toLp (𝓕 (residualLogTransform c)))]
    apply integral_congr_ae
    filter_upwards [H.fourier_memLp_two.coeFn_toLp] with y hy
    rw [hy]
    simp [RCLike.inner_apply', Complex.normSq_eq_norm_sq]
  rw [← hleft, ← hright, hnorm]

/--
Thus D3 is reduced to the one standard L1∩L2 Fourier compatibility producer.
Everything else in the Mellin/Plancherel chain is already explicit.
-/
theorem criticalLineMellinPlancherel_of_fourierCompatibility
    (hcomp : ResidualFourierCompatibilityProducer) :
    CriticalLineMellinPlancherel := by
  exact criticalLineMellinPlancherel_of_three_bridges
    residualLogL2Isometry_realized
    (residualFourierPlancherel_of_compatibility hcomp)
    criticalLineFrequencyScaling_realized

/-- Full D3 once the standard Fourier compatibility producer is inhabited. -/
theorem d3_of_fourierCompatibility
    (hcomp : ResidualFourierCompatibilityProducer)
    {N : ℕ} (c : Fin N → ℝ) :
    ‖concreteNBData.chi -
      concreteNBData.coefficientApproximantAt concreteGeneratorFamily N c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLinePoint t) *
              concreteDirichletPolynomial c (criticalLinePoint t)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  exact residual_mellin_plancherel_of_bridges
    residualL2IntegralIdentity_realized
    (criticalLineMellinPlancherel_of_fourierCompatibility hcomp)
    c

#print axioms MCore.RH.R0.residualFourierPlancherel_of_compatibility
#print axioms MCore.RH.R0.criticalLineMellinPlancherel_of_fourierCompatibility
#print axioms MCore.RH.R0.d3_of_fourierCompatibility

end MCore.RH.R0
