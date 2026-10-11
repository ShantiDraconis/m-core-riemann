# verifica b_k = <chi, rho_k> = int_1^inf {x/k} x^-2 dx = (log k + 1 - gamma)/k  por integração direta
import sys; sys.path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
from decimal import Decimal, getcontext
import nb_gram as nb
getcontext().prec = 40
K = nb.Constants()
def direct_b(k, M):
    X = k * M
    tot = Decimal(0)
    # intervalo [1, k): {x/k} = x/k  -> int x/k / x^2 = log(k)/k
    tot += Decimal(k).ln() / k
    for a in range(1, M):
        u, v = Decimal(k * a), Decimal(k * (a + 1))
        tot += (v.ln() - u.ln()) / k - a * (1 / u - 1 / v)
    return tot + Decimal(1) / 2 / X          # cauda: média 1/2
for k in [1, 2, 3, 7, 10]:
    r = (4 * direct_b(k, 40000) - direct_b(k, 20000)) / 3
    print(k, f"{float(abs(r - nb.b_entry(k, K))):.1e}")
