import MCore.RH.R0.ChiL2

namespace MCore.RH.R0

open MeasureTheory

/-- The target representative is pointwise bounded by one. -/
theorem chiRepresentative_norm_le_one (x : BaseDomain) :
    ‖chiRepresentative x‖ ≤ 1 := by
  by_cases hx : 0 < x ∧ x < 1
  · simp [chiRepresentative, hx]
  · simp [chiRepresentative, hx]

/-- The concrete indicator is measurable. -/
theorem chiRepresentative_measurable : Measurable chiRepresentative := by
  have hset : MeasurableSet chiSupport := measurableSet_Ioo
  have hind : Measurable (chiSupport.indicator (fun _ : BaseDomain => (1 : ℝ))) :=
    hset.measurable_indicator measurable_const
  have heq : chiRepresentative = chiSupport.indicator (fun _ : BaseDomain => (1 : ℝ)) := by
    funext x
    by_cases hx : x ∈ chiSupport
    · simp [chiRepresentative, chiSupport, hx]
    · simp [chiRepresentative, chiSupport, hx]
  simpa [heq] using hind

/-- R0.4 isolates the remaining quantitative integrability statement.  This is
kept separate from measurability so a failed finite-measure API step cannot be
mistaken for a mathematical failure. -/
def ChiIntegrableSquare : Prop :=
  Integrable (fun x : BaseDomain => ‖chiRepresentative x‖ ^ 2) zeroInfinityMeasure

end MCore.RH.R0
