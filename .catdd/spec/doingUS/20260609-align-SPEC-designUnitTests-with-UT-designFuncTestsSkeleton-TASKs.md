# TASKs for align SPEC_designUnitTests with UT_designFuncTestsSkeleton for US-USER-01

- [x] Active story: [20260609-align-SPEC-designUnitTests-with-UT-designFuncTestsSkeleton-UserStory.md](20260609-align-SPEC-designUnitTests-with-UT-designFuncTestsSkeleton-UserStory.md)
- [x] Requirement source traced to analyzed issues:
  - `../analyzedNews/20260608-why-SPEC-designUnitTests-not-UT-doXYZ-in-P0-FuncTestFlow-Issue.md`
  - `../analyzedNews/20260609-refactor-US-USER-01-with-UT-designFuncTestsSkeleton-Issue.md`
- [x] Story is open in `.catdd/spec/doingUS/`
- [x] Mutual intent cleared: SPEC orchestrates story lifecycle; UT owns category-level skeleton mechanics
- [x] Requirement-oriented update needed: no module `README_UserStory.md` or paired `README_UserGuide.md` rewrite is required before planning
- [x] Requirement review needed: no separate `SPEC_reviewUserStory` gate is required before initial detail design
- [x] Architecture readiness needed: no architecture command is required for this command-boundary/test-redesign story
- [x] Detail design updated: concrete SPEC-to-UT routing rules and TypeScript test redesign approach are recorded in the active story
- [x] Verification-design location decision recorded: prefer module-local `codeAgents/utCodeAgentCLI/README_VerifyDesign.md` for module-scoped US-USER-01 content
- [x] Lifecycle command completed: `/SPEC_updateDetailDesign`
- [x] Lifecycle command completed: `/SPEC_reviewDetailDesign`
- [x] Lifecycle command completed: `/SPEC_reviewUserStory`
- [x] Lifecycle command completed: `/SPEC_designUnitTests`
- [ ] Lifecycle command pending: `/SPEC_implProductCodes`

## Current Readiness

- Orientation: design-oriented process/test-redesign work.
- Readiness: product intent and scope are clear enough for planning; implementation details are not yet safe to edit directly.
- Satisfied prerequisite: intent alignment is recorded in the active story.
- Skipped prerequisite: no requirement-doc update is needed because the story changes command contracts, flow docs, and test-file structure rather than user-facing module requirements.
- Skipped prerequisite: no architecture design is needed because this is not changing system boundaries, runtime ownership, or module dependencies.

## Candidate Next Steps

- `/SPEC_implProductCodes` to update command/flow documentation so future `SPEC_designUnitTests` executions use matching `UT_designXYZ` commands and language templates.
- `/SPEC_updateDetailDesign` again only if a later review finds missing or weak detail-design rules.
- `/SPEC_refactorIssue` only if product-code/docs implementation reveals a local quality issue after attempted GREEN.

## Rejected Next Steps

- `/SPEC_clearStoryIntent` because intent is already cleared and recorded with `Review result: CLEARED`.
- `/SPEC_updateUserStory` because no module/submodule `README_UserStory.md` or paired `README_UserGuide.md` requirement surface is currently the owned artifact.
- `/SPEC_reviewUserStory` because this step is now completed and passed.
- `/SPEC_takeArchDesign` because the story does not introduce architecture-significant boundaries or runtime design.
- `/SPEC_takeDetailDesign` because the story revises existing command/test design surfaces rather than starting from blank detail design.
- `/SPEC_reviewDetailDesign` because this step is now completed and passed.
- `/SPEC_updateDetailDesign` because the current detail design has passed review.
- `/SPEC_designUnitTests` because this step is now completed.
- `/SPEC_implUnitTests` because the existing US-USER-01 UnitTesting file is already implemented and remains GREEN after redesign.

## Selected Next Step

- [x] Next lifecycle command selected: `/SPEC_implProductCodes`.

## Rationale

This story is not a simple test-only refactor. It changes the documented behavior of `SPEC_designUnitTests`, clarifies the SPEC-vs-UT command boundary, requires language-template selection rules, and may fully redesign/reimplement a mature TypeScript GREEN test file. The updated design has passed `SPEC_reviewDetailDesign`, story/readiness review has passed, and the real `utCodeAgentCLI` TypeScript UnitTesting file has now been redesigned while staying GREEN. The next correct gate is `SPEC_implProductCodes` to update command/flow documentation.

## Unit Test Design Result

- [x] Module verification design created: `codeAgents/utCodeAgentCLI/README_VerifyDesign.md`.
- [x] P0 Functional TypeScript UnitTesting files split by category:
  - `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts`
  - `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts`
  - `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts`
  - `codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts`
