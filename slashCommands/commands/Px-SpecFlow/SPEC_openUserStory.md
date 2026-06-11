# SPEC_openUserStory

## Purpose

Move a selected user story from `.catdd/spec/todoUS/` into `.catdd/spec/doingUS/` and prepare it for planning.

## CoT Pattern

**Linear** — Direct execution. This command performs a deterministic artifact movement step. Given a selected user story, it moves the file and sets the active-work status marker without multi-path analysis.

## Inputs

- `todo_user_story`: selected `.catdd/spec/todoUS/*-UserStory.md` file.
- `projectContext_file`: current project context.
- `working_log`: optional `.catdd/spec/WorkingProcessLog.md`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/doingUS/*-UserStory.md` team-shared active work file.
- The active work file is created only by moving from `.catdd/spec/todoUS/`; do not copy from any other lifecycle directory.
- Status marker showing the story is open.
- Initial next-step recommendation, usually `SPEC_makePlan`.

## Prompt Template

Ask the assistant to preserve story traceability, move only the selected story from `.catdd/spec/todoUS/` into shared active work state (never copy), start a clear active-work status section, and route the story to `SPEC_makePlan` before design or implementation starts.

## Conflict Guard

Opening a story does not mean implementation may begin. `SPEC_makePlan` must decide whether intent clearing, architecture design, detail design, review, or direct test design is next.
Do not open from `.catdd/spec/doneUS/` or `.catdd/spec/abortUS/`; reopen work only by creating a new todo story artifact.
Do not open when the same story ID already exists under `.catdd/spec/doingUS/`.

ONE-MORE-THING: ask developer if something not sure
