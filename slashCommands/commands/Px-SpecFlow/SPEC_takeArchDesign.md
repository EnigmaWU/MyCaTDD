# SPEC_takeArchDesign

## Purpose

Create or update high-level architecture design for the active user story, defining architecture views, architecture-oriented SPEC surface coverage, component decomposition, module boundaries, dependencies, data flows, and key technical trade-offs before detailed class or API design begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the active user story, requirements (e.g. `README_UserStory.md` / `doingUS/`), and project context, reason about the structural decomposition and adapter boundaries, draft or update the project-root `README_ArchDesign.md`, and verify that component structures are traceable to requirements and fit the project guidelines before finalizing. Include C4-style architecture views (system context, container, component, runtime execution, and deployment) or explicitly mark a view as not applicable. Also declare how Px-SpecFlow architecture-oriented surfaces (`README_UsageDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_VerifyDesign.md`, and relevant state design sources) are covered, delegated, deferred, or not applicable. For embedded software or digital video/audio domain work, add hardware boundaries, RTOS task structures, media pipelines, and synchronization boundaries to the architecture design.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `projectContext_file`: current project context.
- `readme_arch_design`: project-root `README_ArchDesign.md` to create or update.
- `readme_arch_template`: matching template under `slashCommands/templates/README_ArchDesignTemplate.md`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Project-root `README_ArchDesign.md` containing high-level architecture goals, module boundaries, dependencies, data flow, key decisions, and risks.
- Architecture views, at minimum C4-style system context, container, component, runtime execution, and deployment views, unless a view is explicitly not applicable.
- Architecture-oriented SPEC surface coverage, declaring whether usage, error, resource, performance, compatibility, diagnosis, verification, and state concerns are covered here, delegated, deferred, or not applicable.
- Created `README_ArchDesign.md` must be based on the `slashCommands/templates/README_ArchDesignTemplate.md` template.
- Integration alignment between components and interfaces, establishing adapter boundaries for IDEs/agents.
- Explicit technical trade-offs and rationale recorded under Key Decisions.

## Prompt Template

Ask the assistant to design the high-level system structure, C4-style architecture views, Px-SpecFlow architecture-oriented SPEC surface coverage, module boundaries, and component dependencies before detailed design or test skeletons, updating the project-root `README_ArchDesign.md`, and keeping architecture decisions traceable to the active user story. For embedded or digital video/audio work, ensure task boundaries, hardware boundaries, buffer topologies, and sample format parameters are designed where relevant.

## Conflict Guard

Do not start low-level detailed design, test writing, or coding from this command. Route to `SPEC_takeDetailDesign` next.

ONE-MORE-THING: ask developer if something not sure
