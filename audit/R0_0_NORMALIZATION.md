# R0.0 — normalization gate

Status: SPECIFICATION_AUDIT / no RH promotion.

## Canonical external model selected

For the concrete identification layer we pin the strong Nyman–Beurling / Báez-Duarte model on `L²(0,∞)`:

- fractional part: `rho(x) = x - floor(x)`;
- target: `chi = 1_(0,1)`;
- dilates: `rho_a(x) = rho(1/(a*x))` for `a >= 1`;
- strong arithmetic family restricts `a` to positive integers.

Primary literature: Luis Báez-Duarte, *A strengthening of the Nyman-Beurling criterion for the Riemann Hypothesis*, arXiv:math/0202141 (2002).

## Indexing firewall

The frozen abstract interface uses `GeneratorFamily := ℕ → H` and `finiteGenerators` via `Fin N`, hence abstract indices are `0,...,N-1`.

The concrete arithmetic family is indexed by positive integers `a = 1,2,...`. Therefore R0 MUST use the explicit shift

`a(n) = n + 1`

when mapping the abstract natural index `n` to a Báez-Duarte dilation parameter. No silent 0/1 indexing identification is permitted.

## Convention firewall

This gate selects the `L²(0,∞)` convention above. It MUST NOT silently mix the alternative `L²(0,1)` Nyman functions `eta_alpha(t) = {alpha/t} - alpha {1/t}` with this model. Any later equivalence between conventions requires an explicit proved isometry/transform.

## R0.0 obligations

1. Declare the concrete normalization/specification without altering frozen NB definitions.
2. Record the positive-integer shift explicitly.
3. Keep the concrete Hilbert-space realization separate from the abstract `NBHilbertData` until the required analytic objects are formalized.
4. No theorem in R0.0 may assert RH, `DNToZero`, `DNLimit = 0`, density, or closure.
5. No `sorry`, `admit`, project scientific `axiom`, `native_decide`, unsafe proof bypass, or vacuous endpoint.
6. R0.1 and later must consume this convention rather than redefine it.

## Next gate

R0.1: formalize the concrete carrier/measure-space interface needed for `L²(0,∞)` and the target/generator objects, preserving this normalization. Analytic measurability/integrability obligations must be proved or explicitly left as OPEN interfaces; they may not be smuggled in as axioms.
