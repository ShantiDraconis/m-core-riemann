import MCore.RH.R0.VasyuninGCD
import Lean

namespace MCore.RH.R0

open Lean Elab Tactic
open MeasureTheory Set

elab "vasyunin_core_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-VASYUNIN-CORE:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_vasyunin_core_{name.getString}.txt" body

/--
For coprime h,k, the ratio h/k is already reduced and no gcd data remains.
-/
def V0_ReducedIndices : Prop :=
  ∀ h k : ℕ, 0 < h → 0 < k → Nat.Coprime h k →
    reducedNumerator h k = h ∧ reducedDenominator h k = k

/--
The autocorrelation at a positive rational is represented directly by
the two fractional-part factors used in Vasyunin's calculation.
-/
def V1_RationalAutocorrelation : Prop :=
  ∀ h k : ℕ, 0 < h → 0 < k →
    fractionalAutocorrelation ((h : ℝ) / (k : ℝ)) =
      ∫ t : ℝ in Ioi 0,
        (Int.fract (((h : ℝ) / (k : ℝ)) * t) * Int.fract t) / t ^ 2

/--
Split the rational autocorrelation into unit blocks. This is the first
countable-summation step in the classical calculation.
-/
def V2_UnitBlockExpansion : Prop :=
  ∀ h k : ℕ, 0 < h → 0 < k → Nat.Coprime h k →
    HasSum
      (fun n : ℕ =>
        ∫ t : ℝ in Ioc ((n : ℝ)) (n + 1),
          (Int.fract (((h : ℝ) / (k : ℝ)) * t) * Int.fract t) / t ^ 2)
      (fractionalAutocorrelation ((h : ℝ) / (k : ℝ)))

/--
Finite residue-class reduction modulo k. This is where rationality of h/k
turns the infinite piecewise-linear pattern into k residue classes.
-/
def V3_ResidueClassReduction : Prop :=
  ∀ h k : ℕ, 0 < h → 0 < k → Nat.Coprime h k →
    ∃ block : Fin k → ℝ,
      fractionalAutocorrelation ((h : ℝ) / (k : ℝ)) =
        ∑ r : Fin k, block r

/--
Analytic evaluation of the finite residue-class expression in terms of
logarithms, Euler's constant, and the two Vasyunin cotangent sums.
-/
def V4_CotangentEvaluation : Prop :=
  ∀ h k : ℕ, 0 < h → 0 < k → Nat.Coprime h k →
    explicitGramEntryNat h k =
      ((Real.log (2 * Real.pi) - Real.eulerMascheroniConstant) / 2) *
          (1 / (h : ℝ) + 1 / (k : ℝ))
        + ((h : ℝ) - (k : ℝ)) / (2 * (h : ℝ) * (k : ℝ)) *
            Real.log ((k : ℝ) / (h : ℝ))
        - Real.pi / (2 * (h : ℝ) * (k : ℝ)) *
            (vasyuninSum k h + vasyuninSum h k)

/-- V4 is exactly the coprime Vasyunin formula after simplification of gcd data. -/
theorem coprimeVasyuninFormula_of_cotangentEvaluation
    (hV4 : V4_CotangentEvaluation) :
    CoprimeVasyuninFormula := by
  intro h k hh hk hcop
  have hgcd : Nat.gcd h k = 1 := hcop.gcd_eq_one
  have hreducedN : reducedNumerator h k = h := by
    simp [reducedNumerator, hgcd]
  have hreducedD : reducedDenominator h k = k := by
    simp [reducedDenominator, hgcd]
  rw [hV4 h k hh hk hcop]
  unfold vasyuninGramEntry
  simp [hgcd, hreducedN, hreducedD]
  ring

theorem DISCOVER_V2_UNIT_BLOCKS : V2_UnitBlockExpansion := by
  unfold V2_UnitBlockExpansion
  vasyunin_core_gap "UNIT_BLOCK_EXPANSION"
  exact ?_

theorem DISCOVER_V3_RESIDUE_CLASSES : V3_ResidueClassReduction := by
  unfold V3_ResidueClassReduction
  vasyunin_core_gap "RESIDUE_CLASS_REDUCTION"
  exact ?_

theorem DISCOVER_V4_COTANGENT : V4_CotangentEvaluation := by
  unfold V4_CotangentEvaluation
  vasyunin_core_gap "COTANGENT_EVALUATION"
  exact ?_

#print axioms MCore.RH.R0.coprimeVasyuninFormula_of_cotangentEvaluation

end MCore.RH.R0
