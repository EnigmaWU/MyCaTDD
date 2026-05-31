# utCodeAgentCLI 需求 —— USER

> 主索引、状态模型与快速参考 AC 清单：[README_UserStory_ZH.md](README_UserStory_ZH.md)

两个子角色形成不同的 USER 路径：

| 子角色 | 关注点 |
| --- | --- |
| **NEW-USER** | "我不知道 CaTDD 的 category 体系或 TDD 纪律。不要让我从 Typical 和 Edge 中选择，或猜测下一个该实现哪个 TC —— 要向我展示我的代码需要什么覆盖结构，解释我 skeleton 中的缺口，并一步步引导我前进。" |
| **EXPERIENCED-USER** | "我了解这套方法。让我精确调用：仅设计一个特定 category，直接实现一个具体 TC-ID，跨多个文件串联操作。给我错误信息，而非手把手指导。我也负责审查团队覆盖率和 CI 运行 —— 给我可解析的输出和清晰的退出码。" |

---

### US-USER-01 [P0] — 解析并验证 CLI 参数

**作为** USER，**我希望** CLI 立即验证我的调用参数，**以便** 参数错误时得到清晰、可操作的反馈，而非静默异常。

#### AC-01：缺少必选参数时报错退出
- **Given** CLI 调用缺少 `--goal`
- **When** 参数解析执行
- **Then** 退出码为 1，stderr 包含 `"--goal"`，并说明 `--goal` 的用途以及为什么必须提供
- **And** `--target` 和 `--behave` 同理

#### AC-02：互斥参数被拒绝
- **Given** CLI 同时指定了 `--goalStory "..."` 和 `--goalStoryFile "..."`，或同时指定 `--input "..."` 和 `--inputFile "..."`
- **When** 参数解析执行
- **Then** 退出码为 1
- **And** stderr 指明两个冲突参数并说明它们不能同时使用

#### AC-03：无法识别的 --behave 值列出有效选项
- **Given** CLI 指定了 `--behave "nonexistent"`
- **When** behavior 解析执行
- **Then** 退出码为 1
- **And** stderr 列出所有有效的 `--behave` 值

#### AC-04：文件路径参数指向不存在的文件
- **Given** CLI 的 `--inputFile`、`--goalStoryFile`、`--reference`、`--extra-prompt` 或 `--config-file` 指向不存在的路径
- **When** 参数验证执行
- **Then** 退出码为 1
- **And** stderr 指明缺失的路径

#### AC-05：有效调用正常继续执行
- **Given** 所有必选参数齐全、互斥对未违反、文件路径全部存在
- **When** 参数解析完成
- **Then** 退出码为 0
- **And** 执行继续进入 `--behave` 指定的行为

---

### US-USER-02 [P0] — 设计 CaTDD 测试 skeleton

**作为** USER，**我希望** CLI 根据我的源代码和 User Story 将 US/AC/TC skeleton 生成到测试文件中，**以便** 在编写任何可执行测试代码之前就拥有一个结构化、可追溯的测试计划。

#### AC-01：P0 Functional skeleton 设计写入全部四个 category
- **Given** 有一个 User Story（`--goalStory` 或 `--goalStoryFile`）、一个源代码接口文件（`--inputFile`），以及一个空或不存在的目标测试文件（`--target`）
- **When** CLI 以 `--behave designFuncTestsSkeleton` 运行
- **Then** 目标测试文件被创建或更新（EMPTY 或 DESIGNED → DESIGNED）
- **And** 文件包含 `@[US]` 注释，其内容与提供的 User Story 一致
- **And** 文件包含从 story 派生出的 `@[AC-*]` 验收标准注释
- **And** 文件包含 Typical、Edge、Misuse 和 Fault 类别的 `@[TC-*]` 测试用例 skeleton 注释
- **And** 每个 TC skeleton 包含 `@[Category:<name>]` 和 `@[Status:PLANNED]`
- **And** 不写入任何可执行测试代码 —— 仅写入注释 skeleton

