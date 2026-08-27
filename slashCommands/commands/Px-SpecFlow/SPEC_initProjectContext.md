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
- `sut_unit_convention`: the boundary treated as one **Unit** for CaTDD unit tests in this project. Choose one of the predefined scopes or define a project-specific one. Common options: `module-interface`, `submodule-interface`, `class`, `header-file` (e.g., one `*.H`), `function`, `component`. If not provided, ask the developer before proceeding. Record the chosen scope, a one-line rationale, and an example SUT name (for example, `SUT: moduleFooInterface` or `SUT: ClassBar`).
- `project_mode`: optional `greenfield | migration | auto` (default: `auto`). Use `migration` when the project has existing source code, tests, issues, or backlog items to carry into CaTDD. Use `greenfield` when starting from scratch. Use `auto` to let the assistant detect which mode applies by inspecting `project_root` and `existing_docs`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- A `.catdd/spec/projectContext.md` team-shared persistent artifact with project facts, constraints, code conventions, test conventions, `sut_unit_convention`, constitution-level guardrails, `default_lang` (US_EN or ZH_CN), and open questions.
- A clearly recorded `sut_unit_convention` with scope, rationale, and example SUT name so later `SPEC_designUnitTests` declarations stay consistent.
- A list of assumptions that must be confirmed by the developer.
- The resolved `project_mode` (`greenfield` or `migration`), recorded in `projectContext.md`.
- **When `project_mode` is `migration`**, also output a **Migration Inventory** section in `projectContext.md`:
  - Detected existing test files and their estimated CaTDD conversion path (e.g., demo tests → `UT_convertDemoToTypical`).
  - Detected existing issues, backlogs, or feature lists to import (→ `SPEC_importIssue` or `SPEC_importFeature`).
  - Detected existing structured user stories or requirement docs (→ `SPEC_importUserStory`).
  - Detected existing README or architecture docs that should anchor `README_ArchDesign.md` or `README_DetailDesign.md` (→ `SPEC_takeArchDesign` or `SPEC_takeDetailDesign`).
  - An explicit **Migration Steps** ordered checklist:
    1. Run `SPEC_importIssue` / `SPEC_importFeature` for each detected issue or feature source.
    2. Run `SPEC_importUserStory` for each detected structured requirement or backlog item.
    3. Run `SPEC_analyzeFeature` / `SPEC_analyzeIssue` to convert raw imports into US/AC/TC.
    4. Run `UT_convertDemoToTypical` for each detected existing test file to convert it into CaTDD skeletons.
    5. Run `SPEC_takeArchDesign` / `SPEC_takeDetailDesign` to anchor existing architecture docs as CaTDD design artifacts.
    6. Run `SPEC_updateProjectContext` to refine context after bulk import is complete.
  - Open questions specific to migration: test framework compatibility, CI pipeline changes needed, coverage gaps between legacy tests and CaTDD categories.
- **When `project_mode` is `greenfield`**, skip the Migration Inventory and Migration Steps; proceed directly to the standard next-command recommendations.
- Next recommended command:
  - `greenfield`: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, or `SPEC_updateProjectContext`.
  - `migration`: follow the **Migration Steps** checklist above, starting with `SPEC_importIssue` or `SPEC_importFeature`.

## Prompt Template

Ask the assistant to read the provided project material, summarize stable context and constitution-level guardrails, mark unknowns explicitly, and avoid inventing product or architecture decisions. Before drafting the context artifact, ask the following setup questions in this order:

1. Which language should be used as `default_lang` for all subsequent SpecCoding progress: `US_EN` for English or `ZH_CN` for Chinese? Only skip this question if `default_lang` has already been provided as input.
2. What boundary should be treated as one **Unit** (the SUT unit convention) for CaTDD unit tests in this project? Offer common options — `module-interface`, `submodule-interface`, `class`, `header-file` (one `*.H`), `function`, or `component` — and let the developer pick or propose a project-specific scope. Record the chosen scope, a one-line rationale, and an example SUT name such as `SUT: moduleFooInterface` or `SUT: ClassBar`. Only skip this question if `sut_unit_convention` has already been provided as input.
3. When `project_mode=auto` or when existing source code, tests, issues, or docs are detected in `project_root`: confirm with the developer whether this is a **migration** of an existing project or a **greenfield** start. Only skip this question if `project_mode` has already been provided as input or if `project_root` is clearly empty.

When `project_mode` resolves to `migration`, after drafting the standard `projectContext.md` content, also produce the **Migration Inventory** and **Migration Steps** checklist described in the Output Contract. Surface open questions about test framework compatibility, CI pipeline changes, and coverage gaps between legacy tests and CaTDD categories.

## Conflict Guard

Do not encode CaTDD category rules here. Link to `methodPrompts` for method semantics.
Do not invent migration inventory items. Only report what is detectable from `project_root` and `existing_docs`; mark anything uncertain as an open question.
Do not skip the migration mode confirmation question when existing material is detected.

ONE-MORE-THING: ask developer if something not sure
