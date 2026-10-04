import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.D1KernelEntry
import MCore.RH.Analytic.MellinTarget

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Finite Dirichlet polynomial attached to the concrete coefficient vector. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Complex finite rho combination used by the Mellin residual. -/
noncomputable def rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Complex residual representative chi - sum c_i rho_i. -/
noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - rhoCombinationC c x

/-- Each scalar rho term is Mellin convergent on the strip. -/
theorem scaled_rho_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (i : Fin N) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent
      (fun x : ℝ => (c i : ℂ) * rhoRepresentativeC i x) s := by
  simpa [smul_eq_mul] using
    (rho_mellinConvergent i s hs0 hs1).const_smul (c i : ℂ)

/-- Finite rho combinations are Mellin convergent on the strip. -/
theorem rhoCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoCombinationC c) s := by
  classical
  unfold rhoCombinationC
  rw [MellinConvergent]
  exact integrable_finsetSum _ (fun i _ => by
    simpa [MellinConvergent, smul_eq_mul] using
      scaled_rho_mellinConvergent c i s hs0 hs1)

/-- Mellin transform of the finite rho combination. -/
theorem mellin_rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (rhoCombinationC c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  classical
  unfold rhoCombinationC concreteDirichletPolynomial
  rw [mellin]
  have hint : ∀ i : Fin N,
      IntegrableOn
        (fun x : ℝ =>
          (x : ℂ) ^ (s - 1) •
            ((c i : ℂ) * rhoRepresentativeC i x))
        (Ioi 0) := by
    intro i
    simpa [MellinConvergent, smul_eq_mul] using
      scaled_rho_mellinConvergent c i s hs0 hs1
  calc
    (∫ x : ℝ in Ioi 0,
      (x : ℂ) ^ (s - 1) •
        ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x)
        =
      ∑ i : Fin N,
        ∫ x : ℝ in Ioi 0,
          (x : ℂ) ^ (s - 1) •
            ((c i : ℂ) * rhoRepresentativeC i x) := by
          simp_rw [smul_sum]
          exact integral_finsetSum _ (fun i _ => hint i)
    _ =
      ∑ i : Fin N, (c i : ℂ) * mellin (rhoRepresentativeC i) s := by
          apply Finset.sum_congr rfl
          intro i hi
          rw [mellin_const_smul]
          simp [smul_eq_mul, mul_comm]
    _ =
      ∑ i : Fin N,
        (c i : ℂ) *
          (- (((rhoIndex i : ℕ) : ℂ) ^ (-s)) * riemannZeta s / s) := by
          apply Finset.sum_congr rfl
          intro i hi
          rw [mellin_rho_realized i s hs0 hs1]
    _ = - riemannZeta s / s *
      ∑ i : Fin N, (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s)) := by
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i hi
          ring

/-- The full residual is Mellin convergent on the strip. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  have hchi := chi_mellinConvergent s hs0
  have hrho := rhoCombinationC_mellinConvergent c s hs0 hs1
  simpa using (hasMellin_sub hchi hrho).1

/--
D3 algebraic half: exact Mellin transform of the finite residual.
No Plancherel theorem is used here.
-/
theorem mellin_residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  unfold residualRepresentativeC
  have hchi := chi_mellinConvergent s hs0
  have hrho := rhoCombinationC_mellinConvergent c s hs0 hs1
  have hsub := (hasMellin_sub hchi hrho).2
  rw [hsub]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_rhoCombinationC c s hs0 hs1]
  have hsne : s ≠ 0 := ne_zero_of_re_pos hs0
  field_simp [hsne]
  ring

#print axioms MCore.RH.R0.rhoCombinationC_mellinConvergent
#print axioms MCore.RH.R0.mellin_rhoCombinationC
#print axioms MCore.RH.R0.residualRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.mellin_residualRepresentativeC

end MCore.RH.R0
