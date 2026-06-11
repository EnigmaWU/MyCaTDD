# User Story: align SPEC_designUnitTests with UT_designFuncTestsSkeleton for US-USER-01

Created by `/SPEC_analyzeIssue` on 2026-06-09.
Merged analysis from two related pending issues:

- `.catdd/spec/analyzedNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md`
- `.catdd/spec/analyzedNews/20260609-refactor-US-USER-01-with-UT-designFuncTestsSkeleton-Issue.md`

## Source Trace

- Raw issue archive: [../analyzedNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md](../analyzedNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md)
- Raw issue archive: [../analyzedNews/20260609-refactor-US-USER-01-with-UT-designFuncTestsSkeleton-Issue.md](../analyzedNews/20260609-refactor-US-USER-01-with-UT-designFuncTestsSkeleton-Issue.md)
- Related test files:
	- [../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts](../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts)
	- [../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts](../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts)
	- [../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts](../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts)
	- [../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts](../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts)
- Related command: [../../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md](../../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md)
- Related command: [../../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md](../../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md)
- Related template: [../../../methodPrompts/CaTDD_designAndImplTemplate.ts](../../../methodPrompts/CaTDD_designAndImplTemplate.ts)

## Active Work Status

- Status: OPEN.
- Active state: `.catdd/spec/doingUS/` active work in progress.
- Priority: P2 - improves process clarity, CaTDD consistency, and maintainability.
- Confidence: high.
- Next recommended command: `/SPEC_implProductCodes`.

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
- The former combined test file was valid CaTDD and GREEN, but it did not visibly follow the fuller `CaTDD_designAndImplTemplate.ts` structure or the category-specific `UT_<US>-<Category>.ts` UnitTesting file style.
- The existing UnitTesting surface did not state that P0 Functional skeleton design should be understood as coming from `UT_designFuncTestsSkeleton` under `SPEC_designUnitTests` orchestration.
- In this story, refactor may mean fully redesigning and reimplementing the UnitTesting surface into category-specific TypeScript files so it fully follows CaTDD, as long as externally verified CLI validation behavior and acceptance coverage are preserved.
- The current target test files are TypeScript, so CaTDD redesign should use the TypeScript design+implementation template instead of a C++ template shape.

## Expected Behavior

1. Flow documentation clearly explains that `SPEC_designUnitTests` is the story-level orchestration command and `UT_designFuncTestsSkeleton` is the P0 Functional skeleton-design command it may delegate to or require.
2. `SPEC_designUnitTests` documentation makes the SPEC-to-UT handoff explicit enough that future agents detect and use matching P0/P1/P2 `UT_designXYZ` commands before drafting category skeletons directly.
3. `SPEC_designUnitTests` records or preserves which `UT_designXYZ` command produced each category skeleton when that command exists.
4. `US-USER-01` CLI validation UnitTesting files may be fully redesigned and reimplemented using the correct language-specific CaTDD design+implementation template, while preserving the same intended CLI validation behavior and coverage.
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

### AC-04: US-USER-01 UnitTesting files fully follow CaTDD without behavior loss
- **Given** `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts`, `UT_US-USER-01-Edge.ts`, `UT_US-USER-01-Misuse.ts`, and `UT_US-USER-01-Fault.ts`
- **When** the files are refactored, redesigned, or reimplemented for CaTDD template/process clarity
- **Then** they fully follow the agreed CaTDD design+implementation structure using the TypeScript template appropriate for `.ts` test files
- **And** it preserves existing `TC-ARG-001..TC-ARG-012` intended behavior and categories, or replaces them only with an explicitly trace-equivalent US/AC/TC set
- **And** it visibly links the P0 Functional skeleton set to `UT_designFuncTestsSkeleton` or its equivalent command contract.

### AC-05: Correct language template is selected
- **Given** a target test file language or extension
- **When** `SPEC_designUnitTests` or downstream refactor work creates or redesigns a test file
- **Then** it selects the matching CaTDD design+implementation template for that language when one exists
- **And** for `UT_US-USER-01-*.ts`, it uses `methodPrompts/CaTDD_designAndImplTemplate.ts` as the template reference.

