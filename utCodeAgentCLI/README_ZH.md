# utCodeAgentCLI

本目录代表 CLI 代码智能体执行层。

## 在四层模型中的角色

`utCodeAgentCLI` 是智能执行层。

- 开发者定义目标，智能体完成任务规划与执行。
- 继承 `methodPrompts` 的方法约束。
- 可调用 `slashCommands` 的标准化步骤。

## 典型内容

- CLI 任务入口提示词
- 目标模板与执行检查清单
- 反思回路与迭代记录

## 上游 / 下游

- 上游输入：
  - `methodPrompts`：方法约束来源
  - `slashCommands`：可复用执行单元
  - `agentSkill`：领域技能封装
- 下游输出：
  - 已执行任务、过程轨迹与反馈，用于方法改进

## 维护规则

当规划/执行/反思模式出现稳定复用时，将其固化，并把改进回写到 `slashCommands` 与 `methodPrompts`。
