# slashCommands

本目录存放可复用的斜杠命令提示词与流程，用于将 CaTDD 方法落地为可触发命令。

## 在四层模型中的角色

`slashCommands` 是方法文档与现有 CodeAgent 之间偏流程的连接与命令化层。

- 将 `methodPrompts` 中的方法片段转为可触发命令单元。
- 将这些命令单元组织为适合自动化执行的流程。
- 降低 GUI 或聊天式工作流的调用成本。
- 提升重复应用方法时的一致性。
- 与具体 code-agent 无关；命令应可被 Copilot、Cline、Continue 或任何能消费提示词文本的助手使用。
- 不定义 CaTDD 方法语义；只负责把现有 CodeAgent 的调用界面连接到 `methodPrompts` 中定义的方法。

## 连接器契约

`slashCommands` 应作为适配层，而不是第二套方法论层。

- 现有 CodeAgent 提供调用界面，例如聊天提示词、prompt files、skills、rules 或 custom commands。
- `slashCommands` 提供可移植的命令意图与流程顺序，用于自动化或半自动化执行。
- `methodPrompts` 提供分类语义、优先级顺序、设计骨架规则与 CaTDD 方法约束。
- 面向 Copilot、Cline、Continue 或 `utCodeAgentCLI` 的原生包装应只是这些可移植命令文件之上的薄适配。

相对 `methodPrompts`，`slashCommands` 更偏流程与自动化；相对 `slashCommands`，`methodPrompts` 更偏方法本身与手工理解。

## 规格驱动流程契约

`slashCommands` 是 CaTDD 的 Spec-Driven Development 风格工作流层。它不是一组松散的提示词快捷方式。

- 治理 spec 是 `methodPrompts` 中定义的 CaTDD verification design。
- 流程命令推动开发者和 CodeAgent 经过可重复阶段：转换或设计骨架、审查骨架、选择下一个 TC、实现一个 TC、审查实现。
- 活的产物是 US/AC/TC 注释、分类标签、优先级关卡、TC 状态标记和测试文件。
- 命令文件描述现在做什么、读什么、产出什么、保留什么，以及下一条命令是什么。
- 原生 Copilot、Cline、Continue 或 `utCodeAgentCLI` 适配器只暴露流程，不拥有方法本身。

在 CaTDD 术语中，直接在 CodeAgent 对话中使用 `methodPrompts` 是 **VibeCoding**：灵活、由方法引导的对话。使用 `slashCommands` 是 **SpecCoding**：基于同一套方法定义的结构化 Spec-Driven Development 流程。

## 原生适配生成

Copilot 使用 `.github/prompts/*.prompt.md` 文件作为可通过斜杠触发的提示词文件。可以用下面的脚本从这些可移植的 `SPEC_*` 和 `UT_*` 命令文件生成 Copilot 原生包装：

```bash
scripts/makeSlashCmd4Copilot.sh --clean
```

生成文件位于 `.github/prompts/`，并且应保持为薄包装。每个包装都指回可移植命令源文件，并指向 `methodPrompts` 作为方法真理源。

在本源仓库中，生成的 `UT_*.prompt.md` 和 `SPEC_*.prompt.md` 包装是临时输出，不应提交。应提交可移植命令源与生成脚本。

可以用下面的命令验证生成器：

```bash
bash scripts/test_makeSlashCmd4Copilot.sh
```

可以用下面的命令把 CaTDD 安装或刷新到另一个已启用 Copilot 的项目：

```bash
scripts/installCaTDD4Copilot.sh --target /path/to/project --clean-prompts
```

安装器会把 `methodPrompts` 和 `slashCommands` 复制到目标项目的 `.catdd/` 目录，然后在目标项目的 `.github/prompts/` 目录下生成 Copilot prompt 包装。

在目标项目中使用 SpecCoding 时，生命周期状态放在 `.catdd/spec/` 下，共享的 `README*` SPEC 文档放在项目根目录。应提交 `.catdd/spec/projectContext.md`、`.catdd/spec/pendingNews/`、`.catdd/spec/todoUS/`、`.catdd/spec/doneUS/`，以及项目根目录的 `README*` 文档等团队共享产物。`.catdd/spec/doingUS/` 和 `.catdd/spec/WorkingProcessLog.md` 属于本地进行中的工作状态，应保持 gitignore；安装器会维护这些 `.gitignore` 规则。

项目根目录的 README SPEC 文档可按需要包含 `README.md`、`README_ArchDesign.md`、`README_UserStories.md`、`README_UserGuide.md`、`README_DetailDesign.md`、`README_VerifyDesign.md`。

