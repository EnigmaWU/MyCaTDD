# SPEC_openUserStory

## Purpose

Move a selected user story from `.catdd/spec/todoUS/` into `.catdd/spec/doingUS/` and prepare it for planning.

## CoT Pattern

**Linear** — Direct execution. This command performs a deterministic artifact movement step. Given a selected user story, it moves the file and sets the active-work status marker without multi-path analysis.

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

## Prompt Template

Ask the assistant to preserve story traceability, move only the selected story from `.catdd/spec/todoUS/` into shared active work state (never copy), ask whether a dedicated story branch should be created or switched now, start a clear active-work status section, and route the story to `SPEC_makePlan` before design or implementation starts.

## Conflict Guard

Opening a story does not mean implementation may begin. `SPEC_makePlan` must decide whether intent clearing, architecture design, detail design, review, or direct test design is next.
Do not open from `.catdd/spec/doneUS/` or `.catdd/spec/abortUS/`; reopen work only by creating a new todo story artifact.
Do not open when the same story ID already exists under `.catdd/spec/doingUS/`.
Do not assume branch strategy; ask the developer before deciding whether to create or switch branch context for this opened story.

ONE-MORE-THING: ask developer if something not sure
