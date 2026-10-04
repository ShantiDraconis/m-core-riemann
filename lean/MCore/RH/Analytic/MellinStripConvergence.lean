import MCore.RH.R0.WeightedIntegrability
import MCore.RH.R0.RhoBasicFacts
import MCore.RH.Analytic.MellinConcrete
import MCore.RH.Analytic.MellinTarget
import Mathlib.Analysis.MellinTransform

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- The concrete complex generator has convergent Mellin transform on the full strip 0 < Re(s) < 1. -/
theorem rhoRepresentativeC_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  rw [MellinConvergent,
    mellin_convergent_iff_norm Subset.rfl measurableSet_Ioi
      ((rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable.restrict)]
  apply IntegrableOn.congr_fun
    (rho_weighted_integrableOn_Ioi n s.re hs0 hs1)
    ?_ measurableSet_Ioi
  intro x hx
  rw [Complex.norm_real, Real.norm_eq_abs,
    abs_of_nonneg (rhoRepresentative_nonneg n x)]
  ring

/-- The frozen target has convergent Mellin transform on Re(s)>0. -/
theorem chiRepresentativeC_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) :
    MellinConvergent chiRepresentativeC s := by
  have hstd :
      MellinConvergent
        (indicator (Ioc (0 : ℝ) 1) (fun _ => (1 : ℂ))) s :=
    (hasMellin_one_Ioc hs0).1
  unfold MellinConvergent at hstd ⊢
  apply hstd.congr_fun_ae
  filter_upwards [
    self_mem_ae_restrict measurableSet_Ioi,
    (Set.countable_singleton (1 : ℝ)).measure_zero.ae_notMem] with x hx h1
  have hx0 : 0 < x := hx
  by_cases hxlt : x < 1
  · simp [chiRepresentativeC, chiRepresentative, hx0, hxlt]
  · have hxge : 1 ≤ x := le_of_not_gt hxlt
    have hxne : x ≠ 1 := by
      intro h
      exact h1 (by simpa [h])
    have hxgt : 1 < x := lt_of_le_of_ne hxge (Ne.symm hxne)
    simp [chiRepresentativeC, chiRepresentative, hx0, hxlt, hxgt.not_le]

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
