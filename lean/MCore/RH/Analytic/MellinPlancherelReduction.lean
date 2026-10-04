import MCore.RH.Analytic.ResidualMellin
import Mathlib.Analysis.MellinInversion
import Mathlib.Analysis.Fourier.LpSpace

namespace MCore.RH.R0

open MeasureTheory Set Complex

/-- Logarithmic critical-line transport used by Mellin--Plancherel. -/
noncomputable def criticalLogTransport (f : ℝ → ℂ) (u : ℝ) : ℂ :=
  Real.exp (-u / 2) * f (Real.exp (-u))

/-- Mellin on the critical line is the Fourier integral of the logarithmic transport. -/
theorem mellin_criticalLine_eq_fourier
    (f : ℝ → ℂ) (t : ℝ) :
    mellin f ((1 / 2 : ℝ) + t * I) =
      𝓕 (criticalLogTransport f) (t / (2 * Real.pi)) := by
  rw [mellin_eq_fourierIntegral]
  congr 1
  funext u
  simp [criticalLogTransport]
  ring_nf

/-- The exact L2 norm transport statement required by Mellin--Plancherel. -/
def CriticalLogTransportIsometry : Prop :=
  ∀ f : ℝ → ℂ,
    MemLp f 2 zeroInfinityMeasure →
    MemLp (criticalLogTransport f) 2 volume ∧
    snorm f 2 zeroInfinityMeasure =
      snorm (criticalLogTransport f) 2 volume

/--
Fourier Plancherel plus the frequency rescaling t -> t/(2*pi).
This is the precise remaining operator statement; no zeta appears here.
-/
def CriticalLinePlancherel : Prop :=
  ∀ f : ℝ → ℂ,
    MemLp f 2 zeroInfinityMeasure →
    Integrable (fun t : ℝ => ‖mellin f ((1 / 2 : ℝ) + t * I)‖ ^ 2) ∧
    (snorm f 2 zeroInfinityMeasure).toReal ^ 2 =
      (1 / (2 * Real.pi)) *
        ∫ t : ℝ, ‖mellin f ((1 / 2 : ℝ) + t * I)‖ ^ 2

/-- D3 reduces to two pure operator facts: logarithmic L2 transport and Fourier Plancherel. -/
structure MellinPlancherelCertificate where
  logIsometry : CriticalLogTransportIsometry
  criticalPlancherel : CriticalLinePlancherel

#check MeasureTheory.Lp.fourierTransformₗᵢ
#check MeasureTheory.Lp.norm_fourier_eq
#check fourierTransform_toLp

end MCore.RH.R0
