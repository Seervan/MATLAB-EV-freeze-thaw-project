"""
detect_stiffness_change.py
==========================
Python-based detection of stiffness anomalies in EV freeze-thaw data.

Reads processed shape descriptors exported from MATLAB (as a CSV or
JSON file) and applies a simple statistical threshold to flag samples
whose displacement or volume change exceeds expected limits.

Usage
-----
    python detect_stiffness_change.py --input data/processed/shape_descriptors.csv

The script writes a detection report to results/detection_report.csv.
"""

import argparse
import csv
import json
import os
import sys
from pathlib import Path

import numpy as np


# ---------------------------------------------------------------------------
# I/O helpers
# ---------------------------------------------------------------------------

def load_descriptors(filepath: str) -> list[dict]:
    """Load shape descriptors from a CSV or JSON file.

    Expected columns/keys:
        label, displacement, volume_change
    """
    path = Path(filepath)
    if not path.exists():
        raise FileNotFoundError(f"Input file not found: {filepath}")

    if path.suffix.lower() == ".json":
        with open(path, "r") as f:
            data = json.load(f)
        if not isinstance(data, list):
            data = [data]
        return data

    # Default: CSV
    records = []
    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            records.append({
                "label":         row["label"],
                "displacement":  float(row["displacement"]),
                "volume_change": float(row["volume_change"]),
            })
    return records


def save_report(records: list[dict], output_path: str) -> None:
    """Write detection results to a CSV report."""
    os.makedirs(os.path.dirname(output_path) or ".", exist_ok=True)
    fieldnames = ["label", "displacement", "volume_change",
                  "disp_anomaly", "vol_anomaly", "flagged"]
    with open(output_path, "w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(records)
    print(f"Detection report saved to: {output_path}")


# ---------------------------------------------------------------------------
# Detection logic
# ---------------------------------------------------------------------------

def detect_anomalies(
    records: list[dict],
    disp_threshold: float = 2.0,
    vol_threshold: float = 5.0,
) -> list[dict]:
    """Flag samples whose displacement or volume change exceeds thresholds.

    Parameters
    ----------
    records : list of dicts with keys 'label', 'displacement', 'volume_change'
    disp_threshold : displacement anomaly threshold (mm)
    vol_threshold  : absolute volume-change anomaly threshold (%)

    Returns
    -------
    Annotated list of dicts with additional boolean flags:
        'disp_anomaly', 'vol_anomaly', 'flagged'
    """
    disps = np.array([r["displacement"] for r in records])
    vols  = np.array([r["volume_change"] for r in records])

    mean_disp = float(np.nanmean(disps))
    std_disp  = float(np.nanstd(disps))

    annotated = []
    for r in records:
        d = r["displacement"]
        v = r["volume_change"]

        # Z-score based displacement anomaly
        z_disp = abs(d - mean_disp) / (std_disp + 1e-9)
        disp_anomaly = bool(z_disp > disp_threshold)

        # Absolute volume change anomaly
        vol_anomaly = bool(abs(v) > vol_threshold)

        annotated.append({
            **r,
            "disp_anomaly": disp_anomaly,
            "vol_anomaly":  vol_anomaly,
            "flagged":      disp_anomaly or vol_anomaly,
        })

    return annotated


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Detect stiffness anomalies in EV freeze-thaw data."
    )
    parser.add_argument(
        "--input", "-i",
        required=True,
        help="Path to the processed shape descriptors file (CSV or JSON).",
    )
    parser.add_argument(
        "--output", "-o",
        default=os.path.join("results", "detection_report.csv"),
        help="Path for the output detection report (default: results/detection_report.csv).",
    )
    parser.add_argument(
        "--disp-threshold", type=float, default=2.0,
        help="Z-score threshold for displacement anomaly detection (default: 2.0).",
    )
    parser.add_argument(
        "--vol-threshold", type=float, default=5.0,
        help="Absolute volume-change threshold in %% (default: 5.0).",
    )
    args = parser.parse_args()

    print("=== EV Freeze-Thaw Stiffness Change Detection ===")

    records   = load_descriptors(args.input)
    annotated = detect_anomalies(records, args.disp_threshold, args.vol_threshold)

    n_flagged = sum(r["flagged"] for r in annotated)
    print(f"Samples analysed : {len(annotated)}")
    print(f"Anomalies flagged: {n_flagged}")

    for r in annotated:
        if r["flagged"]:
            print(f"  [FLAGGED] {r['label']}  "
                  f"disp={r['displacement']:.4f} mm  "
                  f"vol_change={r['volume_change']:.2f}%")

    save_report(annotated, args.output)


if __name__ == "__main__":
    main()
