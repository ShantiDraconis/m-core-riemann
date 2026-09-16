import MCore.RH.NB.Nesting

namespace MCore.RH.NB
namespace NBHilbertData

variable (D : NBHilbertData)

/-- Enlarging the finite approximation space cannot increase the projection residual norm. -/
theorem dN_antitone_of_le (rho : D.GeneratorFamily) {N M : ℕ} (hNM : N ≤ M) :
    D.dN rho M ≤ D.dN rho N := by
  unfold dN
  let vN : D.V rho M :=
    ⟨(D.P rho N D.chi : D.H), D.V_mono_of_le rho hNM (D.P_mem rho N D.chi)⟩
  rw [D.P_minimal rho M D.chi]
  exact ciInf_le' vN

/-- The squared finite-stage defect is antitone in the cutoff. -/
theorem DN_antitone_of_le (rho : D.GeneratorFamily) {N M : ℕ} (hNM : N ≤ M) :
    D.DN rho M ≤ D.DN rho N := by
  unfold DN
  have hnonnegM : 0 ≤ D.dN rho M := D.dN_nonneg rho M
  have hnonnegN : 0 ≤ D.dN rho N := D.dN_nonneg rho N
  have hmono : D.dN rho M ≤ D.dN rho N := D.dN_antitone_of_le rho hNM
  nlinarith

/-- `DN` is an antitone real sequence. -/
theorem DN_antitone (rho : D.GeneratorFamily) :
    Antitone (D.DN rho) := by
  intro N M hNM
  exact D.DN_antitone_of_le rho hNM

end NBHilbertData
end MCore.RH.NB
