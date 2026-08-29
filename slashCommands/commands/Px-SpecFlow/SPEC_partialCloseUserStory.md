# SPEC_partialCloseUserStory

## Purpose

Partially close an active user story by separating the accepted scope from the rejected or intentionally deferred scope, preserving the rejected slice in the abort lane and closing the accepted slice with traceability.

This command is the explicit bridge between `SPEC_closeUserStory` and `SPEC_abortUserStory`: it does not abandon the whole story, but does not pretend every unresolved concern is still valid.

## CoT Pattern

**Linear** — Direct execution. Given an active user story, an accepted-scope summary, and a rejected-scope summary with explicit reasons, this command moves accepted work to the close lane and moves rejected work to the abort lane while preserving evidence, trace links, and the story's original rationale.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `doing_tasks_file`: optional active `.catdd/spec/doingUS/*-UserStory-Tasks.md` artifact paired with the story.
- `accepted_scope`: structured summary of what remains valid and should be closed.
  - Required structure:
    - `accepted_summary`: concise description of the work that still meets product intent.
    - `accepted_evidence`: files, checks, commit refs, or verification mentions proving the accepted slice is ready.
    - `accepted_next_step`: optional follow-up action for the accepted slice if not already complete.
- `rejected_scope`: structured summary of what is intentionally not carried forward.
  - Required structure:
    - `rejected_summary`: concise description of the rejected or deferred scope.
    - `rejection_reason`: one of `scope-gap | assumption-gap | design-gap | implementation-gap | quality-gap`.
    - `evidence_refs`: source files, notes, reviews, or test evidence showing why the rejected slice is not acceptable as-is.
    - `followup_intent`: one of `SPEC_analyzeAbortedUserStory | SPEC_importIssue | undecided`.
- `project_user_stories_doc`: project-root `README_UserStories.md` ledger to synchronize the accepted done state and rejected abort state.
- `commit_ref`: optional completed commit for the accepted slice.
- `ci_summary`: optional CI or verification summary for the accepted slice.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)

## Output Contract

- A `.catdd/spec/doneUS/*-UserStory.md` artifact for the accepted scope once the accepted slice is verified.
- A `.catdd/spec/abortUS/*-UserStory.md` artifact for the rejected scope with preserved reasoning and evidence.
- A paired `.catdd/spec/doneUS/*-UserStory-Tasks.md` artifact when the accepted slice was planned via `SPEC_makePlan`.
- A paired `.catdd/spec/abortUS/*-UserStory-Tasks.md` artifact when the rejected slice was planned via `SPEC_makePlan`.
- Lane normalization guarantee:
  - the accepted slice must not remain in `.catdd/spec/doingUS/` after the close.
  - the rejected slice must not remain active in `.catdd/spec/doingUS/` after the abort.
  - the original story must not be duplicated across active, done, and abort lanes without a clear split.
- A partial-closure summary showing:
  - accepted scope
  - rejected scope
  - reason for rejection
  - evidence retained
  - recommended next command for the rejected slice
- Next recommended command:
  - `SPEC_closeUserStory` for the accepted slice after review/verification is complete.
  - `SPEC_analyzeAbortedUserStory` for the rejected slice when the team should reuse the preserved evidence.
  - `SPEC_importIssue` when the rejected slice should become a fresh improvement input.

## Execution Checklist

1. Validate there is exactly one active target story in `.catdd/spec/doingUS/` for the selected story ID.
2. Capture `accepted_scope` and `rejected_scope` in explicit structured form.
3. Confirm the accepted slice is valid and reviewable; do not close a rejected slice as accepted.
4. Move the accepted story slice into the close lane and record close evidence.
5. Move the rejected story slice into the abort lane and preserve evidence.
6. Verify no duplicate same-ID story remains across doing, done, and abort lanes.
7. Record `followup_intent` for the rejected side.
8. Recommend the next command for each remaining lane.

## Prompt Template

Ask the assistant to split the active story into accepted and rejected scope, preserve the rejected evidence in `.catdd/spec/abortUS/`, close only the valid accepted work, and keep the story trace intact without silently discarding the rejected portion.

## Conflict Guard

Do not use `SPEC_partialCloseUserStory` as a silent alias for `SPEC_abortUserStory`.
Do not treat the entire story as accepted when only part of it is valid.
Do not discard rejected reasoning; preserve the evidence in the abort lane.
Do not leave duplicate story IDs across `.catdd/spec/doingUS/`, `.catdd/spec/doneUS/`, and `.catdd/spec/abortUS/`.
Do not close the accepted slice without its review or verification evidence.
If `accepted_scope` is empty or not materially valid, require a clearer split or fall back to `SPEC_abortUserStory`.

ONE-MORE-THING: ask developer if something not sure
