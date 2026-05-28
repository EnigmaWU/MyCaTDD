# utCodeAgentCLI 使用设计

本文档记录 `utCodeAgentCLI` 的 CLI 接口设计。它基于 [`slashCommands/templates/README_UsageDesignTemplate.md`](../../slashCommands/templates/README_UsageDesignTemplate.md)。

- Story: utCodeAgentCLI 使用设计
- Source artifact: GitHub issue — "Usage design for utCodeAgentCLI"
- Related overview: [README_ZH.md](README_ZH.md)
- Related user guide: [README_UserGuide_ZH.md](README_UserGuide_ZH.md)

## CLI Interface

```text
utCodeAgentCLI [OPTIONS] --goal <STRING> --target <value> --behave <value>

Options:
  --goal                    <STRING>  WHAT 用户想要什么 — 自然语言任务描述（必填）。
  --goalStory               <STRING>  WHY 用户为什么要做 — 内联自然语言 User Story。
  --goalStoryFile           <FILE>    WHY 来自文件 — User Story 文件路径（与 --goalStory 二选一）。
  --input                   <STRING>  WHAT agent 应使用的来源或上下文，内联 selector。
  --inputFile               <FILE>    WHAT 来源或上下文来自文件，与 --input 二选一。
  --target                  <value>   选择要创建、更新或实现的 TestCase/TestFile 范围。
  --behave                  <value>   选择要应用到 target 的行为。
  --reference               <FILEs>   agent 应参考的文件列表，使用逗号分隔。
  --extra-prompt            <FILEs>   追加为额外 prompt 文本的文件列表，使用逗号分隔。
  --config-file             <FILE>    agent config 文件路径。默认：{PRJROOT}/CaTDD/utCodeAgentCLI/config.yaml。
  --log-level               <level>   日志等级。可选：debug | info | warn | error。默认：info。
  --interactive-slash-commands        执行每个 slash command 前请求确认。默认：false。
  --diagMethodPrompts                 输出 DIAG 日志，显示 agent 解析到的 method prompts。
  --diagSlashCommands                 输出 DIAG 日志，显示 agent 解析到的 slash commands。
```

## Argument Reference

### Core Argument Relationships: `--goal`, `--target`, `--input`/`--inputFile`, and `--behave`

这些参数共同完整描述一次调用。理解它们各自的职责，以及为什么要分开，需要理解 CaTDD 如何组织方法含义与 slash commands。

#### Background: methodPrompts vs slashCommands

- **`methodPrompts/`** — 定义 *CaTDD 的含义*：US/AC/TC skeleton 契约、category 语义（Typical、Edge、Misuse、Fault、State、Capability、……）、TDD 状态纪律和风险驱动优先级。这是 CaTDD 方法本身。运行不同 target 或 behavior 时，它不改变。
- **`slashCommands/`** — 定义 *如何执行 CaTDD 步骤*：可移植命令脚本（`UT_designCatSkeleton`、`UT_implTestCase`、`UT_reviewImplTestCase`、……），按 flow 组织（P0 FuncTestsFlow、P1 DesignTestsFlow、……）。每个命令引用 methodPrompts 的 category 含义，但负责具体步骤执行。

`utCodeAgentCLI` 编排这两层。`--target` 与 `--behave` 一起告诉 CLI 要调用哪些 slashCommand；`--goal` 与 `--input`/`--inputFile` 提供两层本身都不拥有的每次调用上下文。

核心模型是：

```text
--goal   = 用户希望本次运行产生什么结果
--input  = agent 应使用什么来源或上下文
--target = agent 应创建、更新或实现哪个 TestCase/TestFile 范围
--behave = CLI 应如何作用于这个 target
```

#### Definitions

**`--goal <STRING>`** — **WHAT** 用户想要什么，内联自然语言字符串。

> 这是本次调用的具体任务描述：用户希望 agent 产出什么结果。它始终是普通字符串，不是文件路径。例如：`"design Typical and Edge skeletons for the login interface"`。

