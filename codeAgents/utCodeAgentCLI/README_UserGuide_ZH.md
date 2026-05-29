# utCodeAgentCLI 用户指南

面向使用或设计未来 CaTDD-native CLI 执行层的开发者与 CodeAgent 的首要启动指南。

请先从这里开始。本指南提供从用户意图到清晰 `utCodeAgentCLI` invocation plan 的最短实践路径。日常使用时它应自包含；只有需要 WHAT/WHY 背景时才打开 [README.md](README.md)，只有需要完整详细参数契约时才打开 [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md)。

## Start Here

当你要使用、模拟、审查或设计一个 `utCodeAgentCLI` workflow 时，把本指南作为第一份文档。

1. 说清楚希望 CLI 完成什么；这就是 `--goal`。
2. 当本次运行要设计新的 US/AC/TC skeletons 时，用 `--goalStory` 或 `--goalStoryFile` 添加 User Story。
3. 当行为需要 source context 时，用 `--input` 或 `--inputFile` 中的恰好一个选择 source material。
4. 只把 `--target` 选择为 test-space scope：one TestCase in one TestFile、one TestFile 或 some TestFiles。
5. 从下方 behavior table 中选择 `--behave`。
6. 写出 invocation plan，然后检查是否缺少必填值。

## Command Shape

每个 planned invocation 都使用这个形状：

```text
utCodeAgentCLI [OPTIONS] --goal <STRING> --target <TEST_SCOPE> --behave <BEHAVIOR>
```

多数 design runs 还会提供 source context 和 User Story：

```text
utCodeAgentCLI \
  --goal "design P0 functional skeletons for the auth interface" \
  --goalStory "As an API consumer I want typed auth errors so that I can handle failures reliably" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp \
  --behave designFuncTestsSkeleton
```

本仓库当前记录的是未来 CLI contract；还没有提供可运行的 `utCodeAgentCLI` binary。在 CLI 实现存在之前，把这里的示例视为 invocation plans。

## Argument Cheat Sheet

| Argument | Meaning | Use it when | Example |
| --- | --- | --- | --- |
| `--goal` | 用户想要的结果 | 每次运行 | `"design P0 functional skeletons for auth"` |
| `--goalStory` | goal 背后的内联 User Story | story 较短，且 skeletons 需要 `@[US]` traceability | `"As a user I want to reset my password..."` |
| `--goalStoryFile` | 来自文件的 User Story | story 较长或需要复用 | `stories/auth-us.md` |
| `--input` | 内联 source/context | source 足够短，适合命令行 | `AuthService` |
| `--inputFile` | 来自文件的 source/context | source 是 interface、schema、protocol、draft 或 production source file | `src/auth/AuthService.h` |
| `--target` | test-space destination 或 scope | 每次运行 | `tests/auth_api_test.cpp` |
| `--behave` | 应用到 target 的 behavior | 每次运行 | `designFuncTestsSkeleton` |

不要同时提供 `--goalStory` 和 `--goalStoryFile`。不要同时提供 `--input` 和 `--inputFile`。

## Target Forms

| Target form | Meaning | Good for |
| --- | --- | --- |
| `tests/auth_test.cpp::TC-03` | 一个 TestFile 中的一个 TestCase | `implTestCase` |
| `tests/auth_test.cpp` | 一个 TestFile | skeleton design、review、full-file implementation |
| `tests/auth_test.cpp,tests/payment_test.cpp` | 多个 TestFiles | 对多个 test files 应用同一 behavior |

最重要的规则：`--target` 永远是 test-space scope。interface files、protocol files、source files、schemas 和 drafts 应放在 `--input` 或 `--inputFile`，不要放在 `--target`。

## 使用者

如果你属于以下角色，请使用本指南：

- 正在判断应使用哪些 `utCodeAgentCLI` 参数的开发者。
- 为 CaTDD test workflow 准备 invocation plan 的 CodeAgent。
- 设计未来 CaTDD-native CLI agent 的维护者。
- 捕获重复规划、执行、轨迹或反思模式的开发者。
- 判断哪些内容属于 `utCodeAgentCLI` 而不是 `methodPrompts` 或 `slashCommands`，以及它与 `agentSkills` 打包路径有何区别的工具作者。

