import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.RhoBasicFacts
import MCore.RH.R0.ChiMemLp
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Complex Filter Asymptotics

/-- Complex rho representatives are measurable and locally integrable on the positive half-line. -/
theorem rhoRepresentativeC_locallyIntegrable (n : ℕ) :
    LocallyIntegrableOn (rhoRepresentativeC n) (Ioi 0) := by
  have hmeas : AEStronglyMeasurable (rhoRepresentativeC n) (volume.restrict (Ioi 0)) := by
    exact ((rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable.restrict)
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm hmeas ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x)]
  exact rhoRepresentative_le_one n x

/-- Near zero every rho_n is O(1). -/
theorem rhoRepresentativeC_isBigO_zero (n : ℕ) :
    rhoRepresentativeC n =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  rw [isBigO_iff]
  refine ⟨1, ?_⟩
  filter_upwards with x
  rw [Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x), Real.rpow_zero, norm_one, one_mul]
  exact rhoRepresentative_le_one n x

/-- At infinity rho_n is O(x^-1). -/
theorem rhoRepresentativeC_isBigO_infty (n : ℕ) :
    rhoRepresentativeC n =O[atTop] (fun x : ℝ => x ^ (-1 : ℝ)) := by
  rw [isBigO_iff]
  refine ⟨1, ?_⟩
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  have hx0 : 0 < x := zero_lt_one.trans hx
  rw [rhoRepresentativeC, rhoRepresentative_tail n hx]
  rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by positivity), one_mul]
  rw [Real.rpow_neg_one]
  have ha : (1 : ℝ) ≤ ((rhoIndex n : ℕ) : ℝ) := by
    exact_mod_cast Nat.succ_le_iff.mpr (rhoIndex_pos n)
  have hax : x ≤ (((rhoIndex n : ℕ) : ℝ) * x) := by nlinarith
  exact one_div_le_one_div_of_le hx0 hax

/-- Mellin convergence of every concrete generator on the critical strip. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  exact mellinConvergent_of_isBigO_rpow
    (rhoRepresentativeC_locallyIntegrable n)
    (rhoRepresentativeC_isBigO_infty n)
    hs1
    (rhoRepresentativeC_isBigO_zero n)
    hs0

/-- Complex chi is locally integrable on the positive half-line. -/
theorem chiRepresentativeC_locallyIntegrable :
    LocallyIntegrableOn chiRepresentativeC (Ioi 0) := by
  have hmeas : AEStronglyMeasurable chiRepresentativeC (volume.restrict (Ioi 0)) := by
    exact chiRepresentative_measurable.ofReal.aestronglyMeasurable.restrict
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm hmeas ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le, Complex.norm_real]
  simpa [chiRepresentativeC] using chiRepresentative_norm_le_one x

/-- Near zero chi is O(1). -/
theorem chiRepresentativeC_isBigO_zero :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  rw [isBigO_iff]
  refine ⟨1, ?_⟩
  filter_upwards with x
  rw [Real.rpow_zero, norm_one, one_mul]
  simpa [chiRepresentativeC] using chiRepresentative_norm_le_one x

/-- At infinity chi is exactly zero, hence O(x^-1). -/
theorem chiRepresentativeC_isBigO_infty :
    chiRepresentativeC =O[atTop] (fun x : ℝ => x ^ (-1 : ℝ)) := by
  apply EventuallyEq.trans_isBigO
    (show chiRepresentativeC =ᶠ[atTop] (fun _ : ℝ => (0 : ℂ)) from ?_)
    (Asymptotics.isBigO_zero _ _)
  filter_upwards [eventually_ge_atTop (1 : ℝ)] with x hx
  simp [chiRepresentativeC, chiRepresentative, hx.not_lt]

/-- Mellin convergence of the target on the same strip. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent chiRepresentativeC s := by
  exact mellinConvergent_of_isBigO_rpow
    chiRepresentativeC_locallyIntegrable
    chiRepresentativeC_isBigO_infty
    hs1
    chiRepresentativeC_isBigO_zero
    hs0

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