- [x] Source command provenance recorded: `SPEC_designUnitTests` + `UT_designFuncTestsSkeleton`.
- [x] TypeScript template provenance recorded: `methodPrompts/CaTDD_designAndImplTemplate.ts`.
- [x] Preserved TC set: `TC-ARG-001..TC-ARG-012`.
- [x] Current TC status: GREEN.
- [x] Focused validation target: category-specific `UT_US-USER-01-*.ts` files.
- [x] Validation result: 12 executable tests passed after split; the Edge design skeleton file also loaded successfully.

## Parallel-Ready Implementation Checklist

- [x] Slice A (Typical / ValidFunc): split valid invocation success into `UT_US-USER-01-Typical.ts`.
- [x] Slice B (Edge / ValidFunc): create `UT_US-USER-01-Edge.ts` as explicit no-TC design skeleton.
- [x] Slice C (Misuse / InvalidFunc): split caller contract violations into `UT_US-USER-01-Misuse.ts`.
- [x] Slice D (Fault / InvalidFunc): split missing file dependencies into `UT_US-USER-01-Fault.ts`.
- [x] Slice E (UT provenance): record `SPEC_designUnitTests` and category-specific `UT_design*Skeleton` provenance in each UnitTesting file.
- [x] Slice F (P0 completeness): keep Typical, Edge, Misuse, and Fault skeleton sections visible, with Edge explicitly N/A for this story.
- [x] Slice G (behavior preservation): keep `TC-ARG-001..TC-ARG-012` assertions intact.
- [x] Checkpoint 1: category-specific UnitTesting files remain GREEN.
- [ ] Checkpoint 2: command/flow documentation is updated to make this behavior repeatable.

## Detail Design Questions Resolved

- [x] `SPEC_designUnitTests` discovers existing `UT_designXYZ` commands by inspecting `slashCommands/commands/**/UT_design*Skeleton.md` command contracts.
- [x] Fallback to `methodPrompts` is explicit only when no matching `UT_designXYZ` command exists and category intent is clear; otherwise ask the developer.
- [x] Generated/refactored test files record SPEC orchestration and `UT_*` category-design provenance near the design overview/skeleton sections.
- [x] `UT_US-USER-01-*.ts` should use `CaTDD_designAndImplTemplate.ts` as the TypeScript structural source, adapted for readability.
- [x] Preserve `TC-ARG-*` IDs unless a trace-equivalent mapping is explicitly documented.
- [x] Prefer moving module-scoped US-USER-01 verification design into `codeAgents/utCodeAgentCLI/README_VerifyDesign.md`.
- [x] Root `README_VerifyDesign.md` should remain only for repository-wide verification strategy or become a root index if needed.

## Detail Design Review Checklist

- [x] Review command discovery rule for existing P0/P1/P2 `UT_designXYZ` commands.
- [x] Review fallback rule when no matching `UT_designXYZ` command exists.
- [x] Review TypeScript language-template selection rule.
- [x] Review US-USER-01 test redesign guardrails.
- [x] Review module-local versus root verification design ownership rule.

## User Story Review Checklist

- [x] Review requirement clarity and scope boundaries.
- [x] Review source trace to analyzed issues.
- [x] Review acceptance criteria testability.
- [x] Review detail-design readiness transfer.
- [x] Review risk list and non-goals.

## Future Implementation Checkpoints

- [ ] Checkpoint 1: command/flow docs explain SPEC orchestration versus UT category design.
- [ ] Checkpoint 2: `SPEC_designUnitTests` contract requires matching `UT_designXYZ` command use when available.
- [x] Checkpoint 3: TypeScript test redesign uses `methodPrompts/CaTDD_designAndImplTemplate.ts` as the language template.
- [x] Checkpoint 4: `node --test codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/tests/UT_US-USER-01-Fault.ts` remains GREEN.
- [ ] Checkpoint 5: verification-design artifact ownership is explicit: module-scoped verification lives under the module; root verification design is repository-wide only when needed.
- [x] Checkpoint 6: detail design review passes before implementation or test redesign begins.
- [x] Checkpoint 7: user story review passes before test/refactor skeleton design begins.

## Checklist

- [x] Opened story identified.
- [x] Requirement trace documented.
- [x] Readiness assessed.
- [x] Candidate next steps compared.
- [x] Rejected next steps recorded.
- [x] Next command selected.
- [x] Detail design update recorded.
- [x] Detail design review passed.
- [x] User story review passed.
- [x] P0 CaTDD skeletons designed.
- [x] Module verification design updated.
- [x] UnitTesting file redesigned and validated GREEN.