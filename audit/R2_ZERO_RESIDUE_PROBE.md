# R2 zero-residue cancellation probe

Parent: `research/r2-dnlimit-zero` at
`ddd8708ffa3b239c8c256ef6816b9d5035b466e4`.

## Question

Does pairing the known conjugate critical zeros materially reduce the BCF
zero-residue sum before any deeper block, contour, or mean-square argument?

The diagnostic evaluates

\[
R_N(\rho,s)=\frac{N^{\rho-s}}{\zeta'(\rho)(\rho-s)^2}
\]

for symmetric pairs supplied by `mpmath.zetazero`, and also evaluates the
locally relevant combination

\[
\frac{\zeta'}{\zeta}(s)-\zeta(s)\sum_\rho R_N(\rho,s).
\]

Samples too close to a supplied zero are rejected because the separated terms
have poles whose cancellation is numerically unstable.

## Result of the first local run

Parameters: `N=32,64,128,256`, 20 positive zeros and their conjugates,
`t=0,5,10,12,16,20,25,30,40,50`, 50 decimal digits.

| N | min pair/L1 | median pair/L1 | max pair/L1 |
|---:|---:|---:|---:|
| 32 | 0.367913 | 0.984638 | 0.999857 |
| 64 | 0.624131 | 0.989157 | 0.999897 |
| 128 | 0.586735 | 0.987130 | 0.999871 |
| 256 | 0.879704 | 0.994863 | 0.999941 |

Interpretation: conjugate pairing alone produces little cancellation at most
sample points and becomes especially weak in this finite truncation at N=256.
The hypothesis `CONJUGATE_PAIRING_ALONE_CLOSES_RESIDUE_GATE` is therefore
classified `REFUTED_BY_FINITE_MODEL_EVIDENCE`, not mathematically disproved.

## Hard limits

- `mpmath.zetazero` supplies zeros with real part exactly 1/2. The diagnostic
  cannot detect or exclude off-critical zeros.
- Only finitely many zeros are summed; there is no certified residue-tail
  bound.
- The BCF remainder `F_s(1/N)` is not included.
- Numerical evidence cannot prove `DNLimit=0` or RH.

Status remains:

`ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL = OPEN_MATH`

`dnlimit_eq_zero_proved = false`

`rh_proved = false`

The next justified attack is a dyadic-height/block or contour formulation
that keeps the locally cancelled combination intact and proves a uniform tail
bound without assuming RH or a moment estimate for `1/zeta'(rho)`.
