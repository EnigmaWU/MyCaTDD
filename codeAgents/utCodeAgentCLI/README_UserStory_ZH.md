# utCodeAgentCLI 需求规格

utCodeAgentCLI 是 CaTDD-native CLI，将自然语言目标、源代码和 User Story 转化为可追溯的测试工件。其核心承诺：**设计 → 审查 → 实现 CaTDD 测试用例，从 story 到 skeleton 到可执行代码，全程可追溯，且永不重新定义 CaTDD 方法语义。**

三个利益相关角色驱动本文档中的所有需求。USER 有两个子角色，形成不同的需求路径：

| 角色 | 子角色 | 关注点 |
| --- | --- | --- |
| **USER** | | |
| | **NEW-USER** | "我不知道 CaTDD 的 category 体系或 TDD 纪律。不要让我从 Typical 和 Edge 中选择，或猜测下一个该实现哪个 TC —— 要向我展示我的代码需要什么覆盖结构，解释我 skeleton 中的缺口，并一步步引导我前进。" |
| | **EXPERIENCED-USER** | "我了解这套方法。让我精确调用：仅设计一个特定 category，直接实现一个具体 TC-ID，跨多个文件串联操作。给我错误信息，而非手把手指导。我也负责审查团队覆盖率和 CI 运行 —— 给我可解析的输出和清晰的退出码。" |
| **INVENTOR** | | "我定义了 CaTDD。CLI 必须编排我的方法 —— 绝不破坏、内联或绕过它。" |
| **DEVELOPER** | | "我构建、测试和扩展 CLI。我需要清晰的契约、诊断能力和 adapter 边界。" |

本文档是 `utCodeAgentCLI` 的**单一权威需求来源**。下游产物 —— [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md)、[README_UserGuide_ZH.md](README_UserGuide_ZH.md)、架构文档、测试计划 —— 必须追溯回此处定义的需求。

### ID 表示法

验收标准 ID 遵循完整格式 `US-{ROLE}-{NN}-AC-{MM}`（例如 `US-USER-03-AC-02`）。在每个需求分节内，AC 标题使用简短形式 `AC-{MM}` —— 外围的 `### US-{ROLE}-{NN}` 标题已提供限定。AC 汇总表记录完整 ID 以便平面交叉引用。

> **实现状态**：`utCodeAgentCLI` 尚无可运行的 binary。所有需求描述的是预期的 CLI 行为。[UsageDesign](README_UsageDesign_ZH.md) 定义了满足这些需求的 CLI 接口契约。[UserGuide](README_UserGuide_ZH.md) 记录了满足这些需求的 invocation plan 模式。

---

## 能力全景图

三种调用路径覆盖所有 CaTDD 工作流：

```
快速路径（一步从零到 RED）：
  USER intent
    └─► designAndImplTest → RED test file，含完整 skeleton + 可执行代码
        US-USER-08

迭代路径（受审查把关的实现）：
  USER intent
    ├─► design*Skeleton → PLANNED test file                    US-USER-02
    ├─► review → 覆盖率报告                                     US-USER-03
    ├─► tellMeNextImplTest → "下一个是 TC-04"                  US-USER-04
    ├─► implTestCase → TC-04 变为 RED                           US-USER-05
    └─► ...重复 pick→impl 直至所有 TC 变为 RED...               US-USER-04, US-USER-05

批量路径（多文件 / 多 TC）：
  USER intent
    ├─► designAllSkeleton → 跨 N 个文件的 skeleton               US-USER-02, US-USER-07
    └─► implTestFile → 所有 PLANNED TC 变为 RED                  US-USER-06
         （按 CaTDD 优先级顺序：P0→P1→P2, P0 内 Typical→Edge→Misuse→Fault）
```

所有路径都生成机器可读的 trace（US-INVENTOR-02）并验证 CaTDD 方法委托（US-INVENTOR-01）。

---

## 测试文件状态模型

CLI 跨调用保持 CaTDD 状态。每个 `--behave` 都操作已知状态的测试文件并产生可预测的状态变迁。

### TC 状态生命周期

```
@[Status:PLANNED]  ──(implTestCase)──►  @[Status:RED]  ──(用户修复产品代码)──►  @[Status:GREEN]
```

CLI 负责 `PLANNED → RED` 的变迁。`RED → GREEN` 的变迁是用户行为（编译、修复产品代码、通过测试）—— CLI 从已有文件中读取 GREEN 状态，但永不写入它。

### 文件级状态

| 状态 | 描述 |
| --- | --- |
| **EMPTY** | 文件中不存在 CaTDD skeleton TC。 |
| **DESIGNED** | 文件包含 skeleton；所有 TC 均为 `@[Status:PLANNED]`。 |
| **PARTIAL** | PLANNED、RED 与 GREEN TC 混合。这是迭代实现过程中的正常工作状态。 |
| **FULLY_RED** | 所有 TC 均为 `@[Status:RED]` 或 `@[Status:GREEN]`。无剩余 PLANNED TC。 |
| **ALL_GREEN** | 所有 TC 均为 `@[Status:GREEN]`。 |

### 行为状态契约

| `--behave` | 要求文件状态 | 产生 TC 状态 | 产生文件状态 |
| --- | --- | --- | --- |
| `design*Skeleton` | 任意 | 所有新 TC → PLANNED | DESIGNED 或 PARTIAL |
| `reviewFuncTestsSkeleton` | DESIGNED, PARTIAL 或 FULLY_RED | 不变 | 不变 |
| `reviewDesignTestsSkeleton` | DESIGNED 或 PARTIAL | 不变 | 不变 |
| `reviewQualityTestsSkeleton` | DESIGNED 或 PARTIAL | 不变 | 不变 |
| `reviewImplTestCase` | 目标 TC 为 RED 或 GREEN | 不变 | 不变 |
| `tellMeNextImplTest` | 存在 ≥1 个 PLANNED TC | 不变 | 不变 |
| `implTestCase` | 目标 TC 为 PLANNED | 目标 TC → RED | PARTIAL 或 FULLY_RED |
| `implTestFile` | 存在 ≥1 个 PLANNED TC | 所有 PLANNED → RED | FULLY_RED |
| `designAndImplTest` | 任意 | 所有 TC → RED | FULLY_RED |

