import MCore.RH.Analytic.MellinRhoConvergence
import MCore.RH.Analytic.MellinTargetConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

open scoped BigOperators

namespace MCore.RH.R0

open Complex MeasureTheory

noncomputable def complexDirichletPolynomial
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x -
    ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

theorem mellinConvergent_finset_sum
    {ι : Type*} [DecidableEq ι] (S : Finset ι)
    (f : ι → ℝ → ℂ) (s : ℂ)
    (h : ∀ i ∈ S, MellinConvergent (f i) s) :
    MellinConvergent (fun x => ∑ i ∈ S, f i x) s := by
  classical
  induction S using Finset.induction_on with
  | empty =>
      simp [MellinConvergent]
  | @insert a S ha ih =>
      simp only [Finset.sum_insert ha]
      exact (h a (Finset.mem_insert_self _ _)).add
        (ih (fun i hi => h i (Finset.mem_insert_of_mem hi)))

theorem mellin_finset_sum
    {ι : Type*} [DecidableEq ι] (S : Finset ι)
    (f : ι → ℝ → ℂ) (s : ℂ)
    (h : ∀ i ∈ S, MellinConvergent (f i) s) :
    mellin (fun x => ∑ i ∈ S, f i x) s =
      ∑ i ∈ S, mellin (f i) s := by
  classical
  induction S using Finset.induction_on with
  | empty =>
      simp [mellin]
  | @insert a S ha ih =>
      simp only [Finset.sum_insert ha]
      have haConv := h a (Finset.mem_insert_self _ _)
      have hSConv := mellinConvergent_finset_sum S f s
        (fun i hi => h i (Finset.mem_insert_of_mem hi))
      rw [(hasMellin_add haConv hSConv).2]
      rw [ih (fun i hi => h i (Finset.mem_insert_of_mem hi))]

theorem generator_sum_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent
      (fun x : ℝ => ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s := by
  classical
  simpa only [Finset.sum_apply] using
    mellinConvergent_finset_sum
      (Finset.univ : Finset (Fin N))
      (fun i x => (c i : ℂ) * rhoRepresentativeC i x)
      s
      (by
        intro i hi
        exact (rhoRepresentativeC_mellinConvergent i hs0 hs1).const_smul (c i : ℂ))

theorem mellin_generator_sum
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (fun x : ℝ =>
      ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s =
      - riemannZeta s / s * complexDirichletPolynomial c s := by
  classical
  rw [mellin_finset_sum
    (Finset.univ : Finset (Fin N))
    (fun i x => (c i : ℂ) * rhoRepresentativeC i x)
    s]
  · simp_rw [mellin_const_smul, mellin_rho_realized _ s hs0 hs1]
    simp [complexDirichletPolynomial]
    ring
  · intro i hi
    exact (rhoRepresentativeC_mellinConvergent i hs0 hs1).const_smul (c i : ℂ)

theorem residual_mellin_closed_form
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * complexDirichletPolynomial c s) / s := by
  have hchiConv : MellinConvergent chiRepresentativeC s :=
    chiRepresentativeC_mellinConvergent hs0 (by linarith)
  have hsumConv :
      MellinConvergent
        (fun x : ℝ =>
          ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s :=
    generator_sum_mellinConvergent c s hs0 hs1
  have hsub := hasMellin_sub hchiConv hsumConv
  change mellin (residualRepresentativeC c) s = _
  rw [hsub.2]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_generator_sum c s hs0 hs1]
  field_simp
  ring

#print axioms MCore.RH.R0.mellinConvergent_finset_sum
#print axioms MCore.RH.R0.mellin_finset_sum
#print axioms MCore.RH.R0.generator_sum_mellinConvergent
#print axioms MCore.RH.R0.residual_mellin_closed_form

end MCore.RH.R0
