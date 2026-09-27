# R2 — HM2-D higher-order mixed main-term control

Status: IN_PROCESS / LOCAL PRINCIPAL-PART CANCELLATION DERIVED

Parent:
- HM1_MATH = GREEN
- HM2-A/B/C = GREEN_MATH
- HM2-D = HIGHER_ORDER_MIXED_MAIN_TERM_CONTROL

## 1. Complete bracket is the only valid object near non-trivial zeros

Recall

  B_{N,m}(s)
    =
    - sum_{j=1}^m
      (log N)^(m-j)/(j!(m-j)!)
      zeta(s) (1/zeta)^(j)(s)
    - zeta(s) sum_rho R_{N,m}(rho,s)
    - zeta(s) F_{N,m}(s).

The individual central terms with j>=2 are more singular at a zero than the
m=1 logarithmic-derivative term.  They therefore cannot be estimated
separately.

Let rho be a simple zero and write u=s-rho.  Then

  zeta(s) = zeta'(rho) u + O(u^2),

and

  (1/zeta)^(j)(s)
    = (-1)^j j!/(zeta'(rho) u^(j+1))
      + O(u^(-j)).

Hence

  zeta(s) (1/zeta)^(j)(s)
    = (-1)^j j! u^(-j) + O(u^(-(j-1))).

Therefore the j-th central contribution has principal part

  - (-1)^j
    (log N)^(m-j)/(m-j)!
    u^(-j).

For the same zero,

  R_{N,m}(rho,s)
    =
    N^(rho-s)/
    (zeta'(rho) (rho-s)^(m+1))

for a simple zero, and multiplying by zeta(s) gives

  zeta(s) R_{N,m}(rho,s)
    =
    (-1)^(m+1)
    e^(-u log N)
    u^(-m)
    + lower Laurent terms.

Expanding

  e^(-u log N)
    = sum_{r>=0} (-log N)^r u^r/r!

shows that the residue contribution generates the entire pole ladder

  u^(-m), u^(-(m-1)), ..., u^(-1)

with coefficients exactly of the same combinatorial form as the central
derivative ladder.

Thus the pole ladder from j=1,...,m is cancelled by the local Laurent expansion
of the rho-residue contribution in the COMPLETE bracket.

## 2. Structural conclusion

The higher-order central terms do NOT create independent new singular main
terms.  Their apparent higher-order poles are artifacts of splitting the
complete bracket.

For every simple non-trivial zero rho,

  B_{N,m}(s)

has removable singularity at s=rho after combining:
- all central derivative terms j=1,...,m;
- the local rho-residue term.

This is forced independently by the identity

  B_{N,m}(s)
    = (log N)^m/m! * [1-zeta(s)V_{N,m}(s)],

whose right-hand side is holomorphic at non-trivial zeros.

## 3. Multiple zeros

For a zero of multiplicity q>1, the simple-zero formula for R_{N,m} is not
valid.  However the contour-defined residue and the exact identity still imply
that the sum of all Laurent principal parts cancels in the complete bracket.

A kernel-level proof must use the contour-defined residue or a general Laurent
coefficient lemma, not zeta'(rho).

Status:
MULTIPLE_ZERO_PRINCIPAL_PART_CANCELLATION = DERIVED_FROM_EXACT_IDENTITY
EXPLICIT_MULTIPLICITY_FORMULA = BUILD_PENDING

## 4. What remains of HM2-D

The local singularity question is now closed.  The unresolved HM2-D content is
global/mean-square:

HM2-D2 := HIGHER_ORDER_GLOBAL_MIXED_ASYMPTOTIC

Required:
prove that after integrating the complete bracket in the weighted critical-line
norm, the j>=2 central/residue interactions are lower order than the j=1 mixed
contribution, or otherwise compute their combined leading asymptotic.

No term may be estimated before the local pole cancellation has been combined.

## 5. Status

HM2_D_LOCAL_POLE_LADDER = GREEN_MATH
HM2_D_SIMPLE_ZERO_CANCELLATION = GREEN_MATH
HM2_D_MULTIPLE_ZERO_CANCELLATION = GREEN_MATH_ABSTRACT
HM2_D_GLOBAL_MIXED_ASYMPTOTIC = OPEN_MATH
HM2 = IN_PROCESS
HM3 = BUILD_PENDING
HM4 = BLOCKED
DNLimit_EQ_ZERO = false
RH_PROVED = false
