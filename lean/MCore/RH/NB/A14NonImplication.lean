import MCore.A14_Formal

namespace MCore.RH.NB

/-- Minimal NB-side observation used only to test whether the scalar A1--A4
signature determines any functional NB conclusion. It contains no RH statement,
no zeta data, and no Hilbert-space assumption. -/
structure NBObservation where
  coveringDecay : Prop
  testDefectDecay : Prop

/-- At the current interface level, compatibility depends only on A1--A4.
A future functional extension must strengthen this with an explicit NB law. -/
def CompatibleObservation (sys : MCoreSystem) (_obs : NBObservation) : Prop :=
  A14Signature sys

/-- Concrete scalar system satisfying the exact current A1--A4 interface. -/
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

/-- A1: baseVal is positive and A=1 works for every δ>0. -/
theorem witness_A1 : A1_prop witnessSystem := by
  constructor
  · norm_num [witnessSystem]
  · intro δ hδ
    refine ⟨1, by norm_num, ?_⟩
    simp [witnessSystem]
    linarith

/-- A2: both required directed edges are present. -/
theorem witness_A2 : A2_cycleDetected witnessSystem := by
  constructor <;> simp [witnessSystem]

/-- A3: K0 and RHO are distinct and have distinct zero-limit values. -/
theorem witness_A3 : A3_pathDependent witnessSystem := by
  refine ⟨ZeroDirection.K0, ZeroDirection.RHO, by decide, ?_⟩
  norm_num [witnessSystem]

/-- A4: the scale observable is exactly baseVal for every positive λ. -/
theorem witness_A4 : A4_scaleInvariant witnessSystem := by
  intro λ _hλ
  rfl

/-- Full exact scalar A1--A4 certificate. -/
theorem witness_A14 : A14Signature witnessSystem := by
  exact ⟨witness_A1, witness_A2, witness_A3, witness_A4⟩

/-- Extra NB datum where both candidate limits hold. -/
def goodObservation : NBObservation :=
  { coveringDecay := True, testDefectDecay := True }

/-- Extra NB datum where both candidate limits fail. -/
def badObservation : NBObservation :=
  { coveringDecay := False, testDefectDecay := False }

theorem good_is_compatible :
    CompatibleObservation witnessSystem goodObservation := by
  exact witness_A14

theorem bad_is_compatible :
    CompatibleObservation witnessSystem badObservation := by
  exact witness_A14

theorem good_covering : goodObservation.coveringDecay := by
  trivial

theorem good_testDefect : goodObservation.testDefectDecay := by
  trivial

theorem bad_not_covering : ¬ badObservation.coveringDecay := by
  simp [badObservation]

theorem bad_not_testDefect : ¬ badObservation.testDefectDecay := by
  simp [badObservation]

/-- Same scalar system, opposite NB behaviour on both candidate limits. -/
theorem same_A14_opposite_NB_observations :
    CompatibleObservation witnessSystem goodObservation ∧
    CompatibleObservation witnessSystem badObservation ∧
    goodObservation.coveringDecay ∧
    ¬ badObservation.coveringDecay ∧
    goodObservation.testDefectDecay ∧
    ¬ badObservation.testDefectDecay := by
  exact ⟨good_is_compatible, bad_is_compatible,
    good_covering, bad_not_covering,
    good_testDefect, bad_not_testDefect⟩

/-- Generic logical kernel: one compatible counterexample blocks a universal
conclusion from compatibility alone. -/
theorem compatible_counterexample_blocks_universal
    (P : NBObservation → Prop)
    (obs : NBObservation)
    (hcompat : CompatibleObservation witnessSystem obs)
    (hnot : ¬ P obs) :
    ¬ (∀ x : NBObservation, CompatibleObservation witnessSystem x → P x) := by
  intro hall
  exact hnot (hall obs hcompat)

/-- A1--A4 alone cannot force covering decay for every compatible NB datum. -/
theorem A14_alone_not_sufficient_for_covering :
    ¬ (∀ obs : NBObservation,
        CompatibleObservation witnessSystem obs → obs.coveringDecay) := by
  exact compatible_counterexample_blocks_universal
    (fun obs => obs.coveringDecay) badObservation bad_is_compatible bad_not_covering

/-- A1--A4 alone cannot force test-defect decay either. -/
theorem A14_alone_not_sufficient_for_testDefect :
    ¬ (∀ obs : NBObservation,
        CompatibleObservation witnessSystem obs → obs.testDefectDecay) := by
  exact compatible_counterexample_blocks_universal
    (fun obs => obs.testDefectDecay) badObservation bad_is_compatible bad_not_testDefect

/-- Strong joint form: A1--A4 alone cannot force both NB conclusions. -/
theorem A14_alone_not_sufficient_for_joint_decay :
    ¬ (∀ obs : NBObservation,
        CompatibleObservation witnessSystem obs →
          obs.coveringDecay ∧ obs.testDefectDecay) := by
  intro hall
  have h := hall badObservation bad_is_compatible
  exact bad_not_covering h.1

end MCore.RH.NB
