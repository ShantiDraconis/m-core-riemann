#!/usr/bin/env python3
"""
R2 Mode B: Mellin-side weighted QR solver and BCF/Selberg mollifier test.

This solver NEVER inverts the finite Gram matrix to obtain coefficients.

For v_N = sum_{n<=N} c_n rho_n and
  M[rho_n](s) = - zeta(s) n^(-s) / s,
the Mellin residual is
  M[chi-v_N](s) = (1 + zeta(s) P_c(s)) / s,
  P_c(s) = sum c_n n^(-s).

Mode B approximates the weighted critical-line least-squares problem on
|t| <= T using Gauss-Legendre quadrature after
  t = (1/2) tan(theta),
which exactly removes the factor dt/(1/4+t^2).

The sampled QR coefficients are then evaluated in the exact finite Gram
quadratic form using Arb:
  E_N^2 = 1 - 2 b^T c + c^T G c.
This is an independent solver check: G is used only to evaluate the candidate,
not to solve for c.

Finite quadrature and finite-N Arb evaluation do NOT prove DNLimit=0 or RH.
"""
from __future__ import annotations

import argparse
import json
import math
import pathlib
import sys

import mpmath as mp
import numpy as np
import scipy.linalg

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from gram_engine import b_arb, gram_arb, mobius_int


def parse_schedule(raw: str) -> list[int]:
    out = [int(x.strip()) for x in raw.split(",") if x.strip()]
    if not out or any(n < 2 for n in out):
        raise ValueError("schedule must contain integers N >= 2")
    return out


def positive_theta_rule(N: int, samples_factor: int, T: float):
    m = max(samples_factor * N, 64)
    x, w = np.polynomial.legendre.leggauss(m)
    theta_max = math.atan(2.0 * T)
    theta = 0.5 * theta_max * (x + 1.0)
    wt_theta = 0.5 * theta_max * w
    t = 0.5 * np.tan(theta)
    weights = (2.0 / math.pi) * wt_theta
    return t, weights


def critical_design(N: int, t: np.ndarray, weights: np.ndarray, zeta_dps: int):
    mp.mp.dps = zeta_dps
    logs = np.log(np.arange(1, N + 1, dtype=np.float64))
    A = np.empty((len(t), N), dtype=np.complex128)

    for k, tk in enumerate(t):
        s_mp = mp.mpf("0.5") + 1j * mp.mpf(repr(float(tk)))
        z = complex(mp.zeta(s_mp))
        phase = np.exp((-0.5 - 1j * tk) * logs)
        A[k, :] = z * phase

    root_w = np.sqrt(weights)
    Aw = A * root_w[:, None]
    target = -root_w

    M = np.vstack([Aw.real, Aw.imag])
    y = np.concatenate([target, np.zeros_like(target)])
    return M, y, A


def qr_solve_real(M: np.ndarray, y: np.ndarray):
    c, _, rank, _ = scipy.linalg.lstsq(
        M, y, cond=None, lapack_driver="gelsy", check_finite=True
    )
    residual = M @ c - y
    sampled_e2 = float(np.dot(residual, residual))
    svals = scipy.linalg.svdvals(M)
    cond = float(svals[0] / svals[-1]) if svals[-1] > 0 else math.inf
    return c, sampled_e2, int(rank), cond


def bcf_linear_coefficients(N: int) -> np.ndarray:
    logN = math.log(N)
    vals = np.zeros(N, dtype=np.float64)
    for n in range(1, N + 1):
        mu = mobius_int(n)
        if mu:
            vals[n - 1] = -mu * (1.0 - math.log(n) / logN)
    return vals


def sampled_energy(A: np.ndarray, weights: np.ndarray, c: np.ndarray) -> float:
    residual = 1.0 + A @ c
    return float(np.sum(weights * np.abs(residual) ** 2))


def arb_candidate_error(N: int, coeff: np.ndarray, dps: int):
    from flint import arb, arb_mat, ctx

    ctx.dps = dps
    entries = [arb(0) for _ in range(N * N)]
    bvals = []
    for i in range(N):
        a = i + 1
        bvals.append(b_arb(a, dps))
        for j in range(i + 1):
            g = gram_arb(a, j + 1, dps)
            entries[i * N + j] = g
            entries[j * N + i] = g

    G = arb_mat(N, N, entries)
    B = arb_mat(N, 1, bvals)
    C = arb_mat(N, 1, [arb(format(float(x), ".17g")) for x in coeff])
    e2 = arb(1) - 2 * (B.transpose() * C)[0, 0] + (C.transpose() * G * C)[0, 0]
    return {
        "ball": e2.str(50, more=True),
        "lower": e2.lower().str(50, radius=False),
        "upper": e2.upper().str(50, radius=False),
    }


