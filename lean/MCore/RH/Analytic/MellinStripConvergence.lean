import MCore.RH.Analytic.MellinConcrete
import MCore.RH.R0.RhoBasicFacts
import MCore.RH.R0.ChiMemLp
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Filter Asymptotics Complex

/-- Near zero every concrete rho generator is O(1). -/
theorem rhoRepresentativeC_isBigO_zero (n : ℕ) :
    rhoRepresentativeC n =O[𝓝[>] (0 : ℝ)]
      (fun x : ℝ => (x ^ (0 : ℝ) : ℂ)) := by
  refine isBigO_iff.2 ⟨1, ?_⟩
  filter_upwards with x
  rw [norm_rhoRepresentativeC, Complex.norm_real]
  have h0 : 0 ≤ rhoRepresentative n x := rhoRepresentative_nonneg n x
  have h1 : rhoRepresentative n x ≤ 1 := rhoRepresentative_le_one n x
  simp [Real.norm_eq_abs, abs_of_nonneg h0, h1]

/-- At infinity rho_n(x)=1/((n+1)x), hence O(x^-1). -/
theorem rhoRepresentativeC_isBigO_top (n : ℕ) :
    rhoRepresentativeC n =O[atTop]
      (fun x : ℝ => (x ^ (-1 : ℝ) : ℂ)) := by
  refine isBigO_iff.2 ⟨1 / (((rhoIndex n : ℕ) : ℝ)), ?_⟩
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  have hx0 : 0 < x := zero_lt_one.trans hx
  rw [rhoRepresentative_tail n hx, norm_rhoRepresentativeC]
  rw [Complex.norm_real, Real.norm_eq_abs]
  have hval : 0 ≤ 1 / (((rhoIndex n : ℕ) : ℝ) * x) := by positivity
  rw [abs_of_nonneg hval]
  rw [show x ^ (-1 : ℝ) = x⁻¹ by simpa using Real.rpow_neg_one x]
  simp [rhoIndex, hx0.ne', mul_assoc, mul_comm, mul_left_comm]

/-- The concrete target is O(1) near zero. -/
theorem chiRepresentativeC_isBigO_zero :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)]
      (fun x : ℝ => (x ^ (0 : ℝ) : ℂ)) := by
  refine isBigO_iff.2 ⟨1, ?_⟩
  filter_upwards with x
  simp [chiRepresentativeC, chiRepresentative]

/-- The concrete target vanishes identically beyond 1, hence is O(x^-1) at infinity. -/
theorem chiRepresentativeC_isBigO_top :
    chiRepresentativeC =O[atTop]
      (fun x : ℝ => (x ^ (-1 : ℝ) : ℂ)) := by
  have hzero : chiRepresentativeC =ᶠ[atTop] 0 := by
    filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
    simp [chiRepresentativeC, chiRepresentative, hx.not_lt]
  exact hzero.trans_isBigO (Asymptotics.isBigO_zero _ _)

/-- Mellin convergence for every rho_n on the critical strip 0<Re(s)<1. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  apply mellinConvergent_of_isBigO_rpow
    (a := (0 : ℝ)) (b := (1 : ℝ))
  · exact hs0
  · exact hs1
  · exact (rhoRepresentative_measurable_public n).ofReal.locallyIntegrableOn
  · simpa using rhoRepresentativeC_isBigO_zero n
  · simpa using rhoRepresentativeC_isBigO_top n

/-- Mellin convergence for chi on the same strip. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent chiRepresentativeC s := by
  apply mellinConvergent_of_isBigO_rpow
    (a := (0 : ℝ)) (b := (1 : ℝ))
  · exact hs0
  · exact hs1
  · exact chi_measurable.ofReal.locallyIntegrableOn
  · simpa using chiRepresentativeC_isBigO_zero
  · simpa using chiRepresentativeC_isBigO_top

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
