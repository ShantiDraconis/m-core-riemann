import MCore.RH.NB.ZeroLimitFrontier

namespace MCore.RH.NB
namespace NBHilbertData

variable (D : NBHilbertData)

/-- Single authoritative zero-defect material target. -/
def MinimalRiemannInhabitant (rho : D.GeneratorFamily) : Prop :=
  D.DNToZero rho

end NBHilbertData
end MCore.RH.NB
