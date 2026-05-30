# utCodeAgentCLI User Stories

## UserStories 摘要：WHAT/WHY/WHEN/WHERE/HOW/ROLE

- **WHAT/WHY**：UserStory 明确 utCodeAgentCLI 在进入 detail design 或实现前必须满足的核心目标、价值和边界，确保所有后续工作都可追溯到用户价值与意图。
- **WHEN/WHERE/HOW**：这些 stories 在架构或编码前使用，归属于本模块，指导 HOW 达到 production-ready 行为。
- **ROLE**：
	- **DEVELOPER**：设计、实现并测试 utCodeAgentCLI，确保满足这些 stories。
	- **USER**：使用 utCodeAgentCLI 开发自己的项目，依赖其能力与保证。
	- **INVENTOR**：发明了 CaTDD 及其核心资产（methodPrompts、slashCommands、codeAgents、agentSkills）。

本文档汇总 `utCodeAgentCLI` 的第一组 User Stories。`utCodeAgentCLI` 是未来的 CaTDD-native CLI 执行层。本文件先记录用户意图，再进入 architecture 或 detail design。

`utCodeAgentCLI` 目前还不是可运行 binary。这些 stories 描述当前文档阶段和未来实现阶段的用户价值与行为边界。

## Who

以下角色使用本文档：

- 希望把 CaTDD 任务表达成清晰 CLI invocation plan 的 developer。
- 需要足够意图来选择 arguments、behavior 和 trace links 的 CodeAgent。
- 判断哪些能力属于 `utCodeAgentCLI` 而不是 `methodPrompts`、`slashCommands` 或 `agentSkills` 的 maintainer。
- 未来实现 CLI 或围绕它实现 adapter 的 tooling author。

## What

本文档负责 `utCodeAgentCLI` 的 user-story 层。

它说明当前 UsageDesign 与 UserGuide 背后的用户价值，但暂不进入 detail design。这些 stories 是未来 architecture、detail design、unit-test design 与 implementation planning 的输入。

## When

在编写 `README_ArchDesign.md`、`README_DetailDesign.md` 或 implementation plan 之前，先使用本文档。

当新的 CLI-facing 用户角色、behavior scenario、argument relationship、traceability need 或 future adapter requirement 变清楚时，更新本文档。

## Where

本文档位于 `codeAgents/utCodeAgentCLI/`，因为这些 stories 归属于 CLI 执行层模块。

相关依据：

- [README.md](README.md) 解释这一层的 WHAT 与 WHY。
- [README_UserGuide_ZH.md](README_UserGuide_ZH.md) 解释启动路径和实际 CLI planning workflow。
- [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md) 定义 argument 与 behavior contract。
- [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md) 保留原始请求。

## Why

`utCodeAgentCLI` 需要先有明确 User Stories，detail design 才不会从零散示例或 chat-only intent 开始。

这些 stories 保持三个边界可见：

- 当前行为只是 documentation 与 invocation planning。
- 未来 runnable behavior 必须标记为 future work。
- CaTDD 方法语义仍由 `methodPrompts` 负责；`utCodeAgentCLI` 只做编排，不重新定义语义。

## How

把本文档作为 CLI 层第一个共享 story artifact 维护。

1. 当 UserGuide 或 UsageDesign 暴露新的 user intent 时，新增或更新 story。
2. 保持每个 story 可独立 review。
3. Acceptance criteria 使用 Given/When/Then 语言。
4. 明确区分当前 documentation behavior 与未来 runnable CLI behavior。
5. 未解决的决策放入 Open Questions，不要悄悄替用户选择。

## Story Index

