#!/usr/bin/env python3
from __future__ import annotations

import argparse
import csv
import sys
import subprocess
from pathlib import Path


NO_WORKFLOW_INTENTS = [
    "解释一下",
    "是什么",
    "什么意思",
    "有什么区别",
    "对比一下",
    "总结一下",
    "怎么看这个方案",
    "适合用哪个 skill",
    "产物在哪里",
]

WORKFLOW_ACTIONS: dict[str, list[str]] = {
    "code-review-triage": ["review", "审查", "检查", "找问题", "找出", "风险", "代码质量", "先列问题"],
    "debug-root-cause": ["排查", "启动失败", "启动不了", "失败", "报错", "异常", "根因", "测试为什么失败"],
    "api-contract-design": ["设计接口", "接口返回结构", "请求响应契约", "接口契约", "返回字段", "响应结构", "DTO", "VO", "days[]"],
    "data-migration-planning": ["表结构", "数据迁移", "回填", "迁移", "schema", "兼容"],
    "tdd-test-engineering": ["TDD", "写测试", "补测试", "测试用例", "回归测试", "测试证据", "验收标准", "发布前测试", "测试矩阵"],
    "software-delivery-pipeline": ["实现", "修复", "落地", "改代码", "改一下", "小改", "handoff 落地", "修复选中的", "直接改", "改完告诉我验证结果", "局部 bugfix"],
    "codebase-orientation": ["熟悉", "梳理", "看懂", "项目地图", "调用链", "怎么跑"],
}

ROUTING_PRIORITY = [
    "code-review-triage",
    "debug-root-cause",
    "api-contract-design",
    "data-migration-planning",
    "tdd-test-engineering",
    "software-delivery-pipeline",
    "codebase-orientation",
]

REVIEW_FIRST_PATTERNS = ["review 后修复", "review 再改", "先 review", "审查后修复", "先列问题"]
CONFIRMED_HANDOFF_PATTERNS = ["按这个 handoff 落地", "按已确认 handoff", "修复选中的", "修复已确认"]


def route(prompt: str) -> tuple[str, str]:
    if any(pattern in prompt for pattern in CONFIRMED_HANDOFF_PATTERNS):
        return "software-delivery-pipeline", "yes"

    matched_workflows = [
        workflow
        for workflow, keywords in WORKFLOW_ACTIONS.items()
        if any(keyword in prompt for keyword in keywords)
    ]

    if not matched_workflows:
        return "none", "no"

    if any(intent in prompt for intent in NO_WORKFLOW_INTENTS) and len(matched_workflows) == 1:
        return "none", "no"

    if any(pattern in prompt for pattern in REVIEW_FIRST_PATTERNS):
        return "code-review-triage", "yes"

    for workflow in ROUTING_PRIORITY:
        if workflow in matched_workflows:
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
