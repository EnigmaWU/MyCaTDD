# utCodeAgentCLI 用户指南

面向设计未来 CaTDD-native CLI 执行层的开发者与 CodeAgent 的实践指南。

关于这一层 WHAT 是什么、WHY 为什么存在，请阅读 [README.md](README.md)。本指南聚焦 HOW 现在如何使用这一层、WHO 谁使用、WHEN 何时在这里工作，以及 WHERE 未来资产应位于哪里。

## 使用者

如果你属于以下角色，请使用本指南：

- 设计未来 CaTDD-native CLI agent 的维护者。
- 捕获重复规划、执行、轨迹或反思模式的开发者。
- 帮助把稳定工作流转化为未来 CLI 行为的 CodeAgent。
- 判断哪些内容属于 `utCodeAgentCLI` 而不是 `methodPrompts`、`slashCommands` 或 `agentSkill` 的工具作者。

## 内容

`utCodeAgentCLI/` 当前是未来 CLI 执行层的设计归属地。

它尚未包含可运行的 CLI 实现。今天使用本目录时，应记录未来应成为一等 CLI 行为的稳定执行模式。

未来 CLI 行为应组合：

- 来自 `methodPrompts/` 的方法约束。
- 来自 `slashCommands/` 的可移植命令步骤。
- 来自 `agentSkill/` 的打包能力。
- 由 `utCodeAgentCLI/` 负责的目标驱动规划、执行、轨迹收集和反思。

## 使用时机

在以下情况在 `utCodeAgentCLI/` 中工作：

- 某个工作流不只是 prompt command，而需要目标驱动编排。
- 某个重复模式横跨规划、执行、验证和反思。
- 需要保留执行轨迹，用于方法改进。
- 某个未来 CLI 功能需要协调多个 `slashCommands` 步骤。
- 某个行为应成为 CaTDD-native 自动化，而不是通用 CodeAgent 适配器。

如果行为是稳定的单条命令或流程步骤，请使用 `slashCommands/`。如果行为是面向另一个 agent runtime 的打包能力，请使用 `agentSkill/`。

## 位置

当前目录结构：

```text
utCodeAgentCLI/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
```

推荐的未来目录结构：

```text
utCodeAgentCLI/
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

CLI 层应成为 CaTDD 从方法文本、提示词命令或技能包走向 native execution loop 的位置。

先记录这一层再实现，可以让未来 CLI 保持诚实：它应编排已有 CaTDD 资产，而不是重新定义方法或绕过命令流程契约。

## 方法

今天塑造 `utCodeAgentCLI/` 时，按以下流程执行。

1. 从一个重复出现的 CaTDD 工作模式开始。
2. 识别哪些部分已经由 `methodPrompts/`、`slashCommands/` 或 `agentSkill/` 覆盖。
3. 这里只记录缺失的 CLI 编排职责。
4. 捕获预期输入、输出、轨迹数据和反思行为。
5. 将产品或方法不确定性明确写成问题。
6. 模式稳定后，判断它应成为 CLI 功能、斜杠命令，还是技能包。
7. 当文档契约变为可执行约束时，更新测试。

## Usage Example

在仓库根目录运行以下命令，在不修改源码树的情况下创建一个临时 CLI 设计记录：

```bash
WORK_DIR="$(mktemp -d)"
cat > "$WORK_DIR/utCodeAgentCLI-first-loop.md" <<'EOF'
# utCodeAgentCLI Design Note

Goal: Capture a future CLI loop that plans one CaTDD test task, executes one command step, records trace evidence, and reflects on whether the method or command layer needs improvement.

Inputs:
- methodPrompts/README_UserGuide.md
- slashCommands/README_UserGuide.md
- agentSkill/README_UserGuide.md

Expected output:
- A proposed CLI responsibility that does not redefine CaTDD method semantics.
- A list of trace fields to preserve.
- Open questions before implementation.
EOF

test -s "$WORK_DIR/utCodeAgentCLI-first-loop.md"
echo "$WORK_DIR"
```

预期结果：

- `test` 命令成功退出。
- 输出的临时路径包含一个未来 CLI loop 的设计记录。
- 仓库文件不会被修改。

## Future CLI Responsibility Map

| Responsibility | Belongs here when |
| --- | --- |
| Goal intake | CLI 需要在选择方法或命令步骤之前结构化任务目标。 |
| Planning | CLI 必须选择并编排多个 CaTDD 步骤。 |
| Execution policy | CLI 必须决定何时运行、停止、询问或继续。 |
| Trace collection | CLI 必须保留用于审查和改进的证据。 |
| Reflection | CLI 必须在执行后识别可复用模式或方法缺口。 |
| Feedback routing | CLI 必须判断改进应进入 `methodPrompts`、`slashCommands` 还是 `agentSkill`。 |

## 边界检查清单

添加未来 CLI 产物之前，检查：

- 这是否超过单个可移植命令？如果不是，使用 `slashCommands/`。
- 这是否只是方法含义？如果是，使用 `methodPrompts/`。
- 这是否只是 package metadata 或 reusable skill behavior？如果是，使用 `agentSkill/`。
- 是否保持 US/AC/TC 可追溯性和 CaTDD 状态纪律？
- 是否记录 CLI 应收集哪些证据？
- 是否把不清楚的产品或方法意图保留为明确问题？

## 质量检查清单

在声明 CLI 层设计变更完成之前，检查：

- README/UserGuide 文档分工保持清晰。
- 在实现存在之前，不声明已有可运行 CLI 行为。
- 未来路径明确标注为 future 或 recommended layout。
- 设计引用上游层，而不是重复它们。
- 文档契约测试和 README 镜像检查通过。

## 下一步

理解方法含义时，阅读 `methodPrompts/README_UserGuide.md`。

执行命令流程时，阅读 `slashCommands/README_UserGuide.md`。

使用可复用技能时，阅读 `agentSkill/README_UserGuide.md`。

在本层，只捕获其他层不应负责的未来 CLI 编排职责。
