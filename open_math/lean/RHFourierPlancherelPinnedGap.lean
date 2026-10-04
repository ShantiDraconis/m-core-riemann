import MCore.RH.Analytic.FourierPlancherelPinnedGap
import MCore.RH.Analytic.CriticalLogPullbackL2
import MCore.RH.Analytic.FourierMellinCriticalLine
import Lean

open Lean Elab Tactic

namespace MCore.RH.R0

elab "library_gap " name:str : tactic => do
  let g ← getMainGoal
  let fmt ← g.withContext do ppGoal g
  let body := toString fmt
  logInfo m!"[RH-LIBRARY-GAP:{name.getString}]\n{body}"
  IO.FS.writeFile s!"/tmp/rh_library_gap_{name.getString}.txt" body

/--
Pinned-Mathlib-only obstruction.
No zeta function, RH proposition, Nyman--Beurling closure, Gram rate or zero statement occurs here.
-/
def PinnedLibraryFourierL2Gap : Prop :=
  PinnedFourierPlancherel

/-- The local L1 and L2 bookkeeping required for our critical pullback is already realized. -/
theorem criticalPullback_L1_ready : CriticalLogPullbackIntegrable :=
  criticalLogPullbackIntegrable_realized

theorem criticalPullback_L2_ready : CriticalLogPullbackMemL2 :=
  criticalLogPullbackMemL2_realized

/-- Once the standard pinned Fourier theorem exists, D3.2 is automatic. -/
theorem d3_fourierPlancherel_from_library
    (h : PinnedLibraryFourierL2Gap) :
    ∀ {N : ℕ} (c : Fin N → ℝ),
      (∫ u : ℝ, Complex.normSq (criticalLogPullback c u)) =
        ∫ ξ : ℝ, Complex.normSq (𝓕 (criticalLogPullback c) ξ) := by
  exact d3_fourierPlancherel_of_pinned
    h criticalLogPullbackIntegrable_realized criticalLogPullbackMemL2_realized

/--
Intentional RED: this is a standard Fourier theorem absent from the pinned library,
not an RH material producer.
-/
theorem DISCOVER_PINNED_FOURIER_PLANCHEREL :
    PinnedLibraryFourierL2Gap := by
  library_gap "PINNED_FOURIER_PLANCHEREL_L1_INTER_L2"
  exact ?_

end MCore.RH.R0
