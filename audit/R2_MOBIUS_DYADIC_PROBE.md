# R2 Möbius dyadic taper probe — finite-N only

Status: **INTERVAL_CERTIFIED_FINITE_N_MODEL_EVIDENCE**.

This diagnostic belongs only to the Riemann / Nyman–Beurling R2 research
branch. It does not alter R0/R1, does not touch `lean/`, and does not prove
`DNLimit = 0`.

## Provenance

Optimized-scale dyadic scan:
- source SHA: `2b26cec7775e0a1550f6d294f67e68b01f052d99`
- workflow run: `35285797407`
- job: `105417711482`
- artifact: `10524221363`
- artifact SHA-256:
  `66ec4a56eb43db3f5ff2bca0d6058a417dcec3b8bbebfb00cc4029c94f024e41`

Fixed-scale extension:
- source SHA: `8514832357cedace6bf78733c42e6c1d258c6176`
- workflow run: `35285974111`
- job: `105418254059`
- artifact: `10523049716`
- artifact SHA-256:
  `43711c300c363fdced9dd114c485606f8e5d55ee75f9cb1c469383ba2f6eb82d`

Runtime: Python 3.12 + python-flint 0.9.0 / Arb, 140 decimal digits.

## Family

For dyadic exponents alpha=m/16, define

[
w_{N,alpha}(n)
=
left(1-rac{log n}{log N}ight)^alpha,
qquad
1le nle N,
]

and the Möbius coefficient shape

[
v_{N,alpha,n}=-mu(n)w_{N,alpha}(n).
]

Two finite problems were tested:

1. fixed scale (A=1);
2. Gram-energy optimized scalar
   [
   A_*=rac{b^Tv}{v^TGv},
   qquad
   E_*^2=1-rac{(b^Tv)^2}{v^TGv}.
   ]

The second is diagnostic only because (A_*) itself depends on the finite Gram
data. The first is a genuinely explicit coefficient family.

## Best exponent on the m/16 grid

| N | best alpha, optimized scale | optimized E² | best alpha, fixed A=1 | fixed E² |
|---:|:---:|---:|:---:|---:|
| 32 | 4/16 | 0.0308828624175162083764677550 | 4/16 | 0.0320782211842448527382143898 |
| 64 | 4/16 | 0.0309038840552981892017331933 | 3/16 | 0.0389805141942446961209735424 |
| 128 | 4/16 | 0.0214268793068810877429229869 | 3/16 | 0.0241445144832290392658932855 |
| 256 | 5/16 | 0.0201060763413549893088794636 | 3/16 | 0.0247209079237184593241720718 |

Thus the finite evidence selects a narrow band near alpha in [3/16, 1/4];
there is no stable exact exponent theorem.

## Two fixed explicit candidates

### alpha = 3/16

| N | E² | E² log N |
|---:|---:|---:|
| 32 | 0.0337213635149486633999064102 | 0.11686934022511837 |
| 64 | 0.0389805141942446961209735424 | 0.16211540106310582 |
| 128 | 0.0241445144832290392658932855 | 0.11714991498027280 |
| 256 | 0.0247209079237184593241720718 | 0.13708182102565970 |

### alpha = 1/4

| N | E² | E² log N |
|---:|---:|---:|
| 32 | 0.0320782211842448527382143898 | 0.11117464285618815 |
| 64 | 0.0418287765532844570885204252 | 0.17396099120508640 |
| 128 | 0.0259676864674593687818596317 | 0.12599600062408875 |
| 256 | 0.0253037473873712228476827913 | 0.14031376927325956 |

These four finite points are compatible with an O(1/log N) scale, but they do
not prove such a bound and must not be extrapolated as a theorem.

## Exact Mellin target for an explicit taper

Let

[
P_{N,alpha}(s)
=
sum_{nle N}
rac{mu(n)w_{N,alpha}(n)}{n^s}.
]

For the explicit approximant

[
v_{N,alpha}
=
-sum_{nle N}mu(n)w_{N,alpha}(n)ho_n,
]

the Mellin transforms

[
mathcal Mchi(s)=rac1s,
qquad
mathcal Mho_n(s)=-rac{zeta(s)}{s,n^s}
]

give the residual transform

[
mathcal M(chi-v_{N,alpha})(s)
=
rac{1-zeta(s)P_{N,alpha}(s)}{s}.
]

Therefore Mellin–Plancherel on Re(s)=1/2 gives

[
oxed{
E_{N,alpha}^2
=
rac1{2pi}
int_{-infty}^{infty}
rac{
left|1-zeta(	frac12+it)
P_{N,alpha}(	frac12+it)ight|^2
}{
	frac14+t^2
},dt.
}
]

This is the analytic target selected by the finite experiment.

To close R2 with this family one must prove, **unconditionally**, that the
right-hand side tends to zero for one fixed explicit choice of alpha (or for
another explicitly defined weight). Such a proof would already deliver the
RH-equivalent Nyman–Beurling endpoint exposed by R1.

## Research classification

- finite Arb calculations: INTERVAL_CERTIFIED_FINITE_N_MODEL_EVIDENCE
- exponent band [3/16,1/4]: RESEARCH_CANDIDATE
- uniform weighted mean-square estimate -> 0: OPEN_MATH
- dnlimit_eq_zero_proved: false
- rh_proved: false
