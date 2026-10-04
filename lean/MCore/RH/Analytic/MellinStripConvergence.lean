import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.RhoBasicFacts
import MCore.RH.R0.ChiMemLp
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Complex Asymptotics Filter

/-- Complex chi representative, already used in the Mellin target lane. -/
theorem chiRepresentativeC_locallyIntegrable :
    LocallyIntegrableOn chiRepresentativeC (Ioi 0) := by
  exact (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm
    ((measurableSet_Ioo.indicator_const : Measurable chiRepresentativeC).aestronglyMeasurable.restrict)
    (by
      filter_upwards with x
      by_cases hx : x ∈ Ioo (0 : ℝ) 1 <;> simp [chiRepresentativeC, chiRepresentative, hx])

/-- rho_n is locally integrable on the positive half-line. -/
theorem rhoRepresentativeC_locallyIntegrable (n : ℕ) :
    LocallyIntegrableOn (rhoRepresentativeC n) (Ioi 0) := by
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm
    ((rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable.restrict) ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x)]
  exact rhoRepresentative_le_one n x

/-- Near zero rho_n is O(1). -/
theorem rhoRepresentativeC_isBigO_nhdsGT (n : ℕ) :
    rhoRepresentativeC n =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  refine isBigO_iff.2 ⟨1, ?_⟩
  filter_upwards with x
  rw [Real.rpow_zero, norm_one, one_mul, rhoRepresentativeC, Complex.norm_real,
    Real.norm_eq_abs, abs_of_nonneg (rhoRepresentative_nonneg n x)]
  exact rhoRepresentative_le_one n x

/-- At infinity rho_n is exactly O(x^-1). -/
theorem rhoRepresentativeC_isBigO_atTop (n : ℕ) :
    rhoRepresentativeC n =O[atTop] (fun x : ℝ => x ^ (-1 : ℝ)) := by
  refine isBigO_iff.2 ⟨1 / (((rhoIndex n : ℕ) : ℝ)), ?_⟩
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  have hx0 : 0 < x := zero_lt_one.trans hx
  rw [rhoRepresentativeC, rhoRepresentative_tail n hx, Complex.norm_real,
    Real.norm_eq_abs, abs_of_nonneg (by positivity), Real.rpow_neg_one]
  have ha : 0 < (((rhoIndex n : ℕ) : ℝ)) := by
    exact_mod_cast rhoIndex_pos n
  field_simp [ha.ne', hx0.ne']

/-- Near zero chi is O(1). -/
theorem chiRepresentativeC_isBigO_nhdsGT :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  refine isBigO_iff.2 ⟨1, ?_⟩
  filter_upwards with x
  rw [Real.rpow_zero, norm_one, one_mul]
  by_cases hx : x ∈ Ioo (0 : ℝ) 1 <;>
    simp [chiRepresentativeC, chiRepresentative, hx]

/-- At infinity chi is eventually zero, hence O(x^-1). -/
theorem chiRepresentativeC_isBigO_atTop :
    chiRepresentativeC =O[atTop] (fun x : ℝ => x ^ (-1 : ℝ)) := by
  have hzero : chiRepresentativeC =ᶠ[atTop] (0 : ℝ → ℂ) := by
    filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
    simp [chiRepresentativeC, chiRepresentative, hx.not_lt]
  exact hzero.trans_isBigO (isBigO_zero _ _)

/-- Concrete rho_n has Mellin convergence exactly on the open critical strip. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  exact mellinConvergent_of_isBigO_rpow
    (f := rhoRepresentativeC n) (a := (0 : ℝ)) (b := (1 : ℝ))
    (rhoRepresentativeC_locallyIntegrable n)
    (rhoRepresentativeC_isBigO_nhdsGT n)
    (rhoRepresentativeC_isBigO_atTop n)
    hs0 hs1

/-- Concrete chi has Mellin convergence on 0 < Re(s) < 1. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent chiRepresentativeC s := by
  exact mellinConvergent_of_isBigO_rpow
    (f := chiRepresentativeC) (a := (0 : ℝ)) (b := (1 : ℝ))
    chiRepresentativeC_locallyIntegrable
    chiRepresentativeC_isBigO_nhdsGT
    chiRepresentativeC_isBigO_atTop
    hs0 hs1

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
