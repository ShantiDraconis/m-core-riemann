import json
import subprocess
import sys


def main() -> None:
    out = subprocess.check_output([
        sys.executable, "zero_residue_probe.py", "--schedule", "32,64",
        "--t-grid", "0,10,20", "--zeros", "4", "--dps", "35"
    ], text=True)
    rows = [json.loads(line) for line in out.splitlines()]
    meta = rows[0]["metadata"]
    assert meta["classification"] == "MODEL_EVIDENCE_ONLY_CRITICAL_ZERO_TRUNCATION"
    assert meta["residue_tail_certified"] is False
    assert meta["dnlimit_eq_zero_proved"] is False
    assert meta["rh_proved"] is False
    data = rows[1:]
    assert len(data) == 6 and all(not row["skipped"] for row in data)
    assert all(float(row["raw_term_l1"]) > 0 for row in data)
    assert all(math_is_finite(float(row["combined_without_F_abs"])) for row in data)


def math_is_finite(value: float) -> bool:
    return value == value and value not in (float("inf"), float("-inf"))


if __name__ == "__main__":
    main()
