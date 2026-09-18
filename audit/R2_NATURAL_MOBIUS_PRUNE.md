# R2 — natural Möbius full-sequence route prune

Status: **refuted full-sequence route at the critical Hilbert norm**.

The concrete R2 model uses the integer generators

[
ho_a(x)=left{rac1{ax}ight}.
]

The most direct Möbius approximation uses coefficients proportional to
(-mu(a)), equivalently the sign-adjusted version of the classical natural
Beurling partial sums.

## Published obstruction

Luis Báez-Duarte's work on strong Nyman–Beurling approximations records the
key phenomenon: the natural partial sums can converge to the target almost
everywhere and in (L^1), while failing in the Hilbert (L^2) norm.

In *New versions of the Nyman-Beurling criterion for the Riemann hypothesis*
(IJMMS 31 (2002), 387–406), Section 4 explicitly studies the gap between weak
and strong approximation and states that the natural approximations
(B_n,V_n,S_n,F_n,G_n) diverge in (L^2). Proposition 4.9 is used in the
full-sequence contradiction argument.

Báez-Duarte's 2003 strengthening likewise notes that the natural Möbius
approximation

[
F_n=sum_{a=1}^n mu(a)Q_a
]

tends to (-chi) almost everywhere and in (L^1(0,1)), but diverges in the
Hilbert space.

The 2026 Hardy-space paper of Manzur–Noor–Quintero restates the consequence in
the Bagchi Hardy model: the analogous natural sequence diverges in
(H^2(mathbb C_{1/2})). They explicitly note that this does not logically
exclude a convergent subsequence.

## Repository consequence

The old classification

`NATURAL_MOBIUS = HIGH_RISK_L2`

was too weak. It is replaced by

`NATURAL_MOBIUS = REFUTED_FULL_SEQUENCE_AT_CRITICAL_L2__SUBSEQUENCE_OPEN`.

What is refuted:
- using the full undamped natural Möbius partial-sum sequence as the critical
  R2 approximation that tends to zero error.

What is not refuted:
- specially chosen subsequences;
- damped/Riesz/Möbius regularizations;
- the finite optimal projection itself.

Those surviving possibilities are research directions only. They do not
justify new gates because none currently supplies an unconditional vanishing
critical (L^2) bound.

The single material frontier remains

[
oxed{	exttt{ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL}}.
]

No Lean write. No project axiom. `DNLimit=0` remains unproved.
