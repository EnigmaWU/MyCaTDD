# SPEC_reviewUserStory

## Purpose

Review the active user story, project-level requirement ledger (`README_UserStories.md`), usage guidance, and acceptance criteria after requirement-oriented updates.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the story and requirement artifacts, reason about clarity, completeness, traceability, and testability, produce a review finding, and verify that the finding is actionable before reporting. The reasoning loop routes to requirement revision when intent, usage guidance, or acceptance criteria cannot be tested.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `project_user_stories_doc`: project-root `README_UserStories.md` updated by `SPEC_updateUserStory`.
- `module_user_story_doc`: optional module or submodule `README_UserStory.md` updated by `SPEC_updateUserStory` when module-local requirement docs are used.
- `module_user_guide_doc`: paired module or submodule `README_UserGuide.md` updated by `SPEC_updateUserStory`.
- `detail_design`: optional design section or project-root README SPEC docs when reviewing transfer from requirement-oriented work into design-oriented work.
- `readme_spec_files`: optional project-root `README*` SPEC files relevant to the story.
- `projectContext_file`: current project context.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Review result recorded against team-shared `.catdd/spec/doingUS/` work state: pass, revise requirements, transfer to design-oriented work, close requirement-only work, or ask developer.
- Explicit consistency check that `README_UserStories.md` TODO/DONE story state and AC trace/status match lifecycle artifacts and active story content.
- Missing acceptance criteria, ambiguity, README SPEC doc gaps, edge cases, measurable outcomes, and risk list from a clarify/analyze/checklist-style review gate.
- Next recommended command: `SPEC_updateUserStory`, `SPEC_commitWorks`, `SPEC_takeArchDesign`, `SPEC_updateArchDesign`, `SPEC_takeDetailDesign`, or `SPEC_updateDetailDesign`.

## Prompt Template

Ask the assistant to run a clarify/analyze/checklist-style review gate over requirement clarity, completeness, traceability, testability, measurable outcomes, project `README_UserStories.md` ledger consistency, usage-guide consistency, and consistency with project context.

## Conflict Guard

Do not approve a story when acceptance criteria cannot be tested through CaTDD skeletons.
Do not approve requirement updates when `README_UserStories.md` TODO/DONE state or AC trace/status is inconsistent with story lifecycle artifacts.
Do not review a story whose `README_UserStories.md` ledger state is SUSPENDED; require `SPEC_resumeUserStory` first to resume before reviewing.
Do not route directly from requirement review to unit-test design; transfer to design-oriented work first when architecture or detail design is still needed.
Do not use this command as the automatic gate after `SPEC_reviewDetailDesign`; detail-design review owns that design gate.

ONE-MORE-THING: ask developer if something not sure
