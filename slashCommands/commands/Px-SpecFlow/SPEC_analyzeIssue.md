# SPEC_analyzeIssue

## Purpose

Analyze a pending issue, bug report, or defect and generate a user story artifact under `.catdd/spec/todoUS/`.

## Inputs

- `pending_issue`: issue file under `.catdd/spec/pendingNews/`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, logs, test docs, or reproduction notes.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact.
- Issue-focused user story, observed behavior, expected behavior, scope, non-goals, risks, and acceptance questions.
- Source trace back to the imported issue artifact.

## Prompt Template

Ask the assistant to convert raw issue input into a repair-oriented user story without designing implementation details too early.

## Conflict Guard

If the issue lacks reproducible intent or expected behavior, create questions and keep the story draft incomplete instead of inventing requirements.

ONE-MORE-THING: ask developer if something not sure
