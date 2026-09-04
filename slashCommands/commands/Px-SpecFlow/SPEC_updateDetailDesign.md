# SPEC_updateDetailDesign

## Purpose

Revise detailed design and acceptance criteria after story review, implementation feedback, or quality failure.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect review feedback and the existing design artifacts, reason about the minimum change needed to address the finding without hiding it, apply the revision, and verify that the updated design resolves the finding and preserves traceability. If the feedback reveals new requirements, the reasoning loop routes to a new work item instead of widening scope.

### ReACT Execution

Repeat within `max_rework_attempts`; each pass must show changed evidence.

1. **Thought** — For each item in `review_feedback`, decide whether it is a design defect (fix here) or a new requirement (route out, do not absorb).
2. **Action** — Apply the smallest design change that resolves the defect, updating only the README SPEC docs the finding actually touches.
3. **Observation** — Check the review-feedback checklist: every finding marked addressed, deferred, or still open, and every changed AC still convertible to a CaTDD skeleton. A masked failure or a widened scope returns to **Thought**.
4. **Stop** — Exit when the checklist is complete. Report `next_command = SPEC_reviewDetailDesign`; this gate is never bypassed.

### Worked Example

Detail-design review returned two findings:

```text
/SPEC_updateDetailDesign
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
detail_design: README_DetailDesign.md
review_feedback: |
  F1: the degraded state has no documented exit transition
  F2: merchants also want per-merchant retry caps
```

Expected result:

- **Thought**: F1 is a design defect → fix here. F2 is a **new requirement**, not a defect → route out; absorbing it would widen the story silently.
- **Action**: `README_StateDesign.md` gains `degraded → ready` on a successful health probe, plus the invalid-transition rule. Nothing is changed for F2.
- **Observation**: checklist shows F1 addressed; F2 recorded as still open with `SPEC_importFeature` as its route. Neither finding was dropped.
- **Stop**: reported `next_command = SPEC_reviewDetailDesign`, with F2 handed to `SPEC_importFeature` as separate work.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `detail_design`: project-root README detail design file or active story design section to update.
- `readme_spec_files`: optional project-root `README*` SPEC files to create or update using matching `slashCommands/templates/README_*Template.md` files when first created, including `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, or `README_DiagnosisDesign.md` when feedback changes error, resource, state, performance, compatibility, or diagnosis design.
- `review_feedback`: findings from story, code, test, or CI review.
- `max_rework_attempts`: optional maximum number of detail-design rework attempts in the `SPEC_updateDetailDesign -> SPEC_reviewDetailDesign` cycle. Default: `3`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Updated design and acceptance criteria in team-shared `.catdd/spec/doingUS/` work state or team-shared project-root README SPEC docs.
- Updated `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_StateDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, or `README_VerifyDesign.md` when the feedback changes module, error, resource, state, performance, compatibility, diagnosis, or verification design.
- Review-feedback checklist showing what was addressed.
- Remaining risks and next recommended command.
- Next recommended command after any update is `SPEC_reviewDetailDesign` so updated design is always re-gated before downstream steps.

## Loop Guard

This update runs inside the `SPEC_updateDetailDesign -> SPEC_reviewDetailDesign` rework cycle, bounded by `max_rework_attempts` (default `3`). Stop on resolved findings, exhausted attempts, or repeated no-progress evidence; on stop, preserve the latest evidence and route to `SPEC_abortUserStory` or `ASK`, never a third silent retry.

## Conflict Guard

Do not hide unresolved quality failures. Keep them visible until a later review passes.
Never bypass `SPEC_reviewDetailDesign` after this update step.

ONE-MORE-THING: ask developer if something not sure
