#!/usr/bin/env python3
"""
Experimental finite Vasyunin Gram numerics.

OUTSIDE the certified Lean proof path.

Uses the exact finite cotangent formula encoded in
MCore.RH.R0.VasyuninFiniteGram, then computes

  c_N = G_N^{-1} b_N
  DN(N) = 1 - b_N^T c_N
  K(N) = DN(N) * log(N+2)

with arbitrary precision arithmetic.

This is discovery only. It does not certify H1.
"""

import argparse
import math
import mpmath as mp


def frac(x):
    return x - mp.floor(x)


def vasyunin_sum(h: int, k: int):
    if k <= 1:
        return mp.mpf("0")
    return mp.fsum(
        frac(mp.mpf(m * h) / k) * mp.cot(mp.pi * m / k)
        for m in range(1, k)
    )


def vasyunin_gram_entry(p: int, q: int):
    d = math.gcd(p, q)
    h = p // d
    k = q // d
    P = mp.mpf(p)
    Q = mp.mpf(q)
    return (
        ((mp.log(2 * mp.pi) - mp.euler) / 2) * (1 / P + 1 / Q)
        + ((P - Q) / (2 * P * Q)) * mp.log(Q / P)
        - (mp.pi * d / (2 * P * Q))
        * (vasyunin_sum(k, h) + vasyunin_sum(h, k))
    )


def target_entry(n: int):
    x = mp.mpf(n)
    return (mp.log(x) + 1 - mp.euler) / x


def gram_matrix(N: int):
    G = mp.matrix(N)
    for i in range(N):
        for j in range(i + 1):
            x = vasyunin_gram_entry(i + 1, j + 1)
            G[i, j] = x
            G[j, i] = x
    return G


def report(N: int):
    G = gram_matrix(N)
    b = mp.matrix([target_entry(i + 1) for i in range(N)])
    c = mp.lu_solve(G, b)
    dn = 1 - (b.T * c)[0]
    eig = mp.eigsy(G, eigvals_only=True)
    lmin = min(eig)
    lmax = max(eig)
    return {
        "N": N,
        "DN": dn,
        "K": dn * mp.log(N + 2),
        "det": mp.det(G),
        "lambda_min": lmin,
        "lambda_max": lmax,
        "condition": lmax / lmin,
        "coeff": c,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--N", type=int, default=50)
    ap.add_argument("--dps", type=int, default=100)
    ap.add_argument("--coeff", action="store_true")
    args = ap.parse_args()

    mp.mp.dps = args.dps
    out = report(args.N)
    for k in ("N", "DN", "K", "det", "lambda_min", "lambda_max", "condition"):
        print(f"{k}={out[k]}")
    if args.coeff:
        for i, x in enumerate(out["coeff"]):
            print(f"c[{i}]={x}")
    print("REFERENCE_CONSTANT=", 2 + mp.euler - mp.log(4 * mp.pi))
    print("STATUS=EXPERIMENTAL_NOT_CERTIFIED")


if __name__ == "__main__":
    main()
