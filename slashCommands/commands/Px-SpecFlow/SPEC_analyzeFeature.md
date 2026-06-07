# SPEC_analyzeFeature

## Purpose

Analyze a pending feature request, enhancement, or imported structured user-story source, generate a user story artifact under `.catdd/spec/todoUS/`, and archive the raw input under `.catdd/spec/analyzedNews/`.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the raw feature or user-story input, reason about user value, actor, and outcome, draft a lifecycle-ready user story, and verify it against quality criteria before accepting the output. When inputs are ambiguous or incomplete, the reasoning loop surfaces questions instead of inventing requirements.

## Inputs

- `pending_feature`: feature or imported user-story file under `.catdd/spec/pendingNews/`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, design, product, or test docs.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact.
- The source feature or imported user-story input moved from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/` as a team-shared raw input archive.
- A value-focused, independently testable user story slice with user value, priority, acceptance scenarios, edge cases, scope, non-goals, risks, assumptions, and initial acceptance questions.
- Source trace from the user story back to the archived raw input artifact.

## Prompt Template

Ask the assistant to convert raw feature or imported user-story input into a value-oriented, independently testable user story slice without designing implementation details too early. When the user story is accepted, move the raw input from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/` and update trace links.

## Conflict Guard

If the feature or imported user-story source lacks user value, actor, or outcome, create questions and keep the story draft incomplete instead of inventing requirements.

ONE-MORE-THING: ask developer if something not sure
