# R2 — DNLimit = 0 attack

Base: R1 GREEN_EXTERNAL_INTERFACE @ 53d97bc0a3e64de419f4214625ae75a9e1ecb178

Scientific status:
- target: concreteNBData.DNLimit concreteGeneratorFamily = 0
- dnlimit_eq_zero_proved = false
- rh_proved = false
- no Lean theorem is emitted in R2 until an unconditional L2 upper bound is obtained.

## Exact reduction

For N >= 1 let V_N be the span of the first N concrete generators rho_1,...,rho_N and

d_N := || chi - P_{V_N} chi ||_2,
DN_N := d_N^2.

For any explicit coefficient vector c_{N,1},...,c_{N,N}, define

v_N := sum_{k=1}^N c_{N,k} rho_k,
E_N := ||chi - v_N||_2.

Because P_{V_N} chi is the best approximation from V_N,

d_N <= E_N
and therefore
DN_N <= E_N^2.

Hence an unconditional construction satisfying E_N -> 0 is sufficient to prove DNLimit = 0.
By R1 this is already equivalent to RH, so obtaining such a bound is the genuine open mathematics.

## Rate sanity check

Burnol's lower-bound work on the Nyman-Beurling approximation gives a nontrivial lower floor of order 1/log N for the squared distance (in the corresponding finite-parameter formulation, with zeros contributing to the constant). Therefore any proposed asymptotic upper bound for DN_N that is o(1/log N) is immediately suspect/incompatible with the known lower-bound regime.

Practical target family:
  DN_N <= C / log N
or more weakly any explicit epsilon_N -> 0.

Equivalent residual target:
  d_N <= sqrt(C/log N).

## Route audit

### A. Direct optimal-projection upper bound
Status: OPEN_CORE
Task:
  prove DN_N <= epsilon_N with epsilon_N -> 0.
Comment:
  this is exactly the frontier, not a technical corollary.

### B. Damped Möbius approximants of Báez-Duarte
Candidate:
  v_N = - sum_{a<=N} mu(a) exp(-c log a / log log N) rho_a.
Published estimate:
  distance = O((log log N)^(-1/3)).
Fatal issue for R2:
  the published estimate is conditional on RH.
Classification: CIRCULAR_CONDITIONAL_ROUTE.
Do not use as an unconditional proof.

Primary source:
- L. Báez-Duarte, "A strengthening of the Nyman-Beurling criterion for the Riemann hypothesis, 2"
  arXiv:math/0205003
  https://arxiv.org/abs/math/0205003

### C. Natural Möbius approximants without damping
Status: HIGH_RISK_L2
Known warning:
  natural Beurling/Möbius sequences may converge pointwise and in L1 yet fail to converge in L2.
Classification: NO_PROMOTION_WITHOUT_NEW_L2_BOUND.

Primary source:
- L. Báez-Duarte, "Arithmetical Aspects of Beurling's Real Variable Reformulation of the Riemann Hypothesis"
  arXiv:math/0011254
  https://arxiv.org/abs/math/0011254

### D. Burnol lower-bound / zero-vector route
Status: NECESSARY_RATE_INFORMATION_ONLY
Use:
  constrains possible decay rates and can falsify over-strong claimed upper bounds.
Does not supply:
  an upper bound tending to zero.

Primary source:
- J.-F. Burnol, "A lower bound in an approximation problem involving the zeros of the Riemann zeta function"
  arXiv:math/0103058
  https://arxiv.org/abs/math/0103058

### E. Numerical Gram / finite projection experiments
Status: MODEL_EVIDENCE_ONLY
Useful outputs:
- exact or interval-certified DN_N for finite N;
- optimal finite coefficients;
- candidate asymptotic fits;
- adversarial comparison with 1/log N.
Cannot prove:
- DNLimit = 0 from finitely many N.

## Minimal research computation to run next

For N in an increasing schedule:
1. compute or interval-bound the Gram matrix G_N = (<rho_j,rho_k>)_{1<=j,k<=N};
2. compute b_N = (<chi,rho_k>)_{1<=k<=N};
3. solve G_N c_N = b_N with certified intervals / rational enclosures where feasible;
4. evaluate
     DN_N = ||chi||^2 - b_N^T G_N^{-1} b_N
   only after invertibility/positive-definiteness is certified;
5. record
     DN_N,
     DN_N * log N,
     sqrt(DN_N * log N),
     condition number / enclosure width;
6. fit no theorem from numerics; use them only to choose a candidate analytic inequality.

## Immediate falsification tests for any proposed R2 bound

Reject a candidate before Lean if it:
- imports RH or a statement equivalent to RH;
- uses the Báez-Duarte damped Möbius convergence estimate without discharging its RH hypothesis;
- claims finite numerical convergence implies the infinite limit;
- proposes DN_N = o(1/log N) without reconciling Burnol's lower-bound regime;
- transports a Gram formula from a different measure normalization;
- silently replaces dx on (0,infinity) by dx/x, dx/x^2, or an unproved isometric model.

## Frontier

OPEN_BRIDGE:
  concreteNBData.DNLimit concreteGeneratorFamily = 0

No project axiom.
No sorry.
No RH theorem emitted.
