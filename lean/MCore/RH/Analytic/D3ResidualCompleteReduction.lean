import MCore.RH.Analytic.ResidualCriticalL1

namespace MCore.RH.R0

open MeasureTheory Set Complex

/--
D3 with all residual-specific analytic side conditions discharged.
The only remaining operator input is classical Fourier Plancherel.
-/
theorem residual_mellin_plancherel_of_fourier
    (hFourier : FourierIntegralPlancherel)
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ x : ℝ in Ioi 0, ‖complexResidual c x‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta ((1 / 2 : ℝ) + t * I) *
              concreteDirichletPolynomial c ((1 / 2 : ℝ) + t * I)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  exact residual_mellin_plancherel_integral
    hFourier c
    (criticalLogTransport_complexResidual_integrable c)
    (criticalLogTransport_complexResidual_memLp_two c)

/-- D3 has no remaining zeta-specific or residual-specific open side condition. -/
def D3OperatorGap : Prop := FourierIntegralPlancherel

theorem d3_reduced_to_fourier_plancherel :
    D3OperatorGap →
    ∀ {N : ℕ} (c : Fin N → ℝ),
      (∫ x : ℝ in Ioi 0, ‖complexResidual c x‖ ^ 2) =
        (1 / (2 * Real.pi)) *
          ∫ t : ℝ,
            Complex.normSq
              (1 + riemannZeta ((1 / 2 : ℝ) + t * I) *
                concreteDirichletPolynomial c ((1 / 2 : ℝ) + t * I)) /
              ((1 / 4 : ℝ) + t ^ 2) := by
  intro h N c
  exact residual_mellin_plancherel_of_fourier h c

#print axioms MCore.RH.R0.residual_mellin_plancherel_of_fourier
#print axioms MCore.RH.R0.d3_reduced_to_fourier_plancherel

end MCore.RH.R0