### 状态保持保证

1. CLI 绝不降级状态：RED 的 TC 绝不会被设回 PLANNED。
2. CLI 绝不覆盖已实现的 TC，除非有明显意图。
3. 需要特定状态的行为若文件不处于该状态，则报清晰错误退出。
4. 每次状态变迁均记录在执行 trace 中（US-INVENTOR-02）。

---

## 需求索引

| ID | P | 角色 | 子角色 | 标题 | AC 范围 | 依赖 |
| --- | --- | --- | --- | --- | --- | --- |
| US-USER-01 | P0 | USER | Both | 解析并验证 CLI 参数 | AC-01..05 | — |
| US-USER-02 | P0 | USER | Both | 设计 CaTDD 测试 skeleton | AC-01..03 | US-USER-01, US-INVENTOR-01 |
| US-USER-03 | P0 | USER | Both | 审查设计 skeleton（所有层级） | AC-01..04 | US-USER-02 |
| US-USER-04 | P0 | USER | NEW-USER | 选择下一个要实现的测试用例 | AC-01..03 | US-USER-02 |
| US-USER-05 | P0 | USER | EXPERIENCED-USER | 实现一个可执行测试用例（RED） | AC-01..04 | US-USER-01, US-INVENTOR-01 |
| US-USER-06 | P1 | USER | EXPERIENCED-USER | 实现文件中所有测试用例 | AC-01..02 | US-USER-05 |
| US-USER-07 | P1 | USER | EXPERIENCED-USER | 批量 skeleton 设计（多文件） | AC-01 | US-USER-02 |
| US-USER-08 | P1 | USER | NEW-USER | 一步完成设计与实现 | AC-01 | US-USER-02, US-USER-05 |
| US-USER-09 | P0 | USER | EXPERIENCED-USER | 审查已实现的测试用例 | AC-01..03 | US-USER-05 |
| US-USER-10 | P0 | USER | EXPERIENCED-USER | 审查文件中所有已实现的测试用例 | AC-01..02 | US-USER-06 |
| US-INVENTOR-01 | P0 | INVENTOR | | 将所有 CaTDD 语义委托给 methodPrompts | AC-01..03 | — |
| US-INVENTOR-02 | P0 | INVENTOR | | 生成机器可读的执行 trace | AC-01..03 | US-USER-01 |
| US-INVENTOR-03 | P1 | INVENTOR | | 方法解析过程的可诊断可见性 | AC-01..02 | US-USER-01 |
| US-DEV-01 | P0 | DEVELOPER | | 所有失败状态都有可操作的错误信息 | AC-01..03 | US-USER-01 |
| US-DEV-02 | P1 | DEVELOPER | | 可配置的日志与诊断输出 | AC-01..02 | US-USER-01 |
| US-DEV-03 | P1 | DEVELOPER | | 交互式逐命令确认 | AC-01..02 | US-USER-01 |
| US-DEV-04 | P2 | DEVELOPER | | 运行时 adapter 接口 | AC-01..02 | — |

### 优先级定义

| 优先级 | 含义 |
| --- | --- |
| **P0 关键** | v0.1 不能没有此需求。CLI 无此能力即无存在意义。 |
| **P1 重要** | v1.0 需要此需求才能构成完整的端到端 CaTDD 工作流。 |
| **P2 有价值** | v1.x+ 扩展能力，不改变核心设计。 |

### USER 子角色路径

```
NEW-USER 路径（引导式发现）：
  U01（验证）→ U02（designAllSkeleton）→ U03（审查所有层级）
  → U04（选择下一个）→ U08（designAndImplTest，从零到 RED）

EXPERIENCED-USER 路径（精确控制）：
  U01（验证）→ U02（单 category 设计）→ U03（按层级审查）
  → U05（实现一个 TC）→ U09（审查实现）→ U04（选择下一个）
  → U06（实现所有）→ U10（审查所有实现）/ U07（批量多文件）
```

---

## USER 需求

### US-USER-01 [P0] — 解析并验证 CLI 参数

**作为** USER，**我希望** CLI 立即验证我的调用参数，**以便** 参数错误时得到清晰、可操作的反馈，而非静默异常。

#### AC-01: 缺少必选参数时报错退出

- **Given** CLI 调用缺少 `--goal`
- **When** 参数解析执行
- **Then** 退出码为 1
- **And** stderr 包含字符串 `"--goal"`
- **And** stderr 说明 `--goal` 的用途以及为什么必须提供

`--target` 和 `--behave` 同理。

#### AC-02: 互斥参数被拒绝

- **Given** CLI 同时指定了 `--goalStory "..."` 和 `--goalStoryFile "..."`，或同时指定 `--input "..."` 和 `--inputFile "..."`
- **When** 参数解析执行
- **Then** 退出码为 1
- **And** stderr 指明两个冲突参数并说明它们不能同时使用

#### AC-03: 无法识别的 --behave 值列出有效选项

- **Given** CLI 指定了 `--behave "nonexistent"`
- **When** behavior 解析执行
- **Then** 退出码为 1
- **And** stderr 列出所有有效的 `--behave` 值

#### AC-04: 文件路径参数指向不存在的文件

- **Given** CLI 的 `--inputFile`、`--goalStoryFile`、`--reference`、`--extra-prompt` 或 `--config-file` 指向不存在的路径
- **When** 参数验证执行
- **Then** 退出码为 1
- **And** stderr 指明缺失的路径

#### AC-05: 有效调用正常继续执行

- **Given** 所有必选参数齐全、互斥对未违反、文件路径全部存在
- **When** 参数解析完成
- **Then** 退出码为 0
- **And** 执行继续进入 `--behave` 指定的行为

---

### US-USER-02 [P0] — 设计 CaTDD 测试 skeleton

