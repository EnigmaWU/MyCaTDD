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

- Status: OPEN.
- Active state: `.catdd/spec/doingUS/` active work in progress.
- Priority: P2 - improves process clarity, CaTDD consistency, and maintainability.
- Confidence: high.
- Next recommended command: `/SPEC_takeDetailDesign`.

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
- In this story, "refactor `cli_argument_validation.design.test.ts`" may mean fully redesigning and reimplementing the test file so it fully follows CaTDD, as long as externally verified CLI validation behavior and acceptance coverage are preserved.
- The current target test file is TypeScript, so CaTDD redesign should use the TypeScript design+implementation template instead of a C++ template shape.

## Expected Behavior

1. Flow documentation clearly explains that `SPEC_designUnitTests` is the story-level orchestration command and `UT_designFuncTestsSkeleton` is the P0 Functional skeleton-design command it may delegate to or require.
2. `SPEC_designUnitTests` documentation makes the SPEC-to-UT handoff explicit enough that future agents detect and use matching P0/P1/P2 `UT_designXYZ` commands before drafting category skeletons directly.
3. `SPEC_designUnitTests` records or preserves which `UT_designXYZ` command produced each category skeleton when that command exists.
4. `US-USER-01` CLI validation test file may be fully redesigned and reimplemented using the correct language-specific CaTDD design+implementation template, while preserving the same intended CLI validation behavior and coverage.
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

### AC-04: US-USER-01 test file fully follows CaTDD without behavior loss
- **Given** `codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts`
- **When** the file is refactored, redesigned, or reimplemented for CaTDD template/process clarity
- **Then** it fully follows the agreed CaTDD design+implementation structure using the TypeScript template appropriate for a `.ts` test file
- **And** it preserves existing `TC-ARG-001..TC-ARG-012` intended behavior and categories, or replaces them only with an explicitly trace-equivalent US/AC/TC set
- **And** it visibly links the P0 Functional skeleton set to `UT_designFuncTestsSkeleton` or its equivalent command contract.

### AC-05: Correct language template is selected
- **Given** a target test file language or extension
- **When** `SPEC_designUnitTests` or downstream refactor work creates or redesigns a test file
- **Then** it selects the matching CaTDD design+implementation template for that language when one exists
- **And** for `cli_argument_validation.design.test.ts`, it uses `methodPrompts/CaTDD_designAndImplTemplate.ts` as the template reference.

### AC-06: Existing CLI validation tests remain green
- **Given** the refactored `US-USER-01` test file
- **When** `node --test codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts` is run
- **Then** all existing tests pass.

## Edge Cases

- `UT_designFuncTestsSkeleton` is design-only and must not be treated as responsible for executable implementation bodies.
- Refactoring a GREEN test file may become full redesign+reimplementation, but it must not reduce behavior coverage or loosen verification without an explicit product reason.
- Template alignment should not add noise that makes the test file harder to maintain.

## Scope

In scope:

- Clarify SPEC-vs-UT command boundary in relevant flow/command docs.
- Update `SPEC_designUnitTests` so it explicitly discovers and uses matching P0/P1/P2 `UT_designXYZ` command contracts when they exist.
- Refactor, redesign, or reimplement the `US-USER-01` test file so it fully follows CaTDD design+implementation intent and exposes the `UT_designFuncTestsSkeleton` relationship.
- Use the correct language-specific CaTDD design+implementation template for target files, including `methodPrompts/CaTDD_designAndImplTemplate.ts` for TypeScript tests.
- Preserve existing test semantics, acceptance coverage, and GREEN status.

Out of scope:

- Changing CLI argument validation product behavior.
- Redefining P0 Functional category semantics.
- Introducing a new `UT_doXYZ` command unless later analysis explicitly chooses that design.
- Handcrafting category skeletons directly when an existing matching `UT_designXYZ` command can be used.
- Reducing or removing `US-USER-01` acceptance coverage under the label of refactor.
- Applying a C++ template shape to a TypeScript target when a TypeScript CaTDD template exists.

## Non-Goals

- Reopening `US-USER-01` product implementation unless full test redesign exposes a real regression or contract ambiguity.
- Expanding coverage beyond the current CLI argument validation acceptance criteria.
- Replacing `SPEC_designUnitTests` as the story-level lifecycle command.
- Treating one language's design+implementation template as universal when a target-language template exists.

## Risks

- Overfitting the test file to a verbose template could reduce readability.
- Ambiguous wording could still leave future agents unclear about when SPEC should call UT commands.
- Refactor churn could accidentally alter executable assertions.
- Full redesign+reimplementation could accidentally change test intent if US/AC/TC equivalence is not tracked explicitly.
- Using the wrong language template could make the file look CaTDD-aligned while still feeling unnatural or misleading for TypeScript maintainers.

## Assumptions

- `SPEC_designUnitTests` remains the correct story-level command in Px SpecFlow.
- `UT_designFuncTestsSkeleton` remains design-only and should not generate executable tests by itself.
- The desired fix is documentation/process clarity plus a non-behavioral test-file refactor.
- Existing `UT_designXYZ` command contracts are authoritative for their categories when present.

## Acceptance Questions

- Should `SPEC_designUnitTests` require explicit mention of the specific `UT_*` command used in every generated test file?
- Should mature GREEN test files follow the full design+implementation template, or only the minimum CaTDD skeleton contract plus source-command trace?
- Should fallback-to-methodPrompts behavior be allowed automatically when no `UT_designXYZ` command exists, or should `SPEC_designUnitTests` stop and ask before fallback?

