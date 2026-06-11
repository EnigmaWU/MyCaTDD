# methodPrompts

本目录存放 CaTDD 的方法级提示词资产。

本 README 是方法层的 WHAT / WHY 入口。关于 HOW、WHO、WHEN、WHERE 如何独立使用 `methodPrompts/`，请阅读 [README_UserGuide.md](README_UserGuide.md) 或 [README_UserGuide_ZH.md](README_UserGuide_ZH.md)。

## What

`methodPrompts` 是 CaTDD 四层模型中的方法论权威源头层。

它定义稳定的 CaTDD 方法契约：

- comment-alive 验证设计的主方法规范。
- 面向 P0/P1/P2/P3 测试设计优先级的分类方法提示词。
- 面向只使用本目录的人类与 CodeAgent 的独立用户指南。
- 展示方法形态的 C++ 实现模板，但 C++ 不是方法要求。

这一层既适合人类阅读，也适合 LLM 理解；它与编程语言无关，并可被多种 code-agent 工具复用。

## Why

`methodPrompts` 存在的原因，是让 CaTDD 方法意图独立于任何单一工作流适配器、code-agent 产品、编程语言或项目模块。

下游层应将本目录视为稳定的方法契约：

- **slashCommands** 将高频方法步骤命令化，供 Copilot、Cline、Continue 或类似助手使用。
- **utCodeAgentCLI** 可将其作为 CaTDD-native 方法基础，再结合 `slashCommands` 进行更深入的规划与执行。
- **agentSkills** 将其封装为 code-agent 可复用能力。

当方法意图发生变化时，先修改这一层，让所有下游层继承同一个 CaTDD 含义。

## 阶段模型

CaTDD 方法提示词支持两个设计阶段：

- **Stage-0：自由草稿阶段** - 先捕获原始场景、风险、示例和开放问题，不要过早强行结构化。
- **Stage-1：分类设计阶段** - 将草稿归类到 CaTDD 类别，并转化为 US/AC/TC 验证设计。

默认分类顺序：

- P0 功能型：Typical -> Edge -> Misuse -> Fault
- P1 设计型：State -> Capability -> Concurrency
- P2 质量型：Performance -> Robust -> Compatibility -> Configuration
- P3 附加型：Demo/Example

## 强制追溯约束

- P0 功能设计默认应完整覆盖 `Typical -> Edge -> Misuse -> Fault`，除非开发者明确限制范围。
- 每个 US 至少对应 1 个 AC。
- 每个 AC 至少对应 1 个 TC。
- 设计产出必须在测试文件 Overview 中显式声明 SUT（例如：`SUT: utCodeAgentCLI`）。

## 典型内容

- 主方法规范（`CaTDD_methodPrompt.md`）
- 分类方法提示词（`CaTDD_methodPrompt4Cat-*.md`）
- 独立用户指南（`README_UserGuide.md`、`README_UserGuide_ZH.md`）
- 实现模板（`CaTDD_designAndImplTemplate.cxx`）

## 文档边界

保持文档分工清晰：

| 文件 | 负责内容 |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT：这一层包含什么；WHY：这一层为什么存在。 |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW：如何使用；WHO：谁使用；WHEN：何时使用；WHERE：放在哪里；以及可复制执行的 `Usage Example`。 |

具体的提示词选择步骤属于独立用户指南，不放在本 README 中。

## 上游 / 下游

- 上游输入：真实项目实践与经验反馈。
- 下游消费方：
  - `slashCommands`（方法步骤命令化）
  - `utCodeAgentCLI`（智能体执行约束）
  - `agentSkills`（可复用能力封装）

## 维护规则

当方法意图发生变化时，先更新本目录，再向其余 3 层同步传播。
