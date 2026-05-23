# SPEC_initProjectContext

## Purpose

Create the first `.catdd/spec/projectContext.md` for a target project before SpecCoding begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect available project material, reason about what is confirmed vs. assumed, draft the context artifact, and verify that uncertain facts are flagged explicitly rather than invented. The reasoning loop surfaces open questions for the developer.

## Inputs

- `project_root`: target project directory.
- `known_constraints`: language, framework, test framework, architecture, product goals, and team conventions.
- `existing_docs`: optional README, architecture notes, issue templates, or test docs.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/projectContext.md` team-shared persistent artifact with project facts, constraints, code conventions, test conventions, and open questions.
- A list of assumptions that must be confirmed by the developer.
- Next recommended command: `SPEC_importIssue`, `SPEC_importFeature`, or `SPEC_updateProjectContext`.

## Prompt Template

Ask the assistant to read the provided project material, summarize stable context, mark unknowns explicitly, and avoid inventing product or architecture decisions.

## Conflict Guard

Do not encode CaTDD category rules here. Link to `methodPrompts` for method semantics.

ONE-MORE-THING: ask developer if something not sure
