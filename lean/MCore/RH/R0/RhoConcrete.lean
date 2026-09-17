import MCore.RH.R0.ChiMemLp
import MCore.RH.NB.HilbertData
import Mathlib.Algebra.Order.Floor.Ring

namespace MCore.RH.R0

open MeasureTheory

noncomputable def rhoBase (t : ℝ) : ℝ := Int.fract t

def rhoIndex (n : ℕ) : ℕ := n + 1

noncomputable def rhoRepresentative (n : ℕ) (x : BaseDomain) : ℝ :=
  rhoBase (1 / (((rhoIndex n : ℕ) : ℝ) * x))

@[simp] theorem rhoIndex_pos (n : ℕ) : 0 < rhoIndex n := by
  simp [rhoIndex]

@[simp] theorem rhoIndex_ne_zero (n : ℕ) : rhoIndex n ≠ 0 := by
  exact Nat.ne_of_gt (rhoIndex_pos n)

theorem rhoIndex_injective : Function.Injective rhoIndex := by
  intro m n h
  simp [rhoIndex] at h
  exact h

theorem rhoRepresentative_index_formula (n : ℕ) (x : BaseDomain) :
    rhoRepresentative n x = Int.fract (1 / (((n + 1 : ℕ) : ℝ) * x)) := by
  rfl

def RhoMemLpTwo (n : ℕ) : Prop :=
  MemLp (rhoRepresentative n) twoExponent zeroInfinityMeasure

noncomputable def rhoLp (n : ℕ) (h : RhoMemLpTwo n) :
    Lp ℝ twoExponent zeroInfinityMeasure :=
  h.toLp (rhoRepresentative n)

/-- Expose the literal exponent `2` so Mathlib can synthesize the Hilbert-space instances. -/
abbrev ConcreteH := Lp ℝ (2 : ENNReal) zeroInfinityMeasure

/-- The frozen R0 exponent is definitionally the literal exponent two. -/
theorem twoExponent_eq_two : twoExponent = (2 : ENNReal) := by
  rfl

noncomputable def concreteNBData : MCore.RH.NB.NBHilbertData where
  H := ConcreteH
  instNormedAddCommGroup := inferInstance
  instInnerProductSpace := inferInstance
  instCompleteSpace := inferInstance
  chi := by
    simpa [ConcreteH, twoExponent] using chiLpConcrete

noncomputable def concreteGeneratorFamily (h : ∀ n, RhoMemLpTwo n) :
    concreteNBData.GeneratorFamily :=
  fun n => by
    simpa [concreteNBData, ConcreteH, twoExponent] using rhoLp n (h n)

end MCore.RH.R0