### AC-06: Existing CLI validation tests remain green
- **Given** the refactored `US-USER-01` category-specific UnitTesting files
- **When** `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts` is run
- **Then** all existing tests pass.

## Edge Cases

- `UT_designFuncTestsSkeleton` is design-only and must not be treated as responsible for executable implementation bodies.
- Refactoring a GREEN test file may become full redesign+reimplementation, but it must not reduce behavior coverage or loosen verification without an explicit product reason.
- Template alignment should not add noise that makes the test file harder to maintain.

## Scope

In scope:

- Clarify SPEC-vs-UT command boundary in relevant flow/command docs.
- Update `SPEC_designUnitTests` so it explicitly discovers and uses matching P0/P1/P2 `UT_designXYZ` command contracts when they exist.
- Refactor, redesign, or reimplement the `US-USER-01` category-specific UnitTesting files so they fully follow CaTDD design+implementation intent and expose the `UT_designFuncTestsSkeleton` relationship.
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
	- Keep `US-USER-01` behavior unchanged while making the CLI validation UnitTesting files visibly express the SPEC-to-UT design handoff using the correct TypeScript CaTDD template.
- CodeAgent intent:
	- Update flow/command documentation so future agents understand that `SPEC_designUnitTests` selects category needs and delegates category skeleton design to matching `UT_*` commands.
	- Refactor may include full redesign and reimplementation into `UT_US-USER-01-Typical.ts`, `UT_US-USER-01-Edge.ts`, `UT_US-USER-01-Misuse.ts`, and `UT_US-USER-01-Fault.ts` so they fully follow CaTDD using `CaTDD_designAndImplTemplate.ts`; do not change validator behavior, and preserve or explicitly trace-equate the existing verification intent.
	- Preserve CaTDD category semantics from `methodPrompts` and do not invent new command names such as `UT_doXYZ` as part of this story.
- In scope:
	- Clarify the SPEC-vs-UT boundary in `slashCommands/flows/Px-SpecFlow.md`, `slashCommands/flows/P0-FuncTestsFlow.md`, and `slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md` as needed.
	- Define a clear category routing rule: needed category set -> matching `UT_designXYZ` command -> produced skeleton trace.
	- Make the US-USER-01 category-specific UnitTesting files fully follow the TypeScript CaTDD design+implementation template and show that their P0 Functional skeleton set corresponds to `UT_designFuncTestsSkeleton`, while preserving `TC-ARG-*` behavior coverage or an explicitly equivalent replacement.
	- Keep the category-specific tests GREEN with `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`.
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
	- `UT_US-USER-01-*.ts` files remain traceable to `US-USER-01`, `AC-01..AC-05`, and `TC-ARG-001..TC-ARG-012` or an explicitly trace-equivalent replacement, use `CaTDD_designAndImplTemplate.ts` as the language template, and also expose the `UT_designFuncTestsSkeleton` relationship.
	- The CLI validation test command remains GREEN after the refactor.
- Insights:
	- The core bug is not that the existing test file lacks CaTDD tags; it has the minimum CaTDD skeleton. The deeper process gap is that the orchestration command allowed agents to obscure which category-design command owned the skeleton shape.
	- The repair should strengthen command boundaries rather than duplicate method semantics: `SPEC_*` decides lifecycle and needed categories; `UT_*` owns category-specific design mechanics; `methodPrompts` remains the semantic source of truth.
	- Template alignment should serve future reasoning. Full redesign is justified when it makes CaTDD structure, command provenance, and safe future refactoring clearer than a small comment patch.
- Assumptions:
	- Existing `UT_designXYZ` commands are authoritative for their categories when present.
	- The current P0 Functional category classification across `UT_US-USER-01-*.ts` remains correct.
	- This story can be planned as a documentation/process/test-redesign slice without new architecture design.
	- TypeScript is the correct target language for `UT_US-USER-01-*.ts`.
