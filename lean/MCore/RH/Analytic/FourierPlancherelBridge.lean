import MCore.RH.Analytic.LogResidualIsometry
import Mathlib.Analysis.Fourier.LpSpace
import Mathlib.MeasureTheory.Function.L2Space

namespace MCore.RH.R0

open MeasureTheory Complex
open scoped FourierTransform ComplexInnerProductSpace

/-- Generic L2 norm-square formula for a complex representative. -/
theorem lp2_norm_sq_eq_integral_normSq
    (f : ℝ → ℂ) (hf : MemLp f 2 volume) :
    ‖hf.toLp f‖ ^ 2 = ∫ x : ℝ, Complex.normSq (f x) := by
  rw [norm_sq_eq_re_inner]
  rw [MeasureTheory.L2.inner_def]
  rw [← integral_re]
  · apply integral_congr_ae
    filter_upwards [hf.coeFn_toLp] with x hx
    rw [hx]
    simp [RCLike.inner_apply', Complex.normSq_eq_norm_sq]
  · exact MeasureTheory.L2.integrable_inner _ _

/--
Once the L2 Fourier extension agrees a.e. with the classical Fourier integral,
Mathlib's L2 isometry gives the exact classical Plancherel identity.
-/
theorem classicalFourierPlancherel_of_compatibility
    (hcompat : FourierIntegralLpCompatibility) :
    ClassicalFourierPlancherel := by
  intro N c
  rcases hcompat N c with ⟨hL2, hae⟩
  let F2 : Lp ℂ 2 volume := hL2.toLp (logResidualC c)
  have hnorm : ‖𝓕 F2‖ = ‖F2‖ := by
    exact MeasureTheory.Lp.norm_fourier_eq F2
  have hin :
      ‖F2‖ ^ 2 = ∫ u : ℝ, Complex.normSq (logResidualC c u) := by
    exact lp2_norm_sq_eq_integral_normSq (logResidualC c) hL2
  have houtMem : MemLp ((𝓕 F2 : Lp ℂ 2 volume) : ℝ → ℂ) 2 volume :=
    Lp.memLp (𝓕 F2)
  have hout :
      ‖𝓕 F2‖ ^ 2 =
        ∫ y : ℝ, Complex.normSq ((𝓕 F2 : Lp ℂ 2 volume) y) := by
    simpa using
      (lp2_norm_sq_eq_integral_normSq
        ((𝓕 F2 : Lp ℂ 2 volume) : ℝ → ℂ) houtMem)
  calc
    (∫ u : ℝ, Complex.normSq (logResidualC c u))
        = ‖F2‖ ^ 2 := hin.symm
    _ = ‖𝓕 F2‖ ^ 2 := by rw [hnorm]
    _ = ∫ y : ℝ, Complex.normSq ((𝓕 F2 : Lp ℂ 2 volume) y) := hout
    _ = ∫ y : ℝ, Complex.normSq (𝓕 (logResidualC c) y) := by
      apply integral_congr_ae
      filter_upwards [hae] with y hy
      rw [hy]

#print axioms MCore.RH.R0.lp2_norm_sq_eq_integral_normSq
#print axioms MCore.RH.R0.classicalFourierPlancherel_of_compatibility

end MCore.RH.R0