**`--goalStory <STRING>`** — **WHY** 用户为什么要做，内联自然语言 User Story。

> 这是驱动目标的 User Story。使用自然语言编写，例如：`"As a logged-in user I want to reset my password so that I can regain access to my account"`。设计步骤中写入 TestFile 的 `@[US]` 注释来自这个 story — `--goalStory` 是 User Story 的*来源*；TestFile 是它作为永久设计记录的*目的地*。
> 当 story 较短、适合命令行输入时，使用 `--goalStory`。

**`--goalStoryFile <FILE>`** — **WHY** 来自文件；较长 User Story 的 `--goalStory` 替代形式。

> 指向包含 User Story 的文件。story 太长不适合内联，或需要在多次调用中复用时使用。文件内容与通过 `--goalStory` 传入的值同等处理。同一次调用同时提供 `--goalStory` 与 `--goalStoryFile` 是错误。

**`--input <STRING>`** — **WHAT** agent 应使用的来源或上下文，内联字符串。

> `--input` 提供本次工作的源材料。对于设计行为，它可以命名 interface、protocol、API、schema、draft，或短自然语言来源。对于实现行为，它可以命名相关生产源码文件或短实现上下文。短 selector 适合命令行输入时使用 `--input`。

**`--inputFile <FILE>`** — **WHAT** 来源或上下文来自文件；`--input` 的替代形式。

> 指向本次工作的源材料，例如 interface header、API spec、schema、protocol file、existing draft，或相关生产源码文件。同一次调用同时提供 `--input` 与 `--inputFile` 是错误。

**`--target <value>`** — agent 将创建、更新或实现的 CaTDD test-space 范围。

> `--target` 不说明工作是设计还是实现 — 这是 `--behave` 的职责。`--target` 限定测试产物目的地：

> - one TestCase in one TestFile → 例如 `tests/auth_login_test.cpp::TC-03`
> - one TestFile → 例如 `tests/auth_login_test.cpp`
> - some TestFiles → 例如 `tests/auth_test.cpp,tests/payment_test.cpp`

**`--behave <value>`** — 要执行或编排的 CaTDD slash-command behavior。

> `--behave` 是一个 behavior selector，会根据 `slashCommands/commands/` 下兼容的 unit-testing slash commands 解析。它可以是 portable UT slash-command 名称，例如 `UT_designCatSkeleton`、`UT_reviewFuncTestsSkeleton`、`UT_tellMeNextImplTest` 或 `UT_implTestCase`，前提是该命令的输入/输出契约能由 `--goal`、`--input`/`--inputFile`、`--target` 和可选 reference 参数满足。

> CLI 也可以为常见的多步骤或参数化 slash-command behavior 提供稳定 alias：

> - `designTypicalSkeleton` / `designEdgeSkeleton` / `designMisuseSkeleton` / `designFaultSkeleton` → 使用匹配的 P0 functional category 调用 `UT_designCatSkeleton`。产出 US/AC/TC skeleton；不产出可执行测试代码。
> - `designStateSkeleton` / `designCapabilitySkeleton` / `designConcurrencySkeleton` → 调用匹配的 P1 DesignTestsFlow skeleton command。产出 US/AC/TC skeleton；不产出可执行测试代码。
> - `designPerformanceSkeleton` / `designRobustSkeleton` / `designCompatibilitySkeleton` / `designConfigurationSkeleton` → 调用匹配的 P2 QualityTestsFlow skeleton command。产出 US/AC/TC skeleton；不产出可执行测试代码。
> - `designAllSkeleton` → 为所有 P0/P1/P2 CaTDD categories 调用 category skeleton design：Typical、Edge、Misuse、Fault、State、Capability、Concurrency、Performance、Robust、Compatibility、Configuration。只产出 skeleton；不产出可执行测试代码。
> - `implTestCase` → 调用 `UT_implTestCase`。为一个 TC 写入可执行测试代码（RED 阶段）。
> - `implTestFile` → 对文件中的所有 TC 重复调用 `UT_implTestCase`。
> - `designAndImplTest` → 先运行 skeleton design，然后由 CLI 编排重复调用 `UT_implTestCase` 实现选中或生成的 TCs。

