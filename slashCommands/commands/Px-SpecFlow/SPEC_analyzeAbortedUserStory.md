# SPEC_analyzeAbortedUserStory

## Purpose

Analyze an aborted user story, audit its preserved evidence, diagnose the abort cause, selectively re-apply requirements-analysis techniques to the affected parts, and generate a corrected user story artifact under `.catdd/spec/todoUS/`. The original aborted story remains in `.catdd/spec/abortUS/` as historical evidence — it is never mutated.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the aborted story, its paired tasks, the abort reason, and any design/test/product evidence produced before the abort. It reasons about what was valid (preserve), what was invalid (reject), which parts of the story need correction, and which analysis SKILLs to selectively re-apply. When replacement intent is unclear, it surfaces questions instead of inventing requirements.

## Inputs

- `aborted_user_story`: aborted story under `.catdd/spec/abortUS/`.
- `aborted_tasks_file`: optional `.catdd/spec/abortUS/*-TASKs.md` task artifact paired with the aborted story.
- `projectContext_file`: current project context.
- `related_docs`: optional README SPEC docs, arch/detail design docs, review findings, test output, implementation notes, or reproduction evidence.
- `SpecTodoUserStoryTemplate`: output template at `../../templates/SpecTodoUserStoryTemplate.md`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)
- Composed from requirements-analysis skills in `.github/skills/`: `write-user-story`, `build-feature-tree`, `elicit-requirements-models`, `extract-business-rules`, `facilitate-example-mapping`, `validate-requirements-criteria`, `prioritize-requirements`. See their `SKILL.md` for full technique details.

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact for the corrected next round.
- Source trace from the new todo story to the aborted story and its paired tasks.
- A corrected, independently testable user-story slice with preserved valid intent, rejected invalid assumptions, acceptance scenarios, risks, non-goals, and open questions.
- The aborted story remains preserved in `.catdd/spec/abortUS/` as historical evidence — it is never mutated.
- The story follows `SpecTodoUserStoryTemplate.md` structure and includes the optional **Abort Evidence** section documenting the abort diagnosis.
- Explicit documentation of what was kept (valid) and what was rejected (invalid) from the original story.

## Prompt Template

Apply the selective evidence-based pipeline below. The story was already analyzed before — only re-apply SKILLs to the parts that the abort proves needed correction. Use `SpecTodoUserStoryTemplate.md` for the final output, including the **Abort Evidence** section.

### Step 0 — Audit: Read all available evidence
Read all sources: the aborted story (`abortUS/*-UserStory.md`), its paired tasks (`abortUS/*-TASKs.md`), project context, and any related documents (design specs, test files, review notes, test output, code fragments). Determine the lifecycle phase at abort (Phase 1 opened only, Phase 2 designed, or Phase 3 implemented) and what evidence exists at each level.

If no design, test, or code evidence exists, the story was aborted early. If design docs exist, review them for clues about what went wrong. If test files or code exist, review those too.

### Step 1 — Diagnose: Classify the abort reason
Read the abort reason recorded by `SPEC_abortUserStory`. Classify the failure into one or more of:

| Category | Meaning | Example |
|---|---|---|
| **Intent unclear** | Role, capability, or business value was wrong | Story targeted wrong user |
| **Scope wrong** | In-scope/non-goals were misaligned | Story too big or too narrow |
| **Assumption invalid** | Something assumed true was false | Assumed API existed but didn't |
| **Design flaw** | Architecture/detail design proved unviable | Chosen pattern doesn't fit constraints |
| **Test gap** | Couldn't test the behavior effectively | No mocking strategy for dependency |
| **Quality dead-end** | Implementation exposed unsolvable problem | Performance target impossible on target hardware |

If multiple categories apply, list all. If the abort reason doesn't fit any category, create a question for the developer.

### Step 2 — Preserve: Keep valid intent
Explicitly list what was **correct** in the original story. Do not over-correct. Format:

> The following remains valid: role "{{role}}", capability "{{capability}}", business value "{{value}}" (if all correct). Acceptance scenarios 1–3 are valid. Business rules BR-1 through BR-3 remain correct. Scope items X and Y are still in scope.

### Step 3 — Reject: Discard invalid assumptions
Explicitly list what the abort proved **wrong** in the original story. Format:

> The following is rejected: assumption Z ("{{original assumption}}") was proven false by {{evidence}}. Non-goal W is no longer correct because {{reason}}. Scenario 4 is infeasible because {{reason}}.

