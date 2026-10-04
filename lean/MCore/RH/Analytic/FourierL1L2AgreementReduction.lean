import MCore.RH.Analytic.ResidualLogPullbackL1
import MCore.RH.Analytic.FourierAeBridgeReduction
import Mathlib.Analysis.Fourier.LpSpace

namespace MCore.RH.R0

open MeasureTheory Complex
open scoped FourierTransform

/--
Generic compatibility theorem missing from the current formal path:
for a function lying in L1∩L2, the pointwise Fourier integral agrees a.e.
with the Fourier transform obtained by L2 completion.

This is standard Fourier-analysis infrastructure; it contains no RH-specific statement.
-/
def L1L2FourierAgreement : Prop :=
  ∀ (f : ℝ → ℂ), Integrable f volume →
    ∀ (hf2 : MemLp f 2 volume),
      (fun ξ : ℝ => 𝓕 f ξ) =ᵐ[volume]
        ((𝓕 (hf2.toLp f)) : ℝ → ℂ)

/-- The generic L1∩L2 compatibility theorem realizes the sole residual-specific a.e. bridge. -/
theorem residualPointwiseFourierAeBridge_of_L1L2
    (h : L1L2FourierAgreement) :
    ResidualPointwiseFourierAeBridge where
  aeEq := fun c =>
    h (residualLogPullback c)
      (residualLogPullback_integrable c)
      (residualLogPullback_memLp c)

/-- Consequently the full D3 Plancherel producer follows from a generic Fourier theorem only. -/
theorem residualCriticalLinePlancherel_of_L1L2
    (h : L1L2FourierAgreement) :
    ResidualCriticalLinePlancherel :=
  residualCriticalLinePlancherel_of_aeBridge
    (residualPointwiseFourierAeBridge_of_L1L2 h)

/-- And therefore the fully explicit zeta/Dirichlet-polynomial D3 identity follows. -/
theorem residualMellinPlancherelExplicit_of_L1L2
    (h : L1L2FourierAgreement)
    {N : ℕ} (c : Fin N → ℝ) :
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          normSq
            (1 + riemannZeta (criticalLine t) *
              concreteDirichletPolynomial c (criticalLine t)) /
            ((1 / 4 : ℝ) + t ^ 2) := by
  exact residual_mellin_plancherel_explicit
    (residualCriticalLinePlancherel_of_L1L2 h) c

#print axioms MCore.RH.R0.residualPointwiseFourierAeBridge_of_L1L2
#print axioms MCore.RH.R0.residualCriticalLinePlancherel_of_L1L2
#print axioms MCore.RH.R0.residualMellinPlancherelExplicit_of_L1L2

end MCore.RH.R0
