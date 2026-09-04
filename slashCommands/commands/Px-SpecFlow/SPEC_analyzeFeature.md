# SPEC_analyzeFeature

## Purpose

Analyze a pending feature request, enhancement, or imported structured user-story source, generate a user story artifact under `.catdd/spec/todoUS/`, and archive the raw input under `.catdd/spec/analyzedNews/`.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the raw feature or user-story input, reason about user value, actor, and outcome, draft a lifecycle-ready user story, and verify it against quality criteria before accepting the output. When inputs are ambiguous or incomplete, the reasoning loop surfaces questions instead of inventing requirements.

### ReACT Execution

The Analysis Pipeline below is not a straight run — wrap it in this loop.

1. **Thought** — Identify which pipeline step is next and whether its inputs actually exist in the source. Never substitute a missing input with an invented one.
2. **Action** — Run that single pipeline step.
3. **Observation** — Inspect what the step produced:
   - Step 1 says oversized → propose a split and restart at Step 1 with the first slice.
   - Steps 4, 5, or 7 produced open questions → record them and continue; do not fill the gap.
   - Step 2 lacks role, capability, or business value → stop and ask the developer.
4. **Stop** — Exit after Step 9. If any Initial Acceptance Question is still open, mark the story NOT ready; it may not proceed to `SPEC_openUserStory`.

### Worked Example

A feature request is analyzed into a story:

```text
/SPEC_analyzeFeature
pending_feature: .catdd/spec/pendingNews/20260904-per-merchant-retry-cap-Feature.md
projectContext_file: .catdd/spec/projectContext.md
```

Expected result:

- **Thought/Action/Observation (Step 1)**: the request touches retry policy, merchant config, and the admin UI — 3 functional areas → borderline. Feature tree gives L1 `retry policy` / L2 `per-merchant override`. Admin UI is split out as a follow-up → restart Step 1 on the first slice → now single-area, passes.
- **Step 2**: role `merchant admin`, capability `cap retry attempts`, value `avoid duplicate charges on non-idempotent endpoints` → all three present, no stop.
- **Step 3**: 1 happy + 1 alternate (cap = 0) + 2 error (cap above system max, cap not numeric) = 4 scenarios.
- **Step 5**: implied rule — "cap must not exceed the system-wide max" — but the max is never stated. Flagged as a question. **Not** guessed.
- **Step 7**: source says retries should stop "quickly" → flagged: "Is 'quickly' a time bound or an attempt bound?" No threshold substituted.
- **Step 8**: BV 7, UV 8, Cost 3, Risk 2 → score 3.0.
- **Step 9**: written to `.catdd/spec/todoUS/`, raw feature archived to `analyzedNews/`. Two questions remain open → story marked **NOT ready**; it cannot proceed to `SPEC_openUserStory` until they are answered.

## Inputs

- `pending_feature`: feature or imported user-story file under `.catdd/spec/pendingNews/`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, design, product, or test docs.
- `SpecTodoUserStoryTemplate`: output template at `../../templates/SpecTodoUserStoryTemplate.md`.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)
- Composed from requirements-analysis skills in `.github/skills/`: `write-user-story`, `build-feature-tree`, `elicit-requirements-models`, `extract-business-rules`, `facilitate-example-mapping`, `validate-requirements-criteria`, `prioritize-requirements`. See their `SKILL.md` for full technique details.

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact.
- The source feature or imported user-story input moved from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/` as a team-shared raw input archive.
- A value-focused, independently testable user story slice with user value, priority, acceptance scenarios, edge cases, scope, non-goals, risks, assumptions, and initial acceptance questions.
- Source trace from the user story back to the archived raw input artifact.
- The story follows `SpecTodoUserStoryTemplate.md` structure, with each section tracing to its source analysis technique.

## Analysis Pipeline

Apply the pipeline below, driven by the ReACT Execution loop. Each step summarizes the key technique; `(→ SKILL: name)` marks the source for more detail. Use `SpecTodoUserStoryTemplate.md` for the final output.

### Step 1 — Is this story too big?
Inspect the pending feature. If it spans >3 functional areas or would need >7 acceptance scenarios, it may need splitting. Group into L1 areas → L2 groups → L3 features. Propose a split before continuing. `(→ SKILL: build-feature-tree)`

### Step 2 — Who, what, why?
Extract the **role**, **capability**, and **business value** for the story statement. If any of these three are absent or ambiguous, pause and create a question — do not invent. `(→ SKILL: write-user-story)`

### Step 3 — Discover scenarios
Identify paths: 1 happy path, 1-2 alternate (valid variations), 1-2 error (invalid input, failure). Keep each scenario atomic — one behavior only. Do not fabricate paths the input doesn't support; flag missing ones as open questions. Aim for 3-7 total. `(→ SKILL: write-user-story)`

### Step 4 — Visualize and find gaps
Choose the right model type: state diagram (if status changes over time), flow diagram (if action sequences), or context diagram (if external actors matter). Render as Mermaid.js. Then trace the diagram: are there dead-end states? decisions with only one outcome? unhandled failure paths? List each gap as a clarifying question — do not invent paths. `(→ SKILL: elicit-requirements-models)`

### Step 5 — Extract hidden business rules
Scan the feature text for policies, calculations, regulations, or constraints that are business logic (not software functions). Classify each: Fact, Constraint, Action Enabler, Inference, Computation. If a rule implies a functional requirement (e.g., "must be 18" → system needs birthdate input), note it. If a calculation is implied but the formula is missing, flag it as a question. `(→ SKILL: extract-business-rules)`

### Step 6 — Map rules to examples
For each acceptance scenario: state the governing Rule, provide at least one concrete Example and one counter-example, list any open Questions. If too many Rules accumulate, the story may be too big — consider splitting. `(→ SKILL: facilitate-example-mapping)`

### Step 7 — Hunt ambiguity
Scan the entire story draft for vague terms: "fast", "robust", "seamless", "always", "never", "reliable". For each, generate a precise clarifying question (e.g., "Is 'fast' 500ms or 5s?"). Do not silently substitute your own threshold. Also verify each scenario tests exactly one behavior. `(→ SKILL: validate-requirements-criteria)`

### Step 8 — Prioritize
Score Business Value, User Value, Cost/Effort, and Risk/Complexity each 1-9. Compute Priority Score = (BV + UV) / (Cost + Risk). Record the rationale for each score. If fewer than 3 items exist in total, skip formal scoring and use pairwise comparison instead. `(→ SKILL: prioritize-requirements)`

### Step 9 — Write artifact & archive
Write `todoUS/*-UserStory.md` following `SpecTodoUserStoryTemplate.md`. Move the raw feature from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/`. Update trace links both ways. **Gate:** if any Initial Acceptance Questions remain open, mark the story NOT ready — it may not proceed to `SPEC_openUserStory`.

## Conflict Guard

If the feature or imported user-story source lacks user value, actor, or outcome, create questions and keep the story draft incomplete instead of inventing requirements.

- If Step 1 detects oversize: propose splitting, don't write one oversized story.
- If Step 4 finds unhandled model gaps: list them as questions, don't invent paths.
- If Step 5 finds implied but unspecified business rules: flag them, don't guess values.
- If Step 7 finds vague terms: flag them, don't silently substitute thresholds.

ONE-MORE-THING: ask developer if something not sure
