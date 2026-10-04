import MCore.RH.Analytic.D1KernelEntry
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.RhoBasicFacts
import Mathlib.Analysis.MellinTransform
import Mathlib.Analysis.Asymptotics.Basic

namespace MCore.RH.R0

open MeasureTheory Set Filter Asymptotics Complex

/-- Complexified rho is locally integrable on the positive half-line. -/
theorem rhoRepresentativeC_locallyIntegrable
    (n : ℕ) :
    LocallyIntegrableOn (rhoRepresentativeC n) (Ioi 0) := by
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm
    ((rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable.restrict) ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x)]
  exact rhoRepresentative_le_one n x

/-- Near zero every rho_n is O(1). -/
theorem rhoRepresentativeC_isBigO_zero
    (n : ℕ) :
    rhoRepresentativeC n =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  apply IsBigO.of_bound' 
  filter_upwards with x
  rw [Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x), Real.rpow_zero, norm_one]
  exact rhoRepresentative_le_one n x

/-- At infinity rho_n is O(x^-1), uniformly with a concrete coefficient <= 1. -/
theorem rhoRepresentativeC_isBigO_atTop
    (n : ℕ) :
    rhoRepresentativeC n =O[atTop] (fun x : ℝ => x ^ (-1 : ℝ)) := by
  apply IsBigO.of_bound'
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  have hx0 : 0 < x := zero_lt_one.trans hx
  have ha : (1 : ℝ) ≤ ((rhoIndex n : ℕ) : ℝ) := by
    exact_mod_cast Nat.succ_le_iff.mpr (rhoIndex_pos n)
  rw [rhoRepresentativeC, rhoRepresentative_tail n hx,
    Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (by positivity : 0 ≤ 1 / (((rhoIndex n : ℕ) : ℝ) * x))]
  rw [Real.rpow_neg_one hx0.le, Real.norm_eq_abs, abs_of_nonneg (by positivity : 0 ≤ x⁻¹)]
  have hden : 0 < (((rhoIndex n : ℕ) : ℝ) * x) := by positivity
  rw [one_div, one_div]
  exact inv_le_inv₀ (by positivity) (by nlinarith) (by nlinarith)

/-- Hence every concrete rho Mellin transform converges on 0 < Re(s) < 1. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  exact mellinConvergent_of_isBigO_rpow
    (rhoRepresentativeC_locallyIntegrable n)
    (rhoRepresentativeC_isBigO_atTop n)
    hs1
    (rhoRepresentativeC_isBigO_zero n)
    hs0

/-- The complex target is locally integrable. -/
theorem chiRepresentativeC_locallyIntegrable :
    LocallyIntegrableOn chiRepresentativeC (Ioi 0) := by
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm
    ((chi_measurable.ofReal).aestronglyMeasurable.restrict) ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le, Complex.norm_real, Real.norm_eq_abs]
  by_cases hx : x ∈ Ioo (0 : ℝ) 1
  · simp [chiRepresentativeC, chiRepresentative, hx]
  · simp [chiRepresentativeC, chiRepresentative, hx]

/-- Near zero chi is O(1). -/
theorem chiRepresentativeC_isBigO_zero :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  apply IsBigO.of_bound'
  filter_upwards with x
  rw [Real.rpow_zero, norm_one]
  by_cases hx : x ∈ Ioo (0 : ℝ) 1
  · simp [chiRepresentativeC, chiRepresentative, hx]
  · simp [chiRepresentativeC, chiRepresentative, hx]

/-- At infinity chi is eventually zero, hence O(x^-1). -/
theorem chiRepresentativeC_isBigO_atTop :
    chiRepresentativeC =O[atTop] (fun x : ℝ => x ^ (-1 : ℝ)) := by
  exact (EventuallyEq.trans_isBigO
    (show chiRepresentativeC =ᶠ[atTop] (fun _ : ℝ => (0 : ℂ)) by
      filter_upwards [eventually_ge_atTop (1 : ℝ)] with x hx
      simp [chiRepresentativeC, chiRepresentative, not_lt.mpr hx])
    (Asymptotics.isBigO_zero _ _))

/-- The target Mellin transform converges throughout the same strip. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent chiRepresentativeC s := by
  exact mellinConvergent_of_isBigO_rpow
    chiRepresentativeC_locallyIntegrable
    chiRepresentativeC_isBigO_atTop
    hs1
    chiRepresentativeC_isBigO_zero
    hs0

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
