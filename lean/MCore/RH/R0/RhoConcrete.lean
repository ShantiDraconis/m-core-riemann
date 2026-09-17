import MCore.RH.R0.ChiMemLp
import MCore.RH.NB.HilbertData
import Mathlib.Algebra.Order.Floor.Ring
import Mathlib.MeasureTheory.Function.L2Space
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals

namespace MCore.RH.R0

open MeasureTheory Set

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

/-- The frozen R0 exponent is definitionally the literal exponent two. -/
theorem twoExponent_eq_two : twoExponent = (2 : ENNReal) := by
  rfl

private theorem rhoRepresentative_measurable (n : ℕ) :
    Measurable (rhoRepresentative n) := by
  unfold rhoRepresentative rhoBase rhoIndex
  exact measurable_fract.comp
    (measurable_const.div (measurable_const.mul measurable_id))

private theorem rho_sq_integrableOn_Ioc (n : ℕ) :
    IntegrableOn (fun x : ℝ => (rhoRepresentative n x) ^ 2) (Ioc 0 1) volume := by
  have hmeas : AEStronglyMeasurable (fun x : ℝ => (rhoRepresentative n x) ^ 2)
      (volume.restrict (Ioc 0 1)) :=
    ((rhoRepresentative_measurable n).pow_const 2).aestronglyMeasurable
  have hone : IntegrableOn (fun _ : ℝ => (1 : ℝ)) (Ioc 0 1) volume := by
    rw [integrableOn_const]
    right
    simp
  refine Integrable.mono' hone hmeas ?_
  filter_upwards with x
  simp only [Real.norm_eq_abs]
  have h0 : 0 ≤ rhoRepresentative n x := Int.fract_nonneg _
  have h1 : rhoRepresentative n x < 1 := Int.fract_lt_one _
  rw [abs_of_nonneg (sq_nonneg _)]
  nlinarith

private theorem rho_tail_eq (n : ℕ) {x : ℝ} (hx : 1 < x) :
    rhoRepresentative n x = 1 / (((rhoIndex n : ℕ) : ℝ) * x) := by
  unfold rhoRepresentative rhoBase
  apply Int.fract_eq_self.2
  constructor
  · positivity
  · have ha : (1 : ℝ) ≤ ((rhoIndex n : ℕ) : ℝ) := by
      exact_mod_cast Nat.succ_le_iff.2 (rhoIndex_pos n)
    have hax : 1 < ((rhoIndex n : ℕ) : ℝ) * x := by
      nlinarith [show (0 : ℝ) < ((rhoIndex n : ℕ) : ℝ) by positivity]
    exact (one_div_lt_one hax).2 hax

private theorem rho_sq_integrableOn_Ioi (n : ℕ) :
    IntegrableOn (fun x : ℝ => (rhoRepresentative n x) ^ 2) (Ioi 1) volume := by
  have hrpow : IntegrableOn (fun x : ℝ => x ^ (-2 : ℝ)) (Ioi 1) volume := by
    exact integrableOn_Ioi_rpow_of_lt (by norm_num) (by norm_num)
  have hmeas : AEStronglyMeasurable (fun x : ℝ => (rhoRepresentative n x) ^ 2)
      (volume.restrict (Ioi 1)) :=
    ((rhoRepresentative_measurable n).pow_const 2).aestronglyMeasurable
  refine Integrable.mono' hrpow hmeas ?_
  filter_upwards with x hx
  have hx1 : 1 < x := hx
  have hx0 : 0 < x := lt_trans (by norm_num) hx1
  have ha : (1 : ℝ) ≤ ((rhoIndex n : ℕ) : ℝ) := by
    exact_mod_cast Nat.succ_le_iff.2 (rhoIndex_pos n)
  rw [rho_tail_eq n hx1]
  rw [Real.norm_eq_abs, abs_of_nonneg (sq_nonneg _)]
  have hden : 0 < ((rhoIndex n : ℕ) : ℝ) * x := by positivity
  have hfrac : 0 ≤ 1 / (((rhoIndex n : ℕ) : ℝ) * x) := le_of_lt (one_div_pos.mpr hden)
  have hle : 1 / (((rhoIndex n : ℕ) : ℝ) * x) ≤ 1 / x := by
    apply one_div_le_one_div_of_le hx0
    nlinarith
  have hsq : (1 / (((rhoIndex n : ℕ) : ℝ) * x)) ^ 2 ≤ (1 / x) ^ 2 := by
    nlinarith [one_div_pos.mpr hx0]
  have hrpow_eq : x ^ (-2 : ℝ) = (1 / x) ^ 2 := by
    rw [show (-2 : ℝ) = (-1 : ℝ) * 2 by norm_num, Real.rpow_mul hx0.le]
    simp [Real.rpow_neg_one, Real.rpow_natCast, one_div]
  rw [hrpow_eq]
  exact hsq

private theorem rho_sq_integrableOn_Ioi_zero (n : ℕ) :
    IntegrableOn (fun x : ℝ => (rhoRepresentative n x) ^ 2) (Ioi 0) volume := by
  have hnear := rho_sq_integrableOn_Ioc n
  have htail := rho_sq_integrableOn_Ioi n
  have hunion := hnear.union htail
  have hset : Ioc (0 : ℝ) 1 ∪ Ioi 1 = Ioi 0 := by
    ext x
    simp only [mem_union, mem_Ioc, mem_Ioi]
    constructor
    · rintro (⟨hx0, _⟩ | hx1)
      · exact hx0
      · linarith
    · intro hx0
      by_cases h : x ≤ 1
      · exact Or.inl ⟨hx0, h⟩
      · exact Or.inr (lt_of_not_ge h)
  rw [← hset]
  exact hunion

/-- The concrete Báez-Duarte generator belongs to L²((0,∞), dx). -/
theorem rho_memLp_two (n : ℕ) : RhoMemLpTwo n := by
  rw [RhoMemLpTwo, twoExponent_eq_two, memLp_two_iff_integrable_sq]
  · simpa [zeroInfinityMeasure, ambientMeasure, zeroInfinityDomain, IntegrableOn] using
      rho_sq_integrableOn_Ioi_zero n
  · exact (rhoRepresentative_measurable n).aestronglyMeasurable

noncomputable def rhoLp (n : ℕ) :
    Lp ℝ twoExponent zeroInfinityMeasure :=
  (rho_memLp_two n).toLp (rhoRepresentative n)

/-- Literal L² carrier. `Mathlib.MeasureTheory.Function.L2Space` provides its Hilbert instance. -/
noncomputable abbrev ConcreteH := Lp ℝ (2 : ENNReal) zeroInfinityMeasure

/-- Concrete NB Hilbert data on the exact L²(0,∞) carrier. -/
noncomputable def concreteNBData : MCore.RH.NB.NBHilbertData where
  H := ConcreteH
  instNormedAddCommGroup := inferInstance
  instInnerProductSpace := inferInstance
  instCompleteSpace := inferInstance
  chi := by
    simpa [ConcreteH, twoExponent] using chiLpConcrete

/-- Unconditional concrete generator family on the exact same L² carrier. -/
noncomputable def concreteGeneratorFamily : concreteNBData.GeneratorFamily :=
  fun n => by
    simpa [concreteNBData, ConcreteH, twoExponent] using rhoLp n

end MCore.RH.R0
