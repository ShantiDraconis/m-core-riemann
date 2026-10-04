import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

namespace MCore.RH.R0

open scoped BigOperators
open Complex MeasureTheory Set

/-- Finite Dirichlet polynomial attached to a coefficient vector. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N,
    (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Literal complex representative of the finite rho combination. -/
noncomputable def finiteRhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Literal complex residual chi - sum c_i rho_i. -/
noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - finiteRhoCombinationC c x

/-- Finite rho combinations are Mellin-convergent throughout 0 < Re(s) < 1. -/
theorem finiteRhoCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (finiteRhoCombinationC c) s := by
  classical
  have hsum :
      ∀ S : Finset (Fin N),
        MellinConvergent
          (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s := by
    intro S
    induction S using Finset.induction_on with
    | empty =>
        simp [MellinConvergent]
    | @insert a S ha ih =>
        have hca :
            MellinConvergent
              (fun x : ℝ => (c a : ℂ) * rhoRepresentativeC a x) s := by
          simpa [smul_eq_mul] using
            (rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
        have hadd := hasMellin_add hca ih
        simpa [Finset.sum_insert ha, finiteRhoCombinationC] using hadd.1
  simpa [finiteRhoCombinationC] using hsum Finset.univ

/-- Mellin transform of the finite rho combination. -/
theorem mellin_finiteRhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (finiteRhoCombinationC c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  classical
  have hsum :
      ∀ S : Finset (Fin N),
        mellin
          (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s =
        ∑ i ∈ S, (c i : ℂ) * mellin (rhoRepresentativeC i) s := by
    intro S
    induction S using Finset.induction_on with
    | empty =>
        simp [mellin]
    | @insert a S ha ih =>
        have hca := rhoRepresentativeC_mellinConvergent a s hs0 hs1
        have hrest :
            MellinConvergent
              (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s := by
          have h :=
            finiteRhoCombinationC_mellinConvergent
              (N := S.card)
              (fun i => 0) s hs0 hs1
          -- Rebuild directly from the induction hypothesis's finite terms.
          induction S using Finset.induction_on with
          | empty => simp [MellinConvergent]
          | @insert b T hb ihT =>
              have hcb :
                  MellinConvergent
                    (fun x : ℝ => (c b : ℂ) * rhoRepresentativeC b x) s := by
                simpa [smul_eq_mul] using
                  (rhoRepresentativeC_mellinConvergent b s hs0 hs1).const_smul (c b : ℂ)
              exact (by
                simpa [Finset.sum_insert hb] using
                  (hasMellin_add hcb ihT).1)
        have hleft := hasMellin_add
          (by simpa [smul_eq_mul] using hca.const_smul (c a : ℂ))
          hrest
        rw [Finset.sum_insert ha]
        rw [show
          (fun x : ℝ =>
            ∑ i ∈ insert a S, (c i : ℂ) * rhoRepresentativeC i x) =
          (fun x : ℝ =>
            (c a : ℂ) * rhoRepresentativeC a x +
              ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) by
              funext x
              simp [Finset.sum_insert ha]]
        rw [hleft.2, mellin_const_smul, ih]
  rw [show mellin (finiteRhoCombinationC c) s =
      ∑ i : Fin N, (c i : ℂ) * mellin (rhoRepresentativeC i) s by
        simpa [finiteRhoCombinationC] using hsum Finset.univ]
  simp_rw [mellin_rho_realized _ s hs0 hs1]
  unfold concreteDirichletPolynomial
  ring_nf
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  ring

/-- The residual is Mellin-convergent on the full critical strip. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  exact (hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (finiteRhoCombinationC_mellinConvergent c s hs0 hs1)).1

/-- D3 algebraic half: exact Mellin transform of the finite residual. -/
theorem mellin_residual_closed_form
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  unfold residualRepresentativeC
  have hsub := hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (finiteRhoCombinationC_mellinConvergent c s hs0 hs1)
  rw [hsub.2]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_finiteRhoCombinationC c s hs0 hs1]
  have hsne : s ≠ 0 := ne_zero_of_re_pos hs0
  field_simp [hsne]
  ring

#print axioms MCore.RH.R0.residualRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.mellin_residual_closed_form

end MCore.RH.R0
