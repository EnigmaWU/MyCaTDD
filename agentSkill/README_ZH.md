# agentSkill

本目录存放技能包，用于在智能体工作流中复用 CaTDD。

## 在四层模型中的角色

`agentSkill` 是能力封装层。

- 将方法知识封装为可触发技能。
- 定义技能范围、约束、输入与输出。
- 通过参考资料保证执行与 CaTDD 对齐。

## 典型内容

- 技能包目录（例如 `comment-alive-test-driven-development/`）
- `SKILL.md` 文件（机器可读技能定义）
- 技能本地 `README.md`（人类可读用法）
- `references/` 资产（指南、提示词、模板、PPT）

## 上游 / 下游

- 上游输入：`methodPrompts`（权威方法定义）
- 下游消费方：
  - `utCodeAgentCLI`（智能体执行）
  - 调用特定技能的助手/聊天式工作流

## 维护规则

更新技能行为时，需要与 `methodPrompts` 保持一致，并同步刷新技能内参考资料。
