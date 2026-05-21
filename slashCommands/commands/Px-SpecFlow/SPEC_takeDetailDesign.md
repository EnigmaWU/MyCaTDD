# SPEC_takeDetailDesign

## Purpose

Create or update detailed design and acceptance criteria for the active user story.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `projectContext_file`: current project context.
- `readme_spec_files`: optional project-root `README*` SPEC files to create or update.
- `readme_spec_templates`: matching templates under `slashCommands/templates/`, such as `README_DetailDesignTemplate.md`, `README_ErrorDesignTemplate.md`, `README_ResourceDesignTemplate.md`, `README_StateDesignTemplate.md`, `README_PerfDesignTemplate.md`, `README_DiagnosisDesignTemplate.md`, and `README_VerifyDesignTemplate.md`.
- `design_target`: optional project-root README SPEC file, API contract, architecture note, or detail design target.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Project-root README SPEC docs as needed, such as `README.md`, `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_DiagnosisDesign.md`, and `README_VerifyDesign.md`.
- First-time README SPEC docs should be based on the corresponding `slashCommands/templates/README_*Template.md` file.
- Detailed design notes tied to the active user story in local gitignored `.catdd/spec/doingUS/` work state or team-shared project-root README SPEC docs.
- Acceptance criteria that can be converted into CaTDD US/AC/TC skeletons.
- Explicit assumptions, constraints, and unresolved questions.

## Prompt Template

Ask the assistant to design behavior and acceptance criteria before tests or product code, updating only the project-root README SPEC docs needed for the active story and keeping implementation choices traceable to story intent. For embedded software or digital video/audio domain work, add error, resource, state, performance, and diagnosis design surfaces when hardware faults, finite resources, hardware lifecycle, real-time scheduling, buffer ownership, media timing, A/V sync, or field-debug evidence constraints are relevant.

## Conflict Guard

Do not start coding from this command. Route to `SPEC_reviewUserStory` first.

ONE-MORE-THING: ask developer if something not sure