**作为** USER，**我希望** CLI 根据我的源代码和 User Story 将 US/AC/TC skeleton 生成到测试文件中，**以便** 在编写任何可执行测试代码之前就拥有一个结构化、可追溯的测试计划。

#### AC-01: P0 Functional skeleton 设计写入全部四个 category

- **Given** 有一个 User Story（`--goalStory` 或 `--goalStoryFile`）、一个源代码接口文件（`--inputFile`），以及一个空或不存在目标测试文件（`--target`）
- **When** CLI 以 `--behave designFuncTestsSkeleton` 运行
- **Then** 目标测试文件被创建或更新（EMPTY 或 DESIGNED → DESIGNED）
- **And** 文件包含 `@[US]` 注释，其内容与提供的 User Story 一致
- **And** 文件包含从 story 派生出的 `@[AC-*]` 验收标准注释
- **And** 文件包含 Typical、Edge、Misuse 和 Fault 类别的 `@[TC-*]` 测试用例 skeleton 注释
- **And** 每个 TC skeleton 包含 `@[Category:<name>]` 和 `@[Status:PLANNED]`
- **And** 不写入任何可执行测试代码 —— 仅写入注释 skeleton

#### AC-02: 单 category skeleton 设计

- **Given** 有一个源文件和一个 story
- **When** CLI 以 `--behave designEdgeSkeleton` 运行
- **Then** 目标文件仅包含 Edge 类别的 TC skeleton
- **And** 不存在 Typical、Misuse 或 Fault 的 skeleton

#### AC-03: 不带 User Story 的 skeleton 设计会接受但给出警告

- **Given** 有源文件但没有 `--goalStory` 或 `--goalStoryFile`
- **When** CLI 以 skeleton 设计行为运行
- **Then** skeleton 正常生成
- **And** `@[US]` 注释包含一个自动生成的占位符，说明未提供 story
- **And** stderr 发出警告，提示可追溯性不完整

---

### US-USER-03 [P0] — 审查设计 skeleton（所有层级）

**作为** USER，**我希望** CLI 在实现前审计所有 CaTDD 层级（P0 Functional、P1 Design、P2 Quality）的设计 skeleton，**以便** 在每个层级都发现覆盖缺口和可追溯性断裂，而非仅检查 P0。

与以下配对：US-USER-02（设计 skeleton）。每个设计动作必须可审查。

#### AC-01: P0 Functional 审查输出数值化的 skeleton 状态

- **Given** 一个包含 CaTDD skeleton TC 的测试文件 —— 部分 PLANNED，部分 RED，部分 GREEN，部分缺少 category 标签（DESIGNED、PARTIAL 或 FULLY_RED 状态）
- **When** CLI 以 `--behave reviewFuncTestsSkeleton` 针对该文件运行
- **Then** stdout 包含：
  - TC 总数量
  - 各 P0 category 数量（Typical、Edge、Misuse、Fault）
  - 各 status 数量（PLANNED、RED、GREEN）
  - 缺少 `@[Category]` 或 `@[Status]` 标签的 TC-ID 列表
- **And** 不修改任何文件

#### AC-02: 对不含 skeleton 的文件进行审查时报告为空

- **Given** 一个没有 CaTDD skeleton 注释的测试文件（EMPTY 状态）
- **When** review 被调用
- **Then** stdout 报告："0 个 CaTDD skeleton TC 已找到"
- **And** 退出码为 0（不是错误 —— 文件有效，只是为空）

#### AC-03: P1 Design 审查报告 State/Capability/Concurrency 状态

- **Given** 一个包含 P1 design skeleton TC 的测试文件（State、Capability、Concurrency 类别）
- **When** CLI 以 `--behave reviewDesignTestsSkeleton` 运行
- **Then** stdout 包含各 P1 category 和 status 的数量
- **And** 不修改任何文件

#### AC-04: P2 Quality 审查报告 Performance/Robust/Compatibility/Configuration 状态

- **Given** 一个包含 P2 quality skeleton TC 的测试文件（Performance、Robust、Compatibility、Configuration 类别）
- **When** CLI 以 `--behave reviewQualityTestsSkeleton` 运行
- **Then** stdout 包含各 P2 category 和 status 的数量
- **And** 不修改任何文件

---

### US-USER-04 [P0] — 选择下一个要实现的测试用例

**作为** USER，**我希望** CLI 精确告诉我下一个要实现哪个 TC，**以便** 遵循 TDD 纪律，无需手动扫描文件或猜测优先级。

#### AC-01: 下一个 TC 是首个未实现的 P0 TC

- **Given** 测试文件包含 TC-01（Typical, PLANNED）、TC-02（Typical, PLANNED）、TC-03（Edge, PLANNED）
- **When** CLI 以 `--behave tellMeNextImplTest` 运行
- **Then** stdout 精确输出一个 TC-ID：`TC-01`（首个 PLANNED，遵循 CaTDD 优先级：P0 先于 P1 先于 P2，P0 内 Typical → Edge → Misuse → Fault）
- **And** stdout 包含该 TC 的 category
- **And** 不修改任何文件

#### AC-02: 部分 TC 已实现时

- **Given** 测试文件包含 TC-01（RED）、TC-02（PLANNED）、TC-03（PLANNED）
- **When** `tellMeNextImplTest` 被调用
- **Then** stdout 选择 `TC-02`（首个未实现，遵循 CaTDD 优先级顺序）
- **And** 已 RED 和 GREEN 的 TC 被跳过

#### AC-03: 所有 TC 均已实现时

- **Given** 测试文件中每个 TC 都标记为 `@[Status:RED]` 或 `@[Status:GREEN]`（FULLY_RED 或 ALL_GREEN 状态）
- **When** `tellMeNextImplTest` 被调用
- **Then** stdout 报告："所有 TC 均已实现。无需选择。"
- **And** 退出码为 0

---

### US-USER-05 [P0] — 实现一个可执行测试用例（RED）

**作为** USER，**我希望** CLI 将一个 skeleton TC 转化为可编译的测试代码，**以便** 我能以可执行测试（而非仅注释）进入 TDD 的 RED 阶段。

