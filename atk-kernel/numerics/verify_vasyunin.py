"""
Verificação independente da fórmula de Vasyunin por integração direta:

  <rho_h, rho_k> = int_0^inf {x/h}{x/k} x^-2 dx

Integração exata por partes em cada intervalo onde floor(x/h), floor(x/k) são constantes,
até X = M*lcm(h,k); cauda = mu/X + c/X^2 + O(X^-3), eliminada por extrapolação de Richardson
(M e 2M). mu = média exata (racional) de {x/h}{x/k} num período.
"""
import sys
from decimal import Decimal, getcontext
from fractions import Fraction
from math import gcd
sys.path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
import nb_gram as nb

getcontext().prec = 40
K = nb.Constants()

PI_REF = "3.14159265358979323846264338327950288419716939937510"
GAMMA_REF = "0.57721566490153286060651209008240243104215933593992"
print("pi    ok:", str(K.pi)[:38] == PI_REF[:38])
print("gamma ok:", str(K.gamma)[:38] == GAMMA_REF[:38])


def lcm(a, b):
    return a * b // gcd(a, b)


def direct(h, k, M):
    L = lcm(h, k)
    X = L * M
    pts = sorted(set([h * i for i in range(X // h + 1)] + [k * i for i in range(X // k + 1)]))
    hD, kD = Decimal(h), Decimal(k)
    total = Decimal(min(h, k)) / (hD * kD)          # (0, min(h,k)): {x/h}{x/k} = x^2/(hk)
    for u, v in zip(pts, pts[1:]):
        if v <= min(h, k):
            continue
        a, b = u // h, u // k
        uD, vD = Decimal(u), Decimal(v)
        total += (vD - uD) / (hD * kD) - (Decimal(b) / hD + Decimal(a) / kD) * (vD.ln() - uD.ln()) \
                 + Decimal(a * b) * (1 / uD - 1 / vD)
    # média exata num período
    mu = Fraction(0)
    pp = sorted(set([h * i for i in range(L // h + 1)] + [k * i for i in range(L // k + 1)]))
    for u, v in zip(pp, pp[1:]):
        a, b = Fraction(u // h), Fraction(u // k)
        # int_u^v (x/h - a)(x/k - b) dx
        F = lambda x: Fraction(x**3, 3 * h * k) - (a / k + b / h) * Fraction(x**2, 2) + a * b * x
        mu += F(v) - F(u)
    mu /= L
    return total + Decimal(mu.numerator) / Decimal(mu.denominator) / X


def richardson(h, k, M):
    t1, t2 = direct(h, k, M), direct(h, k, 2 * M)
    return (4 * t2 - t1) / 3


def V_variant_h(h, k):  # variante com o inverso de h mod k, para descartar
    if k == 1:
        return Decimal(0)
    hb = pow(h, -1, k)
    cot = K.cot_table(k)
    return sum(((m * hb) % k) * cot[m] for m in range(1, k)) / k


pairs = [(1, 1), (1, 2), (1, 3), (2, 3), (2, 5), (3, 5), (3, 7), (4, 7), (5, 7), (3, 8), (5, 11), (7, 9), (6, 11), (7, 13)]
worst = 0
for h, k in pairs:
    M = max(200, 4000 // lcm(h, k))
    ref = richardson(h, k, M)
    vas = nb.gram_coprime(h, k, K)
    hD, kD = Decimal(h), Decimal(k)
    alt = (K.log2pi - K.gamma) / 2 * (1 / hD + 1 / kD) + ((kD - hD) / (2 * hD * kD) * (hD / kD).ln() if h != k else 0) \
          - K.pi / (2 * hD * kD) * (V_variant_h(h, k) + V_variant_h(k, h))
    err = abs(ref - vas)
    worst = max(worst, err)
    print(f"({h},{k})  direto={float(ref):.15f}  Vasyunin={float(vas):.15f}  |dif|={float(err):.1e}  "
          f"variante_inverso |dif|={float(abs(ref-alt)):.1e}")
print("pior diferença Vasyunin vs direto:", f"{float(worst):.1e}")
# escala gcd: <rho_{dh}, rho_{dk}> = <rho_h, rho_k>/d
r = richardson(2, 4, 1000)
print("escala gcd (2,4):", f"{float(abs(r - nb.gram_coprime(1, 2, K) / 2)):.1e}")
b1 = 1 - K.gamma
print("b_1 = 1-gamma =", float(b1))
