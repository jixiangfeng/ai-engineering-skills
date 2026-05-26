#!/usr/bin/env python3
"""Generate a workflow-state.json file that matches docs/workflow-state-schema.json."""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path


WORKFLOWS = (
    "codebase-orientation",
    "code-review-triage",
    "debug-root-cause",
    "api-contract-design",
    "data-migration-planning",
    "software-delivery-pipeline",
)

STATUSES = (
    "not_started",
    "in_progress",
    "blocked",
    "pending_human_confirmation",
    "handoff_ready",
    "completed",
    "abandoned",
)

EXECUTION_MODES = ("lightweight", "standard", "full")
RISK_LEVELS = ("low", "medium", "high")


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def nullable(value: str | None) -> str | None:
    if value is None or value == "":
        return None
    return value


def parse_blockers(values: list[str]) -> list[str]:
    blockers: list[str] = []
    for value in values:
        for item in value.split(","):
            item = item.strip()
            if item:
                blockers.append(item)
    return blockers


def parse_csv_items(values: list[str]) -> list[str]:
    items: list[str] = []
    for value in values:
        for item in value.split(","):
            item = item.strip()
            if item:
                items.append(item)
    return items


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--workflow", required=True, choices=WORKFLOWS)
    parser.add_argument("--run-path", required=True)
    parser.add_argument("--output", required=True, help="Output workflow-state.json path.")
    parser.add_argument("--status", default="in_progress", choices=STATUSES)
    parser.add_argument("--execution-mode", default="standard", choices=EXECUTION_MODES)
    parser.add_argument("--current-stage", default="scope")
    parser.add_argument("--latest-document", default=None)
    parser.add_argument("--next-action", default="Continue from current workflow state.")
    parser.add_argument("--source-artifact", default=None)
    parser.add_argument("--domain-module", action="append", default=[], help="Repeat or comma-separate domain modules.")
    parser.add_argument("--selected-scope", default=None)
    parser.add_argument("--affected-service", action="append", default=[], help="Repeat or comma-separate affected services.")
    parser.add_argument("--blocker", action="append", default=[], help="Repeat or comma-separate blockers.")
    parser.add_argument("--code-edits-allowed", action="store_true")
    parser.add_argument("--risk-level", default="low", choices=RISK_LEVELS)
    parser.add_argument("--risk-reason", default="")
    parser.add_argument("--confirmation-required", action="store_true")
    parser.add_argument("--rollback-required", action="store_true")
    parser.add_argument("--updated-at", default=None)
    parser.add_argument("--force", action="store_true", help="Overwrite an existing output file.")
    args = parser.parse_args()

    output = Path(args.output)
    if output.exists() and not args.force:
        fail(f"{output} already exists; use --force to overwrite")

    updated_at = args.updated_at or datetime.now(timezone.utc).isoformat()
    state = {
        "schemaVersion": "1.0",
        "workflow": args.workflow,
        "runPath": args.run_path,
        "sourceArtifact": nullable(args.source_artifact),
        "domainModules": parse_csv_items(args.domain_module),
        "executionMode": args.execution_mode,
        "status": args.status,
        "currentStage": args.current_stage,
        "latestDocument": nullable(args.latest_document),
        "nextAction": args.next_action,
        "codeEditsAllowed": bool(args.code_edits_allowed),
        "riskLevel": args.risk_level,
        "riskReason": args.risk_reason,
        "confirmationRequired": bool(args.confirmation_required),
        "rollbackRequired": bool(args.rollback_required),
        "blockers": parse_blockers(args.blocker),
        "selectedScope": nullable(args.selected_scope),
        "affectedServices": parse_csv_items(args.affected_service),
        "updatedAt": updated_at,
    }

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(state, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
