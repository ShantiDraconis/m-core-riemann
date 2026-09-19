#!/usr/bin/env python3
"""Numerical diagnostic for the BCF zero-residue term.

MODEL_EVIDENCE_ONLY: mpmath.zetazero supplies critical-line zeros.  Therefore
this program measures cancellation among known critical zeros; it cannot rule
out off-critical zeros, prove a tail bound, DNLimit=0, or RH.
"""
from __future__ import annotations

import argparse
import json
import math
from typing import Iterable

import mpmath as mp


def critical_zeros(count: int) -> list[mp.mpc]:
    return [mp.mpc(mp.mpf("0.5"), mp.im(mp.zetazero(k))) for k in range(1, count + 1)]


def residue(N: int, rho: mp.mpc, s: mp.mpc) -> mp.mpc:
    zp = mp.diff(mp.zeta, rho)
    return mp.power(N, rho - s) / (zp * mp.power(rho - s, 2))


def symmetric_terms(N: int, s: mp.mpc, positive_zeros: Iterable[mp.mpc]) -> list[mp.mpc]:
    out: list[mp.mpc] = []
    for rho in positive_zeros:
        out.append(residue(N, rho, s))
        out.append(residue(N, mp.conj(rho), s))
    return out


def log_derivative(s: mp.mpc) -> mp.mpc:
    return mp.diff(mp.zeta, s) / mp.zeta(s)


def encode(z: mp.mpc) -> dict[str, str]:
    return {"re": mp.nstr(mp.re(z), 24), "im": mp.nstr(mp.im(z), 24)}


def evaluate(N: int, t: mp.mpf, zeros: list[mp.mpc], pole_guard: mp.mpf) -> dict:
    nearest = min(abs(t - mp.im(rho)) for rho in zeros)
    if nearest < pole_guard:
        return {"N": N, "t": mp.nstr(t, 16), "skipped": True,
                "reason": "sample too close to a supplied critical zero"}
    s = mp.mpc(mp.mpf("0.5"), t)
    terms = symmetric_terms(N, s, zeros)
    raw_l1 = mp.fsum(abs(z) for z in terms)
    pair_sums = [terms[2*k] + terms[2*k+1] for k in range(len(zeros))]
    paired_l1 = mp.fsum(abs(z) for z in pair_sums)
    total = mp.fsum(pair_sums)
    zeta_s = mp.zeta(s)
    combined = log_derivative(s) - zeta_s * total
    return {
        "N": N,
        "t": mp.nstr(t, 16),
        "skipped": False,
        "zero_count_positive": len(zeros),
        "raw_term_l1": mp.nstr(raw_l1, 24),
        "conjugate_pair_l1": mp.nstr(paired_l1, 24),
        "pairing_ratio": mp.nstr(paired_l1 / raw_l1 if raw_l1 else 0, 16),
        "residue_sum": encode(total),
        "combined_without_F": encode(combined),
        "combined_without_F_abs": mp.nstr(abs(combined), 24),
        "nearest_zero_distance": mp.nstr(nearest, 16),
    }


def parse_ints(raw: str) -> list[int]:
    return [int(x.strip()) for x in raw.split(",") if x.strip()]


def parse_reals(raw: str) -> list[mp.mpf]:
    return [mp.mpf(x.strip()) for x in raw.split(",") if x.strip()]


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--schedule", default="32,64,128,256")
    ap.add_argument("--t-grid", default="0,5,10,12,16,20,25,30,40,50")
    ap.add_argument("--zeros", type=int, default=20)
    ap.add_argument("--dps", type=int, default=50)
    ap.add_argument("--pole-guard", default="0.1")
    ap.add_argument("--jsonl", default="")
    args = ap.parse_args()
    mp.mp.dps = args.dps
    zeros = critical_zeros(args.zeros)
    records = [evaluate(N, t, zeros, mp.mpf(args.pole_guard))
               for N in parse_ints(args.schedule) for t in parse_reals(args.t_grid)]
    header = {
        "classification": "MODEL_EVIDENCE_ONLY_CRITICAL_ZERO_TRUNCATION",
        "zero_source": "mpmath.zetazero; supplied zeros have Re(rho)=1/2",
        "critical_limitation": "cannot detect or exclude off-critical zeros",
        "residue_tail_certified": False,
        "dnlimit_eq_zero_proved": False,
        "rh_proved": False,
        "dps": args.dps,
        "positive_zero_count": args.zeros,
    }
    rows = [{"metadata": header}] + records
    for row in rows:
        print(json.dumps(row, sort_keys=True))
    if args.jsonl:
        with open(args.jsonl, "w", encoding="utf-8") as fh:
            for row in rows:
                fh.write(json.dumps(row, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
