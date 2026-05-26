# Minimal Change 模块

本模块用于所有会触碰代码、配置、文档或 workflow artifact 的任务。目标是保持改动小、可解释、可验证。

## 最小改动规则

1. 只修改完成目标所必需的文件和逻辑。
2. 不做顺手重构、顺手格式化、批量改名或无关清理。
3. 发现无关问题时记录为后续建议，不直接纳入本轮。
4. 不回滚用户已有改动，除非用户明确要求。
5. 如果当前计划需要扩大 scope，先暂停说明原因、影响和替代方案。
6. 每个改动都应能映射到用户请求、已确认计划、handoff 或验证需求。

## Scope Guard

```md
## Scope Guard

### In Scope
- ...

### Out of Scope
- ...

### Scope Change Trigger
- ...
```

## 正例

- 修复一个字段位置时，只改 DTO 和映射逻辑，不重排整个 controller。
- 发现旧测试命名混乱，只在 summary 里记录，不顺手重命名。

## 反例

- 为了一个小 bug 格式化整个模块。
- 修一个 selected finding 时顺手修未选择 finding。
