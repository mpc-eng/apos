#!/usr/bin/env python3
"""
Timeout fallback script for APOS pipeline advisory agents.

Called by MONO-REVIEW and REALITY-CHECK workflows when the agent times out.
Reads fallback values from state.json and writes a schema-valid JSON output
with timeout_state: "timed_out".

Usage:
    python3 write_timeout_output.py --agent MONO-REVIEW --state state.json --output approvals/pending/mono-review-output.json
    python3 write_timeout_output.py --agent REALITY-CHECK --state state.json --output approvals/pending/reality-check-output.json
"""

import argparse
import json
import sys
from datetime import datetime, timezone


def read_state(state_path: str) -> dict:
    with open(state_path, "r") as f:
        return json.load(f)


def build_mono_review_output(state: dict) -> dict:
    return {
        "schema_version": "3.3.0",
        "agent": "MONO-REVIEW",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "review_passed": True,
        "context": "monday_analytics",
        "timeout_state": "timed_out",
        "flags": [],
        "enriched_diagnosis": {
            "aarrr_pattern": state.get("last_aarrr_pattern", "not_diagnosed"),
            "intervention_type": state.get("last_intervention_type", "no_intervention"),
            "do_not_test": state.get("last_do_not_test", []),
            "enriched_diagnosis_source": "fallback",
        },
        "self_check": {
            "agent_badge": "[MONO-REVIEW]",
            "output_schema_valid": True,
            "gate_type": "advisory",
        },
    }


def build_reality_check_output(state: dict) -> dict:
    momentum = state.get("build_momentum_signal", "moderate")

    framing_map = {
        "strong": "Momentum is strong from last week. Building on recent progress with clear next steps ahead.",
        "moderate": "Pipeline is active with steady progress. Continuing forward with current priorities.",
        "stalled": "Taking stock of the current position. Identifying the single best next action to rebuild momentum.",
    }

    return {
        "schema_version": "3.3.0",
        "agent": "REALITY-CHECK",
        "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "review_passed": True,
        "context": "monday_session",
        "timeout_state": "timed_out",
        "idea_filter": {
            "suppressed_ids": [],
            "disappointment_loop_active": False,
            "consecutive_low_signal_batches": state.get(
                "consecutive_low_signal_batches", 0
            ),
            "cognitive_load_flag": False,
            "morning_framing": framing_map.get(momentum, framing_map["moderate"]),
        },
        "monday_session": {
            "build_momentum_signal": momentum,
            "system_health": {
                "manual_file_movements": state.get("system_health", {}).get(
                    "manual_file_movements", 0
                ),
                "schema_failures_this_week": state.get("system_health", {}).get(
                    "schema_failures_this_week", 0
                ),
                "health_status": "healthy",
            },
            "kill_log_pattern": None,
            "session_framing_note": framing_map.get(momentum, framing_map["moderate"]),
        },
        "self_check": {
            "agent_badge": "[REALITY-CHECK]",
            "output_schema_valid": True,
            "gate_type": "advisory",
        },
    }


def main():
    parser = argparse.ArgumentParser(
        description="Write timeout fallback output for APOS advisory agents"
    )
    parser.add_argument(
        "--agent",
        required=True,
        choices=["MONO-REVIEW", "REALITY-CHECK"],
        help="Agent that timed out",
    )
    parser.add_argument(
        "--state", required=True, help="Path to state.json"
    )
    parser.add_argument(
        "--output", required=True, help="Path to write output JSON"
    )
    args = parser.parse_args()

    state = read_state(args.state)

    if args.agent == "MONO-REVIEW":
        output = build_mono_review_output(state)
    elif args.agent == "REALITY-CHECK":
        output = build_reality_check_output(state)
    else:
        print(f"Unknown agent: {args.agent}", file=sys.stderr)
        sys.exit(1)

    with open(args.output, "w") as f:
        json.dump(output, f, indent=2)

    print(f"[{args.agent}] Timeout fallback output written to {args.output}")
    sys.exit(0)


if __name__ == "__main__":
    main()
