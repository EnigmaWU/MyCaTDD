# SPEC_takeDetailDesign

## Purpose

Create or update detailed design and acceptance criteria for the active user story.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the active user story and project context, reason about the design surfaces needed (detail design, error, resource, state, performance, compatibility, diagnosis), draft or update the relevant project-root README SPEC docs, and verify that acceptance criteria are testable and traceable before finalizing. Embedded software and digital media domain concerns should trigger additional reasoning cycles for error, resource, state, performance, compatibility, and diagnosis design surfaces.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `projectContext_file`: current project context.
- `readme_spec_files`: optional project-root `README*` SPEC files to create or update.
- `readme_spec_templates`: matching templates under `slashCommands/templates/`, such as `README_DetailDesignTemplate.md`, `README_ErrorDesignTemplate.md`, `README_ResourceDesignTemplate.md`, `README_StateDesignTemplate.md`, `README_PerfDesignTemplate.md`, `README_CompatDesignTemplate.md`, `README_DiagnosisDesignTemplate.md`, `README_VerifyDesignTemplate.md`, and `README_UsageDesignTemplate.md`.
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

## Prompt Template

Ask the assistant to design localized implementation details, class layouts, state machine transitions, and concrete API signatures before writing tests or product code, updating only the project-root Detailed-oriented README SPEC docs needed for the active story, keeping detailed design decisions traceable to story intent, and capturing the active story's lightweight implementation plan in the resulting design docs. For embedded or digital video/audio work, ensure localized state lifecycles and thread concurrency primitives are designed where relevant.

## Conflict Guard

Do not start coding from this command. Route to `SPEC_reviewDetailDesign` first.

ONE-MORE-THING: ask developer if something not sure
