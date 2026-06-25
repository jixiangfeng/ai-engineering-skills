# TDD 测试工程 Skill 设计文档

## 1. 文档信息

- Skill 名称：`tdd-test-engineering`
- 文档版本：`v1.0.0`
- 适用对象：Java / Spring Boot 项目优先，也可扩展到前端、Python、AI 模型及智能问诊项目
- 核心目标：建立“需求理解 → 用例确认 → 环境验证 → TDD 执行 → 问题确认 → 修复回归 → 测试总结”的完整测试闭环

---

## 2. Skill 定位

`tdd-test-engineering` 不是简单的“测试代码生成器”，而是一个覆盖完整测试生命周期的工程化 Skill。

其核心职责是：

1. 熟悉需求、设计和代码实现。
2. 将需求转换成可测试的验收标准。
3. 设计测试用例，并等待人工确认。
4. 检查测试环境、账号配置和依赖服务。
5. 验证测试环境连通性和测试数据完整性。
6. 按 TDD 流程编写并运行测试。
7. 输出失败证据和问题文档。
8. 等待人工确认是否修复。
9. 修复后执行缺陷回归、模块回归和完整回归。
10. 所有测试完成后输出测试总结和发布建议。

Skill 的完成标准不是“测试代码已经生成”，而是：

> 需求已经理解，测试用例已经确认，测试环境已经验证，全部确认用例已经执行，问题已经确认并处理，完整回归已经完成，并输出了可验证的测试证据和测试总结。

---

## 3. 适用场景

### 3.1 推荐使用场景

- 新功能开发前进行 TDD 测试设计。
- Bug 修复前编写复现测试。
- 已有功能补充自动化回归测试。
- 根据 Git Diff 分析测试影响范围。
- 发布前执行模块测试和完整回归。
- 验证数据库、Redis、MQ、Neo4j、Nacos 等依赖环境。
- 测试权限、资金、状态流转、医疗安全等高风险功能。
- 验证 AI 模型、提示词、智能问诊和疾病排序效果。
- 输出测试总结、风险报告和发布建议。

### 3.2 不适用场景

- 需求行为尚未明确，无法定义正确预期。
- 仅需要代码格式或代码风格审查。
- 线上故障根因尚未确认，应先进入故障定位流程。
- 仅需要设计接口协议。
- 仅需要部署、灰度或回滚设计。
- 用户明确禁止修改代码和执行测试。

---

## 4. 整体工作流

```text
熟悉需求
  ↓
梳理验收标准
  ↓
分析影响范围
  ↓
设计测试策略
  ↓
设计测试用例
  ↓
人工确认测试用例
  ↓
检查测试环境和配置
  ↓
验证环境连通性
  ↓
准备测试数据
  ↓
编写自动化测试
  ↓
执行 Red 阶段测试
  ↓
实现或修复业务代码
  ↓
执行 Green 阶段测试
  ↓
重构并回归
  ↓
输出问题文档
  ↓
人工确认是否修复
  ↓
执行问题修复
  ↓
缺陷用例回归
  ↓
相邻场景回归
  ↓
模块回归
  ↓
完整回归
  ↓
输出测试总结
```

---

## 5. 人工确认节点

Skill 必须支持暂停和恢复，至少设置两个强制确认节点。

### 5.1 测试用例确认

测试用例设计完成后，状态进入：

```yaml
phase: test_case_review
status: awaiting_approval
```

在用户确认之前，不允许：

- 编写生产业务代码。
- 修改已有业务逻辑。
- 根据测试失败自行改变业务预期。
- 开始完整测试执行。

用户可以：

- 确认全部测试用例。
- 删除不需要的测试用例。
- 增加遗漏场景。
- 修改预期结果。
- 调整测试优先级。
- 指定哪些场景自动化、哪些场景人工测试。

测试用例确认后生成版本基线：

```yaml
test_case_baseline:
  version: v1.0
  approved: true
  approved_at: 2026-06-25T10:30:00
```

### 5.2 缺陷修复确认

测试发现问题后，状态进入：

```yaml
phase: issue_review
status: awaiting_fix_approval
```

在用户确认之前，不允许自动修改生产代码。

Skill 应向用户输出：

- 问题列表。
- 严重级别。
- 影响范围。
- 关联测试用例。
- 复现证据。
- 初步原因。
- 建议修复范围。
- 修复风险。
- 是否阻塞发布。

