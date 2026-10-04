import MCore.RH.Analytic.MellinPlancherelReduction
import Mathlib.MeasureTheory.Integral.IntegralEqImproper

namespace MCore.RH.R0

open Complex MeasureTheory Set

/-- Squared norm of the critical log lift. -/
theorem residualLogLift_normSq
    {N : ℕ} (c : Fin N → ℝ) (u : ℝ) :
    Complex.normSq (residualLogLift c u) =
      Real.exp (-u) *
        Complex.normSq (residualRepresentativeC c (Real.exp (-u))) := by
  unfold residualLogLift
  rw [Complex.normSq_mul, Complex.normSq_ofReal]
  have hsq : (Real.exp (-(1 / 2 : ℝ) * u)) ^ 2 = Real.exp (-u) := by
    rw [← Real.exp_two_mul]
    congr 1
    ring
  rw [hsq]

/--
The logarithmic change of variables is exactly an L2 isometry at Re(s)=1/2.
No Fourier or zeta input is used.
-/
theorem residualLogLift_integral_normSq
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ u : ℝ, Complex.normSq (residualLogLift c u)) =
      ∫ x : ℝ in Ioi 0,
        Complex.normSq (residualRepresentativeC c x) := by
  simp_rw [residualLogLift_normSq]
  rw [← integral_neg_eq_self]
  simp only [neg_neg]
  simpa [smul_eq_mul] using
    (integral_comp_exp
      (fun x : ℝ => Complex.normSq (residualRepresentativeC c x)))

#print axioms MCore.RH.R0.residualLogLift_integral_normSq

end MCore.RH.R0
