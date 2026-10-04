import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.WeightedIntegrability
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- rho_n is Mellin-convergent throughout the critical strip 0 < Re(s) < 1. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  rw [MellinConvergent]
  rw [mellin_convergent_iff_norm Subset.rfl measurableSet_Ioi]
  · have hreal :
        IntegrableOn
          (fun t : ℝ => rhoRepresentative n t * t ^ (s.re - 1))
          (Ioi 0) :=
      rho_weighted_integrableOn_Ioi n s.re hs0 hs1
    apply hreal.congr_fun
    · intro t ht
      have ht0 : 0 < t := ht
      rw [rhoRepresentativeC]
      rw [norm_real, Real.norm_eq_abs, abs_of_nonneg (rhoRepresentative_nonneg n t)]
      ring
    · exact measurableSet_Ioi
  · exact ((rhoRepresentative_measurable_public n).ofReal).aestronglyMeasurable.restrict

/-- chi is Mellin-convergent for Re(s)>0; only this half is needed for D3. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) :
    MellinConvergent chiRepresentativeC s := by
  rw [MellinConvergent]
  rw [mellin_convergent_iff_norm Subset.rfl measurableSet_Ioi]
  · have hpow :
        IntegrableOn (fun t : ℝ => t ^ (s.re - 1)) (Ioc 0 1) := by
      rw [← intervalIntegrable_iff_integrableOn_Ioc_of_le zero_le_one]
      exact intervalIntegral.intervalIntegrable_rpow' (by linarith)
    have hzero :
        IntegrableOn (fun _t : ℝ => (0 : ℝ)) (Ioi 1) := integrableOn_zero
    have hunion := hpow.union hzero
    have hset : Ioc (0 : ℝ) 1 ∪ Ioi 1 = Ioi 0 := by
      ext t
      simp
      constructor <;> intro h
      · rcases h with h | h <;> linarith
      · by_cases ht : t ≤ 1
        · exact Or.inl ⟨h, ht⟩
        · exact Or.inr (lt_of_not_ge ht)
    rw [← hset]
    apply hunion.congr_fun
    · intro t ht
      rcases ht with ht | ht
      · have ht0 : 0 < t := ht.1
        have ht1 : t ≤ 1 := ht.2
        by_cases h1 : t = 1
        · subst t
          simp [chiRepresentativeC, chiRepresentative]
        · have hlt : t < 1 := lt_of_le_of_ne ht1 h1
          simp [chiRepresentativeC, chiRepresentative, ht0, hlt]
      · have ht1 : 1 < t := ht
        have ht0 : 0 < t := zero_lt_one.trans ht1
        simp [chiRepresentativeC, chiRepresentative, ht0, not_lt_of_ge ht1.le]
    · exact measurableSet_union measurableSet_Ioc measurableSet_Ioi
  · exact ((measurableSet_Ioo.indicator measurable_const).ofReal).aestronglyMeasurable.restrict

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
