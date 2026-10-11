"""Uso: python3 run_dn.py NMAX PREC SAIDA.csv"""
import sys, time
sys.path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
from decimal import Decimal, getcontext
import nb_gram as nb

nmax, prec, out = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3]
getcontext().prec = prec
K = nb.Constants()
C0 = 2 + K.gamma - (4 * K.pi).ln()          # 2 + gamma - log(4 pi) = soma 1/(rho(1-rho))
t0 = time.time()
rows = nb.residuals(nmax, K, progress=100)
with open(out, "w") as f:
    f.write("N,D_N,D_N_log_N_plus_2,D_N_log_N,schur_s_N\n")
    for n, d, piv in rows:
        f.write(f"{n},{d},{d * Decimal(n + 2).ln()},{d * Decimal(n).ln()},{piv * piv}\n")
print(f"OK prec={prec} N={nmax} tempo={time.time() - t0:.0f}s C0={C0}")
