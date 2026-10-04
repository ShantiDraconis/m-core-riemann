import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinTarget
import MCore.RH.Analytic.MellinRhoClosedForm

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Complex finite linear combination of concrete rho generators. -/
noncomputable def rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Finite Dirichlet polynomial attached to the same coefficient vector. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Complex residual representative chi - sum c_i rho_i. -/
noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - rhoCombinationC c x

/-- Finite-subset Mellin convergence, used by the residual algebra. -/
theorem rhoCombinationOnC_mellinConvergent
    {N : ℕ} (S : Finset (Fin N)) (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent
      (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s := by
  classical
  induction S using Finset.induction_on with
  | empty =>
      simp [MellinConvergent]
  | @insert a S ha ih =>
      rw [Finset.sum_insert ha]
      exact ((rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul
        (c a : ℂ)).add ih

/-- Mellin linearity for any finite subset of concrete generators. -/
theorem mellin_rhoCombinationOnC
    {N : ℕ} (S : Finset (Fin N)) (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin
        (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s =
      ∑ i ∈ S, (c i : ℂ) * mellin (rhoRepresentativeC i) s := by
  classical
  induction S using Finset.induction_on with
  | empty =>
      simp [mellin]
  | @insert a S ha ih =>
      rw [Finset.sum_insert ha, Finset.sum_insert ha]
      have hterm :=
        (rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
      have hrest := rhoCombinationOnC_mellinConvergent S c s hs0 hs1
      rw [(hasMellin_add hterm hrest).2]
      rw [mellin_const_smul]
      rw [ih]

/-- Finite rho combinations Mellin-converge throughout 0 < Re(s) < 1. -/
theorem rhoCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoCombinationC c) s := by
  simpa [rhoCombinationC] using
    rhoCombinationOnC_mellinConvergent
      (Finset.univ : Finset (Fin N)) c s hs0 hs1

/-- Mellin transform of the finite rho combination. -/
theorem mellin_rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (rhoCombinationC c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  classical
  rw [rhoCombinationC, concreteDirichletPolynomial]
  rw [mellin_rhoCombinationOnC
    (Finset.univ : Finset (Fin N)) c s hs0 hs1]
  simp_rw [mellin_rho_realized _ s hs0 hs1]
  ring

/-- The residual itself Mellin-converges throughout the open strip. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  exact (chiRepresentativeC_mellinConvergent s hs0 hs1).sub
    (rhoCombinationC_mellinConvergent c s hs0 hs1)

/-- D3 algebraic core: exact pointwise Mellin formula for the residual. -/
theorem mellin_residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  unfold residualRepresentativeC
  rw [(hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (rhoCombinationC_mellinConvergent c s hs0 hs1)).2]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_rhoCombinationC c s hs0 hs1]
  field_simp
  ring

#print axioms MCore.RH.R0.rhoCombinationOnC_mellinConvergent
#print axioms MCore.RH.R0.mellin_rhoCombinationOnC
#print axioms MCore.RH.R0.rhoCombinationC_mellinConvergent
#print axioms MCore.RH.R0.mellin_rhoCombinationC
#print axioms MCore.RH.R0.mellin_residualRepresentativeC

end MCore.RH.R0
