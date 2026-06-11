# User Story: refactor UT_US-USER-01 under mandatory CaTDD P0 traceability

Created by `/SPEC_analyzeIssue` on 2026-06-12.
Opened by `/SPEC_openUserStory` on 2026-06-12.
Closed by `/SPEC_closeUserStory` on 2026-06-12.

## Source Trace

- [20260612-refactor-unit-testing-of-UT_US-USER-01-under-CaTDD-Issue.md](../analyzedNews/20260612-refactor-unit-testing-of-UT_US-USER-01-under-CaTDD-Issue.md)
- [README_UserStory4USER.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- [README_VerifyDesign.md](../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md)
- Related tests:
  - [UT_US-USER-01-Typical.ts](../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts)
  - [UT_US-USER-01-Edge.ts](../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts)
  - [UT_US-USER-01-Misuse.ts](../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts)
  - [UT_US-USER-01-Fault.ts](../../../codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts)
- [SPEC_designUnitTests.md](../../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md)
- [UT_designFuncTestsSkeleton.md](../../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md)
- [CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_designAndImplTemplate.ts](../../../methodPrompts/CaTDD_designAndImplTemplate.ts)

## Active Work Status

- Status: CLOSED.
- Active state: `.catdd/spec/doneUS/` completed story archive.
- Opened from: [20260612-refactor-UT_US-USER-01-P0-functional-traceability-UserStory.md](../todoUS/20260612-refactor-UT_US-USER-01-P0-functional-traceability-UserStory.md)
- Closed from: [20260612-refactor-UT_US-USER-01-P0-functional-traceability-UserStory.md](../doingUS/20260612-refactor-UT_US-USER-01-P0-functional-traceability-UserStory.md)
- Priority: P1 - affects verification design correctness and CaTDD lifecycle consistency.
- Confidence: medium-high.
- TASKs artifact: [20260612-refactor-UT_US-USER-01-P0-functional-traceability-TASKs.md](20260612-refactor-UT_US-USER-01-P0-functional-traceability-TASKs.md).
- Commit reference: `25389e6` (`impl UT_US-USER-01 with subprocess SUT boundary`).
- Verification summary: `node --test` focused suite passed (`13 pass, 0 fail`).
- Next recommended command: `/SPEC_analyzeIssue`.

## Mutual Intent Contract

### Developer Intent

- Goal: refactor the `UT_US-USER-01` unit-testing surface for `utCodeAgentCLI` so it explicitly satisfies the new CaTDD P0 Functional traceability rules.
- Why: future readers and agents must be able to audit `US-USER-01` coverage, SUT selection, and AC-to-TC mapping without relying on implicit historical context.

### CodeAgent Intent

- Goal: keep the `utCodeAgentCLI` CLI-validation behavior unchanged while making the P0 Functional test design and verification docs explicitly traceable.
- Why: the story should strengthen CaTDD auditability and lifecycle clarity, not alter the product behavior under test.

### In Scope

- Preserve `US-USER-01`, `AC-01..AC-05`, and the `utCodeAgentCLI` SUT.
- Make SUT declaration explicit in the story-linked verification surface.
- Ensure each AC has at least one TC and the P0 Functional category intent remains visible.
- Update `README_VerifyDesign.md` and related test-story comments only if needed to keep traceability explicit.

### Out of Scope

- Changing `utCodeAgentCLI` argument-validation behavior.
- Expanding the redesign to unrelated `UT_US-*` stories.
- Redefining CaTDD P0 Functional semantics or adding new slash commands.

### Success Signal

- A reviewer can inspect the story artifacts and see `utCodeAgentCLI` named as SUT, `US-USER-01` traceability preserved, each AC backed by at least one TC, and the focused Node test command still GREEN.

### Assumptions

- `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` remains the authoritative AC source.
- The TypeScript test files remain the target surface.

### Open Questions

- Does the Edge category need a real executable TC, or should the story explicitly document a traceable non-required Edge decision before completion?

## Story

As a CaTDD workflow maintainer,
I want `UT_US-USER-01` unit-test design for `utCodeAgentCLI` to satisfy mandatory P0 Functional traceability and SUT-declaration rules,
so that every `US-USER-01` acceptance criterion is backed by at least one test case and the test suite can be audited without relying on implicit comments or historical context.

## Conversation Consensus

- Scope is `US-USER-01` for `utCodeAgentCLI`, because the imported issue names `UT_US-USER-01` directly.
- Repository-wide method and command rules have been updated separately so future CaTDD design outputs must enforce US/AC/TC cardinality and SUT declaration.
- This story applies those rules to the existing `UT_US-USER-01` test design and module verification artifacts.
- `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` is the authoritative `US-USER-01` AC source.
- `utCodeAgentCLI` is the SUT for this unit-testing redesign.

## Observed Behavior

- The current `US-USER-01` verification surface maps `AC-01..AC-05` to executable `TC-ARG-*` cases, but the Edge category is documented as intentionally present with no executable TC.
- The new CaTDD method rule requires every AC to map to at least one TC and requires design output to declare the SUT explicitly in the test-file overview.
- Existing `UT_US-USER-01` test files may not all make the SUT and the full P0 Functional rule visible enough for future agents.
- Current verification docs may need to change from "Edge intentionally N/A with no TC" to an explicit AC/TC decision that is traceable under the mandatory cardinality gate.

## Expected Behavior

1. The `UT_US-USER-01` test design declares `SUT: utCodeAgentCLI` in the relevant test-file overview comments or equivalent CaTDD overview section.
2. `US-USER-01` retains traceability to authoritative `AC-01..AC-05` from `README_UserStory4USER.md`.
3. Each `AC-01..AC-05` has at least one linked TC in the redesigned test files and verification design.
4. The full P0 Functional set remains visible as Typical, Edge, Misuse, and Fault under `UT_designFuncTestsSkeleton` semantics.
5. If no valid Edge behavior exists for `US-USER-01`, the redesign records that decision without leaving a completed P0 skeleton that appears to violate the new cardinality rule.
6. Existing CLI argument-validation behavior remains unchanged and the focused Node test command stays GREEN.

## Independent Test Intent

A reviewer can inspect `UT_US-USER-01-*.ts`, `codeAgents/utCodeAgentCLI/README_VerifyDesign.md`, and the focused Node test result to confirm that `utCodeAgentCLI` is named as SUT, every authoritative AC has at least one TC, P0 Functional categories are handled deliberately, and no CLI validation behavior regressed.

## Acceptance Criteria

### AC-01: SUT is explicit in US-USER-01 UnitTesting design
- **Given** the `UT_US-USER-01` category-specific test files
- **When** a reviewer reads their CaTDD overview or design comments
- **Then** the SUT is explicitly identified as `utCodeAgentCLI`
- **And** the product code path under test is traceable to the CLI argument-validation surface.

### AC-02: Authoritative AC source is used
- **Given** `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` defines `US-USER-01` and `AC-01..AC-05`
- **When** the test design is refactored
- **Then** those ACs remain the authoritative acceptance criteria
- **And** the test design does not invent replacement ACs without an explicit trace-equivalence note.

### AC-03: Every AC has at least one TC
- **Given** the redesigned `US-USER-01` UnitTesting surface
- **When** `codeAgents/utCodeAgentCLI/README_VerifyDesign.md` or equivalent traceability comments are inspected
- **Then** each of `AC-01`, `AC-02`, `AC-03`, `AC-04`, and `AC-05` maps to at least one TC
- **And** no AC is represented only by a category placeholder.

### AC-04: P0 Functional categories are handled under CaTDD rules
- **Given** the story requires P0 Functional coverage
- **When** `UT_US-USER-01-Typical.ts`, `UT_US-USER-01-Edge.ts`, `UT_US-USER-01-Misuse.ts`, and `UT_US-USER-01-Fault.ts` are reviewed
- **Then** the files visibly follow `Typical -> Edge -> Misuse -> Fault` P0 Functional intent
- **And** the `UT_designFuncTestsSkeleton` relationship remains explicit.

### AC-05: Edge category decision is traceable and not dangling
- **Given** existing design says Edge has no executable TC for `US-USER-01`
- **When** the redesign is completed
- **Then** either at least one valid Edge TC is designed and mapped to an AC
- **Or** the Edge file/design is reclassified or marked as a non-required category in a way that does not leave a completed P0 skeleton with dangling AC/TC traceability.

### AC-06: Existing behavior remains GREEN
- **Given** the redesigned `US-USER-01` UnitTesting files
- **When** this command is run from the repository root:
  `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`
- **Then** all executable CLI argument-validation tests pass.

## Edge Cases

- A category file can exist for structural clarity, but it must not make the design look complete if it lacks required AC/TC traceability.
- If Edge truly has no valid scenario for `US-USER-01`, the story should decide whether the correct CaTDD expression is an explicit non-required category note, a documented zero-TC exception before completion, or a new valid Edge TC.
- The redesign should not reduce `TC-ARG-001..TC-ARG-012` coverage unless a trace-equivalent replacement is documented.
- Adding SUT text should not obscure the existing command provenance or category semantics.

## Scope

In scope:

- Refactor `UT_US-USER-01` category-specific UnitTesting files for mandatory CaTDD traceability and explicit SUT naming.
- Update `codeAgents/utCodeAgentCLI/README_VerifyDesign.md` if traceability, Edge handling, or SUT declaration changes.
- Preserve `US-USER-01`, `AC-01..AC-05`, and current CLI validation behavior.
- Use `methodPrompts/CaTDD_methodPrompt.md`, `CaTDD_designAndImplTemplate.ts`, `SPEC_designUnitTests`, and `UT_designFuncTestsSkeleton` as source contracts.

Out of scope:

- Changing `utCodeAgentCLI` argument-validation product behavior.
- Applying the redesign immediately to all other `UT_US-*` files.
- Redefining CaTDD P0 Functional semantics.
- Creating new slash commands.
- Reopening already closed lifecycle stories except as source trace.

## Non-Goals

- Broad repository-wide unit-test refactoring.
- Rewriting mature GREEN tests only for formatting preference.
- Treating documentation-only category placeholders as completed AC/TC coverage.
- Moving CaTDD method semantics out of `methodPrompts`.

## Risks

- A forced Edge TC may invent behavior not present in `US-USER-01`.
- Leaving Edge as a zero-TC file may conflict with the stricter method rule if not explicitly resolved.
- A full redesign could accidentally alter test assertions or weaken CLI validation.
- Duplicating method rules in test files could create drift if not referenced back to methodPrompts and slashCommands.

## Assumptions

- `US-USER-01` scope is the intended redesign scope for this story.
- The authoritative AC source is `codeAgents/utCodeAgentCLI/README_UserStory4USER.md`.
- `utCodeAgentCLI` is the SUT.
- Existing `TC-ARG-*` IDs may be preserved unless a reviewed redesign chooses an explicit trace-equivalent replacement.
- TypeScript remains the target language for these test files.

## Acceptance Questions

- For `US-USER-01`, should the Edge category receive a real valid-edge TC, or should the design explicitly mark Edge as not required for this story before completion?
- Should every `UT_US-USER-01-*.ts` file declare `SUT: utCodeAgentCLI`, or is one shared overview plus module verification design sufficient?
- Should `TC-ARG-*` IDs be preserved exactly to minimize regression risk?

## Next Recommended Action

Run `/SPEC_analyzeIssue` for pending imported work.
