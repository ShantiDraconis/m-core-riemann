#!/usr/bin/env python3
"""
Exact rational Gram-witness generator for the RH/Nyman--Beurling finite endpoint.

Input JSON:
{
  "gram": [["1", "1/2"], ["1/2", "1"]],
  "target": ["3/4", "2/3"],
  "chi_norm_sq": "1",
  "epsilon": "1/10"
}

All arithmetic is exact via fractions.Fraction.

The script solves the exact normal equations
    sum_i c_i * G[i][j] = b[j]
and verifies the reduced energy
    ||chi||^2 - sum_i c_i*b[i] < epsilon^2.

This is a candidate generator/verifier for the finite-dimensional obligation
already formalized in MCore.RH.NB.GramEndpoint.lean.  It does not replace the
Lean proof that the supplied rational Gram/target values equal the concrete
analytic inner products.
"""

from __future__ import annotations
from fractions import Fraction
import json
import sys
from typing import List


def F(x) -> Fraction:
    if isinstance(x, int):
        return Fraction(x)
    if isinstance(x, str):
        return Fraction(x)
    raise TypeError(f"unsupported rational literal: {x!r}")


def solve_linear(A: List[List[Fraction]], b: List[Fraction]) -> List[Fraction]:
    n = len(A)
    if n == 0 or any(len(row) != n for row in A) or len(b) != n:
        raise ValueError("expected a nonempty square matrix and matching target")
    aug = [row[:] + [b[i]] for i, row in enumerate(A)]
    pivot_row = 0
    pivot_cols = []
    for col in range(n):
        pivot = next((r for r in range(pivot_row, n) if aug[r][col] != 0), None)
        if pivot is None:
            continue
        aug[pivot_row], aug[pivot] = aug[pivot], aug[pivot_row]
        p = aug[pivot_row][col]
        aug[pivot_row] = [x / p for x in aug[pivot_row]]
        for r in range(n):
            if r != pivot_row and aug[r][col] != 0:
                q = aug[r][col]
                aug[r] = [aug[r][k] - q * aug[pivot_row][k] for k in range(n + 1)]
        pivot_cols.append(col)
        pivot_row += 1
        if pivot_row == n:
            break
    for r in range(pivot_row, n):
        if all(aug[r][c] == 0 for c in range(n)) and aug[r][n] != 0:
            raise ValueError("normal equations are inconsistent")
    if len(pivot_cols) < n:
        raise ValueError("singular system: supply a nonsingular finite Gram block")
    x = [Fraction(0) for _ in range(n)]
    for r, col in enumerate(pivot_cols):
        x[col] = aug[r][n]
    return x


def qstr(x: Fraction) -> str:
    return str(x.numerator) if x.denominator == 1 else f"{x.numerator}/{x.denominator}"


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: rh_gram_witness.py INPUT.json", file=sys.stderr)
        return 2
    with open(sys.argv[1], "r", encoding="utf-8") as fh:
        raw = json.load(fh)
    G = [[F(x) for x in row] for row in raw["gram"]]
    b = [F(x) for x in raw["target"]]
    chi2 = F(raw["chi_norm_sq"])
    eps = F(raw["epsilon"])
    if eps <= 0:
        raise ValueError("epsilon must be positive")

    # Lean's equation is sum_i c_i * G[i][j] = b[j], i.e. G^T c = b.
    GT = [[G[i][j] for i in range(len(G))] for j in range(len(G))]
    c = solve_linear(GT, b)

    normal_residuals = [
        sum((c[i] * G[i][j] for i in range(len(c))), Fraction(0)) - b[j]
        for j in range(len(c))
    ]
    reduced_energy = chi2 - sum((c[i] * b[i] for i in range(len(c))), Fraction(0))
    eps2 = eps * eps

    out = {
        "N": len(c),
        "coefficients": [qstr(x) for x in c],
        "normal_equation_residuals": [qstr(x) for x in normal_residuals],
        "normal_equations_exact": all(x == 0 for x in normal_residuals),
        "reduced_energy": qstr(reduced_energy),
        "epsilon_squared": qstr(eps2),
        "energy_strictly_below_epsilon_squared": reduced_energy < eps2,
        "finite_gram_witness_valid":
            all(x == 0 for x in normal_residuals) and reduced_energy < eps2,
    }
    print(json.dumps(out, indent=2, sort_keys=True))
    return 0 if out["finite_gram_witness_valid"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
