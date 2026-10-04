import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.ChiMemLp
import Mathlib.MeasureTheory.Function.LocallyIntegrable

namespace MCore.RH.R0

open Complex Set Filter MeasureTheory Asymptotics

theorem chiRepresentativeC_locallyIntegrable :
    LocallyIntegrableOn chiRepresentativeC (Ioi 0) := by
  refine (locallyIntegrableOn_const (s := Ioi (0 : ℝ)) (1 : ℂ)).mono_enorm
    (chi_measurable.ofReal.aestronglyMeasurable) ?_
  filter_upwards with x
  rw [enorm_le_iff_norm_le]
  unfold chiRepresentativeC chiRepresentative
  by_cases hx : x ∈ Ioo (0 : ℝ) 1
  · simp [Set.indicator_of_mem hx]
  · simp [Set.indicator_of_not_mem hx]

theorem chiRepresentativeC_isBigO_nhdsGT :
    chiRepresentativeC =O[𝓝[>] (0 : ℝ)] (fun x : ℝ => x ^ (0 : ℝ)) := by
  rw [Asymptotics.isBigO_iff]
  refine ⟨1, ?_⟩
  filter_upwards [eventually_mem_nhdsWithin] with x hx
  rw [Real.rpow_zero]
  unfold chiRepresentativeC chiRepresentative
  by_cases hmem : x ∈ Ioo (0 : ℝ) 1
  · simp [Set.indicator_of_mem hmem]
  · simp [Set.indicator_of_not_mem hmem]

theorem chiRepresentativeC_isBigO_atTop :
    chiRepresentativeC =O[atTop] (fun x : ℝ => x ^ (-2 : ℝ)) := by
  have hzero : chiRepresentativeC =ᶠ[atTop] (0 : ℝ → ℂ) := by
    filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
    simp [chiRepresentativeC, chiRepresentative, hx.not_lt]
  exact hzero.trans_isBigO (Asymptotics.isBigO_zero _ _)

theorem chiRepresentativeC_mellinConvergent
    {s : ℂ} (hs0 : 0 < s.re) (hs2 : s.re < 2) :
    MellinConvergent chiRepresentativeC s := by
  exact mellinConvergent_of_isBigO_rpow
    chiRepresentativeC_locallyIntegrable
    (a := (2 : ℝ)) (b := (0 : ℝ))
    chiRepresentativeC_isBigO_atTop hs2
    chiRepresentativeC_isBigO_nhdsGT hs0

#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

end MCore.RH.R0
