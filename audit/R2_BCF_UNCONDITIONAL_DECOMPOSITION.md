# R2 — Bettin–Conrey–Farmer linear Riesz–Möbius decomposition

Status: **external theorem audit / R2 remains OPEN_MATH**.

Repository: `ShantiDraconis/m-core-riemann`  
Branch: `research/r2-dnlimit-zero`  
R1 base: `53d97bc0a3e64de419f4214625ae75a9e1ecb178`

This note isolates what is unconditional in Bettin–Conrey–Farmer (BCF) from
what is conditional on RH. Nothing in this note proves `DNLimit = 0`.

## 1. Source

S. Bettin, J. B. Conrey, D. W. Farmer,
**“An Optimal Choice of Dirichlet Polynomials for the Nyman–Beurling Criterion”**,
Proceedings of the Steklov Institute of Mathematics 280, Suppl. 2 (2013),
S30–S36. DOI: 10.1134/S0081543813030036. Preprint: arXiv:1211.5191.

The paper explicitly states that Lemma 2 is unconditional.

## 2. Exact family and mapping to the repository

BCF define

[
V_N(s)
=
sum_{n=1}^{N}
left(1-rac{log n}{log N}ight)
rac{mu(n)}{n^s}.
]

This is exactly the project’s fixed-scale Riesz–Möbius family with exponent
(alpha=1):

[
w_N(n)=1-rac{log n}{log N},
qquad
v_N
=
-sum_{nle N}mu(n)w_N(n)ho_n.
]

With the project Mellin convention

[
mathcal Mho_n(s)
=
-rac{zeta(s)}{s,n^s},
qquad
mathcal Mchi(s)=rac1s,
]

the residual is

[
mathcal M(chi-v_N)(s)
=
rac{1-zeta(s)V_N(s)}{s}.
]

Thus no measure or normalization conversion is needed: BCF’s Dirichlet
polynomial is the Mellin-side polynomial for the already-fixed
(L^2((0,infty),dx)) model.

## 3. BCF Lemma 2 — unconditional identity

For (0<Re(s)<1), BCF prove unconditionally

[
V_N(s)
=
rac1{zeta(s)}
left(
1-rac1{log N}rac{zeta'}{zeta}(s)
ight)
+
rac1{log N}sum_ho R_N(ho,s)
+
rac1{log N}F_s(1/N),
]

where the sum is over distinct non-trivial zeros and

[
R_N(ho,s)
=
operatorname{Res}_{z=ho}
rac{N^{z-s}}{zeta(z)(z-s)^2}.
]

They also give the explicit entire function

[
F_s(z)
=
pi z^s
sum_{n=1}^{infty}
rac{(-1)^n(2pi)^{2n+1}z^{2n}}
{(2n)!,zeta(2n+1)(2n+s)^2}.
]

Classification in this repository:

[
oxed{	exttt{PROVED_EXTERNAL_UNCONDITIONAL_IDENTITY}}
]

This classification applies only to the identity above, not to convergence of
the Nyman–Beurling error.

Multiplying by (zeta(s)) gives the exact residual decomposition

[
oxed{
1-zeta(s)V_N(s)
=
rac1{log N}
left[
rac{zeta'}{zeta}(s)
-zeta(s)sum_ho R_N(ho,s)
-zeta(s)F_s(1/N)
ight].
}
]

This is the sharpest currently audited analytic decomposition of the explicit
linear candidate.

## 4. What BCF prove only conditionally

BCF Theorem 1 assumes RH and

[
sum_{|Imho|le T}
rac1{|zeta'(ho)|^2}
ll T^{3/2-delta}
]

for some (delta>0). The condition implicitly requires simple zeros.

Under those assumptions they obtain the asymptotic

[
rac1{2pi}
int_{-infty}^{infty}
rac{
|1-zeta(	frac12+it)V_N(	frac12+it)|^2
}{
	frac14+t^2
},dt
sim
rac{2+gamma-log(4pi)}{log N}.
]

For the present R2 chain this is

[
oxed{	exttt{CIRCULAR_CONDITIONAL_ASYMPTOTIC}}
]

because RH is one of its hypotheses. It cannot be used to prove R2.

BCF Lemma 3 is likewise conditional: it assumes RH, simple zeros, and the
discrete (zeta'(ho)) moment bound to control the zero-residue sum.

## 5. New narrowed frontier

The unconditional Lemma 2 means the linear candidate no longer has an
undifferentiated “prove its mean square tends to zero” frontier. It decomposes
into three analytic pieces:

1. the logarithmic-derivative term (zeta'/zeta);
2. the zero-residue term (sum_ho R_N(ho,s));
3. the entire remainder (F_s(1/N)).

BCF’s proof handles the entire remainder by elementary decay and obtains the
needed zero-residue estimates only after imposing RH plus the
(zeta'(ho))-moment hypothesis.

Therefore the highest-value open obligation is recorded as

[
oxed{	exttt{ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL}}
]

meaning: obtain enough unconditional weighted (L^2) control of the BCF
residual decomposition, in particular its zero-residue contribution, to force

[
|chi-v_N|_2^2longrightarrow0.
]

Any such result must be checked for hidden RH-equivalent input. Since the final
vanishing itself is equivalent to RH through R1, an unconditional proof would
constitute the genuine open mathematical step.

## 6. Relation to the project’s finite alpha scan

The Arb finite-(N) scan found that among the tested fractional tapers,
(alphain[3/16,1/4]) performs better than (alpha=1) at
(Nle256). This is legitimate finite model evidence, but BCF identifies the
linear (alpha=1) family as the asymptotically optimal candidate under their
stated hypotheses.

Accordingly the fractional band is now classified as

[
	exttt{PREASYMPTOTIC_FINITE_N_DIAGNOSTIC},
]

not as an asymptotic theorem or preferred final route.

## 7. Firewall

- no `lean/` write;
- no project axiom;
- no `sorry`;
- `dnlimit_eq_zero_proved = false`;
- `rh_proved = false`;
- BCF Lemma 2: external unconditional identity;
- BCF Theorem 1 / Lemma 3: conditional and unusable for an unconditional R2 close.
