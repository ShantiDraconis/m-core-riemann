# OPEN_MATH min-cut checkpoint — 2026-10-04

Lane: RH
Observed current HEAD before this checkpoint: 0224ffc217a5d58047f16f70886ed14eb528158f
Earlier work in this conversation reached 26252c94e9190eb40f2f8d6d7acadf723878c242; later commits on the same work branch were preserved, not overwritten.

Certified/reusable compression:
- finite coefficient approximants span exactly V_N
- DN_N is attained by a finite coefficient vector
- DN <= squared error of any explicit coefficient vector
- coefficient error admits the exact Pythagorean decomposition:
  error^2 = DN_N + projection-gap^2
- coefficient distances are exact finite Gram quadratic energies
- a coefficient-level log-majorant certificate promotes mechanically to the log-majorant / vanishing-upper-bound chain
- direct route: an explicit coefficient family with L2 error -> 0 closes FiniteSpanApproximatesChi and DNLimit=0

Current material min-cut:
Either:
A. choose an explicit coefficient family c_N and prove its L2 error tends to zero
or quantitatively:
B. choose explicit c_N and prove coefficient energy <= K / log(N+2) uniformly.

Infrastructure repairs are not mathematical progress and must be kept separate.
No RH terminal promotion is asserted by this checkpoint.


## Explicit coefficient research pruning preserved

Historical certified/audited material additionally fixes the following research state:

- The undamped full natural Möbius partial-sum sequence is rejected as the critical L2 convergence route. This does not reject subsequences, damped/Riesz regularizations, or optimal projections.
- Finite Arb evidence selected explicit damped Möbius candidates near alpha = 3/16 and alpha = 1/4, but finite-N evidence is not promoted to an asymptotic theorem.
- For
  P_{N,alpha}(s) = sum_{n<=N} mu(n) w_{N,alpha}(n) / n^s,
  the exact analytic target recorded by the audit is the Mellin-Plancherel weighted mean-square residual
  |1 - zeta(1/2+it) P_{N,alpha}(1/2+it)|^2 / (1/4+t^2).
- Therefore the next genuine mathematical forcing target is an unconditional proof that this weighted mean-square tends to zero for one fixed explicit admissible coefficient family, or an equivalent direct L2-error theorem already mapped by ExplicitCoefficientProducer.

Current work branch contains all of:
- ExplicitCoefficientProducer.lean
- CoefficientRealization.lean
- CoefficientPythagoras.lean
- CoefficientGramEnergy.lean
- CoefficientLogMajorantProducer.lean
- ChiNorm.lean
- GramTerminalLink.lean

A certificate run at pre-checkpoint HEAD 0224ffc217a5d58047f16f70886ed14eb528158f succeeded: run 37190899941.
