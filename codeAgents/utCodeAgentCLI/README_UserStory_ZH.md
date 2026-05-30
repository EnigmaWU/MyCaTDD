# utCodeAgentCLI 需求规格

utCodeAgentCLI 是 CaTDD-native CLI，将自然语言目标、源代码和 User Story 转化为可追溯的测试工件。其核心承诺：**设计 → 审查 → 实现 CaTDD 测试用例，从 story 到 skeleton 到可执行代码，全程可追溯，且永不重新定义 CaTDD 方法语义。**

三种角色驱动本文档中的所有需求：

| 角色 | 关注点 |
| --- | --- |
| **USER** | "我有源代码和一个测试需求。给我可追溯的测试工件。" |
| **INVENTOR** | "我定义了 CaTDD。CLI 必须编排我的方法 —— 绝不破坏、内联或绕过它。" |
| **DEVELOPER** | "我构建、测试和扩展 CLI。我需要清晰的契约、诊断能力和 adapter 边界。" |

本文档是 `utCodeAgentCLI` 的**单一权威需求来源**。下游产物 —— [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md)、[README_UserGuide_ZH.md](README_UserGuide_ZH.md)、架构文档、测试计划 —— 必须追溯回此处定义的需求。

> **实现状态**：`utCodeAgentCLI` 尚无可运行的 binary。所有需求描述的是预期的 CLI 行为。[UsageDesign](README_UsageDesign_ZH.md) 定义了满足这些需求的 CLI 接口契约。[UserGuide](README_UserGuide_ZH.md) 记录了满足这些需求的 invocation plan 模式。

---

## 能力全景图

```
USER:  "为我的 auth 服务设计 Typical 和 Edge 测试覆盖。"
  │
  ├─(1)─► CLI 解析并验证：--goal, --goalStory, --inputFile, --target, --behave
  │         REQ-CLI-U01
  │
  ├─(2)─► CLI 委托 methodPrompts 获取 category 语义
  │         REQ-CLI-I01
  │
  ├─(3)─► CLI 将 US/AC/TC skeleton 设计写入目标 test file
  │         REQ-CLI-U02
  │         输出：tests/auth_api_test.cpp ← @[US], @[AC-01], @[TC-01]...@[TC-08]
  │
  ├─(4)─► CLI 审查 skeleton 质量
  │         REQ-CLI-U03
  │         输出："共 8 个 TC。3 Typical, 2 Edge, 2 Misuse, 1 Fault。全部 PLANNED。"
  │
  ├─(5)─► CLI 选择下一个要实现的 TC
  │         REQ-CLI-U04
  │         输出："TC-04 | Edge | empty-password-boundary"
  │
  ├─(6)─► CLI 实现 TC-04 —— 写入可执行的 RED 测试代码
  │         REQ-CLI-U05
  │         输出：TC-04 现在包含可编译的测试体，@[Status:RED]
  │
  └─(7)─► Trace 文件记录一切：invocation、resolution、output、status
            REQ-CLI-I02
```

---

## 需求索引

| ID | P | 角色 | 标题 | 依赖 |
| --- | --- | --- | --- | --- |
| REQ-CLI-U01 | P0 | USER | 解析并验证 CLI 参数 | — |
| REQ-CLI-U02 | P0 | USER | 设计 CaTDD 测试 skeleton | U01, I01 |
| REQ-CLI-U03 | P0 | USER | 审查 skeleton 完整性 | U02 |
| REQ-CLI-U04 | P0 | USER | 选择下一个要实现的测试用例 | U02 |
| REQ-CLI-U05 | P0 | USER | 实现一个可执行测试用例（RED） | U01, I01 |
| REQ-CLI-U06 | P1 | USER | 实现文件中所有测试用例 | U05 |
| REQ-CLI-U07 | P1 | USER | 批量 skeleton 设计（多文件） | U02 |
| REQ-CLI-U08 | P1 | USER | 一步完成设计与实现 | U02, U05 |
| REQ-CLI-I01 | P0 | INVENTOR | 将所有 CaTDD 语义委托给 methodPrompts | — |
| REQ-CLI-I02 | P0 | INVENTOR | 生成机器可读的执行 trace | U01 |
| REQ-CLI-I03 | P1 | INVENTOR | 方法解析过程的可诊断可见性 | U01 |
| REQ-CLI-D01 | P0 | DEVELOPER | 所有失败状态都有可操作的错误信息 | U01 |
| REQ-CLI-D02 | P1 | DEVELOPER | 可配置的日志与诊断输出 | U01 |
| REQ-CLI-D03 | P1 | DEVELOPER | 交互式逐命令确认 | U01 |
| REQ-CLI-D04 | P2 | DEVELOPER | 运行时 adapter 接口 | — |