配对审查：US-USER-09（审查已实现的测试用例）。每个实现动作必须可审查。

#### AC-01: Skeleton TC 变为可执行 RED 测试

- **Given** 测试文件中 TC-04 包含 `@[TC-04]` skeleton 注释，标记 `@[Status:PLANNED]`、`@[Category:Edge]`，且 `@[AC]` 追溯链有效，有源文件提供实现上下文（`--inputFile`）
- **When** CLI 以 `--behave implTestCase --target tests/auth_test.cpp::TC-04` 运行
- **Then** TC-04 的注释 skeleton 被保留（所有 `@[US]`、`@[AC]`、`@[TC]`、`@[Category]` 标签保持不变）
- **And** TC-04 skeleton 注释下方添加可执行测试函数体
- **And** `@[Status:PLANNED]` 替换为 `@[Status:RED]`
- **And** 文件中其他 TC 不被修改
- **And** 文件状态变迁：DESIGNED → PARTIAL，或 PARTIAL → PARTIAL/FULLY_RED

#### AC-02: 已实现的 TC 不被覆盖

- **Given** TC-04 已标记 `@[Status:RED]` 或 `@[Status:GREEN]`
- **When** `implTestCase` 再次针对 TC-04
- **Then** 退出码为 1
- **And** stderr 报告："TC-04 已经实现。请先使用 review 行为，或重新设计 skeleton。"
- **And** 文件不被修改（无状态降级）

#### AC-03: Target 选择器未解析为单个 TC

- **Given** `--target tests/auth_test.cpp`（整个文件，非特定 TC）
- **When** `--behave implTestCase` 被调用
- **Then** 退出码为 1
- **And** stderr 报告 `--target` / `--behave` 不匹配，并建议有效组合

#### AC-04: 实现前 skeleton 未通过完整性检查

- **Given** TC-04 有 `@[TC-04]` skeleton 注释，但缺少 `@[Category]`，或 `@[Status]` 值为无法识别的值（非 PLANNED/RED/GREEN）
- **When** `implTestCase` 针对 TC-04
- **Then** CLI 执行 skeleton 完整性预检
- **And** 退出码为 1
- **And** stderr 报告："TC-04 skeleton 完整性检查失败：缺少 @[Category]"（附具体细节）
- **And** 文件不被修改

---

### US-USER-06 [P1] — 实现文件中所有测试用例

**作为** USER，**我希望** CLI 一次调用按 CaTDD 优先级顺序实现文件中所有 PLANNED 的 TC，**以便** 无需逐个调用 `implTestCase`。

配对审查：US-USER-10（审查所有已实现的测试用例）。每个实现动作必须可审查。

#### AC-01: 所有 PLANNED TC 按优先级顺序变为 RED

- **Given** 测试文件包含 TC-01（Edge, PLANNED）、TC-02（Typical, PLANNED）、TC-03（Misuse, PLANNED）、TC-04（RED）—— TC-04 已实现
- **When** CLI 以 `--behave implTestFile --target tests/auth_test.cpp` 运行
- **Then** TC 按 CaTDD 优先级顺序实现，而非文件顺序：
  - P0 先于 P1 先于 P2
  - P0 内：Typical → Edge → Misuse → Fault
  - 同 category 内：按文件顺序
- **And** 本文件的实现顺序为：TC-02（Typical）→ TC-01（Edge）→ TC-03（Misuse）
- **And** TC-04 被跳过（已 RED）
- **And** stdout 报告："3 个 TC 已实现，1 个已跳过（已实现），0 个失败"
- **And** 所有 `@[US]`/`@[AC]`/`@[TC]` 注释被保留
- **And** 每个 TC 仅在通过 skeleton 完整性预检后才从 PLANNED 变为 RED（US-USER-05-AC-04）

#### AC-02: 中途某 TC 实现失败

- **Given** TC-02 的 skeleton 未通过完整性预检，或其实现遇到无法解决的错误
- **When** `implTestFile` 处理 TC-02
- **Then** TC-02 保持不变（仍为 PLANNED）
- **And** CLI 继续按优先级顺序处理下一个 TC
- **And** stdout 将 TC-02 报告为失败并附失败原因
- **And** 最终摘要区分已实现、已跳过和已失败的数量

---

### US-USER-07 [P1] — 批量 skeleton 设计（多文件）

**作为** USER，**我希望** 从一个源文件和一个 User Story 将 skeleton 设计进多个测试文件，**以便** 一次完成多模块测试覆盖准备。

#### AC-01: 多个目标文件各获得 skeleton

- **Given** `--target tests/auth_api_test.cpp,tests/auth_error_test.cpp` 和共享的 `--inputFile` 及 `--goalStoryFile`
- **When** CLI 以 `--behave designAllSkeleton` 运行
- **Then** `tests/auth_api_test.cpp` 和 `tests/auth_error_test.cpp` 均被创建或更新
- **And** 每个文件包含从共享 story 和源文件派生出的 US/AC/TC skeleton
- **And** stdout 报告每个文件的结果

---

### US-USER-08 [P1] — 一步完成设计与实现

**作为** USER，**我希望** CLI 一次调用完成全部 skeleton 设计并立即实现它们，**以便** 无需中间步骤即可从零到 RED 测试代码。

配对审查：US-USER-03（设计 skeleton 审查）和 US-USER-10（实现审查）。即使是组合操作也必须事后可审查。

#### AC-01: 设计所有 category 然后实现所有 TC

- **Given** 一个源文件、一个 User Story，以及一个空或不存在目标测试文件（EMPTY 状态）
- **When** CLI 以 `--behave designAndImplTest` 运行
- **Then** 目标文件首先获得所有适用 P0/P1/P2 category 的 US/AC/TC skeleton（EMPTY → DESIGNED）
- **And** `@[US]` 注释保留提供的 User Story 以保持可追溯性
- **And** 然后每个生成的 TC 按 CaTDD 优先级顺序获得可执行测试代码（DESIGNED → FULLY_RED）
- **And** 所有 TC 标记为 `@[Status:RED]`
- **And** trace 文件记录两阶段执行（design → implement）

