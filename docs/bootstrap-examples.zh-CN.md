# Bootstrap Routing Examples

本文记录 `workflow-bootstrap` 的典型输入和期望路由，用于人工验收、安装后冒烟测试，以及 `scripts/check-consistency.sh` 的静态一致性检查。

## 使用方式

安装 plugin 后，用下列提示词测试 agent 是否会先判断 workflow，而不是直接进入实现或泛泛回答。

期望结果不是逐字匹配，而是 agent 应明确说明要进入哪个 workflow，并遵守对应 workflow 的只读、设计或交付边界。

## 典型路由

路由采用两层判断：

1. 是否需要进入 workflow：只有用户要求修改、排查、review、设计、迁移、熟悉项目或继续已确认 handoff 时才进入。
2. 进入哪个 workflow：在执行意图明确后，再按 review-first、debug、API 契约、数据迁移、交付、熟悉的优先级选择。

| 用户提示词 | 期望 workflow | 依据 |
| --- | --- | --- |
| 熟悉下当前项目 | `codebase-orientation` | 用户目标是理解项目结构、业务流程和调用链 |
| 看下 healthplan 模块怎么跑的 | `codebase-orientation` | 用户要求理解模块和技术流 |
| 梳理这个模块调用链 | `codebase-orientation` | 用户要求只读梳理调用关系 |
| 画一下项目地图 | `codebase-orientation` | 用户要求项目结构地图 |
| review 下整体逻辑，先列问题 | `code-review-triage` | 用户要求只读审查并产出问题清单 |
| 找出这个接口链路里需要处理的问题 | `code-review-triage` | 用户要求找问题，不是直接修 |
| review 后修复这些问题 | `code-review-triage` | review-first 任务先进入审查，确认 accepted scope 后再交付 |
| 先 review 再改代码 | `code-review-triage` | 用户明确要求先 review |
| 排查这个启动失败 | `debug-root-cause` | 用户描述失败现象，需要先定位根因 |
| 这个测试为什么失败 | `debug-root-cause` | 用户要求解释失败，需要证据优先调试 |
| 排查这个报错并修复 | `debug-root-cause` | 失败/报错优先根因排查，再决定修复 |
| 设计这个接口的请求响应契约 | `api-contract-design` | 用户要求设计 API / DTO / 响应契约 |
| 这个返回字段要放到 days[] 上 | `api-contract-design` | 用户要求调整响应结构，需要先稳契约 |
| 设计接口后落地 | `api-contract-design` | 契约设计优先于实现 |
| 规划这次表结构和数据迁移 | `data-migration-planning` | 用户要求 schema / 数据迁移规划 |
| 这个字段要回填历史数据 | `data-migration-planning` | 用户要求数据回填和验证策略 |
| 表结构迁移并实现 | `data-migration-planning` | schema / 数据变更优先规划，再交付 |
| 写测试覆盖这个回归 | `tdd-test-engineering` | 用户要求先补测试证据和回归覆盖 |
| 先写失败测试再修复 | `tdd-test-engineering` | 用户要求测试先行和缺陷复现 |
| 跑一下这个模块回归 | `tdd-test-engineering` | 用户要求执行回归测试和证据整理 |
| 按这个 handoff 落地 | `software-delivery-pipeline` | 用户要求按已确认 handoff 实现 |
| 修复选中的 findings | `software-delivery-pipeline` | 用户要求交付 review 选中项 |
| 实现这个小改动 | `software-delivery-pipeline` | 用户要求明确实现 |
| 直接把 README 里一个错别字改掉，改完告诉我验证结果 | `software-delivery-pipeline` | 低风险小改动且有明确执行授权 |
| 把这个局部 bugfix 先锁范围后直接改，改完给我验证结果 | `software-delivery-pipeline` | 需要最小 scope+plan 锁定，但不必展开完整流程 |

## 不应打开 workflow 的示例