### 优先级定义

| 优先级 | 含义 |
| --- | --- |
| **P0 关键** | v0.1 不能没有此需求。CLI 无此能力即无存在意义。 |
| **P1 重要** | v1.0 需要此需求才能构成完整的端到端 CaTDD 工作流。 |
| **P2 有价值** | v1.x+ 扩展能力，不改变核心设计。 |

---

## USER 需求

### REQ-CLI-U01 [P0] — 解析并验证 CLI 参数

**作为** USER，**我希望** CLI 立即验证我的调用参数，**以便** 参数错误时得到清晰、可操作的反馈，而非静默异常。

#### Scenario: 缺少必选参数时报错退出

- **Given** CLI 调用缺少 `--goal`
- **When** 参数解析执行
- **Then** 退出码为 1
- **And** stderr 包含字符串 `"--goal"`
- **And** stderr 说明 `--goal` 的用途以及为什么必须提供

`--target` 和 `--behave` 同理。

#### Scenario: 互斥参数被拒绝

- **Given** CLI 同时指定了 `--goalStory "..."` 和 `--goalStoryFile "..."`，或同时指定 `--input "..."` 和 `--inputFile "..."`
- **When** 参数解析执行
- **Then** 退出码为 1
- **And** stderr 指明两个冲突参数并说明它们不能同时使用

#### Scenario: 无法识别的 --behave 值列出有效选项

- **Given** CLI 指定了 `--behave "nonexistent"`
- **When** behavior 解析执行
- **Then** 退出码为 1
- **And** stderr 列出所有有效的 `--behave` 值

#### Scenario: 文件路径参数指向不存在的文件

- **Given** CLI 的 `--inputFile`、`--goalStoryFile`、`--reference`、`--extra-prompt` 或 `--config-file` 指向不存在的路径
- **When** 参数验证执行
- **Then** 退出码为 1
- **And** stderr 指明缺失的路径

#### Scenario: 有效调用正常继续执行

- **Given** 所有必选参数齐全、互斥对未违反、文件路径全部存在
- **When** 参数解析完成
- **Then** 退出码为 0
- **And** 执行继续进入 `--behave` 指定的行为

---

### REQ-CLI-U02 [P0] — 设计 CaTDD 测试 skeleton

**作为** USER，**我希望** CLI 根据我的源代码和 User Story 将 US/AC/TC skeleton 生成到测试文件中，**以便** 在编写任何可执行测试代码之前就拥有一个结构化、可追溯的测试计划。

#### Scenario: P0 Functional skeleton 设计写入全部四个 category

- **Given** 有一个 User Story（`--goalStory` 或 `--goalStoryFile`）、一个源代码接口文件（`--inputFile`），以及一个空或不存在目标测试文件（`--target`）
- **When** CLI 以 `--behave designFuncTestsSkeleton` 运行
- **Then** 目标测试文件被创建或更新
- **And** 文件包含 `@[US]` 注释，其内容与提供的 User Story 一致
- **And** 文件包含从 story 派生出的 `@[AC-*]` 验收标准注释
- **And** 文件包含 Typical、Edge、Misuse 和 Fault 类别的 `@[TC-*]` 测试用例 skeleton 注释
- **And** 每个 TC skeleton 包含 `@[Category:<name>]` 和 `@[Status:PLANNED]`
- **And** 不写入任何可执行测试代码 —— 仅写入注释 skeleton

