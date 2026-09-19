# R2 dyadic zero-residue diagnostic

Parent probe head: `bb03f702f71bddc9338ed8ffb26bdd143941ec37`.

## Tested route

Known positive critical zeros and their conjugates were grouped by positive-zero
index in blocks of sizes 1, 2, 4, 8 and 16.  For each block the diagnostic
compares

\[
\left|\sum_{\rho\in B}R_N(\rho,s)\right|
\quad\hbox{with}\quad
\sum_{\rho\in B}|R_N(\rho,s)|.
\]

It also compares the full truncated sum with the sum of the block magnitudes.

## Local result

Parameters: `N=64,128,256`, 32 positive critical zeros plus conjugates,
`t=0,10,20,30,50`, 50 decimal digits.

Cross-block cancellation ratio, minimum / median / maximum:

| N | minimum | median | maximum |
|---:|---:|---:|---:|
| 64 | 0.303679 | 0.923497 | 0.999263 |
| 128 | 0.453673 | 0.922277 | 0.999118 |
| 256 | 0.576101 | 0.957465 | 0.998488 |

For the highest sampled block, positive-zero indices 17--32, the internal
cancellation ratio at `N=256` ranged from `0.989268` to `0.995716`.  Thus the
finite critical-zero data do not show a cancellation mechanism uniform in N.

Classification:

`NAIVE_DYADIC_BLOCK_CANCELLATION = NOT_SUPPORTED_BY_FINITE_MODEL_EVIDENCE`

This is not a mathematical refutation of every block or contour method.

## Firewalls

- all supplied zeros have real part 1/2;
- off-critical zeros are neither detected nor excluded;
- only 32 positive zeros are included;
- no zero-density theorem or certified infinite-tail estimate is used;
- the BCF `F_s(1/N)` term is absent;
- no inference to `DNLimit=0` or RH is permitted.

The surviving analytic target must control the locally cancelled full contour
expression, not merely pair or block a finite list of critical zeros:

\[
\frac{\zeta'}{\zeta}(s)
-\zeta(s)\sum_\rho R_N(\rho,s)
-\zeta(s)F_s(1/N).
\]

Status remains `ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL = OPEN_MATH`.
