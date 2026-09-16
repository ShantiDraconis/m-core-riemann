# NB16 literal signature extraction

Evidence base: `e7e36d636a56ea23fbf7b534acb4eecba76bc6b6`.

This document records the frozen source literally enough to constrain R0. It does not add mathematical claims and does not modify any certified source.

## `NBHilbertData`

```lean
structure NBHilbertData where
  H : Type
  instNormedAddCommGroup : NormedAddCommGroup H
  instInnerProductSpace : InnerProductSpace ℝ H
  instCompleteSpace : CompleteSpace H
  chi : H
```

Thus `chi` is a field of the abstract Hilbert datum; there is no concrete Nyman--Beurling normalization in this structure.

## `GeneratorFamily`

```lean
def GeneratorFamily := ℕ → D.H
```

The abstract family is indexed by all Lean naturals. A future concrete R0 instance must explicitly settle the mathematical index shift if the chosen published generator convention begins at positive integers.

## finite generators and approximation space

```lean
def finiteGenerators (rho : D.GeneratorFamily) (N : ℕ) : Set D.H :=
  Set.range (fun n : Fin N => rho n)

def V (rho : D.GeneratorFamily) (N : ℕ) : Submodule ℝ D.H :=
  Submodule.span ℝ (D.finiteGenerators rho N)
```

So `V rho N` uses indices represented by `Fin N`, i.e. `0,...,N-1` at the Lean level.

## orthogonal projection

```lean
noncomputable def P (rho : D.GeneratorFamily) (N : ℕ) :
    D.H →L[ℝ] (D.V rho N) :=
  (D.V rho N).orthogonalProjection
```

## residual distance and squared defect

```lean
noncomputable def dN (rho : D.GeneratorFamily) (N : ℕ) : ℝ :=
  ‖D.chi - (D.P rho N D.chi : D.H)‖

noncomputable def DN (rho : D.GeneratorFamily) (N : ℕ) : ℝ :=
  (D.dN rho N) ^ 2
```

Therefore the frozen `DN` is **the square of the projection residual norm**. R0 must preserve this exact quantity. It must not redefine `DN` as an unsquared distance.

## canonical limit

```lean
noncomputable def DNLimit (rho : D.GeneratorFamily) : ℝ :=
  ⨅ N : ℕ, D.DN rho N
```

Certified source also exports:

```lean
theorem tendsto_DN_DNLimit (rho : D.GeneratorFamily) :
    Filter.Tendsto (D.DN rho) Filter.atTop (nhds (D.DNLimit rho))

theorem DNLimit_nonneg (rho : D.GeneratorFamily) :
    0 ≤ D.DNLimit rho
```

## zero-limit frontier

```lean
def DNToZero (rho : D.GeneratorFamily) : Prop :=
  Filter.Tendsto (D.DN rho) Filter.atTop (nhds 0)

theorem DNToZero_iff_DNLimit_eq_zero (rho : D.GeneratorFamily) :
    D.DNToZero rho ↔ D.DNLimit rho = 0
```

The frozen source therefore proves an equivalence between convergence of the **squared defect sequence** to zero and equality of its canonical infimum limit to zero. It does not identify this abstract proposition with RH.

## Immediate R0 constraints extracted from the source

1. R0 must instantiate/preserve a real complete inner-product space and the distinguished `chi`.
2. A concrete positive-integer generator convention needs an explicit index map from Lean `n : ℕ` to the published generator index; no silent `0 ↔ 1` shift is allowed.
3. Concrete finite spans must correspond to the exact `Fin N` range used by `finiteGenerators`.
4. Any identification map used to transfer the defect must preserve norm; a mere linear equivalence is insufficient.
5. R0.5/R0.6.5 must preserve `dN` and `DN = dN^2` separately.
6. No statement `RH ↔ DNLimit = 0` belongs to NB16/NB_TOTAL. Such an identification requires the later concrete normalization and external-criterion bridge.
