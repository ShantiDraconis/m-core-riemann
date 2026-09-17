import MCore.RH.R0.ChiMemLp
import MCore.RH.NB.HilbertData
import Mathlib.Algebra.Order.Floor.Ring

namespace MCore.RH.R0

open MeasureTheory

/-- Fractional-part function used in the strong Nyman--Beurling/Baez-Duarte family. -/
noncomputable def rhoBase (t : ℝ) : ℝ := Int.fract t

/-- Positive integer parameter corresponding to abstract index `n : ℕ`. -/
def rhoIndex (n : ℕ) : ℕ := n + 1

/-- Concrete Baez-Duarte generator representative: rho(1 / ((n+1)x)). -/
noncomputable def rhoRepresentative (n : ℕ) (x : BaseDomain) : ℝ :=
  rhoBase (1 / (((rhoIndex n : ℕ) : ℝ) * x))

@[simp] theorem rhoIndex_pos (n : ℕ) : 0 < rhoIndex n := by
  simp [rhoIndex]

@[simp] theorem rhoIndex_ne_zero (n : ℕ) : rhoIndex n ≠ 0 := by
  exact Nat.ne_of_gt (rhoIndex_pos n)

/-- The index shift is injective, so no positive-integer generator is duplicated. -/
theorem rhoIndex_injective : Function.Injective rhoIndex := by
  intro m n h
  simp [rhoIndex] at h
  exact h

/-- Explicit semantic statement of the abstract-to-classical index map. -/
theorem rhoRepresentative_index_formula (n : ℕ) (x : BaseDomain) :
    rhoRepresentative n x = Int.fract (1 / (((n + 1 : ℕ) : ℝ) * x)) := by
  rfl

/-- Analytic obligation for the fused gate.  This is a proposition, not an assumption. -/
def RhoMemLpTwo (n : ℕ) : Prop :=
  MemLp (rhoRepresentative n) twoExponent zeroInfinityMeasure

/-- Once the analytic obligation is proved, the concrete generator is an actual L² vector. -/
noncomputable def rhoLp (n : ℕ) (h : RhoMemLpTwo n) :
    Lp ℝ twoExponent zeroInfinityMeasure :=
  h.toLp (rhoRepresentative n)

/-- The concrete Hilbert carrier selected by R0. -/
abbrev ConcreteH := Lp ℝ twoExponent zeroInfinityMeasure

/-- Concrete NB Hilbert data.  This packages only already-proved chi and ambient structure. -/
noncomputable def concreteNBData : MCore.RH.NB.NBHilbertData where
  H := ConcreteH
  chi := chiLpConcrete

/-- If every concrete rho representative is in L², it induces exactly the abstract NB generator type. -/
noncomputable def concreteGeneratorFamily (h : ∀ n, RhoMemLpTwo n) :
    concreteNBData.GeneratorFamily :=
  fun n => rhoLp n (h n)

end MCore.RH.R0