可以用下面的命令验证安装器：

```bash
bash scripts/test_installCaTDD4Copilot.sh
```

## 可移植性契约

斜杠命令不应依赖某一个编辑器、某一个模型提供方或某一种编程语言。

- 方法真理源：`methodPrompts`
- 命令形态：小型、可触发、可参数化，并被组织成流程的提示词单元
- 预期消费方：人类开发者、GUI/聊天助手，以及 `utCodeAgentCLI`
- 稳定性规则：当命令与 `methodPrompts` 冲突时，先更新 `methodPrompts`，再重新生成或修订命令。

## 模板契约

所有具体斜杠命令都应遵循 [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md)。

该模板使用 5W1H 结构和普通 Markdown，使命令文本可被 Copilot、Cline、Continue、`utCodeAgentCLI` 以及类似助手复用。

## 优先级契约

斜杠命令流程优先级与 `methodPrompts` 中定义的 CaTDD Class 优先级使用同一套 Pn 编号，并从 `P0` 开始。

- **P0 = FuncTestsFlow**：功能测试流程，用于 Typical、Edge、Misuse、Fault 骨架。它就是 CaTDD `P0 Functional`。
- **P1 = DesignTestsFlow**：设计测试流程，用于 State、Capability、Concurrency 骨架。它就是 CaTDD `P1 Design`。
- **P2 = QualityTestsFlow**：质量测试流程，用于 Performance、Robust、Compatibility、Configuration 骨架。它就是 CaTDD `P2 Quality`。

未来的 Addons/Demo 命令应使用 `P3 Addons`，以保持与 `methodPrompts` 一致。

## 开发者入口

当开发者处于以下起点时，可以使用斜杠命令：

- 已有 demo tests，希望转换为 CaTDD 功能测试骨架。
- 已有 interface 或 protocol，希望在实现前设计 Typical 骨架。
- 已有 Typical、Edge、Misuse、Fault 或后续分类骨架，希望选择并实现下一个测试用例。

## 流程地图

| Flow | Purpose | Start here |
| --- | --- | --- |
| Px SpecFlow | 从项目上下文和 work item 驱动 SpecCoding，直到故事完成审查与提交 | [flows/Px-SpecFlow.md](flows/Px-SpecFlow.md) |
| P0 FuncTestsFlow | 转换或设计功能测试骨架，然后逐个 TC 实现 | [flows/P0-FuncTestsFlow.md](flows/P0-FuncTestsFlow.md) |
| P1 DesignTestsFlow | 在稳定功能覆盖基础上扩展 State、Capability、Concurrency | [flows/P1-DesignTestsFlow.md](flows/P1-DesignTestsFlow.md) |
| P2 QualityTestsFlow | 在稳定行为基础上扩展 Performance、Robust、Compatibility、Configuration | [flows/P2-QualityTestsFlow.md](flows/P2-QualityTestsFlow.md) |

## 命令地图

| Developer need | Command template |
| --- | --- |
| 创建或修订可移植的 UT 斜杠命令 | [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md) |
| 驱动完整 SpecCoding 生命周期 | [commands/Px-SpecFlow/README.md](commands/Px-SpecFlow/README.md) |
| 将 demo tests 转换为 CaTDD Typical 骨架 | [commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md](commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md) |
| 基于 interface/protocol 设计 Typical、Edge、Misuse 或 Fault 骨架 | [commands/P0-FuncTestsFlow/UT_designCatSkeleton.md](commands/P0-FuncTestsFlow/UT_designCatSkeleton.md) |
| 实现前审查功能测试骨架集合 | [commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md](commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md) |
| 从已有骨架中选择下一个测试用例 | [commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md](commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md) |
| 实现已选择的测试用例 | [commands/P0-FuncTestsFlow/UT_implTestCase.md](commands/P0-FuncTestsFlow/UT_implTestCase.md) |
| 审查已实现的测试用例 | [commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md](commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md) |

## 典型内容

- `flows/` 下的流程文档
- 共享命令模板 [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md)
- `commands/` 下的命令提示词模板
- 参数化调用示例
- 防止与 `methodPrompts` 冲突的兼容性说明

## 上游 / 下游

- 上游输入：`methodPrompts`（方法定义）
- 下游消费方：
  - `utCodeAgentCLI`（调用命令的智能体流水线）
  - 使用助手 GUI/聊天模式的开发者
  - 任意兼容的代码助手，例如 Copilot、Cline、Continue 或类似工具

## 维护规则

当某个方法步骤高频且稳定后，将其抽取到本目录形成标准斜杠命令。
