import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.RhoBasicFacts
import MCore.RH.R0.ChiMemLp
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Complex Filter Asymptotics

/-- The complex concrete generators are locally integrable on the positive half-line. -/
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
    rhoRepresentativeC n =O[𝓝[>] (0 : ℝ)]
      (fun x : ℝ => x ^ (0 : ℝ)) := by
  refine IsBigO.of_bound 1 ?_
  filter_upwards [self_mem_nhdsWithin] with x hx
  have hx0 : 0 < x := hx
  rw [rhoRepresentativeC, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x)]
  have hr := rhoRepresentative_le_one n x
  simpa [Real.rpow_zero] using hr

/-- At infinity every rho_n is exactly O(x^-1). -/
theorem rhoRepresentativeC_isBigO_atTop
    (n : ℕ) :
    rhoRepresentativeC n =O[atTop]
      (fun x : ℝ => x ^ (-1 : ℝ)) := by
  let a : ℝ := ((rhoIndex n : ℕ) : ℝ)
  have ha : 0 < a := by
    dsimp [a]
    exact_mod_cast rhoIndex_pos n
  refine IsBigO.of_bound (1 / a) ?_
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  have hx0 : 0 < x := zero_lt_one.trans hx
  rw [rhoRepresentativeC, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x),
    rhoRepresentative_tail n hx]
  have hrpow : x ^ (-1 : ℝ) = x⁻¹ := by
    rw [Real.rpow_neg_one]
  rw [hrpow, Real.norm_eq_abs, abs_of_nonneg (inv_nonneg.mpr hx0.le)]
  dsimp [a]
  field_simp
  ring

/-- rho_n has an absolutely convergent Mellin transform on 0 < Re(s) < 1. -/
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
    (chiRepresentative_measurable.ofReal.aestronglyMeasurable.restrict) ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le, Complex.norm_real]
  simpa [chiRepresentativeC] using chiRepresentative_norm_le_one x

/-- Near zero chi is O(1). -/
theorem chiRepresentativeC_isBigO_zero :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)]
      (fun x : ℝ => x ^ (0 : ℝ)) := by
  refine IsBigO.of_bound 1 ?_
  filter_upwards [self_mem_nhdsWithin] with x hx
  rw [Real.rpow_zero, norm_one, one_mul]
  simpa [chiRepresentativeC] using chiRepresentative_norm_le_one x

/-- At infinity chi is zero, hence O(x^-1). -/
theorem chiRepresentativeC_isBigO_atTop :
    chiRepresentativeC =O[atTop]
      (fun x : ℝ => x ^ (-1 : ℝ)) := by
  have hzero :
      chiRepresentativeC =ᶠ[atTop] (fun _ : ℝ => (0 : ℂ)) := by
    filter_upwards [eventually_ge_atTop (1 : ℝ)] with x hx
    simp [chiRepresentativeC, chiRepresentative, not_lt_of_ge hx]
  exact hzero.trans_isBigO (Asymptotics.isBigO_zero _ _)

/-- chi has an absolutely convergent Mellin transform on 0 < Re(s) < 1. -/
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
