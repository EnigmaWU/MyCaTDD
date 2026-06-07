# TASKs for utCodeAgentCLI USER US-USER-01 Parse and Validate CLI Arguments

- [x] Active story: [20260607-utCodeAgentCLI-US-USER-01-UserStory.md](20260607-utCodeAgentCLI-US-USER-01-UserStory.md)
- [x] Requirement source traced to module `README_UserStory.md` plus paired `README_UserGuide.md`
- [x] Story is open in `.catdd/spec/doingUS/`
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
- [ ] Next lifecycle command: `/SPEC_implProductCodes`

## Current Readiness

- Orientation: implementation-oriented work.
- Readiness: unit-test design complete for P0 Functional categories.
- Skipped prerequisite: no requirement rewrite needed.
- Skipped prerequisite: no new architecture or detail design gate is needed before the next step.

## Candidate Next Steps

- `/SPEC_implUnitTests` for the opened story.
- `/SPEC_reviewUserStory` only if the requirement slice changes.
- `/SPEC_updateUserStory` only if the module `README_UserStory.md` or `README_UserGuide.md` must change.

## Rejected Next Steps

- `/SPEC_clearStoryIntent` because the story intent is already clear from the imported slice.
- `/SPEC_updateUserStory` because the active story is a direct imported user-story slice, not a requirement-doc rewrite.
- `/SPEC_takeArchDesign` because architecture evidence already exists and this story is past initial design intake.
- `/SPEC_takeDetailDesign` because detail design evidence already exists and this story is past initial design intake.
- `/SPEC_designUnitTests` because this step is now completed for US-USER-01.

## Rationale

The active story is an imported P0 user-story slice for CLI argument validation. Requirement and design readiness were already available, so this step produced P0 CaTDD skeletons and a verification design artifact. The smallest correct next step is implementing selected PLANNED TCs in RED order via `SPEC_implUnitTests`.

## Parallel-Ready Implementation Checklist

- [x] Slice A (Typical): implemented `TC-ARG-001`, `TC-ARG-002`, `TC-ARG-003` in RED sequence.
- [x] Slice B (Edge): implemented `TC-ARG-004`, `TC-ARG-005` after Slice A stabilized.
- [x] Slice C (Misuse): implemented `TC-ARG-006`, `TC-ARG-007` after Slice A stabilized.
- [x] Slice D (Fault): implemented `TC-ARG-008` to `TC-ARG-012` after Slice A stabilized.
- [x] Checkpoint 1: stderr assertion style is consistent across Typical and Edge implemented TCs.
- [x] Checkpoint 2: AC trace tags remain intact after all P0 implementation slices.

## Post-Implementation Readiness

- [x] All P0 Functional TCs for `US-USER-01` are now in RED state.
- [x] Remaining P1/P2 coverage is intentionally deferred.
- [ ] Product-code implementation is now unblocked by test design for this story.

## Checklist

- [x] Opened story identified.
- [x] Requirement trace documented.
- [x] Readiness assessed.
- [x] Candidate next steps compared.
- [x] Rejected next steps recorded.
- [x] Next command selected.
- [x] P0 CaTDD skeletons designed.
- [x] Verification design artifact updated.