| Story ID | Title | Primary Role | State | Source |
| --- | --- | --- | --- | --- |
| US-CLI-01 | Plan a valid invocation from intent | Developer | Draft | UserGuide Start Here and UsageDesign core arguments |
| US-CLI-02 | Preserve User Story intent in CLI runs | Developer | Draft | `--goalStory` and `--goalStoryFile` contract |
| US-CLI-03 | Choose a behavior safely | CodeAgent | Draft | Behavior Selection Guide and `--behave` selector |
| US-CLI-04 | Review skeletons and pick the next TC | Developer | Draft | `reviewFuncTestsSkeleton` and `tellMeNextImplTest` aliases |
| US-CLI-05 | Keep method and command boundaries clean | Maintainer | Draft | Layer model and dependency direction |
| US-CLI-06 | Prepare future runnable CLI adapters | Tooling author | Draft | Future CLI implementation and adapter needs |

## User Stories

### US-CLI-01: Plan a Valid Invocation From Intent

**As a** developer,
**I want** to turn a CaTDD task into a valid `utCodeAgentCLI` invocation plan,
**So that** I can clearly state the goal, source context, test-space target, and behavior before asking an agent to work.

#### Acceptance Criteria

#### Scenario: Required Arguments Are Chosen From Intent

- **Given** a developer has a CaTDD task and the `utCodeAgentCLI` UserGuide,
- **When** the developer writes an invocation plan,
- **Then** the plan includes `--goal`, `--target`, and `--behave`,
- **And** it uses exactly one of `--input` or `--inputFile` when source context is needed,
- **And** it keeps source files out of `--target`.

### US-CLI-02: Preserve User Story Intent in CLI Runs

**As a** developer,
**I want** to provide the User Story behind a skeleton-design goal,
**So that** generated US/AC/TC skeletons can preserve WHY traceability.

#### Acceptance Criteria

#### Scenario: Story Source Is Explicit

- **Given** a design run will create or update US/AC/TC skeletons,
- **When** the developer prepares the invocation plan,
- **Then** the plan uses either `--goalStory` or `--goalStoryFile`,
- **And** it does not provide both at the same time,
- **And** the story is treated as the source of `@[US]` traceability, not as a target file.

### US-CLI-03: Choose a Behavior Safely

**As a** CodeAgent,
**I want** to resolve `--behave` through stable aliases or compatible `UT_*` commands,
**So that** I can apply the intended CaTDD step without redefining method semantics.

#### Acceptance Criteria

#### Scenario: Behavior Maps to a Compatible Command

- **Given** an invocation plan includes a `--behave` value,
- **When** the CodeAgent resolves the behavior,
- **Then** it accepts stable aliases such as `designFuncTestsSkeleton`, `designAllSkeleton`, `reviewFuncTestsSkeleton`, `tellMeNextImplTest`, `implTestCase`, and `implTestFile`,
- **And** it may accept a direct compatible `UT_*` command,
- **And** it reports uncertainty when the target scope cannot satisfy the selected behavior.

### US-CLI-04: Review Skeletons and Pick the Next TC

**As a** developer,
**I want** the CLI layer to support skeleton review and next-test selection as first-class planning steps,
**So that** implementation starts from reviewed CaTDD skeletons instead of jumping directly to code.

#### Acceptance Criteria

#### Scenario: Review Comes Before Implementation

- **Given** a TestFile contains planned P0 functional skeletons,
- **When** the developer asks for review or next-test selection,
- **Then** the invocation can use `reviewFuncTestsSkeleton` or `tellMeNextImplTest`,
- **And** the output remains a planning recommendation unless the behavior is explicitly an implementation behavior,
- **And** no product code implementation is implied by review-only behavior.

### US-CLI-05: Keep Method and Command Boundaries Clean

**As a** maintainer,
**I want** `utCodeAgentCLI` to orchestrate CaTDD assets without owning their semantics,
**So that** CLI automation can evolve without drifting from `methodPrompts` and `slashCommands`.

#### Acceptance Criteria

#### Scenario: CLI Orchestration Does Not Redefine CaTDD

