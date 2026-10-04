# P04-RH — ConcreteUniformLogDNBound

LANE: P04-RH  
HEAD: a32e91637425697f6e326bc1ceccb3119e8666df  
FREEZE: PENDING_BUILD_GREEN  
GAP ID: ConcreteUniformLogDNBound  
STATUS ATUAL: STRUCTURAL_OPEN_GAPS=0, MATERIAL_OPEN_GAPS=1, KERNEL_STRUCTURE=CLOSED_TO_SINGLE_PRODUCER  
BUILD: PENDING_REAL_LEAN_EXECUTION

## PRODUTOR CANÔNICO

```lean
RHMaterialProducer := ConcreteUniformLogDNBound
```

## CADEIA TERMINAL FECHADA

- `lean/MCore/RH/R0/FinalKernelComposition.lean`
- `lean/MCore.lean`
- `lean/MCore/RH/R0/RHKernelEntry.lean`
- `audit/RHKernelAxiomAudit.lean`
- `audit/rh_preflight_kernel.sh`
- `audit/RH_FINAL_MATERIAL_LEDGER.json`

## HABITANTE EXATO REQUERIDO

```lean
∃ K : ℝ, 0 ≤ K ∧
  ∀ N : ℕ,
    concreteNBData.DN concreteGeneratorFamily N ≤
      logMajorant K N
```

## DEFINIÇÕES CONGELADAS / NÃO REABRIR

- `concreteNBData`
- `concreteGeneratorFamily`
- `DN`
- `logMajorant`

## CRITÉRIO DE ACEITAÇÃO

A construção deve ser em Lean e satisfazer simultaneamente:

- 0 novo `axiom`
- 0 `sorry`
- 0 `admit`
- 0 wrapper de hipótese equivalente
- sem assumir RH ou uma proposição equivalente
- manter SOURCE GREEN
- manter KERNEL GREEN no preflight
- passar `RHKernelAxiomAudit.lean`
- passar `lake build MCore`

## REGRA DE PROMOÇÃO

Não criar `frozen/`, não marcar GREEN terminal e não emitir certificado enquanto um habitante real de `RHMaterialProducer` não tiver sido aceito pelo kernel.

Após BUILD GREEN, o prefixo estrutural pode ser congelado separadamente; o OPEN_MATH permanece aberto até o habitante existir.

## NOTA

Toda a estrutura terminal está fechada. O único item restante é matemática nova: a desigualdade uniforme concreta acima.
