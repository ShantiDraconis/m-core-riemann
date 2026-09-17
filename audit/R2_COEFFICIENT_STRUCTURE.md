# R2 coefficient-structure probe — finite-N only

Source SHA: `77be7ec1a7d4e8c834a1afc8dc30cbcf62d61ec1`
Workflow run: `35285121855`
Job: `105415631681`
Artifact SHA-256: `efb25882b6006a9adc539da360b90efb75f9238d7c30efc0e0117b0b8550ceda`

Status: **MODEL_EVIDENCE / INTERVAL_CERTIFIED_FINITE_N**. This file does not prove an asymptotic statement and does not change `DNLimit=0` or RH status.

## Optimal finite coefficients at N=256

The Arb-certified optimal coefficient vector has a striking arithmetic sign pattern:

- square-free indices in 1..256: 157
- signs matching (-\mu(n)): 157 / 157
- mean absolute coefficient on square-free indices: 0.3630560816477301
- mean absolute coefficient on non-square-free indices: 0.05580093176501322

This is structural evidence that Möbius arithmetic is visible in the optimal projection, but it is not an asymptotic theorem.

## Explicit candidate falsification / comparison

Using the same rigorously enclosed Gram matrix and target vector, the squared L2 residual at N=256 is:

- optimal projector: 0.0082337162772610214415980381026354345341046229830852
- raw (c_n=-\mu(n)): 0.041758169053726221499981876646527789613483986006628
- square-root log taper
  (c_n=-\mu(n)\sqrt{1-\log n/\log N}):
  0.043608225771310468085388569299920798720899174871726
- linear log taper
  (c_n=-\mu(n)(1-\log n/\log N)):
  0.12428770771638819184885871242023601518304220686818

All are finite-N interval-certified values. None is promoted to a uniform bound.

## Relation to Bettin--Conrey--Farmer

Bettin, Conrey and Farmer use the Dirichlet polynomial

[
V_N(s)=\sum_{n\le N}\left(1-\frac{\log n}{\log N}\right)\frac{\mu(n)}{n^s}.
]

Their asymptotic result is conditional on RH plus a discrete moment bound for (1/|\zeta'(\rho)|^2). Therefore the linear taper remains a **CIRCULAR_CONDITIONAL_ROUTE** for the present R2 goal. Poor finite-N performance does not refute their asymptotic theorem.

Primary source: arXiv:1211.5191.

## Burnol lower-bound correction

The relevant lower bound is asymptotic:

[
\liminf_{N\to\infty} d_N^2\log N
\ge
\sum_{\Re\rho=1/2}\frac{m(\rho)^2}{|\rho|^2}.
]

The familiar constant (2+\gamma-\log(4\pi)) is not an unconditional lower bound for each finite N. Under RH one has the corresponding zero sum identity, and with the simple-zero specialization the expected asymptotic is the familiar constant divided by (log N).

Thus the finite certified value
[
DN_{256}\log 256=0.0456574177849120475575\ldots
]
being below (2+\gamma-\log(4\pi)\approx0.04619) is not a contradiction.

Primary sources: Burnol, arXiv:math/0103058; Bettin--Conrey--Farmer, arXiv:1211.5191.

## Research consequence

The next useful object is not another arbitrary taper. A viable explicit family must explain both:

1. the exact (-\mu(n)) sign pattern observed on square-free indices; and
2. the nonzero corrections on non-square-free indices which materially improve the projection.

Until a uniform analytic estimate is proved, the frontier remains

[
\texttt{concreteNBData.DNLimit concreteGeneratorFamily = 0}.
]

`dnlimit_eq_zero_proved=false`
`rh_proved=false`
