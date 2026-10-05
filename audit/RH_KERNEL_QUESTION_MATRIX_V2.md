# RH Kernel Question Matrix V2

Forward-only rule: K0 -> K1 -> ... -> K10. A later stage never substitutes for a failed earlier stage.
Promotion rule: SOURCE_READY != GREEN. GREEN requires real Lean compilation plus a clean axiom audit.

## K0 — pinned Mathlib foundation
1. mellin_chiRepresentativeC: Mellin chi = 1/s for Re(s)>0.
2. rho_weighted_integrableOn_Ioi: weighted integrability for 0<s<1.
3. rhoRepresentativeC_locallyIntegrableOn.
4. chiRepresentativeC_locallyIntegrableOn.
5. rhoRepresentativeC_isBigO_nhdsGT.
6. rhoRepresentativeC_isBigO_atTop.
7. rhoRepresentativeC_mellinConvergent.
8. chiRepresentativeC_mellinConvergent.
9. MellinRhoReduction contains no sorry/admit/custom axiom.

## K1 — D1
1. rho_0 inversion reduction.
2. fractional-part Mellin identity on 0<Re(s)<1.
3. dilation law.
4. M rho_n(s)=-(n+1)^(-s) zeta(s)/s.

## K2 — finite source/Gram
1. finite Vandermonde uniqueness.
2. generator linear independence.
3. concrete Gram PosDef.
4. determinant nonzero.
5. inverse normal-equation solution.
6. target closed form.
7. Gram autocorrelation formula.

## K3 — residual Mellin algebra
1. finite combination convergence.
2. finite combination Mellin formula.
3. residual convergence.
4. M residual=(1+zeta P_c)/s.
5. critical-line norm-square formula.

## K4 — physical/log bridges
1. Hilbert residual equals literal representative a.e.
2. Hilbert norm-square equals positive-half-line integral.
3. x=exp(-u) log pullback isometry.
4. Mellin critical line equals Fourier integral at t/(2*pi).
5. frequency scaling factor is exactly 1/(2*pi).

## K5 — generic Fourier representative agreement
Exact generic target:
For every f:R->C, Integrable f and MemLp f 2 imply
the classical Fourier integral equals a.e. the abstract L2 Fourier transform.

Decomposition:
1. classical Fourier integral is locally integrable.
2. L1 Fourier/Schwartz pairing identity.
3. abstract L2 Fourier/tempered-distribution compatibility.
4. equality of all smooth compact-test pairings.
5. uniqueness of locally integrable representatives via ae_eq_of_integral_contDiff_smul_eq.
6. a.e. Fourier representative equality.

No RH/zeta/Nyman-specific hypothesis is permitted in this stage.

## K6 — D3 terminal
1. ordinary Fourier Plancherel from K5.
2. residual critical-line Plancherel.
3. explicit zeta/Dirichlet-polynomial spectral identity.
4. no residual-specific analytic side condition remains open.

## K7 — E1 off-critical witness
1. construct criticalEvaluationKernel for a right-strip zero.
2. prove L2 membership.
3. prove norm-square formula pi/(Re rho-1/2).
4. CriticalEvaluationReproducing.
5. SpectralToPhysicalWitness.
6. transport off-critical zero to a nonzero physical witness.
7. derive the required obstruction/lower-bound consequence.
8. reflection handles the opposite side of the critical line.

## K8 — finite Vasyunin route
1. b_i closed form.
2. G_ij autocorrelation form.
3. diagonal/symmetry/scaling/common-factor laws.
4. coprime formula:
   explicitGramEntryNat h k = vasyuninGramEntry h k.
5. coprime formula -> general formula.
6. finite Vasyunin matrix = concrete Gram matrix.
7. DN(N)=1-b_N^T G_N^{-1}b_N.

## K9 — material quantitative producer
Exact terminal producer:
ConcreteUniformLogDNBound :=
  exists K >= 0, forall N, DN(N) <= K / log(N+2).

Kernel discovery questions:
1. explicit coefficient vector c_N with energy <= K/log(N+2)?
2. direct bound on 1-b^T G^{-1}b?
3. Vasyunin cotangent-sum uniform estimates?
4. diagonal/off-diagonal decomposition with O(1/log N) error?
5. spectral bounds on G_N or G_N^{-1} sufficient for the rate?
6. monotone/comparison quantity controlling DN?
7. direct uniform bound on log(N+2)*DN(N)?
8. any finite K suffices; optimal K is not required.

## K10 — endpoint transport
1. ConcreteUniformLogDNBound -> DNLimit=0.
2. DNLimit=0 -> FiniteSpanApproximatesChi.
3. finite-span closure -> Nyman-Beurling criterion.
4. criterion -> terminal RH certification consumer.
5. exact axiom audit contains no sorryAx and no custom RH axiom.

## Promotion
Only after K0-K10 executable gates pass:
SOURCE_READY -> GREEN -> FROZEN -> CERTIFIED.
No open mathematical producer is promoted merely because its reduction graph is complete.
