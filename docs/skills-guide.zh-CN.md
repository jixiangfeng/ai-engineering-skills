# AI Engineering Skills 使用说明

这套仓库包含 6 个面向软件研发流程的 agent skill，目标是把“熟悉项目、审查问题、定位根因、设计契约、规划迁移、实现交付”变成可复用、可审查、可交接的文档化流程。

所有中间产物默认使用中文，生成在当前项目根目录的 `workflow/` 下，而不是生成在 skill 安装目录里。

## 一、Skill 总览

| Skill | 适用场景 | 是否默认改代码 | 主要产物目录 |
| --- | --- | --- | --- |
| `codebase-orientation` | 熟悉项目、模块、业务流程、调用链 | 否 | `workflow/orientation/<run>/` |
| `code-review-triage` | 只读代码审查，找问题并选择要修复的 findings | 否 | `workflow/reviews/<run>/` |
| `software-delivery-pipeline` | 需求确认、架构设计、计划、实现、二次 review、验证、交付 | 是，但必须过确认门禁 | `workflow/runs/<run>/` |
| `debug-root-cause` | 排查报错、失败测试、启动失败、运行时异常 | 否 | `workflow/debug/<run>/` |
| `api-contract-design` | 设计接口、DTO、响应结构、错误码、兼容策略 | 否 | `workflow/api-contracts/<run>/` |
| `data-migration-planning` | 规划表结构、数据迁移、回填、清理、回滚 | 否 | `workflow/data-migrations/<run>/` |

## 二、安装与调用

### Codex

在本仓库根目录执行：

```bash
./scripts/install-codex.sh
```

调用示例：

```text
$codebase-orientation 熟悉当前项目
$code-review-triage review 当前模块，列出需要处理的问题
$software-delivery-pipeline 按已确认的 handoff 进行实现
$debug-root-cause 排查这个启动失败
$api-contract-design 设计这个接口的请求响应契约
$data-migration-planning 规划这次表结构和数据迁移
```

### Claude

在本仓库根目录执行：

```bash
./scripts/install-claude.sh
```

调用示例：

```text
Use the codebase-orientation skill to understand this module first.
Use the code-review-triage skill to review this module.
Use the software-delivery-pipeline skill to implement the confirmed handoff.
Use the debug-root-cause skill to investigate this failure.
Use the api-contract-design skill to design this endpoint contract.
Use the data-migration-planning skill to plan this migration.
```

## 三、核心理念

### 1. 先理解，再审查，再实现

推荐主链路：

```text
codebase-orientation
  -> code-review-triage
  -> software-delivery-pipeline
```

含义：

1. 先用 `codebase-orientation` 熟悉业务、模块、调用链、数据契约。
2. 再用 `code-review-triage` 做只读 review，形成 findings。
3. 用户选择要修复的问题。
4. 生成 `review-to-delivery-handoff.md`。
5. 最后由 `software-delivery-pipeline` 负责实现、二次 review、验证和交付。

### 2. 所有关键阶段必须文档化

每个 workflow run 都会生成 Markdown 文档，记录：

- 当前范围
- 证据引用
- 决策记录
- 范围锁定
- 验收样例
- 验证矩阵
- 用户确认记录

这样可以避免只靠聊天上下文导致信息丢失。

### 3. 确认门禁不是一次确认

需求、架构、计划、修复选择等阶段都是“澄清与收敛循环”：

1. AI 生成当前阶段文档。
2. AI 主动指出矛盾、缺口、风险或与代码现状冲突的地方。
3. 用户反馈。
4. AI 更新文档。
5. 直到用户明确确认，并且无未解决阻塞项。

确认前不能进入下一阶段。

### 4. Review 和实现分离

`code-review-triage` 默认不改代码。

它只负责：

- 找问题
- 给 findings 编号
- 让用户选择要修复的 findings
- 生成修复计划
- 生成 `review-to-delivery-handoff.md`

真正实现必须交给 `software-delivery-pipeline`。

### 5. 实现后还有 Change Review Gate

`software-delivery-pipeline` 在实现后、验证前有条件触发二次 review：

