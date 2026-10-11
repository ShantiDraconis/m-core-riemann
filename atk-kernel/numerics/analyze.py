import csv, math, sys
from decimal import Decimal, getcontext
getcontext().prec = 50

def load(p):
    with open(p) as f:
        return [{k: Decimal(v) for k, v in r.items()} for r in csv.DictReader(f)]

a, b = load(sys.argv[1]), load(sys.argv[2])
n = min(len(a), len(b))
maxdiff = max(abs(a[i]["D_N"] - b[i]["D_N"]) for i in range(n))
mono = all(b[i + 1]["D_N"] <= b[i]["D_N"] for i in range(n - 1))
schur_pos = all(r["schur_s_N"] > 0 for r in b[:n])
kN = [(r["D_N_log_N_plus_2"], int(r["N"])) for r in b[:n]]
kmax, nmax = max(kN)
gamma = Decimal("0.57721566490153286060651209008240243104215933593992")
pi = Decimal("3.14159265358979323846264338327950288419716939937510")
C0 = 2 + gamma - (4 * pi).ln()

print(f"N calculados: {n}")
print(f"max |D_N(prec30) - D_N(prec45)| = {float(maxdiff):.2e}")
print(f"D_N monotona nao-crescente: {mono}")
print(f"complementos de Schur s_N > 0: {schur_pos}")
print(f"K_emp = max_N D_N log(N+2) = {kmax:.15f}  em N = {nmax}")
print(f"C0 = 2 + gamma - log(4 pi) = {C0:.15f}")
print()
print(f"{'N':>5} {'D_N':>20} {'D_N log(N+2)':>16} {'D_N log N':>12}")
for N in [1, 2, 3, 4, 5, 10, 20, 50, 100, 200, 300, 500, 700, 1000, 1200, 1500]:
    if N <= n:
        r = b[N - 1]
        print(f"{N:>5} {float(r['D_N']):>20.15f} {float(r['D_N_log_N_plus_2']):>16.10f} {float(r['D_N_log_N']):>12.8f}")

if n < 120:
    sys.exit(0)
# ajuste por minimos quadrados: D_N ~ c1/log N + c2/log^2 N  (N em [100, n])
xs = [(1 / math.log(N), 1 / math.log(N) ** 2, float(b[N - 1]["D_N"])) for N in range(100, n + 1)]
S11 = sum(x * x for x, _, _ in xs); S12 = sum(x * y for x, y, _ in xs); S22 = sum(y * y for _, y, _ in xs)
T1 = sum(x * d for x, _, d in xs); T2 = sum(y * d for _, y, d in xs)
det = S11 * S22 - S12 * S12
c1 = (T1 * S22 - T2 * S12) / det
c2 = (S11 * T2 - S12 * T1) / det
res = max(abs(d - c1 * x - c2 * y) for x, y, d in xs)
print()
print(f"ajuste D_N ~ c1/log N + c2/log^2 N  (100<=N<={n}):  c1 = {c1:.5f}, c2 = {c2:.5f}, resíduo max = {res:.1e}")
print(f"c1 / C0 = {c1 / float(C0):.4f}")