用户可以选择：

- 修复全部问题。
- 只修复 P0 和 P1 问题。
- 指定问题修复。
- 暂不修复。
- 将部分问题标记为已知风险。

---

## 6. 阶段一：需求理解

### 6.1 需要读取的资料

Skill 应尽量读取：

- 需求文档。
- 产品原型。
- 详细设计。
- 接口文档。
- 数据库设计。
- 状态机设计。
- Git Diff。
- 当前源代码。
- 已有测试代码。
- 历史 Bug。
- 部署文档。
- 环境配置说明。
- 外部系统协议。
- 测试数据说明。

### 6.2 需求理解内容

必须梳理：

- 业务背景。
- 需求目标。
- 主流程。
- 异常流程。
- 边界条件。
- 数据流转。
- 状态变化。
- 权限规则。
- 外部系统依赖。
- 失败处理。
- 降级策略。
- 不在本次范围内的内容。

### 6.3 输出文件

```text
docs/testing/<task-id>/
├── requirement-understanding.md
├── acceptance-criteria.md
├── impact-analysis.md
└── open-questions.md
```

### 6.4 验收标准示例

```markdown
AC-01：实名认证前创建的报告不可被跨账号查询。

AC-02：实名认证后，同一自然人在其他账号下创建的报告可以查询。

AC-03：UMS 权限接口调用失败时，不得默认放开报告权限。

AC-04：输入不存在的 patientId 时，不得返回其他就诊人的数据。
```

### 6.5 输入不足时的处理

当需求存在不确定项时，应生成阻塞问题：

```markdown
## 测试阻塞项

- 未明确用户解除绑定后历史报告是否继续可见。
- 未定义 UMS 超时时的业务错误码。
- 未定义重复提交的幂等行为。
```

对于能够从代码、接口文档、已有测试和历史实现中确认的内容，应主动分析，不应把全部问题抛给用户。

---

## 7. 阶段二：影响范围分析

Skill 应分析：

- 修改了哪些文件。
- 哪些入口会调用修改代码。
- 哪些公共方法受到影响。
- 哪些接口可能发生行为变化。
- 哪些数据库表和字段被读写。
- 是否影响缓存、消息、图数据库或第三方服务。
- 是否影响历史功能。
- 是否需要跨模块回归。

输出示例：

```markdown
## 变更影响范围

### 直接影响

- ReportController
- ReportService
- PatientPermissionService

### 间接影响

- 报告列表查询
- 报告详情查询
- 健康调理计划入口

### 高风险依赖

- UMS 权限接口
- patientId 与 naturalPersonId 映射
- realnamePassedAt 时间过滤
```

不能只依据 Git Diff 中的文件列表判断测试范围，还必须结合调用链和业务链路。

---

## 8. 阶段三：测试策略设计

### 8.1 测试层级

根据风险选择：

- 单元测试。
- Service 测试。
- Controller/API 测试。
- 数据库集成测试。
- Redis 集成测试。
- MQ 集成测试。
- Neo4j 集成测试。
- 外部系统契约测试。
- 端到端测试。
- 回归测试。
- 并发测试。
- 性能测试。
- 安全和权限测试。
- AI 专项评测。

### 8.2 风险分级

| 风险级别 | 典型场景 | 最低测试要求 |
|---|---|---|
| 低 | 工具类、简单转换 | 单元测试 |
| 中 | Service 业务规则 | 单元测试 + 集成测试 |
| 高 | 权限、金额、状态流转 | 单元 + 接口 + 数据库集成 + 回归 |
| 极高 | 跨系统权限、支付、医疗结论 | 完整链路 + 异常场景 + 人工复核 |

### 8.3 测试优先级

| 优先级 | 含义 |
|---|---|
| P0 | 核心主流程、权限、资金、医疗安全 |
| P1 | 重要业务分支和异常处理 |
| P2 | 一般边界及兼容性场景 |
| P3 | 低风险体验和非核心场景 |

---

## 9. 阶段四：测试用例设计

### 9.1 用例结构

每个测试用例至少包含：

```yaml
case_id: TC-REPORT-001
title: 实名认证前的报告不可跨账号查询
requirement_id: AC-01
priority: P0
test_type: integration
preconditions:
  - 用户A和用户B对应同一自然人
  - 用户B在2026-06-01完成实名认证
  - 报告创建时间为2026-05-20
steps:
  - 使用用户B登录
  - 查询用户A名下报告
expected:
  - 不返回2026-05-20创建的报告
  - 不泄露报告摘要和报告ID
automation: true
data_cleanup: required
```