## Mutual Intent Contract

- Developer intent:
	- Make `SPEC_designUnitTests` a true story-level orchestrator instead of a command that handcrafts category skeletons directly.
	- When CaTDD P0/P1/P2 category design commands already exist, `SPEC_designUnitTests` should detect and use the corresponding `UT_designXYZ` command contract.
	- Keep `US-USER-01` behavior unchanged while making the existing CLI validation test file visibly express the SPEC-to-UT design handoff using the correct TypeScript CaTDD template.
- CodeAgent intent:
	- Update flow/command documentation so future agents understand that `SPEC_designUnitTests` selects category needs and delegates category skeleton design to matching `UT_*` commands.
	- Refactor may include full redesign and reimplementation of `cli_argument_validation.design.test.ts` so it fully follows CaTDD using `CaTDD_designAndImplTemplate.ts`; do not change validator behavior, and preserve or explicitly trace-equate the existing verification intent.
	- Preserve CaTDD category semantics from `methodPrompts` and do not invent new command names such as `UT_doXYZ` as part of this story.
- In scope:
	- Clarify the SPEC-vs-UT boundary in `slashCommands/flows/Px-SpecFlow.md`, `slashCommands/flows/P0-FuncTestsFlow.md`, and `slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md` as needed.
	- Define a clear category routing rule: needed category set -> matching `UT_designXYZ` command -> produced skeleton trace.
	- Make the US-USER-01 test file fully follow the TypeScript CaTDD design+implementation template and show that its P0 Functional skeleton set corresponds to `UT_designFuncTestsSkeleton`, while preserving `TC-ARG-*` behavior coverage or an explicitly equivalent replacement.
	- Keep the existing tests GREEN with `node --test codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts`.
- Out of scope:
	- Changing `validateInvocation` behavior or CLI argument validation semantics.
	- Reopening US-USER-01 product implementation.
	- Creating a new generalized `UT_doXYZ` command.
	- Assuming mature GREEN test files only need comment-only tweaks when the developer intent allows a full CaTDD redesign+reimplementation.
	- Using `CaTDD_designAndImplTemplate.cxx` or C++-specific examples as the structural source for a TypeScript test when `CaTDD_designAndImplTemplate.ts` exists.
- Intent decisions:
	- `SPEC_designUnitTests` should prefer existing `UT_designXYZ` command contracts whenever they match the required category or category set.
	- `SPEC_designUnitTests` should select the correct language-specific design+implementation template based on the target test file language or extension when a matching template exists.
	- Fallback to `methodPrompts` is allowed only as an explicit fallback when no matching `UT_designXYZ` command exists; if category intent is unclear, the command should ask rather than guess.
	- Generated or refactored test files should record enough source-command trace to show which `UT_*` command shaped the skeleton; for this story, the test refactor may be a full CaTDD redesign+reimplementation rather than a minimal comment patch.
	- `UT_designFuncTestsSkeleton` remains design-only; executable test bodies and GREEN assertions belong to later implementation/review steps.
- Success signal:
	- Documentation shows a reader why `SPEC_designUnitTests` is invoked at story level and how it uses `UT_designFuncTestsSkeleton` or other `UT_designXYZ` commands for category skeletons.
	- Documentation shows that target test language controls which CaTDD design+implementation template is used when multiple language templates exist.
	- `SPEC_designUnitTests` output expectations include preserving category-command provenance when a matching `UT_*` command exists.
	- `cli_argument_validation.design.test.ts` remains traceable to `US-USER-01`, `AC-01..AC-05`, and `TC-ARG-001..TC-ARG-012` or an explicitly trace-equivalent replacement, uses `CaTDD_designAndImplTemplate.ts` as the language template, and also exposes the `UT_designFuncTestsSkeleton` relationship.
	- The CLI validation test command remains GREEN after the refactor.
- Insights:
	- The core bug is not that the existing test file lacks CaTDD tags; it has the minimum CaTDD skeleton. The deeper process gap is that the orchestration command allowed agents to obscure which category-design command owned the skeleton shape.
	- The repair should strengthen command boundaries rather than duplicate method semantics: `SPEC_*` decides lifecycle and needed categories; `UT_*` owns category-specific design mechanics; `methodPrompts` remains the semantic source of truth.
	- Template alignment should serve future reasoning. Full redesign is justified when it makes CaTDD structure, command provenance, and safe future refactoring clearer than a small comment patch.
- Assumptions:
	- Existing `UT_designXYZ` commands are authoritative for their categories when present.
	- The current P0 Functional category classification in `cli_argument_validation.design.test.ts` remains correct.
	- This story can be planned as a documentation/process/test-redesign slice without new architecture design.
	- TypeScript is the correct target language for `cli_argument_validation.design.test.ts`.
- Open questions:
	- No blocking intent question remains before planning.
	- During planning, decide the readable CaTDD redesign level for `cli_argument_validation.design.test.ts`, including whether to preserve `TC-ARG-*` IDs exactly or replace them with a trace-equivalent US/AC/TC set.
	- During planning, decide how much of `CaTDD_designAndImplTemplate.ts` should be applied verbatim versus adapted for readability in this mature GREEN test file.
- Review result: CLEARED.

## Next Recommended Action

Run `/SPEC_takeDetailDesign` to define the concrete SPEC-to-UT routing rules, language-template selection behavior, and TypeScript test redesign approach before implementation.