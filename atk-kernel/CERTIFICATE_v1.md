# Certificado ATK v1 — ShantiDraconis/m-core-riemann

- Commit verificado: `bed63e8e13170b6a98a8263c6d62d0473c237119` (tag `atk-kernel-cert-v1`)
- Gerado em: 2026-10-11T23:51:41+00:00
- Teoremas aceitos pelo kernel: **8/8**

## ATK kernel check
- Execução: https://github.com/ShantiDraconis/m-core-riemann/actions/runs/38185383935
- Lean (version 4.34.1, x86_64-unknown-linux-gnu, commit 5045d0056413266e57c625dcd7c365b10e377c52, Release)
- SHA-256 das fontes: `a24fea206ce246d35b1448d90c0351086cbdd81def50c2b57e40bcf50f70fe94`
- Job “RH — D_N real (Nyman–Beurling / Báez-Duarte)”: success
- Job “Lean 4 + Mathlib — compilação e auditoria de axiomas”: success

| Teorema | Veredito | Axiomas |
|---|---|---|
| `ATK.Riemann.residual_tendsto_zero` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.Riemann.schur_step_monotone` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.Riemann.gram_complete_square` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.Riemann.gram_residual_le` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.Riemann.abstract_bound_vacuous` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.Riemann.bdDistSq_nonneg` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.Riemann.bd_bound_tendsto` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.Riemann.rh_of_bd_bound` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |

Lemas auxiliares e cálculos concretos. Nenhuma das sete conjecturas foi provada; OPEN_MATH=true.
