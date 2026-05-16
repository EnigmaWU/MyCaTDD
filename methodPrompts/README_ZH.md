# methodPrompts

本目录存放 CaTDD 的方法级提示词资产。

## 在四层模型中的角色

`methodPrompts` 是方法论的权威源头层。

- 定义如何设计并执行 CaTDD 工作流。
- 既适合人类阅读，也适合 LLM 理解。
- 应保持稳定、明确，并可被多工具复用。
- 与编程语言无关；特定语言文件只是示例或实现模板，不是方法限制。

## 消费方契约

下游工具应将本目录视为稳定的 CaTDD 方法契约：

- **开发者** 阅读它来理解方法，并手工填写 comment-alive 设计骨架。
- **CodeAgent** 阅读它来分类场景、保持 US/AC/TC 注释，并在不改变方法意图的前提下生成测试。
- **slashCommands** 可从中抽取高频方法步骤，形成适用于任意代码助手的命令提示词，例如 Copilot、Cline、Continue 或类似工具。
- **utCodeAgentCLI** 可将其作为 CaTDD-native 方法基础，再结合 `slashCommands` 进行更深入的规划与执行。

不要在这里把某一种编程语言、某一个 code-agent 产品或某一个项目模块写成方法要求。

## 阶段模型

CaTDD 方法提示词支持两个设计阶段：

- **Stage-0：自由草稿阶段** - 先捕获原始场景、风险、示例和开放问题，不要过早强行结构化。
- **Stage-1：分类设计阶段** - 将草稿归类到 CaTDD 类别，并转化为 US/AC/TC 验证设计。

默认分类顺序：

- P1 功能型：Typical -> Edge -> Misuse -> Fault
- P2 设计型：State -> Capability -> Concurrency
- P3 质量型：Performance -> Robust -> Compatibility -> Configuration
- P4 附加型：Demo/Example

## 典型内容

- 主方法规范（`CaTDD_methodPrompt.md`）
- 分类方法提示词（`CaTDD_methodPrompt4Cat-*.md`）
- 根目录用户指南（`../README_UserGuide.md`）
- 演示摘要（`CaTDD-UserGuide-PPT*.md`）
- 实现模板（`CaTDD_ImplTemplate.cxx`）

## 提示词地图

选择方法提示词时使用此地图：

| 需求 | 使用 |
| --- | --- |
| 先学习面向用户的工作流 | `../README_UserGuide.md` |
| 学习或解释完整 CaTDD 方法 | `CaTDD_methodPrompt.md` |
| 设计核心 happy-path 行为 | `CaTDD_methodPrompt4Cat-Typical.md` |
| 设计合法边缘场景、极限值和边界值 | `CaTDD_methodPrompt4Cat-Edge.md` |
| 设计错误 API 使用或非法调用者行为 | `CaTDD_methodPrompt4Cat-Misuse.md` |
| 设计依赖、资源或环境故障处理 | `CaTDD_methodPrompt4Cat-Fault.md` |
| 设计生命周期和 FSM 验证 | `CaTDD_methodPrompt4Cat-State.md` |
| 设计容量和最大能力验证 | `CaTDD_methodPrompt4Cat-Capability.md` |
| 设计线程安全或竞态条件验证 | `CaTDD_methodPrompt4Cat-Concurrency.md` |
| 设计速度、延迟、吞吐量或资源使用检查 | `CaTDD_methodPrompt4Cat-Performance.md` |
| 设计压力、重复、长稳或稳定性检查 | `CaTDD_methodPrompt4Cat-Robust.md` |
| 设计跨平台、版本或集成兼容性检查 | `CaTDD_methodPrompt4Cat-Compatibility.md` |
| 设计配置、功能开关或环境变量检查 | `CaTDD_methodPrompt4Cat-Configuration.md` |
| 设计面向文档的演示和示例 | `CaTDD_methodPrompt4Cat-DemoExample.md` |
| 编写 C++ comment-alive 测试文件 | `CaTDD_ImplTemplate.cxx` |

## 上游 / 下游

- 上游输入：真实项目实践与经验反馈。
- 下游消费方：
  - `slashCommands`（方法步骤命令化）
  - `utCodeAgentCLI`（智能体执行约束）
  - `agentSkill`（可复用能力封装）

## 维护规则

当方法意图发生变化时，先更新本目录，再向其余 3 层同步传播。
