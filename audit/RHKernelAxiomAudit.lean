import MCore.RH.Analytic.MellinPlancherelBridges
import MCore.RH.Analytic.CriticalLineResidual
import MCore.RH.Analytic.ResidualMellinAlgebra
import MCore.RH.Analytic.FourierCompatibilityRealization
import MCore.RH.Analytic.FourierCompatibilityReduction
import MCore.RH.Analytic.LogResidualMembership
import MCore.RH.Analytic.FourierPlancherelBridge
import MCore.RH.Analytic.LogResidualIsometry
import MCore.RH.Analytic.ResidualPlancherelReduction
import MCore.RH.Analytic.MellinPlancherelBridge
import MCore.RH.Analytic.MellinPlancherelCoreReduction
import MCore.RH.Analytic.MellinLogIsometry
import MCore.RH.R0.VasyuninRateReduction
import MCore.RH.Analytic.FourierLpCompatibility
import MCore.RH.Analytic.FourierPlancherelReduction
import MCore.RH.Analytic.LogPullbackNorm
import MCore.RH.R0.VasyuninGCD
import MCore.RH.R0.VasyuninStructural
import MCore.RH.Analytic.MellinPlancherelFourierReduction
import MCore.RH.Analytic.MellinFourierBridge
import MCore.RH.Analytic.ResidualNormBridge
import MCore.RH.Analytic.MellinCriticalLine
import MCore.RH.R0.VasyuninFiniteGram
import MCore.RH.R0.ExplicitGramRate
import MCore.RH.Analytic.E1EvaluationReduction
import MCore.RH.Analytic.OffLineZeroReflection
import MCore.RH.Analytic.CriticalEvaluationKernel
import MCore.RH.Analytic.D3PinnedGap
import MCore.RH.Analytic.D3LogLiftIsometry
import MCore.RH.Analytic.D3FourierReduction
import MCore.RH.Analytic.D3Reduction
import MCore.RH.Analytic.ResidualCriticalLine
import MCore.RH.Analytic.ResidualMellin
import MCore.RH.Analytic.MellinStripConvergence
import MCore.RH.Analytic.D3SingleGap
import MCore.RH.Analytic.MellinPlancherelEasyLaws
import MCore.RH.Analytic.MellinPlancherelDecomposition
import MCore.RH.Analytic.MellinPlancherelReduction
import MCore.RH.Analytic.MellinCriticalDensity
import MCore.RH.Analytic.CriticalLineBasic
import MCore.RH.Analytic.MellinResidualAlgebra
import MCore.RH.Analytic.MellinTargetConvergence
import MCore.RH.Analytic.MellinRhoConvergence
import MCore.RH.Analytic.D1KernelEntry
import MCore.RH.Analytic.MellinTailContinuation
import MCore.RH.Analytic.MellinRhoClosedForm
import MCore.RH.Analytic.MellinTailContinuationReduction
import MCore.RH.Analytic.RegularizedZeta
import MCore.RH.Analytic.MellinTailPartial
import MCore.RH.Analytic.MellinTailRightReduction
import MCore.RH.Analytic.MellinTailBlocks
import MCore.RH.Analytic.MellinNearZero
import MCore.RH.Analytic.MellinRhoReduction
import MCore.RH.Analytic.MellinTarget
import MCore.RH.R0.GramAutocorrelation
import MCore.RH.R0.TargetClosedForm
import MCore.RH.R0.GramIntegral
import MCore.RH.R0.GramInverse
import MCore.RH.R0.BaseMellinPositive
import MCore.RH.R0.WeightedScaling
import MCore.RH.R0.WeightedIntegralLinearity
import MCore.RH.R0.ExponentialUniqueness
import MCore.RH.R0.WeightedIntegrability
import MCore.RH.R0.LpToAE
import MCore.RH.R0.RhoBasicFacts
import MCore.RH.R0.LinearIndependentReduction
import MCore.RH.R0.GramExplicit
import MCore.RH.R0.FrontierExposure
import MCore.RH.R0.HardFrontierReduction
import MCore.RH.R0.ConcreteGramLogRate
import MCore.RH.R0.ConcreteZeroObstruction
import MCore.RH.NB.OrthogonalWitnessObstruction
import MCore.RH.Analytic.MellinConcrete
import MCore.RH.R0.RHKernelEntry

