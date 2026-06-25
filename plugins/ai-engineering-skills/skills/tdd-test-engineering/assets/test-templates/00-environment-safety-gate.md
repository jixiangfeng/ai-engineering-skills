---
workflow: tdd-test-engineering
runId: <YYYYMMDD-slug>
runPath: workflow/tests/<YYYY-MM-DD>-<slug>
executionMode: standard
stage: environment-safety-gate
status: in_progress
source: user-request
allowsCodeEdit: false
nextAction: confirm_environment_safety_before_connecting
verificationRequired: true
---
# 环境安全门

## 文档元信息
- 项目根目录：
- 生成时间：
- 当前分支 / commit：
- 执行 agent：
- 来源文档：
- 文档状态：

## 环境 Profile
- profilePath：
- profileVersion：
- environmentType：local | test | staging | production
- credentialPolicy：masked_by_default | plaintext_user_approved
- credentialApprovalBasis：
- handoffCredentialAllowed：

## 连接目标
| 服务 | 用途 | 地址 / 库 / 集合 / 命名空间 | 用户 | 凭证策略 | 必需 | 结论 |
| --- | --- | --- | --- | --- | --- | --- |
| MySQL |  |  |  |  |  |  |
| MongoDB |  |  |  |  |  |  |
| Redis |  |  |  |  |  |  |
| MQ |  |  |  |  |  |  |
| Nacos |  |  |  |  |  |  |
| Elasticsearch |  |  |  |  |  |  |
| 外部 API |  |  |  |  |  |  |
| 模型服务 |  |  |  |  |  |  |

## 允许操作
| 服务 | 允许的 smoke check | 允许的测试写入 | 写入边界 | 清理方式 |
| --- | --- | --- | --- | --- |
| MySQL | `SELECT 1` / `SELECT DATABASE()` |  |  |  |
| MongoDB | `ping` / 只读查询测试集合 |  |  |  |
| Redis | `PING` / 读取测试 key |  |  |  |
| MQ | 查询测试 topic / consumer group |  |  |  |
| Nacos | 只读读取测试 namespace 配置 |  |  |  |
| Elasticsearch | health / 只读查询测试 index |  |  |  |

## 禁止操作
- 禁止连接生产环境后执行写入。
- 禁止无条件 `DELETE`、`UPDATE`、`DROP`、`TRUNCATE`。
- 禁止 MongoDB `dropDatabase`、`dropCollection`、无条件 `deleteMany` / `updateMany`。
- 禁止 Redis `FLUSHALL`、`FLUSHDB`、批量删除非测试前缀 key。
- 禁止向生产 MQ topic 发布消息、确认真实业务消息或修改 DLQ。
- 禁止修改生产 Nacos / 配置中心配置。
- 禁止调用真实支付、真实短信、真实推送或真实用户通知。
- 禁止使用真实患者 / 用户敏感数据做非只读测试。
- 禁止高成本批量调用生产模型密钥。

## 安全判断
- environmentType 是否明确：
- productionWriteAllowed：false
- destructiveOperationAllowed：false
- testWriteBoundary 是否明确：
- cleanupStrategy 是否明确：
- dangerousOperationRequested：
- oneOffApproval：
- gateStatus：passed | blocked

## 阻塞项
-

## 停止 / 确认记录
-

## 下一步
- 只有 `gateStatus=passed` 后，才能进入环境连通性验证和测试执行。
