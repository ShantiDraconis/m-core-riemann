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
