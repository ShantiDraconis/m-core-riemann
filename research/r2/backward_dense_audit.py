#!/usr/bin/env python3
"""Backward-dense fail-closed audit for the Riemann-only research branch.

This is an integrity/audit tool, not a mathematical proof. It checks the entire
project Riemann namespace plus the dense R2 evidence surface and preserves the
single material frontier:
  ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL.
"""
from __future__ import annotations

import json
import pathlib
import py_compile
import re
import sys

ROOT = pathlib.Path(".")
MATHLIB_SHA = "c44e0c8ee63ca166450922a373c7409c5d26b00b"
TOOLCHAIN = "leanprover/lean4:v4.19.0"
MATERIAL_GATE = "ZERO_RESIDUE_SUM_UNCONDITIONAL_CONTROL"

FORBIDDEN_LEAN_TOKENS = re.compile(
    r"(^|[^A-Za-z0-9_])(sorry|admit|sorryAx|native_decide|cheat|bypass)([^A-Za-z0-9_]|$)"
)
FORBIDDEN_DECL = re.compile(r"^\s*(axiom|constant|constants)\s+", re.MULTILINE)

EXPECTED = [
    "R0_CERT.json",
    "audit/R1_BAEZ_DUARTE_INTERFACE.json",
    "audit/R2_BCF_UNCONDITIONAL_DECOMPOSITION.md",
    "audit/R2_COEFFICIENT_STRUCTURE.md",
    "audit/R2_CONSOLIDATED_ANALYTIC_LEDGER.md",
    "audit/R2_FALSE_RH_BACKWARD_DENSE.md",
    "audit/R2_FORMALIZATION_CORRECTIONS.md",
    "audit/R2_GRAM_FINITE_CERT.json",
    "audit/R2_MOBIUS_DYADIC_PROBE.md",
    "audit/R2_NATURAL_MOBIUS_PRUNE.md",
    "audit/R2_RECENT_LITERATURE_SWEEP.md",
    "audit/R2_ROUTE_MATRIX.json",
    "audit/R2_ZERO_RESIDUE_OBSTRUCTION.md",
    "audit/BACKWARD_DENSE_MATCHES.json",
    "audit/BACKWARD_DENSE_AXIOM_AUDIT.txt",
    "certificates/PROOF_CLOSURE_TRIPLE_CERT.json",
    "research/r2/DNLimitZeroAttack.md",
    "research/r2/GramAnalytic.md",
    "research/r2/gram_engine.py",
    "research/r2/mellin_band_probe.py",
    "research/r2/mode_b_mellin_qr.py",
    "research/r2/probe_arb.py",
    "research/r2/requirements-r2.txt",
    "research/r2/validate_vasyunin.py",
    "papers/final-dense/main.tex",
    "lakefile.toml",
    "lake-manifest.json",
    "lean-toolchain",
]


def fail(msg: str) -> None:
    raise AssertionError(msg)


def require_files() -> None:
    missing = [p for p in EXPECTED if not (ROOT / p).is_file()]
    if missing:
        fail(f"missing required Riemann audit files: {missing}")


def audit_dependency_pin() -> None:
    toolchain = (ROOT / "lean-toolchain").read_text(encoding="utf-8").strip()
    if toolchain != TOOLCHAIN:
        fail(f"unexpected Lean toolchain: {toolchain}")

    lake = (ROOT / "lakefile.toml").read_text(encoding="utf-8")
    if f'rev = "{MATHLIB_SHA}"' not in lake:
        fail("lakefile.toml is not pinned to the certified Mathlib SHA")

    manifest = json.load(open(ROOT / "lake-manifest.json", encoding="utf-8"))
    pkgs = [p for p in manifest["packages"] if p["name"] == "mathlib"]
    if len(pkgs) != 1:
        fail(f"expected exactly one mathlib package, got {len(pkgs)}")
    pkg = pkgs[0]
    if pkg["rev"] != MATHLIB_SHA or pkg["inputRev"] != MATHLIB_SHA:
        fail(f"manifest Mathlib pin mismatch: {pkg}")


def audit_all_riemann_lean() -> None:
    lean_files = sorted((ROOT / "lean/MCore/RH").rglob("*.lean"))
    if not lean_files:
        fail("no Riemann Lean sources found")
    bad_tokens = []
    bad_decls = []
    for path in lean_files:
        text = path.read_text(encoding="utf-8")
        for i, line in enumerate(text.splitlines(), 1):
            if FORBIDDEN_LEAN_TOKENS.search(line):
                bad_tokens.append((str(path), i, line.strip()))
        for m in FORBIDDEN_DECL.finditer(text):
            line = text.count("\n", 0, m.start()) + 1
            bad_decls.append((str(path), line, m.group(0).strip()))
    if bad_tokens:
        fail(f"forbidden placeholder/bypass tokens in Riemann Lean: {bad_tokens[:20]}")
    if bad_decls:
        fail(f"project axiom/constant declarations in Riemann Lean: {bad_decls[:20]}")
    print(f"RIEMANN_LEAN_FILES_AUDITED={len(lean_files)}")


