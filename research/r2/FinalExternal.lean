import MCore.RH.R2.BackwardDenseEndpoint

namespace MCore.RH.R2

structure FinalExternal where
  r1 : R1ExternalBridge
  vanishing : VanishingUpperCertificate

theorem FinalExternal.finalRoot (E : FinalExternal) : FinalStatement := by
  exact (vanishingUpperCertificate_iff_finalStatement_of_r1 E.r1).1 E.vanishing

def FINAL_EXTERNAL : Type := FinalExternal
def FINAL_ROOT (E : FINAL_EXTERNAL) : FinalStatement := E.finalRoot

#print axioms MCore.RH.R2.FinalExternal.finalRoot
end MCore.RH.R2