#### AC-02：单 category skeleton 设计
- **Given** 有一个源文件和一个 story
- **When** CLI 以 `--behave designEdgeSkeleton` 运行
- **Then** 目标文件仅包含 Edge 类别的 TC skeleton
- **And** 不存在 Typical、Misuse 或 Fault 的 skeleton

#### AC-03：不带 User Story 的 skeleton 设计会接受但给出警告
- **Given** 有源文件但没有 `--goalStory` 或 `--goalStoryFile`
- **When** CLI 以 skeleton 设计行为运行
- **Then** skeleton 正常生成
- **And** `@[US]` 注释包含一个自动生成的占位符，说明未提供 story
- **And** stderr 发出警告，提示可追溯性不完整

---

### US-USER-03 [P0] — 审查设计 skeleton（所有层级）

**作为** USER，**我希望** CLI 在实现前审计所有 CaTDD 层级（P0 Functional、P1 Design、P2 Quality）的设计 skeleton，**以便** 在每个层级都发现覆盖缺口和可追溯性断裂，而非仅检查 P0。

与以下配对：US-USER-02（设计 skeleton）。每个设计动作必须可审查。

#### AC-01：P0 Functional 审查输出数值化的 skeleton 状态
- **Given** 一个包含 CaTDD skeleton TC 的测试文件 —— 部分 PLANNED，部分 RED，部分 GREEN，部分缺少 category 标签（DESIGNED、PARTIAL 或 FULLY_RED 状态）
- **When** CLI 以 `--behave reviewFuncTestsSkeleton` 针对该文件运行
- **Then** stdout 包含：TC 总数量、各 P0 category 数量（Typical、Edge、Misuse、Fault）、各 status 数量（PLANNED、RED、GREEN）、缺少 `@[Category]` 或 `@[Status]` 标签的 TC-ID 列表
- **And** 不修改任何文件

#### AC-02：对不含 skeleton 的文件进行审查时报告为空
- **Given** 一个没有 CaTDD skeleton 注释的测试文件（EMPTY 状态）
- **When** review 被调用
- **Then** stdout 报告："0 个 CaTDD skeleton TC 已找到"
- **And** 退出码为 0（不是错误 —— 文件有效，只是为空）

#### AC-03：P1 Design 审查报告 State/Capability/Concurrency 状态
- **Given** 一个包含 P1 design skeleton TC 的测试文件（State、Capability、Concurrency 类别）
- **When** CLI 以 `--behave reviewDesignTestsSkeleton` 运行
- **Then** stdout 包含各 P1 category 和 status 的数量
- **And** 不修改任何文件

#### AC-04：P2 Quality 审查报告 Performance/Robust/Compatibility/Configuration 状态
- **Given** 一个包含 P2 quality skeleton TC 的测试文件（Performance、Robust、Compatibility、Configuration 类别）
- **When** CLI 以 `--behave reviewQualityTestsSkeleton` 运行
- **Then** stdout 包含各 P2 category 和 status 的数量
- **And** 不修改任何文件

---

### US-USER-04 [P0] — 选择下一个要实现的测试用例

**作为** USER，**我希望** CLI 精确告诉我下一个要实现哪个 TC，**以便** 遵循 TDD 纪律，无需手动扫描文件或猜测优先级。

#### AC-01：下一个 TC 是首个未实现的 P0 TC
- **Given** 测试文件包含 TC-01（Typical, PLANNED）、TC-02（Typical, PLANNED）、TC-03（Edge, PLANNED）
- **When** CLI 以 `--behave tellMeNextImplTest` 运行
- **Then** stdout 精确输出一个 TC-ID：`TC-01`（首个 PLANNED，遵循 CaTDD 优先级：P0 先于 P1 先于 P2，P0 内 Typical → Edge → Misuse → Fault）
- **And** stdout 包含该 TC 的 category
- **And** 不修改任何文件

#### AC-02：部分 TC 已实现时
- **Given** 测试文件包含 TC-01（RED）、TC-02（PLANNED）、TC-03（PLANNED）
- **When** `tellMeNextImplTest` 被调用
- **Then** stdout 选择 `TC-02`（首个未实现，遵循 CaTDD 优先级顺序）
- **And** 已 RED 和 GREEN 的 TC 被跳过