- **Given** a CLI scenario refers to CaTDD categories or slash-command behavior,
- **When** the scenario needs category meaning or command steps,
- **Then** category meaning remains sourced from `methodPrompts`,
- **And** portable command behavior remains sourced from `slashCommands`,
- **And** `agentSkills` stays a separate generic packaging path, not an upstream dependency of `utCodeAgentCLI`.

### US-CLI-06: Prepare Future Runnable CLI Adapters

**As a** tooling author,
**I want** the story set to separate current documentation behavior from future runnable CLI behavior,
**So that** TypeScript implementation and adapter design can proceed without claiming runtime support that does not exist yet.

#### Acceptance Criteria

#### Scenario: Future Runtime Work Is Marked Clearly

- **Given** `utCodeAgentCLI` is currently a documented future CLI layer,
- **When** a story describes parser behavior, execution, logging, diagnostics, or adapter integration,
- **Then** the story marks that behavior as future runnable CLI work,
- **And** it keeps current examples as invocation plans,
- **And** it can later feed architecture work for raw TypeScript, Copilot-native, and OpenCode-compatible adapters.

## Acceptance Criteria Summary

| AC ID | Story | Given | When | Then | Status |
| --- | --- | --- | --- | --- | --- |
| AC-CLI-01 | US-CLI-01 | A developer has a CaTDD task | The developer writes an invocation plan | Required arguments are present and source/target are separated | Draft |
| AC-CLI-02 | US-CLI-02 | A design run needs skeleton traceability | The developer prepares the plan | `--goalStory` or `--goalStoryFile` supplies WHY | Draft |
| AC-CLI-03 | US-CLI-03 | A behavior selector is present | A CodeAgent resolves it | Alias or compatible `UT_*` behavior is selected | Draft |
| AC-CLI-04 | US-CLI-04 | Skeletons exist in a TestFile | Review or next-test selection is requested | Planning output does not imply implementation | Draft |
| AC-CLI-05 | US-CLI-05 | CLI behavior needs CaTDD meaning | The maintainer updates CLI docs or design | Method and command semantics remain upstream | Draft |
| AC-CLI-06 | US-CLI-06 | Future runtime behavior is discussed | A story mentions implementation or adapters | It is marked as future work | Draft |

## Usage Example

在仓库根目录运行以下命令，查看 story set，并确认每个 story 都有 acceptance scenario：

```bash
sed -n '1,240p' codeAgents/utCodeAgentCLI/README_UserStory_ZH.md
rg --line-number '^### US-CLI-|^#### Scenario:' codeAgents/utCodeAgentCLI/README_UserStory_ZH.md
```

预期结果：第一条命令打印本文档，第二条命令列出每个 `US-CLI-*` story 及其 scenario heading。

## Traceability Notes

- Active SpecFlow story: `.catdd/spec/doingUS/20260530-assemble-utCodeAgentCLI-user-stories-UserStory.md`。
- Archived raw input: [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md)。
- Related usage guide: [README_UserGuide_ZH.md](README_UserGuide_ZH.md)。
- Related usage design: [README_UsageDesign_ZH.md](README_UsageDesign_ZH.md)。
- Future detail design 应在本 story set review 之后再开始。

## Open Questions

- 哪个角色应首先驱动优先级顺序：developer、CodeAgent、maintainer，还是 tooling author？
- 本文件后续是否应 rename 或 mirror 到项目根目录 `README_UserStories.md`，作为仓库级索引？
- 哪些 stories 应保持 documentation-only，哪些应成为未来 runnable CLI implementation stories？
- 第一轮 architecture 中应包含多少 future adapter scope：raw TypeScript、Copilot-native、OpenCode、LangGraph、Google Agent SDK，还是只保留最小集合？

## Maintenance Rule

本文档只聚焦 user intent 与 BDD-style acceptance criteria。Architecture decisions 放入后续 `README_ArchDesign.md`，detailed behavior decisions 放入后续 `README_DetailDesign.md`。