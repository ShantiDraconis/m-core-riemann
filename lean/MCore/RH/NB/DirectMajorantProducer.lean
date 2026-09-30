import MCore.RH.NB.ZeroLimitFrontier

namespace MCore.RH.NB
namespace NBHilbertData

variable (D : NBHilbertData)

/-- Generic squeeze producer: any nonnegative majorant tending to zero and
    dominating DN forces the exact zero-limit frontier. -/
theorem DNToZero_of_majorant
    (rho : D.GeneratorFamily)
    (eps : ℕ → ℝ)
    (heps : Filter.Tendsto eps Filter.atTop (nhds 0))
    (hbound : ∀ N, D.DN rho N ≤ eps N) :
    D.DNToZero rho := by
  unfold DNToZero
  exact squeeze_zero' (fun N => D.DN_nonneg rho N) hbound heps

theorem DNLimit_eq_zero_of_majorant
    (rho : D.GeneratorFamily)
    (eps : ℕ → ℝ)
    (heps : Filter.Tendsto eps Filter.atTop (nhds 0))
    (hbound : ∀ N, D.DN rho N ≤ eps N) :
    D.DNLimit rho = 0 :=
  (D.DNToZero_iff_DNLimit_eq_zero rho).1
    (D.DNToZero_of_majorant rho eps heps hbound)

#print axioms MCore.RH.NB.NBHilbertData.DNToZero_of_majorant
#print axioms MCore.RH.NB.NBHilbertData.DNLimit_eq_zero_of_majorant

end NBHilbertData
end MCore.RH.NB