#### AC-03：所有 TC 均已实现时
- **Given** 测试文件中每个 TC 都标记为 `@[Status:RED]` 或 `@[Status:GREEN]`（FULLY_RED 或 ALL_GREEN 状态）
- **When** `tellMeNextImplTest` 被调用
- **Then** stdout 报告："所有 TC 均已实现。无需选择。"
- **And** 退出码为 0

---

### US-USER-05 [P0] — 实现一个可执行测试用例（RED）

**作为** USER，**我希望** CLI 将一个 skeleton TC 转化为可编译的测试代码，**以便** 我能以可执行测试（而非仅注释）进入 TDD 的 RED 阶段。

配对审查：US-USER-09（审查已实现的测试用例）。每个实现动作必须可审查。

#### AC-01：Skeleton TC 变为可执行 RED 测试
- **Given** 测试文件中 TC-04 包含 `@[TC-04]` skeleton 注释，标记 `@[Status:PLANNED]`、`@[Category:Edge]`，且 `@[AC]` 追溯链有效，有源文件提供实现上下文（`--inputFile`）
- **When** CLI 以 `--behave implTestCase --target tests/auth_test.cpp::TC-04` 运行
- **Then** TC-04 的注释 skeleton 被保留（所有 `@[US]`、`@[AC]`、`@[TC]`、`@[Category]` 标签保持不变）
- **And** TC-04 skeleton 注释下方添加可执行测试函数体
- **And** `@[Status:PLANNED]` 替换为 `@[Status:RED]`
- **And** 文件中其他 TC 不被修改
- **And** 文件状态变迁：DESIGNED → PARTIAL，或 PARTIAL → PARTIAL/FULLY_RED

#### AC-02：已实现的 TC 不被覆盖
- **Given** TC-04 已标记 `@[Status:RED]` 或 `@[Status:GREEN]`
- **When** `implTestCase` 再次针对 TC-04
- **Then** 退出码为 1
- **And** stderr 报告："TC-04 已经实现。请先使用 review 行为，或重新设计 skeleton。"
- **And** 文件不被修改（无状态降级）

#### AC-03：Target 选择器未解析为单个 TC
- **Given** `--target tests/auth_test.cpp`（整个文件，非特定 TC）
- **When** `--behave implTestCase` 被调用
- **Then** 退出码为 1
- **And** stderr 报告 `--target` / `--behave` 不匹配，并建议有效组合

#### AC-04：实现前 skeleton 未通过完整性检查
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

#### AC-01：所有 PLANNED TC 按优先级顺序变为 RED
- **Given** 测试文件包含 TC-01（Edge, PLANNED）、TC-02（Typical, PLANNED）、TC-03（Misuse, PLANNED）、TC-04（RED）—— TC-04 已实现
- **When** CLI 以 `--behave implTestFile --target tests/auth_test.cpp` 运行
- **Then** TC 按 CaTDD 优先级顺序实现，而非文件顺序：P0 先于 P1 先于 P2，P0 内 Typical → Edge → Misuse → Fault，同 category 内按文件顺序
- **And** 本文件的实现顺序为：TC-02（Typical）→ TC-01（Edge）→ TC-03（Misuse）
- **And** TC-04 被跳过（已 RED）
- **And** stdout 报告："3 个 TC 已实现，1 个已跳过（已实现），0 个失败"
- **And** 所有 `@[US]`/`@[AC]`/`@[TC]` 注释被保留
- **And** 每个 TC 仅在通过 skeleton 完整性预检后才从 PLANNED 变为 RED（US-USER-05-AC-04）

#### AC-02：中途某 TC 实现失败
- **Given** TC-02 的 skeleton 未通过完整性预检，或其实现遇到无法解决的错误
- **When** `implTestFile` 处理 TC-02
- **Then** TC-02 保持不变（仍为 PLANNED）
- **And** CLI 继续按优先级顺序处理下一个 TC
- **And** stdout 将 TC-02 报告为失败并附失败原因
- **And** 最终摘要区分已实现、已跳过和已失败的数量

