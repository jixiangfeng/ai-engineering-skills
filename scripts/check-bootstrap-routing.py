#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import sys
import subprocess
from pathlib import Path


RULES: list[tuple[str, str]] = [
    ("启动失败", "debug-root-cause"),
    ("测试为什么失败", "debug-root-cause"),
    ("报错", "debug-root-cause"),
    ("review", "code-review-triage"),
    ("找出", "code-review-triage"),
    ("问题", "code-review-triage"),
    ("请求响应契约", "api-contract-design"),
    ("返回字段", "api-contract-design"),
    ("days[]", "api-contract-design"),
    ("表结构", "data-migration-planning"),
    ("数据迁移", "data-migration-planning"),
    ("回填", "data-migration-planning"),
    ("handoff 落地", "software-delivery-pipeline"),
    ("修复选中的", "software-delivery-pipeline"),
    ("熟悉", "codebase-orientation"),
    ("怎么看", "codebase-orientation"),
    ("怎么跑", "codebase-orientation"),
]

NO_WORKFLOW = ["解释一下", "适合用哪个 skill", "产物在哪里"]


def route(prompt: str) -> tuple[str, str]:
    for keyword in NO_WORKFLOW:
        if keyword in prompt:
            return "none", "no"
    for keyword, workflow in RULES:
        if keyword in prompt:
            return workflow, "yes"
    return "none", "no"


def route_with_runtime(command: str, prompt: str) -> tuple[str, str]:
    completed = subprocess.run(
        [command, prompt],
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if completed.returncode != 0:
        raise RuntimeError(completed.stderr.strip() or f"runtime command failed: {command}")
    output = completed.stdout.strip()
    parts = dict(part.split("=", 1) for part in output.split() if "=" in part)
    return parts.get("workflow", "none"), parts.get("run", "no")


def main() -> int:
    parser = argparse.ArgumentParser(description="Bootstrap routing harness for fixture prompts.")
    parser.add_argument("--cases", default="tests/bootstrap-routing/cases.tsv")
    parser.add_argument(
        "--runtime-command",
        help="Optional executable that receives the prompt as argv[1] and prints 'workflow=<name> run=yes|no'.",
    )
    args = parser.parse_args()

    failed = False
    with Path(args.cases).open(encoding="utf-8", newline="") as handle:
        reader = csv.DictReader(handle, delimiter="\t")
        for row in reader:
            if args.runtime_command:
                actual_workflow, actual_run = route_with_runtime(args.runtime_command, row["prompt"])
            else:
                actual_workflow, actual_run = route(row["prompt"])
            expected_workflow = row["expected_workflow"]
            expected_run = row["expect_workflow_run"]
            if (actual_workflow, actual_run) != (expected_workflow, expected_run):
                failed = True
                print(
                    f"{row['prompt']}: expected {expected_workflow}/{expected_run}, "
                    f"got {actual_workflow}/{actual_run}",
                    file=sys.stderr,
                )

    if failed:
        return 1
    print("Bootstrap routing harness checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
