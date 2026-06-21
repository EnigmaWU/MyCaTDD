# SPEC_suspendUserStory

## Purpose

Suspend an active user story when work must pause, while preserving a durable resume reference.

## CoT Pattern

**Linear** -- Direct execution. Given a selected active story and a suspend reason, this command moves the active story and its paired task artifact from `.catdd/spec/doingUS/` to `.catdd/spec/suspendUS/` and records a durable git resume reference.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `doing_tasks_file`: optional active `.catdd/spec/doingUS/*-TASKs.md` task artifact paired with the story.
- `suspend_reason`: explicit reason for pausing instead of continuing in place.
- `resume_ref`: durable git resume reference, typically a branch name or worktree path.
- `working_tree_state`: optional note indicating whether uncommitted changes exist.

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
- A paired `.catdd/spec/suspendUS/*-TASKs.md` team-shared task artifact when the story was planned through `SPEC_makePlan`.
- Recorded `resume_ref` under the suspended story so the next developer can resume deterministically.
- Local `.catdd/spec/doingUS/` active work state removed after the suspended artifact is created.
- Next recommended command: `SPEC_resumeUserStory`.

## Prompt Template

Ask the assistant to suspend the selected active story into `.catdd/spec/suspendUS/`, preserve full traceability, record a durable git resume reference, and avoid mutating product intent.

## Conflict Guard

Do not suspend without an explicit `suspend_reason`.
Do not suspend when no durable `resume_ref` is available for work that must be resumed.
Do not rely on stash-only references when branch or worktree-based recovery is required.
Do not use a dirty, uncheckpointed branch as the only `resume_ref` for team handoff scenarios.
Do not leave the same story ID under both `.catdd/spec/doingUS/` and `.catdd/spec/suspendUS/`.

ONE-MORE-THING: ask developer if something not sure
