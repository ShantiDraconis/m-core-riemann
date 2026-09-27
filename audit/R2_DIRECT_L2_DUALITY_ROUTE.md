# R2 — Direct weighted-L2 duality route

Status: OPEN_MATH / VALID REDESIGN ROUTE

Parent deltas:
- R-ZR1 = COMPLETE_BCF_BRACKET_CANCELLATION
- R-ZR1-M1b = OFF_CRITICAL_COMPLEMENT_L2_CONTROL
- R-ZR1-M1b-(B/C)-TRADEOFF = fixed-length single-height split no-go

## Motivation

The fixed-length BCF route with a hard truncation at one height T creates a
complement/tail tradeoff.  A t-dependent cutoff is inadmissible because it
breaks both holomorphy and realization by one fixed Nyman-Beurling vector.

The remaining valid redesign is to avoid a hard height split and estimate the
complete error directly in the target weighted L2 / Hilbert norm.

## Target error

For a fixed admissible NB approximant v_N with Mellin polynomial V_N,

  E_N(t) :=
    [1 - zeta(1/2+it) V_N(1/2+it)] / (1/2+it).

The desired conclusion is

  ||E_N||_{L2(R,dt/2pi)} -> 0.

Equivalently, by Hilbert-space duality,

  sup_{||phi||_2 <= 1}
    | integral_R E_N(t) conjugate(phi(t)) dt |
      -> 0.

This formulation has no hard truncation height.

## Operator formulation

Define the residual operator on coefficient vectors c=(c_n) by

  T_N c (t) :=
    [1 - zeta(1/2+it) sum_{n<=N} c_n n^{-1/2-it}]
      / (1/2+it).

The NB frontier is to construct admissible c^(N) such that

  ||T_N c^(N)||_2 -> 0.

The BCF choice is one concrete c^(N).  Any other fixed coefficient choice is
allowed provided it corresponds to the certified NB generators.

## Dual target

For every unit test function phi, move the t-integral against n^{-it} to the
Fourier/Mellin side:

  <T_N c, phi>
    = <chi, phi> - sum_{n<=N} c_n <rho_n, phi>.

Thus the dual route is exactly a density / annihilator statement:

  if phi is orthogonal to every rho_n, then <chi,phi>=0.

Quantitatively, a closing theorem must provide finite-N coefficients c^(N)
with a norm bound uniform enough to force the residual norm to zero.

## Canonical sub-delta

R-ZR1-DUAL :=
UNIFORM_FINITE_DUAL_APPROXIMATION

Required output:
construct a sequence of fixed coefficient vectors c^(N) such that

  sup_{||phi||_2 <= 1}
    | <chi,phi> - sum_{n<=N} c^(N)_n <rho_n,phi> |
      -> 0.

This is equivalent to

  dist(chi, span{rho_1,...,rho_N}) -> 0,

hence it is the exact NB open mathematics.  The route is valid, but it does
not by itself weaken the theorem: any estimate proving the dual target is an
RH-equivalent result.

## Research value

The advantage is architectural, not logical weakening:
- no single truncation height T;
- no nonholomorphic cutoff;
- no need to isolate individual zero residues;
- cancellation can occur at the operator / Gram level.

Candidate analytic tools:
- Gram operator spectral estimates;
- frame/Riesz sequence estimates for the NB generators;
- explicit construction of dual certificates;
- weighted Carleson/large-sieve estimates for the Mellin image.

## Firewall

This route must not be reported as progress unless it proves a quantitative
finite-N estimate.  The qualitative Hahn-Banach annihilator formulation is
equivalent to the original density problem and therefore not a closure.

## Status

DUALITY_REFORMULATION = VALID
HARD_HEIGHT_SPLIT = AVOIDED
NEW_MATHEMATICAL_WEAKENING = NONE
UNIFORM_FINITE_DUAL_APPROXIMATION = OPEN_MATH
DNLimit_EQ_ZERO = false
RH_PROVED = false
