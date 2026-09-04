# SPEC_takeDetailDesign

## Purpose

Create or update detailed design and acceptance criteria for the active user story.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the active user story and project context, reason about the design surfaces needed (detail design, error, resource, state, performance, compatibility, diagnosis), draft or update the relevant project-root README SPEC docs, and verify that acceptance criteria are testable and traceable before finalizing. Embedded software and digital media domain concerns should trigger additional reasoning cycles for error, resource, state, performance, compatibility, and diagnosis design surfaces.

### ReACT Execution

Repeat until every acceptance criterion is convertible to a CaTDD skeleton.

1. **Thought** — Decide which design surfaces this story actually changes. Do not open a README SPEC doc the story does not touch.
2. **Action** — Draft or update only those docs, seeding first-time files from the matching `slashCommands/templates/README_*Template.md`. Include the story's lightweight implementation plan: technical context, structure decisions, constraints, verification strategy. Apply the Skill Integration Policy, falling back to the Builtin Skill Checklist.
3. **Observation** — Test each acceptance criterion against the Verification builtin: can it become a US/AC/TC skeleton as written? An untestable AC, an undocumented state transition, or an architecture quality scenario that was dropped instead of carried into detail constraints returns to **Action**.
4. **Stop** — Exit when all ACs are convertible and assumptions/constraints/open questions are explicit. Report `next_command = SPEC_reviewDetailDesign`. Coding does not start here.

For embedded or digital video/audio work, step 2 must also design localized state lifecycles and thread concurrency primitives.

### Worked Example

Detailing the gateway adapter story after architecture review passed:

```text
/SPEC_takeDetailDesign
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
readme_spec_files: README_DetailDesign.md, README_ErrorDesign.md, README_StateDesign.md
```

Expected result — two passes:

- **Thought**: the story changes the adapter API, its failure modes, and its connection state machine → three docs. It does not touch performance or compatibility → those docs stay closed.
- **Action**: `README_DetailDesign.md` gets the port signature; `README_ErrorDesign.md` gets timeout/refusal/partial-settlement cases; `README_StateDesign.md` gets `idle → connecting → ready → degraded` including invalid-transition handling.
- **Observation**: AC-03 reads "gateway failures are handled gracefully" — not convertible to a TC → back to **Action**.
- **Action (pass 2)**: AC-03 rewritten as "on gateway timeout, the adapter returns `GatewayTimeout` without retrying, and emits one diagnostic event".
- **Observation**: all ACs now map to Typical/Edge/Fault skeletons; the architecture's p95 latency scenario is carried across as a detail constraint → **Stop**.
- Reported: `next_command = SPEC_reviewDetailDesign`.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `projectContext_file`: current project context.
- `readme_spec_files`: optional project-root README SPEC files to create or update, including `README_ArchDesign.md`, `README_UserStories.md`, `README_UserGuide.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_VerifyDesign.md`, and `README_UsageDesign.md` when the active story changes those design surfaces.
- `readme_spec_templates`: matching templates under `slashCommands/templates/`, such as `README_DetailDesignTemplate.md`, `README_ErrorDesignTemplate.md`, `README_ResourceDesignTemplate.md`, `README_StateDesignTemplate.md`, `README_PerfDesignTemplate.md`, `README_CompatDesignTemplate.md`, `README_DiagnosisDesignTemplate.md`, `README_VerifyDesignTemplate.md`, `README_UsageDesignLiteCliTemplate.md`, and `README_UsageDesignMicroServiceTemplate.md`.
- `design_target`: optional project-root README SPEC file, API contract, architecture note, or detail design target.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Skill Integration Policy

- Skill-first rule: if relevant architecture skills exist in the workspace, use them to shape detailed design output quality.
- Preferred skills and usage:
  - `design-architecture-viewpoints` to check detail-level consistency with approved architecture views and ownership boundaries.
  - `apply-architectural-tactics` to carry architecture quality scenarios into concrete detail constraints and implementation guidance.
  - `document-architectural-decisions` when detail-level design choices become architecture-significant and require ADR promotion.
- Builtin fallback rule: if one or more relevant skills are unavailable, apply the learned builtin-skill detail checklist covering: API contract clarity, state transition ownership, resource/error constraints, and AC-to-test conversion readiness.
- Completion rule: lack of skill availability must not block generation of complete detailed design artifacts. Skills are preferred when present; builtin-skill behavior is mandatory fallback.

### Builtin Skill Checklist (when skills are unavailable)

- Detail-view builtin: map each architecture boundary to concrete API/module ownership in detailed design.
- State builtin: document local state transitions, ownership, and invalid transition handling.
- Constraint builtin: document error/resource/compatibility/performance constraints that affect implementation choices.
- Tactics carryover builtin: preserve architecture quality scenarios as detail-level acceptance constraints.
- Verification builtin: ensure each acceptance criterion is convertible to CaTDD US/AC/TC skeletons.

## Output Contract

- Project-root README SPEC docs as needed: `README_DetailDesign.md` and `README_StateDesign.md`.
- First-time README SPEC docs should be based on the corresponding `slashCommands/templates/README_*Template.md` file.
- A lightweight implementation plan inside the relevant README SPEC docs, covering technical context, structure decisions, constraints, and verification strategy for the active story.
- Detailed design notes tied to the active user story in team-shared `.catdd/spec/doingUS/` work state or team-shared project-root README SPEC docs.
- Acceptance criteria that can be converted into CaTDD US/AC/TC skeletons.
- Explicit assumptions, constraints, and unresolved questions.

## Conflict Guard

Do not start coding from this command. Route to `SPEC_reviewDetailDesign` first.

ONE-MORE-THING: ask developer if something not sure
