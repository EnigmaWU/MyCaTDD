# SPEC_analyzeIssue

## Purpose

Analyze a pending issue, bug report, defect, support problem, or research input; extract detailed evidence, causes, implications, and actionable insights; generate a user story artifact under `.catdd/spec/todoUS/`; and archive the raw issue under `.catdd/spec/analyzedNews/`.

## CoT Pattern

**ReACT + ToT preflight, then mode-gated execution** — Stage 0.1 uses **ReACT** to inspect the raw issue, observe evidence gaps, and decide what must be clarified. Stage 0.2 uses **ToT** to branch across plausible interpretations, repair slices, and follow-up routes before choosing the best analysis path. After those stages, execution chooses either default `BRAINSTORM` mode or explicit `AUTONOMOUS` mode.

- `BRAINSTORM` mode is the default: chat with the developer step by step, ask focused clarification questions, refine the issue understanding, and generate `todoUS` only when the story is good enough or explicitly marked blocked/not-ready.
- `AUTONOMOUS` mode is opt-in only: generate `todoUS` by the predefined prompts below, record assumptions and open questions explicitly, and mark the story NOT ready when blocking intent or acceptance questions remain.

Use concise public reasoning summaries, not hidden chain-of-thought transcripts.

### ReACT Execution (Stage 0.1 — intake and clarification gate)

Inspect the pending issue and related evidence, then repeat until the good-enough gate passes or the story is explicitly blocked.

1. **Thought** — Identify what is known and what is missing across role, observed behavior, expected behavior, repair capability, scope, and testability.
2. **Action** — Read the minimum necessary artifacts: `pending_issue`, `projectContext_file`, and only the `related_docs` that close a named gap.
3. **Observation** — Check the good-enough gate below. If a gap could materially change role, value, scope, expected behavior, or acceptance criteria, return to **Thought** with one focused question.
4. **Stop** — Exit when the gate passes, or when a blocking question makes the story NOT ready.

Mode behavior inside the loop:

- In default `BRAINSTORM` mode, step 3 asks the developer the highest-value clarification question before generating `todoUS`, and the loop continues until the story is good enough, explicitly blocked, or the developer switches to `AUTONOMOUS`.
- In explicit `AUTONOMOUS` mode, step 3 does not pause. Unanswered items are recorded as assumptions, ambiguity warnings, or Initial Acceptance Questions, and blocking questions mark the story NOT ready for `SPEC_openUserStory`.

Good-enough gate for drafting `todoUS`:

- role or affected user is known or explicitly marked unknown
- observed behavior and expected behavior are distinguished
- primary repair capability is identified
- scope/non-goals are bounded enough to avoid an oversized story
- acceptance criteria can be tested or blocking questions are recorded
- evidence confidence is recorded for major claims

### ToT Execution (Stage 0.2 — candidate analysis and mode selection)

1. **Generate** — Produce 2-4 candidate interpretations before committing to one story shape: candidate repair story slices, candidate root-cause hypotheses, candidate split/follow-up issues, and the forbidden-input route (aborted UserStory input must stop and reroute to `SPEC_analyzeAbortedUserStory`).
2. **Evaluate** — Score each candidate on evidence strength, story size, user value, testability, risk, and fit with the issue origin.
3. **Select** — In `BRAINSTORM` mode, present the comparison and ask the developer to choose whenever more than one candidate is plausible. In `AUTONOMOUS` mode, select by evidence/risk and record discarded candidates as alternatives.
4. **Execute** — Run the Analysis Pipeline below against the selected candidate.
5. **Verify** — If the pipeline shows the selected shape is oversized or unsupported by evidence, return to **Select**.

Mode selection rule:

- If the developer explicitly requests `AUTONOMOUS`, run autonomous generation using this command's Analysis Pipeline.
- Otherwise default to `BRAINSTORM`, because issue analysis often contains hidden product intent and should converge through developer conversation before committing a todo story.

### Worked Example

An imported issue says the user guide is confusing:

