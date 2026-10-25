# SPEC_updateMadePlan

## Purpose

Synchronize and progressively refine an existing `.catdd/spec/doingUS/*-UserStory-Tasks.md` task plan after lifecycle phase transitions, review verdicts, rework loops, story resumption, or `plan_drift` detection, keeping `[ ]`/`[x]` task status truthful and expanding coarse phases into detailed design or US/AC/TC execution slices.

Use `SPEC_makePlan` to create the initial task plan right after `SPEC_openUserStory` or `SPEC_clearStoryIntent`. Use `SPEC_updateMadePlan` whenever an already-made task plan is out of date with actual gate/commit evidence or needs finer-grained tasks for the next phase.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command inspects the existing `*-UserStory-Tasks.md` artifact alongside the active story, project context, review verdicts, verification designs, and git commit evidence; identifies stale `[ ]`/`[x]` checkboxes, orientation transitions, or coarse tasks that now have enough upstream evidence to be decomposed into concrete slices; updates the task artifact; and verifies that every checked item has gate evidence and every newly expanded slice preserves the commit plan and orientation boundary.

### ReACT Execution

Repeat until the paired `*-UserStory-Tasks.md` artifact is truthful, sufficiently detailed for the current lifecycle phase, and free of `plan_drift`.

1. **Thought** — Compare the existing `*-UserStory-Tasks.md` against the active story, `README_UserStories.md`, reviewed `README*` SPEC docs, test skeletons, and actual git commits. Identify: (a) completed steps still marked `[ ]` or checked `[x]` steps lacking gate evidence (`plan_drift`), (b) work-orientation transitions (for example `requirement-oriented` → `design-oriented`, or `design-oriented` → `implementation-oriented`), (c) changes in the 10-dimension `## EPIC Specification Sufficiency` ledger (`satisfied / partial / gap / question / N/A`), (d) coarse placeholder tasks that must now expand into concrete architecture/detail design tasks or US/AC/TC test-and-code slices with parallel markers, and (e) step-commit boundaries that need updating.
2. **Action** — Update `.catdd/spec/doingUS/*-UserStory-Tasks.md` (following [SpecDoingUserStoryTasksTemplate.md](../../templates/SpecDoingUserStoryTasksTemplate.md)): refresh the `## EPIC Specification Sufficiency` table dispositions and evidence, append a new chronological row to the `## Trajectory` table (`# | Date | Command / Gate | Verdict / Evidence / Commit | Plan Delta -> Next Command`), and synchronize the `Current Readiness` table, `Work Orientation`, `[x]`/`[ ]` checkboxes in `## Task Checklist` with gate/commit citations, expanded phase or US/AC/TC slice tasks, `Candidate Next Steps`, `Rejected Next Steps`, `Selected Next Command`, and the commit plan (`commit_step = yes|no|optional`, `single_story_commit`, and recorded `commit_ref`s).
3. **Observation** — Check the updated plan against four invariants: (a) every `[x]` task is backed by an append-only `## Trajectory` row citing real gate or commit evidence (prior `## Trajectory` rows are never deleted or overwritten), (b) when entering `implementation-oriented` Part 2.b, required EPIC dimensions in `## EPIC Specification Sufficiency` are `satisfied` (or explicitly `N/A` / risk-accepted) and tasks are broken down into ordered US/AC/TC slices (P0 Functional first, then gated P1/P2) and explicit `SPEC_commitStepWorks` boundaries rather than a single coarse implementation checkbox, (c) any `REVISE` verdict from `SPEC_reviewUserStory`, `SPEC_reviewArchDesign`, `SPEC_reviewDetailDesign`, `SPEC_reviewImplTests`, or `SPEC_reviewProductCodes` records its finding IDs and bounded attempt count (`Attempt k of 3`) in `## Trajectory` and `## Task Checklist`, and (d) the selected next command's prerequisites are all `[x]`. If any `[x]` lacks evidence, any slice omits a required review gate, or `execution_mode` violates the orientation boundary, return to **Thought** or **Action**.
4. **Stop** — Print the updated TASKs checklist and latest `## Trajectory` row, the updated work orientation and `execution_mode` status, and `next_command = <selected SPEC command>`.