---

### US-USER-09 [P0] — 审查已实现的测试用例

**作为** USER，**我希望** CLI 在编写产品代码前审计一个已实现的 RED 测试用例，**以便** 在进入 GREEN 阶段之前验证测试是否正确、是否遵循其 skeleton，以及是否保留了 CaTDD 可追溯性。

与以下配对：US-USER-05（implTestCase）。

#### AC-01: 审查报告实现质量

- **Given** 测试文件中 TC-04 标记为 `@[Status:RED]`，包含可执行测试代码和保留的 skeleton 注释
- **When** CLI 以 `--behave reviewImplTestCase --target tests/auth_test.cpp::TC-04` 运行
- **Then** stdout 包含：
  - `@[Status:RED]` 是否正确设置
  - skeleton 注释（`@[US]`、`@[AC]`、`@[TC]`、`@[Category]`）是否完整保留
  - 测试代码是否遵循 CaTDD 结构
  - 测试代码与 skeleton AC 覆盖之间的任何偏差
- **And** 不修改任何文件

#### AC-02: 审查 PLANNED TC 时报告尚未实现

- **Given** TC-04 标记为 `@[Status:PLANNED]`（尚未实现）
- **When** `reviewImplTestCase` 针对 TC-04
- **Then** stdout 报告："TC-04 尚未实现（Status: PLANNED）。请先使用设计审查行为。"
- **And** 退出码为 0（非错误）

#### AC-03: Target 选择器未解析为单个 TC

- **Given** `--target tests/auth_test.cpp`（整个文件，非特定 TC）
- **When** `--behave reviewImplTestCase` 被调用
- **Then** 退出码为 1
- **And** stderr 报告 `--target` / `--behave` 不匹配，并建议有效组合

---

### US-USER-10 [P0] — 审查文件中所有已实现的测试用例

**作为** USER，**我希望** CLI 一次调用审计文件中每个已实现的 RED TC，**以便** 在编写产品代码前验证整个文件的实现质量。

与以下配对：US-USER-06（implTestFile）。

#### AC-01: 审查报告每个 TC 和文件级摘要

- **Given** 测试文件包含 TC-01（RED）、TC-02（RED）、TC-03（PLANNED）、TC-04（RED）
- **When** CLI 以 `--behave reviewImplTestFile --target tests/auth_test.cpp` 运行
- **Then** stdout 报告 TC-01、TC-02、TC-04 的逐个 TC 审查结果
- **And** TC-03 被跳过并附注："TC-03 尚未实现（PLANNED）"
- **And** 文件级摘要报告：已审查的总 RED TC 数、保留 skeleton 的 TC 数、存在问题的 TC 数
- **And** 不修改任何文件

#### AC-02: 文件无已实现 TC 时报告为空

- **Given** 测试文件中所有 TC 均为 PLANNED（DESIGNED 状态，无 RED TC）
- **When** `reviewImplTestFile` 被调用
- **Then** stdout 报告："0 个已实现的 TC。所有 TC 均为 PLANNED。"
- **And** 退出码为 0

---

## INVENTOR 需求

### US-INVENTOR-01 [P0] — 将所有 CaTDD 语义委托给 methodPrompts

**作为** INVENTOR，**我希望** CLI 不拥有任何 CaTDD 方法知识，**以便** 我可以演进 category、discipline 规则和 prompt 契约，而无需触碰或重新发布 CLI。

#### AC-01: Category 定义绝不硬编码在 CLI 中

- **Given** CLI 需要生成一个 Edge 类别的 TC skeleton
- **When** 它解析 Edge category 的含义
- **Then** 它从 `methodPrompts/` 下的文件读取 —— 绝不从 CLI 源码中的硬编码字符串、枚举或模板读取
- **And** 如果所需的 methodPrompt 文件缺失或不可读，CLI 退出并报错，指明缺失的文件

#### AC-02: Slash-command 行为委托给 slashCommands

- **Given** CLI 解析 `--behave designFuncTestsSkeleton`
- **When** 它执行该行为
- **Then** 它调用 `slashCommands/commands/` 下对应的可移植命令
- **And** 不内联或复制该命令的逻辑

#### AC-03: 输出中所有 CaTDD 工件均由委托层生成

- **Given** 任何会修改测试文件的 CLI 调用
- **When** 输出中出现 CaTDD 特定内容（`@[US]`、`@[AC]`、`@[TC]`、`@[Category]`、`@[Status]`）
- **Then** 该内容由 methodPrompt 或 slashCommand 生成 —— 绝不由 CLI 自身从硬编码字符串或模板生成

> **注意**：US-INVENTOR-01（设计委托）与 US-INVENTOR-03（诊断可见性）构成一对：US-INVENTOR-01 是架构保证；US-INVENTOR-03 是委托确实发生的运行时证明。

---

### US-INVENTOR-02 [P0] — 生成机器可读的执行 trace

**作为** INVENTOR，**我希望** 每次 CLI 运行留下结构化 trace，**以便** 我可以审计方法合规性、重放调用、检测意图与执行结果之间的偏差。

#### AC-01: 成功执行时写入 trace

- **Given** 一个有效的 CLI 调用成功完成
- **When** CLI 退出
- **Then** 在可发现位置存在 trace 工件
- **And** trace 包含：时间戳、完整调用字符串、解析后的参数、解析后的 slash 命令（含文件路径）、已修改的文件、受影响的 TC-ID 及其前后 status、退出码和执行时长

#### AC-02: 执行失败时也写入 trace

- **Given** 一个有效的 CLI 调用在执行期间（非参数解析期间）失败
- **When** CLI 以退出码 1 退出
- **Then** trace 工件依然存在
- **And** 它记录失败点：哪个 step 正在执行、错误信息、以及失败前已完成哪些 step

#### AC-03: Trace 格式可被机器解析

- **Given** CLI 写入的任何 trace 工件
- **When** 被标准 JSON 或 YAML 解析器解析
- **Then** 解析成功，所有字段符合文档化的 schema

