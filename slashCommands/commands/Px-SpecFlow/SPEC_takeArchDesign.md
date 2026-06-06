# SPEC_takeArchDesign

## Purpose

Create or update high-level architecture design for the architecture-changing active user story, defining architecture views, architecture-oriented SPEC surface coverage, component decomposition, module boundaries, dependencies, data flows, and key technical trade-offs before detailed class or API design begins.

Model guidance: use a SOTA reasoning-capable LLM for this command (for example, GPT-5.5-xHigh) because architecture design requires deep thinking across competing constraints and complex trade-off analysis.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the architecture-changing active user story, requirements (e.g. `README_UserStory.md` / `doingUS/`), and project context, reason about the structural decomposition and adapter boundaries, draft or update the project-root `README_ArchDesign.md`, and verify that component structures are traceable to requirements and fit the project guidelines before finalizing. Include Mermaid-renderable C4-style architecture views (system context, container, component, runtime execution, and deployment) or explicitly mark a view as not applicable. Also declare how Px-SpecFlow architecture-oriented surfaces (`README_UsageDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_VerifyDesign.md`, and relevant state design sources) are covered, delegated, deferred, or not applicable. When the architecture document already contains earlier architectural work, update its traceability to distinguish baseline architecture stories from the current architecture-changing update story instead of replacing everything with the newest opened story. For embedded software or digital video/audio domain work, add hardware boundaries, RTOS task structures, media pipelines, and synchronization boundaries to the architecture design.

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
	- `design-architecture-viewpoints` for stakeholder-to-viewpoint mapping, view coverage depth, and inter-view consistency checks.
	- `apply-architectural-tactics` for ASR extraction, measurable quality-attribute scenarios, tactic selection, and tradeoff clarity.
	- `document-architectural-decisions` for ADR-quality alternatives/argument/implication structure when architecture-significant choices are made.
- Builtin fallback rule: if one or more relevant skills are unavailable, apply the learned builtin-skill checklist in this command covering: stakeholders and concerns, C4-style views, at least three measurable quality scenarios, explicit tradeoffs/risks, and decision traceability.
- Completion rule: command completion must not depend on skill availability. Skills are preferred when present; builtin-skill behavior is mandatory fallback.

### Builtin Skill Checklist (when skills are unavailable)

- Viewpoint builtin: identify at least three stakeholder groups, map each to concerns, and cover them in Context/Container/Component/Deployment views.
- Consistency builtin: explicitly check Context vs Functional boundaries, Functional vs Development ownership, and Concurrency vs Deployment placement.
- Tactics builtin: define at least three measurable quality scenarios using `Source, Stimulus, Environment, Response, Response Measure`.
- Tradeoff builtin: record at least two sensitivity points and two tradeoff points for major design decisions.
- Decision builtin: when architecture-significant choices exist, include alternatives, selected option, argument, implications, and trace links.

## Output Contract

- Project-root `README_ArchDesign.md` containing high-level architecture goals, module boundaries, dependencies, data flow, key decisions, and risks.
- Architecture views, at minimum Mermaid-renderable C4-style system context, container, component, runtime execution, and deployment views, unless a view is explicitly not applicable.
- Architecture-oriented SPEC surface coverage, declaring whether usage, error, resource, performance, compatibility, diagnosis, verification, and state concerns are covered here, delegated, deferred, or not applicable.
- Created `README_ArchDesign.md` must be based on the `slashCommands/templates/README_ArchDesignTemplate.md` template.
- Integration alignment between components and interfaces, establishing adapter boundaries for IDEs/agents.
- Explicit technical trade-offs and rationale recorded under Key Decisions.

## Prompt Template

Ask the assistant to design the high-level system structure, Mermaid-renderable C4-style architecture views, Px-SpecFlow architecture-oriented SPEC surface coverage, module boundaries, and component dependencies before detailed design or test skeletons, updating the project-root `README_ArchDesign.md`, and keeping architecture decisions traceable to the architecture-changing user story or explicitly listed architecture-changing baseline/update stories. Do not treat unrelated opened stories that only consume the architecture as architecture trace owners. For embedded or digital video/audio work, ensure task boundaries, hardware boundaries, buffer topologies, and sample format parameters are designed where relevant.

When possible, prefer a SOTA high-reasoning model (for example, GPT-5.5-xHigh) for this step to improve decision quality on architectural alternatives and trade-offs.

## Conflict Guard

Do not start low-level detailed design, test writing, or coding from this command. Route to `SPEC_reviewArchDesign` next.

ONE-MORE-THING: ask developer if something not sure
