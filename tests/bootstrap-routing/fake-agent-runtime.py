#!/usr/bin/env python3
from __future__ import annotations

import sys


RULES = [
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


def main() -> int:
    prompt = sys.argv[1] if len(sys.argv) > 1 else ""
    workflow, run = route(prompt)
    print(f"workflow={workflow} run={run}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
