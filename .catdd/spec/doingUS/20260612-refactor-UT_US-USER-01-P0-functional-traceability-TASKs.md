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
- [x] Selected next lifecycle command: `/SPEC_designUnitTests`

## Current Readiness

- Orientation: implementation-oriented UnitTesting design/refactor work.
- Readiness: story is open, mutual intent is recorded, requirement source is stable, and existing verification/test artifacts are available for focused redesign.
- Satisfied prerequisite: `US-USER-01` and `AC-01..AC-05` are already defined in [README_UserStory4USER.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md).
- Satisfied prerequisite: `utCodeAgentCLI` is the agreed SUT.
- Satisfied prerequisite: existing `UT_US-USER-01` category files and [README_VerifyDesign.md](../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md) provide the local implementation surface.
- Skipped prerequisite: no requirement-doc update is needed because this story preserves the authoritative ACs and changes the verification design/test traceability surface.
- Skipped prerequisite: no architecture or detail design update is needed because no product behavior, runtime boundary, or module dependency changes are in scope.

## Candidate Next Steps

- `/SPEC_designUnitTests` to redesign the `UT_US-USER-01` UnitTesting surface under mandatory P0 Functional traceability, explicit SUT declaration, and `UT_designFuncTestsSkeleton` semantics.
- `/SPEC_updateUserStory` only if a later review discovers that `US-USER-01` AC wording itself must change.
- `/SPEC_updateDetailDesign` only if UnitTesting design reveals a missing design contract outside the test/verification surface.
- `/SPEC_implUnitTests` after the UnitTesting design is explicit enough to edit tests safely.

## Rejected Next Steps

- `/SPEC_clearStoryIntent` because the mutual intent contract is already recorded and aligned enough for planning.
- `/SPEC_updateUserStory` because this story does not change [README_UserStory4USER.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md), `US-USER-01`, or `AC-01..AC-05`.
- `/SPEC_reviewUserStory` because there is no requirement update to review before UnitTesting design.
- `/SPEC_takeArchDesign` because the story does not introduce architecture-significant behavior.
- `/SPEC_updateArchDesign` because no existing architecture review gap is being closed.
- `/SPEC_takeDetailDesign` because the story uses existing module detail design and narrows to UnitTesting traceability.
- `/SPEC_updateDetailDesign` because no detail-design gap is known before UnitTesting design.
- `/SPEC_implUnitTests` because test edits should not start before the UnitTesting redesign records the SUT, AC/TC mapping, P0 categories, and Edge decision.
- `/SPEC_implProductCodes` because product behavior changes are out of scope.

## Selected Next Step

- [x] Next lifecycle command selected: `/SPEC_designUnitTests`.

## Rationale

The active story is not asking for new user-facing requirements or product CLI behavior. It applies already-updated CaTDD method rules to the existing `UT_US-USER-01` test and verification surface. The smallest safe next step is therefore `SPEC_designUnitTests`: it can decide the traceable Edge handling, record `SUT: utCodeAgentCLI`, preserve `AC-01..AC-05`, and prepare any later `SPEC_implUnitTests` work without jumping straight into edits.

The Edge category question is a UnitTesting design decision, not a blocker to planning. The design step must not invent new product behavior. If no valid Edge behavior is present in the authoritative AC source, the design should record a traceable non-required Edge decision that does not appear as dangling AC/TC coverage.

## Planned UnitTesting Design Checklist

- [ ] Run `/SPEC_designUnitTests` for the active story.
- [ ] Declare `SUT: utCodeAgentCLI` in the relevant `UT_US-USER-01` test design overview or equivalent shared overview.
- [ ] Preserve authoritative `US-USER-01` and `AC-01..AC-05` from [README_UserStory4USER.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md).
- [ ] Ensure each `AC-01..AC-05` maps to at least one TC.
- [ ] Preserve `TC-ARG-*` IDs unless a trace-equivalent replacement is explicitly documented.
- [ ] Make the P0 Functional category set visible: Typical, Edge, Misuse, and Fault.
- [ ] Resolve Edge handling as either a valid Edge TC or a traceable non-required Edge decision.
- [ ] Keep `UT_designFuncTestsSkeleton` provenance explicit.
- [ ] Update [README_VerifyDesign.md](../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md) if traceability, SUT declaration, or Edge handling changes.
- [ ] Keep the focused Node test command GREEN after later implementation/refactor work.

## Open Questions

- [ ] During `/SPEC_designUnitTests`, decide whether the Edge category receives a real executable TC or is documented as traceably non-required for `US-USER-01`.

## Checklist

- [x] Opened story identified.
- [x] Requirement trace documented.
- [x] Readiness assessed.
- [x] Candidate next steps compared.
- [x] Rejected next steps recorded.
- [x] Next command selected.
- [ ] UnitTesting design completed.
- [ ] UnitTesting implementation/refactor completed.
- [ ] Focused tests validated GREEN.
- [ ] Story reviewed, committed, and closed.