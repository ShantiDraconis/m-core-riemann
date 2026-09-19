import json
from pathlib import Path
import subprocess
import sys


def main() -> None:
    probe = Path(__file__).with_name("zero_residue_dyadic.py")
    out = subprocess.check_output([
        sys.executable, str(probe), "--schedule", "64", "--t-grid", "0,10",
        "--zeros", "8", "--dps", "35"
    ], text=True)
    rows = [json.loads(line) for line in out.splitlines()]
    meta = rows[0]["metadata"]
    assert meta["classification"] == "MODEL_EVIDENCE_ONLY_DYADIC_CRITICAL_ZERO_TRUNCATION"
    assert meta["off_critical_zeros_excluded"] is False
    assert meta["uniform_zero_tail_bound_proved"] is False
    assert meta["dnlimit_eq_zero_proved"] is False and meta["rh_proved"] is False
    for row in rows[1:]:
        assert not row["skipped"]
        assert len(row["blocks"]) == 4
        assert row["blocks"][-1]["positive_zero_index_end"] == 8
        ratio = float(row["cross_block_cancellation_ratio"])
        assert 0 <= ratio <= 1.0000000001


if __name__ == "__main__":
    main()
