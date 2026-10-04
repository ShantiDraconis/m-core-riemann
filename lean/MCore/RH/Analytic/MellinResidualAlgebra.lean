import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import Mathlib.Analysis.MellinTransform

open scoped BigOperators

namespace MCore.RH.R0

open Complex MeasureTheory

/-- Explicit finite Dirichlet polynomial attached to real coefficients. -/
noncomputable def concreteDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N,
    (c i : ℂ) * ((((rhoIndex i : ℕ) : ℂ)) ^ (-s))

/-- Complex representative of the finite Beurling combination. -/
noncomputable def complexFiniteCombination
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Complex residual representative chi - sum c_i rho_i. -/
noncomputable def complexResidual
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - complexFiniteCombination c x

/-- Mellin transform of an arbitrary finite subset of the concrete generator family. -/
theorem hasMellin_finset_rho
    {N : ℕ} (S : Finset (Fin N)) (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    HasMellin
      (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x)
      s
      (∑ i ∈ S, (c i : ℂ) * mellin (rhoRepresentativeC i) s) := by
  classical
  induction S using Finset.induction_on with
  | empty =>
      constructor
      · simp [MellinConvergent]
      · simp [mellin]
  | @insert a S ha ih =>
      have hterm :
          HasMellin
            (fun x : ℝ => (c a : ℂ) * rhoRepresentativeC a x)
            s
            ((c a : ℂ) * mellin (rhoRepresentativeC a) s) := by
        simpa [smul_eq_mul] using
          (hasMellin_const_smul
            (rhoRepresentativeC_mellinConvergent a s hs0 hs1)
            (c a : ℂ))
      have hadd := hasMellin_add hterm.1 ih.1
      constructor
      · simpa [Finset.sum_insert ha] using hadd.1
      · have hval := hadd.2
        rw [hterm.2, ih.2] at hval
        simpa [Finset.sum_insert ha] using hval

/-- Mellin transform of the full finite combination. -/
theorem hasMellin_complexFiniteCombination
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    HasMellin
      (complexFiniteCombination c)
      s
      (∑ i : Fin N, (c i : ℂ) * mellin (rhoRepresentativeC i) s) := by
  simpa [complexFiniteCombination] using
    hasMellin_finset_rho (Finset.univ : Finset (Fin N)) c s hs0 hs1

/-- Closed Mellin formula for the finite generator combination. -/
theorem mellin_complexFiniteCombination
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (complexFiniteCombination c) s =
      -(riemannZeta s / s) * concreteDirichletPolynomial c s := by
  have h := (hasMellin_complexFiniteCombination c s hs0 hs1).2
  rw [h]
  simp_rw [mellin_rho_realized _ s hs0 hs1]
  unfold concreteDirichletPolynomial
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  ring

/-- Mellin convergence of the finite combination. -/
theorem complexFiniteCombination_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (complexFiniteCombination c) s :=
  (hasMellin_complexFiniteCombination c s hs0 hs1).1

/-- D3 algebraic core: exact Mellin transform of the residual. -/
theorem mellin_complexResidual
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (complexResidual c) s =
      (1 + riemannZeta s * concreteDirichletPolynomial c s) / s := by
  have hsub := hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (complexFiniteCombination_mellinConvergent c s hs0 hs1)
  have hval := hsub.2
  change mellin (complexResidual c) s = _
  rw [hval, mellin_chiRepresentativeC s hs0,
    mellin_complexFiniteCombination c s hs0 hs1]
  field_simp
  ring

/-- Mellin convergence of the residual itself. -/
theorem complexResidual_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ)
    (s : ℂ) (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (complexResidual c) s :=
  (hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (complexFiniteCombination_mellinConvergent c s hs0 hs1)).1

#print axioms MCore.RH.R0.mellin_complexFiniteCombination
#print axioms MCore.RH.R0.mellin_complexResidual
#print axioms MCore.RH.R0.complexResidual_mellinConvergent

end MCore.RH.R0