#### Scenario: 单 category skeleton 设计

- **Given** 有一个源文件和一个 story
- **When** CLI 以 `--behave designEdgeSkeleton` 运行
- **Then** 目标文件仅包含 Edge 类别的 TC skeleton
- **And** 不存在 Typical、Misuse 或 Fault 的 skeleton

#### Scenario: 不带 User Story 的 skeleton 设计会接受但给出警告

- **Given** 有源文件但没有 `--goalStory` 或 `--goalStoryFile`
- **When** CLI 以 skeleton 设计行为运行
- **Then** skeleton 正常生成
- **And** `@[US]` 注释包含一个自动生成的占位符，说明未提供 story
- **And** stderr 发出警告，提示可追溯性不完整

---

### REQ-CLI-U03 [P0] — 审查 skeleton 完整性

**作为** USER，**我希望** CLI 在实现前审计已有的 skeleton 文件，**以便** 在写代码前发现覆盖缺口和可追溯性断裂。

#### Scenario: 审查输出数值化的 skeleton 状态

- **Given** 一个包含 CaTDD skeleton TC 的测试文件 —— 部分 PLANNED，部分 IMPLEMENTED，部分缺少 category 标签
- **When** CLI 以 `--behave reviewFuncTestsSkeleton` 针对该文件运行
- **Then** stdout 包含：
  - TC 总数量
  - 各 category 数量（Typical、Edge、Misuse、Fault）
  - 各 status 数量（PLANNED、RED、GREEN）
  - 缺少 `@[Category]` 或 `@[Status]` 标签的 TC-ID 列表
- **And** 不修改任何文件

#### Scenario: 对不含 skeleton 的文件进行审查时报告为空

- **Given** 一个没有 CaTDD skeleton 注释的测试文件
- **When** review 被调用
- **Then** stdout 报告："0 个 CaTDD skeleton TC 已找到"
- **And** 退出码为 0（不是错误 —— 文件有效，只是为空）

---

### REQ-CLI-U04 [P0] — 选择下一个要实现的测试用例

**作为** USER，**我希望** CLI 精确告诉我下一个要实现哪个 TC，**以便** 遵循 TDD 纪律，无需手动扫描文件或猜测优先级。

#### Scenario: 下一个 TC 是首个未实现的 P0 TC

- **Given** 测试文件包含 TC-01（Typical, PLANNED）、TC-02（Typical, PLANNED）、TC-03（Edge, PLANNED）
- **When** CLI 以 `--behave tellMeNextImplTest` 运行
- **Then** stdout 精确输出一个 TC-ID：`TC-01`（首个 PLANNED，P0 优先于 P1/P2）
- **And** stdout 包含该 TC 的 category
- **And** 不修改任何文件

#### Scenario: 部分 TC 已实现时

- **Given** 测试文件包含 TC-01（RED）、TC-02（PLANNED）、TC-03（PLANNED）
- **When** `tellMeNextImplTest` 被调用
- **Then** stdout 选择 `TC-02`（首个未实现）
- **And** 已 RED 的 TC 被跳过

#### Scenario: 所有 TC 均已实现时

- **Given** 测试文件中每个 TC 都标记为 `@[Status:RED]` 或 `@[Status:GREEN]`
- **When** `tellMeNextImplTest` 被调用
- **Then** stdout 报告："所有 TC 均已实现。无需选择。"
- **And** 退出码为 0

---

### REQ-CLI-U05 [P0] — 实现一个可执行测试用例（RED）

**作为** USER，**我希望** CLI 将一个 skeleton TC 转化为可编译的测试代码，**以便** 我能以可执行测试（而非仅注释）进入 TDD 的 RED 阶段。

#### Scenario: Skeleton TC 变为可执行 RED 测试

