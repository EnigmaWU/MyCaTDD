# SPEC_analyzeIssue

## Purpose

Analyze a pending issue, bug report, or defect, generate a user story artifact under `.catdd/spec/todoUS/`, and archive the raw issue under `.catdd/spec/analyzedNews/`.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the raw issue input, reason about observed behavior, expected behavior, and root-cause hypotheses, draft a repair-oriented user story, and verify it before accepting the output. When reproducible intent or expected behavior is missing, the reasoning loop surfaces questions instead of inventing requirements.

## Inputs

- `pending_issue`: issue file under `.catdd/spec/pendingNews/`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, logs, test docs, or reproduction notes.
- `SpecTodoUserStoryTemplate`: output template at `../../templates/SpecTodoUserStoryTemplate.md`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)
- Composed from requirements-analysis skills in `.github/skills/`: `write-user-story`, `build-feature-tree`, `elicit-requirements-models`, `extract-business-rules`, `facilitate-example-mapping`, `validate-requirements-criteria`, `prioritize-requirements`. See their `SKILL.md` for full technique details.

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact.
- The source issue moved from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/` as a team-shared raw input archive.
- An issue-focused, independently testable user story slice with observed behavior, expected behavior, priority, acceptance scenarios, edge cases, scope, non-goals, risks, assumptions, and acceptance questions.
- Source trace from the user story back to the archived raw issue artifact.
- The story follows `SpecTodoUserStoryTemplate.md` structure, with each section tracing to its source analysis technique.
- The story statement is framed as a repair: observed behavior → expected behavior → fix capability.

## Prompt Template

Apply the pipeline below. Each step summarizes the key technique; `(→ SKILL: name)` marks the source for more detail. Use `SpecTodoUserStoryTemplate.md` for the final output. The story is framed as a **repair** — the happy path is the corrected behavior, and error paths include regression scenarios (what must NOT break).

### Step 0 — Observed vs expected
Extract from the issue: what was observed, what was expected, and any root-cause hypotheses. If the expected behavior is missing or unreproducible, pause and ask — do not guess the fix.

### Step 1 — Is this story too big?
Inspect the pending issue. If it spans multiple independent defects, propose splitting into separate repair stories. `(→ SKILL: build-feature-tree)`

### Step 2 — Who, what, why?
Frame the story around the repair: "As a {{role}}, I want {{fix capability}}, So that {{expected behavior is restored}}." If role or value is absent, pause and create a question — do not invent. `(→ SKILL: write-user-story)`

### Step 3 — Discover scenarios
Identify paths: 1 happy path (corrected behavior), 1-2 alternate (valid variations of the fix), 1-2 error (regression scenarios — what must NOT break, what if the condition reappears). Keep each scenario atomic. `(→ SKILL: write-user-story)`

### Step 4 — Visualize and find gaps
Choose the right model type: state diagram (if repro steps involve state changes), flow diagram (action sequences), or context diagram (external actor interactions). Render as Mermaid.js. Trace the diagram for dead-end states, single-outcome decisions, unhandled failure paths. List each gap as a question. `(→ SKILL: elicit-requirements-models)`

### Step 5 — Extract hidden business rules
Scan the issue and related docs for policies, calculations, constraints, or regulations that governed the expected behavior. Classify each: Fact, Constraint, Action Enabler, Inference, Computation. If a rule implies a functional requirement, note it. `(→ SKILL: extract-business-rules)`

### Step 6 — Map rules to examples
For each acceptance scenario: state the governing Rule, give at least one concrete Example and one counter-example, list any open Questions. `(→ SKILL: facilitate-example-mapping)`

### Step 7 — Hunt ambiguity
Scan the entire story draft for vague terms: "fast", "robust", "seamless", "always", "never", "eventually". Also scan the original issue for ambiguous reproduction steps. Generate clarifying questions — do not silently substitute precise thresholds. `(→ SKILL: validate-requirements-criteria)`

### Step 8 — Prioritize
Score Business Value, User Value, Cost/Effort, and Risk/Complexity each 1-9. Compute Priority Score = (BV + UV) / (Cost + Risk). Record the rationale. `(→ SKILL: prioritize-requirements)`

### Step 9 — Write artifact & archive
Write `todoUS/*-UserStory.md` following `SpecTodoUserStoryTemplate.md`. Move the raw issue from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/`. Update trace links both ways. **Gate:** if any Initial Acceptance Questions remain open, mark the story NOT ready — it may not proceed to `SPEC_openUserStory`.

## Conflict Guard

If the issue lacks reproducible intent or expected behavior, create questions and keep the story draft incomplete instead of inventing requirements.

- If expected behavior cannot be determined from the issue: keep the story draft incomplete — do not guess.
- If Step 1 detects oversize: propose splitting, don't write one oversized repair story.
- If Step 4 finds unhandled model gaps: list them as questions, don't invent paths.
- If Step 5 finds implied but unspecified business rules: flag them, don't guess values.
- If Step 7 finds vague terms: flag them, don't silently substitute thresholds.

ONE-MORE-THING: ask developer if something not sure
