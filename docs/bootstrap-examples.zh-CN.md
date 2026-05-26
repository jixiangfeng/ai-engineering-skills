# Bootstrap Routing Examples

本文记录 `workflow-bootstrap` 的典型输入和期望路由，用于人工验收、安装后冒烟测试，以及 `scripts/check-consistency.sh` 的静态一致性检查。

## 使用方式

安装 plugin 后，用下列提示词测试 agent 是否会先判断 workflow，而不是直接进入实现或泛泛回答。

期望结果不是逐字匹配，而是 agent 应明确说明要进入哪个 workflow，并遵守对应 workflow 的只读、设计或交付边界。

## 典型路由

| 用户提示词 | 期望 workflow | 依据 |
| --- | --- | --- |
| 熟悉下当前项目 | `codebase-orientation` | 用户目标是理解项目结构、业务流程和调用链 |
| 看下 healthplan 模块怎么跑的 | `codebase-orientation` | 用户要求理解模块和技术流 |
| review 下整体逻辑，先列问题 | `code-review-triage` | 用户要求只读审查并产出问题清单 |
| 找出这个接口链路里需要处理的问题 | `code-review-triage` | 用户要求找问题，不是直接修 |
| 排查这个启动失败 | `debug-root-cause` | 用户描述失败现象，需要先定位根因 |
| 这个测试为什么失败 | `debug-root-cause` | 用户要求解释失败，需要证据优先调试 |
| 设计这个接口的请求响应契约 | `api-contract-design` | 用户要求设计 API / DTO / 响应契约 |
| 这个返回字段要放到 days[] 上 | `api-contract-design` | 用户要求调整响应结构，需要先稳契约 |
| 规划这次表结构和数据迁移 | `data-migration-planning` | 用户要求 schema / 数据迁移规划 |
| 这个字段要回填历史数据 | `data-migration-planning` | 用户要求数据回填和验证策略 |
| 按这个 handoff 落地 | `software-delivery-pipeline` | 用户要求按已确认 handoff 实现 |
| 修复选中的 findings | `software-delivery-pipeline` | 用户要求交付 review 选中项 |

## 不应打开 workflow 的示例

| 用户提示词 | 期望行为 |
| --- | --- |
| 解释一下 DTO 是什么 | 直接概念回答，不创建 workflow run |
| 这个项目适合用哪个 skill | 直接说明推荐 workflow，除非用户要求开始执行 |
| 当前 review 产物在哪里 | 直接回答路径或状态 |

## 安装后冒烟测试

建议至少手动测试三类提示词：

1. 熟悉类：`熟悉下当前项目`
2. 排错类：`排查这个启动失败`
3. 交付类：`按这个 handoff 落地`

每次测试确认：

- agent 是否先声明路由判断
- 是否没有跳过只读/确认门禁
- 是否把产物写到当前项目根目录下的 `workflow/`
- 如果无法继续，是否说明阻塞原因

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
