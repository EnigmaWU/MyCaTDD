# SPEC_reviewUserStory

## Purpose

Review the active user story, detailed design, and acceptance criteria before test design begins.

## Inputs

- `doing_user_story`: active story under `doingUS/`.
- `detail_design`: design or README file updated by `SPEC_takeDetailDesign`.
- `projectContext_file`: current project context.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Review result: pass, revise design, or ask developer.
- Missing acceptance criteria, ambiguity, and risk list.
- Next recommended command: `SPEC_designUnitTests` or `SPEC_updateDetailDesign`.

## Prompt Template

Ask the assistant to check clarity, completeness, traceability, testability, and consistency with project context.

## Conflict Guard

Do not approve a story when acceptance criteria cannot be tested through CaTDD skeletons.

ONE-MORE-THING: ask developer if something not sure
