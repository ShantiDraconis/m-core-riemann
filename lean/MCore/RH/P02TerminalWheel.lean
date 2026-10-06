import MCore.RH.P02TerminalFreeze

namespace MCore

/-!
# RH terminal wheel / truncation theorem

No new parameter family is introduced. The only dynamical map is the already
frozen terminal reflection `criticalReflect`.

The wheel is the repeated application of that involution. Because the map is
involutive, the orbit has period dividing two. The smallest possible
truncation is equality of step one and step zero, and that equality is exactly
the fixed-point equation defining the terminal RH endpoint.
-/

def criticalWheel (n : ℕ) (s : ℂ) : ℂ :=
  Function.iterate criticalReflect n s

theorem criticalWheel_zero (s : ℂ) :
    criticalWheel 0 s = s := by
  rfl

theorem criticalWheel_one (s : ℂ) :
    criticalWheel 1 s = criticalReflect s := by
  rfl

theorem criticalWheel_two (s : ℂ) :
    criticalWheel 2 s = s := by
  simpa [criticalWheel, Function.iterate_succ_apply]
    using criticalReflect_involutive s

theorem criticalWheel_add_two (n : ℕ) (s : ℂ) :
    criticalWheel (n + 2) s = criticalWheel n s := by
  simp only [criticalWheel, Function.iterate_add_apply]
  rw [show Function.iterate criticalReflect 2 s = s by
    simpa [Function.iterate_succ_apply] using criticalReflect_involutive s]

/-- Minimal truncation: the first reflected state is already the initial state. -/
def CriticalWheelTruncatesAtLastBit (s : ℂ) : Prop :=
  criticalWheel 1 s = criticalWheel 0 s

theorem criticalWheel_truncates_iff_fixed (s : ℂ) :
    CriticalWheelTruncatesAtLastBit s ↔ criticalReflect s = s := by
  rfl

theorem criticalWheel_truncates_iff_critical_line (s : ℂ) :
    CriticalWheelTruncatesAtLastBit s ↔ s.re = (1 / 2 : ℝ) := by
  simpa [CriticalWheelTruncatesAtLastBit, criticalWheel]
    using criticalReflect_fixed_iff s

/--
The user's terminal truncation signature, restricted to nontrivial zeta zeros,
is definitionally the same endpoint as `CriticalOrbitCollapse`.
-/
def CriticalWheelTerminalClosure : Prop :=
  ∀ s : ℂ, ProbeNontrivialZetaZero s → CriticalWheelTruncatesAtLastBit s

theorem criticalWheelTerminalClosure_iff_orbitCollapse :
    CriticalWheelTerminalClosure ↔ CriticalOrbitCollapse := by
  constructor
  · intro h s hs
    exact (criticalWheel_truncates_iff_fixed s).mp (h s hs)
  · intro h s hs
    exact (criticalWheel_truncates_iff_fixed s).mpr (h s hs)

theorem criticalWheelTerminalClosure_implies_endpoint
    (h : CriticalWheelTerminalClosure) :
    ProbeCriticalLineStatement := by
  exact criticalOrbitCollapse_implies_probeCriticalLine
    ((criticalWheelTerminalClosure_iff_orbitCollapse).mp h)

end MCore