#print axioms MCore.RH.R0.concreteVanishingUpperBound_to_FINAL_ROOT
#print axioms MCore.RH.R0.concreteVanishingUpperBound_to_ConcreteGramResidual
#print axioms MCore.RH.R0.concreteVanishingUpperBound_to_FiniteSpanApproximatesChi
#print axioms MCore.RH.R0.concreteVanishingUpperBound_to_RiemannTerminalCertifies
#print axioms MCore.RH.R0.concreteVanishingUpperBound_iff_exists_majorant
#print axioms MCore.RH.R0.rh_kernel_entry_FINAL_ROOT
#print axioms MCore.RH.R0.rh_kernel_entry_GramResidual
#print axioms MCore.RH.R0.rh_kernel_entry_FiniteSpan
#print axioms MCore.RH.R0.rh_kernel_entry_Terminal
#print axioms MCore.RH.R0.ConcreteLogDNBound.toConcreteVanishingUpperBound
#print axioms MCore.RH.R0.concreteLogDNBound_to_FINAL_ROOT
#print axioms MCore.RH.R0.concreteLogDNBound_to_RiemannTerminalCertifies
#print axioms MCore.RH.R0.nonempty_concreteLogDNBound_iff
#print axioms MCore.RH.R0.rh_kernel_entry_LogMajorantTerminal
#print axioms MCore.RH.R0.concreteUniformLogDNBound_iff_nonempty
#print axioms MCore.RH.R0.terminal_of_concreteUniformLogDNBound
#print axioms MCore.RH.R0.rh_kernel_entry_HardFrontier
#print axioms MCore.RH.R0.rh_material_producer_closes_terminal
#print axioms MCore.RH.R0.rh_material_producer_nonempty_closes_terminal
#print axioms MCore.RH.R0.rh_kernel_entry_MaterialProducer
#print axioms MCore.RH.R0.rhoRepresentativeC_eq_dilate
#print axioms MCore.RH.R0.mellin_rhoRepresentativeC_dilate
#print axioms MCore.RH.NB.NBHilbertData.orthogonal_witness_lower_bound_mul
#print axioms MCore.RH.NB.NBHilbertData.orthogonalWitnessDelta_le_DN
#print axioms MCore.RH.NB.NBHilbertData.not_DNToZero_of_orthogonal_witness
#print axioms MCore.RH.R0.no_ConcreteUniformLogDNBound_of_orthogonal_witness
#print axioms MCore.RH.R0.optimalGramCoeff_reduced_energy
#print axioms MCore.RH.R0.optimalGramCoeff_normal
#print axioms MCore.RH.R0.ConcreteGramLogRate.toUniformLogDNBound
#print axioms MCore.RH.R0.uniformLogDNBound_to_ConcreteGramLogRate
#print axioms MCore.RH.R0.concreteGramLogRate_iff_uniformLogDNBound
#print axioms MCore.RH.R0.hardFrontierTarget_implies_ConcreteUniformLogDNBound
#print axioms MCore.RH.R0.hard_frontier_of_ConcreteGramLogRate
#print axioms MCore.RH.R0.hard_frontier_of_CriticalLineWeightedErrorRate
#print axioms MCore.RH.R0.no_HardFrontierTarget_of_orthogonal_witness
#print axioms MCore.RH.R0.coefficient_gap_iff_material_gap
#print axioms MCore.RH.R0.gram_gap_iff_material_gap
#print axioms MCore.RH.R0.material_gap_closes_terminal
#print axioms MCore.RH.R0.orthogonal_witness_blocks_material_gap
#print axioms MCore.RH.R0.concreteGramMatrix_posSemidef
#print axioms MCore.RH.R0.concreteGramMatrix_posDef_iff_linearIndependent
#print axioms MCore.RH.R0.concrete_normal_equations_iff_mulVec
#print axioms MCore.RH.R0.optimalGramCoeff_mulVec
#print axioms MCore.RH.R0.rhoIndex_cast_injective
#print axioms MCore.RH.R0.concreteGeneratorFamily_linearIndependent_of_moments
#print axioms MCore.RH.R0.concreteGramMatrix_posDef_of_moments
#print axioms MCore.RH.R0.concreteFiniteCombination_eq_zero_ae
#print axioms MCore.RH.R0.rho_weighted_integrableOn_Ioi
#print axioms MCore.RH.R0.concreteMomentUniqueness_vandermonde
#print axioms MCore.RH.R0.weighted_integral_finset_linearity
#print axioms MCore.RH.R0.rho_weighted_integral_scaling
#print axioms MCore.RH.R0.base_weighted_integral_pos
#print axioms MCore.RH.R0.concreteMomentBridge_realized
#print axioms MCore.RH.R0.optimalGramCoeff_eq_inv_mulVec_target
#print axioms MCore.RH.R0.concreteTargetVector_eq_setIntegral
#print axioms MCore.RH.R0.concreteGramMatrix_eq_setIntegral
#print axioms MCore.RH.R0.fractionalTailEulerIdentity_realized
#print axioms MCore.RH.R0.concreteTargetVector_closed_form
#print axioms MCore.RH.R0.concreteGramMatrix_eq_fractionalAutocorrelation
#print axioms MCore.RH.R0.mellin_chiRepresentativeC
#print axioms MCore.RH.R0.mellin_rhoBase_reduction
#print axioms MCore.RH.R0.d1_nearZero_identity
#print axioms MCore.RH.R0.complexTailTerm_formula
#print axioms MCore.RH.R0.tailFormulaRight_of_series
#print axioms MCore.RH.R0.complexTailPartial_formula
#print axioms MCore.RH.R0.riemannZeta_eq_floor_integral
#print axioms MCore.RH.R0.tailFormulaRight_realized
#print axioms MCore.RH.R0.regularizedZeta_analyticAt_one
#print axioms MCore.RH.R0.continuedFractionalTail_analyticAt
#print axioms MCore.RH.R0.fractionalTail_eq_continued
#print axioms MCore.RH.R0.fractionalTailKernel_locallyIntegrable
#print axioms MCore.RH.R0.fractionalTailKernel_mellin_differentiableAt
#print axioms MCore.RH.R0.fractionalTailComplex_differentiableAt
#print axioms MCore.RH.R0.tailMellinAnalytic_realized
#print axioms MCore.RH.R0.tailAnalyticContinuation_realized
#print axioms MCore.RH.R0.fractionalZetaMellinIdentity_realized
#print axioms MCore.RH.R0.mellin_rho_base_realized

