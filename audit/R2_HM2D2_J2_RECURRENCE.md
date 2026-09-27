# R2 — HM2-D2 j=2 via exact higher-order recurrence

Status: OPEN_MATH / RECURRENCE ISOLATED

## Exact recurrence for the fixed logarithmic weights

Let

  w_N(n) := 1 - log n / log N

and

  V_{N,m}(s) := sum_{n<=N} mu(n) w_N(n)^m n^{-s}.

Since

  log n = log N * (1 - w_N(n)),

we have exactly

  d/ds V_{N,m}(s)
    = -log N * V_{N,m}(s)
      + log N * V_{N,m+1}(s).

Therefore

  V_{N,m+1}(s)
    = V_{N,m}(s)
      + (1/log N) d/ds V_{N,m}(s).

This identity is algebraic and uses no zero information.

## Error recurrence

Define

  E_{N,m}(s) := 1 - zeta(s) V_{N,m}(s)

and

  L(s) := zeta'(s)/zeta(s).

From

  (zeta V_{N,m})'
    = zeta' V_{N,m} + zeta V_{N,m}'
    = -E_{N,m}',

we obtain

  zeta V_{N,m}'
    = -E_{N,m}' - L(s)(1-E_{N,m}).

Hence

  E_{N,m+1}
    =
    E_{N,m}
    + (1/log N)
      [ E_{N,m}' + L(s)(1-E_{N,m}) ].

This is an exact recurrence for the COMPLETE residual.  No termwise
zero-residue expansion or 1/zeta'(rho) is introduced.

## j=2 consequence

For m=1 -> 2,

  E_{N,2}
    =
    E_{N,1}
    + (1/log N)
      [ E_{N,1}' + L(s)(1-E_{N,1}) ].

Therefore the second-order redesign is controlled globally if one can prove
weighted Sobolev bounds for the complete m=1 residual:

  ||E_{N,1}'||_w = o(log N)

and

  ||L(1-E_{N,1})||_w = o(log N)

(or any quantitatively sufficient variant after exploiting cancellation
between these two terms).

This is strictly preferable to bounding zeta(1/zeta)'' and zero residues
separately.

## Canonical j=2 min-cut

HM2-D2-j2 :=
COMPLETE_RESIDUAL_WEIGHTED_SOBELEV_CONTROL

Required:
establish a weighted-L2 estimate on the COMPLETE combination

  E_{N,1}' + (zeta'/zeta)(1-E_{N,1})

strong enough that division by log N makes it lower-order relative to the
m=1 BCF scale.

The two summands must not be estimated separately near zeros unless their pole
cancellation is retained.

## General recurrence

Iterating

  V_{m+1} = V_m + (1/log N) V_m'

shows that all higher-order mollifiers are generated from V_{N,1} by repeated
application of

  I + (1/log N) d/ds.

Thus the higher-order route is not an independent source of cancellation; it
is a differential smoothing/reshaping of the m=1 residual whose success
depends on weighted derivative control of the complete error.

## Status

HIGHER_ORDER_V_RECURRENCE = GREEN_MATH
COMPLETE_ERROR_RECURRENCE = GREEN_MATH
J2_LAYER_REDUCTION = GREEN_MATH
COMPLETE_RESIDUAL_WEIGHTED_SOBELEV_CONTROL = OPEN_MATH
HM2_D2_J2 = OPEN_MATH
HM2 = IN_PROCESS
HM3 = BUILD_PENDING
HM4 = BLOCKED
DNLimit_EQ_ZERO = false
RH_PROVED = false


## Exact simplification of the Sobolev combination

Using E_{N,1}=1-zeta V_{N,1},

  E_{N,1}'
    = -zeta' V_{N,1} - zeta V_{N,1}'.

Also

  (zeta'/zeta)(1-E_{N,1})
    = (zeta'/zeta)(zeta V_{N,1})
    = zeta' V_{N,1}.

Therefore exactly

  E_{N,1}' + (zeta'/zeta)(1-E_{N,1})
    = - zeta V_{N,1}'.

No zero-set analysis remains in this identity.

Since

  V_{N,1}'(s)
    = - sum_{n<=N} mu(n) w_N(n) log n * n^{-s},

the normalized critical-line quantity

  zeta(s)V_{N,1}'(s)/s

is the Mellin transform of the fixed finite NB vector

  q_N
    := sum_{n<=N} mu(n) w_N(n) log n * rho_n

up to the frozen sign convention.

Hence the weighted-L2 norm is a finite Gram quadratic form:

  || zeta V_{N,1}' ||_w^2
    = ||q_N||_2^2
    = sum_{a,b<=N}
      d_{N,a} d_{N,b} G_{a,b},

where

  d_{N,n} := mu(n) w_N(n) log n.

Therefore HM2-D2-j2 is equivalent to the explicit finite-energy asymptotic

  ||q_N||_2 = o(log N)

or, squared,

  ||q_N||_2^2 = o((log N)^2).

This is now a Gram-energy problem, not a zeta-zero singularity problem.

## Refined canonical min-cut

HM2-D2-j2 :=
LOG_WEIGHTED_MOBIUS_GRAM_ENERGY

Target:

  sum_{a,b<=N}
    mu(a)mu(b) w_N(a)w_N(b)
    log a log b
    G_{a,b}
      = o((log N)^2).

Equivalent target:

  ||q_N||_2^2 = o((log N)^2).

Status:
SOBOLEV_COMBINATION_SIMPLIFIED = GREEN_MATH
ZERO_SINGULARITY_DEPENDENCE = ELIMINATED_FOR_J2_IDENTITY
FINITE_NB_REALIZATION = GREEN_MATH
J2_GRAM_ENERGY_ASYMPTOTIC = OPEN_MATH
