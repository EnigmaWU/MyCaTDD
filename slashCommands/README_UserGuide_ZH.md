# Slash Commands 用户指南

面向使用 `slashCommands/` 将 CaTDD 运行为可重复 SpecCoding 工作流的开发者与 CodeAgent 的实践指南。

关于这一层 WHAT 是什么、WHY 为什么存在，请阅读 [README.md](README.md)。本指南聚焦 HOW 如何使用、WHO 谁使用、WHEN 何时使用，以及 WHERE 资产位于哪里。

## 使用者

如果你属于以下角色，请使用本指南：

- 想通过可触发 prompt command 运行 CaTDD，而不是反复编写长聊天提示词的开发者。
- 需要可移植命令文件和清晰下一步流程顺序的 CodeAgent。
- 将 CaTDD 安装到 Copilot、Continue 或 Cline 目标项目的维护者。
- 为其他 assistant 或 CLI 包装可移植 CaTDD 命令的工具作者。

## 内容

`slashCommands/` 将稳定的 CaTDD 方法步骤转化为小型命令文件和有序流程。

方法真理源仍然是 `methodPrompts/`。斜杠命令层只说明如何调用可重复步骤、每一步读什么、产出什么、必须保留什么，以及下一步是什么。

## 使用时机

在以下情况使用 `slashCommands/`：

- 想使用结构化 SpecCoding，而不是自由对话式 VibeCoding。
- 某个 CaTDD 方法步骤已经足够稳定，可以成为可重复命令。
- 想让 Copilot、Continue、Cline 或其他助手暴露同一份可移植命令意图。
- 正在转换 demo tests、设计骨架、审查骨架、选择下一个 TC、实现 TC 或审查实现。
- 正在运行 Px SpecFlow 生命周期，从项目上下文和 work item 推进到完成审查的 story。

如果仍在探索方法含义，或只是手工草拟一次性设计想法，请直接使用 `methodPrompts/`。

## 位置

在本源仓库中，可移植命令资产位于：

```text
slashCommands/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
  UT_slashCommandTemplate.md
  flows/
  commands/
```

在安装后的目标项目中，共享 CaTDD 资产位于 `.catdd/`：

```text
.catdd/
  methodPrompts/
  slashCommands/
  spec/
```

原生适配输出位于各工具自己的位置：

```text
.github/prompts/UT_*.prompt.md
.github/prompts/SPEC_*.prompt.md
.continue/rules/catdd.md
.continue/prompts/UT_*.prompt
.continue/prompts/SPEC_*.prompt
.clinerules/catdd.md
```

## 原因

命令层可以减少重复提示词成本，并保持 CodeAgent 执行一致，同时避免把 CaTDD 方法定义复制进每个工具适配器。

它也保护方法边界：`methodPrompts` 负责 CaTDD 含义，`slashCommands` 负责流程执行，原生包装保持轻量且可重新生成。

## 方法

使用 `slashCommands/` 时，按以下流程执行。

1. 阅读 [README.md](README.md)，理解 WHAT/WHY 层契约。
2. 从下面的流程地图中选择一个流程。
3. 阅读流程文档，理解命令顺序和预期交接。
4. 如果在目标项目使用，先用对应 CodeAgent 的安装脚本安装 CaTDD。
5. 触发生成的原生 prompt 包装，或把可移植命令文件粘贴给助手。
6. 让每条命令只更新它在当前步骤负责的产物。
7. 保留 US/AC/TC 注释、分类标签、优先级关卡和 TC 状态标记。
8. 按当前命令或流程文档指定的下一条命令继续。

## Usage Example

在 MyCaTDD 仓库根目录运行以下命令，将 slash-command 资产安装到一个临时 Copilot 风格目标项目：

```bash
TARGET_DIR="$(mktemp -d)"
scripts/installCaTDD4Copilot.sh --target "$TARGET_DIR" --clean-prompts
test -f "$TARGET_DIR/.catdd/slashCommands/README_UserGuide.md"
test -f "$TARGET_DIR/.github/prompts/UT_convertDemoToTypical.prompt.md"
echo "$TARGET_DIR"
```

预期结果：

- `.catdd/slashCommands/` 包含可移植命令源。
- `.catdd/methodPrompts/` 包含方法真理源。
- `.github/prompts/` 包含从可移植命令生成的 Copilot 原生薄包装。
- 输出的临时路径可用于检查，确认后可删除。

## 原生适配生成

从可移植 `SPEC_*` 与 `UT_*` 命令文件生成 Copilot 原生包装：

```bash
scripts/makeSlashCmd4Copilot.sh --clean
```

验证 Copilot 生成器：

```bash
bash scripts/test_makeSlashCmd4Copilot.sh
```

安装或刷新 CaTDD 到另一个已启用 Copilot 的项目：

