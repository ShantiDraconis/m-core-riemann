import MCore.RH.Analytic.MellinTailRightReduction

namespace MCore.RH.R0

open Complex

/-- Finite partial sum of the complex tail blocks. -/
noncomputable def complexTailPartial (N : ℕ) (s : ℂ) : ℂ :=
  ∑ n ∈ Finset.range N, complexTailTerm (n + 1) s

/-- Exact telescoping formula for the first N blocks. -/
theorem complexTailPartial_formula
    (N : ℕ) (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    complexTailPartial N s =
      (((N + 1 : ℕ) : ℂ) ^ (1 - s) - 1) / (1 - s) +
      (1 / s) *
        (((N : ℕ) : ℂ) * (((N + 1 : ℕ) : ℂ) ^ (-s)) -
          ∑ n ∈ Finset.range N, 1 / (((n + 1 : ℕ) : ℂ) ^ s)) := by
  induction N with
  | zero =>
      simp [complexTailPartial]
  | succ N hN =>
      rw [complexTailPartial, Finset.sum_range_succ]
      change complexTailPartial N s + complexTailTerm (N + 1) s = _
      rw [hN, complexTailTerm_formula (N + 1) (by positivity) s hs0 hs1]
      rw [Finset.sum_range_succ]
      have hNp1 : (((N + 1 : ℕ) : ℂ) : ℂ) ≠ 0 := by
        exact_mod_cast Nat.succ_ne_zero N
      have hNp2 : (((N + 2 : ℕ) : ℂ) : ℂ) ≠ 0 := by
        exact_mod_cast Nat.succ_ne_zero (N + 1)
      rw [← cpow_neg hNp1, ← cpow_neg hNp2]
      field_simp [hs0, hs1, hNp1, hNp2]
      ring

#print axioms MCore.RH.R0.complexTailPartial_formula

end MCore.RH.R0