#### Relationship summary

| Argument | Question | Role |
| --- | --- | --- |
| `--goal` | **WHAT** — 用户想要什么结果？ | 本次调用的内联自然语言任务描述 |
| `--goalStory` / `--goalStoryFile` | **WHY** — 目标背后的 User Story 是什么？ | 写入 TestFile 的 `@[US]` 来源；永久设计记录 |
| `--input` / `--inputFile` | **WHAT (source)** — agent 应使用什么来源或上下文？ | 提供 interface/protocol/source/draft 材料；`--inputFile` 是文件形式替代 |
| `--target` | **WHAT (destination/scope)** — 作用于哪个测试产物范围？ | 选择 one TC in one TestFile、one TestFile 或 some TestFiles |
| `--behave` | **HOW** — 运行哪个 slash-command behavior？ | 从 `slashCommands/commands/` 选择或 alias slashCommand；category 含义来自 `methodPrompts/` |

`--goal`、`--target`、`--behave` 必填，并且必须彼此一致。当行为需要 target 测试产物之外的源材料时，提供 `--input` 或 `--inputFile` 中的一个。

#### Single-argument use (error cases)

缺少任何必填参数时，CLI 应退出并报错：

```bash
# ERROR: 缺少 --target 和 --behave；agent 无法确定测试范围或步骤
utCodeAgentCLI --goal "design Typical skeletons for login"

# ERROR: 缺少 --goal 和 --behave；agent 没有任务描述或步骤
utCodeAgentCLI --target tests/auth_login_test.cpp

# ERROR: 缺少 --goal 和 --target；agent 没有任务描述和测试范围
utCodeAgentCLI --behave designAllSkeleton

# ERROR: --goalStory 和 --goalStoryFile 不能同时提供
utCodeAgentCLI --goal "design login skeletons" --goalStory "As a user..." --goalStoryFile stories/login.md \
  --target tests/auth_login_test.cpp --behave designAllSkeleton

# ERROR: --input 和 --inputFile 不能同时提供
utCodeAgentCLI --goal "design login skeletons" \
  --input "AuthService" --inputFile src/auth/AuthService.h \
  --target tests/auth_login_test.cpp --behave designAllSkeleton
```

#### Typical use cases (proposed valid invocations)

```bash
# 从 interface file 设计一个 P0 category skeleton 到一个 test file。
utCodeAgentCLI \
  --goal "design Typical skeletons for the auth interface" \
  --goalStory "As a logged-in user I want to reset my password so that I can regain access" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_login_test.cpp --behave designTypicalSkeleton

# 从 protocol file 设计所有 P0/P1/P2 category skeletons 到一个 test file。
utCodeAgentCLI \
  --goal "design all skeletons for the payment protocol" \
  --goalStoryFile stories/payment-us.md \
  --inputFile src/payment/PaymentProtocol.proto \
  --target tests/payment_protocol_test.cpp --behave designAllSkeleton

# 实现一个选中的 test case。
utCodeAgentCLI \
  --goal "implement TC-03 of the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp::TC-03 --behave implTestCase

# 通过重复单 TC 实现步骤，实现一个 test file 中的所有 TC。
utCodeAgentCLI \
  --goal "implement all RED test cases in the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp --behave implTestFile

# 从一个 source interface 跨多个 test files 设计 skeletons。
utCodeAgentCLI \
  --goal "design auth service skeletons across API and error test files" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp,tests/auth_error_test.cpp --behave designAllSkeleton

# 一步完成 skeleton 设计并实现生成的 TCs。
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --goalStory "As an API consumer I want typed auth errors so that I can handle failures reliably" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp --behave designAndImplTest

# 直接把 portable slash command 作为 behavior 运行。
utCodeAgentCLI \
  --goal "review the functional skeletons before implementation" \
  --target tests/auth_api_test.cpp --behave UT_reviewFuncTestsSkeleton
```

