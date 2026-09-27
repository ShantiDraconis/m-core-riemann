# R2 — BCF mixed cross-term delta

Status: OPEN_MATH REFINEMENT

## Exact source mechanism

For the BCF linear mollifier, the weighted Nyman–Beurling error is written as a
contour integral of the complete BCF bracket. In the BCF proof under RH, all
terms are lower order except the mixed term coupling the logarithmic derivative
with the zero-residue sum.

The mixed term is

\[
-\frac{1}{\log^2 N}\frac{1}{2\pi i}
\int_{(1/2-\varepsilon)}
\frac{\zeta'}{\zeta}(1-s)
\left(\sum_\rho R_N(\rho,s)\right)
\frac{\zeta(s)}{s(1-s)}\,ds.
\]

Under RH and the stated derivative-moment hypothesis, BCF move the contour from
Re(s)=1/2-epsilon to Re(s)=1/2+epsilon. The crossed zero residues yield the
main term

\[
\frac{1}{\log N}\sum_\rho \frac{1}{|\rho|^2}+O(\log^{-2}N).
\]

Thus the zeta'/zeta <-> residue interaction is not a vanishing identity. It is
the source of the expected leading constant.

## Unconditional obstruction

Without RH, moving this contour across the critical strip may cross zeros with
beta>1/2. Their residue contributions inherit the BCF factor
N^(beta-1/2) (and higher logarithmic factors for multiple zeros). Therefore a
proof that simply repeats the BCF contour shift unconditionally must control
these extra crossed residues rather than discard them.

## Canonical sub-delta

R-ZR1-M1 := OFF_CRITICAL_MIXED_RESIDUE_CONTROL

Required output:
an unconditional contour-shift theorem for the complete mixed BCF term showing
that every off-critical crossed contribution is either exactly cancelled in the
full bracket or is bounded strongly enough that the total weighted L2 error is
o(1).

Equivalent operational target:
construct eps_N >= 0 with eps_N -> 0 and
DN_N <= eps_N, while retaining the complete mixed cross-term and without:
- assuming RH;
- assuming all zeros are simple;
- imposing the BCF negative zeta'-moment hypothesis as an unconditional fact;
- dropping off-critical crossed residues;
- applying termwise absolute values before the contour cancellation is exposed.

## Status

BCF_CONTOUR_IDENTITY = PROVED_EXTERNAL_UNCONDITIONAL
BCF_MIXED_TERM_MAIN_MECHANISM = IDENTIFIED
RH_CONTOUR_SHIFT_EVALUATION = CONDITIONAL
OFF_CRITICAL_MIXED_RESIDUE_CONTROL = OPEN_MATH
COMPLETE_BCF_BRACKET_CANCELLATION = OPEN_MATH
DNLimit_EQ_ZERO = false
RH_PROVED = false
