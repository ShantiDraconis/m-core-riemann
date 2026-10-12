"""ATK — FICHA, corpo RH (proposta "UniformTauberian"): norma do operador de Möbius truncado
    (H_N f)(k) = Σ_{j : kj ≤ N} μ(j) f(kj) / j      em ℓ²({1,…,N}),
comparada com D_N·log N (dados reais em dn_N1500_prec45.csv).
O adjunto de H é a convolução de Dirichlet por μ(j)/j, isto é, a multiplicação por 1/ζ(1+s) no espaço de
Hardy de séries de Dirichlet; a norma do operador completo é sup_{Re s>0} |1/ζ(1+s)|, que é infinita porque
1/ζ(1+it) não é limitada (Titchmarsh, cap. 8). Os truncamentos H_N crescem devagar (≈ log log N).
uso: python3 mobius_operator_norm.py [dn_N1500_prec45.csv]
"""
import csv, math, sys
import numpy as np

def mobius(n):
    mu = np.ones(n + 1, dtype=int); mu[0] = 0
    is_p = np.ones(n + 1, dtype=bool); is_p[:2] = False
    for p in range(2, n + 1):
        if is_p[p]:
            is_p[2 * p::p] = False
            mu[p::p] *= -1
            mu[p * p::p * p] = 0
    return mu

NMAX = 1500
mu = mobius(NMAX)
dn = {}
if len(sys.argv) > 1:
    dn = {int(r["N"]): float(r["D_N"]) for r in csv.DictReader(open(sys.argv[1]))}
print(f"{'N':>6}{'‖H_N‖':>12}{'log log N':>12}{'D_N·log N':>14}{'D_N·log N ≤ ‖H_N‖?':>22}")
for N in (10, 50, 100, 300, 600, 1000, 1500):
    H = np.zeros((N, N))
    for k in range(1, N + 1):
        for j in range(1, N // k + 1):
            if mu[j]:
                H[k - 1, k * j - 1] = mu[j] / j
    nrm = np.linalg.norm(H, 2)
    d = dn.get(N)
    dl = d * math.log(N) if d is not None else float("nan")
    print(f"{N:>6}{nrm:>12.6f}{math.log(math.log(N)):>12.6f}{dl:>14.6f}{str(dl <= nrm) if d is not None else '—':>22}")
print("\n‖H_N‖ cresce com N (não há K uniforme); D_N·log N ≤ ‖H_N‖ vale nos dados mas não tem prova nem conteúdo:")
print("o lado direito não depende da RH. A taxa uniforme (itens 10/48) continua sendo o enunciado aberto.")
