# Java / Spring 微服务领域模块

## 定位

本模块不是独立 workflow，而是 Java / Spring Boot / Spring Cloud / MyBatis / Mongo / Redis / MQ 项目的领域增强模块。主 workflow 仍由 `workflow-bootstrap` 路由决定；当任务出现 Java/Spring 信号时，同时加载本模块。

## 触发信号

- `pom.xml`、`build.gradle`、`SpringBootApplication`
- `@RestController`、`@Service`、`@Transactional`
- MyBatis、MyBatis-Plus、Mapper XML
- Feign、OpenFeign、RestTemplate、WebClient
- RabbitMQ、Kafka、RocketMQ、MQ
- Redis、Redisson、MongoTemplate
- Nacos、XXL-JOB、Gateway、Spring Security、JWT

## 适用 Workflow

- `codebase-orientation`: 识别 Java 微服务分层、调用链、数据链路、外部依赖。
- `code-review-triage`: 补充 Java 微服务专项 review checklist。
- `debug-root-cause`: 排查事务、MQ、Feign、Redis、配置、数据库等常见根因。
- `api-contract-design`: 检查 DTO/VO、接口兼容、enum、null / empty / missing 语义。
- `data-migration-planning`: 检查 MyBatis 字段、历史数据、回填、兼容和回滚。
- `software-delivery-pipeline`: 在实施计划中补充风险、回滚和验证清单。

## 不适用场景

- 纯前端、纯 Python、纯文档项目。
- 仅做概念解释且不进入 workflow。
- 用户明确要求不使用 Java/Spring 专项规则。

## 项目识别

进入 Java/Spring 项目后，先识别并引用证据：

1. 构建方式：Maven / Gradle。
2. Spring Boot 和 Java 版本。
3. 模块结构：单体 / 多模块 / 多服务。
4. Web 框架：Spring MVC / WebFlux。
5. 数据访问：MyBatis / JPA / MongoTemplate / Redis。
6. 远程调用：Feign / MQ / HTTP Client。
7. 配置中心：Nacos / Apollo / 本地 yml。
8. 定时任务：XXL-JOB / Spring Scheduler。
9. 安全认证：Spring Security / OAuth2 / JWT。

证据必须尽量包含文件路径、类名、方法名、注解、配置 key、表名、topic / queue、接口路径。

## 专项检查清单

### 分层边界

- Controller 只做参数接收、校验、鉴权上下文获取、调用应用服务和返回 VO。
- 避免 Controller 直接调用 Mapper、拼复杂 SQL、处理 MQ / Redis 锁 / 事务。
- Service 避免过长方法、多职责混杂、事务边界混乱、魔法字符串状态流转。

### DTO / VO / Entity 边界

- Request DTO、Response VO、Entity、Feign DTO、Mongo 文档对象应隔离。
- 避免 Controller 直接返回 Entity 或 Feign 暴露内部模型。
- enum 新增应有 UNKNOWN / DEFAULT 兜底。
- null、空字符串、空数组、字段不存在语义必须明确。

### 事务

- `@Transactional` 应在 public service 方法上。
- 检查 self-invocation、private 方法、异常被吞导致事务失效。
- 避免在事务内调用 Feign / MQ / Python / 文件上传等外部依赖。
- 检查先发 MQ 后事务回滚、跨库或 Mongo + MySQL 混合写入无补偿。

### Feign / 远程调用

- 检查服务双向依赖、超时配置、fallback、错误码映射。
- 避免循环中 Feign、N+1 远程调用、重试放大。
- 输出调用方、被调用方、FeignClient、接口路径、请求/响应 DTO、失败处理方式。

### MQ

- 消息必须有业务唯一键，例如 orderNo、checkNo、jobId、taskId、eventId。
- 检查幂等、ack/nack、重试、死信、重复消费、乱序、失败告警。
- 检查本地事务和消息发送一致性。

### Redis / Redisson

- lock key 必须带业务唯一键并设置过期时间。
- unlock 必须校验 owner。
- 检查 tryLock 超时、死锁、误删他人锁、缓存 key 租户/用户/版本维度。