### 9.2 必须覆盖的场景

每个功能至少覆盖：

1. 正常场景。
2. 边界场景。
3. 异常场景。
4. 权限和安全场景。
5. 数据不存在场景。
6. 重复请求场景。
7. 并发场景。
8. 外部依赖超时场景。
9. 外部依赖返回异常数据场景。
10. 历史 Bug 回归场景。

### 9.3 测试矩阵示例

| 编号 | 场景 | 前置条件 | 输入 | 预期结果 | 优先级 |
|---|---|---|---|---|---|
| T01 | 查询本人认证后报告 | 已实名 | patientId=A | 返回认证后报告 | P0 |
| T02 | 查询认证前报告 | 已实名 | patientId=A | 不返回认证前数据 | P0 |
| T03 | 跨账号同一自然人 | 两账号均实名 | naturalPersonId 相同 | 按权限范围返回 | P0 |
| T04 | UMS 接口超时 | 权限服务不可用 | 正常请求 | 返回降级结果或明确错误 | P0 |
| T05 | patientId 不存在 | 无对应就诊人 | 非法 ID | 不泄露任何报告 | P0 |

### 9.4 输出文件

```text
test-strategy.md
test-cases.md
test-data-plan.md
```

---

## 10. TDD 执行方式

## 10.1 新功能：严格 TDD

新功能采用经典流程：

```text
Red → Green → Refactor
```

### Red

先编写测试，并确认测试因为功能尚未实现而失败。

记录：

```yaml
tdd_phase: red
expected_failure: true
failure_reason: 功能尚未实现
```

如果测试一开始就通过，应检查：

- 功能是否已经存在。
- 测试是否没有命中真实业务逻辑。
- Mock 是否过多。
- 断言是否无效。
- 测试数据是否错误。
- 测试调用的是否为错误入口。

### Green

只编写让测试通过的最小实现。

禁止：

- 顺带修改无关模块。
- 提前进行大范围重构。
- 为了通过测试而改变已确认的业务预期。

### Refactor

测试通过后才允许重构。

每次重构之后必须重新执行：

- 当前缺陷测试。
- 当前测试类。
- 当前模块测试。
- 必要的关联模块回归。

---

## 10.2 已有功能：特征测试和回归测试

已有项目不应强行套用新功能 TDD，应采用：

```text
现有行为识别
  ↓
补充特征测试
  ↓
确认当前基线
  ↓
增加缺陷复现测试
  ↓
修复业务代码
  ↓
执行回归
```

Bug 修复必须遵循：

> 先编写一个可以稳定复现 Bug 的失败测试，再修改业务代码。

如果无法通过测试稳定复现问题，不应直接声称问题已修复。

---

## 11. 阶段五：测试环境识别

Skill 应根据项目自动识别所需环境，例如：

```yaml
runtime:
  jdk: 17
  maven: 3.9.x

services:
  mysql:
    required: true
  redis:
    required: true
  neo4j:
    required: true
  nacos:
    required: true
  mqtt:
    required: false
  ums:
    required: true
```

需要检查：

- JDK。
- Maven 或 Gradle。
- Node.js。
- Python。
- MySQL。
- Redis。
- Neo4j。
- Nacos。
- MQ。
- Elasticsearch。
- 第三方接口。
- 大模型接口。
- Docker。
- Testcontainers。
- 环境变量。
- 网络和 DNS。
- 配置中心。
- 测试数据。

---

## 12. 账号密码与密钥安全

测试 Skill 不应在文档、控制台或对话中直接输出完整密码和密钥。

### 12.1 允许输出

- 主机地址。
- 端口。
- 数据库名。
- 用户名。
- 测试环境标识。
- 密钥配置来源。
- 是否已经配置。
- 连通状态。
- 脱敏后的凭证信息。

示例：

```yaml
mysql:
  host: 10.10.1.20
  port: 3306
  database: cmp_test
  username: cmp_test_user
  password: "******"
  credential_source: NACOS:mysql.test.password
```

```yaml
neo4j:
  uri: bolt://10.10.1.30:7687
  username: neo4j_test
  password_source: ENV_NEO4J_PASSWORD
```

### 12.2 默认禁止输出

