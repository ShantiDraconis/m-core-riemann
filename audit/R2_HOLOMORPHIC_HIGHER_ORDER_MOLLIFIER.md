# R2 — Holomorphic higher-order logarithmic mollifier redesign

Status: OPEN_MATH / VALID REDESIGN CANDIDATE

## Objective

Replace the rejected t-dependent cutoff by a fixed-coefficient holomorphic
Dirichlet polynomial that still represents one admissible Nyman-Beurling
approximant.

For an integer m >= 1 define

  w_{N,m}(n) := (1 - log n / log N)^m  for 1 <= n <= N,

and

  V_{N,m}(s) := sum_{n<=N} mu(n) w_{N,m}(n) n^{-s}.

For each fixed N,m this is an entire Dirichlet polynomial with coefficients
independent of Im(s).  Hence:

- BCF-style contour shifts remain legitimate;
- V_{N,m}(1/2+it) is the Mellin-side polynomial of one fixed finite NB vector.

The case m=1 recovers the BCF linear mollifier.

## Perron/Mellin representation

For m >= 1,

  (1 - log n/log N)^m_+
    = m!/(2 pi i (log N)^m)
      int_{(c)} (N/n)^w dw / w^(m+1).

Therefore

  V_{N,m}(s)
    = m!/(2 pi i (log N)^m)
      int_{(c)} N^w / ( zeta(s+w) w^(m+1) ) dw.

After z=s+w this becomes

  V_{N,m}(s)
    = m!/(2 pi i (log N)^m)
      int N^(z-s) / ( zeta(z) (z-s)^(m+1) ) dz.

Thus shifting the contour generates zero residues

  R_{N,m}(rho,s)
    := Res_{z=rho}
       N^(z-s)/( zeta(z) (z-s)^(m+1) ).

For a simple zero rho,

  R_{N,m}(rho,s)
    = N^(rho-s)/
      ( zeta'(rho) (rho-s)^(m+1) ).

Compared with m=1, the height kernel gains m-1 extra powers of
|rho-s|^{-1}.  This is the intended tail improvement.

## Central residue at z=s

The pole at z=s has order m+1.  Its residue is a finite expression involving
the first m derivatives at s of N^(z-s)/zeta(z).

Equivalently, the BCF bracket generalizes from

  zeta'/zeta - zeta * sum R_{N,1} - zeta F

to a finite differential polynomial

  B_{N,m}(s)
    := C_m[s; zeta'/zeta, ..., d^m log zeta]
       - zeta(s) * sum_rho R_{N,m}(rho,s)
       - zeta(s) * F_{N,m}(s),

with normalization (log N)^(-m).

The exact C_m and F_{N,m} must be derived and audited before promotion.

## NB realization

Define the fixed finite NB vector

  v_{N,m} := - sum_{n<=N} mu(n) w_{N,m}(n) rho_n.

Its Mellin residual is

  M(chi-v_{N,m})(s)
    = [1 - zeta(s)V_{N,m}(s)]/s.

Therefore any unconditional estimate

  ||chi-v_{N,m}||_2^2 <= eps_N,
  eps_N -> 0,

is a legitimate BCFZeroResidueControl input for DN_N by best approximation.

No new DN bridge is needed.

## Expected gain and what is NOT yet proved

For simple zeros the residue kernel is now

  |rho-s|^{-(m+1)}

instead of |rho-s|^{-2}.

This improves:
- the high-|t-gamma| tail;
- local summability over zeros;
- the B/C height tradeoff.

It does NOT by itself remove:
- the off-critical factor N^(beta-1/2);
- reciprocal zeta'(rho) at a simple zero;
- multiplicity issues;
- the need to control the complete bracket.

Hence the redesign is valid but not yet a closure theorem.

## Canonical sub-deltas

R-ZR1-HM1 := HIGHER_ORDER_BCF_IDENTITY
  Derive the exact unconditional contour identity for general m and prove the
  m=1 specialization matches the frozen BCF identity.

R-ZR1-HM2 := HIGHER_ORDER_MAIN_TERM_CONTROL
  Determine the central/mixed main term after contour shift and prove that the
  strengthened kernel does not introduce a new nonvanishing obstruction.

R-ZR1-HM3 := HIGHER_ORDER_TAIL_GAIN
  Prove that for some fixed or slowly growing m=m(N), the weighted L2 tail is
  o((log N)^(2m)) after the natural normalization.

R-ZR1-HM4 := OFF_CRITICAL_HIGH_BETA_CONTROL
  Control beta>1/2 contributions in the complete higher-order bracket without
  RH, simplicity assumptions, or termwise absolute values.

## Design choices

Two regimes are admissible:

1. fixed m >= 2:
   simplest contour identity and fixed NB family;

2. slowly growing integer m=m(N):
   still one fixed polynomial for each N and still holomorphic, but every
   asymptotic estimate must be uniform in m.

The growing-m route may create factorial/derivative losses from the central
residue and must be audited separately.

## Status

T_DEPENDENT_MOLLIFIER = REJECTED
FIXED_COEFFICIENT_HIGHER_ORDER_MOLLIFIER = VALID_CANDIDATE
HOLOMORPHY = PRESERVED
FIXED_NB_REALIZATION = PRESERVED
HIGHER_ORDER_BCF_IDENTITY = OPEN_MATH
HIGHER_ORDER_MAIN_TERM_CONTROL = OPEN_MATH
HIGHER_ORDER_TAIL_GAIN = OPEN_MATH
OFF_CRITICAL_HIGH_BETA_CONTROL = OPEN_MATH
DNLimit_EQ_ZERO = false
RH_PROVED = false
