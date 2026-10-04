import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.D1KernelEntry
import MCore.RH.Analytic.MellinTarget

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Finite complex linear combination of the concrete rho-generators. -/
noncomputable def rhoLinearCombinationC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- The associated finite Dirichlet polynomial. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N,
    (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Complex residual representative chi - sum c_i rho_i. -/
noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - rhoLinearCombinationC c x

/-- The finite rho combination is Mellin-convergent on 0 < Re(s) < 1. -/
theorem rhoLinearCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoLinearCombinationC c) s := by
  unfold MellinConvergent rhoLinearCombinationC
  have hterm : ∀ i : Fin N,
      IntegrableOn
        (fun t : ℝ =>
          (t : ℂ) ^ (s - 1) •
            ((c i : ℂ) * rhoRepresentativeC i t))
        (Ioi 0) := by
    intro i
    have h := (rhoRepresentativeC_mellinConvergent i s hs0 hs1).const_smul (c i : ℂ)
    simpa [MellinConvergent, smul_eq_mul, mul_assoc, mul_left_comm, mul_comm] using h
  simpa [Finset.smul_sum, smul_eq_mul] using
    (integrable_finsetSum Finset.univ (fun i _ => hterm i))

/-- Exact Mellin transform of the finite rho combination. -/
theorem mellin_rhoLinearCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (rhoLinearCombinationC c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  unfold rhoLinearCombinationC concreteDirichletPolynomial
  have hterm : ∀ i : Fin N,
      IntegrableOn
        (fun t : ℝ =>
          (t : ℂ) ^ (s - 1) •
            ((c i : ℂ) * rhoRepresentativeC i t))
        (Ioi 0) := by
    intro i
    have h := (rhoRepresentativeC_mellinConvergent i s hs0 hs1).const_smul (c i : ℂ)
    simpa [MellinConvergent, smul_eq_mul, mul_assoc, mul_left_comm, mul_comm] using h
  rw [mellin]
  rw [show
    (fun t : ℝ =>
      (t : ℂ) ^ (s - 1) •
        ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i t) =
      fun t : ℝ =>
        ∑ i : Fin N,
          (t : ℂ) ^ (s - 1) •
            ((c i : ℂ) * rhoRepresentativeC i t) by
      funext t; simp [Finset.smul_sum]]
  rw [integral_finsetSum Finset.univ (fun i _ => hterm i)]
  apply Finset.sum_congr rfl
  intro i hi
  rw [← mellin]
  rw [mellin_const_smul]
  rw [mellin_rho_realized i s hs0 hs1]
  simp [smul_eq_mul]
  ring

/-- The residual itself is Mellin-convergent on the strip. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  exact (hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (rhoLinearCombinationC_mellinConvergent c s hs0 hs1)).1

/-- D3 algebraic core: exact pointwise Mellin formula for the residual. -/
theorem mellin_residual_closed_form
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  unfold residualRepresentativeC
  have hsub := hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (rhoLinearCombinationC_mellinConvergent c s hs0 hs1)
  rw [hsub.2]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_rhoLinearCombinationC c s hs0 hs1]
  have hsne : s ≠ 0 := ne_zero_of_re_pos hs0
  field_simp [hsne]
  ring

#print axioms MCore.RH.R0.rhoLinearCombinationC_mellinConvergent
#print axioms MCore.RH.R0.mellin_rhoLinearCombinationC
#print axioms MCore.RH.R0.residualRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.mellin_residual_closed_form

end MCore.RH.R0
