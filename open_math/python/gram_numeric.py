#!/usr/bin/env python3
"""
Experimental Nyman--Beurling Gram numerics.

This file is OUTSIDE the certified Lean proof path.

rho_n(x) = fract(1 / ((n+1)x))
chi = 1_(0,1)

For x in (0,1], let t = 1/x:
  b_i = integral_1^infty fract(t/a)/t^2 dt
  G_ij|(0,1] = integral_1^infty fract(t/a) fract(t/b)/t^2 dt
where a=i+1, b=j+1.

For x>1, rho_i(x)=1/(a x), hence
  G_ij|(1,infty) = 1/(ab).

The truncated transformed tails satisfy
  0 <= b_tail(T) <= 1/T
  0 <= G_tail(T) <= 1/T.

Because G_N becomes ill-conditioned, the entrywise tail bound does NOT
directly give a certified error bound for G_N^{-1}. Use the output only
for discovery.
"""

import argparse
import math
import mpmath as mp


def frac_piece_integral_single(a: int, T: int) -> mp.mpf:
    """Exact integral on [1,T] of fract(t/a)/t^2, piecewise."""
    pts = {mp.mpf(1), mp.mpf(T)}
    k = math.floor(1 / a) + 1
    while k * a < T:
        pts.add(mp.mpf(k * a))
        k += 1
    pts = sorted(pts)
    total = mp.mpf("0")
    for l, r in zip(pts[:-1], pts[1:]):
        mid = (l + r) / 2
        ka = mp.floor(mid / a)
        # fract(t/a)/t^2 = 1/(a t) - ka/t^2
        total += (mp.log(r / l) / a) - ka * (1 / l - 1 / r)
    return total


def frac_piece_integral_pair(a: int, b: int, T: int) -> mp.mpf:
    """Exact integral on [1,T] of fract(t/a)fract(t/b)/t^2."""
    pts = {mp.mpf(1), mp.mpf(T)}
    for d in (a, b):
        k = math.floor(1 / d) + 1
        while k * d < T:
            pts.add(mp.mpf(k * d))
            k += 1
    pts = sorted(pts)
    total = mp.mpf("0")
    for l, r in zip(pts[:-1], pts[1:]):
        mid = (l + r) / 2
        ka = mp.floor(mid / a)
        kb = mp.floor(mid / b)
        # ((t/a-ka)(t/b-kb))/t^2
        A = mp.mpf(1) / (a * b)
        B = -(ka / b + kb / a)
        C = ka * kb
        total += A * (r - l) + B * mp.log(r / l) + C * (1 / l - 1 / r)
    return total


def target_entry(i: int, T: int) -> mp.mpf:
    return frac_piece_integral_single(i + 1, T)


def gram_entry(i: int, j: int, T: int) -> mp.mpf:
    a, b = i + 1, j + 1
    near = frac_piece_integral_pair(a, b, T)
    tail_x_gt_one = mp.mpf(1) / (a * b)
    return near + tail_x_gt_one


def build_system(N: int, T: int):
    G = mp.matrix(N)
    b = mp.matrix(N, 1)
    for i in range(N):
        b[i] = target_entry(i, T)
        for j in range(i + 1):
            gij = gram_entry(i, j, T)
            G[i, j] = gij
            G[j, i] = gij
    return G, b


def report(N: int, T: int):
    G, b = build_system(N, T)
    eig = mp.eigsy(G, eigvals_only=True)
    lam_min = min(eig)
    lam_max = max(eig)
    cond = lam_max / lam_min
    c = mp.lu_solve(G, b)
    residual = mp.mpf(1) - (b.T * c)[0]
    K = residual * mp.log(N + 2)
    det = mp.det(G)
    return {
        "N": N,
        "T": T,
        "entry_tail_bound": mp.mpf(1) / T,
        "det": det,
        "lambda_min": lam_min,
        "lambda_max": lam_max,
        "condition": cond,
        "DN_truncated": residual,
        "K_truncated": K,
        "coeff": c,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--N", type=int, default=10)
    ap.add_argument("--T", type=int, default=10000)
    ap.add_argument("--dps", type=int, default=100)
    ap.add_argument("--coeff", action="store_true")
    args = ap.parse_args()
    mp.mp.dps = args.dps
    out = report(args.N, args.T)
    for k in (
        "N", "T", "entry_tail_bound", "det", "lambda_min",
        "lambda_max", "condition", "DN_truncated", "K_truncated"
    ):
        print(f"{k}={out[k]}")
    if args.coeff:
        for i, x in enumerate(out["coeff"]):
            print(f"c[{i}]={x}")
    print("STATUS=EXPERIMENTAL_NOT_CERTIFIED")


if __name__ == "__main__":
    main()
