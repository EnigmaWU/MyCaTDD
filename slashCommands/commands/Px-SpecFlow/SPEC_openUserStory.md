# SPEC_openUserStory

## Purpose

Move a selected user story from `todoUS/` into `doingUS/` and prepare it for detailed design.

## Inputs

- `todo_user_story`: selected `todoUS/*-UserStory.md` file.
- `projectContext_file`: current project context.
- `working_log`: optional `WorkingProcessLog.md`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `doingUS/*-UserStory.md` active story file.
- Status marker showing the story is open.
- Initial next-step recommendation, usually `SPEC_takeDetailDesign`.

## Prompt Template

Ask the assistant to preserve story traceability, move only the selected story, and start a clear active-work status section.

## Conflict Guard

Opening a story does not mean implementation may begin. Detail design and review still gate implementation.

ONE-MORE-THING: ask developer if something not sure