### Worked Example

A story opened as `requirement-oriented` and initially planned by `SPEC_makePlan` has now completed `SPEC_updateUserStory`, `SPEC_reviewUserStory` (`PASS`), `SPEC_takeDetailDesign`, and `SPEC_reviewDetailDesign` (`PASS`), but `*-UserStory-Tasks.md` still shows the story as `requirement-oriented` with `[ ] SPEC_updateUserStory` and a single coarse `[ ] Implement tests and code` placeholder:

```text
/SPEC_updateMadePlan
doing_user_story: .catdd/spec/doingUS/20260904-payment-retry-UserStory.md
tasks_file: .catdd/spec/doingUS/20260904-payment-retry-UserStory-Tasks.md
projectContext_file: .catdd/spec/projectContext.md
trigger_reason: phase_transition_after_detail_design_pass
detail_design: README_DetailDesign.md
verify_design: README_DetailVerifyDesign.md
execution_mode: autonomousMode
```

Expected result — two ReACT passes:

- **Thought**: `SPEC_updateUserStory`, `SPEC_reviewUserStory`, `SPEC_takeDetailDesign`, and `SPEC_reviewDetailDesign` all passed in the story log, so leaving them `[ ]` in `*-UserStory-Tasks.md` is status drift. Because detail design and `README_DetailVerifyDesign.md` are now `PASS`, work orientation shifts from `design-oriented` to `implementation-oriented`, and the coarse implementation placeholder must expand into P0 `Typical/Edge/Misuse/Fault` US/AC/TC slices plus `SPEC_commitStepWorks` boundaries.
- **Action**: mark the requirement and detail-design tasks `[x]` with their review verdicts; update `Work Orientation` to `implementation-oriented`; expand Part 2.b tasks into `[ ] SPEC_designTests` (AC-01..AC-04 P0 skeletons), `[ ] SPEC_implTests`, `[ ] SPEC_reviewImplTests`, `[ ] SPEC_implProductCodes`, `[ ] SPEC_reviewProductCodes`, and `[ ] SPEC_reviewImplTests` (post-code); set `commit_step = yes` on `SPEC_designTests`, `SPEC_implTests`, and `SPEC_implProductCodes` for `autonomousMode`.
- **Observation (pass 1)**: draft task list marked `[x] SPEC_takeArchDesign`, but the story skipped architecture design rather than running it → claiming a skipped gate as `[x]` without a `Skipped (no arch boundary change)` note would cause `plan_drift` at close → back to **Action** to record `SPEC_takeArchDesign` as `[x] Skipped — no architecture boundary change`.
- **Observation (pass 2)**: every `[x]` item has truthful gate or skip evidence, US/AC/TC slices and step-commit boundaries are explicit, and `implementation-oriented` orientation now legally unlocks `autonomousMode` → checks pass.
- **Stop**: printed the updated TASKs checklist and reported `next_command = SPEC_designTests` (`execution_mode = autonomousMode` active).

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `tasks_file`: existing `.catdd/spec/doingUS/*-UserStory-Tasks.md` file created by `SPEC_makePlan` to synchronize and refine. If this file does not exist yet, stop and route to `SPEC_makePlan`.
- `projectContext_file`: current project context.
- `trigger_reason`: reason for updating the plan:
  - `phase_transition`: moving across `intent-clearing`, `requirement-oriented`, `design-oriented`, or `implementation-oriented` phases (for example after `SPEC_reviewUserStory`, `SPEC_reviewArchDesign`, or `SPEC_reviewDetailDesign` passes).
  - `detail_breakdown`: expanding coarse tasks into concrete design surfaces or US/AC/TC test-and-implementation slices after design or `SPEC_designTests`.
  - `rework_routing`: recording bounded rework tasks after a review gate returns `REVISE` (`SPEC_updateUserStory`, `SPEC_updateArchDesign`, `SPEC_updateDetailDesign`, `SPEC_implTests`, or `SPEC_implProductCodes`).
  - `status_sync` / `plan_drift`: reconciling stale `[ ]`/`[x]` checkboxes, gate verdicts, or commit records before `SPEC_closeUserStory`, after `SPEC_resumeUserStory`, or after `SPEC_whatsWrong` returns from VibeCoding.
