# SPEC_analyzeWorkItem

## Purpose

Analyze a pending issue or feature request and generate a user story artifact under `todoUS/`.

## Inputs

- `pending_work_item`: file under `pendingNews/`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, or test docs.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `todoUS/*-UserStory.md` file.
- User story, scope, non-goals, risks, and initial acceptance questions.
- Source trace back to the imported work item.

## Prompt Template

Ask the assistant to convert raw input into a user story without designing implementation details too early.

## Conflict Guard

If the work item lacks intent, create questions and keep the story draft incomplete instead of inventing requirements.

ONE-MORE-THING: ask developer if something not sure
