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

/-- Mellin convergence of a finite generator combination on the critical strip. -/
theorem generatorCombination_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent
      (fun x : ℝ => ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s := by
  classical
  induction N with
  | zero =>
      simpa using (MellinConvergent.zero (s := s) (E := ℂ))
  | succ N ih =>
      rw [Fin.sum_univ_succ]
      exact (rhoRepresentativeC_mellinConvergent 0 s hs0 hs1).const_smul (c 0 : ℂ)
        |>.add (by
          simpa using ih (fun i : Fin N => c i.succ))

/-- Mellin convergence of the full finite residual. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  exact (chiRepresentativeC_mellinConvergent s hs0).sub
    (generatorCombination_mellinConvergent c s hs0 hs1)

/-- Exact Mellin transform of the finite generator combination. -/
theorem mellin_generatorCombination
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin
      (fun x : ℝ => ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s =
      - riemannZeta s / s * residualDirichletPolynomial c s := by
  classical
  induction N with
  | zero =>
      simp [residualDirichletPolynomial]
  | succ N ih =>
      rw [Fin.sum_univ_succ]
      have h0 := mellin_const_smul (rhoRepresentativeC 0) s (c 0 : ℂ)
      have hscomb :
          mellin
            (fun x : ℝ =>
              (c 0 : ℂ) * rhoRepresentativeC 0 x +
                ∑ i : Fin N, (c i.succ : ℂ) * rhoRepresentativeC i.succ x) s =
          mellin (fun x : ℝ => (c 0 : ℂ) * rhoRepresentativeC 0 x) s +
          mellin
            (fun x : ℝ =>
              ∑ i : Fin N, (c i.succ : ℂ) * rhoRepresentativeC i.succ x) s :=
        (hasMellin_add
          ((rhoRepresentativeC_mellinConvergent 0 s hs0 hs1).const_smul (c 0 : ℂ))
          (by
            simpa using
              generatorCombination_mellinConvergent
                (fun i : Fin N => c i.succ) s hs0 hs1)).2
      rw [hscomb]
      rw [h0]
      rw [mellin_rho_realized 0 s hs0 hs1]
      rw [ih (fun i : Fin N => c i.succ)]
      simp [residualDirichletPolynomial, Fin.sum_univ_succ]
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

#print axioms MCore.RH.R0.mellin_residual_closed_form

end MCore.RH.R0