def text_surface() -> list[pathlib.Path]:
    files: set[pathlib.Path] = set()
    files.update(p for p in (ROOT / "audit").glob("R2_*") if p.is_file())
    files.update([
        ROOT / "audit/BACKWARD_DENSE_MATCHES.json",
        ROOT / "audit/BACKWARD_DENSE_AXIOM_AUDIT.txt",
    ])
    files.update(p for p in (ROOT / "research/r2").rglob("*") if p.is_file())
    files.update(
        p for p in (ROOT / "papers/final-dense").rglob("*")
        if p.is_file() and p.suffix.lower() != ".pdf"
    )
    files.update((ROOT / ".github/workflows").glob("r2-*.yml"))
    files.add(ROOT / ".github/workflows/final-dense-riemann.yml")
    return sorted(files)


def audit_text_hygiene() -> None:
    bad = {}
    for path in text_surface():
        data = path.read_bytes()
        # R2 audit sources are canonical UTF-8/LF text. Reject every other C0.
        hits = [(i, b) for i, b in enumerate(data) if b < 32 and b != 10]
        if hits:
            bad[str(path)] = hits[:20]
        try:
            data.decode("utf-8")
        except UnicodeDecodeError as exc:
            fail(f"non-UTF8 audit text {path}: {exc}")
    if bad:
        fail(f"invisible/control bytes in dense evidence: {bad}")


def audit_json() -> None:
    json_files = sorted((ROOT / "audit").glob("R2_*.json")) + [
        ROOT / "audit/BACKWARD_DENSE_MATCHES.json",
        ROOT / "R0_CERT.json",
        ROOT / "audit/R1_BAEZ_DUARTE_INTERFACE.json",
        ROOT / "certificates/PROOF_CLOSURE_TRIPLE_CERT.json",
    ]
    for path in json_files:
        json.load(open(path, encoding="utf-8"))
    print(f"JSON_FILES_PARSED={len(json_files)}")


def audit_python() -> None:
    files = sorted((ROOT / "research/r2").glob("*.py"))
    if not files:
        fail("no R2 Python research scripts found")
    for path in files:
        py_compile.compile(str(path), doraise=True)
    print(f"R2_PYTHON_FILES_COMPILED={len(files)}")


def audit_semantics() -> None:
    r2 = json.load(open(ROOT / "audit/R2_ROUTE_MATRIX.json", encoding="utf-8"))
    assert r2["status"] == "OPEN_BRIDGE"
    assert r2["dnlimit_eq_zero_proved"] is False
    assert r2["rh_proved"] is False
    assert r2["new_lean_theorem"] is False
    assert r2["project_axiom_added"] is False

    assert r2["normalization"]["ambient"] == "L2((0,infinity), dx)"
    assert r2["normalization"]["rho_a"] == "fract(1/(a*x))"
    assert r2["normalization"]["frozen_semantics"] == "dN = residual norm; DN = dN^2"

    fm = r2["frontier_minimization"]
    assert fm["policy"] == "ONE_MATERIAL_OPEN_GATE"
    assert fm["material_gate"] == MATERIAL_GATE

    nxt = r2["next_mathematical_task"]
    assert nxt["id"] == MATERIAL_GATE
    assert nxt["status"] == "OPEN_MATH"

    fa = r2["formalization_audit"]
    assert fa["gap_reclassification"]["F_DN_CONVERGENCE"] == "PROVED_LEAN_FROZEN_NB14"
    assert fa["gap_reclassification"]["B_UNIFORM_VANISHING"] == "OPEN_MATH_SINGLE_MATERIAL_GATE"
    assert fa["material_gate_count"] == 1
    assert fa["material_gate"] == MATERIAL_GATE

    matches = json.load(open(ROOT / "audit/BACKWARD_DENSE_MATCHES.json", encoding="utf-8"))
    assert matches["chain"]["material_gate_count"] == 1
    assert matches["chain"]["material_gate"] == MATERIAL_GATE
    assert matches["current_claims"] == {
        "dnlimit_eq_zero_proved": False,
        "rh_proved": False,
        "rh_false_proved": False,
    }

    tri = json.load(open(ROOT / "certificates/PROOF_CLOSURE_TRIPLE_CERT.json", encoding="utf-8"))
    assert tri["beginning"]["closed"] is True
    assert tri["middle"]["closed"] is False
    assert tri["final"]["closed"] is False
    assert tri["authoritative_frontier"]["true_lane"] == MATERIAL_GATE

    gram = json.load(open(ROOT / "audit/R2_GRAM_FINITE_CERT.json", encoding="utf-8"))
    assert gram["classification"] == "INTERVAL_CERTIFIED_FINITE_N_MODEL_EVIDENCE"
    assert gram["interpretation"]["asymptotic_limit_proved"] is False
    assert gram["interpretation"]["uniform_upper_bound_proved"] is False
    assert gram["dnlimit_eq_zero_proved"] is False
    assert gram["rh_proved"] is False


def main() -> int:
    require_files()
    audit_dependency_pin()
    audit_all_riemann_lean()
    audit_text_hygiene()
    audit_json()
    audit_python()
    audit_semantics()
    print("R2_BACKWARD_DENSE_ALL_FILE_AUDIT=GREEN")
    print("MATERIAL_GATE_COUNT=1")
    print(f"MATERIAL_GATE={MATERIAL_GATE}")
    print("DNLIMIT_EQ_ZERO=false")
    print("RH_PROVED=false")
    return 0


if __name__ == "__main__":
    sys.exit(main())
