import MCore.RH.R0.GramExplicit
import MCore.RH.R0.DiscoveryCertificates

namespace MCore.RH.Experimental

open MCore.RH.R0

/-- Candidate arithmetic profile for comparing optimal coefficients. -/
structure CoefficientProfile where
  name : String
  value : ℕ → ℝ

/-- Pointwise discrepancy between the true optimal finite coefficient and a candidate profile. -/
noncomputable def coefficientProfileError
    (P : CoefficientProfile) (N : ℕ) (i : Fin N) : ℝ :=
  optimalGramCoeff N i - P.value (i.1 + 1)

/-- Aggregate squared discrepancy; experimental only. -/
noncomputable def coefficientProfileEnergy
    (P : CoefficientProfile) (N : ℕ) : ℝ :=
  ∑ i : Fin N, (coefficientProfileError P N i) ^ 2

/-- Möbius-over-n candidate, deliberately only a profile hypothesis. -/
noncomputable def mobiusOverNProfile : CoefficientProfile where
  name := "mobius_over_n"
  value := fun n => (ArithmeticFunction.moebius n : ℝ) / n

/-- Log-weighted Möbius family. -/
noncomputable def logWeightedMobiusProfile (A B : ℝ) : CoefficientProfile where
  name := "log_weighted_mobius"
  value := fun n =>
    ((ArithmeticFunction.moebius n : ℝ) / n) *
      (A + B * Real.log n)

/-- Experimental observable bundle. No theorem claims asymptotics. -/
structure GramObservables where
  N : ℕ
  determinant : ℝ
  residual : ℝ

noncomputable def gramObservables (N : ℕ) : GramObservables where
  N := N
  determinant := (concreteGramMatrix N).det
  residual :=
    1 - dotProduct (concreteTargetVector N)
      ((concreteGramMatrix N)⁻¹ *ᵥ concreteTargetVector N)

end MCore.RH.Experimental
