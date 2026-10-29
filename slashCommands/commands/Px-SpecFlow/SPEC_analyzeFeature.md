# SPEC_analyzeFeature

## Purpose

Analyze a pending feature request, enhancement, or imported structured user-story source, generate a user story artifact under `.catdd/spec/todoUS/`, and archive the raw input under `.catdd/spec/analyzedNews/`.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the raw feature or user-story input, reason about user value, actor, and outcome, draft a lifecycle-ready user story, and verify it against quality criteria before accepting the output. When inputs are ambiguous or incomplete, the reasoning loop surfaces questions instead of inventing requirements.

Execution supports two local analysis modes:
- `BRAINSTORM` mode (default): chat with the developer step by step, ask focused clarification questions, and refine the feature understanding interactively.
- `AUTONOMOUS` mode (opt-in): execute the composed 9-step analysis pipeline in one shot to generate `todoUS`, record assumptions and open questions explicitly, and mark the story NOT ready if blocking questions remain.

### ReACT Execution

The Analysis Pipeline below is not a straight run — wrap it in this loop.

1. **Thought** — Identify which pipeline step is next and whether its inputs actually exist in the source. Never substitute a missing input with an invented one. In `BRAINSTORM` mode, ask the developer for missing intent; in `AUTONOMOUS` mode, record missing intent as questions and continue the pipeline.
2. **Action** — Run that single pipeline step.
3. **Observation** — Inspect what the step produced:
   - Step 1 says oversized → propose a split and restart at Step 1 with the first slice.
   - Steps 4, 5, or 7 produced open questions → record them and continue; do not fill the gap.
   - Step 2 lacks role, capability, or business value → in `BRAINSTORM` mode, stop and ask the developer; in `AUTONOMOUS` mode, record a blocking question.
4. **Stop** — Exit after Step 9. If any Initial Acceptance Question is still open, mark the story NOT ready; it may not proceed to `SPEC_openUserStory`.

## Usage Example

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
- **Step 9**: written to `.catdd/spec/todoUS/`, raw feature archived to `analyzedNews/` with `status: analyzed` and a `## Chat History` section recording the feature-tree split and ambiguity Q&A. Two questions remain open → story marked **NOT ready**; it cannot proceed to `SPEC_openUserStory` until they are answered.

## Inputs

- `pending_feature`: feature or imported user-story file under `.catdd/spec/pendingNews/`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, design, product, or test docs.
- `SpecTodoUserStoryTemplate`: output template at `../../templates/SpecTodoUserStoryTemplate.md`.
- `analysis_mode`: optional `BRAINSTORM | AUTONOMOUS` (default: `BRAINSTORM`; `AUTONOMOUS` must be explicit).
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). When `autonomousMode` is requested, record the mode in the pending artifact or downstream handoff; autonomous execution is strictly supported only for implementation-oriented stories once planned.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts](../../../methodPrompts/README.md)
- [Project-Wide Traceability IDs](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids)
- Composed from requirements-analysis skills in `.github/skills/`: `write-user-story`, `build-feature-tree`, `elicit-requirements-models`, `extract-business-rules`, `facilitate-example-mapping`, `validate-requirements-criteria`, `prioritize-requirements`. See their `SKILL.md` for full technique details.

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact.
- A project-wide Story ID registered in `README_UserStories.md` and full Story-qualified AC IDs in the story.
- The source feature or imported user-story input moved from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/` as a team-shared raw input archive.
- The archived raw feature metadata is normalized to analyzed state:
  - `status: analyzed`
  - `analyzed_by: SPEC_analyzeFeature`
  - `analyzed_on: YYYY-MM-DD`
  - `analysis_mode: BRAINSTORM | AUTONOMOUS`
- A mandatory `## Chat History` (`chatHistory`) section appended to the archived `.catdd/spec/analyzedNews/*-Feature.md` file to preserve how the feature was analyzed:
  - In `BRAINSTORM` mode: chronological turn-by-turn or Q&A record of the developer and CodeAgent dialogue (clarification questions asked, developer answers/quotes, feature-tree split proposals and selections, business-rule/ambiguity resolutions, and final `BRAINSTORM` decisions).
  - In `AUTONOMOUS` mode: chronological autonomous reasoning/prompt trace across Steps 1-9, recorded assumptions, and open `ONE-MORE-THING` / Initial Acceptance Questions surfaced.
- A value-focused, independently testable user story slice with user value, priority, acceptance scenarios, edge cases, scope, non-goals, risks, assumptions, and initial acceptance questions.
- Source trace from the user story back to the archived raw input artifact, and forward trace (`generated_todo_story`, `project_story_ledger`) in the archived raw feature.
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
Scan the entire story draft for Ambiguity Smells using the Ambiguity Smell Taxonomy (AST):
- `SMELL-ACTOR`: Passive voice without actor ("data will be synced", "events are processed").
- `SMELL-BOUND`: Unbounded / subjective adjectives ("fast", "robust", "seamless", "always", "never", "reliable", "efficient", "real-time").
- `SMELL-BRANCH`: Missing negative branches (silent on timeout, network drop, retry exhaustion, cancellation).
- `SMELL-STATE`: Unstated lifecycle bounds (calling APIs before init, during drain, or after close).
- `SMELL-VAGUE`: Vague verbs & loophole words ("handle", "manage", "support", "etc.", "generally", "if possible").
- `SMELL-MODAL`: Weak/ambiguous modal verbs in ACs or rules ("should", "might", "could", "is expected to" without an explicit `SHOULD` exception condition) or synonym drift against `README_UbiLang.md` (`EPIC E1.4 & I2.1`). Mandatory AC outcomes **MUST** use `MUST` / `MUST NOT`.
- `SMELL-RACE`: Unstated concurrency bounds (simultaneous calls without synchronization rules).
For each smell, generate a precise clarifying question under `## Ambiguity Warnings` and `## Initial Acceptance Questions` (e.g., "Is 'fast' 500ms or 5s?"). Do not silently substitute your own threshold or fabricate missing branches. Also verify each scenario tests exactly one behavior. `(→ SKILL: validate-requirements-criteria)`

