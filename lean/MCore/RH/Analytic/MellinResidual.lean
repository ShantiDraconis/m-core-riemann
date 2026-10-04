import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Certified finite Dirichlet polynomial attached to coefficients c. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N,
    (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Literal complex representative of the finite generator combination. -/
noncomputable def complexFiniteCombinationRepresentative
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Literal complex residual representative chi - sum c_i rho_i. -/
noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - complexFiniteCombinationRepresentative c x

/-- Each scalar-weighted generator has the expected Mellin transform. -/
theorem hasMellin_coeff_rho
    {N : ℕ} (c : Fin N → ℝ) (i : Fin N)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    HasMellin
      (fun x : ℝ => (c i : ℂ) * rhoRepresentativeC i x)
      s
      ((c i : ℂ) * mellin (rhoRepresentativeC i) s) := by
  constructor
  · simpa [smul_eq_mul] using
      (rhoRepresentativeC_mellinConvergent i s hs0 hs1).const_smul (c i : ℂ)
  · simpa [smul_eq_mul] using
      (mellin_const_smul (rhoRepresentativeC i) s (c i : ℂ))

/-- Finite sums of the concrete generators have the sum of their Mellin transforms. -/
theorem hasMellin_complexFiniteCombination
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    HasMellin
      (complexFiniteCombinationRepresentative c)
      s
      (∑ i : Fin N, (c i : ℂ) * mellin (rhoRepresentativeC i) s) := by
  classical
  unfold complexFiniteCombinationRepresentative
  induction (Finset.univ : Finset (Fin N)) using Finset.induction_on with
  | empty =>
      simp [MellinConvergent, mellin]
  | @insert a S ha ih =>
      have hsingle := hasMellin_coeff_rho c a s hs0 hs1
      have hadd := hasMellin_add hsingle.1 ih.1
      simpa [Finset.sum_insert ha, add_comm, add_left_comm, add_assoc] using hadd

/-- Closed form for the finite-combination Mellin transform. -/
theorem mellin_complexFiniteCombination
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (complexFiniteCombinationRepresentative c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  have h := (hasMellin_complexFiniteCombination c s hs0 hs1).2
  rw [h]
  unfold concreteDirichletPolynomial
  simp_rw [mellin_rho_realized _ s hs0 hs1]
  ring_nf
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  ring

/-- The finite-combination representative is Mellin-convergent on the strip. -/
theorem complexFiniteCombination_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (complexFiniteCombinationRepresentative c) s :=
  (hasMellin_complexFiniteCombination c s hs0 hs1).1

/-- The residual chi - sum c_i rho_i is Mellin-convergent on the strip. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  exact (chiRepresentativeC_mellinConvergent s hs0 hs1).sub
    (complexFiniteCombination_mellinConvergent c s hs0 hs1)

/-- D3 algebraic core: exact Mellin transform of the residual. -/
theorem mellin_residual_closed_form
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  unfold residualRepresentativeC
  have hsub := hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (complexFiniteCombination_mellinConvergent c s hs0 hs1)
  rw [hsub.2]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_complexFiniteCombination c s hs0 hs1]
  have hsne : s ≠ 0 := ne_zero_of_re_pos hs0
  field_simp [hsne]
  ring

#print axioms MCore.RH.R0.mellin_complexFiniteCombination
#print axioms MCore.RH.R0.residualRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.mellin_residual_closed_form

end MCore.RH.R0