```bash
scripts/installCaTDD4Copilot.sh --target /path/to/project --clean-prompts
```

生成 Continue 原生包装：

```bash
scripts/makeSlashCmd4Continue.sh --clean
```

安装或刷新 CaTDD 到 Continue 或 Cline 项目：

```bash
scripts/installCaTDD4Continue.sh --target /path/to/project
scripts/installCaTDD4Cline.sh --target /path/to/project
```

验证安装器和生成器行为：

```bash
bash scripts/test_installCaTDD4Copilot.sh
bash scripts/test_makeSlashCmd4Continue.sh
bash scripts/test_installCaTDD4Continue.sh
bash scripts/test_installCaTDD4Cline.sh
```

## SpecCoding 产物策略

在目标项目中使用 SpecCoding 时，生命周期状态放在 `.catdd/spec/` 下，共享的 `README*` SPEC 文档放在项目根目录。

应提交团队共享产物，例如：

- `.catdd/spec/projectContext.md`
- `.catdd/spec/pendingNews/`
- `.catdd/spec/analyzedNews/`
- `.catdd/spec/todoUS/`
- `.catdd/spec/doingUS/`
- `.catdd/spec/abortUS/`
- `.catdd/spec/doneUS/`
- 项目根目录 `README*` 文档，例如 `README_UserGuide.md`、`README_UserStories.md`、`README_DetailDesign.md`、`README_VerifyDesign.md`

保持本地过程追踪产物被 gitignore，尤其是：

- `.catdd/spec/WorkingProcessLog.md`

安装器会维护这些本地产物的 `.gitignore` 规则。

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
| 告诉我当前 SpecCoding 下一步该做什么 | [commands/Px-SpecFlow/SPEC_whatsNextTask.md](commands/Px-SpecFlow/SPEC_whatsNextTask.md) |
| 为已打开的 user story 规划下一条 SPEC 步骤 | [commands/Px-SpecFlow/SPEC_makePlan.md](commands/Px-SpecFlow/SPEC_makePlan.md) |
| 澄清开发者与 CodeAgent 的 story intent | [commands/Px-SpecFlow/SPEC_clearStoryIntent.md](commands/Px-SpecFlow/SPEC_clearStoryIntent.md) |
| 中止不宜继续的 active user story，保留给后续分析或下一轮改进 | [commands/Px-SpecFlow/SPEC_abortUserStory.md](commands/Px-SpecFlow/SPEC_abortUserStory.md) |
| 导入已有结构化 User Story 或 AC 切片 | [commands/Px-SpecFlow/SPEC_importUserStory.md](commands/Px-SpecFlow/SPEC_importUserStory.md) |
| 将 demo tests 转换为 CaTDD Typical 骨架 | [commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md](commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md) |
| 基于 interface/protocol 设计 Typical 骨架 | [commands/P0-FuncTestsFlow/UT_designTypicalSkeleton.md](commands/P0-FuncTestsFlow/UT_designTypicalSkeleton.md) |
| 基于 interface/protocol 和有效边界设计 Edge 骨架 | [commands/P0-FuncTestsFlow/UT_designEdgeSkeleton.md](commands/P0-FuncTestsFlow/UT_designEdgeSkeleton.md) |
| 基于无效调用者行为设计 Misuse 骨架 | [commands/P0-FuncTestsFlow/UT_designMisuseSkeleton.md](commands/P0-FuncTestsFlow/UT_designMisuseSkeleton.md) |
| 基于故障行为设计 Fault 骨架 | [commands/P0-FuncTestsFlow/UT_designFaultSkeleton.md](commands/P0-FuncTestsFlow/UT_designFaultSkeleton.md) |
| 设计完整 P0 Functional 骨架集合 | [commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md](commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md) |
| 实现前审查功能测试骨架集合 | [commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md](commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md) |
| 从已有骨架中选择下一个测试用例 | [commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md](commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md) |
| 实现已选择的测试用例 | [commands/P0-FuncTestsFlow/UT_implTestCase.md](commands/P0-FuncTestsFlow/UT_implTestCase.md) |
| 审查已实现的测试用例 | [commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md](commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md) |

## 质量检查清单

在声明斜杠命令变更完成之前，检查：

- 可移植命令文件仍指向 `methodPrompts` 作为方法真理源。
- 生成的原生包装保持轻量且可重新生成。
- 流程顺序清楚命名下一条命令。
- 命令保留 US/AC/TC 可追溯性和 TC 状态标记。
- P0/P1/P2 命名与 `methodPrompts` 保持一致。
- 共享 SpecCoding 产物与本地进行中状态分离。

## 下一步

理解方法含义时，回到 `methodPrompts/README_UserGuide.md` 和 `methodPrompts/CaTDD_methodPrompt.md`。

执行流程时，从流程地图中选择一个流程，然后运行对应原生包装或可移植命令文件。
