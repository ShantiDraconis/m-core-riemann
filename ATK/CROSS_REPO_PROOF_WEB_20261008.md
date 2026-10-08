# ATK CROSS-REPOSITORY PROOF WEB — 2026-10-08

Branch: atk/global-material-audit-20261008
Policy: FORWARD-ONLY; main and frozen refs unchanged.

## Status semantics
VERIFIED means exact theorem type and assumptions checked in kernel, with run and SHA. CANDIDATE means no certified cross-repository import yet. CLOSED_MATH structural does not imply terminal mathematical proof. No flags may be set true without evidence.

## Directed edges (source -> target)
- m-core-p-vs-np -> M-Core | P01ConstructionGap, G21Pointwise | source: P01FinalCertificate.lean; P01Adapter.lean | target: FinalExternalTwoGap.lean | conditional; terminal open
- M-Core -> axiomatic-millenium | global endpoint and external issuance state | source: certs/final_external/v1/status.json | target: GlobalExternalClosedMathReport.lean | report synchronization only
- axiomatic-millenium -> M-Core | seven-lane structural catalog | source: SevenLaneClosedMath.lean; SevenLaneClosureKernel.lean | target: global audit | structural only
- m-core-riemann -> millennium-riemann-I | DN/Gram material reductions | source: material Lean modules | target: RH integration | candidate; type audit required
- m-core-beal -> M-Core | primitive family reductions | source: Beal kernel | target: global lane | candidate; type audit required
- m-core-hodge -> millennium-hodge | Hodge geometric lemmas | source: Hodge modules | target: Hodge endpoint | candidate; type audit required
- millennium-bsd -> M-Core | rank/torsion partial certificates | source: BSD modules | target: global lane | candidate; type audit required
- millennium-yang-mills -> M-Core | finite spectral certificates | source: YM modules | target: global lane | candidate; type audit required
- millennium-navier-stokes-I -> M-Core | energy and forcing estimates | source: NS modules | target: global lane | candidate; type audit required
- proofs-multiprover -> M-Core | cross-checks and reproducibility | source: audit suite | target: global report | infrastructure
- 0-0-FORMAL-SUITE -> axiomatic-millenium | Lean verification harness | source: build tools | target: kernel report | infrastructure
- universal-proof-hub -> M-Core | evidence index | source: proof registry | target: global evidence | infrastructure

## Required integration
1. Identify theorem declarations, original statement, hypotheses, universe/typeclass parameters and exact dependency graph.
2. Record source commit SHA and target commit SHA; prefer pinned imports over duplicated, drifting proofs.
3. For identical statements, import the theorem; for nonidentical statements, prove an explicit adapter with no new axioms.
4. Compile target project; inspect #print axioms and reproducible CI runs.
5. Only then update registry status and dependent certificates; do not set terminalCertified or FINAL_EXTERNAL_ISSUED merely from this graph.
6. Keep missing material endpoints explicit (P01ConstructionGap, G21Pointwise, and other lane-specific obligations).

## Audit state
SOURCE / GRAPH REGISTERED / NO CROSS-REPO KERNEL VERIFICATION YET.

## Local node
ShantiDraconis/m-core-riemann