---

### US-INVENTOR-03 [P1] — 方法解析过程的可诊断可见性

**作为** INVENTOR，**我希望** `--diagMethodPrompts` 和 `--diagSlashCommands` 能揭示 CLI 解析了哪些具体 prompt 和命令，**以便** 我可以验证 CLI 没有替换、跳过或绕过任何 CaTDD 资产。

#### AC-01: --diagMethodPrompts 记录已解析的 prompt

- **Given** 任意带 `--diagMethodPrompts` 的有效 CLI 调用
- **When** CLI 在执行期间解析 method prompt
- **Then** stderr（或诊断日志流）列出每个已解析的 prompt 文件路径及对应的 CaTDD category 或规则

#### AC-02: --diagSlashCommands 记录已解析的命令

- **Given** 带 `--behave designFuncTestsSkeleton` 和 `--diagSlashCommands` 的调用
- **When** CLI 将 behavior 解析为一个或多个 slash command
- **Then** 诊断输出按解析顺序列出每个 slash command 名称和文件路径

---

## DEVELOPER 需求

### US-DEV-01 [P0] — 所有失败状态都有可操作的错误信息

**作为** DEVELOPER，**我希望** 每条错误信息都指明问题、标识受影响的参数并建议纠正方法，**以便** 无需阅读 CLI 源码即可调试调用问题。

#### AC-01: 无法识别的参数值给出纠正建议

- **Given** CLI 调用使用 `--behave "deisgnAllSkeleton"`（拼写错误）
- **When** 验证失败
- **Then** stderr 包含 `"deisgnAllSkeleton"` 未被识别
- **And** stderr 包含建议：`"您是否想输入 'designAllSkeleton'？"`（最佳匹配）
- **And** stderr 包含完整有效值列表

#### AC-02: 文件缺失错误包含精确路径

- **Given** `--inputFile nonexistent/path.h`
- **When** 验证失败
- **Then** stderr 包含完整解析路径 `nonexistent/path.h`
- **And** stderr 指明参数名称（`--inputFile`）

#### AC-03: Target/behavior 不匹配时解释原因并建议替代方案

- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** 验证检测到不匹配
- **Then** stderr 解释：skeleton 设计需要文件级 `--target`，而非 TC 级 target
- **And** stderr 建议 skeleton 设计有效的 `--target` 形式，或 TC 级 target 有效的 `--behave` 值

---

### US-DEV-02 [P1] — 可配置的日志与诊断输出

**作为** DEVELOPER，**我希望** `--log-level` 控制输出详细程度，**以便** 生产环境静默运行，调试时详细输出。

#### AC-01: --log-level error 抑制非错误输出

- **Given** 任意带 `--log-level error` 的有效调用
- **When** CLI 成功执行
- **Then** stderr 仅出现 error 级别消息
- **And** stdout 不受影响（行为输出仍然正常）

#### AC-02: --log-level debug 揭示内部分辨过程

- **Given** 任意带 `--log-level debug` 的有效调用
- **When** CLI 执行
- **Then** stderr 包含状态转换：参数解析、behavior 解析、slash-command 选择、文件写入

---

### US-DEV-03 [P1] — 交互式逐命令确认

**作为** DEVELOPER，**我希望** 在每个 slash command 执行前预览它，**以便** 可以在多 step 调用中批准、跳过或中止，避免盲执行。

#### AC-01: 每个 slash command 执行前提示确认

- **Given** 带 `--interactive-slash-commands` 的 `designAndImplTest` 调用
- **When** CLI 解析出一个 slash command（如 `UT_designFuncTestsSkeleton`）
- **Then** stdout 提示："在 tests/auth_api_test.cpp 上执行 UT_designFuncTestsSkeleton？[y/n/s(kip)/a(bort)]"
- **And** CLI 等待用户输入后才继续

#### AC-02: 中止停止所有后续执行

- **Given** 一个交互式会话有多个待执行 slash command
- **When** 用户在任意提示输入 "a"（中止）
- **Then** 不再执行任何后续 slash command
- **And** CLI 以退出码 1 退出
- **And** trace 记录哪些命令被跳过

---

### US-DEV-04 [P2] — 运行时 adapter 接口

**作为** DEVELOPER，**我希望** CLI 的 slash-command 执行后端可通过文档化的 adapter 接口替换，**以便** `utCodeAgentCLI` 可在 Copilot-native、OpenCode 或自定义 agent runtime 上运行，无需重写 CLI 核心。

#### AC-01: Adapter 符合定义的接口

- **Given** 一个实现了 `CliRuntimeAdapter` 接口的 runtime adapter
- **When** CLI 需要调用 slash command
- **Then** 它调用 adapter 的 `invoke(slashCommand, context)` 方法
- **And** adapter 接收已解析的命令路径、target、source 和 goal 上下文
- **And** CLI 不假定任何特定 runtime（TypeScript、Python、shell）

#### AC-02: 提供默认 adapter

- **Given** 未配置自定义 adapter
- **When** CLI 运行
- **Then** 内置默认 adapter 直接执行 slash command

---

## 验收标准汇总

