import MCore.RH.R0.GramIntegral
import Mathlib.NumberTheory.Harmonic.EulerMascheroni

namespace MCore.RH.R0

open MeasureTheory Set

/-- Universal fractional-part tail constant appearing in every target entry. -/
noncomputable def fractionalTailConstant : ℝ :=
  ∫ t : ℝ in Ioi 1, Int.fract t / (t ^ 2)

/-- The exact universal identity needed to introduce Euler--Mascheroni. -/
def FractionalTailEulerIdentity : Prop :=
  fractionalTailConstant = 1 - Real.eulerMascheroniConstant

/--
After x -> 1/(a t), every target entry has the same universal tail.
This is the exact change-of-variable statement C4 needs.
-/
def TargetEntryTransform : Prop :=
  ∀ (N : ℕ) (i : Fin N),
    let a : ℝ := ((rhoIndex i : ℕ) : ℝ)
    concreteTargetVector N i =
      Real.log a / a + fractionalTailConstant / a

/-- C4 follows mechanically from the transform plus the universal tail identity. -/
theorem target_closed_form_of_transform_tail
    (htransform : TargetEntryTransform)
    (htail : FractionalTailEulerIdentity)
    (N : ℕ) (i : Fin N) :
    concreteTargetVector N i =
      (Real.log ((rhoIndex i : ℕ) : ℝ) + 1 -
        Real.eulerMascheroniConstant) /
      (((rhoIndex i : ℕ) : ℝ)) := by
  have ha : (0 : ℝ) < ((rhoIndex i : ℕ) : ℝ) := by
    exact_mod_cast rhoIndex_pos i
  have h := htransform N i
  dsimp at h
  rw [htail] at h
  rw [h]
  field_simp
  ring

/-- The interval (1/a,1) contributes exactly log(a)/a once fract(t)=t there. -/
def TargetElementaryIntervalIdentity : Prop :=
  ∀ a : ℝ, 1 ≤ a →
    (1 / a) *
      (∫ t : ℝ in Ioc (1 / a) 1, Int.fract t / (t ^ 2)) =
      Real.log a / a

#print axioms MCore.RH.R0.target_closed_form_of_transform_tail

end MCore.RH.R0
