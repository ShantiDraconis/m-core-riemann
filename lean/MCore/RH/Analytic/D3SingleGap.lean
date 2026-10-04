import MCore.RH.Analytic.MellinPlancherelEasyLaws

namespace MCore.RH.R0

/-- D3 now needs only Fourier Plancherel on the logarithmic pullback class. -/
theorem mellinPlancherel_of_fourier_only
    (hfourier : FourierPlancherelForLogPullback) :
    MellinPlancherelProducer := by
  exact mellinPlancherel_of_three_laws
    logPullbackIsometry_realized
    hfourier
    criticalFrequencyScaling_realized

theorem residualPlancherel_of_fourier_only
    (hfourier : FourierPlancherelForLogPullback) :
    ResidualMellinPlancherel := by
  exact residualMellinPlancherel_of_generic
    (mellinPlancherel_of_fourier_only hfourier)

#print axioms MCore.RH.R0.mellinPlancherel_of_fourier_only
#print axioms MCore.RH.R0.residualPlancherel_of_fourier_only

end MCore.RH.R0
