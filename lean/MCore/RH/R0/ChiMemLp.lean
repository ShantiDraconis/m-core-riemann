import MCore.RH.R0.ChiL2

namespace MCore.RH.R0

open MeasureTheory

/-- The target representative is pointwise bounded by one. -/
theorem chiRepresentative_norm_le_one (x : BaseDomain) :
    ‖chiRepresentative x‖ ≤ 1 := by
  by_cases hx : 0 < x ∧ x < 1
  · simp [chiRepresentative, hx]
  · simp [chiRepresentative, hx]

/-- The concrete indicator is measurable.  We prove this directly as a
measurable piecewise function, avoiding dependence on an indicator-specific
API name. -/
theorem chiRepresentative_measurable : Measurable chiRepresentative := by
  have hset : MeasurableSet chiSupport := measurableSet_Ioo
  have hpw : Measurable (chiSupport.piecewise (fun _ : BaseDomain => (1 : ℝ)) (fun _ => 0)) :=
    hset.piecewise measurable_const measurable_const
  have heq : chiRepresentative = chiSupport.piecewise (fun _ : BaseDomain => (1 : ℝ)) (fun _ => 0) := by
    funext x
    by_cases hx : x ∈ chiSupport
    · have hcond : 0 < x ∧ x < 1 := hx
      simp [chiRepresentative, Set.piecewise, hx, hcond]
    · have hcond : ¬ (0 < x ∧ x < 1) := by
        simpa [chiSupport] using hx
      simp [chiRepresentative, Set.piecewise, hx, hcond]
  rw [heq]
  exact hpw

/-- R0.4 isolates the remaining quantitative square-integrability statement
without importing an integration API merely to name the proposition. -/
def ChiIntegrableSquare : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧ ∀ x : BaseDomain, ‖chiRepresentative x‖ ^ 2 ≤ C

end MCore.RH.R0