## 内容

`codeAgents/utCodeAgentCLI/` 当前是未来 CLI 执行层的启动与设计归属地。

它尚未包含可运行的 CLI 实现。今天使用本指南时，应形成清晰 invocation plans，并记录未来应成为一等 CLI 行为的稳定执行模式。

本 UserGuide 已包含日常 planning 所需的启动契约：command shape、argument meaning、target forms、behavior selection 和 common recipes。把 [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md) 作为 parser grammar、selector details 和完整错误处理的正式 reference。

未来 CLI 行为应组合：

- 来自 `methodPrompts/` 的方法约束。
- 来自 `slashCommands/` 的可移植命令步骤。
- 由 `codeAgents/utCodeAgentCLI/` 负责的目标驱动规划、执行、轨迹收集和反思。

`agentSkills/` 是给 GitHub Copilot 等通用 CodeAgent 使用 CaTDD 的独立打包路径。`utCodeAgentCLI` 不应依赖它。

## 使用时机

在以下情况使用本指南：

- 你正在判断如何把任务表达为 `--goal`、`--input`/`--inputFile`、`--target` 和 `--behave`。
- 你需要在 `designFuncTestsSkeleton`、`designAllSkeleton`、直接 `UT_*` commands 和 implementation behaviors 之间选择。
- 你需要一个不依赖完整 UsageDesign reference 的快速路径。

在以下情况在 `codeAgents/utCodeAgentCLI/` 中工作：

- 某个工作流不只是 prompt command，而需要目标驱动编排。
- 某个重复模式横跨规划、执行、验证和反思。
- 需要保留执行轨迹，用于方法改进。
- 某个未来 CLI 功能需要协调多个 `slashCommands` 步骤。
- 某个行为应成为 CaTDD-native 自动化，而不是通用 CodeAgent 适配器。

如果行为是稳定的单条命令或流程步骤，请使用 `slashCommands/`。如果行为只是通用 CodeAgent 打包，请使用 `agentSkills/`，并把它保持在 CLI 依赖路径之外。

## 位置

当前目录结构：

```text
codeAgents/utCodeAgentCLI/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
  README_UsageDesign.md
  README_UsageDesign_ZH.md
```

推荐的未来目录结构：

```text
codeAgents/utCodeAgentCLI/
  prompts/
  goals/
  checklists/
  traces/
  reflections/
  src/
  tests/
```

不要把生成的运行输出作为源码加入本目录。这里应保留可重复设计资产、模板和实现文件；本地运行日志或临时执行输出不应提交，除非它们成为明确的示例。

## 原因

CLI 层应成为 CaTDD 从方法文本或提示词命令走向 native execution loop 的位置。

先记录这一层再实现，可以让未来 CLI 保持诚实：它应编排已有 CaTDD 资产，而不是重新定义方法或绕过命令流程契约。

## 方法

今天塑造 `codeAgents/utCodeAgentCLI/` 时，按以下流程执行。

1. 从用户意图开始，并把它写成 `--goal`。
2. 识别 source context；当行为需要 target 测试产物之外的材料时，在 `--input` 与 `--inputFile` 中恰好选择一个。
3. 只把 `--target` 选择为 test-space scope：one TestCase in one TestFile、one TestFile 或 some TestFiles。
4. 从稳定 alias 或兼容的 portable `UT_*` slash command 中选择 `--behave`。
5. 使用本指南中的 cheat sheets 和 `IF: What You Want` series 确认必填参数与常见组合。
6. 如果目标行为是单个可复用命令，先更新 `slashCommands/`；本目录只聚焦 CLI 编排。
7. 如果目标行为需要编排多条命令、记录 trace data，或决定何时停止/询问/继续，在这里记录缺失的 CLI 职责。
8. 将产品或方法不确定性明确写成 open questions。
9. 当文档契约变为可执行约束时，更新测试。

## Instruction Path

当用户从一个 CaTDD 需求出发，并想形成 `utCodeAgentCLI` plan 时，按以下路径执行：

