import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- The raw fractional-part Mellin integral converges at -s on the critical strip. -/
theorem fract_mellinConvergent_neg
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent fractRepresentativeC (-s) := by
  rw [MellinConvergent]
  have hnear := fractional_mellin_nearZero_integrable s hs1
  have htail := fractional_mellin_tail_integrable s hs0
  rw [← Ioc_union_Ioi_eq_Ioi zero_le_one]
  apply IntegrableOn.union
  · simpa [fractRepresentativeC, smul_eq_mul, neg_sub] using hnear
  · simpa [fractRepresentativeC, smul_eq_mul, neg_sub] using htail

/-- Mellin convergence of the base concrete generator on 0<Re(s)<1. -/
theorem rhoBase_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC 0) s := by
  have hfrac := fract_mellinConvergent_neg s hs0 hs1
  have hinv :
      MellinConvergent (fun t : ℝ => fractRepresentativeC (t ^ (-1 : ℝ))) s := by
    rw [MellinConvergent.comp_rpow (a := (-1 : ℝ)) (by norm_num)]
    simpa using hfrac
  rw [MellinConvergent] at hinv ⊢
  refine integrableOn_congr_fun ?_ measurableSet_Ioi |>.mpr hinv
  intro t ht
  have ht0 : 0 < t := ht
  simp [rhoRepresentativeC, rhoRepresentative, rhoBase, rhoIndex,
    fractRepresentativeC, Real.rpow_neg_one, ht0.ne']

/-- Mellin convergence of every concrete generator on the open critical strip. -/
theorem rho_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  rw [rhoRepresentativeC_eq_dilate n]
  exact (MellinConvergent.comp_mul_left
    (f := rhoRepresentativeC 0) (s := s)
    (by exact_mod_cast rhoIndex_pos n)).mpr
      (rhoBase_mellinConvergent s hs0 hs1)

/-- Mellin convergence of the frozen target for Re(s)>0. -/
theorem chi_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) :
    MellinConvergent chiRepresentativeC s := by
  have hstd := (hasMellin_one_Ioc (s := s) hs0).1
  rw [MellinConvergent] at hstd ⊢
  refine integrableOn_congr_fun ?_ measurableSet_Ioi |>.mpr hstd
  intro t ht
  have ht0 : 0 < t := ht
  by_cases h1 : t < 1
  · simp [chiRepresentativeC, chiRepresentative, ht0, h1]
  · have hge : 1 ≤ t := le_of_not_gt h1
    by_cases heq : t = 1
    · subst t; simp [chiRepresentativeC, chiRepresentative]
    · have hgt : 1 < t := lt_of_le_of_ne hge (Ne.symm heq)
      simp [chiRepresentativeC, chiRepresentative, ht0, h1, hgt]

#print axioms MCore.RH.R0.fract_mellinConvergent_neg
#print axioms MCore.RH.R0.rho_mellinConvergent
#print axioms MCore.RH.R0.chi_mellinConvergent

end MCore.RH.R0
