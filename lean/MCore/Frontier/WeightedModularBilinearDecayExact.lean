import Mathlib
import MCore.Frontier.MultistateSN

namespace MCore.RiemannMultistate

open Filter Topology

/-!
Producer-first semantic hardening of the frozen F1 inhabitant.

Dependency direction is strictly forward:
  concrete S_N
    -> explicit majorant eps_N
    -> eps_N -> 0
    -> |S_N| <= eps_N
    -> S_N -> 0

No theorem in this file permits a return edge to the source and no RH premise
is used to manufacture the decay certificate.
-/

structure WeightedModularBilinearDecayExact where
  SN : Nat → ℝ
  eps : Nat → ℝ
  eps_nonneg : ∀ N, 0 ≤ eps N
  bound : ∀ N, |SN N| ≤ eps N
  eps_tendsto_zero : Tendsto eps atTop (nhds 0)

theorem WeightedModularBilinearDecayExact.sn_tendsto_zero
    (D : WeightedModularBilinearDecayExact) :
    Tendsto D.SN atTop (nhds 0) := by
  rw [Metric.tendsto_atTop]
  intro ε hε
  have hEventually : ∀ᶠ N in atTop, D.eps N < ε := by
    have h := (Metric.tendsto_atTop.1 D.eps_tendsto_zero) ε hε
    filter_upwards [h] with N hN
    simpa [Real.dist_eq] using hN
  filter_upwards [hEventually] with N hN
  have hAbs : |D.SN N| < ε := lt_of_le_of_lt (D.bound N) hN
  simpa [Real.dist_eq] using hAbs

/-- Exact terminal F1 inhabitant: the canonical sequence itself tends to zero. -/
structure ExactTerminalGap where
  SN : Nat → ℝ
  decay : WeightedModularBilinearDecayExact
  same_sequence : decay.SN = SN

theorem ExactTerminalGap.vanishes
    (G : ExactTerminalGap) :
    Tendsto G.SN atTop (nhds 0) := by
  simpa [G.same_sequence] using G.decay.sn_tendsto_zero

#print axioms MCore.RiemannMultistate.WeightedModularBilinearDecayExact.sn_tendsto_zero
#print axioms MCore.RiemannMultistate.ExactTerminalGap.vanishes

end MCore.RiemannMultistate