| 用户提示词 | 期望行为 |
| --- | --- |
| 解释一下 DTO 是什么 | 直接概念回答，不创建 workflow run |
| 解释一下这个问题 | 直接解释，不因为“问题”误进 review |
| 这个报错是什么意思 | 直接解释，不因为“报错”误进 debug；用户要求排查时才进入 debug |
| 总结一下上面的内容 | 直接总结，不创建 workflow run |
| DTO 和 VO 有什么区别 | 直接对比，不创建 API 契约 workflow |
| 这个项目适合用哪个 skill | 直接说明推荐 workflow，除非用户要求开始执行 |
| 当前 review 产物在哪里 | 直接回答路径或状态 |

## 安装后冒烟测试

建议至少手动测试三类路由提示词：

1. 熟悉类：`熟悉下当前项目`
2. 排错类：`排查这个启动失败`
3. 交付类：`按这个 handoff 落地`

每次测试确认：

- agent 是否先声明路由判断
- 是否没有跳过只读/确认门禁
- 是否把产物写到当前项目根目录下的 `workflow/`
- 如果无法继续，是否说明阻塞原因

## Delivery 执行模式冒烟

安装后还应测试 `software-delivery-pipeline` 是否能按风险选择执行重量：

| 用户提示词 | 期望模式 | 期望产物 |
| --- | --- | --- |
| 帮我把 README 里一个错别字改掉，并说明验证结果 | `lightweight` / `fast` | concise summary 或 `00-fast-patch-summary.md` |
| 直接把 README 里一个错别字改掉，改完告诉我验证结果 | `lightweight` / `fast` | 不额外追问，直接记录最小计划和验证结果 |
| 实现一个局部低风险 bugfix，需要先确认范围和计划 | `standard` / `guarded` | `10-guarded-scope-plan.md` + `11-guarded-execution.md` + `12-guarded-summary.md` |
| 把这个局部 bugfix 先锁范围后直接改，改完给我验证结果 | `standard` / `guarded` | `10-guarded-scope-plan.md` 记录 combined gate 的 approval basis，必要时可同轮继续 |
| 按这个 review handoff 修复涉及 API 响应结构的问题 | `full` / `audited` | `20-audited-run-map.md` + 完整门禁链路 |

安装后还应测试 `tdd-test-engineering` 是否能独立运行并在需要时 handoff：

| 用户提示词 | 期望 workflow | 期望行为 |
| --- | --- | --- |
| 写测试覆盖这个回归 | `tdd-test-engineering` | 先确认验收标准，再进入测试计划 |
| 先写失败测试再修复 | `tdd-test-engineering` | 输出失败测试、执行证据或下游 handoff |
| 跑一下这个模块回归 | `tdd-test-engineering` | 记录命令、结果、失败分类和剩余风险 |

每次测试确认：

- agent 是否明确说明 execution mode 和 mode path
- fast 是否没有生成完整 `01-08` 文档
- guarded 是否有合并后的 scope / plan 门禁，以及带验证证据的 execution 文档
- audited 是否保留 handoff、风险门禁、验证矩阵和必要确认
- 高风险或 handoff 任务是否没有被降级

## 自动化 Harness

`tests/bootstrap-routing/cases.tsv` 是结构化验收资产，目前由两层检查使用：

- `scripts/check-consistency.sh` 做静态一致性检查：确认 expected workflow 存在、示例文档覆盖对应 workflow。
- `scripts/check-bootstrap-routing.py` 做可执行 harness：默认用确定性路由规则校验 `cases.tsv`，也支持 `--runtime-command` 调用外部 agent wrapper。

runtime wrapper 约定：

```bash
python3 scripts/check-bootstrap-routing.py \
  --cases tests/bootstrap-routing/cases.tsv \
  --runtime-command /path/to/agent-routing-wrapper
```

wrapper 接收用户提示词作为第一个参数，输出：

```text
workflow=<workflow-name> run=yes|no
```

Codex / Claude 的真实 skill 选择仍依赖运行时环境，不能用本地脚本完全替代安装后人工抽查。真实 agent harness 如未来接入，应复用 `cases.tsv`，不要另建一套用例。