- 来自 review handoff
- 有架构门禁
- 跨模块/跨服务
- 改 API / DTO / 数据契约
- 改数据库 / 持久化结构
- 改 MQ / 调度 / 并发
- 涉及权限、安全、数据一致性
- worktree 很脏或 diff 很大
- 用户明确要求二次 review

二次 review 通过后才能进入验证。

## 四、各 Skill 详细说明

## 1. codebase-orientation

### 用途

用于快速熟悉项目、模块、业务流程、接口链路、数据模型。

适合用户这样说：

```text
$codebase-orientation 熟悉当前项目
$codebase-orientation 熟悉 healthplan 模块
$codebase-orientation 看下这个接口链路是怎么跑的
```

### 默认行为

- 只读，不改代码。
- 优先从代码、配置、测试、文档找证据。
- 区分 `事实 / 推断 / 待确认`。
- 如果用户指定模块，先只看指定模块。
- 不把疑似问题直接当 review finding，只放到“后续可 review 的线索”。

### 主要产物

目录：

```text
workflow/orientation/<YYYY-MM-DD>-<slug>/
```

文件：

```text
01-orientation-scope.md
02-orientation-project-map.md
03-orientation-business-flow.md
04-orientation-technical-flow.md
05-orientation-data-contracts.md
06-orientation-open-questions.md
07-orientation-summary.md
orientation-to-review-handoff.md
orientation-to-delivery-handoff.md
```

### 后续联动

- 要继续 review：使用 `orientation-to-review-handoff.md` 交给 `code-review-triage`。
- 要直接实现：使用 `orientation-to-delivery-handoff.md` 交给 `software-delivery-pipeline`。

## 2. code-review-triage

### 用途

用于只读代码审查，找出需要处理的问题，并让用户选择修复范围。

适合用户这样说：

```text
$code-review-triage review 当前模块
$code-review-triage 根据刚才熟悉结果，找出需要处理的问题
$code-review-triage review 这个接口链路，有问题先列出来
```

### 默认行为

- 只读，不改代码。
- findings 必须有证据、影响、修复方向和置信度。
- 按严重级别排序：阻塞 / 高 / 中 / 低。
- 用户确认要修复的 findings 前，不生成修复计划。
- `04-review-fix-plan.md` 确认后，只生成 `review-to-delivery-handoff.md`，不直接实现。

### 主要产物

目录：

```text
workflow/reviews/<YYYY-MM-DD>-<slug>/
```

文件：

```text
review-workflow-state.md
01-review-scope.md
02-review-findings.md
03-review-fix-selection.md
04-review-fix-plan.md
review-to-delivery-handoff.md
review-delivery-result.md
07-review-summary.md
```

例外情况下，如果用户明确要求不走 `software-delivery-pipeline`，才可能生成：

```text
05-review-implementation.md
06-review-verification.md
```

### 后续联动

- 修复选中的 findings：交给 `software-delivery-pipeline` 读取 `review-to-delivery-handoff.md`。
- 修复完成后，`software-delivery-pipeline` 会回写 `review-delivery-result.md`。

## 3. software-delivery-pipeline

### 用途

用于真正执行功能实现、bug 修复、review handoff 落地、API 契约实现、数据迁移落地。

适合用户这样说：

```text
$software-delivery-pipeline 实现这个需求
$software-delivery-pipeline 按 review handoff 修复选中的问题
$software-delivery-pipeline 按 API 契约设计落地
```

### 默认行为

它是唯一默认可以改代码的主流程 skill，但必须经过确认门禁。

核心门禁：

1. `01-delivery-requirements.md` 需求确认。
2. `02-delivery-architecture.md` 架构/选型确认，条件触发。
3. `02-delivery-plan.md` 或 `03-delivery-plan.md` 实施计划确认。
4. 实现。
5. `05-delivery-change-review.md` 二次 review，条件触发。
6. 验证。
7. 交付。

### 主要产物

目录：

```text
workflow/runs/<YYYY-MM-DD>-<slug>/
```

文件：

```text
delivery-workflow-state.md
01-delivery-requirements.md
02-delivery-architecture.md
02-delivery-plan.md
03-delivery-plan.md
03-delivery-implementation.md
04-delivery-implementation.md
04-delivery-debugging.md
05-delivery-debugging.md
05-delivery-change-review.md
05-delivery-verification.md
06-delivery-verification.md
06-delivery-summary.md
07-delivery-summary.md
```

