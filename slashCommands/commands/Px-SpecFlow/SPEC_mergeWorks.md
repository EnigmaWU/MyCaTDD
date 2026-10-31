# SPEC_mergeWorks

## Purpose

Merge a closed story branch into the target integration branch when branch integration is still required.

## CoT Pattern

**Linear** — Direct execution. Given merge prerequisites and a closed story artifact, this command verifies merge readiness, performs the repository merge step, and reports merge evidence. If prerequisites are missing or conflicts are unresolved, stop and ask the developer before continuing.

### Linear Execution

Run these steps once, in order. There is no retry loop; missing prerequisites or unresolved conflicts stop and ask the developer.

1. Verify `SPEC_closeUserStory` completed and `close_commit_ref` is present. Stop if not.
2. Verify both `story_branch` and `target_branch` are named explicitly. Do not infer either.
3. Check whether the story branch is already integrated. If so, check the integrated project for identity collisions before reporting `merge_skipped_reason`.
4. Compare registered Story ID/StoryIdAlias/CreatedAt mappings and qualified child IDs across both branches using [Project-Wide Traceability IDs](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids). Check alias collisions as well as AC/TP/TC ownership and coverage links in the integrated project. Distinguish shared history and declared slices from independent definitions; stop and ask on conflicting identities instead of silently renaming an accepted alias.
5. Merge using the repository-approved `merge_strategy`.
6. On conflicts, stop and report them; do not resolve without developer confirmation.
7. Recheck the integrated project registry and story/AC/TP/TC declarations. If identities conflict or cannot be reconciled, report the merge as blocked for traceability and ask the developer; never silently renumber accepted IDs.
8. Report `merge_commit_ref` and the next command: `SPEC_updateProjectContext` when lifecycle or project-context facts changed, otherwise `SPEC_whatsNextTask`.

### Worked Example

A closed story still lives on its own branch:

```text
/SPEC_mergeWorks
closed_user_story: .catdd/spec/doneUS/20260904-payment-retry-UserStory.md
story_branch: feat/payment-retry
target_branch: main
close_commit_ref: 9f8e7d6
merge_strategy: merge commit (--no-ff)
```

Expected result:

1. Close complete, `close_commit_ref` present → check passes.
2. Both branches named explicitly → check passes.
3. `feat/payment-retry` is not yet an ancestor of `main` → merge is required, not skipped.
4. Branch registries and story declarations have no conflicting independent identities.
5. Merged with `--no-ff` per repository policy.
6. No Git conflicts.
7. Integrated registry and qualified child IDs reconcile without collisions.
8. Reported: `merge_commit_ref = 4c3b2a1`; the story changed no project-wide rule, so `next_command = SPEC_whatsNextTask`.

## Inputs

- `closed_user_story`: completed story under `.catdd/spec/doneUS/`.
- `story_branch`: dedicated branch that contains committed story work.
- `target_branch`: integration branch to receive the story changes.
- `close_commit_ref`: commit evidence from `SPEC_closeUserStory`.
- `merge_strategy`: repository-approved merge strategy (for example merge commit, squash, or rebase policy).

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [Project-Wide Traceability IDs](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids)

## Output Contract

- Merge readiness summary covering story/target branches and close evidence.
- Merge result with `merge_commit_ref` (or explicit `merge_skipped_reason` when already integrated).
- Conflict summary and resolution status when conflicts are encountered.
- Identity reconciliation evidence for the integrated project, including any unresolved collisions and their owning sources.
- Next recommended command: `SPEC_updateProjectContext` when lifecycle/project-context facts changed; otherwise `SPEC_whatsNextTask`.

## Conflict Guard

Do not merge when `SPEC_closeUserStory` is not complete.
Do not merge without explicit source (`story_branch`) and destination (`target_branch`) branches.
Do not mark merge complete without verifiable merge evidence.
Do not report identity reconciliation as complete while independent Story or qualified child IDs collide or their ownership is ambiguous.
Do not continue on unresolved merge conflicts without developer confirmation.

ONE-MORE-THING: ask developer if something not sure
