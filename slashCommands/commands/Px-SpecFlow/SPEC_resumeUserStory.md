# SPEC_resumeUserStory

## Purpose

Resume a suspended user story back into active work.

## CoT Pattern

**Linear** -- Direct execution. Given a selected suspended story, this command moves the story and its paired task artifact from `.catdd/spec/suspendUS/` to `.catdd/spec/doingUS/` and validates the stored resume reference.

## Inputs

- `suspended_user_story`: selected suspended story under `.catdd/spec/suspendUS/`.
- `suspended_tasks_file`: optional `.catdd/spec/suspendUS/*-TASKs.md` task artifact paired with the story.
- `resume_ref`: recorded durable resume reference, typically a branch name or worktree path.
- `projectContext_file`: current project context.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/doingUS/*-UserStory.md` team-shared active work artifact restored from suspended state.
- A paired `.catdd/spec/doingUS/*-TASKs.md` task artifact restored when present.
- Resume note confirming `resume_ref` and any handoff caveats.
- Local `.catdd/spec/suspendUS/` suspended work state removed after active artifact restoration.
- Next recommended command: usually `SPEC_whatsNextTask` or the first unchecked task from `*-TASKs.md`.

## Prompt Template

Ask the assistant to resume a selected suspended story into `.catdd/spec/doingUS/`, preserve traceability and prior task state, verify or restate the durable resume reference, and continue from the correct lifecycle step.

## Conflict Guard

Do not resume if the story already exists under `.catdd/spec/doingUS/`.
Do not resume without validating the stored `resume_ref`.
Do not mutate suspended history; move artifacts and preserve evidence.
Do not leave the same story ID under both `.catdd/spec/suspendUS/` and `.catdd/spec/doingUS/`.

ONE-MORE-THING: ask developer if something not sure
