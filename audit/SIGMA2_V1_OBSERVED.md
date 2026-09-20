# SIGMA2 V1 — Riemann

SOURCE: RH/NB/ZeroLimitFrontier.lean; RH/K9_RiemannHypothesis.lean.

CENTER_OBJECT: DNToZero rho, equivalent for the certified convergent defect sequence to DNLimit rho = 0.
BEHAVIOR: Tendsto (DN rho) atTop (nhds 0); nonnegativity plus a pointwise <=0 bound would force zero, but the module explicitly does not provide that bound.
2_TO_1_TARGET: full RH endpoint requires construction of MCoreRHCertificate (Step7 + Step8); endpoint composition is mechanical once supplied.
SIZE: no canonical |t| maximal-zero center metric is established by the inspected modules.
ZERO_ZERO: one concrete zero-limit quantity is present (DNLimit); a typed numerator/denominator pair is NOT established, so NO_0_0_SIGNATURE.
OMEGA: LIMIT_BEHAVIOR_DETECTED in the precise Filter.Tendsto sense; not yet universal M-Core omega.
NUMERIC_PERCENT: NOT_COMPARABLE without a justified normalization.
CLASSIFICATION: ZERO_LIMIT_CENTER_BEHAVIOR_DETECTED.