- Open questions:
	- No blocking intent question remains before planning.
	- During planning, decide the readable CaTDD redesign level for `UT_US-USER-01-*.ts`, including whether to preserve `TC-ARG-*` IDs exactly or replace them with a trace-equivalent US/AC/TC set.
	- During planning, decide how much of `CaTDD_designAndImplTemplate.ts` should be applied verbatim versus adapted for readability in this mature GREEN test file.
- Review result: CLEARED.

## Detail Design Update

Updated by `/SPEC_updateDetailDesign` on 2026-06-10.

### Review Feedback Addressed

- Feedback: this story is not initial blank-slate design; it updates existing command/test design surfaces, so `SPEC_updateDetailDesign` is the better lifecycle command than `SPEC_takeDetailDesign`.
- Feedback: `SPEC_designUnitTests` should detect existing P0/P1/P2 `UT_designXYZ` commands and use the matching category command before falling back to direct `methodPrompts` drafting.
- Feedback: the `US-USER-01` UnitTesting files are TypeScript and should use the TypeScript CaTDD design+implementation template when fully redesigned.
- Feedback: module-scoped verification design should be considered for module-local ownership instead of project-root `README_VerifyDesign.md` ownership.

### Existing Design Surfaces To Revise Later

- `slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md`: update command contract so category routing and language-template selection are mandatory design behavior.
- `slashCommands/flows/Px-SpecFlow.md`: clarify story-level SPEC orchestration versus category-level UT mechanics without overwriting unrelated active edits.
- `slashCommands/flows/P0-FuncTestsFlow.md`: clarify that `UT_designFuncTestsSkeleton` owns full P0 Functional skeleton design and remains design-only.
- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-*.ts`: redesign/reimplement with TypeScript CaTDD template provenance while preserving CLI validation behavior.
- Verification design ownership: decide whether US-USER-01 module-scoped content moves from root `README_VerifyDesign.md` to `codeAgents/utCodeAgentCLI/README_VerifyDesign.md`.

### UT Design Command Discovery Rule

- `SPEC_designUnitTests` must inspect available `slashCommands/commands/**/UT_design*Skeleton.md` command contracts before drafting skeletons.
- If the active story requires the full P0 Functional set, use `UT_designFuncTestsSkeleton`.
- If the active story requires only one P0 category, use the matching command: `UT_designTypicalSkeleton`, `UT_designEdgeSkeleton`, `UT_designMisuseSkeleton`, or `UT_designFaultSkeleton`.
- If the active story requires P1 Design categories, use the matching existing commands: `UT_designStateSkeleton`, `UT_designCapabilitySkeleton`, or `UT_designConcurrencySkeleton`.
- If the active story requires P2 Quality categories, use the matching existing commands: `UT_designPerformanceSkeleton`, `UT_designRobustSkeleton`, `UT_designCompatibilitySkeleton`, or `UT_designConfigurationSkeleton`.
- If no matching `UT_designXYZ` command exists, record the missing command as an explicit gap and fall back to category `methodPrompts` only when category intent is clear; otherwise ask the developer.

### Language Template Selection Rule

- `SPEC_designUnitTests` and downstream refactor work must infer the target test language from the target path or explicit target metadata.
- When a matching language-specific CaTDD design+implementation template exists, use that template as the structural source.
- For `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-*.ts`, use `methodPrompts/CaTDD_designAndImplTemplate.ts`.
- Do not apply `CaTDD_designAndImplTemplate.cxx` or C++-specific examples as the structural source for TypeScript tests when the TypeScript template exists.

### Generated Test Provenance Rule

- Generated or redesigned test files should record the orchestrating SPEC command and the category-level UT command used for skeleton design.
- For this story, the redesigned category-specific UnitTesting files should show that P0 Functional skeleton design is governed by `UT_designFuncTestsSkeleton` under `SPEC_designUnitTests` orchestration.
- Source-command provenance must not replace US/AC/TC traceability; it supplements it.

### US-USER-01 Test Redesign Rule

- A full redesign/reimplementation into `UT_US-USER-01-Typical.ts`, `UT_US-USER-01-Edge.ts`, `UT_US-USER-01-Misuse.ts`, and `UT_US-USER-01-Fault.ts` is allowed.
- The redesign must preserve `US-USER-01`, `AC-01..AC-05`, and `TC-ARG-001..TC-ARG-012` behavior coverage unless an explicitly trace-equivalent replacement is documented.
- The executable validation command is `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`.
- The file should be easier for future agents to reason about, not merely more verbose.

### Verification Design Ownership Rule

- Module-scoped verification strategy and US/AC/TC traceability should live under the owning module when the story is module-specific.
- For existing US-USER-01 content, prefer `codeAgents/utCodeAgentCLI/README_VerifyDesign.md` as the owning module-level verification design artifact.
- Root `README_VerifyDesign.md` should be retained only for repository-wide verification strategy or reduced to an index if no root-level verification strategy exists.

### Updated Acceptance Detail

- AC-01 is satisfied by documentation that clearly says SPEC commands orchestrate lifecycle/story decisions and UT commands own category mechanics.
- AC-02 and AC-03 are satisfied only if `SPEC_designUnitTests` requires matching `UT_designXYZ` command use when available and documents fallback behavior.
- AC-04 and AC-05 are satisfied only if the TypeScript test redesign uses `CaTDD_designAndImplTemplate.ts` as the language template source.
- AC-06 is satisfied only after the existing CLI validation test command remains GREEN.

### Remaining Risks Before Implementation

- `slashCommands/flows/Px-SpecFlow.md` already has unrelated uncommitted edits; implementation must inspect and preserve them before patching that file.
- A full test redesign can hide behavior drift unless every old `TC-ARG-*` case is mapped to preserved or trace-equivalent coverage.
- Moving or splitting `README_VerifyDesign.md` can create broken links unless references are updated deliberately.

### Review Feedback Checklist

- [x] Lifecycle command corrected from initial detail design to follow-up detail design revision.
- [x] UT command discovery rule defined.
- [x] Language-template selection rule defined.
- [x] Generated-test provenance rule defined.
- [x] US-USER-01 redesign guardrails defined.
- [x] Verification-design ownership rule defined.
- [x] Design review passed via `/SPEC_reviewDetailDesign`.

## Detail Design Review Result

Reviewed by `/SPEC_reviewDetailDesign` on 2026-06-10.

- Review finding: PASS.
- Boundary check: PASS. The update preserves `SPEC_*` as lifecycle orchestration, `UT_*` as category-level mechanics, and `methodPrompts` as semantic source of truth.
- API/state check: PASS. The affected surfaces are command contracts, flow docs, and test-file structure rather than runtime APIs or state machines; no new runtime state model is required.
- Constraint check: PASS. Error/resource/performance/compatibility concerns are not impacted by the documentation/process/test-redesign scope.
- Quality continuity check: PASS. Existing utCodeAgentCLI architecture delegation rules remain intact: CaTDD semantics stay delegated to `methodPrompts/` and `slashCommands/`.
- Testability check: PASS. AC-01..AC-06 are independently verifiable through doc inspection and `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`.
- Remaining implementation caution: preserve unrelated active edits in `slashCommands/flows/Px-SpecFlow.md` before applying this story's flow-doc updates.

## User Story Review Result

Reviewed by `/SPEC_reviewUserStory` on 2026-06-10.

- Review finding: PASS.
- Requirement clarity: PASS. The story clearly distinguishes SPEC lifecycle orchestration, UT category-level design mechanics, and methodPrompts semantic ownership.
- Traceability: PASS. The story traces to two analyzed raw issues and names the affected command, flow, template, and test-file surfaces.
- Acceptance criteria quality: PASS. AC-01..AC-06 are independently testable through documentation inspection, command-contract inspection, file-structure review, and `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`.
- Scope control: PASS. The story excludes product behavior changes, P0 category redefinition, new `UT_doXYZ` invention, and acceptance coverage reduction.
- Usage/design consistency: PASS. The detail design update already gates the SPEC-to-UT routing, language-template selection, provenance, and verification-design ownership decisions.
- Remaining implementation caution: preserve existing user edits in `slashCommands/flows/Px-SpecFlow.md` before patching that file.

## Unit Test Design Output

Designed by `/SPEC_designUnitTests` on 2026-06-10.

- Category source command: `UT_designFuncTestsSkeleton` for the full P0 Functional skeleton set.
- Language template source: `methodPrompts/CaTDD_designAndImplTemplate.ts` for TypeScript test redesign.
- Module verification design: `codeAgents/utCodeAgentCLI/README_VerifyDesign.md`.
- Redesigned UnitTesting files:
	- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts`
	- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts`
	- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts`
	- `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`
