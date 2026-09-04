# SPEC_reviewArchDesign

## Purpose

Review high-level architecture design immediately after `SPEC_takeArchDesign` and before `SPEC_takeDetailDesign`, so architecture boundary mistakes are found before detailed class, API, or test design begins.

Model guidance: use a SOTA reasoning-capable LLM for this command (for example, GPT-5.5-xHigh) because approving or rejecting architecture requires deep thinking about system boundaries, competing constraints, and complex trade-offs.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the architecture-changing active user story, `projectContext.md`, `README_ArchDesign.md`, and the matching ZH mirror when present; reason about architecture completeness, traceability, module boundaries, runtime adapters, and design risks; then produce a PASS, REVISE, or ASK finding with actionable evidence. When the architecture document already reflects earlier architecture work, review whether the current story is correctly represented as an architecture-changing update instead of requiring every opened story to appear as an architecture trace owner.

### ReACT Execution

Repeat until the finding is stable and every finding is actionable.

1. **Thought** — Read the story, project context, `README_ArchDesign.md`, and the ZH mirror when present. Walk the Review Checklist and name the items that fail.
2. **Action** — Run the Builtin Skill Gates (or the preferred skills when available) and write one verdict — `PASS`, `REVISE`, or `ASK` — with one evidence line per failed item.
3. **Observation** — Check every finding cites a document section and states what would make it pass. A finding that only says "unclear" returns to **Thought**. A finding demanding that an unrelated consuming story appear as an architecture trace owner is invalid and must be dropped.
4. **Stop** — Exit on a stable verdict. `PASS` → `SPEC_takeDetailDesign`; `REVISE` → `SPEC_updateArchDesign`; `ASK` → stop and ask the developer.

### Worked Example

Gating the architecture for the multi-gateway story:

```text
/SPEC_reviewArchDesign
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
readme_arch_design: README_ArchDesign.md
readme_arch_design_zh: README_ArchDesign_ZH.md
```

Expected result — two passes:

- **Thought**: checklist walk finds only two measurable quality scenarios, and the EN/ZH mirrors differ by one heading.
- **Action**: Quality gate → REVISE (fewer than three scenarios). Mirror check → REVISE. Verdict `REVISE` with two evidence lines.
- **Observation**: a third draft finding said "the component view feels overloaded" — no section cited, no pass condition → not actionable → back to **Thought** → restated as "Component view: `GatewayRouter` owns both routing and retry; split or document why one component owns both".
- **Observation (pass 2)**: all three findings cite a section and a pass condition → verdict stable.
- Reported: `REVISE` → `next_command = SPEC_updateArchDesign`. Detail design is blocked until this passes.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/` that creates or changes architecture decisions, architecture boundaries, deployment/runtime strategy, or architecture-oriented SPEC surfaces.
- `projectContext_file`: current project context.
- `readme_arch_design`: project-root or module-scoped `README_ArchDesign.md`.
- `readme_arch_design_zh`: optional matching `README_ArchDesign_ZH.md` mirror.
- `reference_docs`: optional user stories, usage design, user guide, external architecture references, or framework notes relevant to the story.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Skill Integration Policy

- Skill-first rule: if relevant architecture skills exist in the workspace, use them for this review.
- Preferred skills and usage:
	- `design-architecture-viewpoints` to strengthen viewpoint completeness and inter-view consistency findings.
	- `apply-architectural-tactics` to evaluate measurable quality scenarios, tactic adequacy, and architecture tradeoff points.
	- `document-architectural-decisions` to validate ADR completeness (alternatives, argument, implications, decision state, trace links).
- Builtin fallback rule: if one or more relevant skills are unavailable, review with the learned builtin-skill gate set covering: boundary clarity, dependency direction, runtime/deployment clarity, measurable quality scenario coverage, and ADR traceability for architecture-changing decisions.
- Completion rule: the review must remain executable and decisive without skill loading. Skills are preferred when present; builtin-skill behavior is mandatory fallback.

### Builtin Skill Gates (when skills are unavailable)

- Viewpoint gate: FAIL if stakeholder concerns are not represented in architecture views.
- Consistency gate: FAIL if major cross-view contradictions are found (module ownership, runtime placement, boundary direction).
- Quality gate: REVISE if fewer than three measurable quality scenarios are documented.
- Tradeoff gate: REVISE if decisions lack explicit sensitivity/tradeoff analysis.
- Decision gate: REVISE if architecture-significant decisions lack alternatives, rationale, implications, or trace links.

## Output Contract

- Review finding: `PASS`, `REVISE`, or `ASK`.
- Evidence for each finding, grounded in the architecture-changing story, project context, architecture document, and mirror document when present.
- Checks for module boundaries, dependency direction, AgentSDK/CaTDD separation, runtime adaptation strategy, trace/audit/control coverage, Mermaid-renderable architecture views, and Px-SpecFlow architecture-oriented surface coverage.
- Checks that architecture remains module-context centered and explicitly documents systems consuming the module and their integration boundaries.
- If `PASS`: next recommended command is `SPEC_takeDetailDesign`.
- If `REVISE`: next recommended command is `SPEC_updateArchDesign` to revise the architecture design before detailed design begins.
- If `ASK`: stop and ask the developer for the missing product, architecture, or review decision.

## Review Checklist

- Architecture decisions trace to the architecture-changing story or explicitly listed architecture-changing baseline/update stories, and to `projectContext.md`.
- C4-style architecture views are Mermaid-renderable or explicitly marked not applicable.
- Module boundaries are clear enough to drive detail design.
- Module context and consuming-system context are explicit enough to drive integration-safe detail design.
- CaTDD method semantics remain delegated to `methodPrompts/` and `slashCommands/`.
- Generic AgentSDK concerns remain independent of CaTDD category/status meaning.
- Runtime targets, adapters, deployment boundaries, and command execution boundaries are explicit.
- Auth, audit, auto, hooks, control, diagnostics, trace, and failure paths are covered or intentionally deferred.
- EN/ZH architecture mirrors have matching heading structure when both are present.

## Loop Guard

On `REVISE`, route to `SPEC_updateArchDesign` and record structured findings. The `SPEC_updateArchDesign -> SPEC_reviewArchDesign` rework cycle is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions: after repeated no-progress or exhausted attempts, route to `SPEC_abortUserStory` or `ASK`, never a third silent retry. Do not claim architecture review progress without changed evidence between passes.

## Conflict Guard

Do not approve an architecture that cannot explain its system boundary, module ownership, dependency direction, runtime/deployment boundaries, and traceability back to requirements.
Do not approve an architecture that omits consuming-system context for the designed module.

ONE-MORE-THING: ask developer if something not sure