简单任务可能使用较短编号，例如没有架构门禁时使用 `02-delivery-plan.md`。
复杂任务会使用顺延编号，例如有架构门禁时使用 `03-delivery-plan.md`。

### Review Handoff 规则

从 `code-review-triage` 继续时，优先读取：

```text
workflow/reviews/<run>/review-to-delivery-handoff.md
workflow/reviews/<run>/03-review-fix-selection.md
workflow/reviews/<run>/04-review-fix-plan.md
workflow/reviews/<run>/02-review-findings.md
```

硬规则：

- review plan 确认不等于 delivery implementation approval。
- 没有 delivery requirements 和 delivery plan 确认前，不能改代码。
- 不能修未选择的 findings。
- 如果未选择的 finding 阻塞修复，必须暂停让用户确认是否扩大范围。

### Change Review Gate

实现后、验证前，如果触发条件成立，必须生成：

```text
05-delivery-change-review.md
```

允许进入验证的结论只有：

```text
approved_for_verification
approved_with_notes
```

其他结论必须回到实现、调试、计划、架构、需求，或暂停等待用户确认。

## 4. debug-root-cause

### 用途

用于排查错误、失败测试、启动失败、接口异常、运行时 bug。

适合用户这样说：

```text
$debug-root-cause 排查这个报错
$debug-root-cause 这个测试为什么失败
$debug-root-cause 项目启动失败，找根因
```

### 默认行为

- 只读优先，不直接修。
- 先复现，再解释。
- 先证据，再假设。
- 区分环境问题、既有失败、测试错误、产品代码错误。
- 找到根因后生成修复选项和验证计划。

### 主要产物

目录：

```text
workflow/debug/<YYYY-MM-DD>-<slug>/
```

文件：

```text
01-debug-scope.md
02-debug-reproduction.md
03-debug-evidence.md
04-debug-hypotheses.md
05-debug-root-cause.md
06-debug-fix-options.md
07-debug-verification-plan.md
08-debug-summary.md
debug-to-delivery-handoff.md
```

### 后续联动

- 要修复：交给 `software-delivery-pipeline` 读取 `debug-to-delivery-handoff.md`。

## 5. api-contract-design

### 用途

用于设计 API、DTO、响应结构、错误码、校验规则、兼容策略。

适合用户这样说：

```text
$api-contract-design 设计这个接口的请求响应
$api-contract-design 这个字段应该放在哪里，契约先定一下
$api-contract-design 梳理前后端接口契约
```

### 默认行为

- 只设计，不实现。
- 强调字段名、字段位置、类型、空值语义。
- Java 后端优先强类型 DTO，不使用 `Map<String,Object>` / raw `Object` / `JSONObject` 作为契约。
- 明确兼容旧客户端与否。

### 主要产物

目录：

```text
workflow/api-contracts/<YYYY-MM-DD>-<slug>/
```

文件：

```text
01-api-contract-scope.md
02-api-current-contract.md
03-api-proposed-contract.md
04-api-compatibility.md
05-api-validation-errors.md
06-api-examples.md
07-api-summary.md
api-to-delivery-handoff.md
```

### 后续联动

- 契约确认后，交给 `software-delivery-pipeline` 读取 `api-to-delivery-handoff.md` 实现。

## 6. data-migration-planning

### 用途

用于规划表结构变更、数据迁移、回填、清理、兼容、验证 SQL、回滚恢复。

适合用户这样说：

```text
$data-migration-planning 规划这次表结构变更
$data-migration-planning 这个字段迁移怎么做
$data-migration-planning 设计数据回填和回滚方案
```

### 默认行为

- 只规划，不直接执行迁移。
- 先确认当前数据模型和真实读写路径。
- 分离 schema 变更、代码兼容、数据回填、验证、清理旧逻辑。
- 必须有验证 SQL 或可执行检查。
- 必须有回滚或恢复策略。
- 破坏性操作必须等待用户确认。

### 主要产物

目录：

```text
workflow/data-migrations/<YYYY-MM-DD>-<slug>/
```

文件：

