import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget
import Mathlib.Analysis.MellinTransform

open scoped BigOperators

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Finite Dirichlet polynomial attached to a concrete coefficient vector. -/
noncomputable def residualDirichletPolynomial
    (N : ℕ) (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N,
    (c i : ℂ) * (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Complex-valued finite rho combination. -/
noncomputable def finiteRhoCombinationC
    (N : ℕ) (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Concrete residual representative used by the Mellin/Plancherel lane. -/
noncomputable def residualRepresentativeC
    (N : ℕ) (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - finiteRhoCombinationC N c x

/-- The finite complex rho combination is Mellin-convergent on the strip. -/
theorem finiteRhoCombinationC_mellinConvergent
    (N : ℕ) (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (finiteRhoCombinationC N c) s := by
  classical
  unfold finiteRhoCombinationC
  induction (Finset.univ : Finset (Fin N)) using Finset.induction_on with
  | empty =>
      simp [MellinConvergent]
  | @insert a S ha ih =>
      have hca :
          MellinConvergent
            (fun x : ℝ => (c a : ℂ) * rhoRepresentativeC a x) s := by
        simpa [smul_eq_mul] using
          (rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
      have hrest :
          MellinConvergent
            (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s := by
        exact ih
      have hadd := hasMellin_add hca hrest
      simpa [Finset.sum_insert ha] using hadd.1

/-- Mellin transform of the finite rho combination. -/
theorem mellin_finiteRhoCombinationC
    (N : ℕ) (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (finiteRhoCombinationC N c) s =
      - riemannZeta s / s * residualDirichletPolynomial N c s := by
  classical
  unfold finiteRhoCombinationC residualDirichletPolynomial
  induction (Finset.univ : Finset (Fin N)) using Finset.induction_on with
  | empty =>
      simp [mellin]
  | @insert a S ha ih =>
      have hca :
          MellinConvergent
            (fun x : ℝ => (c a : ℂ) * rhoRepresentativeC a x) s := by
        simpa [smul_eq_mul] using
          (rhoRepresentativeC_mellinConvergent a s hs0 hs1).const_smul (c a : ℂ)
      have hrest :
          MellinConvergent
            (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s := by
        exact finiteRhoCombinationC_mellinConvergent
          S.card
          (fun j => c ⟨(S.orderIsoOfFin j).1, (S.orderIsoOfFin j).2⟩)
          s hs0 hs1
      rw [Finset.sum_insert ha, mellin_const_smul]
      rw [mellin_rho_realized a s hs0 hs1]
      rw [show
        mellin (fun x : ℝ => ∑ i ∈ S, (c i : ℂ) * rhoRepresentativeC i x) s =
          ∑ i ∈ S, (c i : ℂ) * mellin (rhoRepresentativeC i) s by
        induction S using Finset.induction_on with
        | empty => simp [mellin]
        | @insert j T hj hT =>
            have hjconv :=
              (rhoRepresentativeC_mellinConvergent j s hs0 hs1).const_smul (c j : ℂ)
            have hTconv :
                MellinConvergent
                  (fun x : ℝ => ∑ i ∈ T, (c i : ℂ) * rhoRepresentativeC i x) s := by
              unfold MellinConvergent at *
              exact Finset.integrableOn_sum T (fun i hi =>
                by simpa [smul_eq_mul] using
                  (rhoRepresentativeC_mellinConvergent i s hs0 hs1).const_smul (c i : ℂ))
            simpa [Finset.sum_insert hj, mellin_const_smul] using
              (hasMellin_add hjconv hTconv).2]
      simp_rw [mellin_rho_realized _ s hs0 hs1]
      ring

/-- The residual is Mellin-convergent on the open critical strip. -/
theorem residualRepresentativeC_mellinConvergent
    (N : ℕ) (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC N c) s := by
  unfold residualRepresentativeC
  exact (hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (finiteRhoCombinationC_mellinConvergent N c s hs0 hs1)).1

/-- D3 algebraic core: explicit Mellin transform of the residual. -/
theorem mellin_residualRepresentativeC
    (N : ℕ) (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC N c) s =
      (1 + riemannZeta s * residualDirichletPolynomial N c s) / s := by
  unfold residualRepresentativeC
  have hsub := hasMellin_sub
    (chiRepresentativeC_mellinConvergent s hs0 hs1)
    (finiteRhoCombinationC_mellinConvergent N c s hs0 hs1)
  rw [hsub.2]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_finiteRhoCombinationC N c s hs0 hs1]
  ring

#print axioms MCore.RH.R0.residualRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.mellin_residualRepresentativeC

end MCore.RH.R0
