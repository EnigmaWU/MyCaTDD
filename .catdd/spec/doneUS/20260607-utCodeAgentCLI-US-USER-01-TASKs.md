# TASKs for utCodeAgentCLI USER US-USER-01 Parse and Validate CLI Arguments

- [x] Active story: [20260607-utCodeAgentCLI-US-USER-01-UserStory.md](20260607-utCodeAgentCLI-US-USER-01-UserStory.md)
- [x] Requirement source traced to module `README_UserStory.md` plus paired `README_UserGuide.md`
- [x] Story is closed in `.catdd/spec/doneUS/`
- [x] Requirement-oriented update needed: no, the imported story already carries the current requirement slice
- [x] Requirement review needed: no additional `SPEC_reviewUserStory` gate is required for this imported story slice
- [x] Architecture readiness present: `codeAgents/utCodeAgentCLI/README_ArchDesign.md`
- [x] Detail design readiness present: `codeAgents/utCodeAgentCLI/README_DetailDesign.md`
- [x] Prior design reviews already recorded in project context
- [x] Verification design created: `README_VerifyDesign.md`
- [x] P0 test skeleton file created: `codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts`
- [x] Open questions remain only if implementation discovers mismatch in argument contract details
- [x] Lifecycle command completed: `/SPEC_designUnitTests`
- [x] Lifecycle command completed: `/SPEC_implUnitTests` for P0 Functional slices
- [x] Lifecycle command completed: `/SPEC_implProductCodes`
- [x] Lifecycle command completed: `/SPEC_refactorIssue` (runtime wiring fix)
- [x] Lifecycle command completed: `/SPEC_reviewProductCodes` (pass)
- [x] Lifecycle command completed: `/SPEC_commitWorks`
- [x] Lifecycle command completed: `/SPEC_closeUserStory`
- [ ] Next lifecycle command: `/SPEC_analyzeIssue`

## Current Readiness

- Orientation: implementation-oriented work.
- Readiness: P0 unit-test implementation and product-code implementation are complete for review.
- Skipped prerequisite: no requirement rewrite needed.
- Skipped prerequisite: no new architecture or detail design gate is needed before the next step.

## Candidate Next Steps

- `/SPEC_reviewProductCodes` for the opened story.
- `/SPEC_refactorIssue` only if review finds quality or scope defects.
- `/SPEC_commitWorks` only after product-code review passes.

## Rejected Next Steps

- `/SPEC_clearStoryIntent` because the story intent is already clear from the imported slice.
- `/SPEC_updateUserStory` because the active story is a direct imported user-story slice, not a requirement-doc rewrite.
- `/SPEC_takeArchDesign` because architecture evidence already exists and this story is past initial design intake.
- `/SPEC_takeDetailDesign` because detail design evidence already exists and this story is past initial design intake.
- `/SPEC_designUnitTests` because this step is now completed for US-USER-01.

## Rationale

The active story is an imported P0 user-story slice for CLI argument validation. Requirement and design readiness were already available, then P0 CaTDD tests were implemented to RED state and product validator code was added in batch mode. The smallest correct next step is `SPEC_reviewProductCodes` before any commit/close transition.

## Parallel-Ready Implementation Checklist

- [x] Slice A (Typical / ValidFunc): implemented `TC-ARG-005` as the valid dispatch-readiness path.
- [x] Slice B (Misuse / InvalidFunc): implemented `TC-ARG-001` to `TC-ARG-004`, plus `TC-ARG-006` and `TC-ARG-007`, for caller contract violations.
- [x] Slice C (Fault / InvalidFunc): implemented `TC-ARG-008` to `TC-ARG-012` for deterministic missing file-path checks.
- [x] Checkpoint 1: stderr assertion style is consistent across Misuse and Fault implemented TCs.
- [x] Checkpoint 2: AC trace tags remain intact after all P0 implementation slices.

## Post-Implementation Readiness

- [x] All P0 Functional TCs for `US-USER-01` are now in RED state.
- [x] Remaining P1/P2 coverage is intentionally deferred.
- [x] Product-code implementation is now unblocked by test design for this story.

## Product Code Implementation Result

- [x] Production validator implemented: `codeAgents/utCodeAgentCLI/src/cli/invocationValidator.ts`.
- [x] Test-to-product wiring updated: `codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts` now calls module validator.
- [x] Traceability preserved: implementation covers AC-01..AC-05 via TC-ARG-001..TC-ARG-012 assertions.
- [x] Static verification completed: file diagnostics clean and `git diff --check` clean.
- [x] Runtime verification executed: `node --test codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts`.

## Product Code Review Result

- [x] Previous review status: FAIL (runtime module resolution issue).
- [x] Refactor resolution applied: validator module export mode aligned with test runtime loading.
- [x] Verification rerun: `node --test codeAgents/utCodeAgentCLI/tests/cli_argument_validation.design.test.ts` passed (12/12).
- [x] Final review decision: PASS for current story scope.
- [x] Route decision: continue to `SPEC_commitWorks`.

## Close Normalization Result

- [x] Done artifact normalized after CaTDD category review: `TC-ARG-005` is Typical/ValidFunc; missing required args, unknown `--behave`, and exclusive-pair conflicts are Misuse/InvalidFunc; missing file-path checks remain Fault/InvalidFunc.
- [x] Latest supporting commit: `90268f7`.
- [x] Next command selected after closure: `/SPEC_analyzeIssue`.

## Checklist

- [x] Opened story identified.
- [x] Requirement trace documented.
- [x] Readiness assessed.
- [x] Candidate next steps compared.
- [x] Rejected next steps recorded.
- [x] Next command selected.
- [x] P0 CaTDD skeletons designed.
- [x] Verification design artifact updated.