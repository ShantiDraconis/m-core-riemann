# Backward-Dense Triple Closure Architecture

Repository: \`ShantiDraconis/m-core-riemann\`  
Branch: \`research/r2-dnlimit-zero\`  
Audit base: \`91dabbaa7a7a5d248a9fcc4341e9aab1d53edbb2\`

Status: **META-AUDIT ARCHITECTURE**. This file defines when the beginning,
middle, and final of the proof chain are allowed to be called CLOSED. It does
not itself prove RH or its negation.

No new Lean theorem. No project axiom. No frozen ref is modified.

## 1. The three closures

The compressed proof has exactly three semantic layers:

\[
\boxed{\mathrm{BEGIN\_CLOSED}}
\Longrightarrow
\boxed{\mathrm{MIDDLE\_CLOSED}}
\Longrightarrow
\boxed{\mathrm{FINAL\_CLOSED}}.
\]

These are not three independent badges. They are dependency-ordered closure
conditions.

### BEGIN_CLOSED

The beginning is closed when the mathematical objects, carrier, normalization,
and criterion interface are fixed and audited, so that no later proof step can
change the meaning of the endpoint.

For this repository BEGIN consists of:

- the concrete \(L^2((0,\infty),dx)\) carrier;
- \(\chi=1_{(0,1)}\);
- the concrete family \(\rho_a(x)=\{1/(ax)\}\);
- \(\chi,\rho_a\in L^2\);
- the frozen NB distance/limit semantics;
- the certified concrete R0 composition;
- the R1 Báez-Duarte criterion interface, including the normalization match.

Current classification:

\[
\boxed{\mathrm{BEGIN=CLOSED\_CERTIFIED}}.
\]

The beginning does **not** contain a claim that \(DNLimit=0\), RH, or \(\neg RH\).

### MIDDLE_CLOSED

The middle is the only non-wiring layer after backward-dense compression.

It has two mutually exclusive closing lanes.

#### TRUE lane

\[
\mathrm{TRUE\_MIDDLE}
:\Longleftrightarrow
DNLimit=0.
\]

For the current BCF route, the remaining material obligation is

\[
\boxed{\mathrm{ZERO\_RESIDUE\_SUM\_UNCONDITIONAL\_CONTROL}}.
\]

A valid TRUE-middle close must supply an unconditional proof strong enough to
force the concrete finite defects to vanish. Conditional BCF asymptotics using
RH or an RH-equivalent zero-location hypothesis are not admissible.

Current status:

\[
\mathrm{TRUE\_MIDDLE=OPEN\_MATH}.
\]

#### FALSE lane

\[
\mathrm{FALSE\_MIDDLE}
:\Longleftrightarrow
DNLimit>0.
\]

The canonical input is a rigorously certified right off-critical zero

\[
\exists\rho,\qquad
\zeta(\rho)=0,\qquad
\tfrac12<\Re\rho<1.
\]

With such a witness, the already-audited classical/Hilbert/NB chain gives

\[
\neg RH
\Longrightarrow
\chi\notin\overline{\mathrm{span}\{\rho_a\}}
\Longrightarrow
\neg DNToZero
\Longleftrightarrow
DNLimit\neq0
\Longrightarrow
DNLimit>0.
\]

A floating-point near-zero is not a certificate. The witness must be
interval/argument-principle certified or otherwise rigorous.

Current status:

\[
\mathrm{FALSE\_MIDDLE=HYPOTHETICAL\_WITNESS\_REQUIRED}.
\]

#### XOR law for the middle

The two lanes cannot both close:

\[
DNLimit=0
\quad\wedge\quad
DNLimit>0
\]

is impossible.

Therefore

\[
\boxed{
\mathrm{MIDDLE\_CLOSED}
\Longleftrightarrow
\mathrm{TRUE\_MIDDLE\_CLOSED}
\oplus
\mathrm{FALSE\_MIDDLE\_CLOSED}
}
\]

where \(\oplus\) is exclusive OR.

Current classification:

\[
\boxed{\mathrm{MIDDLE=OPEN\_FRONTIER}}.
\]

### FINAL_CLOSED

The final is composition only. It contains no new analytical estimate.

If the TRUE middle closes, R1 wiring yields

\[
DNLimit=0\Longrightarrow RH.
\]

If the FALSE middle closes, the falsification chain yields

\[
DNLimit>0\Longrightarrow \neg RH.
\]

Thus

\[
\boxed{
\mathrm{FINAL\_CLOSED}
\Longleftrightarrow
\mathrm{BEGIN\_CLOSED}
\wedge
\mathrm{MIDDLE\_CLOSED}
\wedge
\mathrm{ENDPOINT\_COMPOSITION\_AUDITED}.
}
\]

Current classification:

\[
\boxed{\mathrm{FINAL=BLOCKED\_BY\_MIDDLE}}.
\]

No final theorem may be promoted while the middle is open.

## 2. State machine

Allowed states:

| BEGIN | MIDDLE | FINAL | Meaning |
|---|---|---|---|
| CLOSED | OPEN | BLOCKED | current repository state |
| CLOSED | CLOSED_TRUE | CLOSED_TRUE | RH endpoint closed |
| CLOSED | CLOSED_FALSE | CLOSED_FALSE | false-RH endpoint closed |

Forbidden states:

- BEGIN OPEN with MIDDLE CLOSED;
- MIDDLE OPEN with FINAL CLOSED;
- TRUE and FALSE middle lanes both CLOSED;
- FINAL_TRUE and FINAL_FALSE both CLOSED;
- RH promoted from finite-\(N\) numerics;
- RH promoted from an RH-conditional external estimate;
- false RH promoted from a non-rigorous numerical zero candidate.

## 3. Backward-dense behavior

Work starts from the final endpoint and walks backward:

### TRUE direction

\[
RH
\Longleftarrow
DNLimit=0
\Longleftarrow
\mathrm{UNCONDITIONAL\_VANISHING\_BOUND}.
\]

Everything between \(DNLimit=0\) and RH is wiring already audited in R1.

### FALSE direction

\[
\neg RH
\Longleftarrow
DNLimit>0
\Longleftarrow
\mathrm{RIGHT\_OFF\_CRITICAL\_ZERO}.
\]

Everything after a certified witness is classical/Hilbert/frozen-NB wiring.

Hence the compressed research object is not a long artificial gate chain:

\[
\boxed{
\mathrm{BEGIN\_CLOSED}
\wedge
\bigl(
\mathrm{TRUE\_FRONTIER}
\oplus
\mathrm{FALSE\_FRONTIER}
\bigr)
\Longrightarrow
\mathrm{FINAL}.
}
\]

## 4. Certificate model

The repository uses one dense state certificate:
\`certificates/PROOF_CLOSURE_TRIPLE_CERT.json\`.

It contains three logical certificates.

### BEGIN certificate

May be issued now because the beginning evidence is already immutable/audited.

Required evidence:

- R0_CERT GREEN;
- frozen rho-identification SHA
  \`66a9b18f26fd714a968c1d33935d54dde4e6bf30\`;
- frozen NB15 SHA
  \`e7e36d636a56ea23fbf7b534acb4eecba76bc6b6\`;
- R1 GREEN external interface;
- no claim of \(DNLimit=0\) or RH.

### MIDDLE certificate

Not issued while both lanes are open.

TRUE certificate requires:

- an unconditional proof of the concrete \(DNLimit=0\);
- exact source SHA;
- proof/audit classification;
- hypothesis/conclusion/quantifier/scaling/constant/axiom audit;
- no RH assumption or equivalent hidden assumption;
- dedicated GREEN run.

FALSE certificate requires:

- a rigorous off-critical zero witness;
- exact witness enclosure/proof;
- right-half location \(1/2<\Re\rho<1\);
- criterion/Hilbert/NB composition audit;
- dedicated GREEN run.

### FINAL certificate

Cannot be issued independently.

It requires:

1. BEGIN certificate valid;
2. exactly one MIDDLE lane certificate valid;
3. endpoint composition audit;
4. no contradictory endpoint certificate;
5. exact source/run/job identities.

Final closure is therefore a consequence of evidence, not a manually set flag.

## 5. Test matrix

The dedicated workflow \`.github/workflows/proof-closure-triple.yml\` enforces:

**T0 — hygiene**
- no \`lean/\` write relative to the audit base;
- no frozen ref modification;
- no new project axiom/sorry/admit in the triple-closure artifacts.

**T1 — immutable beginning**
- verify exact frozen refs;
- verify R0_CERT GREEN;
- verify R1 GREEN;
- verify NB15 zero-limit theorem provenance.

**T2 — BEGIN closure**
- BEGIN may be CLOSED only if all T1 evidence matches;
- BEGIN close may not promote RH.

**T3 — TRUE-middle promotion**
- if TRUE lane is CLOSED, R2 must no longer say \`OPEN_BRIDGE\`;
- \`dnlimit_eq_zero_proved\` must be true;
- proof evidence and dedicated run IDs must be present;
- circular conditional routes are inadmissible as closing evidence.

**T4 — FALSE-middle promotion**
- if FALSE lane is CLOSED, a rigorous right off-critical witness certificate is mandatory;
- the false-world composition evidence must be present.

**T5 — XOR**
- TRUE and FALSE lanes cannot both be CLOSED.

**T6 — FINAL dependency**
- FINAL CLOSED iff BEGIN CLOSED and exactly one MIDDLE lane is CLOSED;
- FINAL endpoint must agree with the closed middle lane.

**T7 — current-state honesty**
- while R2 remains \`OPEN_BRIDGE\`, current claims must remain
  \`dnlimit_eq_zero_proved=false\`, \`rh_proved=false\`;
- absence of an off-critical witness means \`rh_false_proved=false\`.

**T8 — backward-dense compression**
- exactly one material TRUE frontier is recorded:
  \`ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL\`;
- the false lane has exactly one material input:
  a certified right off-critical zero;
- wiring does not become a new gate.

## 6. Current instantiated state

At audit base \`91dabbaa7a7a5d248a9fcc4341e9aab1d53edbb2\`:

\[
\boxed{
\mathrm{BEGIN=CLOSED\_CERTIFIED}
}
\]

\[
\boxed{
\mathrm{MIDDLE=OPEN\_FRONTIER}
}
\]

\[
\boxed{
\mathrm{FINAL=BLOCKED\_BY\_MIDDLE}
}
\]

with

\[
dnlimit\_eq\_zero\_proved=false,
\qquad
rh\_proved=false,
\qquad
rh\_false\_proved=false.
\]

This is a valid **closed beginning / open middle / blocked final** state, not a
failed architecture. The purpose of the certificate protocol is to ensure that
when the middle genuinely closes, the final can close by composition without
creating any additional mathematical gate.
