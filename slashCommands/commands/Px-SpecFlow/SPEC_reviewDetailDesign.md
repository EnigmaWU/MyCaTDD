# SPEC_reviewDetailDesign

## Purpose

Review detailed design immediately after `SPEC_takeDetailDesign` and before `SPEC_reviewUserStory` or test skeleton design, so local API, state, and testability gaps are found before CaTDD test design begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the active user story, `README_ArchDesign.md`, `README_DetailDesign.md`, matching ZH mirrors when present, and any related README SPEC docs; reason about detailed design completeness, API signatures, state models, resource/error/compatibility impacts, and acceptance-criteria testability; then produce a PASS, REVISE, or ASK finding with actionable evidence.

### ReACT Execution

Repeat until the finding is stable and every finding is actionable.

1. **Thought** — Read the story, architecture design, detail design, and related README SPEC docs. Walk the Review Checklist and name the items that fail.
2. **Action** — Run the Builtin Skill Gates (or the preferred skills when available) and write one verdict — `PASS`, `REVISE`, or `ASK` — with one evidence line per failed item.
3. **Observation** — Check that each finding cites a document section and a pass condition, and that the Testability gate was applied to every AC, not a sample. A vague finding or a skipped AC returns to **Thought**.
4. **Stop** — Exit on a stable verdict. `PASS` → `SPEC_reviewUserStory`; `REVISE` → `SPEC_updateDetailDesign`; `ASK` → stop and ask the developer.

### Worked Example

Gating the detail design before test skeletons are written:

```text
/SPEC_reviewDetailDesign
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
readme_detail_design: README_DetailDesign.md
readme_spec_files: README_StateDesign.md, README_ErrorDesign.md
```

Expected result — two passes:

- **Thought**: AC-01..AC-04 walked one by one. AC-04 says the adapter should "recover on its own" with no observable signal → Testability gate FAIL. The `degraded` state has no exit transition → API/state gate REVISE.
- **Action**: verdict `REVISE`, two evidence lines citing `README_DetailDesign.md` AC-04 and `README_StateDesign.md` the state table.
- **Observation**: the first pass only spot-checked AC-01 and AC-04 → gate not applied to every AC → back to **Thought**.
- **Observation (pass 2)**: all four ACs checked; AC-02 and AC-03 convert cleanly to Typical/Fault skeletons → verdict stable.
- Reported: `REVISE` → `next_command = SPEC_updateDetailDesign`. `SPEC_designUnitTests` stays blocked.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `readme_arch_design`: project-root or module-scoped `README_ArchDesign.md`.
- `readme_arch_design_zh`: optional matching `README_ArchDesign_ZH.md` mirror.
- `readme_detail_design`: project-root or module-scoped `README_DetailDesign.md`.
- `readme_detail_design_zh`: optional matching `README_DetailDesign_ZH.md` mirror.
- `readme_spec_files`: optional related README SPEC docs such as `README_DetailVerifyDesign.md`, `README_ArchVerifyDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_SecurityDesign.md`, or `README_VerifyDesign.md`.
- `projectContext_file`: current project context.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Skill Integration Policy

- Skill-first rule: if relevant architecture skills exist in the workspace, use them for this detail-design review.
- Preferred skills and usage:
	- `design-architecture-viewpoints` to verify detail design does not violate architecture viewpoint boundaries and deployment/concurrency assumptions.
	- `apply-architectural-tactics` to verify quality-attribute tactics and constitutional invariants ($K$) remain valid at detail level and are not lost in implementation-facing design.
	- `document-architectural-decisions` to trigger ADR advice when detail choices cross into architecture-significant decisions.
	- `design-tool-use-sandboxing` to verify that mutative agent tools are strictly partitioned with schema validation and approval gates.
- Builtin fallback rule: if one or more relevant skills are unavailable, review with the learned builtin-skill gate set covering: API/schema explicitness, state/resource/error/compatibility/security constraints, and AC-to-US/AC/TC conversion readiness.
- Completion rule: this review command must remain operational without skill loading. Skills are preferred when present; builtin-skill behavior is mandatory fallback.

### Builtin Skill Gates (when skills are unavailable)