- `project_user_stories_doc`: optional project-root `README_UserStories.md` ledger for verifying TODO/DOING/DONE and AC trace alignment.
- `readme_spec_files`: optional project-root `README*` SPEC docs (`README_ArchDesign.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, `README_ArchVerifyDesign.md`, etc.) that provide new detail for task breakdown.
- `review_evidence`: optional latest `review_verdict` (`PASS`, `REVISE`, `BLOCKED`, `ASK`) and findings from the preceding review gate.
- `commit_evidence`: optional `commit_ref`s from `SPEC_commitPreStoryWorks`, `SPEC_commitStepWorks`, or `SPEC_commitStoryWorks` to reconcile against the recorded commit plan.
- `execution_mode`: optional `manualMode | autonomousMode` (default: `manualMode`). Re-evaluate whether `autonomousMode` must remain held in `manualMode` or can now be unlocked because the story has transitioned to `implementation-oriented` with locked requirements and design.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [SPEC_makePlan](SPEC_makePlan.md)
- [SpecDoingUserStoryTasksTemplate.md](../../templates/SpecDoingUserStoryTasksTemplate.md)
- [methodPrompts](../../../methodPrompts/README.md)

## Output Contract

- An updated, team-shared `.catdd/spec/doingUS/*-UserStory-Tasks.md` artifact conforming to [SpecDoingUserStoryTasksTemplate.md](../../templates/SpecDoingUserStoryTasksTemplate.md).
- A refreshed 10-dimension `## EPIC Specification Sufficiency` table (`E1..E3`, `P1..P2`, `I1..I3`, `C1..C2`) and `### Cross-Artifact Semantic-Delta Matrix` (`KEPT`, `DETAILED`, `REASSIGNED`, `EXCLUDED`, `VIOLATED`, `UNKNOWN` across `SPEC_reviewArchDesign`, `SPEC_reviewDetailDesign`, `SPEC_designTests` + `TEST_review*TestsSkeleton`, and `SPEC_reviewImplTests`) recording updated dispositions (`satisfied / partial / gap / question / N/A`), affected IDs/evidence, and owning next commands as upstream gates pass or revise.
- A newly appended row in the `## Trajectory` table (`# | Date | Command / Gate | Verdict / Evidence / Commit | Plan Delta -> Next Command`) recording the review verdict (`SPEC_reviewUserStory`, `SPEC_reviewArchDesign`, `SPEC_reviewDetailDesign`, `SPEC_reviewImplTests`, or `SPEC_reviewProductCodes`), rework attempt (`Attempt k of 3`), phase transition, or commit checkpoint without deleting or overwriting prior rows.
- Synchronized `[x]` and `[ ]` Markdown checkbox tasks in `## Task Checklist` where every `[x]` item is backed by a `## Trajectory` row citing the gate verdict, commit ref, or explicit skip rationale.
- Refreshed `Current Readiness` table, `Work Orientation`, `Candidate Next Steps`, `Rejected Next Steps`, and `Selected Next Command`.
- Progressive detail expansion matching the story's current stage:
  - When entering `design-oriented` work after `SPEC_reviewUserStory` (`PASS`): explicit tasks for the exact `README*` SPEC surfaces to create/update and their review gates (`SPEC_reviewArchDesign`, `SPEC_reviewDetailDesign`).
  - When transitioning from architecture to detail design after `SPEC_reviewArchDesign` (`PASS`): check off architecture tasks and expand the concrete `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, and domain SPEC tasks.
  - When entering `implementation-oriented` work (Part 2.b) after `SPEC_reviewDetailDesign` (`PASS`) or during `SPEC_designTests`: explicit tasks broken down by US/AC/TC execution slices, P0-first category order (`Typical`, `Edge`, `Misuse`, `Fault`, plus gated P1/P2), parallelizable slice markers (`[P]`), and validation checkpoints.
  - After `SPEC_reviewImplTests` (pre-code or post-code) and `SPEC_reviewProductCodes`: check off verified RED/GREEN TC slices or add bounded rework tasks (`IMPL-REV-*`, `PROD-REV-*`) with attempt counts (`Attempt k of 3`).
- Reconciled commit plan:
  - Updated `commit_step = yes|no|optional` boundaries for newly expanded implementation/test slices.
  - Recorded `commit_ref` evidence alongside any step or pre-story commit boundaries already taken, preventing `plan_drift` at `SPEC_closeUserStory`.
- After updating the artifact, print the current TASKs checklist and latest `## Trajectory` entry in the command response so the developer can see `[ ]` and `[x]` status immediately.
- Explicit `execution_mode` and orientation-boundary status, plus open questions or blockers if any prerequisite is unmet.

## Plan Update Decision Rules

### 1. Append-Only `Trajectory` & Status Synchronization (Preventing `plan_drift`)

- Maintain `## Trajectory` as an append-only chronological table (`# | Date | Command / Gate | Verdict / Evidence / Commit | Plan Delta -> Next Command`). Never delete or rewrite historical rows when a later gate fails or a design surface is revised.
- Never mark a task `[x]` in `## Task Checklist` without a matching `## Trajectory` row citing the artifact, `review_verdict = PASS`, or `commit_ref` that satisfied it.
- If a prior step was legitimately skipped (for example architecture design on a local bug fix), record `[x] <Command> — Skipped (<reason>)` and log the skip decision in `## Trajectory` rather than leaving it `[ ]` or claiming a gate ran when it did not.
- Reconcile the recorded commit plan with actual git history: if `SPEC_commitStepWorks` was optional in `manualMode` and the developer chose to take or skip it, update the step boundary record and append a `## Trajectory` entry so `SPEC_closeUserStory` sees a truthful match between the commit plan and commits taken.

### 2. Progressive Detail Refinement Across All 5 Review Gates

- **After `SPEC_reviewUserStory`**: On `PASS` (or transfer to design), append the verdict to `## Trajectory`, update `Work Orientation` to `design-oriented`, check off the requirement tasks `[x]`, and expand the design tasks to name the target `README*` SPEC docs (`README_ArchDesign.md`, `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, etc.) and their review gates.
- **After `SPEC_reviewArchDesign`**: On `PASS`, append the verdict to `## Trajectory`, check off `[x] SPEC_reviewArchDesign`, and refine the detail-design tasks (`SPEC_takeDetailDesign` / `SPEC_updateDetailDesign`) for the approved module and runtime boundaries.
- **After `SPEC_reviewDetailDesign`**: On `PASS` when `implementation follows`, append the verdict to `## Trajectory`, update `Work Orientation` to `implementation-oriented`, check off `[x] SPEC_reviewDetailDesign`, and expand Part 2.b into concrete US/AC/TC slices derived from `README_DetailDesign.md` and `README_DetailVerifyDesign.md` (`discovery_ledger`), preserving P0-first order, `[P]` parallel markers, and required `SPEC_reviewImplTests` / `SPEC_reviewProductCodes` gates.
- **After `SPEC_designTests`**: When `SPEC_designTests` + `TEST_review*Skeleton` completes or refines US/AC/TC execution slices, append to `## Trajectory` and update `## Task Checklist` with the exact TC IDs and step-commit checkpoints before `SPEC_implTests`.
- **After `SPEC_reviewImplTests` (Pre-Code and Post-Code) & `SPEC_reviewProductCodes`**:
  - On pre-code `SPEC_reviewImplTests = PASS`: append the valid `🔴 RED` verification evidence to `## Trajectory`, mark the pre-code test implementation/review slice `[x]`, and route to `SPEC_implProductCodes` (or `SPEC_commitStepWorks` when `commit_step = yes`).
  - On `SPEC_reviewProductCodes = PASS`: append the `🟢 GREEN` product review verdict to `## Trajectory`, mark `SPEC_implProductCodes` and `SPEC_reviewProductCodes` `[x]`, and route to post-code `SPEC_reviewImplTests`.
  - On post-code `SPEC_reviewImplTests = PASS`: append the final test-alignment verdict to `## Trajectory`, mark the post-code test review `[x]`, and route to `SPEC_commitStoryWorks` (`pre_close`) or the next TC slice.

### 3. Rework, Resume, and Excursion Reconciliation

- **On `REVISE` from any of the 5 `SPEC_review*` Gates**: Append a `## Trajectory` row with `review_verdict = REVISE`, the finding IDs (for example `REQ-REV-*`, `ARCH-REV-*`, `DD-REV-*`, `IMPL-REV-*`, `PROD-REV-*`), and `Attempt k of max_rework_attempts`, and add the bounded rework checkbox task in `## Task Checklist` routing to the owning command (`SPEC_updateUserStory`, `SPEC_updateArchDesign`, `SPEC_updateDetailDesign`, `SPEC_designTests`, `SPEC_implTests`, or `SPEC_implProductCodes`).
- **After `SPEC_resumeUserStory` or `SPEC_whatsWrong`**: Append the resume or VibeCoding reconciliation entry to `## Trajectory`, re-verify `## Task Checklist` against the current branch/worktree and any re-adopted findings, and select the next safe `SPEC_*` command.

### 4. Orientation Boundary for Autonomous Mode

- Re-check `execution_mode` whenever `Work Orientation` changes:
  - If the story is still `intent-clearing`, `requirement-oriented`, or `design-oriented`, keep `autonomousMode` held and enforce `manualMode`.
  - Once requirements and detail design are locked (`PASS`) and `SPEC_updateMadePlan` transitions the story to `implementation-oriented`, an opt-in or driver-default `autonomousMode` may be unlocked to auto-advance through Part 2.b (`SPEC_designTests` → `SPEC_implTests` → `SPEC_reviewImplTests` → `SPEC_implProductCodes` → `SPEC_reviewProductCodes` → `SPEC_reviewImplTests` → `SPEC_commitStoryWorks` → `SPEC_closeUserStory`).

## Loop Guard

`SPEC_updateMadePlan` is a synchronization and planning step, not an unbounded rework loop. When called inside a `review -> update -> review` rework cycle, it must preserve and enforce the cycle's `max_rework_attempts` (default `3`) counter in `*-UserStory-Tasks.md` rather than resetting it. If a rework budget is exhausted, route to `SPEC_abortUserStory` or `ASK`.

## Conflict Guard

Do not use `SPEC_updateMadePlan` when no `*-UserStory-Tasks.md` exists yet; route to `SPEC_makePlan` to create the initial plan first.
Do not falsify gate evidence: never check `[x]` on a task whose review gate failed, was bypassed, or has no observable artifact/verdict evidence.
Do not use `SPEC_updateMadePlan` to silently drop failed review findings, weaken acceptance criteria, or remove required `SPEC_review*` gates from the checklist.
Do not unlock `autonomousMode` while `Work Orientation` is still `intent-clearing`, `requirement-oriented`, or `design-oriented`.
Do not plan `commit_step = yes` boundaries on steps that change no files or lack a deterministic `PASS`/`GREEN` gate.
Do not plan a story whose `README_UserStories.md` ledger state is `SUSPENDED`; route to `SPEC_resumeUserStory` first.

ONE-MORE-THING: ask developer if something not sure
