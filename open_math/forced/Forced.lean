import MCore.RH.R0.HardFrontierReduction
import MCore.RH.R0.ConcreteGramLogRate

namespace MCore.RH.Forced

open MCore.RH.NB
open MCore.RH.R0

/-!
FORCED EXPERIMENT — NOT A CERTIFICATE.

This file is outside the certified MCore source tree.
It explores the consequences of a local hypothesis
`hForced : ConcreteUniformLogDNBound`.
Nothing here is imported by MCore or eligible for terminal promotion.
-/

section ForcedWorld

variable (hForced : ConcreteUniformLogDNBound)

noncomputable def forcedGramRate : ConcreteGramLogRate :=
  Classical.choice
    (concreteGramLogRate_iff_uniformLogDNBound.mpr hForced)

theorem forced_hard_frontier : HardFrontierTarget := by
  exact hard_frontier_of_ConcreteGramLogRate (forcedGramRate hForced)

theorem forced_terminal : RiemannTerminalCertifies := by
  exact terminal_of_concreteUniformLogDNBound hForced

#check forcedGramRate
#check forced_hard_frontier
#check forced_terminal

end ForcedWorld

end MCore.RH.Forced
