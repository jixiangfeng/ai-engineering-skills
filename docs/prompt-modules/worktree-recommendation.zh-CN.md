# Worktree 建议模块

本模块用于大型改造、数据迁移、核心流程重构或当前工作区已经有本地改动的任务。它只提供隔离建议，不默认执行命令。

## 建议条件

当任务满足以下任意条件时，建议使用独立 worktree：

1. 涉及多个模块或多个服务。
2. 当前工作区存在未提交改动。
3. 任务可能持续较久。
4. 有多个方案需要试验。
5. 改造风险较高。
6. 涉及数据库迁移或核心流程重构。

## 输出结构

```md
## Worktree Recommendation

当前任务建议使用独立 worktree：yes / no

原因：
- ...

建议命令：
```bash
git worktree add ../<repo>-<task-slug> -b <branch-name>
```
```

## 强规则

- 只建议，不默认执行。
- 如果用户不同意使用 worktree，应记录风险并继续遵守 scope lock。
- 不得覆盖或回滚当前工作区的预存变更。

## 正例

- 当前 worktree dirty 且任务涉及多模块时，建议 worktree 并给命令。
- 用户拒绝 worktree 后，记录风险并限制改动范围。

## 反例

- 未经确认直接创建 worktree 或切分支。
- 用 worktree 作为扩大 scope 的理由。