- Boundary gate: FAIL if detailed design violates approved architecture boundaries or ownership direction.
- API/state gate: REVISE if APIs, schemas, or state transitions are ambiguous or untestable.
- Constraint gate: REVISE if resource/error/compatibility/performance/security constraints are missing for impacted components.
- Security & sandbox gate: REVISE if sensitive credentials may leak in APIs/logs or if mutative agent tools lack approval/sandbox boundaries.
- Quality continuity gate: REVISE if architecture quality scenarios are not reflected in detail design decisions.
- Testability gate: FAIL if acceptance criteria cannot be translated into CaTDD US/AC/TC skeleton design.

## Output Contract

- `review_verdict`: one of `PASS`, `REVISE`, `BLOCKED`, or `ASK`, with optional `severity: blocking | advisory` and a required `rework_route` whenever the verdict is not `PASS`.
- Evidence for each finding, grounded in the active story, architecture design, detail design, project context, and mirror documents when present.
- Checks for API signatures, class/module responsibilities, local state model, error/resource/performance/compatibility/diagnosis impacts, acceptance-criteria testability, test-point discovery evidence (`discovery_ledger` + Discovery Gate), `TestLevel` routing and `SysTesting`/`UserTesting` promotion, and readiness for CaTDD US/AC/TC skeleton design.
- If `PASS`: next recommended command is `SPEC_reviewUserStory` for final story/design readiness.
- If `REVISE`: next recommended command is `SPEC_updateDetailDesign`.
- If `ASK`: stop and ask the developer for the missing product, design, or review decision.
- If `BLOCKED`: the story, architecture, or detail-design artifact needed for the review is unavailable; report the missing artifact and `rework_route`.

## Review Gate Contract

- Reviews: the detail design documents, including API and state ownership, acceptance-criteria testability, and consistency with the approved architecture.
- Does not: author or revise detail design (`SPEC_updateDetailDesign`), judge requirement content or measurability (that lens belongs to `SPEC_reviewUserStory`), or review tests, product code, or architecture.
- `review_verdict`: exactly one of `PASS`, `REVISE`, `BLOCKED`, or `ASK` per pass. `ASK` brings the human developer into the loop and is the same outcome `ONE-MORE-THING` produces.
- `severity`: optional `blocking | advisory` (default `blocking`); `advisory` marks findings that do not stop the gate.
- `rework_route`: required whenever the verdict is not `PASS`; it names the owning command for each finding.
- Read-only by default: report and route. Do not repair the reviewed artifact unless the developer explicitly approves a repair.
- Source-first: read the upstream source artifact before judging the artifact under review.
- Every finding cites a file, an ID, or a verification signal; an uncitable finding is dropped or chased with one more read.
- One verdict per pass, stable across passes; a repeat pass with identical findings and no changed evidence is the last pass.
- Rework is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions.
- Report `next_command = <COMMAND>` whenever the verdict is not `PASS`. The mapping from older verdict wording lives in the flow's Review Gate Contract table.

## Review Checklist

- Detail design decisions trace to the active story and architecture design.
- Public APIs, data schemas, and ownership rules are explicit enough to test.
- State transitions, resource constraints, error behavior, and compatibility constraints are covered or intentionally deferred.
- Acceptance criteria can be converted into CaTDD US/AC/TC skeletons.
- `README_DetailVerifyDesign.md` exists for the reviewed scope and carries a Behavior Inventory, `discovery_ledger` with dispositions, and a Discovery Gate report; a missing or stale one is a blocking finding.
- Every ledger row carries a canonical `TestLevel` (`UnitTesting`/`SysTesting`/`UserTesting`), `ModuleTesting` appears only as a module-scope qualifier, and every `SysTesting`/`UserTesting` row names its promotion into `README_ArchVerifyDesign.md` under the same TP ID.
- Verification constraints state WHAT must be proven and WHY before test mechanics, and design content is not duplicated from `README_ArchVerifyDesign.md`.
- The detailed design does not contradict approved architecture boundaries.
- EN/ZH detail-design mirrors have matching heading structure when both are present.

## Loop Guard

On `REVISE`, route to `SPEC_updateDetailDesign` and record structured findings. The `SPEC_updateDetailDesign -> SPEC_reviewDetailDesign` rework cycle is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions: after repeated no-progress or exhausted attempts, route to `SPEC_abortUserStory` or `ASK`, never a third silent retry. Do not claim detail-design review progress without changed evidence between passes.

## Conflict Guard

Do not approve a detailed design that lacks testable acceptance criteria, clear API/state ownership, or consistency with the approved architecture.

ONE-MORE-THING: ask developer if something not sure
