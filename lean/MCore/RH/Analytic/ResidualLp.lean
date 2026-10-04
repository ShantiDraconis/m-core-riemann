import MCore.RH.Analytic.ResidualPlancherelReduction
import MCore.RH.R0.RhoConcrete
import MCore.RH.R0.ChiMemLp
import Mathlib.MeasureTheory.Function.L2Space

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set

/-- Complexified target remains in L2 on the concrete positive-half-line measure. -/
theorem chiRepresentativeC_memLp_two :
    MemLp chiRepresentativeC 2 zeroInfinityMeasure := by
  simpa [chiRepresentativeC, twoExponent] using
    (chi_memLp_two.ofReal :
      MemLp (fun x => (chiRepresentative x : ℂ)) 2 zeroInfinityMeasure)

/-- Complexified concrete generators remain in L2. -/
theorem rhoRepresentativeC_memLp_two (n : ℕ) :
    MemLp (rhoRepresentativeC n) 2 zeroInfinityMeasure := by
  simpa [rhoRepresentativeC, twoExponent] using
    ((rho_memLp_two n).ofReal :
      MemLp (fun x => (rhoRepresentative n x : ℂ)) 2 zeroInfinityMeasure)

/-- Every finite complex coefficient combination of generators is in L2. -/
theorem complexFiniteCombination_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (complexFiniteCombination c) 2 zeroInfinityMeasure := by
  classical
  unfold complexFiniteCombination
  apply memLp_finsetSum'
  intro i hi
  simpa [Pi.smul_apply, smul_eq_mul] using
    (rhoRepresentativeC_memLp_two i).const_smul (c i : ℂ)

/-- The full residual chi - sum c_i rho_i is in L2. -/
theorem complexResidual_memLp_two
    {N : ℕ} (c : Fin N → ℝ) :
    MemLp (complexResidual c) 2 zeroInfinityMeasure := by
  simpa [complexResidual] using
    chiRepresentativeC_memLp_two.sub (complexFiniteCombination_memLp_two c)

/-- Squared norm of the residual is integrable on the positive half-line. -/
theorem complexResidual_sq_integrableOn_Ioi
    {N : ℕ} (c : Fin N → ℝ) :
    IntegrableOn (fun x : ℝ => ‖complexResidual c x‖ ^ 2) (Ioi 0) volume := by
  have hmem := complexResidual_memLp_two c
  have hsq :
      Integrable (fun x : ℝ => ‖complexResidual c x‖ ^ 2) zeroInfinityMeasure := by
    exact (memLp_two_iff_integrable_sq_norm hmem.aestronglyMeasurable).1 hmem
  simpa [zeroInfinityMeasure, ambientMeasure, zeroInfinityDomain, IntegrableOn] using hsq

#print axioms MCore.RH.R0.complexResidual_memLp_two
#print axioms MCore.RH.R0.complexResidual_sq_integrableOn_Ioi

end MCore.RH.R0
