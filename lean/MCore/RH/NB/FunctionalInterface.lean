import MCore.RH.NB.A14NonImplication

namespace MCore.RH.NB

/-- A functional carrier is deliberately separate from the scalar `MCoreSystem`.
It is the extra structure that any future NB bridge must actually supply. -/
structure FunctionalCarrier where
  State : Type
  zero : State
  ampAction : ℝ → State → State
  scaleAction : ℝ → State → State
  testAt : ℕ → State
  defectAt : ℕ → ℝ
  coveringAt : ℕ → ℝ

/-- Compatibility is explicit rather than silently inferred from the scalar
fields.  The scalar observables are required to agree with designated
functional observations. -/
structure FunctionalCompatibility (sys : MCoreSystem) (F : FunctionalCarrier) : Prop where
  amplitudeWitness : ℝ → F.State
  scaleWitness : ℝ → F.State
  observe : F.State → ℝ
  amplitude_agrees : ∀ A, observe (F.ampAction A (amplitudeWitness A)) = sys.amplitude A
  scale_agrees : ∀ λ, observe (F.scaleAction λ (scaleWitness λ)) = sys.scale λ

/-- Decay properties are kept as mathematical obligations, not fields of the
scalar signature. -/
def CoveringDecay (F : FunctionalCarrier) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ N₀ : ℕ, ∀ N : ℕ, N₀ ≤ N → |F.coveringAt N| < ε

def TestDefectDecay (F : FunctionalCarrier) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ N₀ : ℕ, ∀ N : ℕ, N₀ ≤ N → |F.defectAt N| < ε

/-- A completely explicit compatible carrier with both errors identically zero.
This proves satisfiability of the interface only; it is not an NB/RH model. -/
def zeroCarrier (sys : MCoreSystem) : FunctionalCarrier where
  State := ℝ
  zero := 0
  ampAction := fun A _ => sys.amplitude A
  scaleAction := fun λ _ => sys.scale λ
  testAt := fun _ => 0
  defectAt := fun _ => 0
  coveringAt := fun _ => 0

def zeroCompatibility (sys : MCoreSystem) : FunctionalCompatibility sys (zeroCarrier sys) where
  amplitudeWitness := fun _ => 0
  scaleWitness := fun _ => 0
  observe := id
  amplitude_agrees := by intro A; rfl
  scale_agrees := by intro λ; rfl

theorem zeroCarrier_covering_decay (sys : MCoreSystem) : CoveringDecay (zeroCarrier sys) := by
  intro ε hε
  refine ⟨0, ?_⟩
  intro N hN
  simpa [zeroCarrier] using hε

theorem zeroCarrier_testDefect_decay (sys : MCoreSystem) : TestDefectDecay (zeroCarrier sys) := by
  intro ε hε
  refine ⟨0, ?_⟩
  intro N hN
  simpa [zeroCarrier] using hε

/-- The same scalar system also admits a compatible carrier whose errors are
identically one.  Thus merely adding actions plus observational compatibility
still does not force either NB decay gate. -/
def oneCarrier (sys : MCoreSystem) : FunctionalCarrier where
  State := ℝ
  zero := 0
  ampAction := fun A _ => sys.amplitude A
  scaleAction := fun λ _ => sys.scale λ
  testAt := fun _ => 0
  defectAt := fun _ => 1
  coveringAt := fun _ => 1

def oneCompatibility (sys : MCoreSystem) : FunctionalCompatibility sys (oneCarrier sys) where
  amplitudeWitness := fun _ => 0
  scaleWitness := fun _ => 0
  observe := id
  amplitude_agrees := by intro A; rfl
  scale_agrees := by intro λ; rfl

theorem oneCarrier_not_covering_decay (sys : MCoreSystem) : ¬ CoveringDecay (oneCarrier sys) := by
  intro h
  obtain ⟨N₀, hN₀⟩ := h (1 / 2 : ℝ) (by norm_num)
  have hlt := hN₀ N₀ (le_refl N₀)
  norm_num [oneCarrier] at hlt

theorem oneCarrier_not_testDefect_decay (sys : MCoreSystem) : ¬ TestDefectDecay (oneCarrier sys) := by
  intro h
  obtain ⟨N₀, hN₀⟩ := h (1 / 2 : ℝ) (by norm_num)
  have hlt := hN₀ N₀ (le_refl N₀)
  norm_num [oneCarrier] at hlt

/-- Even explicit action/observation compatibility is insufficient by itself.
A future useful extension must constrain the actual error quantities by a
functional law (coercivity/density/approximation), not merely reproduce the
scalar observables. -/
theorem compatibility_alone_not_sufficient_for_covering :
    ¬ (∀ F : FunctionalCarrier,
        FunctionalCompatibility witnessSystem F → CoveringDecay F) := by
  intro h
  exact oneCarrier_not_covering_decay witnessSystem
    (h (oneCarrier witnessSystem) (oneCompatibility witnessSystem))

theorem compatibility_alone_not_sufficient_for_testDefect :
    ¬ (∀ F : FunctionalCarrier,
        FunctionalCompatibility witnessSystem F → TestDefectDecay F) := by
  intro h
  exact oneCarrier_not_testDefect_decay witnessSystem
    (h (oneCarrier witnessSystem) (oneCompatibility witnessSystem))

end MCore.RH.NB
