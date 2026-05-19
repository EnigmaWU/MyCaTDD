# SPEC_takeDetailDesign

## Purpose

Create or update detailed design and acceptance criteria for the active user story.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `projectContext_file`: current project context.
- `design_target`: module README, detail design file, API contract, or architecture note.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Detailed design notes tied to the active user story in local gitignored `.catdd/spec/doingUS/` work state or stable team-shared design docs.
- Acceptance criteria that can be converted into CaTDD US/AC/TC skeletons.
- Explicit assumptions, constraints, and unresolved questions.

## Prompt Template

Ask the assistant to design behavior and acceptance criteria before tests or product code, keeping implementation choices traceable to story intent.

## Conflict Guard

Do not start coding from this command. Route to `SPEC_reviewUserStory` first.

ONE-MORE-THING: ask developer if something not sure
