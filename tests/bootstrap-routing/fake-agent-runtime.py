#!/usr/bin/env python3
from __future__ import annotations

import sys


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

WORKFLOW_ACTIONS = {
    "code-review-triage": ["review", "审查", "找问题", "找出", "风险", "代码质量", "先列问题"],
    "debug-root-cause": ["排查", "启动失败", "启动不了", "失败", "报错", "异常", "根因", "测试为什么失败"],
    "api-contract-design": ["设计接口", "请求响应契约", "接口契约", "返回字段", "响应结构", "DTO", "VO", "days[]"],
    "data-migration-planning": ["表结构", "数据迁移", "回填", "迁移", "schema", "兼容"],
    "software-delivery-pipeline": ["实现", "修复", "落地", "改代码", "小改", "handoff 落地", "修复选中的"],
    "codebase-orientation": ["熟悉", "梳理", "看懂", "项目地图", "调用链", "怎么跑"],
}

ROUTING_PRIORITY = [
    "code-review-triage",
    "debug-root-cause",
    "api-contract-design",
    "data-migration-planning",
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


def main() -> int:
    prompt = sys.argv[1] if len(sys.argv) > 1 else ""
    workflow, run = route(prompt)
    print(f"workflow={workflow} run={run}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
