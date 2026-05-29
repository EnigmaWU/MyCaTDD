# SPEC_analyzeIssue

## Purpose

Analyze a pending issue, bug report, or defect, generate a user story artifact under `.catdd/spec/todoUS/`, and archive the raw issue under `.catdd/spec/analyzedNews/`.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the raw issue input, reason about observed behavior, expected behavior, and root-cause hypotheses, draft a repair-oriented user story, and verify it before accepting the output. When reproducible intent or expected behavior is missing, the reasoning loop surfaces questions instead of inventing requirements.

## Inputs

- `pending_issue`: issue file under `.catdd/spec/pendingNews/`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, logs, test docs, or reproduction notes.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact.
- The source issue moved from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/` as a team-shared raw input archive.
- An issue-focused, independently testable user story slice with observed behavior, expected behavior, priority, acceptance scenarios, edge cases, scope, non-goals, risks, assumptions, and acceptance questions.
- Source trace from the user story back to the archived raw issue artifact.

## Prompt Template

Ask the assistant to convert raw issue input into a repair-oriented, independently testable user story slice without designing implementation details too early. When the user story is accepted, move the raw issue from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/` and update trace links.

## Conflict Guard

If the issue lacks reproducible intent or expected behavior, create questions and keep the story draft incomplete instead of inventing requirements.

ONE-MORE-THING: ask developer if something not sure
