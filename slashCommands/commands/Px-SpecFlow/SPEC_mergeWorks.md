# SPEC_mergeWorks

## Purpose

Merge a closed story branch into the target integration branch when branch integration is still required.

## CoT Pattern

**Linear** — Direct execution. Given merge prerequisites and a closed story artifact, this command verifies merge readiness, performs the repository merge step, and reports merge evidence. If prerequisites are missing or conflicts are unresolved, stop and ask the developer before continuing.

## Inputs

- `closed_user_story`: completed story under `.catdd/spec/doneUS/`.
- `story_branch`: dedicated branch that contains committed story work.
- `target_branch`: integration branch to receive the story changes.
- `close_commit_ref`: commit evidence from `SPEC_closeUserStory`.
- `merge_strategy`: repository-approved merge strategy (for example merge commit, squash, or rebase policy).

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)

## Output Contract

- Merge readiness summary covering story/target branches and close evidence.
- Merge result with `merge_commit_ref` (or explicit `merge_skipped_reason` when already integrated).
- Conflict summary and resolution status when conflicts are encountered.
- Next recommended command: `SPEC_updateProjectContext` when lifecycle/project-context facts changed; otherwise `SPEC_whatsNextTask`.

## Prompt Template

Ask the assistant to verify merge prerequisites for the closed story, run the repository merge step to integrate the story branch, report merge evidence, and list any follow-up actions.

## Conflict Guard

Do not merge when `SPEC_closeUserStory` is not complete.
Do not merge without explicit source (`story_branch`) and destination (`target_branch`) branches.
Do not mark merge complete without verifiable merge evidence.
Do not continue on unresolved merge conflicts without developer confirmation.

ONE-MORE-THING: ask developer if something not sure
