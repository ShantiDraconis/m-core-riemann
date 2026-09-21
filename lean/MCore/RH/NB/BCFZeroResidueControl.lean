import MCore.RH.NB.QuantitativeUpperBound

namespace MCore.RH.NB
namespace NBHilbertData

variable (D : NBHilbertData)

structure BCFZeroResidueControl (rho : D.GeneratorFamily) where
  eps : ℕ → ℝ
  eps_nonneg : ∀ N, 0 ≤ eps N
  dn_le_from_bcf : ∀ N, D.DN rho N ≤ eps N
  eps_tendsto_zero : Filter.Tendsto eps Filter.atTop (nhds 0)

def BCFZeroResidueControl.toVanishingUpperBound
    {rho : D.GeneratorFamily}
    (h : BCFZeroResidueControl D rho) :
    VanishingUpperBound D rho where
  eps := h.eps
  eps_nonneg := h.eps_nonneg
  dn_le := h.dn_le_from_bcf
  eps_tendsto_zero := h.eps_tendsto_zero

theorem DNLimit_eq_zero_of_BCFZeroResidueControl
    (rho : D.GeneratorFamily)
    (h : BCFZeroResidueControl D rho) :
    D.DNLimit rho = 0 :=
  D.DNLimit_eq_zero_of_vanishingUpperBound rho h.toVanishingUpperBound

def bcfTerminalStatus : String :=
  "OPEN_MATH: ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL"

#print axioms DNLimit_eq_zero_of_BCFZeroResidueControl

end NBHilbertData
end MCore.RH.NB
