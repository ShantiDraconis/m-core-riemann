# ATK — os 72 parâmetros: o que foi calculado de verdade

Legenda: **REAL** = calculado sobre o objeto matemático do problema · **LEAN** = certificado pelo kernel
(job `kernel`) · **ABERTO** = afirmação universal; nenhum cálculo a fornece.

## Riemann (14) — repositório m-core-riemann, `atk-kernel/numerics/`

Sistema real: Nyman–Beurling/Báez-Duarte, χ = 1₍₀,₁₎, ρₖ(t) = {1/(kt)} em L²(0,∞); Gram pela fórmula de
Vasyunin, conferida por integração direta em 14 pares (erro ≤ 2.4·10⁻¹²).

| Nº | Parâmetro | Antes (modelo 2×2) | Agora | Estado |
|---|---|---|---|---|
| 1 | Gram2_det | 3 | 0.198326449587843 | REAL |
| 2 | Gram2_eigen_min | 1 | 0.111447891180725 | REAL |
| 3 | Gram2_eigen_max | 3 | 1.77954421108099 | REAL |
| 4 | Gram2_condition | 3 | 15.9675000776396 | REAL |
| 5 | DN2 | 5/6 | 0.289964573742203 | REAL |
| 6 | DN3 | 7/12 | 0.0938372284969833 | REAL |
| 7 | DN_step (D₂ − D₃) | 1/4 | 0.196127345245219 | REAL |
| 8 | DN_ratio (D₃/D₂) | 7/10 | 0.3236161827838 | REAL |
| 9 | DN_relative_reduction | 3/10 | 0.6763838172162 | REAL |
| 10 | K_star = sup D_N log(N+2) | — | ≥ 0.942842305946176 (atingido em N = 1, N ≤ 1500) | REAL (cota inferior); finitude ABERTA |
| 45 | DN_concrete | — | D₁…D₁₅₀₀ em `dn_N1500_prec45.csv` (30 vs 45 dígitos: 5.6·10⁻²⁸) | REAL |
| 46 | Schur_increment | — | D_{N−1} − D_N > 0 para todo N ≤ 1500 | REAL; monotonia LEAN |
| 47 | Schur_completeness (D_N → 0) | — | equivale a RH (Báez-Duarte) | ABERTO |
| 48 | uniform_log_rate | — | D_N·log N ∈ [0.0442, 0.0478] para 100 ≤ N ≤ 1500, perto de 2+γ−log 4π ≈ 0.0462 | ABERTO |

Observação de auditoria: em `m-core-riemann/lean/MCore/Material/Closure.lean`, `ConcreteUniformLogDNBound`
recebe uma sequência `DN : Nat → Real` qualquer. Para `DN = 0` ela vale trivialmente; só diz algo sobre RH
se `DN` for definida como a distância de Báez-Duarte acima.

## Navier–Stokes (16) — repositório m-core-openai-ns-audit, `atk-kernel/ns_data/`

| Nº | Parâmetro | Valor | Estado |
|---|---|---|---|
| 11–14 | Young p, q, coef., coef. derivada | 4/3, 4, 27/32, 27/16 | exatos |
| 15 | toy_delta | 5/12 | modelo |
| 16–18, 20–21 | δ, c_B, c_T, c_B*, c_T* | Taylor–Green: max S/(νz) = 2.776 (Re 100), 5.672 (Re 200), 11.458 (Re 400) ⇒ **não existe** c_B + c_T < 1 com bulk + tail = S | REAL |
| 19 | C_min (resto R ≤ C y², θ = 0.7) | 5.48·10⁻⁴ / 6.42·10⁻⁴ / 6.88·10⁻⁴ | REAL (só esta solução) |
| 49–53 | denominadores nulos, orçamento, integral do resto | — | ABERTO |

As hipóteses BulkAbsorption + ExceptionalTailControl + SubcriticalBudget do G1 implicam y' < 0;
a solução de Taylor–Green tem y' > 0 em 45–75% do tempo. Elas são falsas para soluções reais.

## Yang–Mills (17) — m-core-yang-mills

| Nº | Parâmetro | Estado |
|---|---|---|
| 22–33 | derivadas/primitivas do correlator de referência, gap do modelo = 2 | modelo, não é a teoria 4D |
| 34, 54–57 | gap físico, toPhysical, sobrejetividade, limite contínuo, prova do gap | ABERTO |
| — | Cauchy–Schwarz ponderado ⇒ massa efetiva não cresce | LEAN |

## BSD (8) — repositório m-core-bsd, `atk-kernel/bsd_data/`

| Nº | Parâmetro | Valor | Estado |
|---|---|---|---|
| 35 | regulator (rank 2) | modelo 5 → real: 389a1 Reg = 0.152460177943144 | REAL |
| 36 | h22 | modelo 3 → real: 37a1 ĥ(P) = 0.0511114082399688 | REAL |
| 37, 58 | rank_residual | r_an = r_alg em 10 curvas (postos 0 a 4) | REAL caso a caso; prova ABERTA |
| 38, 59 | torsion_positive | #tors ≥ 1 (contém a identidade); medido: 1, 2, 4, 5, 6 | imediato |
| 39, 60 | quotient_identity | Ш_an ∈ {1, 4, 9, 25}, quadrado inteiro nas 10 curvas | REAL caso a caso; prova ABERTA |
| — | det 2×2, Reg > 0, recuperação de #Ш | — | LEAN |

## Hodge (4) — m-core-hodge
40 (coeficientes) — LEAN só a parte linear (M invertível ⇒ c = M⁻¹α único). 61–63 — ABERTO.

## Beal (6) — m-core-beal
41 gcd(x,y,z) ≤ 2 — LEAN, com Fermat como hipótese explícita. 42, 64–67 (exclusão do contraexemplo primitivo,
descida) — ABERTO.

## P ≠ NP (7) — m-core-p-vs-np
43 grau da composição — exato (d·k). 44, 68–72 (máquina, aceitação, parada polinomial, semântica, cota inferior)
— ABERTO. LEAN: só a forma lógica das implicações.

---
Nenhum parâmetro terminal foi fechado: `OPEN_MATH = true` nas sete conjecturas.
