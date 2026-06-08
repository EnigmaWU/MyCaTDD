# User Story: align SPEC_designUnitTests with UT_designFuncTestsSkeleton for US-USER-01

Created by `/SPEC_analyzeIssue` on 2026-06-09.
Merged analysis from two related pending issues:

- `.catdd/spec/analyzedNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md`
- `.catdd/spec/analyzedNews/20260609-refactor-US-USER-01-with-UT-designFuncTestsSkeleton-Issue.md`

## Source Trace

- Raw issue archive: [../analyzedNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md](../analyzedNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md)
- Raw issue archive: [../analyzedNews/20260609-refactor-US-USER-01-with-UT-designFuncTestsSkeleton-Issue.md](../analyzedNews/20260609-refactor-US-USER-01-with-UT-designFuncTestsSkeleton-Issue.md)
- Related test file: [../../../codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts](../../../codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts)
- Related command: [../../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md](../../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md)
- Related command: [../../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md](../../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md)
- Related template: [../../../methodPrompts/CaTDD_designAndImplTemplate.ts](../../../methodPrompts/CaTDD_designAndImplTemplate.ts)

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` waiting to be opened.
- Priority: P2 - improves process clarity, CaTDD consistency, and maintainability.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a CaTDD workflow maintainer,
I want `SPEC_designUnitTests` to detect available CaTDD P0/P1/P2 `UT_designXYZ` commands and use the matching category command for skeleton design, and I want the existing `US-USER-01` CLI validation test file to reflect that relationship,
so that readers understand why SPEC is the story-level orchestration command while UT is the category-level skeleton design command.

## Conversation Consensus

- `SPEC_*` commands are lifecycle/story orchestration commands.
- `UT_*` commands are concrete category-level test design and implementation mechanics.
- When `SPEC_designUnitTests` detects that a needed CaTDD category has a corresponding `UT_designXYZ` command, it should use that command contract instead of handcrafting category skeletons directly.
- Category routing should cover P0/P1/P2 design commands when they exist:
	- P0 Functional examples: `UT_designTypicalSkeleton`, `UT_designEdgeSkeleton`, `UT_designMisuseSkeleton`, `UT_designFaultSkeleton`, or `UT_designFuncTestsSkeleton` for the full P0 set.
	- P1 Design examples: State, Capability, and Concurrency skeleton commands when present.
	- P2 Quality examples: Performance, Robust, Compatibility, and Configuration skeleton commands when present.
- If no matching `UT_designXYZ` command exists for a needed category, `SPEC_designUnitTests` should document the gap, ask when intent is unclear, or explicitly fall back to `methodPrompts` as the source of truth.
- `UT_designFuncTestsSkeleton` remains design-only; executable test bodies still belong to later implementation flow.

## Observed Behavior

- `SPEC_designUnitTests` is used as the story-level entry for unit-test design, but its relationship to `UT_designFuncTestsSkeleton` is not explicit enough in the flow documentation or generated artifacts.
- `SPEC_designUnitTests` currently allows agents to draft P0/P1/P2 category skeletons directly even when a matching `UT_designXYZ` command exists, which hides the intended SPEC-to-UT delegation boundary.
- `codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts` is valid CaTDD and GREEN, but it does not visibly follow the fuller `CaTDD_designAndImplTemplate.ts` structure.
- The existing test file does not state that P0 Functional skeleton design should be understood as coming from `UT_designFuncTestsSkeleton` under `SPEC_designUnitTests` orchestration.

## Expected Behavior

1. Flow documentation clearly explains that `SPEC_designUnitTests` is the story-level orchestration command and `UT_designFuncTestsSkeleton` is the P0 Functional skeleton-design command it may delegate to or require.
2. `SPEC_designUnitTests` documentation makes the SPEC-to-UT handoff explicit enough that future agents detect and use matching P0/P1/P2 `UT_designXYZ` commands before drafting category skeletons directly.
3. `SPEC_designUnitTests` records or preserves which `UT_designXYZ` command produced each category skeleton when that command exists.
4. `US-USER-01` CLI validation test file preserves all current GREEN behavior while making its CaTDD design+implementation structure and `UT_designFuncTestsSkeleton` relationship visible.
5. The refactor does not change CLI validation behavior or CaTDD category semantics.

## Independent Test Intent

A reviewer can inspect the flow docs, command docs, and `US-USER-01` test file and verify that the SPEC-vs-UT boundary is explicit, the test file remains traceable to US/AC/TC, and all existing CLI argument validation tests still pass.

## Acceptance Criteria

### AC-01: SPEC-vs-UT command boundary is explicit
- **Given** the Px SpecFlow and P0 Functional flow documentation
- **When** a reader follows the path from story-level test design to P0 skeleton design
- **Then** `SPEC_designUnitTests` is described as the orchestration command
- **And** `UT_designFuncTestsSkeleton` is described as the P0 Functional skeleton-design command used for Typical, Edge, Misuse, and Fault coverage.

### AC-02: SPEC_designUnitTests contract mentions UT handoff
- **Given** `slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md`
- **When** a CodeAgent reads the output contract or prompt template
- **Then** it can tell when to use or delegate to matching P0/P1/P2 `UT_designXYZ` commands such as `UT_designFuncTestsSkeleton`
- **And** it must not skip P0 Functional coverage before implementation.

### AC-03: SPEC_designUnitTests uses existing category design commands first
- **Given** an active story requires one or more CaTDD unit-test categories
- **When** a matching `UT_designXYZ` command exists for a required category or category set
- **Then** `SPEC_designUnitTests` uses that command contract for skeleton design
- **And** direct methodPrompt-based drafting is only used as an explicit fallback when no matching `UT_designXYZ` command exists.

### AC-04: US-USER-01 test file is template-aligned without behavior change
- **Given** `codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts`
- **When** the file is refactored for CaTDD template/process clarity
- **Then** it preserves existing `TC-ARG-001..TC-ARG-012` behavior and categories
- **And** it visibly links the P0 Functional skeleton set to `UT_designFuncTestsSkeleton` or its equivalent command contract.

### AC-05: Existing CLI validation tests remain green
- **Given** the refactored `US-USER-01` test file
- **When** `node --test codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts` is run
- **Then** all existing tests pass.

## Edge Cases

- `UT_designFuncTestsSkeleton` is design-only and must not be treated as responsible for executable implementation bodies.
- Refactoring a GREEN test file must not rewrite assertions or loosen behavior checks without an explicit product reason.
- Template alignment should not add noise that makes the test file harder to maintain.

## Scope

In scope:

- Clarify SPEC-vs-UT command boundary in relevant flow/command docs.
- Update `SPEC_designUnitTests` so it explicitly discovers and uses matching P0/P1/P2 `UT_designXYZ` command contracts when they exist.
- Refactor the `US-USER-01` test file comments/sections to expose the CaTDD design+implementation and `UT_designFuncTestsSkeleton` relationship.
- Preserve existing test semantics and GREEN status.

Out of scope:

- Changing CLI argument validation product behavior.
- Redefining P0 Functional category semantics.
- Introducing a new `UT_doXYZ` command unless later analysis explicitly chooses that design.
- Handcrafting category skeletons directly when an existing matching `UT_designXYZ` command can be used.

## Non-Goals

- Reopening `US-USER-01` product implementation.
- Expanding coverage beyond the current CLI argument validation acceptance criteria.
- Replacing `SPEC_designUnitTests` as the story-level lifecycle command.

## Risks

- Overfitting the test file to a verbose template could reduce readability.
- Ambiguous wording could still leave future agents unclear about when SPEC should call UT commands.
- Refactor churn could accidentally alter executable assertions.

## Assumptions

- `SPEC_designUnitTests` remains the correct story-level command in Px SpecFlow.
- `UT_designFuncTestsSkeleton` remains design-only and should not generate executable tests by itself.
- The desired fix is documentation/process clarity plus a non-behavioral test-file refactor.
- Existing `UT_designXYZ` command contracts are authoritative for their categories when present.

## Acceptance Questions

- Should `SPEC_designUnitTests` require explicit mention of the specific `UT_*` command used in every generated test file?
- Should mature GREEN test files follow the full design+implementation template, or only the minimum CaTDD skeleton contract plus source-command trace?
- Should fallback-to-methodPrompts behavior be allowed automatically when no `UT_designXYZ` command exists, or should `SPEC_designUnitTests` stop and ask before fallback?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this merged issue-derived story into active work.