# SPEC_analyzeFeature

## Purpose

Analyze a pending feature request or enhancement and generate a user story artifact under `.catdd/spec/todoUS/`.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the raw feature input, reason about user value, actor, and outcome, draft a user story, and verify it against quality criteria before accepting the output. When inputs are ambiguous or incomplete, the reasoning loop surfaces questions instead of inventing requirements.

## Inputs

- `pending_feature`: feature file under `.catdd/spec/pendingNews/`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, design, product, or test docs.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact.
- Feature-focused user story, user value, scope, non-goals, risks, and initial acceptance questions.
- Source trace back to the imported feature artifact.

## Prompt Template

Ask the assistant to convert raw feature input into a value-oriented user story without designing implementation details too early.

## Conflict Guard

If the feature lacks user value, actor, or outcome, create questions and keep the story draft incomplete instead of inventing requirements.

ONE-MORE-THING: ask developer if something not sure
