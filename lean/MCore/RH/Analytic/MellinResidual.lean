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

/-- Finite rho combinations Mellin-converge throughout 0 < Re(s) < 1. -/
theorem rhoCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoCombinationC c) s := by
  classical
  unfold rhoCombinationC
  induction (Finset.univ : Finset (Fin N)) using Finset.induction_on with
  | empty =>
      simp [MellinConvergent]
  | @insert a S ha ih =>
      rw [Finset.sum_insert ha]
      exact ((rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)).add ih

/-- Mellin transform of the finite rho combination. -/
theorem mellin_rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (rhoCombinationC c) s =
      - riemannZeta s / s * concreteDirichletPolynomial c s := by
  classical
  unfold rhoCombinationC concreteDirichletPolynomial
  induction (Finset.univ : Finset (Fin N)) using Finset.induction_on with
  | empty => simp
  | @insert a S ha ih =>
      rw [Finset.sum_insert ha, Finset.sum_insert ha]
      have hterm := (rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
      have hrest : MellinConvergent (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s := by
        induction S using Finset.induction_on with
        | empty => simp [MellinConvergent]
        | @insert b T hb ihT =>
            rw [Finset.sum_insert hb]
            exact ((rhoRepresentativeC_mellinConvergent b s hs0 hs1).const_smul (c b : ℂ)).add ihT
      rw [(hasMellin_add hterm hrest).2]
      rw [mellin_const_smul]
      rw [mellin_rho_realized a s hs0 hs1]
      rw [ih]
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

#print axioms MCore.RH.R0.rhoCombinationC_mellinConvergent
#print axioms MCore.RH.R0.mellin_rhoCombinationC
#print axioms MCore.RH.R0.mellin_residualRepresentativeC

end MCore.RH.R0
