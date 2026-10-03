import MCore.RH.R0.RHKernelEntry
import MCore.RH.R0.ConcreteVanishingProducer

namespace MCore.RH.R0.OpenMath

/--
RH terminal OPEN_MATH.
An inhabitant must provide an explicit nonnegative majorant for concrete DN,
dominate DN pointwise, and tend to zero.
No inhabitant is asserted here.
-/
abbrev RH_GAP : Type :=
  MCore.RH.R0.ConcreteVanishingUpperBound

#check MCore.RH.R0.concreteVanishingUpperBound_iff_exists_majorant
#check MCore.RH.R0.rh_kernel_entry_FINAL_ROOT
#check MCore.RH.R0.rh_kernel_entry_Terminal

end MCore.RH.R0.OpenMath
