import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.RhoBasicFacts
import Mathlib.Analysis.MellinTransform
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- The complex rho representative is measurable. -/
theorem rhoRepresentativeC_aestronglyMeasurable (n : ℕ) :
    AEStronglyMeasurable (rhoRepresentativeC n) (volume.restrict (Ioi 0)) := by
  exact ((rhoRepresentative_measurable_public n).ofReal).aestronglyMeasurable.restrict

/--
Mellin convergence of every concrete rho generator on the full open strip 0 < Re(s) < 1.
This is the complex analogue of the A1 weighted-L1 estimate.
-/
theorem rho_mellinConvergent
    (n : ℕ) (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoRepresentativeC n) s := by
  rw [MellinConvergent]
  have hnearPow :
      IntegrableOn
        (fun x : ℝ => (x : ℂ) ^ (s - 1))
        (Ioc 0 1) := by
    rw [← intervalIntegrable_iff_integrableOn_Ioc_of_le zero_le_one]
    exact intervalIntegral.intervalIntegrable_cpow'
      (by simp only [sub_re, one_re]; linarith)
  have hnear :
      IntegrableOn
        (fun x : ℝ => (x : ℂ) ^ (s - 1) • rhoRepresentativeC n x)
        (Ioc 0 1) := by
    apply Integrable.mono' hnearPow.norm
    · exact AEStronglyMeasurable.smul
        ((continuousOn_of_forall_continuousAt fun x hx =>
          (Complex.continuousAt_ofReal_cpow_const
            (by
              have hx0 : 0 < x := hx.1
              exact hx0.ne')).continuousWithinAt).aestronglyMeasurable measurableSet_Ioc)
        ((rhoRepresentative_measurable_public n).ofReal.aestronglyMeasurable.restrict)
    · filter_upwards [self_mem_ae_restrict measurableSet_Ioc] with x hx
      simp only [smul_eq_mul, norm_mul]
      have hr : ‖rhoRepresentativeC n x‖ ≤ 1 := by
        rw [rhoRepresentativeC, Complex.norm_real, Real.norm_eq_abs,
          abs_of_nonneg (rhoRepresentative_nonneg n x)]
        exact rhoRepresentative_le_one n x
      exact mul_le_of_le_one_right (norm_nonneg _) hr

  let a : ℝ := ((rhoIndex n : ℕ) : ℝ)
  have ha : 0 < a := by
    dsimp [a]
    exact_mod_cast rhoIndex_pos n
  have htailPow :
      IntegrableOn
        (fun x : ℝ => (1 / a : ℂ) * (x : ℂ) ^ (s - 2))
        (Ioi 1) := by
    exact (integrableOn_Ioi_cpow_of_lt
      (by simp only [sub_re, ofReal_re]; linarith)
      zero_lt_one).const_mul _
  have htail :
      IntegrableOn
        (fun x : ℝ => (x : ℂ) ^ (s - 1) • rhoRepresentativeC n x)
        (Ioi 1) := by
    refine htailPow.congr_fun ?_ measurableSet_Ioi
    intro x hx
    have hx0 : 0 < x := zero_lt_one.trans hx
    rw [rhoRepresentativeC, rhoRepresentative_tail n hx]
    push_cast
    simp only [smul_eq_mul]
    have hane : (a : ℂ) ≠ 0 := by exact_mod_cast ha.ne'
    have hxne : (x : ℂ) ≠ 0 := ofReal_ne_zero.mpr hx0.ne'
    rw [show (s - 2 : ℂ) = (s - 1) + (-1) by ring]
    rw [cpow_add hxne, cpow_neg_one]
    dsimp [a]
    field_simp
    ring
  have hunion := hnear.union htail
  have hset : Ioc (0 : ℝ) 1 ∪ Ioi 1 = Ioi 0 := by
    ext x
    simp
    constructor
    · rintro (⟨hx, _⟩ | hx) <;> linarith
    · intro hx
      by_cases h : x ≤ 1
      · exact Or.inl ⟨hx, h⟩
      · exact Or.inr (lt_of_not_ge h)
  simpa [hset] using hunion

/-- The frozen target is a.e. equal to Mathlib's standard Ioc representative. -/
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
    have hxne : x ≠ 1 := by
      intro h
      exact h1 (by simpa [h])
    have hxgt : 1 < x := lt_of_le_of_ne hxge (Ne.symm hxne)
    simp [chiRepresentativeC, chiRepresentative, hx0, hxlt, hxgt.not_le]

/-- Mellin convergence of the target on Re(s)>0. -/
theorem chi_mellinConvergent
    (s : ℂ) (hs0 : 0 < s.re) :
    MellinConvergent chiRepresentativeC s := by
  have hstd := (hasMellin_one_Ioc (s := s) hs0).1
  rw [MellinConvergent] at hstd ⊢
  refine hstd.congr ?_
  filter_upwards [chiRepresentativeC_ae_eq_Ioc] with x hx
  simp only at hx
  rw [hx]

#print axioms MCore.RH.R0.rho_mellinConvergent
#print axioms MCore.RH.R0.chi_mellinConvergent

end MCore.RH.R0