- **Given** 测试文件中 TC-04 包含 `@[TC-04]` skeleton 注释，标记 `@[Status:PLANNED]` 和 `@[Category:Edge]`，且有源文件提供实现上下文（`--inputFile`）
- **When** CLI 以 `--behave implTestCase --target tests/auth_test.cpp::TC-04` 运行
- **Then** TC-04 的注释 skeleton 被保留（所有 `@[US]`、`@[AC]`、`@[TC]`、`@[Category]` 标签保持不变）
- **And** TC-04 skeleton 注释下方添加可执行测试函数体
- **And** `@[Status:PLANNED]` 替换为 `@[Status:RED]`
- **And** 文件中其他 TC 不被修改

#### Scenario: 已实现的 TC 不被覆盖

- **Given** TC-04 已标记 `@[Status:RED]` 或 `@[Status:GREEN]`
- **When** `implTestCase` 再次针对 TC-04
- **Then** 退出码为 1
- **And** stderr 报告："TC-04 已经实现。请先使用 review 行为，或重新设计 skeleton。"
- **And** 文件不被修改

#### Scenario: Target 选择器未解析为单个 TC

- **Given** `--target tests/auth_test.cpp`（整个文件，非特定 TC）
- **When** `--behave implTestCase` 被调用
- **Then** 退出码为 1
- **And** stderr 报告 `--target` / `--behave` 不匹配，并建议有效组合

---

### REQ-CLI-U06 [P1] — 实现文件中所有测试用例

**作为** USER，**我希望** CLI 一次调用实现文件中所有 PLANNED 的 TC，**以便** 无需逐个调用 `implTestCase`。

#### Scenario: 所有 PLANNED TC 变为 RED

- **Given** 测试文件包含 TC-01（PLANNED）、TC-02（PLANNED）、TC-03（RED）—— TC-03 已实现
- **When** CLI 以 `--behave implTestFile --target tests/auth_test.cpp` 运行
- **Then** TC-01 和 TC-02 获得可执行测试代码并标记为 RED
- **And** TC-03 被跳过（已 RED）
- **And** stdout 报告："2 个 TC 已实现，1 个已跳过（已实现），0 个失败"
- **And** 所有 `@[US]`/`@[AC]`/`@[TC]` 注释被保留

#### Scenario: 中途某 TC 实现失败

- **Given** TC-02 的实现遇到无法解决的错误（如源上下文不足）
- **When** `implTestFile` 处理 TC-02
- **Then** TC-02 保持不变（仍为 PLANNED）
- **And** CLI 继续处理下一个 TC（TC-03）
- **And** stdout 将 TC-02 报告为失败并附失败原因
- **And** 最终摘要区分已实现、已跳过和已失败的数量

---

### REQ-CLI-U07 [P1] — 批量 skeleton 设计（多文件）

**作为** USER，**我希望** 从一个源文件和一个 User Story 将 skeleton 设计进多个测试文件，**以便** 一次完成多模块测试覆盖准备。

#### Scenario: 多个目标文件各获得 skeleton

- **Given** `--target tests/auth_api_test.cpp,tests/auth_error_test.cpp` 和共享的 `--inputFile` 及 `--goalStoryFile`
- **When** CLI 以 `--behave designAllSkeleton` 运行
- **Then** `tests/auth_api_test.cpp` 和 `tests/auth_error_test.cpp` 均被创建或更新
- **And** 每个文件包含从共享 story 和源文件派生出的 US/AC/TC skeleton
- **And** stdout 报告每个文件的结果

---

### REQ-CLI-U08 [P1] — 一步完成设计与实现

**作为** USER，**我希望** CLI 一次调用完成全部 skeleton 设计并立即实现它们，**以便** 无需中间步骤即可从零到 RED 测试代码。

#### Scenario: 设计所有 category 然后实现所有 TC

- **Given** 一个源文件、一个 User Story 和一个空的目标测试文件
- **When** CLI 以 `--behave designAndImplTest` 运行
- **Then** 目标文件首先获得所有适用 P0/P1/P2 category 的 US/AC/TC skeleton
- **And** 然后每个生成的 TC 获得可执行测试代码
- **And** 所有 TC 标记为 `@[Status:RED]`
- **And** trace 文件记录两阶段执行（design → implement）

---

## INVENTOR 需求

### REQ-CLI-I01 [P0] — 将所有 CaTDD 语义委托给 methodPrompts

