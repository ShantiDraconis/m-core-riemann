import MCore.A14_Formal

namespace MCore.RH.NB

/-- Minimal NB-side observation used only to test whether the scalar A1--A4
signature determines any functional NB conclusion.  It deliberately contains
no RH statement and no zeta data. -/
structure NBObservation where
  coveringDecay : Prop
  testDefectDecay : Prop

/-- A1--A4 constrain only `MCoreSystem`.  An NB observation is extra data.
This predicate makes that separation explicit. -/
def CompatibleObservation (sys : MCoreSystem) (obs : NBObservation) : Prop :=
  A14Signature sys

/-- A concrete scalar system satisfying the exact current A1--A4 interface. -/
def witnessSystem : MCoreSystem where
  baseVal := 1
  amplitude := fun _ => 1
  scale := fun _ => 1
  zeroLimit := fun d =>
    match d with
    | .K0 => 0
    | .RHO => 1
    | .ETA => 2
  hasEdge := fun a b => (a = "G1" ∧ b = "G4") ∨ (a = "G4" ∧ b = "G1")
  phiObserved := fun _ => False

theorem witness_A1 : A1_prop witnessSystem := by
  constructor
  · norm_num [witnessSystem]
  · intro δ hδ
    refine ⟨1, by norm_num, ?_⟩
    simp [witnessSystem]
    linarith

theorem witness_A2 : A2_cycleDetected witnessSystem := by
  constructor <;> simp [witnessSystem]

theorem witness_A3 : A3_pathDependent witnessSystem := by
  refine ⟨ZeroDirection.K0, ZeroDirection.RHO, by decide, ?_⟩
  norm_num [witnessSystem]

theorem witness_A4 : A4_scaleInvariant witnessSystem := by
  intro λ hλ
  rfl

theorem witness_A14 : A14Signature witnessSystem := by
  exact ⟨witness_A1, witness_A2, witness_A3, witness_A4⟩

def goodObservation : NBObservation :=
  { coveringDecay := True, testDefectDecay := True }

def badObservation : NBObservation :=
  { coveringDecay := False, testDefectDecay := False }

/-- The current scalar A1--A4 signature is compatible with opposite NB-side
behaviour.  Therefore no NB decay theorem follows from A1--A4 *alone* unless
an additional compatibility law links the NB layer to `MCoreSystem`.

This is an interface non-implication result, not a refutation of RH and not a
refutation of a future strengthened M-Core. -/
theorem same_A14_opposite_NB_observations :
    CompatibleObservation witnessSystem goodObservation ∧
    CompatibleObservation witnessSystem badObservation ∧
    goodObservation.coveringDecay ∧
    ¬ badObservation.coveringDecay := by
  exact ⟨witness_A14, witness_A14, trivial, by simp [badObservation]⟩

/-- Fail-closed form: A1--A4 alone cannot prove that every compatible NB
observation has covering decay. -/
theorem A14_alone_not_sufficient_for_covering :
    ¬ (∀ obs : NBObservation,
        CompatibleObservation witnessSystem obs → obs.coveringDecay) := by
  intro h
  exact h badObservation witness_A14

/-- The same independence holds for the test-defect limit. -/
theorem A14_alone_not_sufficient_for_testDefect :
    ¬ (∀ obs : NBObservation,
        CompatibleObservation witnessSystem obs → obs.testDefectDecay) := by
  intro h
  exact h badObservation witness_A14

end MCore.RH.NB
