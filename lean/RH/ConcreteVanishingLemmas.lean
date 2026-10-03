import MCore.RH.R0.ConcreteVanishingProducer
import MCore.RH.NB.LogMajorantFinalProducer

namespace RH

open Filter Topology
open MCore.RH.NB
open MCore.RH.NB.Final
open MCore.RH.R0

/-- Exact finite/infinite parameter subdomain for staged majorant work. -/
structure ParameterSubdomain where
  contains : Nat → Prop

/--
A vanishing upper bound proved only on a parameter subdomain.
This is useful for certified partial progress but does not promote RH.
-/
structure VanishingBoundOnSubdomain (S : ParameterSubdomain) where
  bound : Nat → Real
  nonnegative : ∀ N, 0 ≤ bound N
  dominates : ∀ N, S.contains N →
    concreteNBData.DN concreteGeneratorFamily N ≤ bound N
  vanishing : Tendsto bound atTop (nhds 0)

/--
If the subdomain is exhaustive, the partial bound becomes the exact RH
ConcreteVanishingUpperBound.
-/
def VanishingBoundOnSubdomain.toUniversal
    (S : ParameterSubdomain)
    (B : VanishingBoundOnSubdomain S)
    (covers : ∀ N, S.contains N) :
    ConcreteVanishingUpperBound :=
  {
    eps := B.bound
    eps_nonneg := B.nonnegative
    dn_le := fun N => B.dominates N (covers N)
    eps_tendsto_zero := B.vanishing
  }

/--
Specialized log-majorant research target.  All fields except the universal DN
inequality are already provided by the certified LogMajorant producer.
-/
structure ConcreteLogMajorantCertificate where
  K : Real
  hK : 0 ≤ K
  dn_le : ∀ N : Nat,
    concreteNBData.DN concreteGeneratorFamily N ≤
      logMajorant K N

noncomputable def ConcreteLogMajorantCertificate.toVanishingUpperBound
    (C : ConcreteLogMajorantCertificate) :
    ConcreteVanishingUpperBound :=
  vanishingUpperBound_of_logMajorant
    concreteNBData concreteGeneratorFamily
    {
      K := C.K
      hK := C.hK
      dn_le := C.dn_le
    }

#print axioms RH.VanishingBoundOnSubdomain.toUniversal
#print axioms RH.ConcreteLogMajorantCertificate.toVanishingUpperBound

end RH