---

### US-USER-07 [P1] — 批量 skeleton 设计（多文件）

**作为** USER，**我希望** 从一个源文件和一个 User Story 将 skeleton 设计进多个测试文件，**以便** 一次完成多模块测试覆盖准备。

#### AC-01：多个目标文件各获得 skeleton
- **Given** `--target tests/auth_api_test.cpp,tests/auth_error_test.cpp` 和共享的 `--inputFile` 及 `--goalStoryFile`
- **When** CLI 以 `--behave designAllSkeleton` 运行
- **Then** `tests/auth_api_test.cpp` 和 `tests/auth_error_test.cpp` 均被创建或更新
- **And** 每个文件包含从共享 story 和源文件派生出的 US/AC/TC skeleton
- **And** stdout 报告每个文件的结果

---

### US-USER-08 [P1] — 一步完成设计与实现

**作为** USER，**我希望** CLI 一次调用完成全部 skeleton 设计并立即实现它们，**以便** 无需中间步骤即可从零到 RED 测试代码。

配对审查：US-USER-03（设计 skeleton 审查）和 US-USER-10（实现审查）。即使是组合操作也必须事后可审查。

#### AC-01：设计所有 category 然后实现所有 TC
- **Given** 一个源文件、一个 User Story，以及一个空或不存在的目标测试文件（EMPTY 状态）
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

#### AC-01：审查报告实现质量
- **Given** 测试文件中 TC-04 标记为 `@[Status:RED]`，包含可执行测试代码和保留的 skeleton 注释
- **When** CLI 以 `--behave reviewImplTestCase --target tests/auth_test.cpp::TC-04` 运行
- **Then** stdout 包含：`@[Status:RED]` 是否正确设置、skeleton 注释是否完整保留、测试代码是否遵循 CaTDD 结构、测试代码与 skeleton AC 覆盖之间的任何偏差
- **And** 不修改任何文件

#### AC-02：审查 PLANNED TC 时报告尚未实现
- **Given** TC-04 标记为 `@[Status:PLANNED]`（尚未实现）
- **When** `reviewImplTestCase` 针对 TC-04
- **Then** stdout 报告："TC-04 尚未实现（Status: PLANNED）。请先使用设计审查行为。"
- **And** 退出码为 0（非错误）

#### AC-03：Target 选择器未解析为单个 TC
- **Given** `--target tests/auth_test.cpp`（整个文件，非特定 TC）
- **When** `--behave reviewImplTestCase` 被调用
- **Then** 退出码为 1
- **And** stderr 报告 `--target` / `--behave` 不匹配，并建议有效组合

---

### US-USER-10 [P0] — 审查文件中所有已实现的测试用例

**作为** USER，**我希望** CLI 一次调用审计文件中每个已实现的 RED TC，**以便** 在编写产品代码前验证整个文件的实现质量。

与以下配对：US-USER-06（implTestFile）。

#### AC-01：审查报告每个 TC 和文件级摘要
- **Given** 测试文件包含 TC-01（RED）、TC-02（RED）、TC-03（PLANNED）、TC-04（RED）
- **When** CLI 以 `--behave reviewImplTestFile --target tests/auth_test.cpp` 运行
- **Then** stdout 报告 TC-01、TC-02、TC-04 的逐个 TC 审查结果
- **And** TC-03 被跳过并附注："TC-03 尚未实现（PLANNED）"
- **And** 文件级摘要报告：已审查的总 RED TC 数、保留 skeleton 的 TC 数、存在问题的 TC 数
- **And** 不修改任何文件

#### AC-02：文件无已实现 TC 时报告为空
- **Given** 测试文件中所有 TC 均为 PLANNED（DESIGNED 状态，无 RED TC）
- **When** `reviewImplTestFile` 被调用
- **Then** stdout 报告："0 个已实现的 TC。所有 TC 均为 PLANNED。"
- **And** 退出码为 0
