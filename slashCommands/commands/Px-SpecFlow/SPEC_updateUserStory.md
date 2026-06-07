# SPEC_updateUserStory

## Purpose

Update requirement-oriented story artifacts for an active story by revising module or submodule `README_UserStory.md` and paired `README_UserGuide.md` before design or implementation proceeds.

## CoT Pattern

**ReACT** -- Reasoning + Acting. This command must inspect the active story and current requirement docs, apply the minimum requirement-level updates needed for consistency and traceability, and verify that story IDs and usage guidance stay aligned without drifting into architecture or detail design decisions.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `module_user_story_doc`: module or submodule `README_UserStory.md` to update.
- `module_user_guide_doc`: paired module or submodule `README_UserGuide.md` to align with the updated user story.
- `update_scope`: optional scope hint such as specific `US-*` or `AC-*` IDs.
- `projectContext_file`: optional project context.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated module or submodule `README_UserStory.md` with requirement-level revisions and stable US/AC trace IDs.
- Updated paired `README_UserGuide.md` aligned to the revised requirement intent and usage behavior.
- Explicit trace links from the active doing story to updated requirement docs.
- Requirement-update checklist describing what changed and what remains open.
- Next recommended command is `SPEC_reviewUserStory`.

## Prompt Template

Ask the assistant to apply minimum requirement-level updates to `README_UserStory.md` and paired `README_UserGuide.md`, preserve US/AC traceability, and avoid architecture/detail-design expansion.

## Conflict Guard

Do not invent new product scope outside the active story intent.
Do not move this step into architecture or detail-design decisions; route those to design-oriented commands.
Do not skip `SPEC_reviewUserStory` after updating requirement artifacts.

ONE-MORE-THING: ask developer if something not sure