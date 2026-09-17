import MCore.RH.R0.ChiL2

namespace MCore.RH.R0

open MeasureTheory

/-- The target representative is pointwise bounded by one. -/
theorem chiRepresentative_norm_le_one (x : BaseDomain) :
    ‖chiRepresentative x‖ ≤ 1 := by
  by_cases hx : 0 < x ∧ x < 1
  · simp [chiRepresentative, hx]
  · simp [chiRepresentative, hx]

/-- The concrete target representative is measurable. -/
theorem chiRepresentative_measurable : Measurable chiRepresentative := by
  unfold chiRepresentative
  apply Measurable.ite
  · exact measurableSet_Ioi.and measurableSet_Iio
  · exact measurable_const
  · exact measurable_const

/-- A reusable quantitative bound for the square of the target. -/
theorem chiRepresentative_square_le_one (x : BaseDomain) :
    ‖chiRepresentative x‖ ^ 2 ≤ 1 := by
  have h := chiRepresentative_norm_le_one x
  nlinarith [norm_nonneg (chiRepresentative x)]

/-- R0.4's elementary quantitative obligation is closed explicitly. -/
def ChiIntegrableSquare : Prop :=
  ∃ C : ℝ, 0 ≤ C ∧ ∀ x : BaseDomain, ‖chiRepresentative x‖ ^ 2 ≤ C

theorem chiIntegrableSquare_bound : ChiIntegrableSquare := by
  refine ⟨1, by norm_num, ?_⟩
  exact chiRepresentative_square_le_one

end MCore.RH.R0
