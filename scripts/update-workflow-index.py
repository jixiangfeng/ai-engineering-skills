#!/usr/bin/env python3
"""Create or update workflow/index.md from a workflow-state.json file."""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path
from typing import Any


HEADER = """# Workflow Index

本文记录当前项目的 workflow run，用于查找历史产物、恢复未完成任务、判断下一步。

## Runs

| Updated At | Workflow | Status | Scope | Run Path | Summary | Next Action |
| --- | --- | --- | --- | --- | --- | --- |
"""


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_state(path: Path) -> dict[str, Any]:
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"{path}: invalid JSON at line {exc.lineno}, column {exc.colno}: {exc.msg}")
    except OSError as exc:
        fail(f"{path}: cannot read file: {exc}")
    if not isinstance(data, dict):
        fail(f"{path}: state must be a JSON object")
    return data


def cell(value: Any, code: bool = False) -> str:
    if value is None or value == "":
        text = "无"
    else:
        text = str(value).replace("\n", " ").replace("|", "\\|")
    return f"`{text}`" if code and text != "无" else text


def row_from_state(state: dict[str, Any], summary: str | None) -> str:
    summary_value = summary if summary is not None else state.get("latestDocument")
    return (
        f"| {cell(state.get('updatedAt'))} "
        f"| {cell(state.get('workflow'), code=True)} "
        f"| {cell(state.get('status'), code=True)} "
        f"| {cell(state.get('selectedScope'))} "
        f"| {cell(state.get('runPath'), code=True)} "
        f"| {cell(summary_value, code=bool(summary_value))} "
        f"| {cell(state.get('nextAction'))} |"
    )


def split_index(content: str) -> tuple[list[str], list[str]]:
    lines = content.splitlines()
    table_start = None
    separator = None
    for index, line in enumerate(lines):
        if line.startswith("| Updated At | Workflow | Status | Scope | Run Path | Summary | Next Action |"):
            table_start = index
        elif table_start is not None and line.startswith("| --- | --- | --- | --- | --- | --- | --- |"):
            separator = index
            break
    if table_start is None or separator is None:
        return HEADER.rstrip("\n").splitlines(), []
    return lines[: separator + 1], lines[separator + 1 :]


def row_run_path(row: str) -> str | None:
    parts = [part.strip() for part in row.strip().strip("|").split("|")]
    if len(parts) < 5:
        return None
    run_path = parts[4].strip()
    if run_path.startswith("`") and run_path.endswith("`"):
        run_path = run_path[1:-1]
    return run_path


def upsert_index(index_path: Path, state: dict[str, Any], summary: str | None) -> None:
    new_row = row_from_state(state, summary)
    target_run_path = state.get("runPath")
    if not isinstance(target_run_path, str) or not target_run_path:
        fail("state.runPath must be a non-empty string")

    if index_path.exists():
        content = index_path.read_text(encoding="utf-8")
        header_lines, existing_rows = split_index(content)
    else:
        header_lines, existing_rows = HEADER.rstrip("\n").splitlines(), []

    rows: list[str] = []
    replaced = False
    for row in existing_rows:
        if not row.startswith("| "):
            continue
        if row_run_path(row) == target_run_path:
            rows.append(new_row)
            replaced = True
        else:
            rows.append(row)
    if not replaced:
        rows.append(new_row)

    index_path.parent.mkdir(parents=True, exist_ok=True)
    index_path.write_text("\n".join(header_lines + rows) + "\n", encoding="utf-8")
    print(f"Updated {index_path}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--state", required=True, help="Path to workflow-state.json.")
    parser.add_argument("--index", required=True, help="Path to workflow/index.md.")
    parser.add_argument("--summary", default=None, help="Optional summary path or text for index Summary.")
    args = parser.parse_args()

    state = load_state(Path(args.state))
    upsert_index(Path(args.index), state, args.summary)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
