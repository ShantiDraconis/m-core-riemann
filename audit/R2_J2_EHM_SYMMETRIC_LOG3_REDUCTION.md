# R2 — J2-A symmetric Gram reduction via Ehm

Status: OPEN_MATH / ANALYTIC REPARAMETRIZATION

External source:
Werner Ehm, "On certain Gram matrices and their associated series", 2024,
arXiv:2405.06349.

For q=1 Ehm gives the exact symmetric representation

  G_{u,v}
    =
    1/(u+v)
    [
      2K
      + (v/u) S1(v/u)
      + (u/v) S1(u/v)
    ],

with

  K = (log(2*pi)-gamma+1)/2,

and reciprocity

  S1(1/r)
    =
    r S1(r)
    + K(1-r)
    + (1/2)(1+r) log r.

This representation is equivalent to the Vasyunin/cotangent formula but keeps
the cancellation structure bundled.

## j2 energy

For

  d_N(n) := mu(n)(1-log n/log N)log n,

the exact j2 energy is

  Q_N = sum_{a,b<=N} d_N(a)d_N(b) G_{a,b}.

After gcd reduction a=g u, b=g v, gcd(u,v)=1,

  G_{a,b}=G_{u,v}/g,

so

  Q_N
    =
    sum_{g,u,v}
      d_N(gu)d_N(gv)
      /(g(u+v))
      [
        2K
        + (v/u)S1(v/u)
        + (u/v)S1(u/v)
      ].

This is now the preferred complete formula for J2-A.

## Why this helps

The previous split into:
- elementary diagonal/smooth terms;
- logarithmic term;
- Vasyunin modular term

creates large pieces separately.  Ehm's symmetric formula packages those pieces
before asymptotics, exactly where cancellation is expected.

Therefore the canonical log^3 coefficient must be extracted from the COMPLETE
symmetric kernel, not from the old split.

## New coefficient target

Define formally

  C3_sym :=
    lim-leading-coefficient of
    Q_N/(log N)^3

computed from the symmetric Ehm kernel above.

J2-A closes if one proves

  C3_sym = 0.

No published theorem located in Ehm's paper states this asymptotic for the
specific log-weighted Mobius coefficients d_N(n).  Ehm provides the exact
kernel decomposition and reciprocity, not the required cancellation theorem.

## Reciprocity reduction

Using

  S1(1/r)
    = rS1(r)+K(1-r)+(1/2)(1+r)log r,

one may reduce the two S1 terms in the symmetric kernel to one orientation,
say r>=1, plus explicit elementary terms.

Thus the remaining J2-A open mathematics can be stated as one oriented
Mobius-bilinear asymptotic involving S1(r).

## Canonical min-cut

J2-A1 :=
ORIENTED_S1_LOG3_COEFFICIENT

Required:
derive the full (log N)^3 coefficient of

  sum_{g,u,v}
    d_N(gu)d_N(gv)
    /(g(u+v))
    [
      2K
      + (v/u)S1(v/u)
      + (u/v)S1(u/v)
    ]

and prove that it vanishes.

## Status

EHM_SYMMETRIC_GRAM_REPRESENTATION = EXTERNAL_EXACT
EHM_RECIPROCITY = EXTERNAL_EXACT
OLD_ELEMENTARY_VASYUNIN_SPLIT = DEPRECATED_FOR_J2_ASYMPTOTIC
J2_COMPLETE_SYMMETRIC_KERNEL = GREEN_REDUCTION
ORIENTED_S1_LOG3_COEFFICIENT = OPEN_MATH
C3_EQ_ZERO = OPEN_MATH
HM2_D2_J2 = IN_PROCESS
HM2 = IN_PROCESS
DNLimit_EQ_ZERO = false
RH_PROVED = false