```text
01-migration-scope.md
02-migration-current-data-model.md
03-migration-target-data-model.md
04-migration-plan.md
05-migration-rollback-plan.md
06-migration-validation-sql.md
07-migration-summary.md
migration-to-delivery-handoff.md
```

### 后续联动

- 迁移方案确认后，交给 `software-delivery-pipeline` 读取 `migration-to-delivery-handoff.md` 落地。

## 五、常见组合流程

### 1. 先熟悉，再 review，再修复

```text
$codebase-orientation 熟悉 healthplan 模块
$code-review-triage 基于 orientation 结果 review healthplan 模块
$software-delivery-pipeline 按 review-to-delivery-handoff.md 修复选中的 findings
```

流程：

```text
orientation summary
  -> orientation-to-review-handoff.md
  -> review findings
  -> review-to-delivery-handoff.md
  -> delivery requirements / plan
  -> implementation
  -> change review
  -> verification
  -> delivery summary
```

### 2. 先排查 bug，再修复

```text
$debug-root-cause 排查这个接口返回错误
$software-delivery-pipeline 按 debug-to-delivery-handoff.md 修复
```

### 3. 先设计 API 契约，再实现

```text
$api-contract-design 设计 summary/detail 接口响应结构
$software-delivery-pipeline 按 api-to-delivery-handoff.md 实现
```

### 4. 先规划数据迁移，再落地

```text
$data-migration-planning 规划 health_plan 表字段迁移
$software-delivery-pipeline 按 migration-to-delivery-handoff.md 落地
```

### 5. 已有 review 计划，继续实现

```text
$software-delivery-pipeline 按 workflow/reviews/<run>/review-to-delivery-handoff.md 继续
```

如果没有 handoff，但存在已确认的：

```text
03-review-fix-selection.md
04-review-fix-plan.md
```

`software-delivery-pipeline` 可以重建需求，但必须停在 `01-delivery-requirements.md` 等用户确认，不能直接改代码。

## 六、状态机与恢复

`software-delivery-pipeline` 和 `code-review-triage` 都有状态机文件：

```text
delivery-workflow-state.md
review-workflow-state.md
```

每次继续任务时，agent 应先读状态机，再读最新阶段文档，再看 git diff/status。

恢复协议：

1. 读取 workflow state。
2. 读取最新阶段文档。
3. 检查当前 git diff/status。
4. 明确当前阶段、阻塞项、是否允许改代码。
5. 只从记录的下一步继续。

## 七、文件命名规则

新 run 必须使用带流程前缀的文件名：

```text
01-delivery-requirements.md
02-review-findings.md
03-orientation-business-flow.md
05-debug-root-cause.md
03-api-proposed-contract.md
04-migration-plan.md
```

旧 run 中如果已经存在老文件名，例如：

```text
01-requirements.md
handoff-to-delivery.md
```

可以读取兼容，但不要继续生成新的老命名文件。

## 八、防误用规则

### 所有 skill

- 产物必须生成在当前项目根目录下的 `workflow/`，不能写到 skill 安装目录。
- 文档默认中文。
- 重要结论必须有证据引用，或者标记为推断 / 待确认。
- 用户反馈后必须更新当前阶段文档，不只在聊天里说明。

### Review 类流程

- `code-review-triage` 默认不改代码。
- 没有 `review-to-delivery-handoff.md`，不能实现 review findings。
- review plan 确认不等于 delivery implementation approval。

### Delivery 类流程

- 没有确认 `01-delivery-requirements.md`，不能进入计划。
- 没有确认 plan，不能改代码。
- 超出范围锁定必须暂停确认。
- 不允许用大范围格式化、换行归一化掩盖真实 diff。
- 不允许回滚用户或既有改动，除非用户明确要求。
- Change Review Gate 未通过，不能进入验证。

## 九、推荐使用习惯

- 用户说“熟悉一下”：用 `codebase-orientation`。
- 用户说“review 下”：用 `code-review-triage`。
- 用户说“报错/失败/启动不了”：用 `debug-root-cause`。
- 用户说“接口怎么设计”：用 `api-contract-design`。
- 用户说“表结构/数据怎么迁移”：用 `data-migration-planning`。
- 用户说“实现/落地/按 handoff 修”：用 `software-delivery-pipeline`。

