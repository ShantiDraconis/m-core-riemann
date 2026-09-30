import MCore.RH.R0.RhoConcrete
import Mathlib.MeasureTheory.Function.LpSpace.Indicator

namespace MCore.RH.R0

open MeasureTheory Set

/-- The support of chi has measure one in the selected L2(0,infinity) measure. -/
theorem zeroInfinityMeasure_chiSupport :
    zeroInfinityMeasure chiSupport = 1 := by
  unfold zeroInfinityMeasure
  rw [Measure.restrict_apply measurableSet_Ioo]
  have hset : chiSupport ∩ zeroInfinityDomain = chiSupport := by
    ext x
    simp [chiSupport, zeroInfinityDomain]
  rw [hset]
  simp [ambientMeasure, chiSupport]

/-- The distinguished concrete Nyman--Beurling target has L2 norm exactly one. -/
theorem chiLpConcrete_norm :
    ‖chiLpConcrete‖ = 1 := by
  unfold chiLpConcrete chiLp
  rw [Lp.norm_toLp]
  rw [chiRepresentative_eq_indicator]
  rw [eLpNorm_indicator_const measurableSet_Ioo]
  simp [twoExponent, zeroInfinityMeasure_chiSupport]

/-- Squared normalization used by the finite Gram energy. -/
theorem chiLpConcrete_norm_sq :
    ‖chiLpConcrete‖ ^ 2 = 1 := by
  rw [chiLpConcrete_norm]
  norm_num

/-- The same normalization through the concrete NB data field. -/
theorem concreteNBData_chi_norm :
    ‖concreteNBData.chi‖ = 1 := by
  simpa [concreteNBData, ConcreteH, twoExponent] using chiLpConcrete_norm

theorem concreteNBData_chi_norm_sq :
    ‖concreteNBData.chi‖ ^ 2 = 1 := by
  rw [concreteNBData_chi_norm]
  norm_num

#print axioms zeroInfinityMeasure_chiSupport
#print axioms chiLpConcrete_norm
#print axioms concreteNBData_chi_norm
#print axioms concreteNBData_chi_norm_sq

end MCore.RH.R0
