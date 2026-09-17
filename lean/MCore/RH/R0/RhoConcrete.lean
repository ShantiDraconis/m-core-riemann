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

/-- The zero index degenerates to the zero function under Lean's totalized
division.  It is therefore excluded from the mathematical NB generator family
later by an explicit positivity condition, rather than by a false MemLp claim. -/
@[simp] theorem rhoRepresentative_zero (x : BaseDomain) :
    rhoRepresentative 0 x = 0 := by
  simp [rhoRepresentative]

end MCore.RH.R0