| AC ID | 需求 | Given | When | Then |
| --- | --- | --- | --- | --- |
| US-USER-01-AC-01 | US-USER-01 | CLI 调用缺少 --goal | 参数解析执行 | exit 1, stderr 指明 --goal |
| US-USER-01-AC-02 | US-USER-01 | --goalStory 与 --goalStoryFile 同时提供 | 参数解析执行 | exit 1, stderr 指明冲突参数 |
| US-USER-01-AC-03 | US-USER-01 | --behave "nonexistent" | behavior 解析执行 | exit 1, stderr 列出有效值 |
| US-USER-01-AC-04 | US-USER-01 | 文件路径参数指向不存在文件 | 验证执行 | exit 1, stderr 指明缺失路径 |
| US-USER-01-AC-05 | US-USER-01 | 所有参数有效 | 解析完成 | exit 0, 执行继续 |
| US-USER-02-AC-01 | US-USER-02 | story + source + 空 target | designFuncTestsSkeleton | 文件获得全部 4 个 P0 category 的 US/AC/TC skeleton |
| US-USER-02-AC-02 | US-USER-02 | story + source + target | designEdgeSkeleton | 文件仅获得 Edge skeleton |
| US-USER-02-AC-03 | US-USER-02 | 有 source 但无 story | skeleton 设计行为 | skeleton 生成, @[US] 占位符, stderr 警告 |
| US-USER-03-AC-01 | US-USER-03 | 文件有 skeleton TC | reviewFuncTestsSkeleton | stdout 报告各 P0 category 和 status 数量 |
| US-USER-03-AC-02 | US-USER-03 | 文件为 EMPTY | review 调用 | stdout 报告 "0 个 skeleton", exit 0 |
| US-USER-03-AC-03 | US-USER-03 | 文件有 P1 design skeleton | reviewDesignTestsSkeleton | stdout 报告各 P1 category 和 status 数量 |
| US-USER-03-AC-04 | US-USER-03 | 文件有 P2 quality skeleton | reviewQualityTestsSkeleton | stdout 报告各 P2 category 和 status 数量 |
| US-USER-04-AC-01 | US-USER-04 | 文件有 PLANNED TC | tellMeNextImplTest | stdout 输出 CaTDD 优先级下首个 PLANNED TC-ID |
| US-USER-04-AC-02 | US-USER-04 | TC-01 RED, TC-02/03 PLANNED | tellMeNextImplTest | stdout 选择 TC-02, 跳过 RED |
| US-USER-04-AC-03 | US-USER-04 | 所有 TC 为 RED 或 GREEN | tellMeNextImplTest | stdout 报告全部已实现, exit 0 |
| US-USER-05-AC-01 | US-USER-05 | TC-04 skeleton 为 PLANNED + 有效 | implTestCase | TC-04 获得测试代码, status → RED, 其他不变 |
| US-USER-05-AC-02 | US-USER-05 | TC-04 已为 RED | implTestCase | exit 1, stderr 报告已实现, 无修改 |
| US-USER-05-AC-03 | US-USER-05 | --target 是整个文件非单个 TC | implTestCase | exit 1, stderr 报告不匹配 |
| US-USER-05-AC-04 | US-USER-05 | TC-04 skeleton 缺少 @[Category] | implTestCase 预检 | exit 1, stderr 报告完整性失败, 无修改 |
| US-USER-06-AC-01 | US-USER-06 | 文件有混合 PLANNED/RED TC | implTestFile | TC 按 CaTDD 优先级顺序实现, 报告摘要 |
| US-USER-06-AC-02 | US-USER-06 | TC-02 中途失败 | implTestFile 执行中 | TC-02 保留 PLANNED, 继续下一个, 摘要统计失败数 |
| US-USER-07-AC-01 | US-USER-07 | 多个 --target 文件 + 共享 source | designAllSkeleton | 每个文件获得 skeleton, 报告每个文件结果 |
| US-USER-08-AC-01 | US-USER-08 | story + source + 空 target | designAndImplTest | skeleton 设计后所有 TC 实现 → FULLY_RED |
| US-USER-09-AC-01 | US-USER-09 | TC-04 为 RED 且保留 skeleton | reviewImplTestCase | stdout 报告 skeleton 保留情况和测试质量 |
| US-USER-09-AC-02 | US-USER-09 | TC-04 为 PLANNED（未实现） | reviewImplTestCase | stdout 报告尚未实现, exit 0 |
| US-USER-09-AC-03 | US-USER-09 | --target 是整个文件非单个 TC | reviewImplTestCase | exit 1, stderr 报告不匹配 |
| US-USER-10-AC-01 | US-USER-10 | 文件有混合 RED/PLANNED TC | reviewImplTestFile | RED TC 逐个审查, PLANNED 跳过, 文件摘要 |
| US-USER-10-AC-02 | US-USER-10 | 文件无 RED TC（全部 PLANNED） | reviewImplTestFile | stdout 报告 "0 个已实现 TC", exit 0 |
| US-INVENTOR-01-AC-01 | US-INVENTOR-01 | CLI 需要 Edge category 含义 | 解析 category | 从 methodPrompts/ 读取, 文件缺失则退出报错 |
| US-INVENTOR-01-AC-02 | US-INVENTOR-01 | --behave designFuncTestsSkeleton | 执行 behavior | 调用 slashCommands/, 无内联逻辑 |
| US-INVENTOR-01-AC-03 | US-INVENTOR-01 | CLI 修改测试文件 | CaTDD 内容出现 | 内容来自 methodPrompt 或 slashCommand, 绝不硬编码 |
| US-INVENTOR-02-AC-01 | US-INVENTOR-02 | 有效调用成功 | CLI 退出 | trace 工件包含 invocation、resolution、output 数据 |
| US-INVENTOR-02-AC-02 | US-INVENTOR-02 | 有效调用执行中失败 | CLI exit code 1 | trace 记录失败点及已完成 step |
| US-INVENTOR-02-AC-03 | US-INVENTOR-02 | trace 工件存在 | 被 JSON/YAML 解析 | 有效, 所有字段符合文档化 schema |
| US-INVENTOR-03-AC-01 | US-INVENTOR-03 | 调用带 --diagMethodPrompts | CLI 解析 prompt | 诊断输出列出 prompt 路径和 category |
| US-INVENTOR-03-AC-02 | US-INVENTOR-03 | 调用带 --diagSlashCommands | CLI 解析命令 | 诊断输出列出命令名和路径 |
| US-DEV-01-AC-01 | US-DEV-01 | --behave 有拼写错误 | 验证失败 | stderr 给出纠正建议 + 列出有效值 |
| US-DEV-01-AC-02 | US-DEV-01 | --inputFile 指向缺失文件 | 验证失败 | stderr 指明路径 + 参数名 |
| US-DEV-01-AC-03 | US-DEV-01 | TC target + skeleton 设计 behavior | 验证检测到不匹配 | stderr 解释原因 + 给出替代建议 |
| US-DEV-02-AC-01 | US-DEV-02 | --log-level error | 执行成功 | stderr 仅 error 输出, stdout 不受影响 |
| US-DEV-02-AC-02 | US-DEV-02 | --log-level debug | 执行 | stderr 展示状态转换 |
| US-DEV-03-AC-01 | US-DEV-03 | designAndImplTest + interactive | CLI 解析 slash command | 提示确认 [y/n/s/a] |
| US-DEV-03-AC-02 | US-DEV-03 | 交互式会话, 用户输入 "a" | 任意提示 | 无后续命令, exit 1, trace 记录跳过项 |
| US-DEV-04-AC-01 | US-DEV-04 | adapter 实现 CliRuntimeAdapter | CLI 调用 slash command | 调用 adapter.invoke() 含完整上下文 |
| US-DEV-04-AC-02 | US-DEV-04 | 未配置自定义 adapter | CLI 运行 | 内置默认 adapter 直接执行 |