`--goal` 说明本次运行要产出什么。`--input`/`--inputFile` 说明 CLI 应使用什么来源。`--target` 说明 CLI 应创建、更新或实现哪个测试产物范围。`--behave` 说明运行哪个 CaTDD 步骤。对于会把 `@[US]`/`@[AC]`/`@[TC]` 结构写入 TestFile 的设计步骤，`--goalStory`/`--goalStoryFile` 提供 **why**。这些参数共同形成可回放、可审查的 CaTDD 执行记录。

| Argument | Type | Values | Required | Description |
| --- | --- | --- | --- | --- |
| `--goal` | string | 任意自然语言字符串 | yes | **WHAT** 用户想要什么 — 本次调用的内联任务描述。 |
| `--goalStory` | string | 任意自然语言字符串 | no | **WHY** — 驱动目标的内联 User Story。写入 TestFile 的 `@[US]` 注释来源。与 `--goalStoryFile` 互斥。 |
| `--goalStoryFile` | file path | 任意可读文件 | no | **WHY** 来自文件 — User Story 文件路径。与 `--goalStory` 同等处理。与 `--goalStory` 互斥。 |
| `--input` | string | Source/context selector | no | **WHAT (source)** — 内联源材料或上下文，例如 `AuthService`、`PaymentProtocol`、`src/auth/AuthService.cpp`。与 `--inputFile` 互斥。 |
| `--inputFile` | file path | 任意可读文件 | no | **WHAT (source)** 来自文件 — interface file、protocol file、schema、API spec、draft test material 或相关生产源码。与 `--input` 互斥。 |
| `--target` | string | Test target selector | yes | 选择 test-space target：one TC in one TestFile（`tests/auth_test.cpp::TC-03`）、one TestFile（`tests/auth_test.cpp`）或 some TestFiles（`tests/a_test.cpp,tests/b_test.cpp`）。 |
| `--behave` | string | Slash-command behavior selector | yes | 选择要应用到 target 的 CaTDD behavior。接受 `slashCommands/commands/` 中兼容的 portable slash-command 名称，也接受 `designAllSkeleton`、`implTestFile`、`designAndImplTest` 等稳定 CLI aliases。 |
| `--reference` | string | 逗号分隔文件路径 | no | 生成输出时 agent 应参考的一个或多个文件。多个文件用逗号分隔。路径可以是绝对路径或相对仓库根目录路径。 |
| `--extra-prompt` | string | 逗号分隔文件路径 | no | 内容会被原样追加为本次调用 extra prompt text 的一个或多个文件。多个文件用逗号分隔。 |
| `--config-file` | file path | 任意可读 YAML 文件 | no | agent 配置文件路径。默认：`{PRJROOT}/CaTDD/utCodeAgentCLI/config.yaml`。 |
| `--log-level` | string | `debug` \| `info` \| `warn` \| `error` | no | 设置本次调用的日志详细程度。默认：`info`。 |
| `--interactive-slash-commands` | flag | — | no | 设置后，agent 在执行每个解析出的 slash command 前请求确认。默认：false。 |
| `--diagMethodPrompts` | flag | — | no | 输出 DIAG-class 日志，列出本次调用解析到的 method prompts。用于确认运行时选择了正确的 CaTDD methodPrompt。 |
| `--diagSlashCommands` | flag | — | no | 输出 DIAG-class 日志，列出本次调用解析到的 slash commands。用于确认运行时选择了正确的 CaTDD slashCommand。 |

### `--target` selector forms

