# SPEC_openUserStory

## Purpose

Move a selected user story from `.catdd/spec/todoUS/` into `.catdd/spec/doingUS/` and prepare it for detailed design.

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
- Status marker showing the story is open.
- Initial next-step recommendation, usually `SPEC_takeDetailDesign`.

## Prompt Template

Ask the assistant to preserve story traceability, copy or move only the selected story into shared active work state, and start a clear active-work status section.

## Conflict Guard

Opening a story does not mean implementation may begin. Detail design and review still gate implementation.

ONE-MORE-THING: ask developer if something not sure
