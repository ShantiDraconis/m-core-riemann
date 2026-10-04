import MCore.RH.Analytic.ResidualCriticalLine

namespace MCore.RH.R0

open MeasureTheory Complex

/--
The one genuinely functional-analytic producer remaining in D3.

With Mathlib's Fourier normalization, t = 2π ξ, hence the factor 1/(2π).
The left side is the physical L²(dx) residual written through its representative;
the right side is the critical-line Mellin norm.
-/
def ResidualMellinPlancherel : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Set.Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          ‖mellin (residualRepresentativeC c) (criticalLinePoint t)‖ ^ 2

/--
Once Mellin--Plancherel is supplied, the right side rewrites mechanically to
the explicit zeta/Dirichlet-polynomial spectral density.
-/
theorem residual_spectral_identity_of_plancherel
    (hP : ResidualMellinPlancherel)
    {N : ℕ} (c : Fin N → ℝ) :
    (∫ x : ℝ in Set.Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ, residualSpectralDensity c t := by
  rw [hP c]
  congr 1
  apply integral_congr_ae
  exact Eventually.of_forall (fun t =>
    normSq_mellin_residual_criticalLine c t)

/--
D3 has now been reduced to one producer. No zeta algebra, Mellin scaling,
finite summation, or denominator normalization remains hidden here.
-/
def D3ResidualSpectralIdentity : Prop :=
  ∀ {N : ℕ} (c : Fin N → ℝ),
    (∫ x : ℝ in Set.Ioi 0, ‖residualRepresentativeC c x‖ ^ 2) =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ, residualSpectralDensity c t

theorem d3_of_mellinPlancherel
    (hP : ResidualMellinPlancherel) :
    D3ResidualSpectralIdentity := by
  intro N c
  exact residual_spectral_identity_of_plancherel hP c

#print axioms MCore.RH.R0.residual_spectral_identity_of_plancherel
#print axioms MCore.RH.R0.d3_of_mellinPlancherel

end MCore.RH.R0
