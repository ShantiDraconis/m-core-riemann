# RH / Complexity Cross-Bridge Research Program

Status: RESEARCH_PROGRAM / NO_MATHEMATICAL_PROMOTION  
Branch: k9-research-rh  
RH_PROVED = false  
P_NE_NP_PROVED = false

This file is deliberately outside the certified R0/R1/R2 chain.

## 1. Boolean RH axis

Let R denote the proposition RH.

Let D denote the complexity proposition NP⊆P.

The pair (D,R) can be used as a two-coordinate theorem-status model. This is
bookkeeping only; no implication between the coordinates is assumed.

## 2. Discriminant zeta toy family

For a Boolean parameter D∈{0,1}, define formally for Re(s)>1:

ζ_D(s) := ∏_p (1-D p^(-s))^(-1).

Then:

- D=0 gives ζ_D(s)=1;
- D=1 gives the ordinary Euler product for ζ(s).

This is a parameterized Euler product, not automatically a new motivic,
automorphic, or Langlands L-function.

Any extension beyond D∈{0,1}, Re(s)>1, or any analytic continuation/functional
equation must be proved separately.

## 3. R-axis closure

For Boolean D,R:

N(D,R)=D²+R² ∈ {0,1,2}.

This finite norm is a status encoding only. It has no bearing on the truth of
RH or P versus NP.

## 4. Missing bridge

Target:

RH ⇒ P ≠ NP

or, more generally, an arithmetic spectral statement implying an unconditional
complexity lower bound.

Current status:

OPEN_BRIDGE.

A genuine theorem would need all of the following:

1. an explicitly specified language or circuit/model class;
2. an arithmetic hypothesis stated with exact quantifiers;
3. a theorem converting that hypothesis into a resource lower bound;
4. proof that the lower bound separates P from the chosen NP language;
5. barrier audit: relativization, natural-proofs issues where applicable,
   algebrization, uniformity, advice/oracles.

The current Nyman-Beurling/DNLimit work proves none of these complexity steps.

## 5. Language-indexed L-function proposal

Research-only template:

associate to each language L a Dirichlet/Euler-type generating object L_L(s).

Before calling such an object an L-function one must establish an appropriate
package of properties: coefficients, Euler product if any, analytic
continuation, functional equation, and arithmetic/geometric provenance.

A statement such as

"zeros off a critical line imply L∉P"

is presently only a research target, not a theorem.

## 6. Firewall with the certified RH chain

The certified Riemann chain remains:

R0 → R1 external interface → R2 DNLimit=0 OPEN.

This cross-bridge document must never:

- modify R0/R1/R2 frozen refs;
- set dnlimit_eq_zero_proved=true;
- set rh_proved=true;
- inject complexity assumptions into the RH proof chain;
- use P≠NP as an axiom.

## Frontier

The entire RH-to-complexity bridge is one material open obligation:

ARITHMETIC_TO_COMPLEXITY_LOWER_BOUND = OPEN_MATH.

Until such a theorem exists, RH and P versus NP remain independent axes in
this research framework.
