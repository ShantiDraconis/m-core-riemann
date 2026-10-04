import MCore.RH.R0.VasyuninIntegrability
import Mathlib.Analysis.SumOverResidueClass

namespace MCore.RH.R0

open MeasureTheory Set
open scoped BigOperators

/-- Unit-block integral appearing in the rational autocorrelation expansion. -/
noncomputable def vasyuninUnitBlockCore (h k n : ℕ) : ℝ :=
  ∫ t : ℝ in Ioc (n : ℝ) (n + 1),
    rationalAutocorrelationIntegrand h k t

/-- Absolute summability is available because the unit-block series has a genuine HasSum. -/
theorem vasyuninUnitBlockCore_summable
    (h k : ℕ) (hh : 0 < h) (hk : 0 < k) :
    Summable (fun n : ℕ => vasyuninUnitBlockCore h k n) := by
  exact (by
    simpa [vasyuninUnitBlockCore] using
      (rationalAutocorrelation_unitBlock_hasSum
        rationalAutocorrelationIntegrable_realized h k hh hk)).summable

/--
Exact residue-class regrouping n = r + k*q.
This is the genuine V3 statement; no arbitrary existential block values occur.
-/
theorem fractionalAutocorrelation_eq_sum_residue_classes
    (h k : ℕ) (hh : 0 < h) (hk : 0 < k) :
    fractionalAutocorrelation ((h : ℝ) / (k : ℝ)) =
      ∑ r : ZMod k, ∑' q : ℕ,
        vasyuninUnitBlockCore h k (r.val + k * q) := by
  letI : NeZero k := ⟨hk.ne'⟩
  have hsum :
      HasSum (fun n : ℕ => vasyuninUnitBlockCore h k n)
        (fractionalAutocorrelation ((h : ℝ) / (k : ℝ))) := by
    simpa [vasyuninUnitBlockCore] using
      (rationalAutocorrelation_unitBlock_hasSum
        rationalAutocorrelationIntegrable_realized h k hh hk)
  calc
    fractionalAutocorrelation ((h : ℝ) / (k : ℝ))
        = ∑' n : ℕ, vasyuninUnitBlockCore h k n := hsum.tsum_eq.symm
    _ = ∑ r : ZMod k, ∑' q : ℕ,
          vasyuninUnitBlockCore h k (r.val + k * q) := by
        exact Nat.sumByResidueClasses
          (vasyuninUnitBlockCore_summable h k hh hk) k

#print axioms MCore.RH.R0.vasyuninUnitBlockCore_summable
#print axioms MCore.RH.R0.fractionalAutocorrelation_eq_sum_residue_classes

end MCore.RH.R0