### Step 8 — Prioritize
Score Business Value, User Value, Cost/Effort, and Risk/Complexity each 1-9. Compute Priority Score = (BV + UV) / (Cost + Risk). Record the rationale for each score. If fewer than 3 items exist in total, skip formal scoring and use pairwise comparison instead. `(→ SKILL: prioritize-requirements)`

### Step 9 — Write artifact & archive
Before writing the todo artifact, register its Story ID in `README_UserStories.md`, creating the ledger from `README_UserStoriesTemplate.md` if needed. Follow [Project-Wide Traceability IDs](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids): preserve an existing unambiguous ID or derive a descriptive human-readable ID in `US-<whoName>-<doWhat>` form, writing both segments in lowerCamelCase. Derive them from the story's actor and observable behavior, and ask if either is unclear. Check the registry and known story sources, and give every AC a distinct qualified ID. Refine a collision with meaningful context rather than an arbitrary number or UUID. Register blocked drafts too; do not archive the input while identity registration is unresolved. Preserve source IDs as labeled aliases and stop on conflicting or ambiguous identities.

Write `todoUS/*-UserStory.md` following `SpecTodoUserStoryTemplate.md`, including the Stage 1 EPIC-mapped `## Story Readiness Snapshot` (`E1 Unambiguous`, `E2 Singular`, `E3 Verifiable`, `E3.4 Completion & Readiness`, `P1 Dependency Control`, `P2 Complete`, `I1 Conforming`, `C1 Scope Discipline`) and story-specific `## Story Completion Conditions (`EPIC E3.4`)` (`Required TestLevel`, `Required TestScope & Environment`, `Required CaTDD Categories`, `Required SPEC & Doc Surfaces`, `Not-Done Conditions`, and `Approved Deferrals`). Move the raw feature from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/`. Update trace links both ways. **Gate:** if any Initial Acceptance Questions remain open or any required Stage 1 EPIC lens in `## Story Readiness Snapshot` is `no`, mark the story NOT ready — it may not proceed to `SPEC_openUserStory` until resolved (the full 10-dimension `## EPIC Specification Sufficiency` ledger will be seeded in `*-UserStory-Tasks.md` by `SPEC_makePlan`).

After moving the raw feature, normalize analyzed metadata, append `## Chat History`, and update trace links in the archived `.catdd/spec/analyzedNews/*-Feature.md` file:

- set `status: analyzed`
- add/update `analyzed_by: SPEC_analyzeFeature`
- add/update `analyzed_on: YYYY-MM-DD`
- add/update `analysis_mode: BRAINSTORM | AUTONOMOUS`
- add `generated_todo_story` and `project_story_ledger` trace links
- append `## Chat History` (`chatHistory`) recording how the feature was analyzed:
  - In `BRAINSTORM` mode, capture each clarification round (`Turn # | Speaker / Prompt | Question or Proposal | Developer Answer / Decision | Impact on Story / Scope`), feature-tree split choices, and confirmed `BRAINSTORM` decisions so the interactive analysis rationale is never lost in ephemeral chat.
  - In `AUTONOMOUS` mode, capture the autonomous analysis prompt trace across Steps 1-9, assumptions, and open questions.

## Conflict Guard

If the feature or imported user-story source lacks user value, actor, or outcome, create questions and keep the story draft incomplete instead of inventing requirements.

- Do not archive a raw feature into `.catdd/spec/analyzedNews/` without appending a `## Chat History` section (`chatHistory`) that records how the feature was analyzed (especially the developer/CodeAgent dialogue and decisions in `BRAINSTORM` mode).
- Do not run `AUTONOMOUS` mode unless the developer explicitly requested it.
- In `BRAINSTORM` mode, do not generate `todoUS` before key intent is clarified with the developer.
- In `AUTONOMOUS` mode, do not hide missing intent behind assumptions; record every material unknown as an Initial Acceptance Question.
- If Step 1 detects oversize: propose splitting, don't write one oversized story.
- If Step 4 finds unhandled model gaps: list them as questions, don't invent paths.
- If Step 5 finds implied but unspecified business rules: flag them, don't guess values.
- If Step 7 finds Ambiguity Smells or vague terms: flag them, don't silently substitute thresholds or fabricate branches.

ONE-MORE-THING: ask developer if something not sure (Universal Stop Rule: MUST halt and ask developer in both manualMode and autonomousMode)