MODE_A_DN = {
    8: "0.02416142158589668502280894301085134",
    16: "0.01789402347696943509905506314795876",
    32: "0.01405194369952985983642504072212329",
    64: "0.01137604029967365814705897002932677",
    128: "0.009658549278111909910035392571452577",
    256: "0.008233716277261021441598038102635435",
}


def run_one(N: int, samples_factor: int, zeta_dps: int, arb_dps: int):
    T = float(N * N)
    t, weights = positive_theta_rule(N, samples_factor, T)
    M, y, A = critical_design(N, t, weights, zeta_dps)

    c_qr, sampled_qr_e2, rank, design_cond = qr_solve_real(M, y)
    qr_arb = arb_candidate_error(N, c_qr, arb_dps)

    c_bcf = bcf_linear_coefficients(N)
    sampled_bcf_e2 = sampled_energy(A, weights, c_bcf)
    bcf_arb = arb_candidate_error(N, c_bcf, arb_dps)

    ref = float(MODE_A_DN[N])
    qr_mid = 0.5 * (float(qr_arb["lower"]) + float(qr_arb["upper"]))
    bcf_mid = 0.5 * (float(bcf_arb["lower"]) + float(bcf_arb["upper"]))

    return {
        "classification": "MODE_B_FINITE_N_RESEARCH_WITH_ARB_CANDIDATE_EVALUATION",
        "N": N,
        "T": T,
        "samples_positive": len(t),
        "samples_factor": samples_factor,
        "zeta_dps": zeta_dps,
        "arb_dps": arb_dps,
        "solver": "scipy.linalg.lstsq LAPACK GELSY pivoted QR; real coefficients",
        "uses_gram_inverse_for_coefficients": False,
        "design_rank": rank,
        "design_condition_number": design_cond,
        "mode_b_qr": {
            "sampled_truncated_E2": sampled_qr_e2,
            "arb_full_finite_gram_E2": qr_arb,
            "mode_A_optimal_DN_reference": MODE_A_DN[N],
            "arb_E2_minus_mode_A_mid": qr_mid - ref,
            "coeff_l2": float(np.linalg.norm(c_qr)),
            "coeff_l1": float(np.linalg.norm(c_qr, ord=1)),
            "max_abs_coeff": float(np.max(np.abs(c_qr))),
        },
        "bcf_linear_mollifier": {
            "family": "-mu(n)*(1-log(n)/log(N))",
            "sampled_truncated_E2": sampled_bcf_e2,
            "arb_full_finite_gram_E2": bcf_arb,
            "E2_logN_mid": bcf_mid * math.log(N),
            "coeff_l2": float(np.linalg.norm(c_bcf)),
            "coeff_l1": float(np.linalg.norm(c_bcf, ord=1)),
        },
        "quadrature_scope": {
            "critical_line_window": f"|t| <= {int(T)}",
            "tail_certified": False,
            "statement": (
                "QR sampling chooses coefficients without Gram inversion. "
                "Arb Gram evaluation certifies only the exact finite L2 error "
                "of the resulting decimal coefficient vector. The sampled "
                "Mellin tail beyond T is not used as a proof."
            ),
        },
        "dnlimit_eq_zero_proved": False,
        "rh_proved": False,
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--schedule", default="8,16,32,64,128,256")
    ap.add_argument("--samples-factor", type=int, default=4)
    ap.add_argument("--zeta-dps", type=int, default=50)
    ap.add_argument("--arb-dps", type=int, default=100)
    ap.add_argument("--jsonl", default="")
    args = ap.parse_args()

    rows = []
    for N in parse_schedule(args.schedule):
        row = run_one(N, args.samples_factor, args.zeta_dps, args.arb_dps)
        rows.append(row)
        print(json.dumps(row, sort_keys=True))

    if args.jsonl:
        with open(args.jsonl, "w", encoding="utf-8") as f:
            for row in rows:
                f.write(json.dumps(row, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
