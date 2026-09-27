# ATK-J2-A1 — Exact Ehm quadratic-form compression for d_N = lambda_N log n

Status: T3 COMPRESSED / FINAL CORE ISOLATED

External source:
Werner Ehm, "On certain Gram matrices and their associated series",
arXiv:2405.06349v2, Section 8, especially equation (49).

## 1. Ehm's exact q=1 decomposition

For arbitrary finite coefficients a_n define

  L_{a,j}(N) := sum_{n<=N} a_n log^j(n)/n,
  M_{a,j}(N) := sum_{n<=N} a_n log^j(n),

and

  E_a^(1)(N)
    := sum_{m<=N} a_m/m
       [ sum_{n<=N} a_n S_1(n/m) - R_1(1/m) ].

Ehm proves the exact identity

  Q_a^(1)(N)
    =
    M_{a,0}(N)
      [ K L_{a,0}(N) + 1/2 (L_{a,1}(N)+1) ]
    - 1/2 M_{a,1}(N)L_{a,0}(N)
    + (gamma-1)L_{a,0}(N)
    - L_{a,1}(N)
    + E_a^(1)(N).

This identity already contains the K, log-ratio, and S_1 pieces and their
exact cancellation bookkeeping.

## 2. Apply to the j2 coefficient sequence

Let

  lambda_{n,N} := mu(n)(1-log n/log N),

and

  d_N(n) := lambda_{n,N} log n.

Then exactly

  L_{d,0} = L_{lambda,1},
  L_{d,1} = L_{lambda,2},
  M_{d,0} = M_{lambda,1},
  M_{d,1} = M_{lambda,2}.

Since lambda is the first finite logarithmic difference of the Mobius
coefficients,

  L_{lambda,j}
    = L_{mu,j} - L_{mu,j+1}/log N,

  M_{lambda,j}
    = M_{mu,j} - M_{mu,j+1}/log N.

Define

  DeltaL_j(N)
    := L_{mu,j}(N) - L_{mu,j+1}(N)/log N,

  DeltaM_j(N)
    := M_{mu,j}(N) - M_{mu,j+1}(N)/log N.

Therefore the COMPLETE j2 Gram energy satisfies the exact identity

  Q_N
    =
    DeltaM_1
      [ K DeltaL_1 + 1/2(DeltaL_2+1) ]
    - 1/2 DeltaM_2 DeltaL_1
    + (gamma-1)DeltaL_1
    - DeltaL_2
    + E_d^(1)(N).

No separate C3_K, C3_log, or C3_S1 calculation is required anymore.

## 3. Known L-side limits

Classical PNT-equivalent Mobius limits give

  L_{mu,0}(N) -> 0,
  L_{mu,1}(N) -> -1,
  L_{mu,2}(N) -> -2 gamma,

and hence

  DeltaL_1(N) -> -1,
  DeltaL_2(N) -> -2 gamma

provided the standard fixed-order weighted limits are used.

These limits by themselves do NOT control the DeltaM_j terms.

## 4. Exact C3 criterion

Define

  A_N :=
    DeltaM_1
      [ K DeltaL_1 + 1/2(DeltaL_2+1) ]
    - 1/2 DeltaM_2 DeltaL_1,

  B_N :=
    (gamma-1)DeltaL_1 - DeltaL_2.

Then exactly

  Q_N = A_N + B_N + E_d^(1)(N).

Since B_N=O(1) under the known L-limits, it contributes zero to log^3 scale.

Thus

  Q_N/(log N)^3 -> 0

is reduced to

  [A_N + E_d^(1)(N)]/(log N)^3 -> 0.

This is the correct T3 ledger compression.

## 5. Irreducible core

Ehm explicitly identifies estimation of the inversion error E_a^(q)(N) as a
major challenge and sets it aside in Section 8.  He also notes that strong
estimates for the relevant L/M differences are "very far away".

Therefore the exact J2-A1 core is:

J2-A1-CORE :=
  MOBIUS_DIFFERENCE_PLUS_INVERSION_ERROR_LOG3_CONTROL

Target:

  A_N + E_d^(1)(N) = o((log N)^3).

To reach HM2-D2-j2 one ultimately needs the stronger

  Q_N = o((log N)^2),

so after log^3 cancellation a further log^2 gain remains.

## 6. Status

EHM_Q1_QUADRATIC_DECOMPOSITION = GREEN_EXTERNAL_EXACT
J2_K_LOG_S1_SEPARATE_LEDGER = SUPERSEDED
J2_COMPLETE_EHM_COMPRESSION = GREEN_MATH
B_N_OVER_LOG3 = GREEN_MATH
A_N_OVER_LOG3 = OPEN_MATH
E_D_INVERSION_ERROR_OVER_LOG3 = OPEN_MATH
C3_EQ_ZERO = OPEN_MATH
J2_B_POST_LOG2_GAIN = BLOCKED
RH_PROVED = false
