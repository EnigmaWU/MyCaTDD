# methodPrompts

本目录存放 CaTDD 的方法级提示词资产。

## 在四层模型中的角色

`methodPrompts` 是方法论的权威源头层。

- 定义如何设计并执行 CaTDD 工作流。
- 既适合人类阅读，也适合 LLM 理解。
- 应保持稳定、明确，并可被多工具复用。

## 典型内容

- 方法规范（`CaTDD_DesignPrompt.md`）
- 用户指南（`CaTDD_UserGuide.md`）
- 演示摘要（`CaTDD-UserGuide-PPT*.md`）
- 实现模板（`CaTDD_ImplTemplate.cxx`）

## 上游 / 下游

- 上游输入：真实项目实践与经验反馈。
- 下游消费方：
  - `slashCommands`（方法步骤命令化）
  - `utCodeAgentCLI`（智能体执行约束）
  - `agentSkill`（可复用能力封装）

## 维护规则

当方法意图发生变化时，先更新本目录，再向其余 3 层同步传播。