---

## 需求依赖图

```
US-USER-01（解析与验证）
  │
  ├──► US-DEV-01（错误信息）── 适用于 US-USER-01 中的所有验证
  ├──► US-DEV-02（日志）
  ├──► US-DEV-03（交互式）
  ├──► US-INVENTOR-02（执行 trace）── 依赖 US-USER-01 的已解析参数
  │
  ├──► US-USER-02（设计 skeleton）── 需要 US-INVENTOR-01（委托语义）
  │       │
  │       ├──► US-USER-03（审查设计，所有层级）── US-USER-02 的配对审查
  │       ├──► US-USER-04（选择下一个）── 依赖 US-USER-02 输出
  │       └──► US-USER-07（批量设计）── 按文件复用 US-USER-02
  │
  ├──► US-USER-05（实现一个 TC）── 需要 US-INVENTOR-01
  │       │
  │       ├──► US-USER-09（审查一个实现）── US-USER-05 的配对审查
  │       └──► US-USER-06（实现所有）── 按 CaTDD 优先级顺序循环 US-USER-05
  │               │
  │               └──► US-USER-10（审查所有实现）── US-USER-06 的配对审查
  │
  └──► US-USER-08（设计+实现）── 串联 US-USER-02 → US-USER-05
                                  事后审查通过 US-USER-03 + US-USER-10

US-INVENTOR-01（委托语义）── 被以下所需：US-USER-02, US-USER-05, US-USER-06, US-USER-08, US-USER-09, US-USER-10
US-INVENTOR-03（诊断可见性）── 横切关注点，依赖 US-USER-01
                               （US-INVENTOR-01 的运行时证明）

US-DEV-04（adapter 接口）── P2，独立于所有其他需求
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
| 将 TC 从 RED 变为 GREEN（`@[Status:GREEN]`） | 用户的 TDD 工作流；CLI 可读取 GREEN 但永不写入 |

---

## 可追溯性

| 工件 | 与这些需求的关系 |
| --- | --- |
| [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md) | 定义满足 US-USER-01、US-USER-02、US-USER-05 的 CLI 参数契约。定义 `--behave` alias —— 包括 `review*Skeleton` 和 `reviewImpl*` —— 服务于 US-USER-03、US-USER-09、US-USER-10。错误处理满足 US-DEV-01。 |
| [README_UserGuide_ZH.md](README_UserGuide_ZH.md) | 记录满足所有 USER 需求的 invocation plan 工作流。Behavior Selection Guide 将用户意图映射到 US-USER-02–US-USER-10。 |
| [README_ZH.md](README_ZH.md) | 定义 CLI 层是什么以及为何存在 —— 所有需求的架构上下文。 |
| `methodPrompts/` | 提供 US-INVENTOR-01 所需的 category 语义。每个 USER 设计/实现需求都依赖此层。 |
| `slashCommands/` | 提供 US-INVENTOR-01 所需的可移植命令执行。每个 `--behave` 值都解析为此层中的资产。 |
| [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md) | 发起这些需求的原始请求。 |

### 旧 → 新 ID 映射

| 旧 ID | 新 ID |
| --- | --- |
| REQ-CLI-U01 | US-USER-01 |
| REQ-CLI-U02 | US-USER-02 |
| REQ-CLI-U03 | US-USER-03 |
| REQ-CLI-U04 | US-USER-04 |
| REQ-CLI-U05 | US-USER-05 |
| REQ-CLI-U06 | US-USER-06 |
| REQ-CLI-U07 | US-USER-07 |
| REQ-CLI-U08 | US-USER-08 |
| REQ-CLI-I01 | US-INVENTOR-01 |
| REQ-CLI-I02 | US-INVENTOR-02 |
| REQ-CLI-I03 | US-INVENTOR-03 |
| REQ-CLI-D01 | US-DEV-01 |
| REQ-CLI-D02 | US-DEV-02 |
| REQ-CLI-D03 | US-DEV-03 |
| REQ-CLI-D04 | US-DEV-04 |

---

## 开放问题

- Trace 文件的输出目录和命名规范是什么？是否应由用户通过 `--trace-dir` 控制？
- `--log-level` 是否应支持低于 `debug` 的 `trace` 级别用于原始 prompt/response 日志？
- 对于 US-DEV-04（adapter），首个 adapter 应以哪个 runtime 为目标：raw TypeScript CLI、Copilot-native 还是 OpenCode-compatible？
- `--target` 是否应接受 target-list 文件（`--target-file`）作为逗号分隔内联路径的替代方案？
- `--interactive-slash-commands` 是否应支持超时以用于无人值守的 CI 运行？

---

## 维护规则

当新的用户需求无法追溯至任何现有 US-* ID 时，新增一个需求。每个需求必须至少包含一个带唯一 AC ID 的可验证验收标准。

**不要**将架构决策或详细实现行为放在此文档中 —— 这些应归属 `README_ArchDesign.md` 和 `README_DetailDesign.md`。

本文档是需求大纲。下游文档实现它 —— 它们不驱动它。
