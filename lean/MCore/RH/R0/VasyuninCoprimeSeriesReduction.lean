import MCore.RH.R0.VasyuninResidueClasses
import MCore.RH.R0.VasyuninFormulaReduction

namespace MCore.RH.R0

open scoped BigOperators

/-- The exact coprime closed form appearing in Vasyunin's formula. -/
noncomputable def vasyuninCoprimeClosedForm (h k : ℕ) : ℝ :=
  ((Real.log (2 * Real.pi) - Real.eulerMascheroniConstant) / 2) *
      (1 / (h : ℝ) + 1 / (k : ℝ))
    + ((h : ℝ) - (k : ℝ)) / (2 * (h : ℝ) * (k : ℝ)) *
        Real.log ((k : ℝ) / (h : ℝ))
    - Real.pi / (2 * (h : ℝ) * (k : ℝ)) *
        (vasyuninSum k h + vasyuninSum h k)

/--
After V0--V3, the explicit Gram entry contains no integral: it is a finite
prefactor times an absolutely convergent residue-class series.
-/
theorem explicitGramEntryNat_eq_residue_tsum
    (h k : ℕ) (hh : 0 < h) (hk : 0 < k) :
    explicitGramEntryNat h k =
      (1 / (h : ℝ)) *
        (∑ r : ZMod k, ∑' q : ℕ,
          vasyuninUnitBlockCore h k (r.val + k * q)) := by
  unfold explicitGramEntryNat
  rw [fractionalAutocorrelation_eq_sum_residue_classes h k hh hk]

/--
The remaining coprime Vasyunin bridge with all measure-theoretic structure removed.
This is now a pure absolutely-convergent-series/cotangent identity.
-/
def VasyuninResidueTsumEvaluation : Prop :=
  ∀ h k : ℕ, 0 < h → 0 < k → Nat.Coprime h k →
    (1 / (h : ℝ)) *
        (∑ r : ZMod k, ∑' q : ℕ,
          vasyuninUnitBlockCore h k (r.val + k * q)) =
      vasyuninCoprimeClosedForm h k

/-- The residue-series evaluation implies the exact coprime Vasyunin formula. -/
theorem coprimeVasyuninFormula_of_residueTsum
    (hseries : VasyuninResidueTsumEvaluation) :
    CoprimeVasyuninFormula := by
  intro h k hh hk hcop
  rw [explicitGramEntryNat_eq_residue_tsum h k hh hk]
  rw [hseries h k hh hk hcop]
  unfold vasyuninCoprimeClosedForm
  have hgcd : Nat.gcd h k = 1 := hcop.gcd_eq_one
  unfold vasyuninGramEntry reducedNumerator reducedDenominator
  simp [hgcd]
  ring

/-- Conversely, the classical coprime formula determines the residue-series sum. -/
theorem residueTsum_of_coprimeVasyuninFormula
    (hcop : CoprimeVasyuninFormula) :
    VasyuninResidueTsumEvaluation := by
  intro h k hh hk hcoprime
  rw [← explicitGramEntryNat_eq_residue_tsum h k hh hk]
  rw [hcop h k hh hk hcoprime]
  unfold vasyuninCoprimeClosedForm vasyuninGramEntry
  have hgcd : Nat.gcd h k = 1 := hcoprime.gcd_eq_one
  simp [reducedNumerator, reducedDenominator, hgcd]
  ring

theorem residueTsumEvaluation_iff_coprimeVasyuninFormula :
    VasyuninResidueTsumEvaluation ↔ CoprimeVasyuninFormula := by
  constructor
  · exact coprimeVasyuninFormula_of_residueTsum
  · exact residueTsum_of_coprimeVasyuninFormula

#print axioms MCore.RH.R0.explicitGramEntryNat_eq_residue_tsum
#print axioms MCore.RH.R0.coprimeVasyuninFormula_of_residueTsum
#print axioms MCore.RH.R0.residueTsumEvaluation_iff_coprimeVasyuninFormula

end MCore.RH.R0
