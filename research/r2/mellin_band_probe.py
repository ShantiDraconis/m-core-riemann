#!/usr/bin/env python3
"""R2 Mellin-band diagnostic for one explicit Möbius taper.

Model:
  chi = 1_(0,1)
  rho_n(x) = frac(1/(n*x))
  c_{N,n} = -mu(n) * (log(N/n)/log N)^(3/16)

With P_N(s) = sum_{n<=N} mu(n) w_N(n) n^(-s),
Mellin-Plancherel gives

  ||chi-v_N||_2^2
    = (1/(2*pi)) int_R |1-zeta(1/2+it) P_N(1/2+it)|^2/(1/4+t^2) dt.

This program only decomposes a finite numerical approximation to that integral
into frequency bands. It is MODEL_EVIDENCE_ONLY. It does not prove a tail
bound, DNLimit=0, or RH.
"""
from __future__ import annotations

import argparse
import json
import math
from dataclasses import dataclass

import mpmath as mp

ALPHA_NUM = 3
ALPHA_DEN = 16

# Interval-certified fixed-scale Gram errors from the dyadic probe.
# Provenance: source 8514832357cedace6bf78733c42e6c1d258c6176,
# workflow 35285974111, job 105418254059.
REFERENCE_E2 = {
    32: mp.mpf("0.0337213635149486633999064102"),
    64: mp.mpf("0.0389805141942446961209735424"),
    128: mp.mpf("0.0241445144832290392658932855"),
    256: mp.mpf("0.0247209079237184593241720718"),
}

DEFAULT_BANDS = [
    (0, 1),
    (1, 3),
    (3, 10),
    (10, 20),
    (20, 50),
    (50, 100),
    (100, 200),
    (200, 500),
]


def mobius_int(n: int) -> int:
    m = n
    parity = 0
    p = 2
    while p * p <= m:
        if m % p == 0:
            e = 0
            while m % p == 0:
                m //= p
                e += 1
            if e > 1:
                return 0
            parity += 1
        p += 1
    if m > 1:
        parity += 1
    return 1 if parity % 2 == 0 else -1


@dataclass(frozen=True)
class MellinTerm:
    amplitude: mp.mpf
    logn: mp.mpf


def precompute_terms(N: int) -> list[MellinTerm]:
    logN = mp.log(N)
    alpha = mp.mpf(ALPHA_NUM) / ALPHA_DEN
    out: list[MellinTerm] = []
    for n in range(1, N + 1):
        mu = mobius_int(n)
        if mu == 0:
            continue
        u = 1 - mp.log(n) / logN
        if u <= 0:
            # n=N has zero weight for alpha>0.
            continue
        w = mp.power(u, alpha)
        amp = mp.mpf(mu) * w / mp.sqrt(n)
        out.append(MellinTerm(amp, mp.log(n)))
    return out


def P_on_critical_line(t: mp.mpf, terms: list[MellinTerm]) -> mp.mpc:
    total = mp.mpc(0)
    for term in terms:
        total += term.amplitude * mp.e ** (-1j * t * term.logn)
    return total


def doubled_integrand(t: mp.mpf, terms: list[MellinTerm]) -> mp.mpf:
    """Positive-t integrand after using conjugation symmetry.

    The full Mellin energy has factor 1/(2*pi) on R. For real coefficients the
    integrand is even, hence on t>=0 the factor becomes 1/pi.
    """
    s = mp.mpf("0.5") + 1j * t
    residual = 1 - mp.zeta(s) * P_on_critical_line(t, terms)
    return (abs(residual) ** 2) / (mp.mpf("0.25") + t * t) / mp.pi


def integrate_band(a: int, b: int, terms: list[MellinTerm]) -> mp.mpf:
    return mp.quad(lambda t: doubled_integrand(t, terms), [a, b])


def run_one(N: int, dps: int) -> dict:
    if N not in REFERENCE_E2:
        raise ValueError(f"N={N} has no pinned reference E2 in this diagnostic")
    mp.mp.dps = dps
    terms = precompute_terms(N)
    rows = []
    captured = mp.mpf(0)
    for a, b in DEFAULT_BANDS:
        val = integrate_band(a, b, terms)
        captured += val
        rows.append({
            "a": a,
            "b": b,
            "energy_mid": mp.nstr(val, 30),
        })

    ref = REFERENCE_E2[N]
    unresolved = ref - captured
    return {
        "classification": "MODEL_EVIDENCE_ONLY_NUMERICAL_MELLIN_BANDS",
        "N": N,
        "alpha_num": ALPHA_NUM,
        "alpha_den": ALPHA_DEN,
        "dps": dps,
        "positive_side_doubled": True,
        "bands": rows,
        "captured_0_500_mid": mp.nstr(captured, 30),
        "reference_fixed_scale_E2": mp.nstr(ref, 30),
        "captured_fraction_of_reference": mp.nstr(captured / ref, 20),
        "reference_minus_captured": mp.nstr(unresolved, 30),
        "remainder_interpretation": (
            "reference_minus_captured combines true |t|>500 energy and numerical "
            "quadrature error; it is not a certified tail bound"
        ),
        "reference_provenance": {
            "source_sha": "8514832357cedace6bf78733c42e6c1d258c6176",
            "workflow_run_id": 35285974111,
            "workflow_job_id": 105418254059,
        },
        "dnlimit_eq_zero_proved": False,
        "rh_proved": False,
    }


def parse_schedule(raw: str) -> list[int]:
    return [int(x.strip()) for x in raw.split(",") if x.strip()]


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--schedule", default="32,64,128,256")
    ap.add_argument("--dps", type=int, default=40)
    ap.add_argument("--jsonl", default="")
    args = ap.parse_args()

    records = [run_one(N, args.dps) for N in parse_schedule(args.schedule)]
    for rec in records:
        print(json.dumps(rec, sort_keys=True))

    if args.jsonl:
        with open(args.jsonl, "w", encoding="utf-8") as f:
            for rec in records:
                f.write(json.dumps(rec, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
