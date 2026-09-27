# R2 — No-go for a t-dependent BCF mollifier

Status: FAIL-CLOSED DESIGN AUDIT

## Proposed redesign

A proposed route replaces the fixed Dirichlet polynomial

  V_N(s) = sum_{n<=N} a_{N,n} n^{-s}

by a boundary-dependent object

  V_{N,t}(1/2+it) = sum_{n<=L(t)} a_{N,n}(t) n^{-1/2-it},

with L(t) large near t=0 and decaying in the tail.

## First real obstruction: loss of holomorphy

The BCF contour argument is an argument in the complex variable s.  A function
whose coefficients or truncation length depend on t = Im(s) is not, in
general, holomorphic in s.  Therefore the residue theorem / contour shift used
to obtain the BCF zero-residue decomposition is no longer available.

This is not repaired by adding a partial_t V term.  Cauchy's theorem requires a
holomorphic integrand (or a separately justified non-holomorphic Stokes/d-bar
argument).  A t-dependent cutoff introduces d-bar content, not merely an extra
ordinary derivative term in the old BCF identity.

## Second real obstruction: loss of the fixed Nyman-Beurling vector

The certified Hilbert-space chain bounds DN_N using one fixed vector

  v_N = sum_{n<=N} c_{N,n} rho_n.

Its Mellin transform has coefficients c_{N,n} that are independent of t.  If
the coefficients or support depend on t, the boundary function V_{N,t} is not
the Mellin transform of that fixed finite linear combination.  Hence an L2
bound for 1 - zeta(s)V_{N,t}(s) does not automatically imply

  DN_N <= eps_N

in the existing NBHilbertData interface.

Thus the proposed t-dependent mollifier breaks both:
1. the BCF contour identity;
2. the certified DN upper-bound interpretation.

## Consequence

The claimed route

  t-dependent mollifier
    -> rederive BCF with an extra partial_t term
    -> same main term
    -> BCFZeroResidueControl

is INVALID AS STATED.

## Valid redesign space

Any replacement must preserve both requirements:

A. analytic/contour requirement:
   use a function holomorphic (preferably entire/meromorphic with audited poles)
   in s on the contour domain;

B. Hilbert-candidate requirement:
   its critical-line boundary values must correspond to the Mellin transform of
   one fixed admissible Nyman-Beurling approximant, or a new theorem must prove
   that the broader class still upper-bounds the certified DN target.

Candidate directions:

1. fixed coefficients with analytic smoothing in n/N;
2. a holomorphic two-parameter family W_N(s) with coefficients independent of
   Im(s);
3. a d-bar/non-holomorphic contour formula, together with a new Hilbert-space
   realization theorem (substantially different route).

## Correct next delta

R-ZR1-M1b-REDESIGN :=
HOLomorphic_MOLLIFIER_WITH_FIXED_NB_REALIZATION

Required:
construct W_N(s) such that
- W_N is holomorphic on the required strip/contour domain;
- W_N(1/2+it) is the Mellin image of one fixed admissible NB approximant;
- the BCF-style complete-bracket identity remains valid or is replaced by a
  rigorously proved analogue;
- the tail is smaller than for the current fixed linear mollifier strongly
  enough to remove the B/C tradeoff.

## Status

T_DEPENDENT_MOLLIFIER = REJECTED_AS_STATED
BCF_HOLOMORPHY = REQUIRED
FIXED_NB_VECTOR_REALIZATION = REQUIRED
HOLOMORPHIC_MOLLIFIER_REDESIGN = OPEN_MATH
DNLimit_EQ_ZERO = false
RH_PROVED = false
