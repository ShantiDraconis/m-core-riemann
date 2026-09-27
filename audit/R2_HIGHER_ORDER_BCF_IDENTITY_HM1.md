# R2 — Higher-order BCF identity (HM1)

Status: DERIVED_FORMULA / CONTOUR JUSTIFICATION TO CERTIFY

Parent route:
- R-ZR1-HM1 = HIGHER_ORDER_BCF_IDENTITY
- candidate: V_{N,m}(s) with fixed coefficients and m >= 1

## 1. Fixed holomorphic mollifier

For integer m >= 1 define

  V_{N,m}(s)
    := sum_{n<=N} mu(n)
       (1 - log n / log N)^m
       n^{-s}.

For fixed N,m this is an entire Dirichlet polynomial and is the Mellin-side
polynomial of one fixed finite Nyman-Beurling vector.

## 2. Perron representation

Using the standard Mellin/Perron kernel for the m-th logarithmic taper,

  (1-x)^m_+
    = m!/(2 pi i)
      int_{(c)} e^{w log(1/x)} dw / w^(m+1),

one obtains

  V_{N,m}(s)
    = m!/(2 pi i (log N)^m)
      int_{(c)}
      N^w / (zeta(s+w) w^(m+1)) dw.

With z=s+w,

  V_{N,m}(s)
    = m!/(2 pi i (log N)^m)
      int
      N^(z-s) / (zeta(z) (z-s)^(m+1)) dz.

## 3. Central residue z=s

Write f(s):=1/zeta(s).  Around w=0,

  e^{w log N} f(s+w)
    = sum_{r>=0} A_r(s,N) w^r.

The central residue is

  m!/(log N)^m * A_m(s,N).

Coefficient extraction gives the exact closed formula

  CENTRAL_{N,m}(s)
    =
    sum_{j=0}^m
      binom(m,j)
      f^(j)(s) / (log N)^j.

Hence

  CENTRAL_{N,m}(s)
    =
    1/zeta(s)
    + sum_{j=1}^m
      binom(m,j)
      (d^j/ds^j)(1/zeta(s))
      / (log N)^j.

No Bell-polynomial placeholder is needed at HM1: the derivative polynomial
only appears after multiplying by zeta and rewriting derivatives of 1/zeta
in terms of logarithmic derivatives.

## 4. Zero residues

For every non-trivial zero rho, define

  R_{N,m}(rho,s)
    := Res_{z=rho}
       N^(z-s) /
       (zeta(z) (z-s)^(m+1)).

For a simple zero,

  R_{N,m}(rho,s)
    =
    N^(rho-s) /
    (zeta'(rho) (rho-s)^(m+1)).

For a zero of multiplicity q>1, R_{N,m} is defined by the residue expression
itself; no simplicity assumption is required in the identity.

## 5. Higher-order BCF identity

After the same contour deformation used in the BCF m=1 identity, the expected
general identity is

  V_{N,m}(s)
    =
    CENTRAL_{N,m}(s)
    + m!/(log N)^m
      [ sum_rho R_{N,m}(rho,s) + F_{N,m}(s) ],

where F_{N,m}(s) denotes the contribution of the remaining poles / displaced
contour (trivial-zero/entire remainder sector).

Equivalently,

  1 - zeta(s)V_{N,m}(s)
    =
    - sum_{j=1}^m
        binom(m,j)
        zeta(s) (d^j/ds^j)(1/zeta(s))
        / (log N)^j
    - m! zeta(s)/(log N)^m
        [sum_rho R_{N,m}(rho,s)+F_{N,m}(s)].

Define the normalized complete bracket

  B_{N,m}(s)
    := (log N)^m/m! * [1-zeta(s)V_{N,m}(s)].

Then

  B_{N,m}(s)
    =
    - sum_{j=1}^m
      (log N)^(m-j)/(j!(m-j)!)
      zeta(s) (d^j/ds^j)(1/zeta(s))
    - zeta(s) sum_rho R_{N,m}(rho,s)
    - zeta(s) F_{N,m}(s).

This is the exact HM1 algebraic form.

## 6. m=1 specialization check

For m=1,

  CENTRAL_{N,1}(s)
    = 1/zeta(s)
      + (1/log N)(1/zeta)'(s)

    = 1/zeta(s)
      [1 - (1/log N) zeta'(s)/zeta(s)].

Also,

  B_{N,1}(s)
    = -zeta(s)(1/zeta)'(s)
      - zeta(s) sum_rho R_{N,1}(rho,s)
      - zeta(s)F_{N,1}(s)

    = zeta'(s)/zeta(s)
      - zeta(s) sum_rho R_{N,1}(rho,s)
      - zeta(s)F_{N,1}(s),

which is exactly the frozen BCF bracket.

Therefore:

  HM1_M1_SPECIALIZATION = PASS.

## 7. What remains before HM1 can be promoted GREEN

The algebraic coefficient extraction is complete.  The remaining HM1 work is
analytic/provenance:

1. justify the higher-order Perron representation with the exact endpoint
   convention used by the finite sum;
2. repeat/audit the BCF contour shift for pole order m+1;
3. identify F_{N,m}(s) explicitly and prove its analyticity/decay properties;
4. justify convergence/order of the complete zero-residue sum for the contour
   identity;
5. verify all signs/orientations against the published m=1 formula.

No RH, simplicity, or negative zeta'-moment assumption is allowed in HM1.

## 8. Status

HIGHER_ORDER_CENTRAL_RESIDUE = DERIVED
HIGHER_ORDER_ZERO_RESIDUE_FORM = DERIVED
M1_SPECIALIZATION = VERIFIED_ALGEBRAICALLY
HIGHER_ORDER_CONTOUR_SHIFT = OPEN_ANALYTIC_CERTIFICATION
HIGHER_ORDER_REMAINDER = OPEN_ANALYTIC_CERTIFICATION
HM1 = IN_PROCESS
HM2 = BLOCKED_BY_HM1_CERTIFICATION
DNLimit_EQ_ZERO = false
RH_PROVED = false
