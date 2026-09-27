# R2 — J2 finite falsification probe

Status: FINITE-N MODEL EVIDENCE ONLY

Target:
  Q_N := sum_{a,b<=N} d_N(a)d_N(b) G_{a,b},
  d_N(n) := mu(n)(1-log n/log N)log n.

Question:
  does Q_N/(log N)^3 stabilize to a nonzero constant, or decay?

Using the frozen Gram/Vasyunin formula, a finite high-precision evaluation gives:

| N | Q_N | Q_N/(log N)^3 | Q_N/(log N)^2 | Q_diag/(log N)^3 |
|---:|---:|---:|---:|---:|
| 8  | 0.6117661066 | 0.0680370171 | 0.1414789998 | 0.0329775972 |
| 12 | 0.8874386540 | 0.0578373127 | 0.1437203230 | 0.0316320114 |
| 16 | 1.0927816710 | 0.0512716206 | 0.1421551171 | 0.0305824969 |
| 24 | 1.3324755616 | 0.0415121766 | 0.1319279319 | 0.0295824203 |
| 32 | 1.4757784202 | 0.0354515117 | 0.1228655771 | 0.0289992731 |
| 48 | 1.6517187742 | 0.0284707520 | 0.1102160038 | 0.0283102448 |
| 64 | 1.7655442799 | 0.0245441773 | 0.1020763639 | 0.0279464019 |

Interpretation:
- the diagonal contribution alone is consistent with a positive log^3 coefficient;
- the COMPLETE Gram energy divided by log^3 decreases substantially across
  the tested range;
- therefore finite data do not support a nonzero positive C3 for the complete
  energy and are compatible with cancellation of the log^3 coefficient.

This is NOT an asymptotic proof.

Canonical mathematical target remains:

  J2-A := FULL_LOG3_COEFFICIENT_CANCELLATION

followed by

  J2-B := POST_CANCELLATION_LOG2_GAIN.

Classification:
J2_FINITE_FALSIFICATION_PROBE = MODEL_EVIDENCE
C3_NONZERO_HYPOTHESIS = NOT_SUPPORTED_BY_TESTED_DATA
C3_EQ_ZERO = OPEN_MATH
Q_N_o_log2 = OPEN_MATH
RH_PROVED = false
