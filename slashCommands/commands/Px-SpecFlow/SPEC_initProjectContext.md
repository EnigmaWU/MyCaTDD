# SPEC_initProjectContext

## Purpose

Create the first `.catdd/spec/projectContext.md` for a target project before SpecCoding begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect available project material, reason about what is confirmed vs. assumed, draft the context artifact, and verify that uncertain facts are flagged explicitly rather than invented. The reasoning loop surfaces open questions for the developer.

### ReACT Execution

Repeat until every drafted fact is either sourced or explicitly marked as an assumption.

1. **Thought** — Read `existing_docs` and `known_constraints`. Separate what the material actually states from what you would be guessing.
2. **Action** — Before drafting, ask the two Setup Questions below in order, skipping either one only if it was supplied as input. Then draft `.catdd/spec/projectContext.md`.
3. **Observation** — Walk every line of the draft: is it traceable to project material, or is it an assumption? Unmarked guesses return to **Thought**. Encoded CaTDD category rules must be replaced with a link to `methodPrompts`.
4. **Stop** — Exit when facts and assumptions are cleanly separated. Report the assumption list needing developer confirmation and the next command.

#### Setup Questions

1. Which language should be used as `default_lang` for all subsequent SpecCoding progress: `US_EN` for English or `ZH_CN` for Chinese? Only skip this question if `default_lang` has already been provided as input.
2. What boundary should be treated as one **Unit** (the SUT unit convention) for CaTDD unit tests in this project? Offer common options — `module-interface`, `submodule-interface`, `class`, `header-file` (one `*.H`), `function`, or `component` — and let the developer pick or propose a project-specific scope. Record the chosen scope, a one-line rationale, and an example SUT name such as `SUT: moduleFooInterface` or `SUT: ClassBar`. Only skip this question if `sut_unit_convention` has already been provided as input.

### Worked Example

Bootstrapping SpecCoding on an existing service:

```text
/SPEC_initProjectContext
project_root: services/payment
existing_docs: services/payment/README.md, services/payment/README_UserGuide.md
```

Expected result — two passes:

- **Thought**: the READMEs state the language (TypeScript) and the test runner (`node --test`). They say nothing about the architecture style or release cadence.
- **Action**: asked Setup Question 1 → `US_EN`; asked Setup Question 2 → `module-interface`, rationale "public entry points are the stable surface", example `SUT: paymentGatewayInterface`. Draft written.
- **Observation**: the draft asserted "hexagonal architecture" — nothing in the material supports it → unmarked guess → back to **Thought**.
- **Action (pass 2)**: the line is removed and re-added under assumptions as "architecture style unconfirmed — needs developer input".
- **Observation**: every remaining line is either sourced or listed as an assumption → **Stop**.
- Reported: 1 assumption to confirm; `next_command = SPEC_importIssue`.

## Inputs

- `project_root`: target project directory.
- `known_constraints`: language, framework, test framework, architecture, product goals, and team conventions.
- `existing_docs`: optional README, architecture notes, issue templates, or test docs.
- `default_lang`: developer's preferred language for all subsequent SpecCoding progress, including artifact content, questions, comments, and summaries. Choose `US_EN` (English) or `ZH_CN` (Chinese). If not provided, ask the developer before proceeding.
- `sut_unit_convention`: the boundary treated as one **Unit** for CaTDD unit tests in this project. Choose one of the predefined scopes or define a project-specific one. Common options: `module-interface`, `submodule-interface`, `class`, `header-file` (e.g., one `*.H`), `function`, `component`. If not provided, ask the developer before proceeding. Record the chosen scope, a one-line rationale, and an example SUT name (for example, `SUT: moduleFooInterface` or `SUT: ClassBar`).

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/projectContext.md` team-shared persistent artifact with project facts, constraints, code conventions, test conventions, `sut_unit_convention`, constitution-level guardrails, `default_lang` (US_EN or ZH_CN), and open questions.
- A clearly recorded `sut_unit_convention` with scope, rationale, and example SUT name so later `SPEC_designUnitTests` declarations stay consistent.
- A list of assumptions that must be confirmed by the developer.
- Next recommended command: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, or `SPEC_updateProjectContext`.

## Conflict Guard

Do not encode CaTDD category rules here. Link to `methodPrompts` for method semantics.

ONE-MORE-THING: ask developer if something not sure