#print axioms MCore.RH.R0.d1_kernel_entry_right

#print axioms MCore.RH.R0.d1_kernel_entry_continuation

#print axioms MCore.RH.R0.d1_kernel_entry_mellin

#print axioms MCore.RH.R0.mellin_rho_realized

#print axioms MCore.RH.R0.d1_kernel_entry_rho_family

#print axioms MCore.RH.R0.rhoRepresentativeC_mellinConvergent

#print axioms MCore.RH.R0.chiRepresentativeC_mellinConvergent

#print axioms MCore.RH.R0.residual_mellin_closed_form

#print axioms MCore.RH.R0.criticalLine_norm_sq

#print axioms MCore.RH.R0.residual_mellin_critical_sq

#print axioms MCore.RH.R0.d3_reduced_to_mellin_plancherel

#print axioms MCore.RH.R0.logPullbackIsometry_realized

#print axioms MCore.RH.R0.criticalFrequencyScaling_realized

#print axioms MCore.RH.R0.mellinPlancherel_of_fourier_only

#print axioms MCore.RH.R0.mellin_residual_closed_form

#print axioms MCore.RH.R0.mellin_residual_criticalLine

#print axioms MCore.RH.R0.normSq_mellin_residual_criticalLine

#print axioms MCore.RH.R0.mellin_residual_eq_fourier_logLift

#print axioms MCore.RH.R0.residualCriticalFrequencyScaling_realized

#print axioms MCore.RH.R0.residualLogLiftIsometry_realized

#print axioms MCore.RH.R0.criticalEvaluationKernel_normSq

