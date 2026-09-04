# SPEC_updateArchDesign

## Purpose

Revise high-level architecture design after architecture review feedback, story-level feedback, or quality failure.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect architecture-review findings and existing architecture artifacts, reason about the minimum architecture change needed to address the finding without masking it, apply the revision, and verify that traceability and architecture boundaries remain explicit. If the feedback introduces truly new product intent, route to a new work item instead of silently expanding scope.

### ReACT Execution

Repeat within `max_rework_attempts`; each pass must show changed evidence.

1. **Thought** — Read each item in `review_feedback` and decide whether it is an architecture defect (fix here) or new product intent (route out, do not absorb).
2. **Action** — Apply the smallest architecture change that resolves the defect. Update affected views, module/consuming-system context, and tradeoff notes.
3. **Observation** — Check the feedback checklist: every finding must be marked addressed, deferred, or still open. A finding silently dropped, or a fix that widens scope beyond the story, returns to **Thought**.
4. **Stop** — Exit when the checklist is complete. Report `next_command = SPEC_reviewArchDesign`; this gate is never bypassed.

### Worked Example

Architecture review returned two findings:

```text
/SPEC_updateArchDesign
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
arch_design: README_ArchDesign.md
review_feedback: |
  F1: gateway adapters depend directly on the auth module, violating the port boundary
  F2: no view shows what happens when two gateways are enabled at once
```

Expected result:

- **Thought**: F1 is an architecture defect → fix here. F2 is also a defect (missing runtime view), not new intent → fix here. Neither introduces new product scope.
- **Action**: F1 — auth access moved behind the existing port; F2 — runtime execution view added for the dual-gateway case.
- **Observation**: a first attempt at F1 also introduced a new caching layer, which is beyond the finding → scope creep → back to **Thought** → caching dropped and recorded as a follow-up candidate.
- **Stop**: checklist shows F1 addressed, F2 addressed, caching deferred. Reported `next_command = SPEC_reviewArchDesign`.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `arch_design`: project-root `README_ArchDesign.md` (and optional mirror) to update.
- `projectContext_file`: current project context.
- `review_feedback`: findings from architecture review or upstream story-quality feedback.
- `reference_docs`: optional related architecture notes, ADRs, usage/error/resource/state/perf/compat/diagnosis docs affected by the architecture revision.
- `max_rework_attempts`: optional maximum number of architecture rework attempts in the `SPEC_updateArchDesign -> SPEC_reviewArchDesign` cycle. Default: `3`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated architecture design in `README_ArchDesign.md` (and optional mirror when present).
- Updated architecture decisions, boundaries, dependencies, and tradeoff notes tied to the review feedback.
- Updated module-context and consuming-system context sections when the revision affects module responsibilities, interfaces, or integration boundaries.
- Architecture-feedback checklist showing what was addressed, deferred, or still open.
- Remaining risks and next recommended command.
- Next recommended command after any update is `SPEC_reviewArchDesign` so revised architecture is always re-gated before detailed design or downstream steps.

## Loop Guard

This update runs inside the `SPEC_updateArchDesign -> SPEC_reviewArchDesign` rework cycle, bounded by `max_rework_attempts` (default `3`). Stop on resolved findings, exhausted attempts, or repeated no-progress evidence; on stop, preserve the latest evidence and route to `SPEC_abortUserStory` or `ASK`, never a third silent retry.

## Conflict Guard

Do not hide unresolved architecture quality failures. Keep them visible until `SPEC_reviewArchDesign` passes.
Never bypass `SPEC_reviewArchDesign` after this update step.

ONE-MORE-THING: ask developer if something not sure
