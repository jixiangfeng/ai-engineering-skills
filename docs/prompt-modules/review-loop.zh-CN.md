# Review 闭环模块

本模块用于 review 类 workflow。review 默认只读；发现问题后先分级、给证据、让用户选择是否修，再交给 delivery pipeline。

## Review Findings

```md
## Review Findings

### Finding 1: 标题

- Severity: critical / high / medium / low / suggestion
- Evidence:
- Impact:
- Suggested fix:
- Confidence:
- Requires user decision: yes / no
```

## Fix Handoff

当用户选择修复后，必须生成 handoff：

```md
## Fix Handoff

### Accepted scope
- ...

### Excluded scope
- ...

### Files likely affected
- ...

### Verification focus
- ...

### Recommended next workflow
- software-delivery-pipeline
```

## 强规则

- review 阶段默认只读。
- 除非用户明确确认 accepted scope，否则不得直接修改代码。
- 不把 suggestion 当成必须修复项。
- 修复未选择 finding 前必须暂停确认。
- handoff 必须保留 evidence、selected scope、excluded scope 和 verification focus。

## 正例

- Finding 先给 severity、evidence、impact，再等待用户选择。
- 用户选择 `F-001` 后，handoff 明确 `F-002` excluded。

## 反例

- review 完直接改代码。
- 把“建议重构”包装成 high severity 必修问题。