**作为** INVENTOR，**我希望** CLI 不拥有任何 CaTDD 方法知识，**以便** 我可以演进 category、discipline 规则和 prompt 契约，而无需触碰或重新发布 CLI。

#### Scenario: Category 定义绝不硬编码在 CLI 中

- **Given** CLI 需要生成一个 Edge 类别的 TC skeleton
- **When** 它解析 Edge category 的含义
- **Then** 它从 `methodPrompts/` 下的文件读取 —— 绝不从 CLI 源码中的硬编码字符串、枚举或模板读取
- **And** 如果所需的 methodPrompt 文件缺失或不可读，CLI 退出并报错，指明缺失的文件

#### Scenario: Slash-command 行为委托给 slashCommands

- **Given** CLI 解析 `--behave designFuncTestsSkeleton`
- **When** 它执行该行为
- **Then** 它调用 `slashCommands/commands/` 下对应的可移植命令
- **And** 不内联或复制该命令的逻辑

#### Scenario: 输出中所有 CaTDD 工件均由委托层生成

- **Given** 任何会修改测试文件的 CLI 调用
- **When** 输出中出现 CaTDD 特定内容（`@[US]`、`@[AC]`、`@[TC]`、`@[Category]`、`@[Status]`）
- **Then** 该内容由 methodPrompt 或 slashCommand 生成 —— 绝不由 CLI 自身从硬编码字符串或模板生成

---

### REQ-CLI-I02 [P0] — 生成机器可读的执行 trace

**作为** INVENTOR，**我希望** 每次 CLI 运行留下结构化 trace，**以便** 我可以审计方法合规性、重放调用、检测意图与执行结果之间的偏差。

#### Scenario: 成功执行时写入 trace

- **Given** 一个有效的 CLI 调用成功完成
- **When** CLI 退出
- **Then** 在可发现位置存在 trace 工件
- **And** trace 包含：时间戳、完整调用字符串、解析后的参数、解析后的 slash 命令（含文件路径）、已修改的文件、受影响的 TC-ID 及其前后 status、退出码和执行时长

#### Scenario: 执行失败时也写入 trace

- **Given** 一个有效的 CLI 调用在执行期间（非参数解析期间）失败
- **When** CLI 以退出码 1 退出
- **Then** trace 工件依然存在
- **And** 它记录失败点：哪个 step 正在执行、错误信息、以及失败前已完成哪些 step

#### Scenario: Trace 格式可被机器解析

- **Given** CLI 写入的任何 trace 工件
- **When** 被标准 JSON 或 YAML 解析器解析
- **Then** 解析成功，所有字段符合文档化的 schema

---

### REQ-CLI-I03 [P1] — 方法解析过程的可诊断可见性

**作为** INVENTOR，**我希望** `--diagMethodPrompts` 和 `--diagSlashCommands` 能揭示 CLI 解析了哪些具体 prompt 和命令，**以便** 我可以验证 CLI 没有替换、跳过或绕过任何 CaTDD 资产。

#### Scenario: --diagMethodPrompts 记录已解析的 prompt

- **Given** 任意带 `--diagMethodPrompts` 的有效 CLI 调用
- **When** CLI 在执行期间解析 method prompt
- **Then** stderr（或诊断日志流）列出每个已解析的 prompt 文件路径及对应的 CaTDD category 或规则

#### Scenario: --diagSlashCommands 记录已解析的命令

- **Given** 带 `--behave designFuncTestsSkeleton` 和 `--diagSlashCommands` 的调用
- **When** CLI 将 behavior 解析为一个或多个 slash command
- **Then** 诊断输出按解析顺序列出每个 slash command 名称和文件路径

---

## DEVELOPER 需求

### REQ-CLI-D01 [P0] — 所有失败状态都有可操作的错误信息

**作为** DEVELOPER，**我希望** 每条错误信息都指明问题、标识受影响的参数并建议纠正方法，**以便** 无需阅读 CLI 源码即可调试调用问题。

#### Scenario: 无法识别的参数值给出纠正建议