#print axioms MCore.RH.R0.criticalEvaluationKernel_normSq_integrable

#print axioms MCore.RH.R0.integral_criticalEvaluationKernel_normSq

#print axioms MCore.RH.R0.offLineStripZero_to_right

#print axioms MCore.RH.R0.spectralZeroWitness_of_reproducing

#print axioms MCore.RH.R0.offLineStripZero_to_physical_witness

#print axioms MCore.RH.R0.explicitTargetVector_eq_concrete

#print axioms MCore.RH.R0.explicitGramMatrix_eq_concrete

#print axioms MCore.RH.R0.concreteDN_eq_explicitGramResidual

#print axioms MCore.RH.R0.explicitGramRateTarget_iff_uniformLogDNBound

#print axioms MCore.RH.R0.explicitGramResidual_eq_vasyunin

#print axioms MCore.RH.R0.finiteVasyuninRateTarget_iff_explicitGramRate

#print axioms MCore.RH.R0.explicitResidualMellinPlancherel_of_bridges

#print axioms MCore.RH.R0.residualRepresentativeNormBridge_realized

#print axioms MCore.RH.R0.mellin_residual_eq_fourierIntegral_logPullback

#print axioms MCore.RH.R0.residualMellinPlancherel_of_fourier_bridges

#print axioms MCore.RH.R0.vasyuninGramEntry_diag

#print axioms MCore.RH.R0.vasyuninGramEntry_symm

#print axioms MCore.RH.R0.vasyuninGramMatrix_symm

#print axioms MCore.RH.R0.vasyuninGCDReduction_realized

#print axioms MCore.RH.R0.vasyuninGramFormula_of_coprime

#print axioms MCore.RH.R0.residualLogPullbackNorm_realized

#print axioms MCore.RH.R0.fourier_energy_frequency_rescale

#print axioms MCore.RH.R0.residualFourierPlancherel_of_compatibility

#print axioms MCore.RH.R0.finiteVasyuninRateTarget_iff_uniformLogDNBound_of_coprime

#print axioms MCore.RH.R0.terminal_of_finiteVasyuninRate

#print axioms MCore.RH.R0.residualRepresentativeC_mellinConvergent

#print axioms MCore.RH.R0.residualLogLift_integral_normSq

#print axioms MCore.RH.R0.criticalLine_frequency_rescale

#print axioms MCore.RH.R0.residualMellinPlancherelCore_of_fourier

#print axioms MCore.RH.R0.mellin_complexResidual

#print axioms MCore.RH.R0.residual_plancherel_explicit

#print axioms MCore.RH.R0.mellin_rhoCombinationC

#print axioms MCore.RH.R0.mellin_residualRepresentativeC

#print axioms MCore.RH.R0.residualCarrier_norm_sq_eq_integral

#print axioms MCore.RH.R0.logResidualIsometry_realized

#print axioms MCore.RH.R0.lp2_norm_sq_eq_integral_normSq

#print axioms MCore.RH.R0.classicalFourierPlancherel_of_compatibility

#print axioms MCore.RH.R0.d3_fourier_gap_suffices

#print axioms MCore.RH.R0.logResidualC_integrable

#print axioms MCore.RH.R0.logResidualC_memLp_two

#print axioms MCore.RH.R0.logResidualL1L2Producer_realized

#print axioms MCore.RH.R0.fourierIntegralLpCompatibility_of_generic

#print axioms MCore.RH.R0.mellin_concreteResidualC

#print axioms MCore.RH.R0.mellin_residual_on_critical_line

#print axioms MCore.RH.R0.criticalLine_normSq

#print axioms MCore.RH.R0.mellin_concreteCombinationC

#print axioms MCore.RH.R0.mellin_concreteResidualC_criticalLine

#print axioms MCore.RH.R0.normSq_mellin_concreteResidualC_criticalLine

#print axioms MCore.RH.R0.d3_residual_identity_of_plancherel

#print axioms MCore.RH.R0.mellin_residual_critical_eq_fourier

#print axioms MCore.RH.R0.residualFrequencyScaling_realized

#print axioms MCore.RH.R0.residualLogPullbackIsometry_realized
