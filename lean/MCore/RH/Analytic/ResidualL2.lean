import MCore.RH.Analytic.LogPullbackL2
import MCore.RH.R0.ChiMemLp
import MCore.RH.R0.RhoBasicFacts
import Mathlib.MeasureTheory.Function.L2Space

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set

/-- Complexified target remains in L2. -/
theorem chiRepresentativeC_memLp_two :
    MemLp chiRepresentativeC 2 zeroInfinityMeasure := by
  simpa [chiRepresentativeC] using
    (chi_memLp_two.ofReal :
      MemLp (fun x : ℝ => (chiRepresentative x : ℂ)) 2 zeroInfinityMeasure)

/-- Every complexified rho generator remains in L2. -/
theorem rhoRepresentativeC_memLp_two (n : ℕ) :
    MemLp (rhoRepresentativeC n) 2 zeroInfinityMeasure := by
  simpa [rhoRepresentativeC] using
    (rhoRepresentative_memLp_two_public n).ofReal

/-- Finite complex rho combinations belong to L2. -/
theorem rhoCombinationC_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (rhoCombinationC c) 2 zeroInfinityMeasure := by
  classical
  unfold rhoCombinationC
  induction (Finset.univ : Finset (Fin N)) using Finset.induction_on with
  | empty =>
      simpa using (memLp_zero : MemLp (0 : ℝ → ℂ) 2 zeroInfinityMeasure)
  | @insert a S ha ih =>
      rw [Finset.sum_insert ha]
      exact ((rhoRepresentativeC_memLp_two a).const_smul (c a : ℂ)).add ih

/-- The complex residual belongs to the frozen L2 carrier. -/
theorem residualRepresentativeC_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (residualRepresentativeC c) 2 zeroInfinityMeasure := by
  unfold residualRepresentativeC
  exact chiRepresentativeC_memLp_two.sub (rhoCombinationC_memLp_two c)

/-- Square norm of the residual representative is integrable on the positive half-line. -/
theorem residual_normSq_integrable
    {N : ℕ} (c : Fin N → ℝ) :
    IntegrableOn
      (fun x : ℝ => ‖residualRepresentativeC c x‖ ^ 2)
      (Ioi 0) := by
  have h := residualRepresentativeC_memLp_two c
  rw [memLp_two_iff_integrable_sq_norm h.aestronglyMeasurable] at h
  simpa [zeroInfinityMeasure] using h

/-- The logarithmic pullback of the residual is L2 on the full real line. -/
theorem residual_logPullback_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (logPullback (residualRepresentativeC c)) 2 volume := by
  have hmeas :
      AEStronglyMeasurable (logPullback (residualRepresentativeC c)) volume := by
    exact (continuous_const.smul
      (((residualRepresentativeC_memLp_two c).aestronglyMeasurable.comp_quasiMeasurePreserving
        (Real.quasiMeasurePreserving_exp.comp
          (MeasureTheory.quasiMeasurePreserving_neg volume)))))
  rw [memLp_two_iff_integrable_sq_norm hmeas]
  have hres := residual_normSq_integrable c
  have hEq := residual_logPullback_normSq_integral c
  exact Integrable.of_integral_norm_lt_top (by
    rw [hEq]
    exact hres.integral_norm_lt_top)

#print axioms MCore.RH.R0.residualRepresentativeC_memLp_two
#print axioms MCore.RH.R0.residual_logPullback_memLp_two

end MCore.RH.R0