- **Given** CLI 调用使用 `--behave "deisgnAllSkeleton"`（拼写错误）
- **When** 验证失败
- **Then** stderr 包含 `"deisgnAllSkeleton"` 未被识别
- **And** stderr 包含建议：`"您是否想输入 'designAllSkeleton'？"`（最佳匹配）
- **And** stderr 包含完整有效值列表

#### Scenario: 文件缺失错误包含精确路径

- **Given** `--inputFile nonexistent/path.h`
- **When** 验证失败
- **Then** stderr 包含完整解析路径 `nonexistent/path.h`
- **And** stderr 指明参数名称（`--inputFile`）

#### Scenario: Target/behavior 不匹配时解释原因并建议替代方案

- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** 验证检测到不匹配
- **Then** stderr 解释：skeleton 设计需要文件级 `--target`，而非 TC 级 target
- **And** stderr 建议 skeleton 设计有效的 `--target` 形式，或 TC 级 target 有效的 `--behave` 值

---

### REQ-CLI-D02 [P1] — 可配置的日志与诊断输出

**作为** DEVELOPER，**我希望** `--log-level` 控制输出详细程度，**以便** 生产环境静默运行，调试时详细输出。

#### Scenario: --log-level error 抑制非错误输出

- **Given** 任意带 `--log-level error` 的有效调用
- **When** CLI 成功执行
- **Then** stderr 仅出现 error 级别消息
- **And** stdout 不受影响（行为输出仍然正常）

#### Scenario: --log-level debug 揭示内部分辨过程

- **Given** 任意带 `--log-level debug` 的有效调用
- **When** CLI 执行
- **Then** stderr 包含状态转换：参数解析、behavior 解析、slash-command 选择、文件写入

---

### REQ-CLI-D03 [P1] — 交互式逐命令确认

**作为** DEVELOPER，**我希望** 在每个 slash command 执行前预览它，**以便** 可以在多 step 调用中批准、跳过或中止，避免盲执行。

#### Scenario: 每个 slash command 执行前提示确认

- **Given** 带 `--interactive-slash-commands` 的 `designAndImplTest` 调用
- **When** CLI 解析出一个 slash command（如 `UT_designFuncTestsSkeleton`）
- **Then** stdout 提示："在 tests/auth_api_test.cpp 上执行 UT_designFuncTestsSkeleton？[y/n/s(kip)/a(bort)]"
- **And** CLI 等待用户输入后才继续

#### Scenario: 中止停止所有后续执行

- **Given** 一个交互式会话有多个待执行 slash command
- **When** 用户在任意提示输入 "a"（中止）
- **Then** 不再执行任何后续 slash command
- **And** CLI 以退出码 1 退出
- **And** trace 记录哪些命令被跳过

---

### REQ-CLI-D04 [P2] — 运行时 adapter 接口

**作为** DEVELOPER，**我希望** CLI 的 slash-command 执行后端可通过文档化的 adapter 接口替换，**以便** `utCodeAgentCLI` 可在 Copilot-native、OpenCode 或自定义 agent runtime 上运行，无需重写 CLI 核心。

#### Scenario: Adapter 符合定义的接口

- **Given** 一个实现了 `CliRuntimeAdapter` 接口的 runtime adapter
- **When** CLI 需要调用 slash command
- **Then** 它调用 adapter 的 `invoke(slashCommand, context)` 方法
- **And** adapter 接收已解析的命令路径、target、source 和 goal 上下文
- **And** CLI 不假定任何特定 runtime（TypeScript、Python、shell）

#### Scenario: 提供默认 adapter

- **Given** 未配置自定义 adapter
- **When** CLI 运行
- **Then** 内置默认 adapter 直接执行 slash command

---

## 需求依赖图

