import MCore.RH.Analytic.MellinCriticalLine
import MCore.RH.R0.LpToAE

namespace MCore.RH.R0

open MeasureTheory Set

/--
Bridge from the frozen Hilbert residual norm to the literal complex representative.
This is purely an L2/coercion statement; no Mellin analysis is hidden here.
-/
def ResidualRepresentativeNormBridge : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      ∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)

/--
Exact Mellin--Plancherel identity for the residual representative.
This is the only harmonic-analysis producer in D3.
-/
def ResidualMellinPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Ioi 0, Complex.normSq (residualRepresentativeC c x)) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (mellin (residualRepresentativeC c) (criticalLine t))

/-- Final explicit D3 target, with all zeta/Dirichlet algebra exposed. -/
def ExplicitResidualMellinPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    ‖concreteNBData.chi - concreteFiniteCombination c‖ ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          Complex.normSq
            (1 + riemannZeta (criticalLine t) *
              concreteDirichletPolynomial c (criticalLine t)) /
            ((1 / 4 : ℝ) + t ^ 2)

/-- D3 follows from exactly two structural bridges; the zeta algebra is already closed. -/
theorem explicitResidualMellinPlancherel_of_bridges
    (hL2 : ResidualRepresentativeNormBridge)
    (hMP : ResidualMellinPlancherel) :
    ExplicitResidualMellinPlancherel := by
  intro N c
  rw [hL2 c, hMP c]
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  exact normSq_mellin_residual_criticalLine c t

#print axioms MCore.RH.R0.explicitResidualMellinPlancherel_of_bridges

end MCore.RH.R0
