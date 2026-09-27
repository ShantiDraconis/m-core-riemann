# R2 — HM2 j2 elementary/far split correction

Status: STRUCTURAL CORRECTION / OPEN_MATH

Parent:
- HM2-D2-j2 = LOG_WEIGHTED_MOBIUS_GRAM_ENERGY
- previous split:
    J2-ELEM := LOG_WEIGHTED_ELEMENTARY_GRAM_CONTROL
    J2-FAR  := LOG_WEIGHTED_MODULAR_BILINEAR_DECAY

## 1. Why the previous separate-o(log^2 N) targets are too strong

Let

  d_N(n) := mu(n) (1 - log n/log N) log n.

The j2 energy is

  Q_N = sum_{a,b<=N} d_N(a)d_N(b) G_{a,b}.

On the diagonal a=b=n, gcd reduction gives

  G_{n,n} = G_{1,1}/n.

Hence the diagonal contribution is

  Q_diag,N
    = G_{1,1}
      sum_{n<=N}
      mu(n)^2
      (1 - log n/log N)^2
      (log n)^2 / n.

Using the standard squarefree density asymptotic

  sum_{n<=x} mu(n)^2 = (6/pi^2)x + O(sqrt(x)),

partial summation gives

  sum_{n<=N}
    mu(n)^2
    (1 - log n/log N)^2
    (log n)^2 / n
      ~ (6/pi^2) (log N)^3
         int_0^1 y^2(1-y)^2 dy

and

  int_0^1 y^2(1-y)^2 dy = 1/30.

Therefore

  Q_diag,N
    ~ G_{1,1} /(5 pi^2) * (log N)^3.

In particular,

  Q_diag,N is NOT o((log N)^2).

So the previous requirement

  Q_elem,N = o((log N)^2)

cannot be correct if Q_elem contains the diagonal piece.

## 2. Consequence

Any proof of

  Q_N = o((log N)^2)

must exhibit cancellation between:
- the diagonal / elementary Gram terms;
- the off-diagonal smooth logarithmic terms;
- the Vasyunin modular term.

Thus the Vasyunin piece is not merely a small remainder for the j2-weighted
energy.  It must participate in cancellation of an order-(log N)^3 leading
piece.

## 3. Correct canonical target

Replace the invalid split

  J2-ELEM + J2-FAR

by the COMPLETE renormalized j2 Gram cancellation:

  J2-COMPLETE :=
  LOG_WEIGHTED_COMPLETE_GRAM_CANCELLATION

Target:

  Q_N
    = sum_{a,b<=N} d_N(a)d_N(b) G_{a,b}
    = o((log N)^2).

Equivalent renormalized form:

  Q_N/(log N)^3 -> 0

with an additional one-power gain required to reach the HM2 target
Q_N=o((log N)^2).

The first task is therefore to compute the full order-(log N)^3 coefficient
across all Gram components and prove that it cancels.

## 4. New min-cut

J2-A :=
  FULL_LOG3_COEFFICIENT_CANCELLATION

Required:
extract the coefficient C_3 in

  Q_N = C_3 (log N)^3 + lower-order terms

and prove

  C_3 = 0

using the COMPLETE Gram/Vasyunin identity.

J2-B :=
  POST_CANCELLATION_LOG2_GAIN

Required after J2-A:
prove the remaining term is o((log N)^2), not merely O((log N)^2).

## Status

J2_DIAGONAL_ASYMPTOTIC = DERIVED
J2_SEPARATE_ELEMENTARY_VANISHING = RED
J2_SEPARATE_FAR_VANISHING = NOT_SUFFICIENT
J2_COMPLETE_GRAM_CANCELLATION = OPEN_MATH
J2_LOG3_COEFFICIENT_CANCELLATION = OPEN_MATH
J2_POST_CANCELLATION_LOG2_GAIN = OPEN_MATH
HM2_D2_J2 = IN_PROCESS
HM2 = IN_PROCESS
DNLimit_EQ_ZERO = false
RH_PROVED = false
