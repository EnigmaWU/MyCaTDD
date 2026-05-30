# utCodeAgentCLI User Stories

## UserStories Summary: WHAT/WHY/WHEN/WHERE/HOW/ROLE

- **WHAT/WHY**: UserStory defines the essential goals, value, and boundaries utCodeAgentCLI must meet before any detail design or implementation. It ensures all future work is traceable to user value and intent.
- **WHEN/WHERE/HOW**: These stories are used before architecture or coding, live in this module, and guide HOW production-ready behavior is achieved.
- **ROLE**:
  - **DEVELOPER**: Designs, implements, and tests utCodeAgentCLI to meet these stories.
  - **USER**: Uses utCodeAgentCLI to develop their own projects, relying on its guarantees.
  - **INVENTOR**: Invented CaTDD and its core assets (methodPrompts, slashCommands, codeAgents, agentSkills).

This document assembles the first user-stories set for `utCodeAgentCLI`, the future CaTDD-native CLI execution layer. It captures user intent before architecture or detail design work.

`utCodeAgentCLI` is not a runnable binary yet. These stories describe the intended user value and traceable behavior boundaries for current documentation work and future implementation work.

## Who

Use this document for these roles:

- A developer who wants to express a CaTDD task as a clear CLI invocation plan.
- A CodeAgent that needs enough intent to choose arguments, behavior, and trace links.
- A maintainer who decides what belongs in `utCodeAgentCLI` instead of `methodPrompts`, `slashCommands`, or `agentSkills`.
- A tooling author who will later implement the CLI or adapters around it.

## What

This document owns the `utCodeAgentCLI` user-stories layer.

It explains the user value behind the current UsageDesign and UserGuide without turning that value into detail design yet. The stories here are inputs for future architecture, detail design, unit-test design, and implementation planning.

## When

Use this document before `README_ArchDesign.md`, `README_DetailDesign.md`, or implementation planning.

Update it when a new CLI-facing user role, behavior scenario, argument relationship, traceability need, or future adapter requirement becomes clear.

## Where

This file lives in `codeAgents/utCodeAgentCLI/` because the stories are module-scoped to the CLI execution layer.

Related evidence:

- [README.md](README.md) explains the layer's WHAT and WHY.
- [README_UserGuide.md](README_UserGuide.md) explains the startup path and practical CLI planning workflow.
- [README_UsageDesign.md](README_UsageDesign.md) defines the argument and behavior contract.
- [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md) preserves the raw source request.

## Why

`utCodeAgentCLI` needs explicit user stories before detail design so future architecture does not start from scattered examples or chat-only intent.

These stories keep three boundaries visible:

- Current behavior is documentation and invocation planning only.
- Future runnable behavior must be marked as future work.
- CaTDD method semantics stay owned by `methodPrompts`; `utCodeAgentCLI` orchestrates them but does not redefine them.

## How

Maintain this file as the first shared story artifact for the CLI layer.

1. Add or update stories when the UserGuide or UsageDesign reveals a new user intent.
2. Keep each story independently reviewable.
3. Keep acceptance criteria in Given/When/Then language.
4. Mark current documentation behavior separately from future runnable CLI behavior.
5. Keep unresolved decisions in Open Questions instead of silently choosing for the user.

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

Run from the repository root to inspect the story set and confirm that every story has an acceptance scenario:

```bash
sed -n '1,240p' codeAgents/utCodeAgentCLI/README_UserStory.md
rg --line-number '^### US-CLI-|^#### Scenario:' codeAgents/utCodeAgentCLI/README_UserStory.md
```

Expected result: the first command prints this document, and the second command lists each `US-CLI-*` story plus its scenario heading.

## Traceability Notes

- Active SpecFlow story: `.catdd/spec/doingUS/20260530-assemble-utCodeAgentCLI-user-stories-UserStory.md`.
- Archived raw input: [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md).
- Related usage guide: [README_UserGuide.md](README_UserGuide.md).
- Related usage design: [README_UsageDesign.md](README_UsageDesign.md).
- Future detail design should come after this story set is reviewed.

## Open Questions

- Which role should drive priority order first: developer, CodeAgent, maintainer, or tooling author?
- Should this file later be renamed or mirrored into project-root `README_UserStories.md` for repository-wide indexing?
- Which stories should remain documentation-only, and which should become future runnable CLI implementation stories?
- How much future adapter scope should be included in the first architecture pass: raw TypeScript, Copilot-native, OpenCode, LangGraph, Google Agent SDK, or only the minimum set?

## Maintenance Rule

Keep this document focused on user intent and BDD-style acceptance criteria. Put architecture decisions in a later `README_ArchDesign.md` and detailed behavior decisions in a later `README_DetailDesign.md`.