import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Complex finite combination of the concrete Nyman--Beurling generators. -/
noncomputable def complexFiniteCombination
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Dirichlet polynomial attached to the same coefficient vector. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Complex residual representative chi - sum c_i rho_i. -/
noncomputable def complexResidual
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - complexFiniteCombination c x

/-- Finite Mellin sum, proved by induction with no exchange of infinite sums. -/
theorem hasMellin_complexFiniteCombination
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    HasMellin (complexFiniteCombination c) s
      (∑ i : Fin N, (c i : ℂ) * mellin (rhoRepresentativeC i) s) := by
  classical
  have hfin : ∀ S : Finset (Fin N),
      HasMellin
        (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x)
        s
        (∑ i ∈ S, (c i : ℂ) * mellin (rhoRepresentativeC i) s) := by
    intro S
    induction S using Finset.induction_on with
    | empty =>
        constructor
        · unfold MellinConvergent
          simp
        · simp [mellin]
    | @insert a S ha ih =>
        have hterm :
            MellinConvergent
              (fun x : ℝ => (c a : ℂ) * rhoRepresentativeC a x) s := by
          simpa [smul_eq_mul] using
            (rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
        have hadd := hasMellin_add hterm ih.1
        constructor
        · simpa [Finset.sum_insert ha, mul_add, add_mul] using hadd.1
        · rw [hadd.2]
          rw [mellin_const_smul]
          simp [Finset.sum_insert ha, smul_eq_mul]
  simpa [complexFiniteCombination] using hfin Finset.univ

/-- Mellin transform of the finite combination in zeta/Dirichlet-polynomial form. -/
theorem mellin_complexFiniteCombination
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (complexFiniteCombination c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  have h := (hasMellin_complexFiniteCombination c s hs0 hs1).2
  rw [h]
  simp_rw [mellin_rho_realized _ s hs0 hs1]
  unfold concreteDirichletPolynomial
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  ring

/-- Mellin convergence of the finite combination on the critical strip. -/
theorem complexFiniteCombination_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (complexFiniteCombination c) s :=
  (hasMellin_complexFiniteCombination c s hs0 hs1).1

/-- D3 algebraic core: exact Mellin transform of the residual. -/
theorem mellin_complexResidual
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (complexResidual c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  have hchi := chiRepresentativeC_mellinConvergent s hs0 hs1
  have hcomb := complexFiniteCombination_mellinConvergent c s hs0 hs1
  have hsub := hasMellin_sub hchi hcomb
  have hformula := hsub.2
  change mellin (complexResidual c) s = _
  rw [show complexResidual c =
      (fun x : ℝ => chiRepresentativeC x - complexFiniteCombination c x) by rfl]
  rw [hformula]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_complexFiniteCombination c s hs0 hs1]
  have hsne : s ≠ 0 := ne_zero_of_re_pos hs0
  field_simp [hsne]
  ring

#print axioms MCore.RH.R0.hasMellin_complexFiniteCombination
#print axioms MCore.RH.R0.mellin_complexFiniteCombination
#print axioms MCore.RH.R0.mellin_complexResidual

end MCore.RH.R0
