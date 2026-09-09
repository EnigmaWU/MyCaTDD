# SPEC_takeArchDesign

## Purpose

Create or update high-level architecture design for the architecture-changing active user story, defining module-context architecture and consuming-system context, architecture views, architecture-oriented SPEC surface coverage, component decomposition, module boundaries, dependencies, data flows, and key technical trade-offs before detailed class or API design begins.

Model guidance: use a SOTA reasoning-capable LLM for this command (for example, GPT-5.5-xHigh) because architecture design requires deep thinking across competing constraints and complex trade-off analysis.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the architecture-changing active user story, requirements (e.g. `README_UserStory.md` / `doingUS/`), and project context, reason about the structural decomposition and adapter boundaries, draft or update the project-root `README_ArchDesign.md`, and verify that component structures are traceable to requirements and fit the project guidelines before finalizing. Include Mermaid-renderable C4-style architecture views (system context, container, component, runtime execution, and deployment) or explicitly mark a view as not applicable. Also declare how Px-SpecFlow architecture-oriented surfaces (`README_UsageDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_VerifyDesign.md`, and relevant state design sources) are covered, delegated, deferred, or not applicable. When the architecture document already contains earlier architectural work, update its traceability to distinguish baseline architecture stories from the current architecture-changing update story instead of replacing everything with the newest opened story. For embedded software or digital video/audio domain work, add hardware boundaries, RTOS task structures, media pipelines, and synchronization boundaries to the architecture design.

### ReACT Execution

Repeat until every architecture view and SPEC surface is either covered or explicitly marked not applicable.

1. **Thought** — Read `doing_user_story`, `projectContext_file`, and any existing `README_ArchDesign.md`. Identify which structural decisions the story actually forces, and which existing architecture it merely consumes.
2. **Action** — Draft or update `README_ArchDesign.md` from `README_ArchDesignTemplate.md`: module context, consuming-system context, C4-style views, SPEC surface coverage, and Key Decisions. Apply the Skill Integration Policy, falling back to the Builtin Skill Checklist when skills are unavailable.
3. **Observation** — Check the draft:
   - A view is missing and not marked not-applicable → back to **Action**.
   - A component traces to no requirement, or a requirement reaches no component → back to **Thought**.
   - An unrelated opened story was recorded as an architecture trace owner when it only consumes the architecture → back to **Action** to correct the traceability.
   - Fewer than three measurable quality scenarios, or no recorded tradeoffs → back to **Action**.
4. **Stop** — Exit when views, coverage, and traceability all hold. Report `next_command = SPEC_reviewArchDesign`. Detailed design, tests, and code do not start here.

For embedded or digital video/audio work, step 2 must also place hardware boundaries, RTOS task structures, media pipelines, buffer topologies, and sample-format parameters.

### Worked Example

A story introduces a pluggable payment gateway:

```text
/SPEC_takeArchDesign
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
readme_arch_design: README_ArchDesign.md
readme_arch_template: slashCommands/templates/README_ArchDesignTemplate.md
```

Expected result — two passes:

- **Thought**: the story forces a new adapter boundary (gateway port + per-provider adapters). It only *consumes* the existing auth architecture — so auth is not re-traced to this story.
- **Action**: drafted module context, consuming-system context, C4 context/container/component views, and 3 quality scenarios in `Source, Stimulus, Environment, Response, Response Measure` form.
- **Observation**: deployment view missing and not marked not-applicable; `README_CompatDesign.md` coverage undeclared → back to **Action**.
- **Action (pass 2)**: deployment view added; compatibility declared *delegated* to `SPEC_takeDetailDesign`; two sensitivity points and two tradeoff points recorded.
- **Observation**: every component traces to an AC; no unrelated story claimed as trace owner → **Stop**.
- Reported: `next_command = SPEC_reviewArchDesign`.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/` that creates or changes architecture decisions, architecture boundaries, deployment/runtime strategy, or architecture-oriented SPEC surfaces.
- `projectContext_file`: current project context.
- `readme_arch_design`: project-root `README_ArchDesign.md` to create or update.
- `readme_arch_template`: matching template under `slashCommands/templates/README_ArchDesignTemplate.md`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Skill Integration Policy

- Skill-first rule: if relevant architecture skills exist in the workspace, use them for this command execution.
- Preferred skills and usage:
	- `design-architecture-viewpoints` for stakeholder-to-viewpoint mapping, view coverage depth, inter-view consistency checks, and the Security Perspective (trust boundaries, STRIDE threat models, principals vs. assets).
	- `apply-architectural-tactics` for ASR extraction, measurable quality-attribute scenarios, tactic selection (including security tactics: detect, resist, react, recover), and tradeoff clarity.
	- `document-architectural-decisions` for ADR-quality alternatives/argument/implication structure when architecture-significant choices are made.
	- `design-tool-use-sandboxing` when the architecture involves CodeAgents, LLM tool execution, or runtime sandboxes (partitioning safe read-only tools vs. dangerous mutative actions with human approval gates).
	- `analyze-with-tactics-questionnaires` for evaluating security, availability, and modifiability tactics against architectural questionnaires.
- Builtin fallback rule: if one or more relevant skills are unavailable, apply the learned builtin-skill checklist in this command covering: stakeholders and concerns, C4-style views, at least three measurable quality scenarios, explicit tradeoffs/risks, security/sandbox boundaries, and decision traceability.
- Completion rule: command completion must not depend on skill availability. Skills are preferred when present; builtin-skill behavior is mandatory fallback.

### Builtin Skill Checklist (when skills are unavailable)

- Viewpoint builtin: identify at least three stakeholder groups, map each to concerns, and cover them in Context/Container/Component/Deployment views.
- Consistency builtin: explicitly check Context vs Functional boundaries, Functional vs Development ownership, and Concurrency vs Deployment placement.
- Tactics builtin: define at least three measurable quality scenarios using `Source, Stimulus, Environment, Response, Response Measure`.
- Security & trust boundary builtin: when security design is in scope, identify protected assets, trust boundaries, STRIDE threats, constitutional invariants ($K$), and least-privilege tool sandboxing.
- Tradeoff builtin: record at least two sensitivity points and two tradeoff points for major design decisions.
- Decision builtin: when architecture-significant choices exist, include alternatives, selected option, argument, implications, and trace links.

## Output Contract

- Project-root `README_ArchDesign.md` containing high-level architecture goals, module boundaries, dependencies, data flow, key decisions, and risks.
- Explicit module-context section: module responsibility, owned boundaries, public surface, and interaction contracts with systems that use this module.
- Explicit consuming-system context section: upstream/downstream systems, integration responsibilities, and trust/failure boundaries.
- Architecture views, at minimum Mermaid-renderable C4-style system context, container, component, runtime execution, and deployment views, unless a view is explicitly not applicable.
- Architecture-oriented SPEC surface coverage, declaring whether usage, error, resource, performance, compatibility, diagnosis, verification, and state concerns are covered here, delegated, deferred, or not applicable.
- Created `README_ArchDesign.md` must be based on the `slashCommands/templates/README_ArchDesignTemplate.md` template.
- Integration alignment between components and interfaces, establishing adapter boundaries for IDEs/agents.
- Explicit technical trade-offs and rationale recorded under Key Decisions.

## Conflict Guard

Do not start low-level detailed design, test writing, or coding from this command. Route to `SPEC_reviewArchDesign` next.

ONE-MORE-THING: ask developer if something not sure
