# 测试策略模块

本模块用于代码修改前选择实现策略。不是所有任务都必须完整 TDD，但涉及 bug 修复、核心逻辑、状态机、数据转换、接口契约时，应优先测试先行。

## Strategy

可选策略：

- `test_first`
- `minimal_patch`
- `exploratory_fix`

## 选择规则

优先使用 `test_first`：

1. bug 修复。
2. 状态机逻辑。
3. 复杂业务规则。
4. 数据转换逻辑。
5. API 契约兼容。
6. 数据迁移校验。
7. 已有测试基础较好。

使用 `minimal_patch`：

1. 小范围确定性修改。
2. 文案、枚举、配置类调整。
3. 没有合适测试框架但可手工验证。

使用 `exploratory_fix`：

1. 根因未完全确认。
2. 需要先加日志或观察。
3. 需要构建最小复现。

## 输出结构

```md
## Implementation Strategy

- Strategy: test_first / minimal_patch / exploratory_fix
- Reason:
- Expected behavior:
- Test / verification cases:
```

## 失败处理

如果测试或验证失败，不允许连续猜测式修改。应回到 debug 纪律：复现、收集证据、提出假设、排除，再修订计划。

## 正例

- bug 修复先写一个能复现失败的测试，再做最小修复。
- 没有测试框架时选择 `minimal_patch`，但明确手工验证步骤和剩余风险。

## 反例

- 核心状态机改动没有任何测试或可执行验证。
- 测试失败后连续尝试多个无证据补丁。
