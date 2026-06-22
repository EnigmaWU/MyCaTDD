# SPEC_updateUserStory

## Purpose

Update requirement-oriented story artifacts for an active story by revising project-root `README_UserStories.md` (TODO/DONE + AC trace/status ledger) and paired `README_UserGuide.md` before design or implementation proceeds. Module or submodule `README_UserStory.md` may also be updated when the project uses module-local requirement docs.

## CoT Pattern

**ReACT** -- Reasoning + Acting. This command must inspect the active story and current requirement docs, apply the minimum requirement-level updates needed for consistency and traceability, and verify that story IDs and usage guidance stay aligned without drifting into architecture or detail design decisions.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `project_user_stories_doc`: project-root `README_UserStories.md` to update as the authoritative TODO/DONE and AC ledger.
- `module_user_story_doc`: optional module or submodule `README_UserStory.md` to update when module-local requirement docs are used.
- `module_user_guide_doc`: paired module or submodule `README_UserGuide.md` to align with the updated user story.
- `update_scope`: optional scope hint such as specific `US-*` or `AC-*` IDs.
- `projectContext_file`: optional project context.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated project-root `README_UserStories.md` with requirement-level revisions, TODO/DONE state synchronization, and stable US/AC trace IDs.
- Updated module or submodule `README_UserStory.md` when module-local requirement docs are used.
- Updated paired `README_UserGuide.md` aligned to the revised requirement intent and usage behavior.
- Explicit trace links from the active doing story to updated requirement docs.
- Requirement-update checklist describing what changed and what remains open.
- Next recommended command is `SPEC_reviewUserStory`.

## Prompt Template

Ask the assistant to apply minimum requirement-level updates to project `README_UserStories.md` and paired `README_UserGuide.md` (plus module `README_UserStory.md` when applicable), preserve US/AC traceability and TODO/DONE consistency, and avoid architecture/detail-design expansion.

## Conflict Guard

Do not invent new product scope outside the active story intent.
Do not update `README_UserStories.md` for a story whose ledger state is SUSPENDED; require `SPEC_resumeUserStory` first to resume before updating.
Do not move this step into architecture or detail-design decisions; route those to design-oriented commands.
Do not skip `SPEC_reviewUserStory` after updating requirement artifacts.

ONE-MORE-THING: ask developer if something not sure
