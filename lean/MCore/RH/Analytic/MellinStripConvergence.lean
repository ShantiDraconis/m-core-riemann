import MCore.RH.R0.RhoBasicFacts
import MCore.RH.R0.ChiMemLp
import MCore.RH.Analytic.MellinConcrete
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Complex Filter Asymptotics

/-- The complexified generator is locally integrable on the positive half-line. -/
theorem rhoRepresentativeC_locallyIntegrableOn (n : ℕ) :
    LocallyIntegrableOn (rhoRepresentativeC n) (Ioi 0) := by
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm ?_ ?_
  · exact (rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable
  · filter_upwards with x
    rw [enorm_le_iff_norm_le]
    rw [rhoRepresentativeC, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg (rhoRepresentative_nonneg n x)]
    exact rhoRepresentative_le_one n x

/-- The target is locally integrable on the positive half-line. -/
theorem chiRepresentativeC_locallyIntegrableOn :
    LocallyIntegrableOn chiRepresentativeC (Ioi 0) := by
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm ?_ ?_
  · exact chiRepresentative_measurable.ofReal.aestronglyMeasurable
  · filter_upwards with x
    rw [enorm_le_iff_norm_le]
    rw [chiRepresentativeC, Complex.norm_real]
    exact chiRepresentative_norm_le_one x

/-- rho_n is bounded near zero, i.e. O(x^0). -/
theorem rhoRepresentativeC_isBigO_zero (n : ℕ) :
    rhoRepresentativeC n =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  rw [isBigO_iff]
  refine ⟨1, ?_⟩
  filter_upwards with x
  rw [rhoRepresentativeC, Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x), Real.rpow_zero, norm_one, one_mul]
  exact rhoRepresentative_le_one n x

/-- chi is bounded near zero, i.e. O(x^0). -/
theorem chiRepresentativeC_isBigO_zero :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  rw [isBigO_iff]
  refine ⟨1, ?_⟩
  filter_upwards with x
  rw [Real.rpow_zero, norm_one, one_mul]
  exact chiRepresentative_norm_le_one x

/-- rho_n has exact 1/x decay at infinity, hence O(x^-1). -/
theorem rhoRepresentativeC_isBigO_top (n : ℕ) :
    rhoRepresentativeC n =O[atTop] (fun x : ℝ => x ^ (-1 : ℝ)) := by
  let a : ℝ := ((rhoIndex n : ℕ) : ℝ)
  have ha : 0 < a := by dsimp [a]; exact_mod_cast rhoIndex_pos n
  have heq :
      rhoRepresentativeC n =ᶠ[atTop]
        (fun x : ℝ => ((1 / a : ℝ) : ℂ) * (x ^ (-1 : ℝ) : ℝ)) := by
    filter_upwards [eventually_gt_atTop 1] with x hx
    have hx0 : 0 < x := zero_lt_one.trans hx
    rw [rhoRepresentativeC, rhoRepresentative_tail n hx]
    dsimp [a]
    rw [Real.rpow_neg_one]
    push_cast
    field_simp
  have hO :
      (fun x : ℝ => ((1 / a : ℝ) : ℂ) * (x ^ (-1 : ℝ) : ℝ)) =O[atTop]
        (fun x : ℝ => x ^ (-1 : ℝ)) := by
    simpa using
      (Asymptotics.isBigO_const_mul_self ((1 / a : ℝ) : ℂ)
        (fun x : ℝ => (x ^ (-1 : ℝ) : ℂ)) atTop)
  exact heq.trans_isBigO hO

/-- chi is eventually zero at infinity, hence O(x^-1). -/
theorem chiRepresentativeC_isBigO_top :
    chiRepresentativeC =O[atTop] (fun x : ℝ => x ^ (-1 : ℝ)) := by
  have heq : chiRepresentativeC =ᶠ[atTop] 0 := by
    filter_upwards [eventually_gt_atTop 1] with x hx
    simp [chiRepresentativeC, chiRepresentative, not_lt_of_ge hx.le]
  exact heq.trans_isBigO (Asymptotics.isBigO_zero _ _)

/-- rho_n Mellin-converges throughout the open strip 0 < Re(s) < 1. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  exact mellinConvergent_of_isBigO_rpow
    (rhoRepresentativeC_locallyIntegrableOn n)
    (rhoRepresentativeC_isBigO_top n)
    hs1
    (rhoRepresentativeC_isBigO_zero n)
    hs0

/-- chi Mellin-converges throughout the positive half-plane, in particular the critical strip. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) :
    MellinConvergent chiRepresentativeC s := by
  exact mellinConvergent_of_isBigO_rpow
    chiRepresentativeC_locallyIntegrableOn
    chiRepresentativeC_isBigO_top
    (show s.re < 1 from by
      by_cases h : s.re < 1
      · exact h
      · exact lt_of_lt_of_le (by linarith : s.re < s.re + 1) (by linarith))
    chiRepresentativeC_isBigO_zero
    hs0

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