```text
/SPEC_analyzeIssue
pending_issue: .catdd/spec/pendingNews/20260904-user-guide-confusing-Issue.md
analysis_mode: BRAINSTORM
```

**Stage 0.1 (ReACT)** — two passes:

- **Thought**: the issue names "developers" but not which journey; expected outcome is unstated.
- **Action**: read the pending issue, `README_UserGuide.md`, and project context — nothing more.
- **Observation**: the guide mixes onboarding, API usage, and scenario explanation. Role is too broad to bound scope → gate fails → back to **Thought**.
- **Thought/Action**: ask "Which developer journey should this story optimize first: first-time build/run, API integration, or service usage scenarios?" — developer answers *API integration*.
- **Observation**: role, expected behavior, and scope are now bounded → gate passes → **Stop**.

**Stage 0.2 (ToT)** — four candidates:

| Candidate | Interpretation | Evidence Strength | Risk | Decision |
| --- | --- | --- | --- | --- |
| A | Repair the user guide for new application developers integrating IOC APIs. | High: issue names developer usage and README_UserGuide target. | Medium: scope can grow into full documentation rewrite. | Preferred if developer confirms API integration is the primary journey. |
| B | Split into multiple documentation stories: build/run, API integration, and usage scenarios. | Medium: guide likely has multiple reader paths. | Low per story, higher coordination cost. | Follow-up candidate if Candidate A is still too broad. |
| C | Treat as an architecture/design issue. | Low: issue is documentation-facing, not a design failure. | High: would route work to the wrong lifecycle lane. | Reject unless new evidence shows design docs are incorrect. |
| D | Analyze an aborted UserStory as the source. | Forbidden in this command. | High: violates command boundary. | Stop and route to `SPEC_analyzeAbortedUserStory`. |

- **Select**: Candidate A, confirmed by the developer in Stage 0.1.
- **Execute**: Analysis Pipeline Steps 0-11 run against Candidate A.
- **Verify**: Step 3 finds the story still spans 3 functional areas → return to **Select** → Candidate B adopted as a split, with A kept as the first slice.
- Result: `.catdd/spec/todoUS/20260904-user-guide-api-integration-UserStory.md`, raw issue archived to `analyzedNews/` with `status: analyzed`.

## Inputs

- `pending_issue`: issue file under `.catdd/spec/pendingNews/`.
- `issue_origin`: optional `external_issue | defect_report | support_problem | research_input`.
- `projectContext_file`: current project context.
- `related_docs`: optional architecture, README, API, logs, test docs, or reproduction notes.
- `analysis_mode`: optional `BRAINSTORM | AUTONOMOUS` (default: `BRAINSTORM`; `AUTONOMOUS` must be explicit).
- `analysis_depth`: optional `standard | detailed | exhaustive` (default: `detailed`).
- `insight_focus`: optional focus areas such as `requirements | architecture | design | tests | risks | user-impact | process`.
- `SpecTodoUserStoryTemplate`: output template at `../../templates/SpecTodoUserStoryTemplate.md`.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [methodPrompts/README](../../../methodPrompts/README.md)
- Composed from requirements-analysis skills in `.github/skills/`: `write-user-story`, `build-feature-tree`, `elicit-requirements-models`, `extract-business-rules`, `facilitate-example-mapping`, `validate-requirements-criteria`, `prioritize-requirements`. See their `SKILL.md` for full technique details.

## Output Contract

