import MCore.RH.Analytic.MellinPlancherelDecomposition
import Mathlib.MeasureTheory.Integral.IntegralEqImproper
import Mathlib.MeasureTheory.Measure.Haar.NormedSpace

namespace MCore.RH.R0

open MeasureTheory Complex

/-- Pointwise norm-square identity for the logarithmic pullback. -/
theorem normSq_criticalLogPullback
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) :
    Complex.normSq (criticalLogPullback c u) =
      Real.exp (-u) *
        Complex.normSq (residualRepresentativeC c (Real.exp (-u))) := by
  unfold criticalLogPullback
  simp [Complex.normSq, Real.exp_ne_zero]
  ring_nf
  rw [← Real.exp_add]
  congr 1
  ring

/-- D3.1: x=e^{-u} is an exact isometry after the half-density weight. -/
theorem d3_logPullback_realized :
    D3_LogPullbackNormBridge := by
  intro N c
  let G : ℝ → ℝ :=
    fun x => Complex.normSq (residualRepresentativeC c x)
  let H : ℝ → ℝ :=
    fun v => Real.exp v * G (Real.exp v)
  have hexp :
      (∫ v : ℝ, H v) = ∫ x : ℝ in Set.Ioi 0, G x := by
    simpa [H, G, smul_eq_mul] using
      (integral_comp_exp G)
  have hneg :
      (∫ u : ℝ, H (-u)) = ∫ v : ℝ, H v := by
    have h := Measure.integral_comp_mul_left H (-1 : ℝ)
    simpa using h
  calc
    (∫ x : ℝ in Set.Ioi 0,
      Complex.normSq (residualRepresentativeC c x))
        = ∫ x : ℝ in Set.Ioi 0, G x := by rfl
    _ = ∫ v : ℝ, H v := hexp.symm
    _ = ∫ u : ℝ, H (-u) := hneg.symm
    _ = ∫ u : ℝ, Complex.normSq (criticalLogPullback c u) := by
      apply integral_congr_ae
      filter_upwards with u
      rw [normSq_criticalLogPullback c u]
      simp [H, G]

#print axioms MCore.RH.R0.normSq_criticalLogPullback
#print axioms MCore.RH.R0.d3_logPullback_realized

end MCore.RH.R0
