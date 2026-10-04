import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.WeightedIntegrability

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- The complexified concrete generator is Mellin-convergent on the full strip 0 < Re(s) < 1. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  have hmeas :
      AEStronglyMeasurable (rhoRepresentativeC n)
        (volume.restrict (Ioi 0)) := by
    exact ((rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable).restrict
  rw [mellin_convergent_iff_norm Subset.rfl measurableSet_Ioi hmeas]
  have hreal := rho_weighted_integrableOn_Ioi n s.re hs0 hs1
  refine hreal.congr_fun ?_ measurableSet_Ioi
  intro t ht
  have hr0 : 0 ≤ rhoRepresentative n t := rhoRepresentative_nonneg n t
  rw [rhoRepresentativeC, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hr0]
  ring

/-- The concrete target is Mellin-convergent on Re(s)>0. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) :
    MellinConvergent chiRepresentativeC s := by
  have hstd : MellinConvergent (Ioc (0 : ℝ) 1).indicator (fun _ : ℝ => (1 : ℂ)) s :=
    (hasMellin_one_Ioc (s := s) hs0).1
  rw [MellinConvergent] at hstd ⊢
  refine hstd.congr_fun ?_ measurableSet_Ioi
  intro t ht
  have ht0 : 0 < t := ht
  by_cases ht1 : t < 1
  · simp [chiRepresentativeC, chiRepresentative, ht0, ht1]
  · have htge : 1 ≤ t := le_of_not_gt ht1
    by_cases hteq : t = 1
    · subst t
      simp [chiRepresentativeC, chiRepresentative]
    · have htgt : 1 < t := lt_of_le_of_ne htge (Ne.symm hteq)
      simp [chiRepresentativeC, chiRepresentative, ht0, ht1, htgt.ne]

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
