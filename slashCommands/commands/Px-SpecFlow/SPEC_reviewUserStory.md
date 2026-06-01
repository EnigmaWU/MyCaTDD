# SPEC_reviewUserStory

## Purpose

Review the active user story, detailed design, and acceptance criteria before test design begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the story and design artifacts, reason about clarity, completeness, traceability, and testability, produce a review finding, and verify that the finding is actionable before reporting. The reasoning loop routes to a design revision when criteria cannot be tested.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `detail_design`: design section or project-root README SPEC docs updated by `SPEC_takeDetailDesign`.
- `readme_spec_files`: optional project-root `README*` SPEC files relevant to the story.
- `projectContext_file`: current project context.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Review result recorded against team-shared `.catdd/spec/doingUS/` work state: pass, revise design, or ask developer.
- Missing acceptance criteria, ambiguity, README SPEC doc gaps, edge cases, measurable outcomes, and risk list from a clarify/analyze/checklist-style review gate.
- Next recommended command: `SPEC_designUnitTests` or `SPEC_updateDetailDesign`.

## Prompt Template

Ask the assistant to run a clarify/analyze/checklist-style review gate over clarity, completeness, traceability, testability, measurable outcomes, and consistency with project context.

## Conflict Guard

Do not approve a story when acceptance criteria cannot be tested through CaTDD skeletons.

ONE-MORE-THING: ask developer if something not sure