- 完整数据库密码。
- AccessKey。
- SecretKey。
- Token。
- 私钥。
- 模型 API Key。
- 生产账号密码。

---

## 13. 阶段六：环境连通性验证

环境验证应分四层。

### 13.1 网络连通

验证：

- DNS 解析。
- TCP 端口。
- TLS 证书。
- 网络超时。
- 代理和防火墙。

### 13.2 认证验证

验证：

- 账号是否存在。
- 密码是否正确。
- Token 是否有效。
- 是否拥有目标数据库或命名空间权限。
- 是否拥有只读或测试写权限。

### 13.3 服务验证

MySQL：

```sql
SELECT 1;
SELECT DATABASE();
```

Redis：

```text
PING
GET 测试专用 Key
```

Neo4j：

```cypher
RETURN 1 AS result;
```

Nacos：

- 查询测试命名空间。
- 获取指定 Data ID。
- 不修改配置。

外部接口：

- 调用健康检查接口。
- 调用测试账户只读接口。
- 校验响应状态和结构。

### 13.4 业务数据验证

检查：

- 测试库是否存在。
- 表结构是否正确。
- 数据库版本是否符合预期。
- 必要字典是否存在。
- 测试账号是否存在。
- 测试数据是否满足用例。
- 数据清理脚本是否可用。

### 13.5 环境检查输出

`environment-check.md` 示例：

| 环境 | 地址 | 认证 | 服务验证 | 数据验证 | 结果 |
|---|---|---|---|---|---|
| MySQL | 10.10.1.20:3306 | 成功 | 成功 | 成功 | 通过 |
| Redis | 10.10.1.21:6379 | 成功 | 成功 | 成功 | 通过 |
| Neo4j | 10.10.1.30:7687 | 成功 | 成功 | 部位数据缺失 | 阻塞 |
| UMS | test-ums | 成功 | 超时 | 未验证 | 失败 |

P0 用例依赖的环境没有通过时，不得开始完整测试。

---

## 14. 环境安全规则

连接环境前必须确认：

```yaml
environment_type: test
production_write_allowed: false
```

### 14.1 禁止操作

- 自动连接生产数据库并写入。
- 清空共享数据库。
- 执行无条件 `DELETE`。
- 执行无条件 `MATCH (n) DETACH DELETE n`。
- 清空整个 Redis。
- 使用真实患者隐私数据。
- 调用真实支付。
- 发送真实短信。
- 向真实用户推送消息。
- 触发生产 MQ 消息。
- 修改生产 Nacos 配置。
- 使用生产模型密钥执行高成本批量任务。

### 14.2 数据库测试最低要求

必须满足至少一个条件：

- 使用 Testcontainers。
- 使用独立测试库。
- 使用测试专属 Schema。
- 使用事务回滚。
- 测试数据带唯一前缀。
- 有确定的数据清理方案。

---

## 15. 阶段七：测试实现

### 15.1 测试代码要求

- 遵循项目已有测试风格。
- 优先复用 fixture、builder、测试基类。
- 不随意引入新测试框架。
- 测试名称体现业务行为。
- 每个测试只验证一个主要行为。
- 核心断言必须明确。
- 禁止只使用无意义的 `assertNotNull`。
- Mock 仅隔离非测试目标。
- 不得把核心逻辑全部 Mock 掉。
- 测试数据不依赖执行顺序。
- 测试结束后清理数据。
- 不允许通过删除断言让测试通过。
- 不允许通过 `@Disabled` 隐藏失败。

推荐命名：

```java
@Test
void shouldExcludeReportsCreatedBeforeRealNameVerification() {
    // given
    // when
    // then
}
```

不推荐：

```java
@Test
void test1() {
}
```

---

## 16. 阶段八：测试执行

### 16.1 推荐执行顺序

```text
1. 编译检查
2. 静态检查
3. 单个失败测试
4. 测试类
5. 当前模块测试
6. 相关模块回归
7. 全量回归
```

示例：

```bash
mvn -pl report-service \
    -Dtest=PatientPermissionServiceTest#shouldExcludeReportsBeforeVerification \
    test
```

```bash
mvn -pl report-service \
    -Dtest=PatientPermissionServiceTest \
    test
```

```bash
mvn -pl report-service test
```

```bash
mvn test
```

### 16.2 每次执行必须记录

