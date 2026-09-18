# R2 — zero-residue obstruction audit

Status: **OPEN_MATH boundary audit**.

Repository: `ShantiDraconis/m-core-riemann`  
Branch: `research/r2-dnlimit-zero`

This note explains why the BCF zero-residue term must remain one mathematical
frontier rather than being split into artificial “technical” gates.

## 1. Unconditional BCF identity

For the linear Riesz–Möbius polynomial

[
V_N(s)=sum_{nle N}left(1-rac{log n}{log N}ight)rac{mu(n)}{n^s},
]

Bettin–Conrey–Farmer Lemma 2 gives unconditionally

[
1-zeta(s)V_N(s)
=
rac1{log N}
left[
rac{zeta'}{zeta}(s)
-zeta(s)sum_ho R_N(ho,s)
-zeta(s)F_s(1/N)
ight],
]

where

[
R_N(ho,s)=
operatorname{Res}_{z=ho}
rac{N^{z-s}}{zeta(z)(z-s)^2}.
]

For a simple zero (ho),

[
R_N(ho,s)
=
rac{N^{ho-s}}
{zeta'(ho)(ho-s)^2}.
]

Thus a zero (ho=sigma+igamma) with (sigma>1/2), evaluated near the
critical line, carries the explicit growth scale

[
|N^{ho-s}|asymp N^{sigma-1/2}.
]

This does not by itself prove a lower bound because different residue terms can
interfere, but it identifies exactly where an off-critical zero enters the
candidate error.

## 2. Published off-critical-zero stress test

Helmut Maier and Michael Th. Rassias,
*On the Size of an Expression in the Nyman–Beurling–Báez–Duarte Criterion for
the Riemann Hypothesis*, Canadian Mathematical Bulletin 61 (2018), 622–627,
DOI 10.4153/CMB-2017-070-3, analyze the same (V_N).

Under the model assumption that there is exactly one nontrivial off-critical
quadruplet

[
sigma_0pm igamma_0,qquad 1-sigma_0pm igamma_0,
qquad sigma_0>1/2,
]

plus a discrete (1/|zeta'(ho)|^2) growth hypothesis, their Theorem 1.1
obtains a main scale

[
rac{N^{2sigma_0-1}}{(log N)^2}
left[
Acos(2gamma_0log N)
+Bsin(2gamma_0log N)
+C
ight]
]

up to a relative error of order
(N^{1/2-sigma_0+arepsilon}).

Classification here:

[
	exttt{CONDITIONAL_OFF_CRITICAL_OBSTRUCTION_MODEL}.
]

It is not an unconditional theorem about the actual zeta zero set. Its value
for this audit is structural: it confirms that the BCF residue decomposition
does not hide off-critical zeros inside a harmless remainder.

## 3. Consequence for gate architecture

The R2 endpoint is already equivalent to RH through the certified R1
interface. Therefore a bound strong enough to prove

[
|1-zeta V_N|^2_{mathrm{Mellin}}	o0
]

cannot be expected to emerge from a routine estimate that remains agnostic
about off-critical zeros.

The repository must not turn the following into a chain of apparently
independent easy gates:

- bound each residue;
- sum residues;
- remove off-critical contribution;
- conclude vanishing.

The third item already contains the essential RH obstruction.

The correct minimal DAG is therefore still

[
	ext{BCF Lemma 2 (external, unconditional)}
longrightarrow
oxed{	exttt{ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL}}
longrightarrow
DNLimit=0.
]

The boxed node is one `OPEN_MATH` gate.

## 4. What counts as genuine progress on this gate

A candidate result reduces the frontier only if it gives an unconditional
estimate that is strong enough in the project Mellin norm and does not assume
any equivalent form of RH. Examples of useful reductions would be:

- an unconditional cancellation theorem for the complete residue sum in the
  weighted (L^2) norm;
- a different explicit Dirichlet polynomial whose error can be bounded to zero
  without assuming RH;
- a new identity that removes the off-critical residue contribution for a
  demonstrably non-circular reason.

The following do **not** reduce the gate:

- bounds conditional on RH;
- simplicity of all zeros plus RH-dependent estimates;
- the BCF (sum 1/|zeta'(ho)|^2) hypothesis used together with RH;
- finite zero verification;
- finite-(N) Arb or Mellin numerics;
- splitting the residue sum into more files without a new unconditional
  estimate.

## 5. Current classification

`BCF_LEMMA2 = PROVED_EXTERNAL_UNCONDITIONAL_IDENTITY`

`OFF_CRITICAL_RESIDUE_OBSTRUCTION = STRUCTURALLY_EXPLICIT`

`MAIER_RASSIAS_STRESS_TEST = CONDITIONAL_OFF_CRITICAL_OBSTRUCTION_MODEL`

`ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL = OPEN_MATH`

`DNLimit_EQ_ZERO = false`

`RH_PROVED = false`
