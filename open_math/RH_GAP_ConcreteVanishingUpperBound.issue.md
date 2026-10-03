# RH — ConcreteVanishingUpperBound

LANE: RH  
HEAD: 6834487c1da552177529879e6d719548e6f9a5bf  
BRANCH/FREEZE SOURCE: atk/terminal-parameter-law-20261003  
GAP ID: Nonempty ConcreteVanishingUpperBound  
STATUS ATUAL: structural chain ready; MATH OPEN_MATH 1.

## Definição exata do que falta

```lean
abbrev ConcreteVanishingUpperBound : Type :=
  concreteNBData.VanishingUpperBound concreteGeneratorFamily
```

Decomposição já provada:

```lean
Nonempty ConcreteVanishingUpperBound ↔
  ∃ eps : ℕ → ℝ,
    (∀ N, 0 ≤ eps N) ∧
    (∀ N, concreteNBData.DN concreteGeneratorFamily N ≤ eps N) ∧
    Filter.Tendsto eps Filter.atTop (nhds 0)
```

## Critério de aceite

- 0 `sorry`
- 0 `admit`
- 0 `axiom` novo
- `lake build MCore` SUCCESS
- `RHKernelAxiomAudit` SUCCESS
- `RHKernelEntry` SUCCESS
- majorante `eps` explícito
- prova literal de não-negatividade
- prova literal de `DN ≤ eps`
- prova literal de `eps → 0`
- não usar RH/RiemannTerminalCertifies como hipótese

## Rota canônica

```text
ConcreteVanishingUpperBound
→ FINAL_ROOT
→ ConcreteGramResidual
→ FiniteSpanApproximatesChi
→ RiemannTerminalCertifies
```

## O que não conta

- assumir `DNLimit = 0`
- assumir o endpoint de Nyman–Beurling
- majorante que contém a própria convergência como hipótese
- extrapolação numérica finita sem desigualdade universal

## Pedido

Construir um `eps : ℕ → ℝ` explícito para a sequência DN concreta que satisfaça as três obrigações do tipo e passe integralmente no `RHKernelAxiomAudit`.