- 执行命令。
- Git Commit。
- 分支。
- 测试环境。
- 开始时间。
- 结束时间。
- 测试总数。
- 成功数量。
- 失败数量。
- 跳过数量。
- 构建状态。
- 测试报告路径。
- 失败日志摘要。

### 16.3 失败分类

测试失败必须归类为：

- 业务代码缺陷。
- 测试用例错误。
- 测试数据问题。
- 环境问题。
- 外部依赖问题。
- 历史测试已失败。
- 非确定性偶发失败。
- 配置错误。
- 需求预期不明确。

---

## 17. 测试证据规则

“测试通过”必须包含真实证据。

示例：

```markdown
## 执行证据

执行命令：

`mvn -pl report-service test`

执行结果：

- Tests run: 42
- Failures: 0
- Errors: 0
- Skipped: 0
- BUILD SUCCESS

关键验证：

- 认证前报告过滤：通过
- 跨账号权限隔离：通过
- UMS 超时处理：通过
```

以下内容不能作为通过证据：

- 代码看起来没有问题。
- 理论上应该通过。
- 测试代码已经生成。
- 根据分析应该没有影响。
- 只编译成功但没有执行测试。
- 只执行了正常场景。
- 只运行了单个测试，没有回归。

---

## 18. 阶段九：问题文档输出

每个问题生成独立编号。

示例：

```markdown
## BUG-TEST-001：实名认证前报告被跨账号查询

### 严重级别

P0 / Blocker

### 关联测试用例

TC-REPORT-001

### 测试环境

test

### 前置条件

- 用户A和用户B属于同一自然人
- 认证时间为2026-06-01
- 报告创建时间为2026-05-20

### 复现步骤

1. 使用用户B登录
2. 调用报告列表接口
3. 查询用户A对应的报告

### 预期结果

不返回认证前报告。

### 实际结果

返回了2026-05-20创建的报告。

### 执行证据

- HTTP 状态码：200
- 返回报告数量：1
- reportId：已脱敏
- 测试日志：reports/BUG-TEST-001.log

### 初步原因

PatientPermissionService 只按 naturalPersonId 过滤，
未使用 realnamePassedAt 过滤报告时间。

### 建议修复范围

- PatientPermissionService
- ReportQueryService
- 对应 Mapper 查询条件
```

目录结构：

```text
docs/testing/<task-id>/issues/
├── BUG-TEST-001.md
├── BUG-TEST-002.md
└── issue-summary.md
```

---

## 19. 阶段十：问题修复

用户确认修复后，应遵守：

1. 先确认失败测试可以稳定复现。
2. 只修改与问题相关的最小范围。
3. 不修改测试预期迎合错误实现。
4. 不删除失败测试。
5. 不增加 `@Disabled` 跳过测试。
6. 不通过吞掉异常让测试变绿。
7. 不无依据放宽断言。
8. 修改公共代码后重新分析影响范围。
9. 每个问题尽量独立修复和验证。
10. 修复后必须保留回归测试。

修复记录示例：

```yaml
issue_id: BUG-TEST-001
changed_files:
  - PatientPermissionService.java
  - ReportMapper.xml
  - PatientPermissionServiceTest.java
fix_description:
  - 增加 realnamePassedAt 过滤
  - 报告创建时间必须晚于认证时间
```

---

## 20. 阶段十一：回归测试

修复后的回归分四层。

### 20.1 缺陷用例回归

只执行原失败用例，必须由失败变为通过。

### 20.2 相邻场景回归

例如：

- 认证时间等于报告时间。
- 没有认证时间。
- 多次实名认证。
- 不同自然人。
- 删除就诊人关系。
- UMS 返回空权限。
- UMS 超时。
- 报告时间为空。

### 20.3 模块回归

执行当前业务模块全部测试。

### 20.4 完整回归

执行所有已确认测试用例。

高风险业务还应考虑：

- 多次重复测试。
- 并发测试。
- 性能测试。
- 数据一致性检查。
- 测试数据清理验证。
- 外部接口契约回归。

---

## 21. AI 功能专项测试

对于智能问诊、疾病排序、症状提取、提示词和大模型功能，普通测试不足，需要增加专项评测。

### 21.1 固定评测数据集

```text
eval/
├── complaint-extraction/
│   ├── dataset-v1.jsonl
│   ├── expected-v1.jsonl
│   └── evaluation-config.yaml
├── disease-ranking/
└── question-generation/
```