1. 先留在本 UserGuide 中选择实践路径和可能的 `--behave`。
2. 只有在 strict parser syntax、selector details 或完整错误规则很重要时，才打开 [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md)。
3. 只有在需要检查某个 `UT_*` behavior 背后的 portable command contract 时，才打开 `slashCommands/README_UserGuide_ZH.md`。
4. 只有在需要 method meaning 时，才打开 `methodPrompts/README_UserGuide_ZH.md`；不要在这里重新定义 category semantics。
5. 只有在需要层级 WHAT/WHY 背景时，才打开 [README.md](README.md)。
6. 编写或更新最小的 CLI-layer 说明，用于解释 orchestration、trace、reflection 或 policy。

## Behavior Selection Guide

behavior names 使用的 category shorthand：P0 Functional 表示 Typical、Edge、Misuse、Fault；P1 Design 表示 State、Capability、Concurrency；P2 Quality 表示 Performance、Robust、Compatibility、Configuration。

| User wants to | Prefer `--behave` | Typical `--target` | Notes |
| --- | --- | --- | --- |
| 设计一个 P0 functional category | `designTypicalSkeleton`、`designEdgeSkeleton`、`designMisuseSkeleton` 或 `designFaultSkeleton` | one TestFile | 显式 P0 commands 的稳定 aliases。 |
| 设计所有 P0 functional categories | `designFuncTestsSkeleton` 或 `UT_designFuncTestsSkeleton` | one TestFile 或 some TestFiles | 只覆盖 Typical、Edge、Misuse、Fault。 |
| 设计所有 P0/P1/P2 categories | `designAllSkeleton` | one TestFile 或 some TestFiles | 覆盖 functional、design、quality skeleton categories。 |
| 审查 functional skeletons | `reviewFuncTestsSkeleton` 或 `UT_reviewFuncTestsSkeleton` | one TestFile 或 some TestFiles | 稳定 alias 或直接 portable slash command。 |
| 选择下一个要实现的 TC | `tellMeNextImplTest` 或 `UT_tellMeNextImplTest` | one TestFile | 稳定 alias 或直接 portable slash command。 |
| 实现一个 TC | `implTestCase` 或 `UT_implTestCase` | one TestCase in one TestFile | 为选中的 TC 添加可执行测试代码。 |
| 实现整个 TestFile | `implTestFile` | one TestFile | CLI 重复执行单 TC 实现步骤。 |

当调用者需要某个具体 portable command 时，使用直接 `UT_*` command names。当调用者需要 CLI-friendly behavior names，并且这些名称未来可能展开为一条或多条 portable commands 时，使用稳定 aliases。

## IF: What You Want

当你知道用户意图，但不确定应该选择哪些参数时，使用这一组场景。每个 case 都从普通用户需求开始，并转换成 invocation-plan block。

### IF: You Want P0 Functional Skeletons

当你要为一个 TestFile 设计 Typical、Edge、Misuse、Fault skeletons 时，使用这个场景。

```text
--goal "design P0 functional skeletons for the auth interface"
--goalStoryFile stories/auth-login.md
--inputFile src/auth/AuthService.h
--target tests/auth_api_test.cpp
--behave designFuncTestsSkeleton
```

### IF: You Want One P0 Category

当 target 只需要一个聚焦 category，例如 Edge、Typical、Misuse 或 Fault 时，使用这个场景。

```text
--goal "design edge-case skeletons for auth failures"
--goalStoryFile stories/auth-login.md
--inputFile src/auth/AuthService.h
--target tests/auth_api_test.cpp
--behave designEdgeSkeleton
```

### IF: You Want All P0/P1/P2 Skeletons

当 TestFile 需要覆盖 functional、design、quality categories 的完整 CaTDD skeleton coverage 时，使用这个场景。

```text
--goal "design complete CaTDD skeleton coverage for the auth interface"
--goalStoryFile stories/auth-login.md
--inputFile src/auth/AuthService.h
--target tests/auth_api_test.cpp
--behave designAllSkeleton
```

### IF: You Want To Review Skeletons

当 skeletons 已存在，并且你想在 implementation 之前检查 coverage 与 traceability 时，使用这个场景。

```text
--goal "review P0 functional skeleton coverage before implementation"
--target tests/auth_api_test.cpp
--behave reviewFuncTestsSkeleton
```

### IF: You Want The Next TC

