import MCore.RH.R0.RhoConcrete
import Mathlib.MeasureTheory.Function.LpSpace.Indicator

/-!
Exact norm of the concrete Nyman--Beurling target.

The target is the indicator of (0,1) in L²((0,∞), dx), hence has norm one.
No new assumption or axiom is introduced.
-/

namespace MCore.RH.R0

open MeasureTheory Set

theorem chiLpConcrete_eq_indicatorConstLp :
    chiLpConcrete =
      indicatorConstLp twoExponent measurableSet_Ioo chiSupport_measure_ne_top (1 : ℝ) := by
  unfold chiLpConcrete chiLp
  rw [chiRepresentative_eq_indicator]
  rfl

/-- The concrete target has exact L² norm one. -/
theorem concreteNBData_chi_norm :
    ‖concreteNBData.chi‖ = 1 := by
  change ‖chiLpConcrete‖ = 1
  rw [chiLpConcrete_eq_indicatorConstLp]
  rw [norm_indicatorConstLp]
  · simp [twoExponent, zeroInfinityMeasure, ambientMeasure, chiSupport,
      zeroInfinityDomain, Measure.restrict_apply]
  · norm_num [twoExponent]
  · norm_num [twoExponent]

#print axioms MCore.RH.R0.chiLpConcrete_eq_indicatorConstLp
#print axioms MCore.RH.R0.concreteNBData_chi_norm

end MCore.RH.R0
