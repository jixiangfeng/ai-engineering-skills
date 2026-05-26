# Write Guard 模块

本模块用于所有可能写入、删除、覆盖、格式化、安装、迁移或执行高影响命令的 workflow。

## 默认写入边界

默认只读 workflow：

- `codebase-orientation`
- `code-review-triage`
- `debug-root-cause`
- `api-contract-design`
- `data-migration-planning`

默认允许写入 workflow：

- `software-delivery-pipeline` 的 implementation / verification / summary 阶段，且必须经过 requirements gate 和 plan gate。

## 写入门禁

触发以下动作前必须通过 Write Guard：

1. 修改代码、配置、文档或 workflow artifact。
2. 删除、覆盖、移动文件。
3. 执行数据迁移、回填、清理脚本。
4. 执行安装、发布、格式化、批量生成或 destructive command。
5. 扩大 scope 或处理 handoff / selected items 之外的内容。

## 输出要求

```md
## Write Guard

- allowsCodeEdit: true / false
- Write action:
- Gate evidence:
- User confirmation:
- Scope:
- Rollback / recovery:
```

## 正例

- review 阶段只写 review artifact，不修改业务代码。
- delivery 阶段在 requirements + plan 确认后才修改计划内文件。

## 反例

- orientation 时顺手修代码。
- 没有确认 selected findings 就开始改 review 发现的问题。