当一个 TestFile 有多个 skeleton TCs，并且需要 CLI 识别下一个 implementation target 时，使用这个场景。

```text
--goal "pick the next auth test case to implement"
--target tests/auth_api_test.cpp
--behave tellMeNextImplTest
```

### IF: You Want To Implement One TC

当 target TestCase 已经选定时，使用这个场景。

```text
--goal "implement the selected auth error test case"
--inputFile src/auth/AuthService.h
--target tests/auth_api_test.cpp::TC-03
--behave implTestCase
```

### IF: You Want To Implement A Whole TestFile

当 CLI 应对一个 TestFile 中每个 ready TC 重复执行 single-TC implementation 时，使用这个场景。

```text
--goal "implement all ready auth API test cases"
--inputFile src/auth/AuthService.h
--target tests/auth_api_test.cpp
--behave implTestFile
```

## Usage Example

在仓库根目录运行以下命令，在不修改源码树的情况下创建一个临时 invocation plan：

```bash
WORK_DIR="$(mktemp -d)"
cat > "$WORK_DIR/utCodeAgentCLI-invocation-plan.md" <<'EOF'
# utCodeAgentCLI Invocation Plan

Goal: design the full P0 Functional skeleton set for the auth interface.

Inputs:
- --goal "design P0 functional skeletons for the auth interface"
- --goalStory "As an API consumer I want typed auth errors so that I can handle failures reliably"
- --inputFile src/auth/AuthService.h
- --target tests/auth_api_test.cpp
- --behave designFuncTestsSkeleton

Expected output:
- Typical, Edge, Misuse, and Fault skeletons are planned for the target TestFile.
- No executable implementation test code is planned.
- Any missing source or story context is listed as an open question.
EOF

test -s "$WORK_DIR/utCodeAgentCLI-invocation-plan.md"
echo "$WORK_DIR"
```

预期结果：

- `test` 命令成功退出。
- 输出的临时路径包含一个带有 `--goal`、`--goalStory`、`--inputFile`、`--target` 和 `--behave` 的 invocation plan。
- 仓库文件不会被修改。

## Future CLI Responsibility Map

| Responsibility | Belongs here when |
| --- | --- |
| Goal intake | CLI 需要在选择方法或命令步骤之前结构化任务目标。 |
| Planning | CLI 必须选择并编排多个 CaTDD 步骤。 |
| Execution policy | CLI 必须决定何时运行、停止、询问或继续。 |
| Trace collection | CLI 必须保留用于审查和改进的证据。 |
| Reflection | CLI 必须在执行后识别可复用模式或方法缺口。 |
| Feedback routing | CLI 必须判断改进应进入 `methodPrompts` 还是 `slashCommands`。 |

## 边界检查清单

添加未来 CLI 产物之前，检查：

- 这是否超过单个可移植命令？如果不是，使用 `slashCommands/`。
- 这是否只是方法含义？如果是，使用 `methodPrompts/`。
- 这是否只是 package metadata 或通用 CodeAgent skill behavior？如果是，把它放在 `agentSkills/`，并保持在 CLI 依赖路径之外。
- 是否保持 US/AC/TC 可追溯性和 CaTDD 状态纪律？
- 是否记录 CLI 应收集哪些证据？
- 是否把不清楚的产品或方法意图保留为明确问题？

## 质量检查清单

在声明 CLI 层设计变更完成之前，检查：

- README/UserGuide 文档分工保持清晰。
- 在实现存在之前，不声明已有可运行 CLI 行为。
- 未来路径明确标注为 future 或 recommended layout。
- 设计引用上游层，而不是重复它们。
- `--target` 保持为 test-space scope，而不是 source input。
- `--behave` 命名兼容的 UT slash-command behavior 或稳定 CLI alias。
- 文档契约测试和 README 镜像检查通过。

## 下一步

理解方法含义时，阅读 `methodPrompts/README_UserGuide.md`。

执行命令流程时，阅读 `slashCommands/README_UserGuide.md`。

处理通用 CodeAgent 技能打包时，阅读 `agentSkills/README_UserGuide.md`；不要把它作为 CLI 依赖。

在本层，只捕获其他层不应负责的未来 CLI 编排职责。
