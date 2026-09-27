# R2 — HM2-D2 global mixed asymptotic criterion

Status: OPEN_MATH / QUANTITATIVE MIN-CUT ISOLATED

Parent:
- HM1_MATH = GREEN
- HM2-A/B/C = GREEN_MATH
- HM2-D local principal-part cancellation = GREEN_MATH

## 1. Exact scale hierarchy before global integration

From the HM1 identity,

  1 - zeta(s)V_{N,m}(s)
    =
    - sum_{j=1}^m
        binom(m,j)
        zeta(s)(1/zeta)^(j)(s)
        / (log N)^j
    - m! zeta(s)/(log N)^m
        [SUM_RHO R_{N,m}(rho,s)+F_{N,m}(s)].

Thus the central hierarchy is explicit:

  j=1 : scale (log N)^(-1)
  j=2 : scale (log N)^(-2)
  ...
  j=m : scale (log N)^(-m).

Pointwise on compact subsets away from zeros, j=1 is dominant.

## 2. Why global lower-order does not follow formally

On the critical line, the functions

  zeta(s)(1/zeta)^(j)(s)

have increasing pole order when considered separately.  Local pole cancellation
with the matching zero-residue terms is already proved in the complete bracket,
but this prevents us from bounding the central pieces independently near zeros.

Therefore the statement

  j>=2 is lower order globally

requires a norm estimate for the COMBINED j-th central/residue layer.

## 3. Layer decomposition

Define C_{N,m,j}(s) to be the complete pole-cancelled layer containing:
- the j-th central derivative contribution;
- exactly those Laurent coefficients from the zero-residue expansion needed to
  cancel its principal parts.

The precise layer decomposition may be implemented through local Laurent
projectors or, preferably, by contour coefficients before taking residues.

The required quantitative hierarchy is:

  ||C_{N,m,j}||_w
    = o((log N)^(j-1))

for every j>=2,

where

  ||f||_w^2
    := integral_R |f(1/2+it)|^2/(1/4+t^2) dt.

Indeed, multiplying by (log N)^(-j) then gives

  (log N)^(-j) ||C_{N,m,j}||_w
    = o(1/log N),

so every j>=2 layer is lower order than the j=1 scale.

A weaker sufficient squared-norm condition is

  ||C_{N,m,j}||_w^2
    = o((log N)^(2j-2)).

## 4. Main j=1 layer

HM2 does NOT require evaluating the j=1 layer unconditionally all the way to a
positive constant.  It only requires that the higher-order redesign does not
create a larger main term.

Therefore HM2-D2 can close if:

A. j=1 layer is the same BCF mixed mechanism, up to the factor m;
B. every j>=2 layer satisfies the lower-order norm criterion above;
C. F_{N,m} is lower order in the same weighted norm.

The genuinely RH-equivalent/off-critical difficulty may remain assigned to HM4.

## 5. External-state audit

The surfaced BCF literature evaluates the m=1 leading constant only under RH
plus a negative moment condition on zeta'(rho).  No unconditional published
higher-order analogue was located that supplies the above j>=2 weighted norm
bounds.

Therefore no external theorem is imported as a closure here.

## 6. Canonical HM2-D2 delta

HM2-D2 :=
HIGHER_DERIVATIVE_POLE_CANCELLED_LAYER_BOUNDS

Required for each fixed m>=2 and every j=2,...,m:

  ||C_{N,m,j}||_w^2
    = o((log N)^(2j-2)).

Once these hold, the higher-order terms are globally lower order than the
j=1 BCF layer, and HM2 is closed as a redesign-safety theorem.

## Status

J1_SCALE = IDENTIFIED_AS_1_OVER_LOG_N
J_GE_2_POINTWISE_HIERARCHY = GREEN_MATH_AWAY_FROM_ZEROS
LOCAL_POLE_CANCELLATION = GREEN_MATH
GLOBAL_LAYER_BOUNDS = OPEN_MATH
HM2_D2 = OPEN_MATH
HM2 = IN_PROCESS
HM3 = BUILD_PENDING
HM4 = BLOCKED
DNLimit_EQ_ZERO = false
RH_PROVED = false
