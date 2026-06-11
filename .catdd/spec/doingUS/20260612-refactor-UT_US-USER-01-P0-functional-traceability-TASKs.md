# TASKs for refactor UT_US-USER-01 under mandatory CaTDD P0 traceability

- [x] Active story: [20260612-refactor-UT_US-USER-01-P0-functional-traceability-UserStory.md](20260612-refactor-UT_US-USER-01-P0-functional-traceability-UserStory.md)
- [x] Requirement source traced to [20260612-refactor-unit-testing-of-UT_US-USER-01-under-CaTDD-Issue.md](../analyzedNews/20260612-refactor-unit-testing-of-UT_US-USER-01-under-CaTDD-Issue.md)
- [x] Authoritative AC source traced to [README_UserStory4USER.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- [x] Verification design source traced to [README_VerifyDesign.md](../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md)
- [x] Story is open in `.catdd/spec/doingUS/`
- [x] Mutual intent contract recorded: strengthen CaTDD traceability and SUT visibility without changing CLI behavior
- [x] Requirement-oriented update needed: no module `README_UserStory.md` or paired `README_UserGuide.md` rewrite is required before UnitTesting design
- [x] Requirement review needed: no separate `SPEC_reviewUserStory` gate is required before UnitTesting design because authoritative ACs remain unchanged
- [x] Architecture readiness needed: no architecture command is required because this story does not change runtime boundaries, adapters, or module ownership
- [x] Detail design readiness needed: no detail-design command is required before UnitTesting design because existing architecture/detail docs already cover the CLI validation surface
- [x] Lifecycle command completed: `/SPEC_designUnitTests`
- [x] Lifecycle command completed: `/SPEC_implUnitTests`
- [x] Lifecycle command completed: `/SPEC_reviewProductCodes`
- [x] Selected next lifecycle command: `/SPEC_commitWorks`

## Current Readiness

- Orientation: implementation-oriented UnitTesting design/refactor work.
- Readiness: story is open, mutual intent is recorded, requirement source is stable, and existing verification/test artifacts are available for focused redesign.
- Satisfied prerequisite: `US-USER-01` and `AC-01..AC-05` are already defined in [README_UserStory4USER.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md).
- Satisfied prerequisite: `utCodeAgentCLI` is the agreed SUT.
- Satisfied prerequisite: existing `UT_US-USER-01` category files and [README_VerifyDesign.md](../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md) provide the local implementation surface.
- Skipped prerequisite: no requirement-doc update is needed because this story preserves the authoritative ACs and changes the verification design/test traceability surface.
- Skipped prerequisite: no architecture or detail design update is needed because no product behavior, runtime boundary, or module dependency changes are in scope.

## Candidate Next Steps

- `/SPEC_commitWorks` to checkpoint the reviewed subprocess-boundary implementation slice.
- `/SPEC_updateUserStory` only if a later review discovers that `US-USER-01` AC wording itself must change.
- `/SPEC_updateDetailDesign` only if UnitTesting design reveals a missing design contract outside the test/verification surface.
- `/SPEC_implUnitTests` only if a later review or verification failure requires another executable refactor pass.

## Rejected Next Steps

- `/SPEC_clearStoryIntent` because the mutual intent contract is already recorded and aligned enough for planning.
- `/SPEC_updateUserStory` because this story does not change [README_UserStory4USER.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md), `US-USER-01`, or `AC-01..AC-05`.
- `/SPEC_reviewUserStory` because there is no requirement update to review before UnitTesting design.
- `/SPEC_takeArchDesign` because the story does not introduce architecture-significant behavior.
- `/SPEC_updateArchDesign` because no existing architecture review gap is being closed.
- `/SPEC_takeDetailDesign` because the story uses existing module detail design and narrows to UnitTesting traceability.
- `/SPEC_updateDetailDesign` because no detail-design gap is known before UnitTesting design.
- `/SPEC_implProductCodes` because product behavior changes are out of scope.

## Selected Next Step

- [x] Next lifecycle command selected: `/SPEC_commitWorks`.

## Rationale

The active story is not asking for new user-facing requirements or product CLI behavior. It applies already-updated CaTDD method rules to the existing `UT_US-USER-01` test and verification surface. `SPEC_implUnitTests` and `SPEC_reviewProductCodes` are now complete: executable tests run the `utCodeAgentCLI` SUT as a subprocess, the minimal CLI entrypoint delegates to the validator, and focused verification remains GREEN. The smallest safe next step is therefore `SPEC_commitWorks`.

The Edge category question is resolved at design level. The authoritative AC source defines no valid boundary case, so Edge remains visible in the P0 set as a non-required category decision rather than as fake AC/TC coverage.

## Planned UnitTesting Design Checklist

- [x] Run `/SPEC_designUnitTests` for the active story.
- [x] Declare `SUT: utCodeAgentCLI` in the relevant `UT_US-USER-01` test design overview or equivalent shared overview.
- [x] Preserve authoritative `US-USER-01` and `AC-01..AC-05` from [README_UserStory4USER.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md).
- [x] Ensure each `AC-01..AC-05` maps to at least one TC.
- [x] Preserve `TC-ARG-*` IDs unless a trace-equivalent replacement is explicitly documented.
- [x] Make the P0 Functional category set visible: Typical, Edge, Misuse, and Fault.
- [x] Resolve Edge handling as a traceable non-required Edge decision.
- [x] Keep `UT_designFuncTestsSkeleton` provenance explicit.
- [x] Update [README_VerifyDesign.md](../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md) for traceability, SUT declaration, and Edge handling.
- [x] Keep the focused Node test command GREEN after design-surface updates.

## Open Questions

- [x] During `/SPEC_designUnitTests`, decide that Edge is documented as traceably non-required for `US-USER-01`.

## Checklist

- [x] Opened story identified.
- [x] Requirement trace documented.
- [x] Readiness assessed.
- [x] Candidate next steps compared.
- [x] Rejected next steps recorded.
- [x] Next command selected.
- [x] UnitTesting design completed.
- [x] UnitTesting implementation/refactor completed.
- [x] Focused tests validated GREEN.
- [x] Product code review completed.
- [ ] Story reviewed, committed, and closed.