# RH coefficient excess-energy audit — 2026-10-01

Status: FINITE_N_INTERVAL_CERTIFIED_INPUT + EXACT_HILBERT_IDENTITY

Formal theorem:
`coefficient_error_sq_eq_DN_add_projection_gap`

For every coefficient vector c at finite N,

[
\|\chi-v_c\|^2
=
DN_N+
\|P_N\chi-v_c\|^2.
]

Therefore the difference between any certified explicit-family squared error
and the certified optimal `DN_N` is exactly the finite projection-gap energy.

At N=256, using the already-certified Arb values:

| family | E^2 | E^2-DN_256 | total/optimal | projection-gap share |
|---|---:|---:|---:|---:|
| raw Möbius | 0.04175816905372622 | 0.03352445277646520 | 5.0716 | 80.28% |
| sqrt-log taper | 0.04360822577131047 | 0.03537450949404945 | 5.2963 | 81.12% |
| linear-log taper | 0.12428770771638819 | 0.11605399143912717 | 15.0950 | 93.38% |
| alpha=3/16 | 0.02472090792371846 | 0.01648719164645744 | 3.0024 | 66.69% |
| alpha=1/4 | 0.02530374738737122 | 0.01707003111011020 | 3.0732 | 67.46% |

Interpretation:
- the finite optimal defect itself is already much smaller than every simple
  Möbius-family error tested;
- for alpha=3/16, roughly two thirds of the finite error is not the canonical
  NB defect but distance from that explicit coefficient vector to the optimal
  projection;
- therefore the next coefficient attack should target the correction vector
  to the optimal coefficients, not another blind one-parameter taper scan.

Exact research target:

[
c_N^*=-\mu\,w_N+r_N,
]

with a provable estimate on the Gram/Hilbert energy represented by

[
\|P_N\chi-v_{-\mu w_N}\|^2.
]

A successful asymptotic attack must show both:
1. `DN_N -> 0` through a genuine analytic estimate; or produce an explicit
   family whose total error tends to zero;
2. if using a Möbius-like family, control the projection-gap correction
   uniformly, not only its finite sign pattern.

No asymptotic promotion is made from N=256.
