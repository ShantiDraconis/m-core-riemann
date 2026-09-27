# R2 — Fixed-length BCF height-truncation tradeoff

Status: OPEN_MATH / NO-GO REFINEMENT

## Statement

For the fixed BCF linear mollifier of length N, a single truncation height T
cannot simultaneously satisfy the currently available complement and tail
requirements.

### Complement side (B)

The available canonical-product control has size of the form

  log |P(s,rho)| <= C (log T)^2 log log T

away from zero neighborhoods.

To keep this sub-polynomial in N strongly enough for the dyadic beta-slices,
one is driven toward log T = o(sqrt(log N)), in particular polylogarithmic
heights are natural.

### Tail side (C)

For the fixed length-N Dirichlet polynomial, unconditional pointwise/mean-value
bounds carry losses depending polynomially on N.  With the current estimates,
the weighted tail cannot be forced to o((log N)^2) at polylogarithmic height;
one is driven to T >= N^c for some c>0.

### Conflict

Polylogarithmic T is required by the present complement bound, while polynomial
T is required by the present tail bound.  Hence there is no single T in the
current proof architecture that closes both regions.

This is an audit of the current estimate package, not a theorem that every
possible fixed-coefficient mollifier must fail.

## Invalid redesign already excluded

A t-dependent support/coefficient cutoff is not admissible in the current
BCF/Nyman-Beurling chain because it:
- destroys holomorphy in s needed for contour shifting;
- no longer corresponds to one fixed finite NB vector.

See R2_T_DEPENDENT_MOLLIFIER_NOGO.md.

## Remaining legitimate routes

1. Higher-order fixed-coefficient holomorphic mollifier:
   V_{N,m}(s) with logarithmic weight power m>=2.

2. Direct weighted-L2 duality/operator route:
   avoid a hard split at a single height T and estimate the complete BCF
   bracket in the target Hilbert norm.

3. Any other fixed-coefficient holomorphic family with a proved NB realization
   and a rigorously derived contour identity.

## Canonical delta

R-ZR1-M1b-(B/C)-TRADEOFF := FIXED_LENGTH_HEIGHT_SPLIT_NO_GO_CURRENT_BOUNDS

Status:
- CURRENT_SINGLE_T_SPLIT = RED
- T_DEPENDENT_MOLLIFIER = RED
- HIGHER_ORDER_HOLOMORPHIC_ROUTE = OPEN_MATH
- DUALITY_OPERATOR_ROUTE = OPEN_MATH
- DNLimit_EQ_ZERO = false
- RH_PROVED = false