```
REQ-CLI-U01（解析与验证）
  │
  ├──► REQ-CLI-D01（错误信息）── 适用于 U01 中的所有验证
  ├──► REQ-CLI-D02（日志）
  ├──► REQ-CLI-D03（交互式）
  ├──► REQ-CLI-I02（执行 trace）── 依赖 U01 的已解析参数
  │
  ├──► REQ-CLI-U02（设计 skeleton）── 需要 REQ-CLI-I01（委托语义）
  │       │
  │       ├──► REQ-CLI-U03（审查）── 依赖 U02 输出
  │       ├──► REQ-CLI-U04（选择下一个）── 依赖 U02 输出
  │       └──► REQ-CLI-U07（批量设计）── 按文件复用 U02
  │
  ├──► REQ-CLI-U05（实现一个 TC）── 需要 REQ-CLI-I01
  │       │
  │       └──► REQ-CLI-U06（实现所有）── 循环 U05
  │
  └──► REQ-CLI-U08（设计+实现）── 串联 U02 → U05/U06

REQ-CLI-I01（委托语义）── 被以下所需：U02, U05, U08
REQ-CLI-I03（诊断可见性）── 横切关注点，依赖 U01

REQ-CLI-D04（adapter 接口）── P2，独立于所有其他需求
```

---

## 非需求

以下能力明确**超出** `utCodeAgentCLI` 的范围。这些能力归属于其他层级，或有意排除：

| 能力 | 归属 |
| --- | --- |
| 定义 CaTDD category、discipline 规则或方法含义 | `methodPrompts/` |
| 定义可移植 slash-command 执行逻辑 | `slashCommands/` |
| 将 CaTDD 封装为通用 CodeAgent skill | `agentSkills/` |
| 编译、运行或验证测试代码 | 用户的构建系统 |
| 生成产品/源代码 | 不在范围 —— CLI 仅生成测试代码 |
| 管理 git 分支、提交或版本控制 | 用户的工作流 |
| 解析或验证用户源代码语言 | 委托给 slash command；CLI 仅验证自身参数 |

---

## 可追溯性

| 工件 | 与这些需求的关系 |
| --- | --- |
| [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md) | 定义满足 REQ-CLI-U01、U02、U05 的 CLI 参数契约。定义 `--behave` alias、`--target` 形式和 REQ-CLI-D01 的错误处理。 |
| [README_UserGuide_ZH.md](README_UserGuide_ZH.md) | 记录满足所有 USER 需求的 invocation plan 工作流。Behavior Selection Guide 将用户意图映射到 REQ-CLI-U02–U08。 |
| [README_ZH.md](README_ZH.md) | 定义 CLI 层是什么以及为何存在 —— 所有需求的架构上下文。 |
| `methodPrompts/` | 提供 REQ-CLI-I01 所需的 category 语义。每个 USER 设计/实现需求都依赖此层。 |
| `slashCommands/` | 提供 REQ-CLI-I01 所需的可移植命令执行。每个 `--behave` 值都解析为此层中的资产。 |
| [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md) | 发起这些需求的原始请求。 |
| 旧 story set（US-CLI-01 至 US-CLI-06，现已退役） | US-CLI-01/02/04 → 并入 USER 需求。US-CLI-03 → 并入 U01（behavior 验证）。US-CLI-05 → 成为 I01。US-CLI-06 → 成为 D04。 |

---

## 开放问题

- Trace 文件的输出目录和命名规范是什么？是否应由用户通过 `--trace-dir` 控制？
- `--log-level` 是否应支持低于 `debug` 的 `trace` 级别用于原始 prompt/response 日志？
- 对于 REQ-CLI-D04（adapter），首个 adapter 应以哪个 runtime 为目标：raw TypeScript CLI、Copilot-native 还是 OpenCode-compatible？
- `--target` 是否应接受 target-list 文件（`--target-file`）作为逗号分隔内联路径的替代方案？
- `--interactive-slash-commands` 是否应支持超时以用于无人值守的 CI 运行？

---

## 维护规则

当新的用户需求无法追溯至任何现有 REQ-CLI-* ID 时，新增一个需求。每个需求必须至少包含一个可验证的验收 Scenario。

**不要**将架构决策或详细实现行为放在此文档中 —— 这些应归属 `README_ArchDesign.md` 和 `README_DetailDesign.md`。

本文档是需求大纲。下游文档实现它 —— 它们不驱动它。
