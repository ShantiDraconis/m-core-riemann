import MCore.RH.Analytic.OffLineZeroReflection
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTarget

namespace MCore.RH.R0

open MeasureTheory Complex

/-- Boundary pairing with the explicit Cauchy evaluation kernel. -/
noncomputable def criticalEvaluationPairing
    (F : ℝ → ℂ) (ρ : ℂ) : ℂ :=
  (1 / (2 * Real.pi)) *
    ∫ t : ℝ, F t * conj (criticalEvaluationKernel ρ t)

/--
Minimal Hardy/Cauchy producer needed by E1.
It asks only for reproduction of the concrete generator Mellin functions and the target Mellin
function; no abstract Hardy-space infrastructure is assumed.
-/
def CriticalEvaluationReproducing (ρ : ℂ) : Prop :=
  (∀ n : ℕ,
    criticalEvaluationPairing
      (fun t => mellin (rhoRepresentativeC n) (criticalLinePoint t)) ρ =
        mellin (rhoRepresentativeC n) ρ) ∧
  criticalEvaluationPairing
      (fun t => mellin chiRepresentativeC (criticalLinePoint t)) ρ =
        mellin chiRepresentativeC ρ

/-- Spectral witness data before transport back to the physical real L² carrier. -/
structure SpectralZeroWitnessData (z : RightStripZero) where
  kernel : ℝ → ℂ
  kernelSqIntegrable : Integrable (fun t => ‖kernel t‖ ^ 2)
  generatorPairingZero :
    ∀ n : ℕ,
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ,
          mellin (rhoRepresentativeC n) (criticalLinePoint t) * conj (kernel t) = 0
  targetPairingNonzero :
    (1 / (2 * Real.pi)) *
      ∫ t : ℝ,
        mellin chiRepresentativeC (criticalLinePoint t) * conj (kernel t) ≠ 0

/-- A right-half-strip zero plus the reproducing identity gives an explicit spectral witness. -/
noncomputable theorem spectralZeroWitness_of_reproducing
    (z : RightStripZero)
    (hrep : CriticalEvaluationReproducing z.rho) :
    SpectralZeroWitnessData z := by
  refine {
    kernel := criticalEvaluationKernel z.rho
    kernelSqIntegrable := criticalEvaluationKernel_normSq_integrable z.hright
    generatorPairingZero := ?_
    targetPairingNonzero := ?_
  }
  · intro n
    rw [show
      (1 / (2 * Real.pi)) *
          ∫ t : ℝ,
            mellin (rhoRepresentativeC n) (criticalLinePoint t) *
              conj (criticalEvaluationKernel z.rho t) =
        criticalEvaluationPairing
          (fun t => mellin (rhoRepresentativeC n) (criticalLinePoint t))
          z.rho by rfl]
    rw [hrep.1 n]
    rw [mellin_rho_realized n z.rho (by linarith [z.hright]) z.hlt]
    rw [z.hzero]
    ring
  · rw [show
      (1 / (2 * Real.pi)) *
          ∫ t : ℝ,
            mellin chiRepresentativeC (criticalLinePoint t) *
              conj (criticalEvaluationKernel z.rho t) =
        criticalEvaluationPairing
          (fun t => mellin chiRepresentativeC (criticalLinePoint t))
          z.rho by rfl]
    rw [hrep.2]
    rw [mellin_chiRepresentativeC z.rho (by linarith [z.hright])]
    exact one_div_ne_zero (ne_zero_of_re_pos (by linarith [z.hright]))

/--
Library/transport producer: turn a complex spectral witness into the real physical L² witness
consumed by the already-certified orthogonal-obstruction theorem.
This is deliberately separated from the Cauchy reproducing identity.
-/
def SpectralToPhysicalWitness : Prop :=
  ∀ (z : RightStripZero), SpectralZeroWitnessData z →
    ∃ w : concreteNBData.H,
      w ≠ 0 ∧
      inner ℝ concreteNBData.chi w ≠ 0 ∧
      ∀ n : ℕ, inner ℝ (concreteGeneratorFamily n) w = 0

/-- E1 follows from reproduction plus spectral-to-physical transport. -/
theorem rightStripZero_to_physical_witness
    (hrep : ∀ z : RightStripZero, CriticalEvaluationReproducing z.rho)
    (htransport : SpectralToPhysicalWitness)
    (z : RightStripZero) :
    ∃ w : concreteNBData.H,
      w ≠ 0 ∧
      inner ℝ concreteNBData.chi w ≠ 0 ∧
      ∀ n : ℕ, inner ℝ (concreteGeneratorFamily n) w = 0 := by
  exact htransport z (spectralZeroWitness_of_reproducing z (hrep z))

/-- Full off-line-strip E1 reduction. -/
theorem offLineStripZero_to_physical_witness
    (hrep : ∀ z : RightStripZero, CriticalEvaluationReproducing z.rho)
    (htransport : SpectralToPhysicalWitness)
    (z : OffLineStripZero) :
    ∃ w : concreteNBData.H,
      w ≠ 0 ∧
      inner ℝ concreteNBData.chi w ≠ 0 ∧
      ∀ n : ℕ, inner ℝ (concreteGeneratorFamily n) w = 0 := by
  exact rightStripZero_to_physical_witness
    hrep htransport (offLineStripZero_to_right z)

#print axioms MCore.RH.R0.spectralZeroWitness_of_reproducing
#print axioms MCore.RH.R0.rightStripZero_to_physical_witness
#print axioms MCore.RH.R0.offLineStripZero_to_physical_witness

end MCore.RH.R0
