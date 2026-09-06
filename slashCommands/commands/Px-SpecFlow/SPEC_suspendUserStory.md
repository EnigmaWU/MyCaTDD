# SPEC_suspendUserStory

## Purpose

Suspend an active user story when work must pause, while preserving a durable resume reference.

## CoT Pattern

**Linear** -- Direct execution. Given a selected active story and a suspend reason, this command moves the active story and its paired task artifact from `.catdd/spec/doingUS/` to `.catdd/spec/suspendUS/` and records a durable git resume reference.

### Linear Execution

Run these steps once, in order. There is no retry loop; any failed check stops and asks the developer.

1. Require an explicit `suspend_reason`. Stop if absent.
2. Require a durable `resume_ref` — branch or worktree per the Resume Reference Guidance. Stop if only a dirty working tree or a stash-only reference is available for work that must be resumed.
3. Checkpoint the work: commit on the resume branch, and push when team handoff is expected.
4. Move the story and its paired tasks artifact from `doingUS` to `suspendUS`, preserving source trace.
5. Record `suspend_reason` and `resume_ref` in the suspended artifact.
6. Verify the story ID no longer appears under `doingUS`.
7. Report the suspended paths and `next_command = SPEC_resumeUserStory`.

### Worked Example

Work must pause for an urgent production fix:

```text
/SPEC_suspendUserStory
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
suspend_reason: Paused for P0 incident INC-4471; resuming after the incident closes.
resume_ref: us-123-suspend
working_tree_state: uncommitted changes in services/payment/retry.ts
```

Expected result:

1. `suspend_reason` present → check passes.
2. `resume_ref` is a branch name, not a stash → check passes.
3. Uncommitted changes detected, so the work is checkpointed first:

   ```bash
   git switch -c us-123-suspend
   git add -A
   git commit -m "wip: suspend US-123 at current checkpoint"
   git push -u origin us-123-suspend
   ```

4. Story and tasks moved to `.catdd/spec/suspendUS/`.
5. Reason and `us-123-suspend` recorded in the suspended artifact.
6. ID absent from `doingUS` → verified.
7. Reported: `next_command = SPEC_resumeUserStory`.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `doing_tasks_file`: optional active `.catdd/spec/doingUS/*-UserStory-Tasks.md` task artifact paired with the story.
- `suspend_reason`: explicit reason for pausing instead of continuing in place.
- `resume_ref`: durable git resume reference, typically a branch name or worktree path.
- `working_tree_state`: optional note indicating whether uncommitted changes exist.
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). In `autonomousMode`, upon suspending the story and verifying the durable resume_ref, exit cleanly.

## Resume Reference Guidance

- Preferred: a dedicated branch name (for example, `us-123-suspend`).
- Also valid: an explicit worktree path tied to the suspended story.
- Fallback only: stash identifiers; use only when branch/worktree creation is not possible.
- Recommended checkpoint before suspend: create at least one commit on the resume branch, and push when team handoff is expected.

Example:

```bash
git switch -c us-123-suspend
git add -A
git commit -m "wip: suspend US-123 at current checkpoint"
git push -u origin us-123-suspend
```

## Method References

- [Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/suspendUS/*-UserStory.md` team-shared suspended story artifact preserving source trace, suspend reason, and resume guidance.
- A paired `.catdd/spec/suspendUS/*-UserStory-Tasks.md` team-shared task artifact when the story was planned through `SPEC_makePlan`.
- Recorded `resume_ref` under the suspended story so the next developer can resume deterministically.
- Local `.catdd/spec/doingUS/` active work state removed after the suspended artifact is created.
- Next recommended command: `SPEC_resumeUserStory`.

## Conflict Guard

Do not suspend without an explicit `suspend_reason`.
Do not suspend when no durable `resume_ref` is available for work that must be resumed.
Do not rely on stash-only references when branch or worktree-based recovery is required.
Do not use a dirty, uncheckpointed branch as the only `resume_ref` for team handoff scenarios.
Do not leave the same story ID under both `.catdd/spec/doingUS/` and `.catdd/spec/suspendUS/`.

ONE-MORE-THING: ask developer if something not sure
