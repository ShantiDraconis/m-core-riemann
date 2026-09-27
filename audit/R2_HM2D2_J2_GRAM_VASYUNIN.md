# R2 — HM2-D2 j2 Gram/Vasyunin reduction

Status: OPEN_MATH / EXACT ARITHMETIC REDUCTION

Parent:
- HM2-D2-j2 = LOG_WEIGHTED_MOBIUS_GRAM_ENERGY
- frozen Gram/Vasyunin formula reused from research/r2/GramAnalytic.md
- weighted modular multistate endpoint reused from
  lean/MCore/RH/NB/WeightedModularMultiStateGap.lean

## 1. j2 coefficient vector

Let

  d_N(n) := mu(n) w_N(n) log n,

with

  w_N(n) := 1 - log n / log N.

The exact j2 energy is

  Q_N
    := ||q_N||_2^2
    = sum_{a,b<=N} d_N(a)d_N(b) G_{a,b}.

HM2-D2-j2 requires

  Q_N = o((log N)^2).

## 2. GCD reduction

Write

  a = d u,
  b = d v,
  gcd(u,v)=1.

The certified Gram formula gives

  G_{a,b} = G_{u,v}/d.

For coprime u,v,

  G_{u,v}
    =
    A(1/u+1/v)
    + (u-v)/(2uv) log(v/u)
    - pi/(2uv) [V(v,u)+V(u,v)],

where

  A := (log(2pi)-gamma)/2.

Therefore Q_N splits exactly into:

  Q_N = Q_elem,N + Q_mod,N,

where Q_elem,N contains the two elementary/smooth pieces and

  Q_mod,N
    :=
    -(pi/2)
    sum_{d,u,v; gcd(u,v)=1}
      d_N(du)d_N(dv)
      [V(v,u)+V(u,v)]
      /(d u v),

with the finite constraints du<=N, dv<=N.

## 3. Same modular geometry, new coefficient weight

This is the SAME coprime modular-torus / rose-bouquet kernel already frozen in
WeightedModularMultiStateGap.  The only change is the coefficient function:

  coeff_j2(N,n)
    := mu(n) w_N(n) log n.

No new Vasyunin kernel, gcd reduction, geometry, or transport theorem is
needed.

Thus HM2-D2-j2 is not a second arithmetic architecture.  It is a new weighted
instance of the existing weighted modular bilinear form.

## 4. Exact far-term target

After the already-used diagonal/near/smooth separation is applied to Q_N, the
new material term has the form

  S_N^(j2)
    :=
    log-scale-normalized sum_{FAR}
      (1/d)
      d_N(du)d_N(dv)
      [V(v,u)+V(u,v)]/(uv).

The exact normalization required by HM2 is chosen so that

  Q_N/(log N)^2 -> 0.

Accordingly the canonical material statement is:

  J2_WEIGHTED_MODULAR_DECAY:
    Q_mod,N = o((log N)^2),

together with elementary-part control

  Q_elem,N = o((log N)^2).

The elementary part is expected to be reducible by the same smooth/diagonal
technology already frozen, but is not promoted here without an explicit
bound.

## 5. Relation to the existing S_N frontier

The original Riemann terminal gap uses the same kernel with coefficient
function c_{N,n}.  HM2-D2-j2 uses

  c_{N,n}^{(j2)} = c_{N,n} * log n

for the BCF linear coefficient c_{N,n}=mu(n)w_N(n).

Hence:

- SAME_KERNEL = true
- SAME_GCD_REDUCTION = true
- SAME_MODULAR_GEOMETRY = true
- SAME_TERMINAL_SHAPE = true
- SAME_NUMERICAL_SEQUENCE = false unless an explicit identification theorem is proved.

Therefore the old WeightedModularBilinearDecay certificate cannot simply be
reused as an inhabitant.  What is reusable is its architecture and all kernel
reductions.

## 6. Canonical min-cut

HM2-D2-j2 now splits into:

J2-ELEM :=
  LOG_WEIGHTED_ELEMENTARY_GRAM_CONTROL

J2-FAR :=
  LOG_WEIGHTED_MODULAR_BILINEAR_DECAY

Required:
  J2-ELEM + J2-FAR
    -> Q_N = o((log N)^2)
    -> HM2-D2-j2.

The only genuinely non-elementary part is J2-FAR.

## Status

J2_GRAM_IDENTITY = GREEN_MATH
J2_GCD_REDUCTION = GREEN_MATH
J2_VASYUNIN_REDUCTION = GREEN_MATH
J2_SAME_MODULAR_KERNEL = GREEN_MATH
J2_ELEMENTARY_CONTROL = BUILD_PENDING
J2_LOG_WEIGHTED_MODULAR_DECAY = OPEN_MATH
HM2_D2_J2 = IN_PROCESS
HM2 = IN_PROCESS
DNLimit_EQ_ZERO = false
RH_PROVED = false
