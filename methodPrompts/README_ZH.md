# methodPrompts

本目录存放 CaTDD 的方法级提示词资产。

## 在四层模型中的角色

`methodPrompts` 是方法论的权威源头层。

- 定义如何设计并执行 CaTDD 工作流。
- 既适合人类阅读，也适合 LLM 理解。
- 应保持稳定、明确，并可被多工具复用。

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

- 主方法规范（`CaTDD_DesignPrompt.md`）
- 分类设计提示词（`CaTDD_DesignPrompt4Cat-*.md`）
- 用户指南（`CaTDD_UserGuide.md`）
- 演示摘要（`CaTDD-UserGuide-PPT*.md`）
- 实现模板（`CaTDD_ImplTemplate.cxx`）

## 提示词地图

选择方法提示词时使用此地图：

| 需求 | 使用 |
| --- | --- |
| 学习或解释完整 CaTDD 方法 | `CaTDD_DesignPrompt.md` |
| 设计核心 happy-path 行为 | `CaTDD_DesignPrompt4Cat-Typical.md` |
| 设计合法边缘场景、极限值和边界值 | `CaTDD_DesignPrompt4Cat-Edge.md` |
| 设计错误 API 使用或非法调用者行为 | `CaTDD_DesignPrompt4Cat-Misuse.md` |
| 设计依赖、资源或环境故障处理 | `CaTDD_DesignPrompt4Cat-Fault.md` |
| 设计生命周期和 FSM 验证 | `CaTDD_DesignPrompt4Cat-State.md` |
| 设计容量和最大能力验证 | `CaTDD_DesignPrompt4Cat-Capability.md` |
| 设计线程安全或竞态条件验证 | `CaTDD_DesignPrompt4Cat-Concurrency.md` |
| 编写 C++ comment-alive 测试文件 | `CaTDD_ImplTemplate.cxx` |

## 上游 / 下游

- 上游输入：真实项目实践与经验反馈。
- 下游消费方：
  - `slashCommands`（方法步骤命令化）
  - `utCodeAgentCLI`（智能体执行约束）
  - `agentSkill`（可复用能力封装）

## 维护规则

当方法意图发生变化时，先更新本目录，再向其余 3 层同步传播。
