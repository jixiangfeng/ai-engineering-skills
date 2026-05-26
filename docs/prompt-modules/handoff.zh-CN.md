# Handoff 模块

本模块用于 workflow 之间交接，例如 orientation -> review、review -> delivery、debug -> delivery、api-contract -> delivery、migration -> delivery。

## 交接规则

1. handoff 必须说明来源 workflow、目标 workflow、已确认 scope、排除 scope、证据、约束、待确认问题和验证重点。
2. 下游 workflow 必须把 handoff 当作输入事实来源，不得重新扩大 scope。
3. 如果 handoff 缺少 selected items、验收标准、验证要求或用户确认记录，下游必须暂停补齐。
4. handoff 不等于代码修改授权；进入代码修改前仍需目标 workflow 的计划和确认门禁。
5. 修改 handoff 中未选择或已排除的事项，必须先请求用户确认。

## 机器可读元数据

handoff artifact 的 YAML front matter 必须包含：

```yaml
fromWorkflow: <source-workflow>
toWorkflow: <target-workflow>
selectedItems: []
verificationRequired: true
```

## 输出结构

```md
## Handoff

### Source
- fromWorkflow:
- sourceRun:
- sourceArtifacts:

### Target
- toWorkflow:
- recommendedNextAction:

### Accepted Scope
- ...

### Excluded Scope
- ...

### Selected Items
- ...

### Evidence
- ...

### Verification Required
- ...
```

## 正例

- review handoff 明确 `F-001`、`F-003` 已选择，`F-002` 排除，下游 delivery 只修选中项。
- debug handoff 带上复现命令、根因证据、最小修复点和验证命令。

## 反例

- “按上面修”但没有 selected items 就直接改代码。
- 下游 delivery 顺手修 handoff 之外的问题。
