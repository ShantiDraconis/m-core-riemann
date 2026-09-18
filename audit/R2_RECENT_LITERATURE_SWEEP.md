# R2 — recent literature sweep through 2026-09-18

Status: **audit only; no new gate**.

Repository: `ShantiDraconis/m-core-riemann`  
Branch: `research/r2-dnlimit-zero`  
Material open gate: `ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL`.

Purpose: verify whether post-BCF literature supplies an unconditional
critical-line upper bound that actually reduces the R2 endpoint. This sweep is
not claimed to be exhaustive; it records the directly relevant sources found
and audited through 2026-09-18.

## 1. Wei–Wu (2022): zero-free region characterization

Fei Wei and Dongsheng Wu,
*A characterization of the zero-free region of the Riemann zeta function and
its applications*, Expositiones Mathematicae 40 (2022), 961–993,
DOI 10.1016/j.exmath.2022.07.004.

Their Hardy-space multiplication-operator theorem characterizes zero-free
half-planes by density/closure of the corresponding multiplication range.
For the zeta function this is a functional-analytic characterization of the
zero-free region, not a new unconditional critical-line approximation bound.

Repository classification:

`ZERO_FREE_REGION_CHARACTERIZATION_ONLY`.

Useful information:
- exact closure descriptions for multiplication operators;
- equivalent/one-way functional criteria for zero-free half-planes;
- a weaker Nyman–Beurling–Báez-Duarte formulation.

What it does not provide for this R2:
- no unconditional `DN_N <= epsilon_N -> 0` at the critical exponent;
- no unconditional control of the BCF zero-residue sum sufficient to close R2.

## 2. Ghosh–Kremnizer–Noor–Santos (2024): zero-free half-plane framework

Aditya Ghosh, Kobi Kremnizer, S. Waleed Noor, Charles F. Santos,
*Zero-free half-planes of the ζ-function via spaces of analytic functions*,
Advances in Mathematics 455 (2024), 109872,
DOI 10.1016/j.aim.2024.109872, arXiv:2206.00434.

They build a general analytic-function-space framework in which density
conditions imply zero-free half-planes. In particular, for Hardy spaces
(H^p), density at the relevant norm can imply

[
zeta(s)
e0quad\text{for}quad Re(s)>1/p.
]

The paper also emphasizes that the critical (H^2) density problem is the RH
frontier itself.

Repository classification:

`ZERO_FREE_HALF_PLANE_FRAMEWORK_NO_CRITICAL_CLOSE`.

This is useful for semantic cross-checking of Hardy-space reformulations but
does not supply the missing R2 upper bound.

## 3. Yang (2025): lower-bound generalization

Jongho Yang,
*A generalization of a result of Báez-Duarte, Balazard, Landreau, and Saias*,
Journal of Mathematical Analysis and Applications 542 (2025), 128880,
DOI 10.1016/j.jmaa.2024.128880.

The main result extends the Báez-Duarte–Balazard–Landreau–Saias **lower-bound**
side of the Nyman–Beurling approximation problem to more general
characteristic functions.

Repository classification:

`LOWER_BOUND_GENERALIZATION_ONLY`.

This strengthens rate/falsification information but cannot prove
`DNLimit = 0`.

## 4. Yang (2026): Friedrichs-angle reformulation

Jongho Yang,
*A Friedrichs angle between the Nyman-Beurling spaces and the Riemann
hypothesis*, Journal of Mathematical Analysis and Applications 560 (2026),
130494, DOI 10.1016/j.jmaa.2026.130494.

The paper proves that RH implies zero Friedrichs angle for specified
Nyman–Beurling subspaces and proves additional unconditional proper-inclusion
statements between split subspaces. These are geometric/completeness
statements, not a critical finite-distance upper bound.

Repository classification:

`GEOMETRIC_REFORMULATION_NO_UPPER_BOUND`.

No reduction of `ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL` is obtained.

## 5. Manzur–Noor–Quintero (2026): Hardy approximation

Juan Manzur, Waleed Noor, Gustavo Quintero,
*A Hardy space approximation supporting zero-free half-planes for the
ζ-function*, arXiv:2606.16097v1, submitted 2026-06-15.

They work with

[
E(s)=1/s,qquad
G_k(s)=\frac{(k^{-s}-k^{-1})zeta(s)}{s}.
]

Their main unconditional convergence theorem proves

[
sum_{k=2}^{infty}mu(k)G_k \to E
quad\text{in }H^2(mathbb C_{1/2+\tau})
]

for every (\tau>1/2). Therefore the proved half-plane parameter is

[
alpha=1/2+\tau>1.
]

This is strictly to the right of the critical strip and is compatible with the
classical zero-free half-plane.

For (1/2lealphale1) the paper studies the finite sequence numerically.
It explicitly presents extension into this range as an open question. At
(alpha=1/2), the full natural Möbius sequence is known not to converge in
the required (H^2) norm, although subsequence behavior is numerically
investigated.

Repository classification:

`UNCONDITIONAL_HARDY_CONVERGENCE_ONLY_ALPHA_GT_1`.

This is genuine unconditional analytic progress but does not reduce the
critical R2 gate.

## 6. Calderaro–Manzur–Noor–Santos: orthogonality structure

Francisco Calderaro, Juan Manzur, Waleed Noor, Charles Santos,
*Orthogonality questions in the Hardy space related to ζ-zeros*,
arXiv:2203.05030 (latest audited version 2024).

The paper describes structural links between the orthogonal complement of the
Hardy-space Nyman–Beurling span and zeta zeros, and constructs a complete
biorthogonal sequence.

Repository classification:

`ORTHOGONALITY_STRUCTURE_NO_CRITICAL_UPPER_BOUND`.

Again, this clarifies how failure of completeness stores zero information but
does not provide an unconditional vanishing approximation.

## 7. Sweep conclusion

Among the directly relevant sources audited through 2026-09-18, no surfaced
result provides an unconditional critical (H^2/L^2) upper bound sufficient
to force

[
DNLimit=0.
]

This sentence is deliberately limited to the audited search; it is not a claim
of exhaustive nonexistence in the mathematical literature.

The strongest exact analytic input found for the current explicit
Riesz–Möbius route remains Bettin–Conrey–Farmer Lemma 2:

[
1-zeta(s)V_N(s)
=
\frac1{log N}
left[
\frac{zeta'}{zeta}(s)
-zeta(s)sum_\rho R_N(\rho,s)
-zeta(s)F_s(1/N)
\right].
]

Therefore the material DAG remains unchanged:

[
\text{BCF Lemma 2}
longrightarrow
\boxed{\texttt{ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL}}
longrightarrow
DNLimit=0.
]

No additional gate is justified by this literature sweep.
