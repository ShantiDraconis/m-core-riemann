import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Finite Dirichlet polynomial attached to a concrete coefficient vector. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N,
    (c i : ℂ) * ((((rhoIndex i : ℕ) : ℂ)) ^ (-s))

/-- Complex representative of the finite generator combination. -/
noncomputable def rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Complex residual representative chi - sum c_i rho_i. -/
noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - rhoCombinationC c x

/-- A finite rho combination is Mellin-convergent on 0 < Re(s) < 1. -/
theorem rhoCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoCombinationC c) s := by
  classical
  unfold rhoCombinationC MellinConvergent
  simpa only [smul_sum] using
    (Finset.integrable_finset_sum Finset.univ fun i hi =>
      by
        simpa [mul_smul, Complex.realCast_smul_eq_coe_mul] using
          (rhoRepresentativeC_mellinConvergent i s hs0 hs1).const_smul (c i : ℂ))

/-- Mellin transform of a finite rho combination. -/
theorem mellin_rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (rhoCombinationC c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  classical
  unfold rhoCombinationC concreteDirichletPolynomial
  rw [mellin]
  rw [integral_finset_sum]
  · apply Finset.sum_congr rfl
    intro i hi
    rw [← mellin]
    rw [mellin_const_smul]
    rw [mellin_rho_realized i s hs0 hs1]
    ring
  · intro i hi
    simpa [MellinConvergent, mul_smul, Complex.realCast_smul_eq_coe_mul] using
      (rhoRepresentativeC_mellinConvergent i s hs0 hs1).const_smul (c i : ℂ)

/-- Residual Mellin convergence on the critical strip. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  exact (chiRepresentativeC_mellinConvergent s hs0).sub
    (rhoCombinationC_mellinConvergent c s hs0 hs1)

/-- Pointwise Mellin formula for the concrete residual. -/
theorem mellin_residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  unfold residualRepresentativeC
  have hsub := hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0)
    (rhoCombinationC_mellinConvergent c s hs0 hs1)
  have hm := hsub.2
  rw [mellin_chiRepresentativeC s hs0,
    mellin_rhoCombinationC c s hs0 hs1] at hm
  rw [hm]
  have hsne : s ≠ 0 := ne_zero_of_re_pos hs0
  field_simp [hsne]
  ring

#print axioms MCore.RH.R0.rhoCombinationC_mellinConvergent
#print axioms MCore.RH.R0.mellin_rhoCombinationC
#print axioms MCore.RH.R0.mellin_residualRepresentativeC

end MCore.RH.R0