- Preserved TC set: `TC-ARG-001..TC-ARG-012`.
- Current TC status: GREEN.
- Focused validation command: `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`.
- Validation result: 12 executable tests passed after split; the Edge design skeleton file also loaded successfully.

## Product Code Implementation Result

Implemented by `/SPEC_implProductCodes` on 2026-06-11.

- Updated `slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md` so the command contract requires inspecting existing `UT_design*Skeleton` command contracts before drafting category skeletons directly.
- Added category-command routing rules for full P0 Functional, individual P0 categories, P1 Design categories, and P2 Quality categories.
- Added explicit fallback behavior: record the missing `UT_designXYZ` command as a gap, use `methodPrompts` only when category intent is clear, and ask the developer when intent is unclear.
- Added language-template selection and provenance rules so target-language CaTDD design+implementation templates are used when available.
- Updated `slashCommands/flows/Px-SpecFlow.md` to clarify SPEC lifecycle orchestration versus UT category-design mechanics and to show the `SPEC_designUnitTests` handoff to matching `UT_designXYZ` contracts.
- Updated `slashCommands/flows/P0-FuncTestsFlow.md` to clarify that `UT_designFuncTestsSkeleton` owns full P0 skeleton design and remains design-only.
- Verification: `bash scripts/test_slashcommands_complete.sh` passed.

