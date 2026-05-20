# SPEC_updateDetailDesign

## Purpose

Revise detailed design and acceptance criteria after story review, implementation feedback, or quality failure.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `detail_design`: project-root README detail design file or active story design section to update.
- `readme_spec_files`: optional project-root `README*` SPEC files to create or update.
- `review_feedback`: findings from story, code, test, or CI review.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated design and acceptance criteria in local gitignored `.catdd/spec/doingUS/` work state or team-shared project-root README SPEC docs.
- Updated `README_DetailDesign.md` or `README_VerifyDesign.md` when the feedback changes module design or verification design.
- Review-feedback checklist showing what was addressed.
- Remaining risks and next recommended command.

## Prompt Template

Ask the assistant to make the minimum design change needed to address feedback while preserving traceability.

## Conflict Guard

Do not hide unresolved quality failures. Keep them visible until a later review passes.

ONE-MORE-THING: ask developer if something not sure
