import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.D1KernelEntry
import MCore.RH.Analytic.MellinTarget

open scoped BigOperators

namespace MCore.RH.R0

open Complex MeasureTheory Set

/-- Complex finite Nyman--Beurling combination. -/
noncomputable def concreteFiniteCombinationC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Dirichlet polynomial attached to a finite coefficient vector. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Complex residual chi - sum c_i rho_i. -/
noncomputable def concreteResidualC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - concreteFiniteCombinationC c x

/-- Finite complex rho combinations are Mellin-convergent on the open strip. -/
theorem concreteFiniteCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (concreteFiniteCombinationC c) s := by
  classical
  unfold concreteFiniteCombinationC
  induction (Finset.univ : Finset (Fin N)) using Finset.induction_on with
  | empty =>
      simpa using
        (MellinConvergent.zero (s := s) (E := ℂ))
  | @insert a S ha ih =>
      rw [Finset.sum_insert ha]
      apply MellinConvergent.add
      · simpa only [smul_eq_mul] using
          (rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
      · exact ih

/-- Mellin transform of the finite rho combination. -/
theorem mellin_concreteFiniteCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (concreteFiniteCombinationC c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  classical
  unfold concreteFiniteCombinationC concreteDirichletPolynomial
  have hconv :
      ∀ i : Fin N, MellinConvergent (rhoRepresentativeC i) s :=
    fun i => rhoRepresentativeC_mellinConvergent i s hs0 hs1
  calc
    mellin (fun x : ℝ => ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s
        = ∑ i : Fin N, mellin (fun x : ℝ => (c i : ℂ) * rhoRepresentativeC i x) s := by
            induction (Finset.univ : Finset (Fin N)) using Finset.induction_on with
            | empty => simp
            | @insert a S ha ih =>
                rw [Finset.sum_insert ha, Finset.sum_insert ha]
                rw [show (fun x : ℝ =>
                      (c a : ℂ) * rhoRepresentativeC a x +
                        ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) =
                    fun x : ℝ =>
                      (c a : ℂ) * rhoRepresentativeC a x +
                        (∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) by rfl]
                rw [mellin_add]
                · rw [ih]
                · simpa only [smul_eq_mul] using (hconv a).const_smul (c a : ℂ)
                · induction S using Finset.induction_on with
                  | empty => simpa using (MellinConvergent.zero (s := s) (E := ℂ))
                  | @insert b T hb hT =>
                      rw [Finset.sum_insert hb]
                      exact MellinConvergent.add
                        (by simpa only [smul_eq_mul] using (hconv b).const_smul (c b : ℂ))
                        hT
    _ = ∑ i : Fin N, (c i : ℂ) * mellin (rhoRepresentativeC i) s := by
          apply Finset.sum_congr rfl
          intro i hi
          simpa only [smul_eq_mul] using
            mellin_const_smul (rhoRepresentativeC i) s (c i : ℂ)
    _ = ∑ i : Fin N,
          (c i : ℂ) *
            (- (((rhoIndex i : ℕ) : ℂ) ^ (-s)) * riemannZeta s / s) := by
          apply Finset.sum_congr rfl
          intro i hi
          rw [mellin_rho_realized i s hs0 hs1]
    _ = - riemannZeta s / s *
          ∑ i : Fin N, (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s)) := by
          ring_nf
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i hi
          ring

/-- The residual is Mellin-convergent throughout the open critical strip. -/
theorem concreteResidualC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (concreteResidualC c) s := by
  unfold concreteResidualC
  exact MellinConvergent.sub
    (chiRepresentativeC_mellinConvergent s hs0)
    (concreteFiniteCombinationC_mellinConvergent c s hs0 hs1)

/-- D3 algebraic core: exact Mellin transform of the finite residual. -/
theorem mellin_concreteResidualC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (concreteResidualC c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  unfold concreteResidualC
  rw [mellin_sub
    (chiRepresentativeC_mellinConvergent s hs0)
    (concreteFiniteCombinationC_mellinConvergent c s hs0 hs1)]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_concreteFiniteCombinationC c s hs0 hs1]
  ring

#print axioms MCore.RH.R0.mellin_concreteResidualC

end MCore.RH.R0
