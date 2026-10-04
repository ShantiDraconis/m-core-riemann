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

theorem mellin_generator_sum
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (fun x : ℝ =>
      ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s =
      - riemannZeta s / s * complexDirichletPolynomial c s := by
  classical
  induction N with
  | zero =>
      simp [complexDirichletPolynomial]
  | succ N ih =>
      rw [show (fun x : ℝ =>
        ∑ i : Fin (N + 1), (c i : ℂ) * rhoRepresentativeC i x) =
          fun x =>
            (∑ i : Fin N, (c (Fin.castSucc i) : ℂ) * rhoRepresentativeC i x) +
            (c (Fin.last N) : ℂ) * rhoRepresentativeC N x by
        funext x
        rw [Fin.sum_univ_succ]
        rfl]
      have hsumConv :
          MellinConvergent
            (fun x : ℝ =>
              ∑ i : Fin N,
                (c (Fin.castSucc i) : ℂ) * rhoRepresentativeC i x) s := by
        classical
        induction N with
        | zero => simpa [MellinConvergent] 
        | succ M hM =>
            rw [show (fun x : ℝ =>
              ∑ i : Fin (M + 1),
                (c (Fin.castSucc i) : ℂ) * rhoRepresentativeC i x) =
              fun x =>
                (∑ i : Fin M,
                  (c (Fin.castSucc (Fin.castSucc i)) : ℂ) *
                    rhoRepresentativeC i x) +
                (c (Fin.castSucc (Fin.last M)) : ℂ) *
                    rhoRepresentativeC M x by
                  funext x
                  rw [Fin.sum_univ_succ]
                  rfl]
            exact (hM).add
              ((rhoRepresentativeC_mellinConvergent M hs0 hs1).const_smul _)
      have hlastConv :
          MellinConvergent
            (fun x : ℝ =>
              (c (Fin.last N) : ℂ) * rhoRepresentativeC N x) s :=
        (rhoRepresentativeC_mellinConvergent N hs0 hs1).const_smul _
      have hadd := hasMellin_add hsumConv hlastConv
      rw [hadd.2]
      rw [mellin_const_smul]
      rw [mellin_rho_realized N s hs0 hs1]
      simp [complexDirichletPolynomial, Fin.sum_univ_succ]
      ring

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
          ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x) s := by
    classical
    induction N with
    | zero =>
        simp [MellinConvergent]
    | succ N ih =>
        rw [show (fun x : ℝ =>
          ∑ i : Fin (N + 1), (c i : ℂ) * rhoRepresentativeC i x) =
          fun x =>
            (∑ i : Fin N, (c (Fin.castSucc i) : ℂ) * rhoRepresentativeC i x) +
            (c (Fin.last N) : ℂ) * rhoRepresentativeC N x by
              funext x
              rw [Fin.sum_univ_succ]
              rfl]
        exact ih.add
          ((rhoRepresentativeC_mellinConvergent N hs0 hs1).const_smul _)
  have hsub := hasMellin_sub hchiConv hsumConv
  change mellin (residualRepresentativeC c) s = _
  rw [hsub.2]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_generator_sum c s hs0 hs1]
  field_simp
  ring

#print axioms MCore.RH.R0.residual_mellin_closed_form

end MCore.RH.R0
