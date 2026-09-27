# ATK-J2-A1 — ORIENTED_S1_LOG3_COEFFICIENT

Status: T1 GREEN / T2 GREEN / T3 OPEN_MATH

External source:
Werner Ehm, "On certain Gram matrices and their associated series", 2024,
arXiv:2405.06349.

## T1 — Frozen definitions

Assume N >= 2.

### (a) Exact d_N and support

For n in Nat define

  d_N(n) :=
    if 1 <= n and n <= N then
      mu(n) * (1 - log(n)/log(N)) * log(n)
    else
      0.

Equivalently, all sums below are over 1 <= n <= N and use

  d_N(n) = mu(n) (1 - log n/log N) log n.

### (b) K

K is the real constant

  K := (log(2*pi) - gamma + 1)/2,

where gamma is Euler's constant.

### (c) S_1 and reciprocity

For x>0 define

  R_1(x)
    := log x + gamma - H(x) - ({x}-1/2)/x,

where

  H(x) := sum_{1 <= k <= x} 1/k

and {x}=x-floor(x).

Then

  S_1(x) := sum_{k>=1} R_1(kx),   x>0.

Ehm proves absolute convergence and continuity for every x>0, with
S_1(x)=O(x^-2) as x->infinity.

Exact reciprocity, for every r>0:

  S_1(1/r)
    = r S_1(r)
      + K(1-r)
      + (1/2)(1+r) log r.

There is NO error term in this identity.

### (d) Exact Q_N ranges

Let G^{(1)} be the q=1 Nyman-Beurling Gram kernel.

The j2 energy is

  Q_N
    := sum_{1<=a<=N} sum_{1<=b<=N}
         d_N(a)d_N(b) G^{(1)}_{a,b}.

Using a=g u, b=g v with

  g >= 1,
  u >= 1,
  v >= 1,
  gcd(u,v)=1,
  gu <= N,
  gv <= N,

and G_{gu,gv}=G_{u,v}/g,

  Q_N
    =
    sum_{g>=1}
    sum_{u,v>=1; gcd(u,v)=1; gu<=N; gv<=N}
      d_N(gu)d_N(gv) G^{(1)}_{u,v}/g.

Ehm's exact symmetric formula is

  G^{(1)}_{u,v}
    =
    1/(u+v)
    [
      2K
      + (v/u) S_1(v/u)
      + (u/v) S_1(u/v)
    ].

### (e) Frozen C3 definition

We do NOT assume an asymptotic expansion exists.

Define the proposition

  HasC3(c) : Prop :=
    lim_{N->infinity} Q_N/(log N)^3 = c.

If there exists a unique c satisfying HasC3(c), call that c C3.

Thus J2-A1 must prove existence of the limit before assigning a numerical
value to C3.

The target C3_EQ_ZERO is the conjunction:

  HasC3(0).

No hidden assumption of existence is allowed.

## T2 — Exact oriented folding

Because Q_N is symmetric in u,v, split into:
- diagonal u=v;
- off-diagonal u<v and double it.

Since gcd(u,v)=1, diagonal u=v forces u=v=1.

Therefore

  Q_diag,N
    =
    G^{(1)}_{1,1}
    sum_{1<=g<=N} d_N(g)^2/g.

For the off-diagonal part orient v>u and put

  r := v/u > 1.

Start from Ehm's symmetric bracket

  G^{(1)}_{u,v}
    =
    1/(u+v)
    [
      2K + r S_1(r) + r^-1 S_1(r^-1)
    ].

Apply exact reciprocity:

  r^-1 S_1(r^-1)
    =
    S_1(r)
    + K(r^-1-1)
    + (1/2)(1+r^-1) log r.

Hence

  2K + rS_1(r) + r^-1S_1(r^-1)
    =
    (1+r) S_1(r)
    + K(1+r)/r
    + (1+r)/(2r) log r.

Since

  u+v = u(1+r),
  ur = v,

this simplifies EXACTLY to

  G^{(1)}_{u,v}
    =
    S_1(v/u)/u
    + K/v
    + (1/(2v)) log(v/u),

for v>u.

This is Ehm Theorem 2.1, recovered from the symmetric representation and
reciprocity.

There is no reciprocity error term.

Thus

  Q_N
    =
    Q_diag,N
    + Q_S1,N
    + Q_K,N
    + Q_log,N,

where

  Q_diag,N
    :=
    G^{(1)}_{1,1}
    sum_{g<=N} d_N(g)^2/g,

  Q_S1,N
    :=
    2 sum_{g>=1}
      sum_{1<=u<v; gcd(u,v)=1; gv<=N}
        d_N(gu)d_N(gv)
        S_1(v/u)/(g u),

  Q_K,N
    :=
    2K sum_{g>=1}
      sum_{1<=u<v; gcd(u,v)=1; gv<=N}
        d_N(gu)d_N(gv)/(g v),

  Q_log,N
    :=
    sum_{g>=1}
      sum_{1<=u<v; gcd(u,v)=1; gv<=N}
        d_N(gu)d_N(gv)
        log(v/u)/(g v).

All ranges are finite because gv<=N.

## T3 — log^3 ledger

Define, only when the corresponding limits exist,

  C3_diag := lim Q_diag,N/(log N)^3,
  C3_S1   := lim Q_S1,N/(log N)^3,
  C3_K    := lim Q_K,N/(log N)^3,
  C3_log  := lim Q_log,N/(log N)^3.

Then, if all four limits exist,

  C3 = C3_diag + C3_S1 + C3_K + C3_log.

The diagonal contribution is already derived:

  C3_diag = G^{(1)}_{1,1}/(5*pi^2).

The remaining three limits are NOT yet proved to exist and are the exact
OPEN_MATH content of J2-A1.

No cancellation claim is made until these limits are evaluated.

## Status

T1_DEFINITIONS = GREEN
T1_RECIPROCITY_EXACT_NO_ERROR = GREEN
T2_ORIENTED_FOLDING = GREEN
T2_DIAGONAL_ONCE = GREEN
T2_EXPLICIT_RECIPROCITY_TERMS = GREEN
T3_DIAGONAL_LOG3 = GREEN_MATH
T3_S1_LOG3 = OPEN_MATH
T3_K_LOG3 = OPEN_MATH
T3_LOG_RATIO_LOG3 = OPEN_MATH
C3_LIMIT_EXISTENCE = OPEN_MATH
C3_EQ_ZERO = OPEN_MATH
T4_VERDICT = BLOCKED_BY_T3
