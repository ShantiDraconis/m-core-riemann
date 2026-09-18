# R2 consolidated analytic ledger

Status: **AUDIT CONSOLIDATION — R2 remains OPEN_MATH**.

Repository: \`ShantiDraconis/m-core-riemann\`  
Branch: \`research/r2-dnlimit-zero\`  
Base R1 GREEN interface: \`53d97bc0a3e64de419f4214625ae75a9e1ecb178\`  
Scientific frontier: \`ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL\`.

This file consolidates the concrete Hilbert model, the exact Gram identities,
the finite certified computation, and the remaining analytic obstruction.
It does not modify \`lean/\`, does not add a project axiom, and does not claim
\`DNLimit=0\` or RH.

## 1. Frozen model — do not redefine

Ambient space:

\[
L^2((0,\infty),dx),\qquad
\langle f,g\rangle=\int_0^\infty f(x)g(x)\,dx.
\]

Target:

\[
\chi=1_{(0,1)},\qquad \|\chi\|_2^2=1.
\]

Generators:

\[
\rho_a(x)=\left\{\frac1{ax}\right\},\qquad a\in\mathbb N_{>0}.
\]

The concrete \(\rho_a\in L^2\) result is frozen at

\[
\texttt{66a9b18f26fd714a968c1d33935d54dde4e6bf30}
\]

via
\`frozen/r0-rho-identification-green-66a9b18\`.

The NB15 frozen source
\`e7e36d636a56ea23fbf7b534acb4eecba76bc6b6\`
belongs to the abstract zero-limit bridge, not to the concrete rho L2 proof.

For every \(y\ge0\),

\[
\{y\}=y-\lfloor y\rfloor.
\]

Thus \(\rho_a\) is the cancellation between the real reciprocal term and the
integer staircase.

## 2. Exact target-vector entry

For \(a\ge1\),

\[
b_a=\langle\chi,\rho_a\rangle
=\int_0^1\left\{\frac1{ax}\right\}\,dx.
\]

With \(t=1/(ax)\),

\[
b_a=\frac1a\int_{1/a}^\infty \frac{\{t\}}{t^2}\,dt.
\]

Since \(\{t\}=t\) on \([1/a,1)\),

\[
b_a
=\frac1a
\left(
\int_{1/a}^1\frac{dt}{t}
+
\int_1^\infty\frac{\{t\}}{t^2}\,dt
\right).
\]

Using

\[
\int_1^\infty\frac{\{t\}}{t^2}\,dt=1-\gamma,
\]

we get

\[
\boxed{
b_a=\frac{\log a+1-\gamma}{a}.
}
\]

For the continuous extension,

\[
b'(a)=\frac{\gamma-\log a}{a^2},
\qquad
b''(a)=\frac{2\log a-2\gamma-1}{a^3}.
\]

## 3. Exact Gram entry in the project measure

By definition,

\[
G_{a,b}
=
\int_0^\infty
\left\{\frac1{ax}\right\}
\left\{\frac1{bx}\right\}\,dx.
\]

The correct substitution for the symmetric form is

\[
t=\frac1x,
\qquad dx=-\frac{dt}{t^2},
\]

which gives

\[
\boxed{
G_{a,b}
=
\int_0^\infty
\left\{\frac{t}{a}\right\}
\left\{\frac{t}{b}\right\}
\frac{dt}{t^2}.
}
\]

Using \(t=1/(ax)\) would instead produce an asymmetric intermediate formula;
it must not be used to justify the symmetric \(t/a,t/b\) expression.

### 3.1 Four-term cancellation

For finite truncation,

\[
\frac{\{t/a\}\{t/b\}}{t^2}
=
\frac1{ab}
-\frac{\lfloor t/b\rfloor}{at}
-\frac{\lfloor t/a\rfloor}{bt}
+
\frac{\lfloor t/a\rfloor\lfloor t/b\rfloor}{t^2}.
\]

The individual improper integrals of these four terms over \((0,\infty)\)
diverge. Only their combined expression is integrable. Therefore the repository
must never replace the full Gram integral by four independently evaluated
improper integrals.

Near \(t=0\), the complete integrand equals \(1/(ab)\). At infinity it is
bounded by \(1/t^2\).

### 3.2 Exact x-tail

For \(X\ge1\),

\[
x\ge X
\Longrightarrow
\rho_a(x)=\frac1{ax},\qquad
\rho_b(x)=\frac1{bx},
\]

hence

\[
\boxed{
\int_X^\infty \rho_a(x)\rho_b(x)\,dx
=
\frac1{abX}.
}
\]

This is exact and is suitable for independent quadrature checks.

### 3.3 GCD reduction

If \(d=\gcd(a,b)\), \(a=dp\), \(b=dq\), then

\[
\boxed{
G_{a,b}=\frac1dG_{p,q}.
}
\]

### 3.4 Vasyunin/cotangent closed form

For coprime \(p,q\), define

\[
V(p,q)
=
\sum_{k=1}^{q-1}
\left\{\frac{kp}{q}\right\}
\cot\left(\frac{\pi k}{q}\right).
\]

The research engine uses

\[
\boxed{
G_{p,q}
=
\frac{\log(2\pi)-\gamma}{2}
\left(\frac1p+\frac1q\right)
+
\frac{p-q}{2pq}\log\frac qp
-
\frac{\pi}{2pq}
\bigl(V(q,p)+V(p,q)\bigr).
}
\]

Repository classification:

\[
\texttt{EXTERNAL\_FORMULA\_WITH\_EXPLICIT\_NORMALIZATION\_AND\_INDEPENDENT\_CHECK}.
\]

This is not OPEN in the current R2 route matrix. It has explicit provenance
(Báez-Duarte; Bettin-Conrey), explicit gcd normalization, and an independent
truncated-integral check in \`research/r2/validate_vasyunin.py\`.

It remains external mathematics, not a Lean theorem and not a project axiom.

## 4. Mellin representation

For \(0<\Re s<1\),

\[
\mathcal M[\rho_a](s)
=
\int_0^\infty \rho_a(x)x^{s-1}\,dx
=
-a^{-s}\frac{\zeta(s)}{s}.
\]

The integral

\[
\int_0^\infty \{t\}t^{-s-1}\,dt
\]

already converges directly for \(0<\Re s<1\): near zero
\(\{t\}=t\), and at infinity \(\{t\}\le1\). No analytic continuation is
needed merely to justify this integral representation.

Also

\[
\mathcal M[\chi](s)=\frac1s.
\]

Mellin-Plancherel on the line \(\Re s=1/2\) yields

\[
\boxed{
G_{a,b}
=
\frac1{2\pi\sqrt{ab}}
\int_{-\infty}^{\infty}
\left(\frac ba\right)^{it}
\frac{|\zeta(\tfrac12+it)|^2}{\tfrac14+t^2}\,dt.
}
\]

This is a representation of the same real Gram entry; conjugation symmetry
makes the total integral real.

R1 remains the authoritative RH criterion interface. R2 does not replace R1
with an informal Mellin argument.

## 5. Exact NB semantics: dN versus DN

The frozen file
\`lean/MCore/RH/NB/Distance.lean\` defines

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
1-b_N^T G_N^{-1}b_N
}
\]

when the finite Gram matrix is invertible.

Any table containing values approximately

\[
0.5385,\ 0.2552,\ 0.1555,\ldots
\]

is a table of \(d_N=\sqrt{DN_N}\), not of \(DN_N\).

The interval-certified squared defects are:

| N | DN_N | DN_N log N |
|---:|---:|---:|
| 2 | 0.2899645737422027318112005834160466 | 0.2009881267516741735073435060640294 |
| 4 | 0.06512886865990024957106136367286124 | 0.09028778336933768317047902206236882 |
| 8 | 0.02416142158589668502280894301085134 | 0.05024226375175346904235009514896138 |
| 16 | 0.01789402347696943509905506314795876 | 0.04961276768773933359053561513017498 |
| 32 | 0.01405194369952985983642504072212329 | 0.04870032578358104817080025529562167 |
| 64 | 0.01137604029967365814705897002932677 | 0.04731162155793066882276971344724531 |
| 128 | 0.009658549278111909910035392571452577 | 0.04686357340295795809826330378435643 |
| 256 | 0.008233716277261021441598038102635435 | 0.04565741778491204755750270431193501 |

These are finite-N certificates only.

## 6. What does and does not close R2

For any explicit
\[
v_N=\sum_{n\le N}c_{N,n}\rho_n,
\qquad
E_N=\|\chi-v_N\|_2,
\]
best approximation gives

\[
d_N\le E_N,
\qquad
DN_N\le E_N^2.
\]

Thus any unconditional explicit family with

\[
E_N\to0
\]

or any unconditional bound

\[
DN_N\le\varepsilon_N,\qquad \varepsilon_N\to0,
\]

closes R2.

A bound \(DN_N\le C/\log N\) would suffice, but the finite ladder does not
prove one.

## 7. Current strongest analytic route

The repository has advanced beyond a generic "derive C/log N from Gram"
program.

Bettin-Conrey-Farmer provide an unconditional identity for the linear
Riesz-Möbius polynomial

\[
V_N(s)=
\sum_{n\le N}
\left(1-\frac{\log n}{\log N}\right)
\frac{\mu(n)}{n^s}.
\]

The audited decomposition is

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

BCF's identity is classified

\[
\texttt{PROVED\_EXTERNAL\_UNCONDITIONAL\_IDENTITY}.
\]

Their asymptotic close is conditional on RH plus a
\(\zeta'(\rho)\)-moment hypothesis and is therefore unusable as an R2 proof.

The present single material gate is

\[
\boxed{
\texttt{ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL}.
}
\]

For a simple zero \(\rho=\sigma+i\gamma\),

\[
R_N(\rho,s)
=
\frac{N^{\rho-s}}
{\zeta'(\rho)(\rho-s)^2},
\]

so on \(\Re s=1/2\) an off-critical zero carries the raw scale

\[
N^{\sigma-1/2}.
\]

This identifies why the remaining step is not a routine numerical-tail
estimate: controlling the complete residue contribution strongly enough to
force the NB error to zero is already the RH-equivalent open mathematics.

## 8. Current status

\[
\texttt{R0\_CERT = GREEN}
\]

\[
\texttt{R1 = GREEN\_EXTERNAL\_INTERFACE}
\]

\[
\texttt{R2 = OPEN\_BRIDGE}
\]

\[
\texttt{ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL = OPEN\_MATH}
\]

\[
\texttt{dnlimit\_eq\_zero\_proved = false}
\]

\[
\texttt{rh\_proved = false}.
\]

No \`lean/\` write.
No new frozen ref.
No project axiom.
No \`sorry\`.
