# R2 — HM2 central/main-term control

Status: IN_PROCESS / CENTRAL EXPANSION CLOSED

Parent:
- HM1_MATH = GREEN
- HM2 = HIGHER_ORDER_MAIN_TERM_CONTROL

## HM2-A — exact central expansion

For fixed integer m>=1,

  CENTRAL_{N,m}(s)
    =
    sum_{k=0}^m c_k(s) (log N)^(-k),

with the exact coefficients

  c_k(s)
    := binom(m,k) (d^k/ds^k)(1/zeta(s)).

Hence

  c_0(s) = 1/zeta(s),

and for k>=1 each successive term carries one additional factor
(log N)^(-1).

Equivalently,

  1 - zeta(s) CENTRAL_{N,m}(s)
    =
    - sum_{k=1}^m
      binom(m,k)
      zeta(s) (1/zeta)^(k)(s)
      / (log N)^k.

Thus for fixed s away from a zero/pole of zeta,

  1 - zeta(s) CENTRAL_{N,m}(s)
    =
    m * zeta'(s)/zeta(s) * (log N)^(-1)
    + O_{m,s}((log N)^(-2)).

The sign follows from

  (1/zeta)' = -zeta'/zeta^2.

Therefore the dominant central correction is always the k=1 term, independent
of m except for the multiplicative factor m.

## HM2-B — trivial-zero remainder

The fixed-m trivial-zero remainder is

  F_{N,m}(s)
    =
    sum_{n>=1}
      N^(-2n-s)
      /
      ( zeta'(-2n) (-2n-s)^(m+1) ).

For s in any fixed compact subset K of 0<Re(s)<1 avoiding the trivial zeros,
the factor N^(-2n-Re(s)) yields geometric decay in n.

Therefore, provided the standard functional-equation expression for
1/zeta'(-2n) is used only to establish at-most-subexponential growth in n,

  F_{N,m}(s) = O_{K,m}(N^(-2-Re(s)))

uniformly for s in K.

Consequently

  zeta(s) F_{N,m}(s) / (log N)^m

is asymptotically smaller than the k=1 central correction on fixed compact
subsets of the strip.

This is the only HM2-B claim recorded here.  No global-in-t weighted-L2 claim
is promoted; that belongs to HM3.

## HM2-C — compatibility

For m=1,

  CENTRAL_{N,1}(s)
    =
    1/zeta(s)
    + (1/log N)(1/zeta)'(s),

and

  1 - zeta(s) CENTRAL_{N,1}(s)
    =
    (1/log N) zeta'(s)/zeta(s),

which is exactly the BCF central term.

For every fixed m, the expansion agrees with the coefficient extraction from

  e^{w log N} / zeta(s+w)

at order w^m, hence is consistent with the HM1 contour representation.

## HM2 conclusion so far

HM2-A = GREEN_MATH
HM2-B_FIXED_COMPACT = GREEN_MATH
HM2-C = GREEN_MATH

The unresolved HM2 content is not the central residue anymore.

The remaining question is the mixed/main contribution after combining:
- the k=1 central logarithmic-derivative term;
- the higher k>=2 central terms;
- the non-trivial-zero residue sum.

Canonical next sub-delta:

HM2-D := HIGHER_ORDER_MIXED_MAIN_TERM_CONTROL

Required:
show that after the natural normalization, the complete mixed term has an
explicit leading asymptotic and that the added k>=2 central terms do not create
a larger non-vanishing contribution.

No RH, simplicity, or negative zeta'-moment hypothesis may be used.

## Status

HM2_A_CENTRAL_EXPANSION = GREEN_MATH
HM2_B_TRIVIAL_REMAINDER_FIXED_COMPACT = GREEN_MATH
HM2_C_COMPATIBILITY = GREEN_MATH
HM2_D_MIXED_MAIN_TERM = OPEN_MATH
HM2 = IN_PROCESS
HM3 = BUILD_PENDING
HM4 = BLOCKED
DNLimit_EQ_ZERO = false
RH_PROVED = false
