# R2 formalization audit — corrected status of proposed gaps A–F

Status: **AUDIT CONSOLIDATION — one material open gate remains**.

Repository: \`ShantiDraconis/m-core-riemann\`  
Branch: \`research/r2-dnlimit-zero\`  
Base R1 GREEN interface: \`53d97bc0a3e64de419f4214625ae75a9e1ecb178\`  
Audit base HEAD: \`43766dd47983dd5dbd16caa5e2d9d468485b02ff\`.

This note audits the proposed “Lacunas A–F” against the frozen NB semantics,
the current R2 Gram engine, and the external Nyman–Beurling literature.
It does not write to \`lean/\`, add an axiom, or promote RH.

## 1. Frozen semantics that cannot be renamed

The frozen NB layer defines

\[
d_N=\|\chi-P_{V_N}\chi\|_2,
\qquad
DN_N=d_N^2.
\]

Therefore

\[
\boxed{
DN_N
=
\min_{v\in V_N}\|\chi-v\|_2^2
}
\]

and, when the finite Gram matrix is invertible,

\[
\boxed{
DN_N=1-b_N^T G_N^{-1}b_N.
}
\]

Writing \`DN_N^2\` for the squared residual is a semantic error: it would be
the fourth power of the residual norm.

The finite space \`V_N\` uses the generator indices \`Fin N\`. In the concrete
R0 normalization generator index \(n\) represents \(a=n+1\). Thus the first
\(N\) concrete generators are \(a=1,\dots,N\).

## 2. Exact Mellin residual identity

For

\[
P_N(s)=\sum_{n=1}^N c_{N,n}n^{-s},
\]

and residual

\[
r_N=\chi-\sum_{n=1}^N c_{N,n}\rho_n,
\]

the project Mellin convention gives

\[
\mathcal M\chi(s)=\frac1s,
\qquad
\mathcal M\rho_n(s)=-\frac{\zeta(s)}{s\,n^s},
\]

hence

\[
\mathcal M r_N(s)
=
\frac{1+\zeta(s)P_N(s)}s.
\]

Mellin–Plancherel therefore yields

\[
\boxed{
DN_N
=
\frac1{2\pi}
\int_{\mathbb R}
\frac{
|1+\zeta(\tfrac12+it)P_N(\tfrac12+it)|^2
}{
\tfrac14+t^2
}\,dt
}
\]

for the optimal finite coefficient vector.

This is the squared residual \(DN_N\), not \(DN_N^2\).

### Correct approximation statement

The exact criterion is vanishing of the weighted residual

\[
1+\zeta(\tfrac12+it)P_N(\tfrac12+it)
\]

in

\[
L^2\!\left(
\mathbb R,\frac{dt}{\tfrac14+t^2}
\right).
\]

It is **not** correct to replace this by ordinary unweighted convergence

\[
P_N\to-\frac1\zeta
\quad\text{in}\quad
L^2\!\left(
\mathbb R,\frac{dt}{\tfrac14+t^2}
\right).
\]

If one algebraically divides by \(\zeta\), the equivalent integrand carries
the extra weight \(|\zeta|^2\):

\[
|1+\zeta P_N|^2
=
|\zeta|^2\left|P_N+\frac1\zeta\right|^2
\]

away from zeros, with the undivided residual formulation being the safe global
one. This distinction is essential at critical zeros.

BCF use the same Nyman–Beurling quantity with the opposite polynomial sign,
written \(1-\zeta A_N\).

## 3. Zeros on the critical line: zero, not peak, of the Gram density

The Gram density contains

\[
\frac{|\zeta(\tfrac12+it)|^2}{\tfrac14+t^2}.
\]

At a critical zero \(t=\gamma\),

\[
|\zeta(\tfrac12+i\gamma)|^2=0.
\]

Thus critical zeros are **zeros/dips** of this density, not peaks or
resonant poles. Poles occur in \(1/\zeta\), which is exactly why the undivided
residual \(1+\zeta P_N\) is the correct Hilbert-space object.

An off-critical zero does not create a zero of
\(\zeta(\tfrac12+it)\) at the same ordinate in general. Its obstruction enters
the Nyman–Beurling criterion globally and, in the current strongest analytic
route, through the zero-residue terms in the unconditional BCF decomposition.

## 4. Status of the proposed gaps A–F

### A — Vasyunin/cotangent Gram formula

**Proposed status:** OPEN.  
**Correct repository status:** CLOSED AS EXTERNAL INPUT / NOT A MATERIAL GATE.

The current engine already uses

\[
G_{a,b}
=
\int_0^\infty
\left\{\frac ta\right\}
\left\{\frac tb\right\}
\frac{dt}{t^2},
\]

the gcd reduction, and the symmetric Vasyunin/cotangent formula with explicit
normalization. It is classified

\[
\texttt{EXTERNAL\_FORMULA\_WITH\_EXPLICIT\_NORMALIZATION\_AND\_INDEPENDENT\_CHECK}.
\]

The implementation is independently checked against direct truncated
quadrature. A future Lean formalization would be useful, but it does not reduce
the current R2 mathematical frontier.

### B — unconditional vanishing upper bound

**Status:** OPEN_MATH / THE material gate.

Any unconditional sequence \(\varepsilon_N\to0\) satisfying

\[
DN_N\le\varepsilon_N
\]

closes R2. The special form

\[
DN_N\le\frac C{\log N}
\]

would suffice, but it is stronger than logically necessary.

The finite Arb ladder cannot establish such an all-\(N\) bound.

The current highest-value route is the unconditional Bettin–Conrey–Farmer
decomposition of the linear Riesz–Möbius candidate. Its remaining blocker is

\[
\boxed{
\texttt{ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL}.
}
\]

Any successful unconditional estimate strong enough to force the complete
weighted residual to zero would already constitute the genuine RH-equivalent
step.

### B.1.1 — coefficient \(\ell^2\) bound

A bound such as

\[
\|c_N\|_2\le C_1\sqrt{\log N}
\]

is **not currently proved and is not logically necessary** for closing R2.
It is a possible auxiliary route only. The Gram matrices become strongly
ill-conditioned, so a naive small coefficient norm should not be assumed.

Classification:

\[
\texttt{OPTIONAL\_AUXILIARY\_HYPOTHESIS\_NOT\_A\_GATE}.
\]

### B.1.2 — critical-line zeta control

A finite-height zero-free verification or standard zero-free region away from
\(\Re s=1\) does not by itself control the full critical-line weighted residual
uniformly in \(N\).

Classification:

\[
\texttt{INSUFFICIENT\_ALONE}.
\]

### B.1.3 — explicit Dirichlet polynomial approximant

This is a legitimate formulation of the core problem only when stated in the
weighted residual norm

\[
\frac1{2\pi}\int_{\mathbb R}
\frac{|1+\zeta P_N|^2}{1/4+t^2}\,dt.
\]

It is not a separate subgate from B: proving such an explicit family has
vanishing residual closes B directly.

### B.1.4 — frequency/tail decomposition

Low/high frequency splitting can be useful, but neither part is a separate
material gate unless a new unconditional estimate is obtained.

The existing Mellin-band probe is classified model evidence only.

### C — numerical stability for \(N\ge128\)

**Proposed status:** OPEN technical.  
**Correct status:** CLOSED FOR THE CURRENT FINITE COMPUTATION.

The repository already installs python-flint/Arb and rigorously solves the
finite Gram systems through \(N=256\). The finite \(N=256\) determinant is
certified positive and the finite \(DN_{256}\) interval is certified.

Direct Mellin quadrature remains a useful independent cross-check, but is not
needed to declare the existing finite Gram calculation stable.

Classification:

\[
\texttt{INTERVAL\_CERTIFIED\_FINITE\_N\_THROUGH\_256}.
\]

This does not imply anything about \(N\to\infty\).

### D — formalization of zeta in Lean

**Proposed status:** OPEN architectural.  
**Correct status:** FUTURE FORMALIZATION, NOT A CURRENT R2 MATERIAL GATE.

The current R1 interface intentionally records the Báez-Duarte criterion as an
external theorem because the full Nyman–Beurling/Báez-Duarte bridge is not
available as a ready Mathlib theorem in the pinned environment.

R2 remains a research/audit layer until the analytic frontier closes. No new
Lean theorem should be emitted now.

### E — explicit off-critical-zero separator

**Proposed status:** OPEN formalization.  
**Correct status:** ALREADY OWNED BY R1 EXTERNAL INTERFACE; QUANTITATIVE
SEPARATOR CLAIMS REQUIRE CARE.

One must not simply define

\[
\Lambda_{s_0}(f)=\mathcal M f(s_0)
\]

and assume it is a bounded functional on the boundary Hilbert space
\(L^2(0,\infty,dx)\) for \(\Re s_0>1/2\). Point evaluation off the
Mellin–Plancherel boundary needs additional analytic structure.

Accordingly R2 does not use an unproved quantitative inequality of the form

\[
DN_N\ge c(\sigma_0-\tfrac12)|\zeta'(\rho_0)|^{-1}.
\]

The authoritative implication between the closure criterion and RH remains
the audited R1 external interface.

### F — monotonicity / existence of the DN limit

**Proposed status:** OPEN.  
**Correct status:** PROVED_LEAN and frozen.

The frozen NB14 source proves

\[
N\le M\implies d_M\le d_N
\]

and

\[
N\le M\implies DN_M\le DN_N.
\]

It also defines

\[
DNLimit=\inf_N DN_N
\]

and proves

\[
DN_N\longrightarrow DNLimit.
\]

Therefore F is removed entirely from the open-gap list.

## 5. Gram analytic checks that are valid

From

\[
G_{a,a}=\frac{\log(2\pi)-\gamma}{a}
\]

and Cauchy–Schwarz,

\[
\boxed{
|G_{a,b}|
\le
\frac{\log(2\pi)-\gamma}{\sqrt{ab}}.
}
\]

For the first \(N\) concrete generators,

\[
\operatorname{Tr}(G_N)
=
(\log(2\pi)-\gamma)H_N.
\]

Hadamard's inequality gives

\[
\det G_N
\le
\frac{(\log(2\pi)-\gamma)^N}{N!}.
\]

These are correct upper-envelope identities/bounds but do not supply the
missing lower spectral control needed to prove a vanishing NB error.

### The proposed \(G_{1,2}\approx0.912\) value is rejected

The current exact Vasyunin implementation gives

\[
G_{1,2}
=
0.77220925599087313986130250668208049\ldots
\]

and is independently checked by direct quadrature. Therefore the proposed
termwise series yielding approximately \(0.912\) is not accepted as a proved
identity and must not be added to the route matrix without correction.

## 6. Tail estimates: corrected scale

For the bare Gram spectral density, the classical second moment of zeta implies
a weighted tail at the qualitative scale

\[
\int_T^\infty
\frac{|\zeta(\tfrac12+it)|^2}{t^2}\,dt
=
O\!\left(\frac{\log T}{T}\right),
\]

not \(O(1/T)\) without the logarithm.

For a residual containing a finite Dirichlet polynomial \(P_N\), any pointwise
tail estimate must also include a rigorously proved bound on \(P_N\).
A heuristic or numerically observed estimate such as
\(\|c_N\|_1\sim\sqrt{\log N}\) cannot be inserted as a theorem.

In particular, using a Weyl-type pointwise bound
\(|\zeta(1/2+it)|\ll t^{1/6+\varepsilon}\) gives, after squaring and dividing
by \(t^2\), a tail scale \(T^{-2/3+O(\varepsilon)}\) before the polynomial
factor, not \(T^{-4/3}\).

## 7. Correct minimal DAG

The proposed six-gap hierarchy collapses to:

\[
\text{R0 concrete model GREEN}
\to
\text{R1 external criterion GREEN}
\to
\text{BCF unconditional decomposition}
\to
\boxed{\text{ZERO-RESIDUE / FULL-RESIDUAL UNCONDITIONAL CONTROL}}
\to
DNLimit=0.
\]

Everything else is either:
- already proved/frozen;
- certified finite-\(N\) computation;
- external analytic input already audited;
- future Lean formalization;
- or an optional research decomposition of the single open obligation.

## 8. Final status

\[
\texttt{R2 = OPEN\_BRIDGE}
\]

\[
\texttt{material\_gate\_count = 1}
\]

\[
\texttt{material\_gate = ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL}
\]

\[
\texttt{DNLimit\_EQ\_ZERO = false}
\]

\[
\texttt{RH\_PROVED = false}.
\]

No new Lean theorem.
No project axiom.
No sorry.
No frozen write.
