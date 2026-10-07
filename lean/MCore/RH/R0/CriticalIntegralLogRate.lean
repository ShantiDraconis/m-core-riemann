import MCore.RH.Analytic.MellinPlancherelReduction
import MCore.RH.R0.HardFrontier

namespace MCore.RH.R0

open MCore.RH.NB
open MCore.RH.NB.Final
open MeasureTheory Complex

/--
Material critical-line certificate for the RH lane.

This is deliberately producer-first: it contains an explicit finite coefficient
family and the single quantitative estimate on its critical-line Mellin error.
No RH assumption, zero-location assumption, or finite-N extrapolation is built
into the structure.
-/
structure CriticalIntegralLogRate where
  K : ℝ
  hK : 0 ≤ K
  coeff : (N : ℕ) → Fin N → ℝ
  critical_integral_le :
    ∀ N : ℕ,
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLinePoint t) *
              concreteDirichletPolynomial (coeff N) (criticalLinePoint t)) /
            ((1 / 4 : ℝ) + t ^ 2)
      ≤ logMajorant K N

/--
The critical integral estimate is exactly an L2 coefficient error estimate
once the already-isolated Mellin--Plancherel bridge is available.
-/
theorem CriticalIntegralLogRate.error_sq_le
    (hP : CriticalLineMellinPlancherel)
    (h : CriticalIntegralLogRate)
    (N : ℕ) :
    ‖concreteNBData.chi -
      concreteNBData.coefficientApproximantAt
        concreteGeneratorFamily N (h.coeff N)‖ ^ 2
      ≤ logMajorant h.K N := by
  change ‖concreteResidual (h.coeff N)‖ ^ 2 ≤ logMajorant h.K N
  rw [residual_mellin_plancherel_explicit hP (h.coeff N)]
  exact h.critical_integral_le N

/-- A material critical-line integral certificate produces the canonical hard frontier. -/
theorem CriticalIntegralLogRate.toUniformLogDNBound
    (hP : CriticalLineMellinPlancherel)
    (h : CriticalIntegralLogRate) :
    ConcreteUniformLogDNBound := by
  refine ⟨h.K, h.hK, ?_⟩
  intro N
  exact le_trans
    (concreteNBData.DN_le_coefficient_error_sq
      concreteGeneratorFamily N (h.coeff N))
    (h.error_sq_le hP N)

/-- Terminal composition: no additional mathematical field after the critical integral bound. -/
theorem terminal_of_criticalIntegralLogRate
    (hP : CriticalLineMellinPlancherel)
    (h : CriticalIntegralLogRate) :
    RiemannTerminalCertifies :=
  terminal_of_concreteUniformLogDNBound (h.toUniformLogDNBound hP)

#print axioms MCore.RH.R0.CriticalIntegralLogRate.error_sq_le
#print axioms MCore.RH.R0.CriticalIntegralLogRate.toUniformLogDNBound
#print axioms MCore.RH.R0.terminal_of_criticalIntegralLogRate

end MCore.RH.R0
