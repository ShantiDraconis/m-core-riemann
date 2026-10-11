"""
Nyman–Beurling / Báez-Duarte: cálculo do resíduo real D_N.

Espaço: H = L^2((0, inf), dt)
Alvo:   chi = indicadora de (0, 1]        (||chi||^2 = 1)
Base:   rho_k(t) = { 1/(k t) }  (parte fracionária), k = 1..N

D_N = inf_c || chi - sum_k c_k rho_k ||^2 = 1 - b^T G^{-1} b
Báez-Duarte (2003):  RH  <=>  D_N -> 0.

G_{jk} = <rho_j, rho_k>  via fórmula de Vasyunin (verificada em verify_vasyunin.py)
b_k    = <chi, rho_k> = (log k + 1 - gamma) / k

Tudo em aritmética decimal de precisão arbitrária (módulo decimal da biblioteca padrão).
"""
from decimal import Decimal, getcontext, localcontext
from fractions import Fraction
from math import gcd


def set_prec(p):
    getcontext().prec = p


def dec_pi():
    """pi por Chudnovsky (com 6 dígitos de guarda)."""
    p = getcontext().prec
    with localcontext() as ctx:
        ctx.prec = p + 10
        C = 426880 * Decimal(10005).sqrt()
        K, M, X, L = 6, Decimal(1), Decimal(1), Decimal(13591409)
        S = L
        for i in range(1, p // 14 + 3):
            M = M * (K**3 - 16 * K) / (i**3)
            K += 12
            L += 545140134
            X *= -262537412640768000
            S += M * L / X
        r = C / S
    return +r


def dec_gamma():
    """Constante de Euler–Mascheroni por Brent–McMillan: erro ~ pi*exp(-4n)."""
    p = getcontext().prec
    with localcontext() as ctx:
        ctx.prec = p + 15
        n = int(p * 2.302585093 / 4) + 10          # exp(-4n) < 10^-(p+...)
        nn = Decimal(n) ** 2
        A = Decimal(0)                              # sum (n^k/k!)^2 * (H_k - log n)
        B = Decimal(0)
        term = Decimal(1)                           # (n^k/k!)^2
        Hk = Decimal(0)
        logn = Decimal(n).ln()
        k = 0
        tiny = Decimal(10) ** (-(p + 12))
        while True:
            if k > 0:
                term = term * nn / (k * k)
                Hk += Decimal(1) / k
            A += term * (Hk - logn)
            B += term
            k += 1
            if k > 2 * n and term < tiny * B:
                break
        r = A / B
    return +r


def sin_cos(x):
    """sin e cos por série de Taylor, |x| <= pi."""
    p = getcontext().prec
    with localcontext() as ctx:
        ctx.prec = p + 10
        x2 = x * x
        s, c = Decimal(0), Decimal(0)
        ts, tc = x, Decimal(1)
        k = 0
        eps = Decimal(10) ** (-(p + 8))
        while True:
            s += ts
            c += tc
            ts = -ts * x2 / ((2 * k + 2) * (2 * k + 3))
            tc = -tc * x2 / ((2 * k + 1) * (2 * k + 2))
            k += 1
            if abs(ts) < eps and abs(tc) < eps:
                break
    return +s, +c


class Constants:
    def __init__(self):
        self.pi = dec_pi()
        self.gamma = dec_gamma()
        self.log2pi = (2 * self.pi).ln()
        self._cot = {}

    def cot_table(self, k):
        """cot(pi m / k), m = 0..k-1 (índice 0 não usado)."""
        t = self._cot.get(k)
        if t is None:
            t = [Decimal(0)] * k
            for m in range(1, k // 2 + 1):
                if 2 * m == k:
                    t[m] = Decimal(0)
                    continue
                s, c = sin_cos(self.pi * m / k)
                t[m] = c / s
                t[k - m] = -t[m]
            self._cot[k] = t
        return t


def V(h, k, K):
    """V(h,k) = sum_{m=1}^{k-1} { m h / k } cot(pi m / k).
    (A variante com o inverso de h mod k foi testada e REFUTADA por integração direta:
     erro de até 3e-2 em (3,7); esta forma concorda até ~1e-12. Ver verify_vasyunin.py.)"""
    if k == 1:
        return Decimal(0)
    cot = K.cot_table(k)
    s = Decimal(0)
    for m in range(1, k):
        r = (m * h) % k
        if r:
            s += r * cot[m]
    return s / k


def gram_coprime(h, k, K):
    """<rho_h, rho_k> para gcd(h,k)=1 (fórmula de Vasyunin)."""
    hD, kD = Decimal(h), Decimal(k)
    t1 = (K.log2pi - K.gamma) / 2 * (1 / hD + 1 / kD)
    t2 = (kD - hD) / (2 * hD * kD) * (hD / kD).ln() if h != k else Decimal(0)
    t3 = K.pi / (2 * hD * kD) * (V(h, k, K) + V(k, h, K))
    return t1 + t2 - t3


def gram_entry(j, k, K, cache):
    d = gcd(j, k)
    h, l = j // d, k // d
    key = (min(h, l), max(h, l))
    v = cache.get(key)
    if v is None:
        v = gram_coprime(key[0], key[1], K)
        cache[key] = v
    return v / d


def b_entry(k, K):
    return (Decimal(k).ln() + 1 - K.gamma) / k


def residuals(Nmax, K, progress=None):
    """
    D_N para N = 1..Nmax por Cholesky incremental (equivale à recorrência de Schur):
        G_N = L L^T,  y = L^{-1} b,  D_N = 1 - ||y||^2,
        D_{N-1} - D_N = y_N^2 >= 0.
    Retorna lista de (N, D_N, pivô_N) — pivô_N^2 = complemento de Schur s_N.
    """
    cache = {}
    L = []          # linhas da Cholesky
    y = []
    out = []
    acc = Decimal(0)
    for n in range(1, Nmax + 1):
        g = [gram_entry(n, j, K, cache) for j in range(1, n + 1)]
        row = []
        for j in range(n - 1):
            s = g[j]
            Lj = L[j]
            for i in range(j):
                s -= row[i] * Lj[i]
            row.append(s / Lj[j])
        d = g[n - 1]
        for i in range(n - 1):
            d -= row[i] * row[i]
        if d <= 0:
            raise ArithmeticError(f"G_{n} perdeu positividade numérica (pivô^2={d}); aumente a precisão")
        piv = d.sqrt()
        row.append(piv)
        L.append(row)
        s = b_entry(n, K)
        for i in range(n - 1):
            s -= row[i] * y[i]
        yn = s / piv
        y.append(yn)
        acc += yn * yn
        out.append((n, 1 - acc, piv))
        if progress and n % progress == 0:
            print(f"  N={n}  D_N={float(1 - acc):.12f}", flush=True)
    return out
