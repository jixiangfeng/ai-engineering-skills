---
workflow: code-review-triage
runId: 2026-05-26-order-review
runPath: workflow/reviews/2026-05-26-order-review
executionMode: full
stage: summary
status: handoff_ready
source: example
allowsCodeEdit: false
nextAction: none
---
# Code Review Triage Full Run

> 这是 audited / full 路径的教学示例，用于展示 expanded review trail 和 handoff 形态；不代表新 run 的默认执行路径。
> 新 run 默认应优先使用 `10-review-scope.md`、`11-review-findings.md`、`12-review-fix-plan.md`、`13-review-summary.md` 这条 slim path。

## Review Findings

### Finding 1: 重复提交缺少幂等保护

- Severity: high
- Evidence: `OrderService.submit(...)`
- Impact: 可能创建重复订单。
- Suggested fix: service 层增加幂等检查并补测试。
- Confidence: high
- Requires user decision: yes

## Fix Handoff

### Accepted scope
- 修复 `F-001`。

### Excluded scope
- 不重构退款状态机。

### Files likely affected
- `OrderService`
- `OrderServiceTest`

### Verification focus
- 重复提交只创建一笔订单。

### Recommended next workflow
- software-delivery-pipeline

## Verification

### 完成判断
- analysis-only
