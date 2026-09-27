# R2 — Global L2 assembly after local BCF pole cancellation

Status: OPEN_MATH / CANONICAL SUB-DELTA

Parent:
- R-ZR1 = COMPLETE_BCF_BRACKET_CANCELLATION
- R-ZR1-M1 = OFF_CRITICAL_MIXED_RESIDUE_CONTROL

## Local cancellation already identified

For a simple zero rho, the singular parts of

  zeta'(s)/zeta(s)

and

  zeta(s) R_N(rho,s)

cancel to principal order as s -> rho.

This is a local algebraic cancellation mechanism. It does not by itself give
the required global weighted L2 estimate.

## Partition strategy

For a height parameter T=T(N) and zero neighborhoods U(T), decompose the
critical-line integral into:

A. neighborhoods of zeros with |gamma| <= 2T;
B. the compact complement |t| <= 2T outside U(T);
C. the tail |t| > 2T.

The partition is a research device, not a proof-status promotion.

### Fail-closed status of A and C

The local pole cancellation makes region A structurally tractable, and the
weight (1/4+t^2)^(-1) makes region C a natural tail target.  However neither
region is marked GREEN here until a complete unconditional bound is supplied
with all multiplicity, overlap, infinite-sum, and N-uniformity dependencies
checked.

A_STATUS = REDUCED_TARGET_NOT_PROVED
C_STATUS = REDUCED_TARGET_NOT_PROVED

## Canonical remaining complement target

Let

  Z_N(s) := zeta(s) * sum_rho R_N(rho,s).

The sharp complement sub-delta is:

R-ZR1-M1b := OFF_CRITICAL_COMPLEMENT_L2_CONTROL

Required conclusion:

  integral_{t in B_N}
    |Z_N(1/2+it)|^2 / (1/4+t^2) dt
      = o((log N)^2)

or, more generally, an estimate for the COMPLETE BCF BRACKET on B_N strong
enough that after multiplication by 1/(log N)^2 its contribution tends to 0.

The complete-bracket formulation is preferred whenever cross-term
cancellation with zeta'/zeta or F_s(1/N) is retained.

## Why this is the real obstruction

A zero rho=beta+i gamma with beta>1/2 contributes the raw scale

  N^(beta-1/2)

away from its local pole neighborhood.  Counting estimates alone do not remove
this factor.  Therefore any unconditional close must provide one of:

1. collective phase cancellation across zeros;
2. cancellation with the logarithmic-derivative term in the complete bracket;
3. an operator/contour formulation that bounds the complete expression without
   termwise absolute values.

## Forbidden shortcuts

The following do not discharge R-ZR1-M1b:

- RH or an equivalent critical-line hypothesis;
- universal simplicity of zeros assumed without proof;
- BCF's conditional negative zeta'-moment hypothesis treated as unconditional;
- finite-height zero verification;
- zero-density counting without amplitude cancellation;
- termwise absolute values that destroy complete-bracket cancellation;
- dropping off-critical residues;
- declaring A or C GREEN solely from the partition heuristic.

## Operational endpoint

Any proof of R-ZR1-M1b must ultimately yield a genuine

  BCFZeroResidueControl concreteNBData concreteGeneratorFamily

with

  eps_nonneg,
  DN <= eps,
  eps -> 0.

## Status

LOCAL_SIMPLE_ZERO_POLE_CANCELLATION = IDENTIFIED
REGION_A = REDUCED_TARGET_NOT_PROVED
REGION_B = OPEN_MATH
REGION_C = REDUCED_TARGET_NOT_PROVED
OFF_CRITICAL_COMPLEMENT_L2_CONTROL = OPEN_MATH
COMPLETE_BCF_BRACKET_CANCELLATION = OPEN_MATH
DNLimit_EQ_ZERO = false
RH_PROVED = false