Be precise about why each rejection is justified. Do not reject valid parts just because the story was aborted.

### Step 4 — Decide: Is re-analysis the right path?
Check the following gates:
- **Gate 1**: If the abort reason changes **product intent** (the "I want" or "So that" needs fundamentally different behavior), ask the developer before writing the corrected story. Do not guess new product intent.
- **Gate 2**: If the problem is better represented as a new defect or improvement input (e.g., the abort reason is unrelated to the original story's intent), recommend `SPEC_importIssue` instead of forcing re-analysis.
- **Gate 3**: If the abort reason is unclear or insufficient to determine what should change, ask the developer for clarification.

If all gates pass, proceed to Step 5.

### Step 5 — Selective re-analysis
Apply SKILLs **only** where the abort diagnosis indicates a need for correction. Always re-score priority. Always run ambiguity hunt.

| If the abort category includes... | Apply... |
|---|---|
| **Intent unclear** | `(→ SKILL: write-user-story)` — Step 2 (re-extract role, capability, value). Ask — do not invent. |
| **Scope wrong** | `(→ SKILL: build-feature-tree)` — is the corrected scope still appropriately sized? Group into L1/L2/L3 if splitting is still needed. |
| **Assumption invalid** | No SKILL needed — document the rejected assumption in Step 3 output. Apply `(→ SKILL: facilitate-example-mapping)` to the affected scenarios to generate counter-examples that prove the assumption wrong. |
| **Design flaw** | `(→ SKILL: elicit-requirements-models)` — re-visualize the state/flow that caused the design failure. Trace the new model for remaining gaps. Document what changed from the original model. |
| **Test gap** | `(→ SKILL: validate-requirements-criteria)` — check if ambiguous scenarios contributed to the untestability. `(→ SKILL: elicit-requirements-models)` — visualize the behavior that couldn't be tested. |
| **Quality dead-end** | `(→ SKILL: elicit-requirements-models)` — re-visualize the problematic flow with the quality constraint woven in. `(→ SKILL: prioritize-requirements)` — re-assess risk score upward for the affected dimension. |
| **Always (regardless)** | `(→ SKILL: validate-requirements-criteria)` — hunt ambiguity in the corrected story. `(→ SKILL: prioritize-requirements)` — re-score all four dimensions (BV, UV, Cost, Risk). |

### Step 6 — Correct: Write the corrected story
Write `todoUS/*-UserStory.md` following `SpecTodoUserStoryTemplate.md`. The following sections must be present and correct:

- **Story Statement** — updated if intent changed; otherwise preserved from original
- **Priority** — always re-scored (Step 5 mandate)
- **Visual Model** — updated if design flaw or quality dead-end was diagnosed; otherwise preserved or marked as not changed
- **Acceptance Criteria** — scenarios modified, added, or removed per the re-analysis; unchanged scenarios preserved verbatim
- **Business Rules** — updated if rules were wrong/missing; otherwise preserved
- **Edge Cases & Error Paths** — updated if new gaps found; otherwise preserved
- **Scope** — updated if scope was wrong; otherwise preserved
- **Risks & Assumptions** — rejected assumptions documented here as "formerly assumed X, abort proved Y"
- **Initial Acceptance Questions** — re-surfaced from the re-analysis; mark previously answered questions as answered
- **Ambiguity Warnings** — always re-scanned (Step 5 mandate)
- **Traceability** — traces to both the raw input (if original had one) AND the abortUS file
- **Abort Evidence** — fill the table from Steps 0-3 findings

**Gate:** if any Initial Acceptance Questions remain open, mark the story NOT ready — it may not proceed to `SPEC_openUserStory`.

### Step 7 — Write & trace
Write the corrected story. Do NOT mutate or delete the original `abortUS/` files — they are permanent historical evidence. Source trace the new story to both the archived raw input (if any) and the aborted story + tasks.

## Conflict Guard

Do not mutate the aborted story into active work. Create a new todo story when the corrected intent is clear enough.
Do not invent replacement requirements. If the abort reason changes product intent or acceptance criteria, ask the developer before writing the corrected todo story.
If the problem is better represented as a new defect or improvement input, recommend `SPEC_importIssue` instead of forcing user-story re-analysis.
Do not re-apply all analysis SKILLs — only apply what the abort diagnosis proves needs correction.
If no design, test, or code evidence exists but the abort reason is still unclear, ask the developer — do not speculate.

ONE-MORE-THING: ask developer if something not sure