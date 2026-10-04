import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Finite Dirichlet polynomial attached to a coefficient vector. -/
noncomputable def residualDirichletPolynomial
    (N : ℕ) (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N,
    (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Complexified finite Nyman--Beurling approximant. -/
noncomputable def complexFiniteCombinationC
    (N : ℕ) (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Complex residual whose L2 norm is the concrete approximation error. -/
noncomputable def complexResidualC
    (N : ℕ) (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - complexFiniteCombinationC N c x

private theorem finiteSum_mellinConvergent
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
      have hterm :
          MellinConvergent
            (fun x : ℝ => (c a : ℂ) * rhoRepresentativeC a x) s := by
        simpa [smul_eq_mul] using
          (rho_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
      have hadd :=
        (hasMellin_add hterm ih).1
      simpa [Finset.sum_insert ha, add_comm, add_left_comm, add_assoc] using hadd

/-- The finite complex approximant has a convergent Mellin transform on the strip. -/
theorem complexFiniteCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (complexFiniteCombinationC N c) s := by
  classical
  simpa [complexFiniteCombinationC] using
    finiteSum_mellinConvergent c s hs0 hs1 Finset.univ

private theorem mellin_finiteSum
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1)
    (S : Finset (Fin N)) :
    mellin
      (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s =
      ∑ i ∈ S, (c i : ℂ) * mellin (rhoRepresentativeC i) s := by
  classical
  induction S using Finset.induction_on with
  | empty =>
      simp [mellin]
  | @insert a S ha ih =>
      have hterm :
          MellinConvergent
            (fun x : ℝ => (c a : ℂ) * rhoRepresentativeC a x) s := by
        simpa [smul_eq_mul] using
          (rho_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
      have hrest := finiteSum_mellinConvergent c s hs0 hs1 S
      have hadd := (hasMellin_add hterm hrest).2
      rw [mellin_const_smul] at hadd
      simpa [Finset.sum_insert ha, smul_eq_mul, add_comm, add_left_comm, add_assoc] using
        hadd.trans (congrArg (fun z : ℂ => (c a : ℂ) * mellin (rhoRepresentativeC a) s + z) ih)

/-- Mellin transform of the finite approximant in terms of the explicit rho transforms. -/
theorem mellin_complexFiniteCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (complexFiniteCombinationC N c) s =
      - riemannZeta s / s * residualDirichletPolynomial N c s := by
  classical
  rw [show mellin (complexFiniteCombinationC N c) s =
      ∑ i : Fin N, (c i : ℂ) * mellin (rhoRepresentativeC i) s by
        simpa [complexFiniteCombinationC] using
          mellin_finiteSum c s hs0 hs1 Finset.univ]
  simp_rw [mellin_rho_realized _ s hs0 hs1]
  unfold residualDirichletPolynomial
  ring

/-- The residual itself is Mellin-convergent on the open strip. -/
theorem complexResidualC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (complexResidualC N c) s := by
  have hchi := chi_mellinConvergent s hs0
  have hcomb := complexFiniteCombinationC_mellinConvergent c s hs0 hs1
  simpa [complexResidualC] using (hasMellin_sub hchi hcomb).1

/-- D3 algebraic half: exact Mellin transform of the concrete residual. -/
theorem mellin_complexResidualC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (complexResidualC N c) s =
      (1 + riemannZeta s * residualDirichletPolynomial N c s) / s := by
  have hchi := chi_mellinConvergent s hs0
  have hcomb := complexFiniteCombinationC_mellinConvergent c s hs0 hs1
  have hsub := (hasMellin_sub hchi hcomb).2
  rw [mellin_chiRepresentativeC s hs0,
      mellin_complexFiniteCombinationC c s hs0 hs1] at hsub
  simpa [complexResidualC] using hsub.trans (by ring)

#print axioms MCore.RH.R0.complexFiniteCombinationC_mellinConvergent
#print axioms MCore.RH.R0.mellin_complexFiniteCombinationC
#print axioms MCore.RH.R0.complexResidualC_mellinConvergent
#print axioms MCore.RH.R0.mellin_complexResidualC

end MCore.RH.R0
