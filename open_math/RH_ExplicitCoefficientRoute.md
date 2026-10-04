# R0-RH — explicit coefficient route to the material producer

Status: **analytic derivation / kernel coefficient reduction SOURCE_READY / zeta bridge OPEN_MATH**

Kernel reduction commit: `bc840699f43f79435576ca17f5444a3ed7b50edc`

## 1. Exact finite coefficient producer

The kernel now has `ConcreteCoefficientLogRate`:

```lean
structure ConcreteCoefficientLogRate where
  K : ℝ
  hK : 0 ≤ K
  coeff : (N : ℕ) → Fin N → ℝ
  error_sq_le :
    ∀ N,
      ‖concreteNBData.chi -
        concreteNBData.coefficientApproximantAt
          concreteGeneratorFamily N (coeff N)‖ ^ 2
      ≤ logMajorant K N
```

and proves exactly

```text
Nonempty ConcreteCoefficientLogRate
↔ ConcreteUniformLogDNBound.
```

The forward direction uses the already-certified optimal-projection inequality

```text
DN(N) ≤ ‖chi - v_N‖².
```

The reverse direction chooses the finite coefficient vector realizing the
orthogonal projection at each N. This is a normalization of the same material
gap, not a new assumption and not a terminal promotion.

## 2. Frozen concrete family

For repository index `n : ℕ`,

```text
a = n+1
rho_n(x) = { 1 / (a x) }.
```

The target is

```text
chi(x) = 1_(0,1)(x).
```

For a finite coefficient vector `c : Fin N → ℝ` define

```text
v_c(x) = Σ_{i<N} c_i rho_i(x).
```

## 3. Mellin transform with the repository sign convention

Let `s` satisfy `0 < Re(s) < 1`. Directly,

```text
M chi(s) = ∫_0^∞ chi(x) x^(s-1) dx = 1/s.
```

For `a=n+1`,

```text
M rho_n(s)
 = ∫_0^∞ {1/(a x)} x^(s-1) dx.
```

With `t = 1/(a x)`,

```text
M rho_n(s)
 = a^(-s) ∫_0^∞ {t} t^(-s-1) dt
 = - a^(-s) ζ(s)/s.
```

Therefore if

```text
P_c(s) = Σ_{i<N} c_i (i+1)^(-s),
```

then

```text
M(chi - v_c)(s)
 = (1 + ζ(s) P_c(s))/s.
```

**Sign firewall:** for arbitrary repository coefficients `c_i`, the residual
is `1 + ζ P_c`. The frequently written `1 - ζ V_N` corresponds to choosing
`c_i = -μ(i+1) w_N(i+1)` and defining
`V_N(s)=Σ μ(a)w_N(a)a^{-s}`.

## 4. Critical-line Plancherel identity

Mellin-Plancherel on `Re(s)=1/2` gives the target identity

```text
‖chi - v_c‖²
 =
(1 / 2π) ∫_{t∈ℝ}
  |1 + ζ(1/2+it) P_c(1/2+it)|²
  / (1/4+t²) dt.
```

For the Möbius-sign convention
`c_{N,a}=-μ(a)w_N(a)`, this becomes

```text
‖chi - v_N‖²
 =
(1 / 2π) ∫_{t∈ℝ}
  |1 - ζ(1/2+it) V_N(1/2+it)|²
  / (1/4+t²) dt.
```

This is the analytic bridge required to turn a Dirichlet-polynomial estimate
into `ConcreteCoefficientLogRate`.

## 5. Exact remaining producer after the coefficient reduction

It is now sufficient — and by optimal coefficients no stronger than the
canonical gap — to construct explicit `K ≥ 0` and coefficients `c_N` such
that

```text
∀ N,
(1 / 2π) ∫_ℝ
  |1 + ζ(1/2+it) P_{c_N}(1/2+it)|²
  / (1/4+t²) dt
≤ K / log(N+2).
```

A proof of that estimate without RH/equivalent input yields
`ConcreteCoefficientLogRate`, hence `ConcreteUniformLogDNBound`, hence the
terminal chain.

## 6. Literature boundary

Báez-Duarte proves the integer-dilate Nyman-Beurling criterion and, under RH,
constructs approximants with qualitative convergence. Bettin-Conrey-Farmer
analyze a linear Möbius taper and obtain the conjectural `1/log N` asymptotic
under RH plus an additional discrete moment bound involving
`1/|ζ'(ρ)|²`.

Thus the missing unconditional estimate above is not supplied by those
results. Importing their conditional asymptotic would be circular for the
current producer.

## 7. Status

```text
FINITE_HILBERT_COEFFICIENT_REDUCTION = SOURCE_READY
MELLIN_SIGN_NORMALIZATION = DERIVED
MELLIN_PLANCHEREL_KERNEL_FORMALIZATION = NOT_YET_IN_LEAN
UNCONDITIONAL_ZETA_ERROR_RATE = OPEN_MATH
MATERIAL_OPEN_GAPS = 1
```