| Form | Meaning |
| --- | --- |
| `tests/auth_test.cpp::TC-03` | 一个 TestFile 中的一个 TestCase。用于 `implTestCase`。 |
| `tests/auth_test.cpp` | 一个 TestFile。用于 skeleton design、full-file implementation 或 design and implementation 组合。 |
| `tests/auth_test.cpp,tests/payment_test.cpp` | 多个 TestFiles。用于对多个测试文件应用同一行为。 |

### `--behave` selector forms

| Form | Meaning |
| --- | --- |
| `UT_implTestCase` | 直接 portable slash-command 名称。当该命令的输入/输出契约与 `--goal`、`--input`、`--target` 兼容时，CLI 运行匹配命令。 |
| `UT_reviewFuncTestsSkeleton` | 直接 review command 名称。当 target 是包含 CaTDD skeletons 的 one TestFile 或 some TestFiles 时使用。 |
| `UT_tellMeNextImplTest` | 直接 next-step command 名称。当 target TestFile 已包含 skeleton TCs，并且 CLI 应选择下一个实现候选时使用。 |
| `designTypicalSkeleton` | 稳定 CLI alias。CLI 将其解析为带 `Cat=Typical` 的 `UT_designCatSkeleton`。 |
| `designAllSkeleton` | 稳定 CLI aggregate alias。CLI 将其解析为适用的 P0/P1/P2 skeleton-design command sequence。 |

### Common `--behave` aliases

| Value | Meaning |
| --- | --- |
| `implTestCase` | 在 target 中实现单个 test case，遵循 CaTDD RED 步骤。添加可执行测试代码。 |
| `implTestFile` | 实现目标 test file 中的所有 test cases，遵循 CaTDD RED 步骤。添加可执行测试代码。 |
| `designTypicalSkeleton` | 只设计 CaTDD **Typical** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designEdgeSkeleton` | 只设计 CaTDD **Edge** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designMisuseSkeleton` | 只设计 CaTDD **Misuse** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designFaultSkeleton` | 只设计 CaTDD **Fault** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designStateSkeleton` | 只设计 CaTDD **State** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designCapabilitySkeleton` | 只设计 CaTDD **Capability** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designConcurrencySkeleton` | 只设计 CaTDD **Concurrency** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designPerformanceSkeleton` | 只设计 CaTDD **Performance** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designRobustSkeleton` | 只设计 CaTDD **Robust** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designCompatibilitySkeleton` | 只设计 CaTDD **Compatibility** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designConfigurationSkeleton` | 只设计 CaTDD **Configuration** category 的 US/AC/TC skeleton。不写入实现测试代码。 |
| `designAllSkeleton` | 设计所有 P0/P1/P2 CaTDD categories 的 skeleton：Typical、Edge、Misuse、Fault、State、Capability、Concurrency、Performance、Robust、Compatibility、Configuration。US/AC/TC 注释会写入目标 test file，但**不会**写入实现测试代码。 |
| `designAndImplTest` | 在一个组合步骤中设计所有 category skeletons **并**实现它们的 test cases。产出 US/AC/TC 结构和可执行测试代码。 |

> 这些 aliases 不是完整 behavior set。只要与所选 test-space `--target` 和提供的 source/context 兼容，`slashCommands/commands/` 中几乎任意兼容的 UT slash command 都可以作为 `--behave` 使用。使用 `--diagSlashCommands` 可以确认 CLI 运行时解析到了哪些 portable command(s)。

### `--log-level` values

| Value | Meaning |
| --- | --- |
| `debug` | 输出所有日志消息，包括内部 agent 状态迁移。 |
| `info` | 输出执行进度信息。这是默认值。 |
| `warn` | 只输出警告和错误。 |
| `error` | 只输出错误消息。 |

## Behavior Matrix

