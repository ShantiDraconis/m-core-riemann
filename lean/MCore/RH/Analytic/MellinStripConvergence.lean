import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.RhoBasicFacts
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Filter Asymptotics Complex

/-- Complex rho representative is locally integrable on the positive half-line. -/
theorem rhoRepresentativeC_locallyIntegrable
    (n : ℕ) :
    LocallyIntegrableOn (rhoRepresentativeC n) (Ioi 0) := by
  have hmeas :
      AEStronglyMeasurable (rhoRepresentativeC n)
        (volume.restrict (Ioi 0)) := by
    exact (rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable.restrict
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm hmeas ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le]
  rw [rhoRepresentativeC, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x)]
  exact rhoRepresentative_le_one n x

/-- Near zero, every rho_n is O(1). -/
theorem rhoRepresentativeC_isBigO_nhdsGT
    (n : ℕ) :
    rhoRepresentativeC n =O[𝓝[>] (0 : ℝ)]
      (fun x : ℝ => x ^ (0 : ℝ)) := by
  apply Asymptotics.IsBigO.of_bound 1
  filter_upwards with x
  rw [norm_rpow_of_nonneg (show 0 ≤ x by positivity)]
  simp only [Real.rpow_zero, norm_one, one_mul]
  rw [rhoRepresentativeC, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x)]
  exact rhoRepresentative_le_one n x

/-- At infinity, every rho_n is O(x^-1) by its exact tail formula. -/
theorem rhoRepresentativeC_isBigO_atTop
    (n : ℕ) :
    rhoRepresentativeC n =O[atTop]
      (fun x : ℝ => x ^ (-1 : ℝ)) := by
  apply Asymptotics.IsBigO.of_bound (1 / (((rhoIndex n : ℕ) : ℝ)))
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  have hx0 : 0 < x := zero_lt_one.trans hx
  rw [rhoRepresentativeC, rhoRepresentative_tail n hx]
  rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by positivity)]
  rw [Real.norm_eq_abs, abs_of_nonneg (Real.rpow_nonneg _ _)]
  have ha : 0 < (((rhoIndex n : ℕ) : ℝ)) := by
    exact_mod_cast rhoIndex_pos n
  have hpow : x ^ (-1 : ℝ) = 1 / x := by
    rw [Real.rpow_neg_one]
  rw [hpow]
  field_simp
  positivity

/-- Mellin convergence of every rho_n on the full open strip 0 < Re(s) < 1. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  exact mellinConvergent_of_isBigO_rpow
    (rhoRepresentativeC_locallyIntegrable n)
    (rhoRepresentativeC_isBigO_atTop n)
    hs1
    (rhoRepresentativeC_isBigO_nhdsGT n)
    hs0

/-- Complex target is locally integrable on the positive half-line. -/
theorem chiRepresentativeC_locallyIntegrable :
    LocallyIntegrableOn chiRepresentativeC (Ioi 0) := by
  have hmeas :
      AEStronglyMeasurable chiRepresentativeC
        (volume.restrict (Ioi 0)) := by
    exact chi_measurable.ofReal.aestronglyMeasurable.restrict
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm hmeas ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le]
  simp [chiRepresentativeC, chiRepresentative]

/-- Near zero, chi is O(1). -/
theorem chiRepresentativeC_isBigO_nhdsGT :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)]
      (fun x : ℝ => x ^ (0 : ℝ)) := by
  apply Asymptotics.IsBigO.of_bound 1
  filter_upwards with x
  rw [norm_rpow_of_nonneg (show 0 ≤ x by positivity)]
  simp [chiRepresentativeC, chiRepresentative]

/-- At infinity, chi is eventually zero, hence O(x^-1). -/
theorem chiRepresentativeC_isBigO_atTop :
    chiRepresentativeC =O[atTop]
      (fun x : ℝ => x ^ (-1 : ℝ)) := by
  have hzero :
      chiRepresentativeC =ᶠ[atTop] (fun _ : ℝ => (0 : ℂ)) := by
    filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
    simp [chiRepresentativeC, chiRepresentative, hx.not_lt]
  exact hzero.trans_isBigO (Asymptotics.isBigO_zero _ _)

/-- Mellin convergence of chi on 0 < Re(s); in particular on the critical strip. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) :
    MellinConvergent chiRepresentativeC s := by
  exact mellinConvergent_of_isBigO_rpow
    chiRepresentativeC_locallyIntegrable
    chiRepresentativeC_isBigO_atTop
    (by linarith)
    chiRepresentativeC_isBigO_nhdsGT
    hs0

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
