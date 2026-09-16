# NB8 GREEN certificate

Status: PROVED_LEAN / FROZEN

Certified source SHA: `40b45b6aa73924249e4ad5ae457adcdf6419842a`
Dedicated workflow: `nb-finite-span`
Run: `35123136016`
Job: `104885590115`
Conclusion: SUCCESS

Certified claims:
- `NBHilbertData.finiteDimensional_V`: each finite approximation space `V_N` is finite-dimensional.
- `NBHilbertData.isClosed_V`: each `V_N` is closed in the ambient Hilbert space.

Audit gates passed in the dedicated job:
- source firewall
- Lean build
- theorem API check
- axiom report

Scope note: this certificate establishes only the NB8 finite-span/closedness layer. It does not establish `D_N -> 0` and does not prove the Riemann Hypothesis.
