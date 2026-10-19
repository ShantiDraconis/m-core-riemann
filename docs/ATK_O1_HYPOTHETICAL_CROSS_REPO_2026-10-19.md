# ATK-O1 — Cross-repository research lane, hypothetical closure

**Scope:** documentation and research interface only. No unconditional RH claim.

## Source of truth
The precise Lean objects for the global O1 closure are in `ShantiDraconis/M-Core`, branch `atk/o1-hypothetical-formalization-20261019`:
- `atk-kernel/ATK/O1Hypothetical.lean`
- `conditional/ATK_O1_FORMAL_CONTRACT_2026-10-19.md`
- `atk-kernel/ATK/RiemannConcrete.lean`
- `atk-kernel/ATK/ObrigacoesMinimas.lean`

## Mathematics
For the actual Báez-Duarte approximation sequence `DN`, the existing formal chain is
`UniformLogBound → Tendsto DN atTop (𝓝 0) ↔ (⨅ N, DN N) = 0`,
and `Tendsto DN atTop (𝓝 0) → RiemannHypothesis`.
The key missing producer is a **proof of** `(⨅ N, DN N) = 0` without assuming RH or a logically equivalent hypothesis.

## Research obligations
1. Audit precise generators, integration domain, normalization, indexing and infimum definitions across repositories.
2. Develop genuine analytic inequalities with all constants and quantifiers explicit.
3. Test candidate inequalities numerically only as falsification, never as universal certification.
4. Reject rates incompatible with proved lower bounds. Do not assume geometric contraction.
5. Port successful *proved* estimates into the source-of-truth Lean module.
6. Check source SHA, Mathlib version, `lake build`, `#print axioms` and exact target alignment.

## Formal languages and modal status
The grammatical forms `ASSUMED`, `PROVED`, `FROZEN`, `CERTIFIED` are **audit labels**. They do not denote logical implication and cannot transform an assumed terminal into a proved one. Mathematical operators remain `∀`, `∃`, `≤`, `⨅`, `Tendsto`, `→`, `↔`.

## Status
`SOURCE_LINKED | RESEARCH_INTERFACE_CREATED | KERNEL_NOT_EXECUTED | TERMINAL_UNCONDITIONAL_OPEN`.