| `--target` shape | `--behave` | Expected behavior |
| --- | --- | --- |
| one TestCase in one TestFile | `implTestCase` | 实现一个选中的 test case。添加可执行测试代码。保留 CaTDD comment skeleton 和 RED 状态。 |
| one TestFile | `implTestFile` | 通过重复单 TC 实现步骤，实现文件中的所有 test cases。保留 CaTDD 状态纪律。 |
| one TestFile | `designTypicalSkeleton` | 在 test file 中放置 Typical-category-only US/AC/TC skeleton。不写入实现测试代码。 |
| one TestFile | `designEdgeSkeleton` | 在 test file 中放置 Edge-category-only US/AC/TC skeleton。不写入实现测试代码。 |
| one TestFile | `designMisuseSkeleton` | 在 test file 中放置 Misuse-category-only US/AC/TC skeleton。不写入实现测试代码。 |
| one TestFile | `designFaultSkeleton` | 在 test file 中放置 Fault-category-only US/AC/TC skeleton。不写入实现测试代码。 |
| one TestFile | P1 category skeleton behavior | 在 test file 中放置 State、Capability 或 Concurrency US/AC/TC skeleton。不写入实现测试代码。 |
| one TestFile | P2 category skeleton behavior | 在 test file 中放置 Performance、Robust、Compatibility 或 Configuration US/AC/TC skeleton。不写入实现测试代码。 |
| one TestFile | `designAllSkeleton` | 在 test file 中放置所有 P0/P1/P2 CaTDD categories 的 US/AC/TC skeleton。不写入实现测试代码。 |
| one TestFile | `designAndImplTest` | 设计所有 category skeletons 并实现它们。产出 US/AC/TC 结构和可执行测试代码。 |
| one TestFile | compatible `UT_review*` behavior | 审查选中的 skeleton 或 implementation artifact，不修改无关文件。 |
| one TestFile | `UT_tellMeNextImplTest` | 从目标 test file 中选择或推荐下一个要实现的 TC。 |
| some TestFiles | `implTestFile` | 对每个选中的 test file 重复 full-file implementation。 |
| some TestFiles | any skeleton design behavior | 对每个选中的 test file 应用所选 skeleton design behavior。 |
| some TestFiles | compatible review behavior | 按所选 slash-command 契约审查每个选中的 test file。 |
| some TestFiles | `designAndImplTest` | 跨每个选中的 test file 设计 skeletons 并实现生成的 TCs。 |

## Invocation Examples

```bash
# 为 interface 设计所有 P0/P1/P2 category skeletons — 使用 inline story
utCodeAgentCLI \
  --goal "design all skeletons for the auth interface" \
  --goalStory "As an API consumer I want typed auth errors so that I can handle failures reliably" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp --behave designAllSkeleton

# 实现一个 test case
utCodeAgentCLI \
  --goal "implement TC-03 of the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp::TC-03 --behave implTestCase

# 从 interface file 设计并实现 tests — story 来自文件
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --goalStoryFile stories/auth-us.md \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp --behave designAndImplTest

# 为 protocol 设计 skeletons — story 来自文件，protocol 来自文件
utCodeAgentCLI \
  --goal "design all skeletons for the payment protocol" \
  --goalStoryFile stories/payment-us.md \
  --inputFile src/payment/PaymentProtocol.proto \
  --target tests/payment_protocol_test.cpp --behave designAllSkeleton \
  --reference docs/payment-spec.md

# 设计 skeletons 时参考多个 reference files（逗号分隔）
utCodeAgentCLI \
  --goal "design all skeletons for the order service" \
  --input "OrderService" \
  --target tests/order_api_test.cpp --behave designAllSkeleton \
  --reference docs/api.md,docs/schema.md

# 从文件追加 extra prompt 内容
utCodeAgentCLI \
  --goal "implement TC-01 of the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp::TC-01 --behave implTestCase \
  --extra-prompt prompts/style-guide.md

# 使用自定义 config 文件，并设置 log level 为 debug
utCodeAgentCLI \
  --goal "implement TC-01 of the login test file" \
  --inputFile src/auth/AuthService.cpp \
  --target tests/auth_login_test.cpp::TC-01 --behave implTestCase \
  --config-file ~/.catdd/config.yaml --log-level debug

# 每个 slash command 执行前交互式确认
utCodeAgentCLI \
  --goal "design all skeletons for the auth interface" \
  --input "AuthService" \
  --target tests/auth_api_test.cpp --behave designAllSkeleton \
  --interactive-slash-commands

# 输出 DIAG 日志，显示解析到的 method prompts 和 slash commands
utCodeAgentCLI \
  --goal "design and implement auth interface tests" \
  --inputFile src/auth/AuthService.h \
  --target tests/auth_api_test.cpp --behave designAndImplTest \
  --diagMethodPrompts --diagSlashCommands
```