示例：

```json
{
  "caseId": "ORTHO-001",
  "input": "右边肩膀抬起来疼，晚上更明显",
  "expected": {
    "bodyParts": ["右肩部"],
    "symptoms": ["肩部疼痛"],
    "laterality": "右侧"
  },
  "tags": ["肩部", "口语化", "基础场景"]
}
```

### 21.2 评测指标

- JSON 格式通过率。
- 必填字段完整率。
- 症状提取准确率。
- 部位识别准确率。
- Top1 Accuracy。
- Top3 Recall。
- MRR。
- NDCG@3。
- 红旗症状召回率。
- 危险疾病漏诊率。
- 幻觉率。
- 拒答正确率。
- 平均响应时间。
- Token 消耗。
- 单次调用成本。

### 21.3 非确定性测试

同一个输入建议重复执行：

```yaml
repeat_count: 5
temperature: 0.2
```

检查：

- 输出结构是否稳定。
- 关键字段是否漂移。
- 疾病 Top3 是否频繁变化。
- 是否偶发非法 JSON。
- 是否偶发无依据结论。

### 21.4 模型和 Prompt 版本记录

```yaml
model: qwen-max
model_version: 2026-06
prompt_version: complaint-extraction-v12
dataset_version: ortho-eval-v3
temperature: 0.2
run_time: 2026-06-25T10:30:00
```

### 21.5 基线对比

| 指标 | 基线 | 当前 | 变化 | 阈值 | 结论 |
|---|---:|---:|---:|---:|---|
| JSON 合规率 | 98.5% | 99.2% | +0.7% | ≥98% | 通过 |
| 症状准确率 | 91.0% | 92.1% | +1.1% | ≥90% | 通过 |
| 部位召回率 | 95.2% | 93.8% | -1.4% | ≥95% | 失败 |
| 平均耗时 | 1.8s | 2.6s | +44% | ≤2.5s | 失败 |

关键指标下降时，即使综合平均值提高，也不能判定通过。

---

## 22. 状态机设计

Skill 应保存状态，以支持暂停和恢复。

```yaml
workflow: tdd-test-engineering
task_id: CMP-20260625-001

phase: requirement_analysis
status: in_progress

phases:
  requirement_analysis:
    status: completed

  acceptance_definition:
    status: completed

  impact_analysis:
    status: completed

  test_case_design:
    status: completed

  test_case_review:
    status: approved

  environment_validation:
    status: completed

  test_implementation:
    status: completed

  test_execution:
    status: completed

  issue_review:
    status: approved

  issue_fix:
    status: completed

  regression:
    status: completed

  final_summary:
    status: completed
```

统一状态：

```text
pending
in_progress
awaiting_approval
approved
passed
failed
blocked
skipped_by_approval
completed
```

---

## 23. 完成条件

只有同时满足以下条件，Skill 才能输出“测试完成”：

```yaml
completion_conditions:
  approved_test_cases_executed: true
  p0_cases_passed: true
  p1_cases_passed: true
  unexplained_failures: 0
  blocked_cases: 0
  environment_verified: true
  test_data_cleaned: true
  known_risks_confirmed: true
  execution_evidence_complete: true
```

以下情况不得结束：

- 有确认用例未执行。
- 有失败没有分析。
- P0 用例被跳过。
- 环境未连接成功。
- 修复后只运行了单个测试。
- 修改生产代码后未重新回归。
- 测试数据未清理。
- 测试失败被忽略。
- 测试结果缺少证据。
- AI 关键指标下降但未说明风险。

---

## 24. 输出产物

推荐目录：

```text
docs/testing/<task-id>/
├── requirement-understanding.md
├── acceptance-criteria.md
├── impact-analysis.md
├── open-questions.md
├── test-strategy.md
├── test-cases.md
├── test-data-plan.md
├── environment-check.md
├── execution-report.md
├── issues/
│   ├── BUG-TEST-001.md
│   ├── BUG-TEST-002.md
│   └── issue-summary.md
├── fix-report.md
├── regression-report.md
├── risk-report.md
├── test-summary.md
├── state.md
└── handoff.md
```

---

## 25. 最终测试总结模板