- A `.catdd/spec/todoUS/*-UserStory.md` team-shared persistent user story artifact.
- The source issue moved from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/` as a team-shared raw input archive.
- The archived raw issue metadata is normalized to analyzed state:
  - `status: analyzed`
  - `analyzed_by: SPEC_analyzeIssue`
  - `analyzed_on: YYYY-MM-DD`
- An issue-focused, independently testable user story slice with observed behavior, expected behavior, priority, acceptance scenarios, edge cases, scope, non-goals, risks, assumptions, and acceptance questions.
- Source trace from the user story back to the archived raw issue artifact.
- Forward trace from the archived raw issue to generated artifacts:
  - `generated_todo_story`
  - `project_story_ledger`
  - related story reference (`related_active_story` or `related_closed_story` as applicable)
- The story follows `SpecTodoUserStoryTemplate.md` structure, with each section tracing to its source analysis technique.
- The story statement is framed as a repair: observed behavior → expected behavior → fix capability.
- A **Mode Decision** record documenting `analysis_mode`, why that mode was selected, what was clarified interactively, or which predefined prompts were used autonomously.
- A detailed **Issue Analysis & Insights** record embedded in the generated story or adjacent analysis notes, including:
  - evidence inventory and confidence level
  - observed vs expected delta
  - root-cause hypotheses and disconfirming checks
  - affected users, APIs, docs, tests, and design surfaces
  - hidden assumptions and implied requirements
  - insight list grouped by requirement, design, test, risk, and process learning
  - recommended story split or follow-up issue candidates

## Analysis Pipeline

Apply the pipeline below, driven by the ToT Execution step 4. Each step summarizes the key technique; `(→ SKILL: name)` marks the source for more detail. Use `SpecTodoUserStoryTemplate.md` for the final output. The story is framed as a **repair** — the happy path is the corrected behavior, and error paths include regression scenarios (what must NOT break).

### Step 0 — Classify origin and reject forbidden inputs

Classify the issue origin. This command accepts only pending issue, bug report, defect, support problem, or research input. It must not accept an aborted UserStory as input.

- If the input is `.catdd/spec/abortUS/*-UserStory.md`, a paired abort task artifact, or any request to analyze preserved abort evidence, stop immediately and route to `SPEC_analyzeAbortedUserStory`.
- Do not read or summarize abortUS evidence inside `SPEC_analyzeIssue`.

Create an evidence inventory table with source, facts found, confidence, and gaps.

### Step 1 — Observed vs expected

Extract from the issue: what was observed, what was expected, and any root-cause hypotheses. If the expected behavior is missing or unreproducible, pause and ask — do not guess the fix.

### Step 2 — Build the issue insight map

Before writing the story, extract insights in detail. At minimum, produce:

| Insight Type | Required Questions |
| --- | --- |
| Requirement insight | What requirement was missing, ambiguous, wrong, or too broad? |
| Architecture/design insight | What design boundary, dependency, state, or interface is implicated? |
| Test insight | What verification gap allowed the issue to survive? |
| Risk insight | What user, data, compatibility, performance, or maintainability risk is exposed? |
| Process insight | What workflow, documentation, or handoff gap should be improved? |

For each insight, record evidence, confidence (`high | medium | low`), and whether it should become acceptance criteria, a sub-UserStory, a non-goal, or a follow-up issue.

### Step 3 — Is this story too big?

Inspect the pending issue. If it spans multiple independent defects, propose splitting into separate repair stories. `(→ SKILL: build-feature-tree)`

### Step 4 — Who, what, why?

Frame the story around the repair: "As a {{role}}, I want {{fix capability}}, So that {{expected behavior is restored}}." If role or value is absent, pause and create a question — do not invent. `(→ SKILL: write-user-story)`

### Step 5 — Discover scenarios

Identify paths: 1 happy path (corrected behavior), 1-2 alternate (valid variations of the fix), 1-2 error (regression scenarios — what must NOT break, what if the condition reappears). Keep each scenario atomic. `(→ SKILL: write-user-story)`

### Step 6 — Visualize and find gaps

Choose the right model type: state diagram (if repro steps involve state changes), flow diagram (action sequences), or context diagram (external actor interactions). Render as Mermaid.js. Trace the diagram for dead-end states, single-outcome decisions, unhandled failure paths. List each gap as a question. `(→ SKILL: elicit-requirements-models)`

### Step 7 — Extract hidden business rules

Scan the issue and related docs for policies, calculations, constraints, or regulations that governed the expected behavior. Classify each: Fact, Constraint, Action Enabler, Inference, Computation. If a rule implies a functional requirement, note it. `(→ SKILL: extract-business-rules)`

### Step 8 — Map rules to examples

For each acceptance scenario: state the governing Rule, give at least one concrete Example and one counter-example, list any open Questions. `(→ SKILL: facilitate-example-mapping)`

### Step 9 — Hunt ambiguity

Scan the entire story draft and reproduction steps for Ambiguity Smells using the Ambiguity Smell Taxonomy (AST):
- `SMELL-ACTOR`: Passive voice without actor ("repro steps state data is corrupted without specifying actor or trigger").
- `SMELL-BOUND`: Unbounded / subjective adjectives ("fast", "robust", "seamless", "always", "never", "eventually", "properly").
- `SMELL-BRANCH`: Missing negative/regression branches (silent on what happens if the fix encounters timeout, error, or bad input).
- `SMELL-STATE`: Unstated lifecycle bounds (state machine prerequisites for the repair).
- `SMELL-VAGUE`: Vague verbs & loophole words ("handle", "manage", "support", "etc.", "generally").
- `SMELL-RACE`: Unstated concurrency bounds or race conditions causing the issue.
Generate clarifying questions under `## Ambiguity Warnings` and `## Initial Acceptance Questions` — do not silently substitute precise thresholds or fabricate missing paths. `(→ SKILL: validate-requirements-criteria)`

### Step 10 — Prioritize

Score Business Value, User Value, Cost/Effort, and Risk/Complexity each 1-9. Compute Priority Score = (BV + UV) / (Cost + Risk). Record the rationale. `(→ SKILL: prioritize-requirements)`

### Step 11 — Write artifact & archive

Write `todoUS/*-UserStory.md` following `SpecTodoUserStoryTemplate.md`. Move the raw issue from `.catdd/spec/pendingNews/` to `.catdd/spec/analyzedNews/`. Update trace links both ways. **Gate:** if any Initial Acceptance Questions remain open, mark the story NOT ready — it may not proceed to `SPEC_openUserStory`.

After moving the raw issue, normalize analyzed metadata and trace in the archived issue file:

- set `status: analyzed`
- add/update `analyzed_by: SPEC_analyzeIssue`
- add/update `analyzed_on: YYYY-MM-DD`
- add `generated_todo_story` and `project_story_ledger` trace links
- update related story reference from stale doing links to the correct active/closed path

## Conflict Guard

If the issue lacks reproducible intent or expected behavior, create questions and keep the story draft incomplete instead of inventing requirements.

- Do not run `AUTONOMOUS` mode unless the developer explicitly requested it.
- In `BRAINSTORM` mode, do not generate `todoUS` before the good-enough gate passes unless the output is explicitly marked incomplete/not-ready.
- In `AUTONOMOUS` mode, do not hide missing intent behind assumptions. Record every material unknown as an Initial Acceptance Question, Ambiguity Warning, or Risk/Assumption entry.
- If the input is an aborted UserStory, paired abort task artifact, or preserved abort evidence, stop and route to `SPEC_analyzeAbortedUserStory`; do not synthesize a new issue story here.
- If issue analysis would require reading `.catdd/spec/abortUS/` evidence, stop and ask the developer to run `SPEC_analyzeAbortedUserStory`.
- If expected behavior cannot be determined from the issue: keep the story draft incomplete — do not guess.
- If Step 3 detects oversize: propose splitting, don't write one oversized repair story.
- If Step 6 finds unhandled model gaps: list them as questions, don't invent paths.
- If Step 7 finds implied but unspecified business rules: flag them, don't guess values.
- If Step 9 finds Ambiguity Smells or vague terms: flag them, don't silently substitute thresholds or fabricate branches.
- If an insight is plausible but not evidenced, label it as a hypothesis with a disconfirming check — do not present it as fact.

ONE-MORE-THING: ask developer if something not sure (Universal Stop Rule: MUST halt and ask developer in both manualMode and autonomousMode)
