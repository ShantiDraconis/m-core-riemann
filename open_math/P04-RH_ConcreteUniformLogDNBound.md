# P04-RH — ConcreteUniformLogDNBound

LANE: P04-RH  
HEAD: a32e91637425697f6e326bc1ceccb3119e8666df  
FREEZE: frozen/a32e91637425697f6e326bc1ceccb3119e8666df  
GAP ID: ConcreteUniformLogDNBound  
STATUS ATUAL: STRUCTURAL_OPEN_GAPS 0, MATERIAL_OPEN_GAPS 1, KERNEL_STRUCTURE CLOSED_TO_SINGLE_PRODUCER  
BUILD: PENDING_REAL_LEAN_EXECUTION

## PRODUCER CANÔNICO

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

## DEFINIÇÕES CONGELADAS

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
- preservar SOURCE GREEN
- preservar KERNEL GREEN no preflight
- produzir um habitante real de `ConcreteUniformLogDNBound`

## NOTA

Toda a estrutura terminal já está fechada. O restante não é engenharia nem transporte: é a desigualdade uniforme real. Qualquer PR que produza esse habitante e passe o kernel fecha automaticamente a composição até `RiemannTerminalCertifies`.

## MODELO QUE FAZ LAKE BUILD + KERNEL CERTIFICAR

### HABITANTE EXATO — ÚNICO PRODUTOR ACEITO

```lean
∃ K : ℝ, 0 ≤ K ∧
  ∀ N : ℕ,
    concreteNBData.DN concreteGeneratorFamily N ≤
      logMajorant K N
```

### DEFINIÇÕES CONGELADAS — NÃO EDITAR

- `frozen/a32e9163.../concreteNBData`
- `frozen/a32e9163.../concreteGeneratorFamily`
- `DN : GeneratorFamily → ℕ → ℝ`
- `logMajorant : ℝ → ℕ → ℝ`

### CRITÉRIO LEAN — PARA PASSAR

O arquivo produtor deve habitar exatamente o tipo acima.

Restrições:

- 0 `axiom`
- 0 `sorry`
- 0 `admit`
- 0 wrapper
- nenhuma hipótese equivalente
- não editar `MCore.lean`
- não editar `RHKernelEntry.lean`
- não editar `FinalKernelComposition.lean`

Deve passar:

```bash
lake build MCore
lake env lean audit/RHKernelAxiomAudit.lean
bash audit/rh_preflight_kernel.sh --strict
```

### CRITÉRIO KERNEL — PARA CERTIFICAR

Quando o critério Lean passar com um habitante real, a cadeia já fechada deve certificar automaticamente:

```text
ConcreteUniformLogDNBound
→ Nonempty ConcreteLogDNBound
→ ConcreteVanishingUpperBound
→ FINAL_ROOT
→ ConcreteGramResidual
→ FiniteSpanApproximatesChi
→ RiemannTerminalCertifies
```

Composição já existente:

- `lean/MCore/RH/R0/FinalKernelComposition.lean`
- `lean/MCore.lean`
- `lean/MCore/RH/R0/RHKernelEntry.lean`

### PROMOÇÃO FAIL-CLOSED

Nenhuma promoção manual para GREEN.

`BUILD` permanece `PENDING_REAL_LEAN_EXECUTION` até que o habitante uniforme real seja entregue e os três checks acima passem em Lean real.