### MyBatis / SQL

- update/delete 必须有 where 条件。
- 动态 SQL 不得拼出全表更新。
- foreach 处理空集合。
- 分页要有稳定排序。
- 检查 like 索引风险、N+1 查询、magic column/status 字符串。

### Mongo

- 新字段兼容历史文档和字段不存在。
- 聚合查询关注索引。
- 避免大文档无限增长。
- 不把 Mongo 内部结构直接返回前端。

### 配置 / Nacos

- 新配置必须有默认值或明确启动失败策略。
- 配置 key 支持灰度或兼容旧配置。
- 配置缺失不应导致非必要启动失败。

### 安全与权限

- 检查 SecurityUtils / JWT claim / login_scene / tenant 上下文来源。
- 关注 patientId、storeId、tenantId、deptId 越权查询。
- 管理端和 C 端接口必须隔离。

### 权限 / API 架构任务

- 输出 Provider 侧调用链：Controller、Feign、Service、Mapper / Repository、表、缓存、MQ / 调度影响。
- 输出 Consumer 侧调用链：入口接口、调用顺序、查询前置过滤、业务层评估、分页 / 排序 / 总数影响。
- DTO / Request / Response / Feign DTO 必须强类型，不使用 loose container 表达权限决策。
- 权限失败默认 fail-closed；如选择降级，必须说明降级数据范围、错误码和前端行为。
- 对 patientId、自然人、tenantId、storeId、deptId、历史数据和时间窗口分别说明可 SQL 过滤字段与必须远程评估的资源事实。
- 对 scope 查询、resource permission 评估、单接口合并方案说明取舍、批量能力、N+1 风险和服务边界。
- 检查事务、Feign 超时 / fallback、MQ / 调度、缓存和幂等是否被权限链路放大。

### 接口兼容

- 不删除字段、不改变字段语义、不破坏 enum。
- 明确 null / empty / missing field 语义。
- 状态机、排序、版本、历史数据兜底必须可验证。

### 可观测性

- 关键日志应包含 traceId、jobId、checkNo、orderNo、patientId 等业务主键。
- 外部调用、耗时、异常日志要能定位链路和输入。

## 风险等级

- `low`: 注释、文档、小文案、非核心字段展示、只读查询优化。
- `medium`: 单接口逻辑调整、新增 DTO/VO 字段、单服务内部重构、非破坏性 SQL。
- `high`: 支付、订单、权限、医疗建议、诊断报告、健康计划、跨服务调用链、MQ 消费、数据迁移、删除字段/表、认证授权、多租户/patientId/storeId 权限。

`high` 风险任务必须进入 `full` mode，并要求 rollback + verification。

## Workflow 输出增强

### codebase-orientation

额外输出 Java 模块结构、Controller -> Service -> Mapper / Feign / MQ 调用链、数据模型关系、外部依赖、配置 key、权限上下文和高风险模块。

### code-review-triage

优先检查事务、Feign、MQ、Redis、SQL、Mongo、DTO/VO/Entity 边界、权限越权、幂等、enum/status magic string。

### debug-root-cause

假设树必须覆盖配置/Profile/Nacos、Bean 注入/循环依赖、事务失效、Feign 超时/fallback、MQ ack/retry/DLQ、Redis lock/cache、MyBatis SQL、Mongo 历史字段缺失。

### api-contract-design

额外输出 Request DTO、Response VO、enum、null / empty / missing 语义、兼容策略、老版本兜底和前端渲染建议。

### data-migration-planning

额外输出 affectedTables、affectedEntities、backfill scope、兼容期读写策略、rollback SQL / recovery plan、历史数据校验。

### software-delivery-pipeline

Implementation Plan 必须记录 affectedServices、affectedControllers、affectedFeignClients、affectedTables、affectedCollections、affectedTopics、affectedConfigKeys、riskLevel、rollbackPlan、verificationPlan。

权限、API、跨服务任务还必须继承架构文档中的 Provider 侧逻辑、Consumer 侧逻辑、接口拆分取舍、数据查询边界和验收项映射；缺失任一项时，回到架构确认阶段。