## Product Code Review Result

Reviewed by `/SPEC_reviewProductCodes` on 2026-06-11.

- Review finding: PASS.
- Correctness check: PASS. `SPEC_designUnitTests.md` now requires matching `UT_design*Skeleton` command contract inspection before direct skeleton drafting and records the fallback rule when no matching command exists.
- Traceability check: PASS. The implementation maps to AC-01 through AC-03 and preserves the AC-04 through AC-06 UnitTesting evidence from the split `UT_US-USER-01-*.ts` files.
- Scope check: PASS. The changes are limited to command/flow documentation and lifecycle records; no CLI validator behavior or CaTDD category semantics changed.
- Minimality check: PASS. The patch updates the controlling command contract and the two relevant flow docs without adding new command names or unrelated behavior.
- Verification evidence: `bash scripts/test_slashcommands_complete.sh`, `bash scripts/test_documentation_contract.sh`, `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`, and `git diff --check` passed.
- Review note: the imported pending issue `20260611-add-emoji-to-designAndImplTemplate-key-states-Issue.md` is unrelated to this product-code review scope and remains pending for later `/SPEC_analyzeIssue`.

## Commit Works Result

Prepared by `/SPEC_commitWorks` on 2026-06-11.

- Commit scope: command/flow documentation for `SPEC_designUnitTests`, active story/TASK lifecycle records, and `.catdd/spec/projectContext.md`.
- Excluded from this commit: unrelated pending issue `.catdd/spec/pendingNews/20260611-add-emoji-to-designAndImplTemplate-key-states-Issue.md`.
- Verification summary: `bash scripts/test_slashcommands_complete.sh`, `bash scripts/test_documentation_contract.sh`, split `UT_US-USER-01-*.ts` tests, and `git diff --check` passed before commit.

## Next Recommended Action

Run `/SPEC_closeUserStory` to move the active story and TASKs to `doneUS/` after the reviewed commit is created.
