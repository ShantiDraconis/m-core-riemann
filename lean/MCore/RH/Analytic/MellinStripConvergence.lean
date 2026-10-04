import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- The raw fractional-part Mellin transform converges at -s on the critical strip. -/
theorem fract_mellinConvergent_neg
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent fractRepresentativeC (-s) := by
  rw [MellinConvergent]
  have hnear := fractional_mellin_nearZero_integrable s hs1
  have htail := fractional_mellin_tail_integrable s hs0
  have hsplit :
      IntegrableOn
        (fun t : ℝ => ((t : ℂ) ^ (-s - 1)) * (Int.fract t : ℂ))
        (Ioi 0) := by
    rw [← Ioc_union_Ioi_eq_Ioi zero_le_one]
    exact hnear.union htail
  refine hsplit.congr_fun ?_ measurableSet_Ioi
  intro t ht
  simp only [fractRepresentativeC, smul_eq_mul]
  congr 1
  ring

/-- Mellin convergence of rho_0 on the full open strip 0 < Re(s) < 1. -/
theorem rhoBase_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC 0) s := by
  rw [rhoRepresentativeC_zero_eq_fract_inv]
  have hfract := fract_mellinConvergent_neg s hs0 hs1
  have hcomp :=
    (MellinConvergent.comp_rpow
      (f := fractRepresentativeC) (s := s) (a := (-1 : ℝ))
      (by norm_num)).2
      (by simpa using hfract)
  simpa [Real.rpow_neg_one] using hcomp

/-- Mellin convergence of every concrete generator on the full open strip. -/
theorem rho_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  rw [rhoRepresentativeC_eq_dilate]
  have hbase := rhoBase_mellinConvergent s hs0 hs1
  exact
    (MellinConvergent.comp_mul_left
      (f := rhoRepresentativeC 0) (s := s)
      (a := ((rhoIndex n : ℕ) : ℝ))
      (by exact_mod_cast rhoIndex_pos n)).2 hbase

/-- The frozen target is a.e. the standard Ioc(0,1) Mellin test function. -/
theorem chiRepresentativeC_ae_eq_Ioc :
    chiRepresentativeC =ᵐ[volume.restrict (Ioi 0)]
      indicator (Ioc (0 : ℝ) 1) (fun _ => (1 : ℂ)) := by
  filter_upwards [
    self_mem_ae_restrict measurableSet_Ioi,
    (Set.countable_singleton (1 : ℝ)).measure_zero.ae_notMem] with x hx h1
  have hx0 : 0 < x := hx
  by_cases hxlt : x < 1
  · simp [chiRepresentativeC, chiRepresentative, hx0, hxlt]
  · have hxge : 1 ≤ x := le_of_not_gt hxlt
    have hxne : x ≠ 1 := by exact fun h => h1 (h ▸ rfl)
    have hxgt : 1 < x := lt_of_le_of_ne hxge (Ne.symm hxne)
    simp [chiRepresentativeC, chiRepresentative, hx0, hxlt, hxgt.not_le]

/-- Mellin convergence of the concrete target for Re(s)>0. -/
theorem chi_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) :
    MellinConvergent chiRepresentativeC s := by
  have hstd := (hasMellin_one_Ioc (s := s) hs0).1
  rw [MellinConvergent] at hstd ⊢
  apply hstd.congr
  filter_upwards [chiRepresentativeC_ae_eq_Ioc] with x hx
  simp only [hx]

#print axioms MCore.RH.R0.fract_mellinConvergent_neg
#print axioms MCore.RH.R0.rhoBase_mellinConvergent
#print axioms MCore.RH.R0.rho_mellinConvergent
#print axioms MCore.RH.R0.chi_mellinConvergent

end MCore.RH.R0