## Error and Edge Handling

- `--goal` missing -> 打印 usage 并以非零状态码退出。
- `--goal` given an empty string -> 打印 usage 并以非零状态码退出。
- `--goalStory` and `--goalStoryFile` both provided -> 打印互斥错误并以非零状态码退出。
- `--goalStoryFile` given a path that does not exist -> 打印缺失路径并以非零状态码退出。
- `--input` and `--inputFile` both provided -> 打印互斥错误并以非零状态码退出。
- `--input` given an empty string -> 视为未提供 `--input`；输出 warning。
- `--inputFile` given a path that does not exist -> 打印缺失路径并以非零状态码退出。
- `--target` missing -> 打印 usage 并以非零状态码退出。
- `--behave` missing -> 打印 usage 并以非零状态码退出。
- `--target` cannot be parsed as one TestCase, one TestFile, or some TestFiles -> 打印支持的 selector forms 并以非零状态码退出。
- `--behave` given an unrecognized value -> 打印支持的 values 并以非零状态码退出。
- `--target` selecting one TestCase combined with a skeleton design behavior -> 不支持的组合。打印错误并退出；skeleton behaviors 需要 one TestFile 或 some TestFiles。
- `--reference` given a path that does not exist -> 打印缺失路径并以非零状态码退出。
- `--reference` given an empty string or only commas -> 视为未提供 `--reference`；输出 warning。
- `--extra-prompt` given a path that does not exist -> 打印缺失路径并以非零状态码退出。
- `--extra-prompt` given an empty string or only commas -> 视为未提供 `--extra-prompt`；输出 warning。
- `--config-file` given a path that does not exist -> 打印缺失路径并以非零状态码退出。
- `--config-file` given a file that is not valid YAML -> 打印 parse error 并以非零状态码退出。
- `--log-level` given an unrecognized value -> 打印支持的 values 并以非零状态码退出。
- `--diagMethodPrompts` and `--diagSlashCommands` both provided -> 执行期间同时输出两类 DIAG 日志。

## Open Questions

- `--input` 是否应支持逗号分隔的 source names，用于 batch operations？
- `--target` 对 some-TestFiles operations 应使用逗号分隔 test file paths、重复 `--target` flags，还是 target file list？
- `--log-level` 是否应支持比 `debug` 更低的 `trace` level，用于 raw prompt/response logging？
- `--interactive-slash-commands` 是否应支持 unattended runs 的 timeout？

## Usage Example

在仓库根目录运行以下命令，在不修改源码文件的情况下检查本使用设计：

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign_ZH.md"
cp codeAgents/utCodeAgentCLI/README_UsageDesign_ZH.md "$TMP_DOC"
printf '%s\n' "$TMP_DOC"
grep -E '^##|--goal|--goalStory|--goalStoryFile|--input|--target|--behave|--reference|--extra-prompt|--config-file|--log-level|--interactive|--diag' "$TMP_DOC"
```

预期结果：输出临时文件路径，并且 grep 输出显示所有 CLI argument names 和 section headings。

## Review Checklist

- 每个 argument 都有 type、value set 和清晰描述。
- behavior matrix 中每个支持组合都有预期结果。
- 不支持的组合有明确错误行为。
- Open questions 在实现开始前可见。
- 在真实 CLI 实现存在前，不声称已有可运行 CLI。