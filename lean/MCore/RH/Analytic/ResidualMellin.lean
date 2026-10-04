import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

namespace MCore.RH.R0

open MeasureTheory Set Complex
open scoped BigOperators

/-- Complex finite generator combination. -/
noncomputable def rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) * rhoRepresentativeC i x

/-- Dirichlet polynomial attached to a finite coefficient vector. -/
noncomputable def dirichletPolynomialC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ) : ℂ :=
  ∑ i : Fin N, (c i : ℂ) *
    (((rhoIndex i : ℕ) : ℂ) ^ (-s))

/-- Mellin convergence of every finite concrete generator combination. -/
theorem rhoCombinationC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (rhoCombinationC c) s := by
  unfold MellinConvergent rhoCombinationC
  simp only [smul_eq_mul, mul_sum]
  apply integrable_finset_sum
  intro i hi
  have hconv := rhoRepresentativeC_mellinConvergent i s hs0 hs1
  unfold MellinConvergent at hconv
  simpa [mul_assoc, mul_left_comm, mul_comm] using
    hconv.const_mul (c i : ℂ)

/-- Mellin transform of a finite concrete generator combination. -/
theorem mellin_rhoCombinationC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (rhoCombinationC c) s =
      - riemannZeta s / s * dirichletPolynomialC c s := by
  unfold mellin rhoCombinationC
  simp only [smul_eq_mul, mul_sum]
  rw [integral_finset_sum]
  · calc
      (∑ i : Fin N,
          ∫ t : ℝ in Ioi 0,
            (t : ℂ) ^ (s - 1) * ((c i : ℂ) * rhoRepresentativeC i t))
          =
        ∑ i : Fin N,
          (c i : ℂ) * mellin (rhoRepresentativeC i) s := by
            apply Finset.sum_congr rfl
            intro i hi
            rw [← integral_const_mul]
            rfl
      _ = ∑ i : Fin N,
          (c i : ℂ) *
            (- (((rhoIndex i : ℕ) : ℂ) ^ (-s)) * riemannZeta s / s) := by
            apply Finset.sum_congr rfl
            intro i hi
            rw [mellin_rho_realized i s hs0 hs1]
      _ = - riemannZeta s / s * dirichletPolynomialC c s := by
            unfold dirichletPolynomialC
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro i hi
            ring
  · intro i hi
    have hconv := rhoRepresentativeC_mellinConvergent i s hs0 hs1
    unfold MellinConvergent at hconv
    simpa [mul_assoc, mul_left_comm, mul_comm] using
      hconv.const_mul (c i : ℂ)

/-- Complex residual representative chi - sum c_i rho_i. -/
noncomputable def residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (x : ℝ) : ℂ :=
  chiRepresentativeC x - rhoCombinationC c x

/-- The residual has convergent Mellin transform throughout the strip. -/
theorem residualRepresentativeC_mellinConvergent
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    MellinConvergent (residualRepresentativeC c) s := by
  unfold residualRepresentativeC
  exact (chiRepresentativeC_mellinConvergent s hs0).sub
    (rhoCombinationC_mellinConvergent c s hs0 hs1)

/-- D3 algebraic core: exact Mellin transform of the finite residual. -/
theorem mellin_residualRepresentativeC
    {N : ℕ} (c : Fin N → ℝ) (s : ℂ)
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    mellin (residualRepresentativeC c) s =
      (1 + riemannZeta s * dirichletPolynomialC c s) / s := by
  unfold residualRepresentativeC
  have hchi := chiRepresentativeC_mellinConvergent s hs0
  have hrho := rhoCombinationC_mellinConvergent c s hs0 hs1
  have hsub := hasMellin_sub hchi hrho
  rw [hsub.2]
  rw [mellin_chiRepresentativeC s hs0]
  rw [mellin_rhoCombinationC c s hs0 hs1]
  field_simp [ne_zero_of_re_pos hs0]
  ring

#print axioms MCore.RH.R0.rhoCombinationC_mellinConvergent
#print axioms MCore.RH.R0.mellin_rhoCombinationC
#print axioms MCore.RH.R0.residualRepresentativeC_mellinConvergent
#print axioms MCore.RH.R0.mellin_residualRepresentativeC

end MCore.RH.R0
