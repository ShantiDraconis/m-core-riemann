import MCore.RH.R0.ChiMemLp
import Mathlib.MeasureTheory.Function.Floor

namespace MCore.RH.R0

open MeasureTheory

/-- Concrete Nyman--Beurling generator `rho_n(x) = fract(1/(n*x))`.
The natural-number parameter is kept explicit so that the later finite-span
identification cannot silently change the generator family. -/
noncomputable def rhoRepresentative (n : ℕ) (x : BaseDomain) : ℝ :=
  Int.fract (1 / ((n : ℝ) * x))

/-- Every concrete generator is measurable.  This is infrastructure only; L²
membership is proved separately so measurability cannot be confused with the
analytic tail estimate. -/
theorem rhoRepresentative_measurable (n : ℕ) : Measurable (rhoRepresentative n) := by
  unfold rhoRepresentative
  fun_prop

/-- Fractional-part nonnegativity gives the exact lower bound required by the
near-origin L² estimate. -/
theorem rhoRepresentative_nonneg (n : ℕ) (x : BaseDomain) :
    0 ≤ rhoRepresentative n x := by
  exact Int.fract_nonneg _

/-- Fractional parts are strictly below one.  Keeping the strict statement is
useful both for the bounded near-origin piece and for adversarial boundary tests. -/
theorem rhoRepresentative_lt_one (n : ℕ) (x : BaseDomain) :
    rhoRepresentative n x < 1 := by
  exact Int.fract_lt_one _

/-- Consequently every concrete generator has pointwise absolute value at most
one.  This closes the boundedness half of the near/tail L² split without making
any claim about the infinite-measure tail. -/
theorem abs_rhoRepresentative_le_one (n : ℕ) (x : BaseDomain) :
    |rhoRepresentative n x| ≤ 1 := by
  rw [abs_of_nonneg (rhoRepresentative_nonneg n x)]
  exact (rhoRepresentative_lt_one n x).le

/-- The zero index degenerates to the zero function under Lean's totalized
division.  It is therefore excluded from the mathematical NB generator family
later by an explicit positivity condition, rather than by a false MemLp claim. -/
@[simp] theorem rhoRepresentative_zero (x : BaseDomain) :
    rhoRepresentative 0 x = 0 := by
  simp [rhoRepresentative]

end MCore.RH.R0
