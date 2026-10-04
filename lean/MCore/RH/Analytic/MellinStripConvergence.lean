import MCore.RH.Analytic.MellinConcrete
import MCore.RH.R0.RhoBasicFacts
import MCore.RH.R0.ChiMemLp
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Asymptotics Filter Complex

/-- rho_n is O(1) near zero. -/
theorem rhoRepresentativeC_isBigO_nhdsGT_zero (n : ℕ) :
    rhoRepresentativeC n =O[𝓝[>] (0 : ℝ)]
      (fun x : ℝ => x ^ (0 : ℝ)) := by
  apply IsBigO.of_bound 1
  filter_upwards with x
  rw [Real.rpow_zero, norm_one, rhoRepresentativeC, norm_real]
  exact abs_le.mpr ⟨by linarith [rhoRepresentative_nonneg n x],
    rhoRepresentative_le_one n x⟩

/-- rho_n is O(x^-1) at infinity. -/
theorem rhoRepresentativeC_isBigO_atTop_negOne (n : ℕ) :
    rhoRepresentativeC n =O[atTop]
      (fun x : ℝ => x ^ (-1 : ℝ)) := by
  apply IsBigO.of_bound (1 / (((rhoIndex n : ℕ) : ℝ)))
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  rw [rhoRepresentativeC, rhoRepresentative_tail n hx, norm_real]
  have hx0 : 0 < x := zero_lt_one.trans hx
  have ha0 : 0 < ((rhoIndex n : ℕ) : ℝ) := by
    exact_mod_cast rhoIndex_pos n
  rw [abs_of_nonneg (by positivity), Real.rpow_neg_one]
  field_simp

/-- chi is O(1) near zero. -/
theorem chiRepresentativeC_isBigO_nhdsGT_zero :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)]
      (fun x : ℝ => x ^ (0 : ℝ)) := by
  apply IsBigO.of_bound 1
  filter_upwards with x
  rw [Real.rpow_zero, norm_one]
  unfold chiRepresentativeC chiRepresentative
  by_cases hx : x ∈ Ioo (0 : ℝ) 1 <;> simp [hx]

/-- chi vanishes identically at infinity, hence is O(x^-1). -/
theorem chiRepresentativeC_isBigO_atTop_negOne :
    chiRepresentativeC =O[atTop]
      (fun x : ℝ => x ^ (-1 : ℝ)) := by
  apply IsBigO.of_bound 1
  filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
  unfold chiRepresentativeC chiRepresentative
  have hnot : x ∉ Ioo (0 : ℝ) 1 := by
    intro h; linarith [h.2]
  simp [hnot]

/-- Local integrability of rho_n on the positive half-line. -/
theorem rhoRepresentativeC_locallyIntegrable (n : ℕ) :
    LocallyIntegrableOn (rhoRepresentativeC n) (Ioi 0) := by
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm
    ((rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable) ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le, rhoRepresentativeC, norm_real]
  exact abs_le.mpr ⟨by linarith [rhoRepresentative_nonneg n x],
    rhoRepresentative_le_one n x⟩

/-- Local integrability of chi on the positive half-line. -/
theorem chiRepresentativeC_locallyIntegrable :
    LocallyIntegrableOn chiRepresentativeC (Ioi 0) := by
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm
    ?_ ?_
  · unfold chiRepresentativeC chiRepresentative
    exact (measurableSet_Ioo.indicator measurable_const).aestronglyMeasurable
  · filter_upwards with x
    rw [enorm_le_iff_norm_le]
    unfold chiRepresentativeC chiRepresentative
    by_cases hx : x ∈ Ioo (0 : ℝ) 1 <;> simp [hx]

/-- Mellin convergence of every rho_n on the open strip 0<Re(s)<1. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  exact mellinConvergent_of_isBigO_rpow
    (a := 1) (b := 0)
    (rhoRepresentativeC_locallyIntegrable n)
    (rhoRepresentativeC_isBigO_atTop_negOne n)
    hs1
    (rhoRepresentativeC_isBigO_nhdsGT_zero n)
    hs0

/-- Mellin convergence of chi on the same strip. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent chiRepresentativeC s := by
  exact mellinConvergent_of_isBigO_rpow
    (a := 1) (b := 0)
    chiRepresentativeC_locallyIntegrable
    chiRepresentativeC_isBigO_atTop_negOne
    hs1
    chiRepresentativeC_isBigO_nhdsGT_zero
    hs0

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
