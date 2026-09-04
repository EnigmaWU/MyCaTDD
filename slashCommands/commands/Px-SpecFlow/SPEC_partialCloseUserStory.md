# SPEC_partialCloseUserStory

## Purpose

Partially close an active user story by separating the accepted scope from the rejected or intentionally deferred scope, preserving the rejected slice in the abort lane and closing the accepted slice with traceability.

This command is the explicit bridge between `SPEC_closeUserStory` and `SPEC_abortUserStory`: it does not abandon the whole story, but does not pretend every unresolved concern is still valid.

## CoT Pattern

**Linear** — Direct execution. Given an active user story, an accepted-scope summary, and a rejected-scope summary with explicit reasons, this command moves accepted work to the close lane and moves rejected work to the abort lane while preserving evidence, trace links, and the story's original rationale.

### Linear Execution

Run these steps once, in order. There is no retry loop; a failed split validation stops and asks the developer.

1. Validate there is exactly one active target story in `.catdd/spec/doingUS/` for the selected story ID.
2. Capture `accepted_scope` and `rejected_scope` in explicit structured form. If `accepted_scope` is empty or not materially valid, stop and fall back to `SPEC_abortUserStory`.
3. Confirm the accepted slice is verified and reviewable. Never close a rejected slice as accepted.
4. Move the accepted slice into the close lane and record its close evidence.
5. Move the rejected slice into the abort lane with its `rejection_reason` and `evidence_refs` preserved.
6. Synchronize `README_UserStories.md` so accepted ACs show DONE and rejected ACs show the abort state.
7. Verify no duplicate same-ID story remains across the doing, done, and abort lanes.
8. Record `followup_intent` for the rejected side and report the next command per lane.

### Worked Example

Three of four ACs shipped; the fourth turned out to rest on a bad assumption:

```text
/SPEC_partialCloseUserStory
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
accepted_scope:
  accepted_summary: AC-01..AC-03 bounded retry with exponential backoff
  accepted_evidence: 38/38 GREEN; commit a1b2c3d
rejected_scope:
  rejected_summary: AC-04 automatic retry of partially-settled charges
  rejection_reason: assumption-gap
  evidence_refs: SysTests/UT_Retry-Fault.ts (TC-RETRY-009 FAILS)
  followup_intent: SPEC_importIssue
```

Expected result:

1. Exactly one active story matches → check passes.
2. Both scopes structured; `accepted_scope` is materially valid → no fallback to abort.
3. AC-01..AC-03 carry passing evidence → accepted slice is closeable.
4. Accepted slice written to `.catdd/spec/doneUS/` with commit `a1b2c3d`.
5. Rejected slice written to `.catdd/spec/abortUS/` keeping the failing test reference verbatim.
6. Ledger: AC-01..AC-03 DONE, AC-04 marked aborted — not silently dropped.
7. Story ID present in `doneUS` and `abortUS` as a declared split, absent from `doingUS` → normalized.
8. Reported: accepted lane complete; rejected lane `next_command = SPEC_importIssue`.

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

## Conflict Guard

Do not use `SPEC_partialCloseUserStory` as a silent alias for `SPEC_abortUserStory`.
Do not treat the entire story as accepted when only part of it is valid.
Do not discard rejected reasoning; preserve the evidence in the abort lane.
Do not leave duplicate story IDs across `.catdd/spec/doingUS/`, `.catdd/spec/doneUS/`, and `.catdd/spec/abortUS/`.
Do not close the accepted slice without its review or verification evidence.
If `accepted_scope` is empty or not materially valid, require a clearer split or fall back to `SPEC_abortUserStory`.

ONE-MORE-THING: ask developer if something not sure
