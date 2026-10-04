import MCore.RH.Analytic.MellinCriticalDensity
import MCore.RH.R0.ConcreteGramLogRate

namespace MCore.RH.R0

open MeasureTheory Complex

/--
The exact generic L2 Mellin-Plancherel statement needed by D3.
This is deliberately isolated from the zeta/Dirichlet algebra.
-/
def MellinPlancherelProducer : Prop :=
  ∀ f : ℝ → ℂ,
    MemLp f 2 zeroInfinityMeasure →
      (∫ x : ℝ in Set.Ioi 0, ‖f x‖ ^ 2) =
        (1 / (2 * Real.pi)) *
          ∫ t : ℝ, ‖mellin f (criticalLine t)‖ ^ 2

/--
Residual-level Plancherel target: once the generic producer exists,
the zeta/Dirichlet density is already explicit.
-/
def ResidualMellinPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    MemLp (residualRepresentativeC c) 2 zeroInfinityMeasure →
      (∫ x : ℝ in Set.Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
        (1 / (2 * Real.pi)) *
          ∫ t : ℝ, criticalResidualDensity c t

theorem residualMellinPlancherel_of_generic
    (h : MellinPlancherelProducer) :
    ResidualMellinPlancherel := by
  intro N c hmem
  rw [h (residualRepresentativeC c) hmem]
  apply congrArg (fun z : ℝ => (1 / (2 * Real.pi)) * z)
  apply integral_congr_ae
  filter_upwards with t
  exact residual_mellin_critical_sq c t

/--
D3 is now reduced to exactly one analytic producer.
-/
theorem d3_reduced_to_mellin_plancherel :
    MellinPlancherelProducer → ResidualMellinPlancherel :=
  residualMellinPlancherel_of_generic

#print axioms MCore.RH.R0.residualMellinPlancherel_of_generic
#print axioms MCore.RH.R0.d3_reduced_to_mellin_plancherel

end MCore.RH.R0