```markdown
# 测试总结

## 一、测试结论

通过 / 条件通过 / 不通过 / 阻塞

## 二、测试范围

- 报告列表
- 报告详情
- 跨账号权限
- 实名认证时间过滤
- UMS 异常处理

## 三、执行结果

- 测试用例总数：56
- 通过：56
- 失败：0
- 阻塞：0
- 跳过：0

## 四、问题情况

- 共发现问题：4
- P0：1
- P1：2
- P2：1
- 已修复：4
- 未修复：0

## 五、回归情况

- 缺陷用例回归：通过
- 模块回归：通过
- 全量回归：通过

## 六、环境情况

- MySQL：通过
- Redis：通过
- Neo4j：通过
- UMS：通过

## 七、剩余风险

无。

## 八、发布建议

建议发布。
```

---

## 26. SKILL.md 建议结构

```markdown
---
name: tdd-test-engineering
description: 需求理解、测试用例确认、环境验证、TDD 执行、问题修复和完整回归测试闭环
version: 1.0.0
---

# Use when

- 新功能需要 TDD 测试
- Bug 修复需要回归验证
- 代码变更需要分析影响范围
- 发布前需要测试证据
- AI 模型或提示词需要评测

# Do not use when

- 需求行为尚未明确
- 仅进行代码风格审查
- 未知线上故障需要先定位根因
- 只需要部署、迁移或接口设计

# Workflow

1. Load requirements and repository context
2. Define acceptance criteria
3. Analyze change impact
4. Design test strategy
5. Generate test cases
6. Wait for test case approval
7. Validate test environment
8. Prepare test data
9. Implement tests
10. Execute Red phase
11. Implement or fix code
12. Execute Green phase
13. Refactor and regress
14. Produce issue report
15. Wait for fix approval
16. Fix approved issues
17. Execute defect regression
18. Execute module regression
19. Execute full regression
20. Produce final test summary

# Approval gates

- Test cases must be approved before implementation
- Production code fixes must be approved after issue reporting

# Credential policy

- Never print full passwords, tokens or private keys
- Output host, port, username, credential source and masked values only

# Verification rules

- Tests must actually run
- Commands and results must be recorded
- Failures must be classified
- P0 cases cannot be skipped
- Fixes must be followed by full regression
- Code review cannot replace test execution

# Stop conditions

- All approved test cases executed
- P0 and P1 cases passed
- No unexplained failures
- Environment verified
- Test data cleaned
- Risks documented
- Final summary generated
```

---

## 27. 第一版最小可用范围

第一版建议先实现：

1. 读取需求、Git Diff 和已有测试。
2. 输出需求理解和验收标准。
3. 分析变更影响范围。
4. 生成测试矩阵。
5. 等待测试用例确认。
6. 支持 Java、Spring Boot、Maven。
7. 支持 JUnit 5 和 Mockito。
8. 检查 JDK、Maven、MySQL、Redis、Neo4j、Nacos。
9. 验证环境连通性。
10. 生成失败测试。
11. 执行指定测试和模块测试。
12. 输出问题文档。
13. 等待修复确认。
14. 修复后执行缺陷回归和模块回归。
15. 输出测试总结、状态和交接文档。

第二版再增加：

- Testcontainers。
- MySQL、Redis、MQ、Neo4j 深度集成测试。
- Git Diff 自动回归范围推断。
- JaCoCo 覆盖率。
- 前端 E2E 测试。
- API 契约测试。
- AI 数据集评测。
- Prompt 和模型版本对比。
- 多次运行稳定性评测。
- 性能和成本指标。
- CI/CD 自动执行。
- 测试报告可视化。

---

## 28. 核心约束总结

1. 先理解需求，再设计测试。
2. 测试用例必须映射验收标准。
3. 测试用例必须经过人工确认。
4. 新功能遵循 Red、Green、Refactor。
5. Bug 必须先通过失败测试稳定复现。
6. 测试前必须验证环境和测试数据。
7. 账号密码只显示脱敏值或密钥来源。
8. 发现问题先输出证据，再等待修复确认。
9. 修复后必须执行缺陷回归、模块回归和完整回归。
10. 只有全部确认用例执行完成且无未解释失败，才能输出“测试通过”。

---

## 29. 最终定义

`tdd-test-engineering` 的最终完成标准：

> 需求已经理解，验收标准已经建立，测试用例已经人工确认，测试环境已经验证，所有确认用例已经执行，测试问题已经形成证据和文档，经确认的问题已经完成修复，缺陷回归、模块回归和完整回归均已执行，最终测试总结和发布建议已经输出。
