# Certificado ATK v2 — ShantiDraconis/m-core-riemann

- Commit verificado: `a9cf4ac4f99648cad6e41fd88ba579d86acdf89d` (tag `atk-kernel-cert-v2`)
- Gerado em: 2026-10-12T00:46:19+00:00
- Teoremas aceitos pelo kernel: **13/13**

## ATK kernel check
- Execução: https://github.com/ShantiDraconis/m-core-riemann/actions/runs/38188852004
- Lean (version 4.34.1, x86_64-unknown-linux-gnu, commit 5045d0056413266e57c625dcd7c365b10e377c52, Release)
- SHA-256 das fontes: `77d48ba47dcc82e96dd8898b3731de2cfd2809e61ffd7b77be44c45acee40edf`
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
| `ATK.RHConvergence.bdDistSq_succ_le` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.RHConvergence.bdDistSq_antitone` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.RHConvergence.bdDistSq_converges` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.RHConvergence.bdDistSq_limit_nonneg` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.RHConvergence.rh_iff_limit_zero_of_criterion` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |

Lemas auxiliares e cálculos concretos. Nenhuma das sete conjecturas foi provada; OPEN_MATH=true.
