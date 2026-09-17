# R2 Gram formulas — exact normalization ledger

Model fixed by R0/R1:

- ambient: L2((0,infinity), dx)
- chi(x) = indicator_(0,1)(x) as an L2 class
- rho_a(x) = frac(1/(a*x)), a positive integer
- internal index: a = n + 1

No formula from a different measure is imported without an explicit change of variables.

## Target vector

For a >= 1,

b_a = <chi,rho_a>
    = integral_0^1 frac(1/(a*x)) dx
    = (log(a) + 1 - gamma) / a.

## Gram entry and change of variables

G_ab = integral_0^infinity frac(1/(a*x)) frac(1/(b*x)) dx.

With t = 1/x,

G_ab = integral_0^infinity frac(t/a) frac(t/b) dt/t^2.

This is exactly the multiplicative fractional-part autocorrelation appearing in the Vasyunin literature.

## GCD reduction

Let d = gcd(a,b), a = d*p, b = d*q, gcd(p,q)=1. Substituting t=d*u gives

G_ab = G_pq / d.

Thus only coprime entries need the explicit formula.

## Vasyunin formula used by the engine

For coprime positive integers p,q, define

V(p,q) = sum_{k=1}^{q-1} frac(k*p/q) cot(pi*k/q).

The implemented symmetric formula is

G_pq =
  (log(2*pi)-gamma)/2 * (1/p + 1/q)
  + (p-q)/(2*p*q) * log(q/p)
  - pi/(2*p*q) * (V(q,p) + V(p,q)).

For general a,b the engine applies the gcd reduction above.

## Projection defect

For G_N=(G_jk), b_N=(b_j), if the Gram matrix is invertible then the optimal finite coefficient vector satisfies

G_N c_N = b_N.

Since ||chi||_2^2 = 1,

DN_N = d_N^2 = 1 - b_N^T G_N^{-1} b_N.

The Arb backend solves the finite system with ball arithmetic. A successful non-approximate arb_mat solve is used only as a finite-N enclosure certificate. It does not prove DNLimit = 0.

## Provenance

- L. Baez-Duarte, A strengthening of the Nyman-Beurling criterion for the Riemann hypothesis, 2003.
- L. Baez-Duarte, Harmonic series summation lemma and Vasyunin's formulas, 2001 / J. Math. Sci. 2004.
- F. Alouges, S. Darses, E. Hillion, Polynomial approximations in a generalized Nyman-Beurling criterion, 2022; this explicitly states the finite system Gx=b with these b_k and Gram integrals.

The implementation is additionally cross-checked by an independent truncated-integral sanity test in validate_vasyunin.py.

Status: RESEARCH_ANALYTIC_INPUT. No RH claim.
