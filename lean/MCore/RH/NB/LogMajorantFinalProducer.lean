import MCore.RH.NB.ExactFinalProducer

namespace MCore.RH.NB
namespace Final

def logMajorant (K : ℝ) (N : ℕ) : ℝ :=
  K / Real.log ((N : ℝ) + 2)

theorem logMajorant_nonneg
    (K : ℝ) (hK : 0 ≤ K) :
    ∀ N : ℕ, 0 ≤ logMajorant K N := by
  intro N
  unfold logMajorant
  have harg : 1 < (N : ℝ) + 2 := by
    exact_mod_cast (Nat.succ_lt_succ (Nat.zero_le N))
  have hlog : 0 < Real.log ((N : ℝ) + 2) :=
    Real.log_pos harg
  positivity

theorem logMajorant_tendsto_zero
    (K : ℝ) :
    Filter.Tendsto (logMajorant K) Filter.atTop (nhds 0) := by
  unfold logMajorant
  have harg :
      Filter.Tendsto (fun N : ℕ => (N : ℝ) + 2)
        Filter.atTop Filter.atTop :=
    tendsto_atTop_add_const_right _ _
      tendsto_natCast_atTop_atTop
  exact tendsto_const_nhds.div_atTop
    (Real.tendsto_log_atTop.comp harg)

structure LogMajorantCertificate
    (D : NBHilbertData)
    (rho : D.GeneratorFamily) where
  K : ℝ
  hK : 0 ≤ K
  dn_le :
    ∀ N : ℕ, D.DN rho N ≤ logMajorant K N

def vanishingUpperBound_of_logMajorant
    (D : NBHilbertData)
    (rho : D.GeneratorFamily)
    (h : LogMajorantCertificate D rho) :
    D.VanishingUpperBound rho :=
  {
    eps := logMajorant h.K
    eps_nonneg := logMajorant_nonneg h.K h.hK
    dn_le := h.dn_le
    eps_tendsto_zero := logMajorant_tendsto_zero h.K
  }

theorem FINAL_ROOT_of_logMajorant
    (D : NBHilbertData)
    (rho : D.GeneratorFamily)
    (h : LogMajorantCertificate D rho) :
    FINAL_ROOT D rho :=
  finalRoot_of_vanishingUpperBound D rho
    (vanishingUpperBound_of_logMajorant D rho h)

#print axioms MCore.RH.NB.Final.logMajorant_tendsto_zero
#print axioms MCore.RH.NB.Final.vanishingUpperBound_of_logMajorant
#print axioms MCore.RH.NB.Final.FINAL_ROOT_of_logMajorant

end Final
end MCore.RH.NB
