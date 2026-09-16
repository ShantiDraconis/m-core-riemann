# RH K9 criterion routes — research ledger

Status: RESEARCH_ONLY / OPEN_BRIDGE. No endpoint promotion.

## Global rule
A published equivalence is bibliographic evidence, not a Lean proof term. No route may be marked VERIFIED until its criterion and every required analytic hypothesis compile in the pinned project. No `axiom`, `sorry`, endpoint hypothesis, or hidden equivalent of RH may be introduced to bridge M-Core to a criterion.

## Route NB — Nyman–Beurling / Báez-Duarte
Established mathematical target in the literature: RH is equivalent to an L² closure/approximation statement involving fractional-part dilations; Báez-Duarte proves a strengthening using natural-number dilations.

Formalization obligations:
1. Define the concrete L² space and norm.
2. Define rho(x)=x-floor(x), chi_(0,1), and rho_a(x)=rho(1/(a*x)) with domains/measurability/integrability.
3. Define finite spans and closure/epsilon approximation.
4. Formalize the literature equivalence in Lean, with all analytic hypotheses.
5. Prove MCore -> NB approximation without assuming RH or an equivalent statement.

Current M-Core -> NB edge: OPEN_BRIDGE.

## Route LI/WEIL — positivity
Established mathematical target in the literature: Li's criterion characterizes RH by nonnegativity of all Li coefficients; Weil's explicit-formula positivity gives another criterion and is related to Li-type positivity.

Formalization obligations:
1. Define completed zeta/xi using the pinned Mathlib API.
2. Define Li coefficients in a convergence-safe way (prefer the derivative-at-s=1 formulation first; a sum over zeros requires ordering/convergence/multiplicity bookkeeping).
3. Prove the Li criterion in Lean or import an already formalized theorem if one actually exists in the pinned dependency graph.
4. Define an independent M-Core energy/quadratic form.
5. Prove its positivity from the explicit regularization.
6. Prove the identity MCoreEnergy(n)=LiCoefficient(n), or MCoreQuadraticForm=WeilQuadraticForm, without RH.

Current M-Core -> Li/Weil edge: OPEN_BRIDGE.

## Route DBN — de Bruijn–Newman
Established mathematical target in the literature: the de Bruijn–Newman heat deformation has a threshold Lambda; RH corresponds to the zero-time statement, and Rodgers–Tao proved Lambda >= 0.

Formalization obligations:
1. Define the actual Phi kernel and heat-deformed entire function H_t.
2. Prove convergence/entireness and the zero-reality threshold framework.
3. Formalize the criterion relating the zero-time function to RH.
4. Keep M-Core scale lambda distinct from heat time t.
5. Construct and prove a parameter map from M-Core regularization to heat flow if one exists.

Current M-Core -> DBN edge: OPEN_BRIDGE.

## Spectral route
Hilbert–Polya is a research program, not an established theorem supplying the missing operator for zeta. A valid route must construct the Hilbert space/operator independently, prove self-adjointness, and prove a non-circular zero-spectrum correspondence. Merely placing zero_to_spectrum in a certificate would move RH into a hypothesis.

Current spectral edge: OPEN_BRIDGE.

## Corrections preserved
- Finite delta/lambda tests are harness evidence, not universal quantifiers.
- A3 path dependence does not imply path independence; a constructed regularization plus preservation theorem is required.
- An asymptotic bound tending to zero does not by itself imply exact equality at every finite height.
- No general theorem is assumed here that hypothetical off-critical zeros satisfy |Re(s)-1/2|=O(1/log |Im(s)|).
- `CriticalStatus.unknown` is epistemic metadata; it is not a third truth value of Lean `Prop` and is not encoded as `¬ Decidable p`.

## Promotion gates
REG: explicit R + preservation + path/self-reference repair + nontriviality.
TRANSFER: universal map to genuine zeta/criterion objects for arbitrary nontrivial zeros.
CRITERION: fully formalized established equivalence or a newly proved non-circular theorem.
ENDPOINT: exact Mathlib `RiemannHypothesis`, zero sorry/admit/custom scientific axioms, axiom audit and clean reproduction.
