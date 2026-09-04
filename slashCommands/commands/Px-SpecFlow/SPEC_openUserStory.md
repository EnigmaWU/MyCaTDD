# SPEC_openUserStory

## Purpose

Move a selected user story from `.catdd/spec/todoUS/` into `.catdd/spec/doingUS/` and prepare it for planning.

## CoT Pattern

**Linear** — Direct execution. This command performs a deterministic artifact movement step. Given a selected user story, it moves the file and sets the active-work status marker without multi-path analysis.

### Linear Execution

Run these steps once, in order. There is no retry loop; any failed check stops and asks the developer.

1. Confirm `todo_user_story` is under `.catdd/spec/todoUS/` and no story with the same ID already exists under `.catdd/spec/doingUS/`.
2. Move (do not copy) the file into `.catdd/spec/doingUS/`, preserving its source trace links.
3. Ask whether to create or switch to a dedicated branch for this story. Do not assume.
4. Write the active-work status section marking the story open.
5. Report the moved path, the branch decision, and `next_command = SPEC_makePlan`.

### Worked Example

A story was selected from the backlog to start work on:

```text
/SPEC_openUserStory
todo_user_story: .catdd/spec/todoUS/20260904-payment-retry-UserStory.md
projectContext_file: .catdd/spec/projectContext.md
```

Expected result:

1. `todoUS/` contains the file; no `doingUS/20260904-payment-retry-*` exists → check passes.
2. Moved to `.catdd/spec/doingUS/20260904-payment-retry-UserStory.md`; `todoUS/` copy no longer exists.
3. Asked: "Open this story on a dedicated branch `feat/payment-retry`, or continue on the current branch?" — developer chose the dedicated branch.
4. Status section set to open.
5. Reported: `next_command = SPEC_makePlan`. Implementation does not start here.

## Inputs

- `todo_user_story`: selected `.catdd/spec/todoUS/*-UserStory.md` file.
- `projectContext_file`: current project context.
- `working_log`: optional `.catdd/spec/WorkingProcessLog.md`.
- `branch_strategy`: optional developer preference for whether to open this story on a dedicated git branch.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/doingUS/*-UserStory.md` team-shared active work file.
- The active work file is created only by moving from `.catdd/spec/todoUS/`; do not copy from any other lifecycle directory.
- Status marker showing the story is open.
- Branch checkpoint: ask the developer whether to create or switch to a dedicated branch for this story before continuing.
- Initial next-step recommendation, usually `SPEC_makePlan`.

## Conflict Guard

Opening a story does not mean implementation may begin. `SPEC_makePlan` must decide whether intent clearing, architecture design, detail design, review, or direct test design is next.
Do not open from `.catdd/spec/doneUS/` or `.catdd/spec/abortUS/`; reopen work only by creating a new todo story artifact.
Do not open when the same story ID already exists under `.catdd/spec/doingUS/`.
Do not assume branch strategy; ask the developer before deciding whether to create or switch branch context for this opened story.

ONE-MORE-THING: ask developer if something not sure
