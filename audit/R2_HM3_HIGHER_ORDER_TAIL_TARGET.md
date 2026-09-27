# R2 — HM3 Higher-Order Tail Gain

Status: BUILD_PENDING / MATHEMATICAL CLAIM TO KERNEL-CHECK

Parent:
- HM1 = higher-order BCF identity
- HM2 = higher-order main-term control
- HM3 = higher-order tail gain
- HM4 = off-critical high-beta control

## Exact HM3 target

For a fixed integer m >= 2 and the higher-order BCF kernel

  R_{N,m}(rho,s)
    = Res_{z=rho}
      N^(z-s) / (zeta(z) (z-s)^(m+1)),

prove an unconditional weighted-L2 tail estimate strong enough that the
contribution of |t| > T tends to zero after the natural (log N)^(-m)
normalization.

A canonical quantitative form is:

  Tail_{N,m}(T)
    := integral_{|t|>T}
       |B_{N,m}(1/2+it)|^2 / (1/4+t^2) dt

and prove that for some admissible T=T(N) -> infinity,

  Tail_{N,m}(T(N)) = o((log N)^(2m)).

Equivalently,

  Tail_{N,m}(T(N)) / (log N)^(2m) -> 0.

## Required analytic ingredients

The kernel gain for m>=2 gives

  |rho-s|^(-(m+1))

instead of the BCF m=1 power |rho-s|^(-2).

A valid proof must explicitly account for:
- all non-trivial zeros in the tail;
- zero multiplicity;
- convergence of the contour-defined zero sum;
- the trivial-zero/entire remainder;
- any zeta-growth factors introduced by the complete bracket;
- uniformity in N for fixed m.

## Firewall

The following are insufficient for HM3 promotion:
- a pointwise termwise bound that assumes simplicity;
- a finite-height computation;
- an estimate conditional on RH;
- a bound only on the residue sum while ignoring the complete bracket;
- a prose asymptotic without an explicit dominating function / summability proof.

## Promotion rule

HM3 can be marked GREEN only when a Lean theorem (or a mathematically complete
audited theorem with all hypotheses explicit, pending mechanical port) proves
the normalized tail tends to zero.

Current:
HM3_CLAIMED_EXTERNALLY_BY_USER = true
HM3_KERNEL_VERIFIED = false
HM3 = BUILD_PENDING
HM4 = BLOCKED_BY_HM2_HM3
DNLimit_EQ_ZERO = false
RH_PROVED = false
