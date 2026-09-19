#!/usr/bin/env python3
"""Dyadic-height diagnostic for the truncated BCF zero-residue sum.

Only critical-line zeros returned by mpmath are used.  All output is finite
numerical model evidence; it is not a zero-tail estimate and cannot imply RH.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

import mpmath as mp

from zero_residue_probe import critical_zeros, encode, residue


def dyadic_ranges(count: int) -> list[tuple[int, int]]:
    out = []
    lo = 0
    width = 1
    while lo < count:
        hi = min(count, lo + width)
        out.append((lo, hi))
        lo = hi
        width *= 2
    return out


def block_record(N: int, s: mp.mpc, zeros: list[mp.mpc], lo: int, hi: int) -> dict:
    terms: list[mp.mpc] = []
    for rho in zeros[lo:hi]:
        terms.extend((residue(N, rho, s), residue(N, mp.conj(rho), s)))
    total = mp.fsum(terms)
    raw_l1 = mp.fsum(abs(z) for z in terms)
    return {
        "positive_zero_index_start": lo + 1,
        "positive_zero_index_end": hi,
        "positive_zero_count": hi - lo,
        "gamma_min": mp.nstr(mp.im(zeros[lo]), 18),
        "gamma_max": mp.nstr(mp.im(zeros[hi - 1]), 18),
        "block_sum": encode(total),
        "block_abs": mp.nstr(abs(total), 24),
        "raw_term_l1": mp.nstr(raw_l1, 24),
        "block_cancellation_ratio": mp.nstr(abs(total) / raw_l1 if raw_l1 else 0, 16),
        "block_abs_per_positive_zero": mp.nstr(abs(total) / (hi - lo), 24),
    }


def evaluate(N: int, t: mp.mpf, zeros: list[mp.mpc], pole_guard: mp.mpf) -> dict:
    nearest = min(abs(t - mp.im(rho)) for rho in zeros)
    if nearest < pole_guard:
        return {"N": N, "t": mp.nstr(t, 16), "skipped": True,
                "reason": "sample too close to a supplied critical zero"}
    s = mp.mpc(mp.mpf("0.5"), t)
    blocks = [block_record(N, s, zeros, lo, hi) for lo, hi in dyadic_ranges(len(zeros))]
    cumulative = mp.mpc(0)
    cumulative_rows = []
    for block in blocks:
        z = mp.mpc(mp.mpf(block["block_sum"]["re"]), mp.mpf(block["block_sum"]["im"]))
        cumulative += z
        cumulative_rows.append({
            "through_positive_zero": block["positive_zero_index_end"],
            "cumulative_sum": encode(cumulative),
            "cumulative_abs": mp.nstr(abs(cumulative), 24),
        })
    block_l1 = mp.fsum(mp.mpf(b["block_abs"]) for b in blocks)
    full_abs = abs(cumulative)
    return {
        "N": N,
        "t": mp.nstr(t, 16),
        "skipped": False,
        "blocks": blocks,
        "cumulative": cumulative_rows,
        "cross_block_cancellation_ratio": mp.nstr(full_abs / block_l1 if block_l1 else 0, 16),
        "full_truncated_sum_abs": mp.nstr(full_abs, 24),
    }


def comma_ints(raw: str) -> list[int]:
    return [int(x.strip()) for x in raw.split(",") if x.strip()]


def comma_reals(raw: str) -> list[mp.mpf]:
    return [mp.mpf(x.strip()) for x in raw.split(",") if x.strip()]


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--schedule", default="64,128,256")
    ap.add_argument("--t-grid", default="0,10,20,30,50")
    ap.add_argument("--zeros", type=int, default=32)
    ap.add_argument("--dps", type=int, default=50)
    ap.add_argument("--pole-guard", default="0.1")
    ap.add_argument("--jsonl", default="")
    args = ap.parse_args()
    mp.mp.dps = args.dps
    zeros = critical_zeros(args.zeros)
    metadata = {
        "classification": "MODEL_EVIDENCE_ONLY_DYADIC_CRITICAL_ZERO_TRUNCATION",
        "grouping": "dyadic blocks by positive-zero index, with conjugates retained in each block",
        "critical_limitation": "input contains only mpmath critical-line zeros",
        "off_critical_zeros_excluded": False,
        "uniform_zero_tail_bound_proved": False,
        "dnlimit_eq_zero_proved": False,
        "rh_proved": False,
        "positive_zero_count": args.zeros,
        "dps": args.dps,
    }
    rows = [{"metadata": metadata}]
    rows += [evaluate(N, t, zeros, mp.mpf(args.pole_guard))
             for N in comma_ints(args.schedule) for t in comma_reals(args.t_grid)]
    for row in rows:
        print(json.dumps(row, sort_keys=True))
    if args.jsonl:
        path = Path(args.jsonl)
        path.write_text("".join(json.dumps(x, sort_keys=True) + "\n" for x in rows), encoding="utf-8")


if __name__ == "__main__":
    main()
