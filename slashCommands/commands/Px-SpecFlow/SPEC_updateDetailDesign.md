# SPEC_updateDetailDesign

## Purpose

Revise detailed design and acceptance criteria after story review, implementation feedback, or quality failure.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect review feedback and the existing design artifacts, reason about the minimum change needed to address the finding without hiding it, apply the revision, and verify that the updated design resolves the finding and preserves traceability. If the feedback reveals new requirements, the reasoning loop routes to a new work item instead of widening scope.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `detail_design`: project-root README detail design file or active story design section to update.
- `readme_spec_files`: optional project-root `README*` SPEC files to create or update using matching `slashCommands/templates/README_*Template.md` files when first created, including `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, or `README_DiagnosisDesign.md` when feedback changes error, resource, state, performance, compatibility, or diagnosis design.
- `review_feedback`: findings from story, code, test, or CI review.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated design and acceptance criteria in team-shared `.catdd/spec/doingUS/` work state or team-shared project-root README SPEC docs.
- Updated `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, or `README_VerifyDesign.md` when the feedback changes module, error, resource, state, performance, compatibility, diagnosis, or verification design.
- Review-feedback checklist showing what was addressed.
- Remaining risks and next recommended command.
- Next recommended command after any update is `SPEC_reviewDetailDesign` so updated design is always re-gated before downstream steps.

## Prompt Template

Ask the assistant to make the minimum design change needed to address feedback while preserving traceability.

## Conflict Guard

Do not hide unresolved quality failures. Keep them visible until a later review passes.
Never bypass `SPEC_reviewDetailDesign` after this update step.

ONE-MORE-THING: ask developer if something not sure
