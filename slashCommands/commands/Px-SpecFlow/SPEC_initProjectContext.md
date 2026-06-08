# SPEC_initProjectContext

## Purpose

Create the first `.catdd/spec/projectContext.md` for a target project before SpecCoding begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect available project material, reason about what is confirmed vs. assumed, draft the context artifact, and verify that uncertain facts are flagged explicitly rather than invented. The reasoning loop surfaces open questions for the developer.

## Inputs

- `project_root`: target project directory.
- `known_constraints`: language, framework, test framework, architecture, product goals, and team conventions.
- `existing_docs`: optional README, architecture notes, issue templates, or test docs.
- `default_lang`: developer's preferred language for all subsequent SpecCoding progress, including artifact content, questions, comments, and summaries. Choose `US_EN` (English) or `ZH_CN` (Chinese). If not provided, ask the developer before proceeding.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/projectContext.md` team-shared persistent artifact with project facts, constraints, code conventions, test conventions, constitution-level guardrails, `default_lang` (US_EN or ZH_CN), and open questions.
- A list of assumptions that must be confirmed by the developer.
- Next recommended command: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, or `SPEC_updateProjectContext`.

## Prompt Template

Ask the assistant to read the provided project material, summarize stable context and constitution-level guardrails, mark unknowns explicitly, and avoid inventing product or architecture decisions. Before drafting the context artifact, ask the developer which language should be used as `default_lang` for all subsequent SpecCoding progress: `US_EN` for English or `ZH_CN` for Chinese. Only skip this question if `default_lang` has already been provided as input.

## Conflict Guard

Do not encode CaTDD category rules here. Link to `methodPrompts` for method semantics.

ONE-MORE-THING: ask developer if something not sure
