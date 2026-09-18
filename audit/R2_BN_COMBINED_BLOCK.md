# R2 — B_N combined block: the single backward-dense frontier

Status: **OPEN_MATH — one material gate, refined semantics**.

Repository: \`ShantiDraconis/m-core-riemann\`  
Branch: \`research/r2-dnlimit-zero\`  
Authoritative base for this refinement:
\`e5d817a8a31edc1d6cb61771e3bfe490c3258f32\`.

The historical gate identifier remains

\[
\texttt{ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL}
\]

for certificate stability. Its authoritative mathematical target is now stated
without the misleading implication that the zero-residue sum should be bounded
term-by-term in absolute value.

The one material target is the **BCF combined block**.

## 1. Closed wiring that is not reopened

The following are inputs, not gates:

- the certified \(L^2((0,\infty),dx)\) model;
- \(\chi=1_{(0,1)}\);
- \(\rho_a(x)=\{1/(ax)\}\);
- \(b_a=(\log a+1-\gamma)/a\);
- Gram/Vasyunin with explicit normalization and independent check;
- Mellin–Plancherel in the project normalization;
- frozen NB distance/limit machinery;
- finite Arb numerics through \(N=256\);
- R1 Báez–Duarte external interface.

No statement here redefines \`DNLimit\`. The frozen NB layer remains the
authority for \(d_N\), \(DN_N=d_N^2\), and \(DNLimit\).

## 2. Unconditional BCF identity

For the BCF linear Riesz–Möbius polynomial

\[
V_N(s)=
\sum_{n\le N}
\left(1-\frac{\log n}{\log N}\right)
\frac{\mu(n)}{n^s},
\]

BCF Lemma 2 gives, for \(0<\Re s<1\), the unconditional identity

\[
V_N(s)=
\frac1{\zeta(s)}
\left(
1-\frac1{\log N}\frac{\zeta'}{\zeta}(s)
\right)
+
\frac1{\log N}
\sum_\rho R_N(\rho,s)
+
\frac1{\log N}F_s(1/N).
\]

The zero sum is understood in the same canonical sense as in the source.
Absolute convergence is **not** inserted as an extra hypothesis.

Multiplying by \(\zeta(s)\) gives

\[
1-\zeta(s)V_N(s)
=
\frac1{\log N}
\left[
\frac{\zeta'}{\zeta}(s)
-\zeta(s)\sum_\rho R_N(\rho,s)
-\zeta(s)F_s(1/N)
\right].
\]

BCF's closing asymptotic is conditional on RH and an additional negative
\(\zeta'(\rho)\)-moment hypothesis. That conditional result remains unusable
for closing R2. The paper itself describes its main constant theorem as
conditional. The unconditional asset is the decomposition above.

## 3. The correct combined object

Define

\[
\boxed{
B_N(s):=
\frac{\zeta'}{\zeta}(s)
-
\zeta(s)\sum_\rho R_N(\rho,s)
}
\]

and the companion entire-remainder contribution

\[
C_N(s):=\zeta(s)F_s(1/N).
\]

Then the exact residual is

\[
\boxed{
1-\zeta(s)V_N(s)
=
\frac{B_N(s)-C_N(s)}{\log N}.
}
\]

This is the crucial backward-dense correction.

The primary target is **not**

\[
\left\|\sum_\rho |R_N(\rho,\cdot)|\right\|
\]

and it is not a pair of independent gates for
\(\zeta'/\zeta\) and \(\sum_\rho R_N\).

The logarithmic derivative and the residue block carry matching singular
structure. Their cancellation is part of the exact BCF identity. Destroying
that cancellation by taking termwise absolute values before combination can
reintroduce artificial negative moments of \(\zeta'(\rho)\) and lose the
structure one is trying to exploit.

## 4. Exact project norm and exact closing scale

On the critical Mellin line write

\[
\|H\|_W^2
:=
\frac1{2\pi}
\int_{\mathbb R}
\frac{|H(\tfrac12+it)|^2}{\tfrac14+t^2}\,dt.
\]

For the explicit BCF approximant, Mellin–Plancherel gives

\[
E_N^2
=
\left\|
1-\zeta V_N
\right\|_W^2.
\]

Therefore

\[
\boxed{
E_N^2
=
\frac{
\|B_N-C_N\|_W^2
}{
(\log N)^2
}.
}
\]

This yields two useful target scales.

### Endpoint-only target

To close the Nyman–Beurling endpoint it is sufficient to prove

\[
\boxed{
\|B_N-C_N\|_W=o(\log N).
}
\]

Equivalently,

\[
\|B_N-C_N\|_W^2=o((\log N)^2).
\]

Then \(E_N^2\to0\), hence the corresponding finite-span distance tends to zero,
and the already-audited R1/NB chain gives the endpoint.

### Stronger \(C/\log N\) target

To obtain the commonly studied rate

\[
E_N^2=O(1/\log N),
\]

it suffices to prove

\[
\boxed{
\|B_N-C_N\|_W^2=O(\log N).
}
\]

This is stronger than logically necessary for R2 closure. The project must not
silently replace the endpoint obligation by this stronger rate.

## 5. Why off-critical zeros remain the real obstruction

For a simple zero \(\rho=\beta+i\gamma\),

\[
R_N(\rho,s)=
\frac{N^{\rho-s}}
{\zeta'(\rho)(\rho-s)^2}.
\]

On \(\Re s=1/2\), a zero with \(\beta>1/2\) introduces the raw scale

\[
N^{\beta-1/2}.
\]

But this is **not** a license to bound the residue sum termwise. The exact
question is whether the complete block

\[
\frac{\zeta'}{\zeta}
-
\zeta\sum_\rho R_N
\]

has unconditional cancellation in the project weighted \(L^2\) norm strong
enough to meet the scale in Section 4.

The Maier–Rassias off-critical stress test remains useful as a boundary sanity
check: it shows that off-critical residues are not automatically harmless.
It does not prove that the combined block cannot cancel, and it does not give
an unconditional theorem about the actual zero set.

## 6. Backward-dense audit table

### HYPOTHESIS_MATCH

**PASS for the identity.**

BCF Lemma 2 is unconditional on its stated strip. No RH hypothesis is used to
obtain the decomposition itself.

### CONCLUSION_MATCH

**FAIL for closure / PASS for decomposition.**

The identity exposes \(B_N-C_N\); it does not prove
\(\|B_N-C_N\|_W=o(\log N)\).

### QUANTIFIER_MATCH

The closing statement must control the complete critical-line weighted norm as
\(N\to\infty\). Finite-height zero verification, positive proportions of
critical zeros, or finite \(N\) Gram calculations do not match this quantifier.

### SCALING_MATCH

Exact endpoint scale:

\[
\|B_N-C_N\|_W=o(\log N).
\]

Stronger Burnol/BCF-rate scale:

\[
\|B_N-C_N\|_W^2=O(\log N).
\]

### CONSTANT_MATCH

No unconditional global constant \(C\) proving the stronger
\(O(\log N)\) numerator bound is currently certified in the project.

### AXIOM_AUDIT

- BCF Lemma 2: \`PROVED_EXTERNAL_UNCONDITIONAL_IDENTITY\`;
- BCF Lemma 3 / Theorem 1 closing estimates:
  \`CIRCULAR_CONDITIONAL_ASYMPTOTIC\`;
- no project axiom;
- no \`sorry\`;
- no new Lean theorem;
- no frozen write.

## 7. Routes that do not reduce this gate

The following remain pruned or insufficient:

- termwise absolute-value control of the residue sum;
- Cauchy–Schwarz that simply reintroduces unavailable negative
  \(\zeta'(\rho)\) moments;
- RH-conditional residue estimates;
- finite zero verification;
- zero-density estimates that do not eliminate a single off-critical zero and
  do not control the required local Laurent data;
- functional-equation pairing without a new cancellation theorem;
- finite Arb extrapolation.

They may provide diagnostics, but they do not change
\`MATERIAL_GATE_COUNT = 1\`.

## 8. The single material frontier

Stable certificate identifier:

\[
\boxed{
\texttt{ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL}
}
\]

Canonical mathematical semantics:

\[
\boxed{
\texttt{BN\_COMBINED\_BLOCK\_UNCONDITIONAL\_CONTROL}
}
\]

Exact obligation:

\[
\boxed{
\|B_N-\zeta F_s(1/N)\|_W=o(\log N).
}
\]

A proof of that obligation, with no RH-equivalent hypothesis hidden in the
inputs, closes the current R2 true lane. Until such a proof exists:

\[
\texttt{dnlimit\_eq\_zero\_proved=false},
\qquad
\texttt{rh\_proved=false}.
\]

## 9. Next research action

Do **not** reopen Gram/Vasyunin and do **not** add another gate.

The next mathematical attack should search directly for a cancellation theorem
or representation of \(B_N\) that preserves the BCF combination. Productive
forms would include:

1. an integral/operator representation of \(B_N\) in which the residue and
   logarithmic-derivative pieces are already combined;
2. a contour identity that moves the zero sum before absolute values are taken;
3. an unconditional weighted mean-square estimate for the full combined block;
4. a different explicit Dirichlet polynomial producing a combined residual
   with a provable vanishing bound.

Anything weaker remains wiring or model evidence.

## 10. Provenance

Primary audited source:
S. Bettin, J. B. Conrey, D. W. Farmer,
*An Optimal Choice of Dirichlet Polynomials for the Nyman–Beurling Criterion*,
arXiv:1211.5191; published in the Proceedings of the Steklov Institute of
Mathematics. The paper's headline asymptotic is explicitly conditional on RH
and an additional reciprocal-\(\zeta'(\rho)\) moment hypothesis.

This document refines the gate semantics only. It does not mathematically
promote R2.
