# SPEC_takeDetailDesign

## Purpose

Create or update detailed design and acceptance criteria for the active user story.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `projectContext_file`: current project context.
- `readme_spec_files`: optional project-root `README*` SPEC files to create or update.
- `design_target`: optional project-root README SPEC file, API contract, architecture note, or detail design target.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Project-root README SPEC docs as needed, such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, and `README_VerifyDesign.md`.
- Detailed design notes tied to the active user story in local gitignored `.catdd/spec/doingUS/` work state or team-shared project-root README SPEC docs.
- Acceptance criteria that can be converted into CaTDD US/AC/TC skeletons.
- Explicit assumptions, constraints, and unresolved questions.

## Prompt Template

Ask the assistant to design behavior and acceptance criteria before tests or product code, updating only the project-root README SPEC docs needed for the active story and keeping implementation choices traceable to story intent.

## Conflict Guard

Do not start coding from this command. Route to `SPEC_reviewUserStory` first.

ONE-MORE-THING: ask developer if something not sure
