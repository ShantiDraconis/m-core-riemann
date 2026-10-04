import MCore.RH.Analytic.MellinStripConvergence

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Complex Dirichlet polynomial attached to a finite real coefficient vector. -/
noncomputable def residualDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Pointwise complex residual representative. -/
noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Finite-subset Mellin convergence, preserving the concrete generator indices. -/
theorem generatorCombination_finset_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1)
    (S : Finset (Fin N)) :
    MellinConvergent
      (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s := by
  classical
  induction S using Finset.induction_on with
  | empty =>
      simp [MellinConvergent]
  | @insert a S ha ih =>
      rw [Finset.sum_insert ha]
      exact
        (hasMellin_add
          ((rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ))
          ih).1

/-- Mellin convergence of the full finite generator combination. -/
theorem generatorCombination_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent
      (fun x : ℝ => ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s := by
  simpa using
    generatorCombination_finset_mellinConvergent c s hs0 hs1 Finset.univ

/-- Mellin convergence of the full finite residual. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  exact (hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0)
    (generatorCombination_mellinConvergent c s hs0 hs1)).1

/-- Mellin transform of an arbitrary finite subset of generators. -/
theorem mellin_generatorCombination_finset
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1)
    (S : Finset (Fin N)) :
    mellin
      (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s =
      ∑ i ∈ S, (c i : ℂ) * mellin (rhoRepresentativeC i) s := by
  classical
  induction S using Finset.induction_on with
  | empty =>
      simp
  | @insert a S ha ih =>
      rw [Finset.sum_insert ha, Finset.sum_insert ha]
      have hadd :=
        (hasMellin_add
          ((rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ))
          (generatorCombination_finset_mellinConvergent c s hs0 hs1 S)).2
      rw [hadd]
      rw [mellin_const_smul]
      rw [ih]

/-- Exact Mellin transform of the full finite generator combination. -/
theorem mellin_generatorCombination
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin
      (fun x : ℝ => ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s =
      - riemannZeta s / s * residualDirichletPolynomial c s := by
  rw [mellin_generatorCombination_finset c s hs0 hs1 Finset.univ]
  simp_rw [mellin_rho_realized _ s hs0 hs1]
  unfold residualDirichletPolynomial
  ring

/-- D3 algebraic layer: Mellin transform of the residual is exactly (1 + zeta*P_c)/s. -/
theorem mellin_residual_closed_form
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * residualDirichletPolynomial c s) / s := by
  unfold residualRepresentativeC
  have hsub :=
    (hasMellin_sub
      (chiRepresentativeC_mellinConvergent s hs0)
      (generatorCombination_mellinConvergent c s hs0 hs1)).2
  rw [hsub]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_generatorCombination c s hs0 hs1]
  ring

#print axioms MCore.RH.R0.generatorCombination_mellinConvergent
#print axioms MCore.RH.R0.mellin_generatorCombination
#print axioms MCore.RH.R0.mellin_residual_closed_form

end MCore.RH.R0
