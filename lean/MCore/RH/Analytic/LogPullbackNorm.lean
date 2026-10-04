import MCore.RH.Analytic.MellinPlancherelFourierReduction
import Mathlib.MeasureTheory.Integral.IntegralEqImproper
import Mathlib.MeasureTheory.Measure.Lebesgue.Integral

namespace MCore.RH.R0

open MeasureTheory Set

/-- Pointwise density identity after reflecting the logarithmic coordinate. -/
theorem normSq_residualLogPullback_neg
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) :
    Complex.normSq (residualLogPullback c (-u)) =
      Real.exp u *
        Complex.normSq (residualRepresentativeC c (Real.exp u)) := by
  unfold residualLogPullback
  rw [show -(1 / 2 : ℝ) * (-u) = u / 2 by ring]
  rw [neg_neg]
  rw [show (Real.exp (u / 2) •
      residualRepresentativeC c (Real.exp u) : ℂ) =
      (Real.exp (u / 2) : ℂ) * residualRepresentativeC c (Real.exp u) by rfl]
  rw [Complex.normSq_mul, Complex.normSq_ofReal]
  have hsq : Real.exp (u / 2) * Real.exp (u / 2) = Real.exp u := by
    rw [← Real.exp_add]
    congr 1
    ring
  rw [hsq]

/-- D3 log-coordinate L2 norm bridge, realized by reflection plus x = exp(u). -/
theorem residualLogPullbackNorm_realized :
    ResidualLogPullbackNorm := by
  intro N c
  let g : ℝ → ℝ := fun x =>
    Complex.normSq (residualRepresentativeC c x)
  have hreflect :
      (∫ u : ℝ, Complex.normSq (residualLogPullback c u)) =
        ∫ u : ℝ, Complex.normSq (residualLogPullback c (-u)) := by
    symm
    simpa using
      (Measure.measurePreserving_neg (volume : Measure ℝ)).integral_comp
        (Homeomorph.neg ℝ).measurableEmbedding
        (fun u : ℝ => Complex.normSq (residualLogPullback c u))
  rw [hreflect]
  have hdensity :
      (fun u : ℝ => Complex.normSq (residualLogPullback c (-u))) =
        fun u : ℝ => Real.exp u * g (Real.exp u) := by
    funext u
    exact normSq_residualLogPullback_neg c u
  rw [hdensity]
  simpa [g, smul_eq_mul] using (integral_comp_exp g).symm

#print axioms MCore.RH.R0.normSq_residualLogPullback_neg
#print axioms MCore.RH.R0.residualLogPullbackNorm_realized

end MCore.RH.R0
