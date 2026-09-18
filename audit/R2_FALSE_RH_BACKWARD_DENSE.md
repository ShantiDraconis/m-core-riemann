# R2 — RH FALSE BACKWARD-DENSE CHAIN

Repository: \`ShantiDraconis/m-core-riemann\`  
Branch: \`research/r2-dnlimit-zero\`  
Base scientific chain: R0 GREEN -> R1 GREEN_EXTERNAL_INTERFACE -> R2 OPEN  
Current branch base for this audit: \`b8da93ba007de8841108afc04d55209de927919e\`

Status of this document: **COUNTERFACTUAL / FALSIFICATION HARNESS**.

This file does **not** assert that the Riemann hypothesis is false. It formalizes the
complete logical chain that would have to hold if a nontrivial zero off the critical
line existed, and identifies exactly which R2 closing statements would then be false.

No project axiom. No Lean source modification. No mathematical promotion.

---

## 0. Two mutually exclusive endpoints

The existing forward endpoint is

\[
\mathrm{TRUE\_ENDPOINT}
:\Longleftrightarrow
\mathrm{DNLimit}=0.
\]

The falsity endpoint is defined as

\[
\boxed{
\mathrm{FALSE\_ENDPOINT}
:\Longleftrightarrow
\mathrm{DNLimit}>0.
}
\]

In the frozen NB layer,

\[
DN_N=d_N^2\ge0,
\qquad
\mathrm{DNLimit}=\inf_N DN_N\ge0.
\]

Therefore, once \(\mathrm{DNLimit}\neq0\) is known, nonnegativity upgrades it to
\(\mathrm{DNLimit}>0\).

The two endpoints are incompatible:

\[
\mathrm{DNLimit}=0
\quad\text{and}\quad
\mathrm{DNLimit}>0
\]

cannot both hold.

---

## 1. Canonical witness of RH falsity

Use a right-half critical-strip witness, not merely a zero with
\(\Re\rho\neq1/2\).

Define semantically

\[
\mathrm{RightOffCriticalZero}(\rho)
\]

to mean

\[
\zeta(\rho)=0,
\qquad
\frac12<\Re\rho<1.
\]

The reason for choosing the right half is symmetry. Nontrivial zeros lie in the
critical strip and are symmetric about the critical line. Thus any off-line zero
with \(\Re\rho<1/2\) has a reflected partner with real part \(>1/2\).

Hence the canonical falsity witness is

\[
\boxed{
\exists \rho,\quad
\zeta(\rho)=0,\quad
\frac12<\Re\rho<1.
}
\]

Classification:

- existence of such a witness: **HYPOTHETICAL INPUT**;
- critical-strip location and reflection symmetry: **EXTERNAL_CLASSICAL**;
- no numerical zero witness is currently supplied by this repository.

A future numerical witness must be interval-certified. A floating-point near-zero
of \(\zeta\) is not sufficient.

---

## 2. Complete backward-dense falsity chain

The dense chain is

\[
\boxed{
\exists\rho\ \mathrm{RightOffCriticalZero}(\rho)
\Longrightarrow
\neg RH
\Longrightarrow
\chi\notin\overline{\mathrm{span}\{\rho_a:a\in\mathbb N_{>0}\}}
\Longrightarrow
\neg DNToZero
\Longleftrightarrow
DNLimit\neq0
\Longrightarrow
DNLimit>0.
}
\]

Expanded stage by stage:

### F0 — right off-critical zero

\[
F_0:
\exists\rho,\quad
\zeta(\rho)=0,\quad
1/2<\Re\rho<1.
\]

Classification: **HYPOTHETICAL WITNESS**.

### F1 — RH is false

\[
F_0\Longrightarrow\neg RH.
\]

Classification: **EXTERNAL_CLASSICAL / DEFINITIONAL**.

A right off-critical nontrivial zero directly violates the statement that every
nontrivial zero has real part \(1/2\).

### F2 — strong Nyman–Beurling/Báez–Duarte closure fails

The strong criterion gives

\[
RH
\Longleftrightarrow
\chi\in
\overline{\mathrm{span}\{\rho_a:a\in\mathbb N_{>0}\}}
\subset L^2(0,\infty).
\]

Therefore

\[
\neg RH
\Longleftrightarrow
\chi\notin
\overline{\mathrm{span}\{\rho_a:a\in\mathbb N_{>0}\}}.
\]

Classification: **PROVED_EXTERNAL**, contrapositive of the Báez–Duarte criterion.

### F3 — positive Hilbert-space distance

Let

\[
\mathcal B_{\mathbb N}
=
\overline{\mathrm{span}\{\rho_a:a\in\mathbb N_{>0}\}}.
\]

Because \(\mathcal B_{\mathbb N}\) is closed,

\[
\chi\notin\mathcal B_{\mathbb N}
\Longrightarrow
\delta
:=
\operatorname{dist}(\chi,\mathcal B_{\mathbb N})
>0.
\]

Classification: **STANDARD_HILBERT_ANALYSIS / EXTERNAL_UNFORMALIZED**.

For the increasing finite spans \(V_N\),

\[
d_N:=\operatorname{dist}(\chi,V_N)
\downarrow
\delta.
\]

Thus

\[
\forall N,\quad d_N\ge\delta>0,
\]

and since \(DN_N=d_N^2\),

\[
\forall N,\quad DN_N\ge\delta^2>0.
\]

Semantically,

\[
DNLimit=\delta^2>0.
\]

The exact closure-to-finite-distance identification remains the same standard
Hilbert bridge already documented in R1.

### F4 — failure of DNToZero

From \(\delta>0\),

\[
\neg DNToZero.
\]

Classification: **STANDARD_HILBERT ANALYSIS**.

Equivalently, no sequence of finite integer-dilate approximants can have residual
norm tending to zero.

### F5 — frozen Lean zero-limit frontier

The frozen NB15 theorem states

\[
DNToZero
\Longleftrightarrow
DNLimit=0.
\]

Therefore

\[
\neg DNToZero
\Longleftrightarrow
DNLimit\neq0.
\]

Classification: **PROVED_LEAN**.

Source:

\`frozen/nb15-zero-limit-frontier-green-e7e36d6\`

theorem:

\`MCore.RH.NB.NBHilbertData.DNToZero_iff_DNLimit_eq_zero\`.

### F6 — frozen Lean nonnegativity

The frozen NB limit layer proves

\[
0\le DNLimit.
\]

Classification: **PROVED_LEAN**.

Source theorem:

\`MCore.RH.NB.NBHilbertData.DNLimit_nonneg\`.

Combining F5 and F6:

\[
DNLimit\neq0
\land
DNLimit\ge0
\Longrightarrow
\boxed{DNLimit>0}.
\]

This is the falsity endpoint.

---

## 3. What becomes false in the current forward R2 program

If F0 holds, the following existing facts remain true:

- the definition of \(\chi\);
- the definition of \(\rho_a(x)=\{1/(ax)\}\);
- \(\chi\in L^2\);
- every \(\rho_a\in L^2\);
- the exact formula for \(b_a\);
- the Gram identities;
- the Vasyunin/cotangent representation, if correctly normalized;
- finite Gram positivity/invertibility at certified finite \(N\);
- antitonicity of \(DN_N\);
- existence of \(DNLimit\);
- the Báez–Duarte equivalence itself;
- the BCF residue decomposition itself.

Therefore the falsity world does **not** refute R0 or R1.

The first material statement that must fail is any unconditional statement strong
enough to force

\[
DN_N\longrightarrow0.
\]

In particular, under F0, each of the following is false:

\[
\exists C>0,\ \forall N\ge N_0,\quad
DN_N\le\frac{C}{\log N}
\]

if it is used with a fixed finite \(C\) to conclude vanishing;

more generally,

\[
\exists\varepsilon_N\to0,\quad
DN_N\le\varepsilon_N
\]

cannot hold.

Proof by contradiction:

if \(DNLimit=\delta^2>0\) and \(\varepsilon_N\to0\), choose \(N\) large enough that

\[
\varepsilon_N<\delta^2.
\]

But \(DN_N\ge DNLimit=\delta^2\), contradicting \(DN_N\le\varepsilon_N\).

Thus the **first real falsifiable forward bridge** is exactly the vanishing upper
bound.

---

## 4. Current BCF frontier under the false-RH hypothesis

The current dense R2 route isolates the unconditional Bettin–Conrey–Farmer
residue decomposition.

For a simple zero

\[
\rho=\sigma+i\gamma,
\qquad
\sigma>1/2,
\]

the individual residue contribution has the raw factor

\[
R_N(\rho,s)
\sim
\frac{N^{\rho-s}}
{\zeta'(\rho)(\rho-s)^2}.
\]

On the critical line

\[
s=\frac12+it,
\]

its raw magnitude scale contains

\[
N^{\sigma-1/2}.
\]

Therefore a proof that bounds each off-critical residue term absolutely by a
quantity tending to zero is immediately impossible when \(\sigma>1/2\).

Important limitation:

this does **not** prove that the complete residue sum cannot exhibit cancellation.
It gives a stress test. Any claimed unconditional proof of a vanishing full residue
sum must explicitly control all cancellations among the symmetric zero
contributions.

Under the hypothetical false-RH world, because R1 already implies
\(DNLimit>0\), any global residue estimate that would force the BCF residual to
zero must ultimately fail somewhere. The purpose of the residue harness is to
locate that failure declaration-by-declaration.

---

## 5. Complete test chain

### T0 — structural invariants

Verify:

- no change to frozen R0/R1/NB evidence;
- no project axiom;
- no \`sorry\`;
- no assumption equivalent to RH hidden in a residue bound.

Expected result in both worlds: **PASS**.

### T1 — zero witness validation

Input a candidate complex interval \(Z\).

Require a rigorous proof that it contains a zero \(\rho\) of \(\zeta\) and

\[
1/2<\Re\rho<1.
\]

Ordinary numerical evaluation \(|\zeta(z)|\approx0\) is insufficient.

If no certified witness exists:

\[
F_0=\mathrm{UNESTABLISHED}.
\]

### T2 — symmetry test

For any off-line nontrivial zero witness, construct the corresponding right-half
witness using the classical zero symmetries.

Expected result: **EXTERNAL_CLASSICAL PASS** once a witness is certified.

### T3 — criterion contrapositive

Use the strong Báez–Duarte equivalence:

\[
F_0
\Longrightarrow
\neg RH
\Longrightarrow
\chi\notin\overline{\mathcal B_{\mathbb N}}.
\]

Expected result: **PROVED_EXTERNAL**.

### T4 — closure-distance test

From nonmembership in the closed subspace derive

\[
\delta=\operatorname{dist}(\chi,\mathcal B_{\mathbb N})>0.
\]

Then check

\[
d_N\ge\delta,\qquad DN_N\ge\delta^2.
\]

Expected result: **STANDARD_HILBERT_ANALYSIS**.

### T5 — frozen zero-limit logic

Use

\[
DNToZero\leftrightarrow DNLimit=0
\]

and

\[
DNLimit\ge0.
\]

Expected result:

\[
\boxed{DNLimit>0}.
\]

Classification: **PROVED_LEAN once the external false-world premises are supplied**.

### T6 — universal upper-bound contradiction

For every proposed R2 close candidate of the form

\[
DN_N\le\varepsilon_N,\qquad\varepsilon_N\to0,
\]

run the falsity-world test

\[
DNLimit>0
\Longrightarrow
\exists N:\varepsilon_N<DNLimit\le DN_N.
\]

Any candidate bound that survives only by assuming no off-critical zero is
circular.

### T7 — BCF zero-residue stress

Given \(\rho=\sigma+i\gamma\), \(\sigma>1/2\), instantiate the zero-residue term
and record the exponent

\[
\beta=\sigma-\frac12>0.
\]

Test every claimed residue estimate against the factor \(N^\beta\).

Classifications:

- termwise vanishing absolute bound: **REFUTED UNDER F0**;
- full signed/complex cancellation bound: **OPEN UNTIL PROVED**;
- bound using RH or equivalent zero-location input: **CIRCULAR_DEPENDENCY**.

### T8 — endpoint consistency

The falsity branch must end with

\[
\boxed{
DNLimit>0,\quad
DNToZero=\mathrm{false},\quad
RH=\mathrm{false}.
}
\]

It must never produce simultaneously

\[
DNLimit=0.
\]

---

## 6. Backward-dense compression

The entire false chain compresses to

\[
\boxed{
\mathrm{RIGHT\_OFF\_CRITICAL\_ZERO}
\land
\mathrm{EXTERNAL\_CLASSICAL}
\Longrightarrow
\mathrm{DNLimit}>0
\Longrightarrow
\mathrm{RH\_FALSE}.
}
\]

More explicitly:

\[
\mathrm{RightOffCriticalZero}
\stackrel{\text{classical}}{\Longrightarrow}
\neg RH
\stackrel{\text{Báez--Duarte}}{\Longrightarrow}
\neg\mathrm{Closure}
\stackrel{\text{Hilbert}}{\Longrightarrow}
\neg DNToZero
\stackrel{\text{NB15}}{\Longleftrightarrow}
DNLimit\neq0
\stackrel{\text{NB limit}}{\Longrightarrow}
DNLimit>0.
\]

There is only one non-wiring input in the falsity direction:

\[
\boxed{
\exists\rho:\zeta(\rho)=0,\quad 1/2<\Re\rho<1.
}
\]

If that witness exists, the rest of the falsity chain is classical/external wiring
plus already-certified internal logic.

---

## 7. Where the forward proof must break if RH is false

Current forward chain:

\[
R0
\to
R1
\to
R2\text{ identities}
\to
\mathrm{ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL}
\to
DNLimit=0
\to
RH.
\]

Counterfactual false-world classification:

- R0: **TRUE**;
- R1 criterion: **TRUE**;
- R2 exact identities: **TRUE**;
- finite Arb calculations: **TRUE FOR THE CERTIFIED FINITE N**;
- BCF unconditional identity: **TRUE**;
- unconditional zero-residue control strong enough to imply vanishing:
  **MUST FAIL**;
- \(DNLimit=0\): **FALSE**;
- RH: **FALSE**.

Therefore the earliest material failure in the current compressed route is

\[
\boxed{
\mathrm{ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL}.
}
\]

If a different future route bypasses BCF, then the invariant falsification target
is still the same:

\[
\boxed{
\text{the first statement that forces }DN_N\to0\text{ must be false.}
}
\]

---

## 8. Dual-world research harness

From now on every proposed R2 lemma should be checked in two models.

### WORLD_TRUE candidate

Assume no off-critical zero and try to prove

\[
DNLimit=0.
\]

### WORLD_FALSE(\(\rho\))

Assume a symbolic right off-critical zero

\[
\zeta(\rho)=0,\qquad 1/2<\Re\rho<1.
\]

Then require the same candidate lemma to be tested against

\[
DNLimit>0.
\]

A candidate that silently proves \(DNLimit=0\) in WORLD_FALSE has exposed a
hidden circular assumption or an invalid estimate.

This dual-world test does not decide RH. It is a falsification harness for the
proof architecture.

---

## 9. Source ledger

External classical zero geometry:
- NIST DLMF §25.10: nontrivial zeros lie in the critical strip and are symmetric
  about the real axis and the critical line.

Strong Nyman–Beurling/Báez–Duarte criterion:
- L. Báez-Duarte, *A strengthening of the Nyman-Beurling criterion for the
  Riemann Hypothesis*, arXiv:math/0202141.

BCF residue route:
- S. Bettin, J. B. Conrey, D. W. Farmer,
  *An optimal choice of Dirichlet polynomials for the Nyman-Beurling criterion*,
  arXiv:1211.5191.
- Their asymptotic conclusion is conditional on RH plus a moment hypothesis for
  \(1/\zeta'(\rho)\); those conditional steps are forbidden as an unconditional
  R2 close.

Frozen internal logic:
- \`frozen/nb15-zero-limit-frontier-green-e7e36d6\`
- \`DNToZero_iff_DNLimit_eq_zero\`
- \`DNLimit_nonneg\`

---

## Final status

\[
\boxed{
\mathrm{RH\_FALSE\_CHAIN}
=
\mathrm{RIGHT\_OFF\_CRITICAL\_ZERO}
\to
DNLimit>0
}
\]

is now completely specified as a backward-dense falsification architecture.

Actual repository status remains:

\[
dnlimit\_eq\_zero\_proved=false,
\qquad
rh\_proved=false.
\]

No off-critical zero witness has been established here.
