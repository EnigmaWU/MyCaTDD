# TASKs: Reconcile utCodeAgentCLI partial closure and lifecycle evidence

Created by `/SPEC_makePlan` on 2026-08-30.
Updated by `/SPEC_updateUserStory` on 2026-08-30; requirement synchronization attempt 1 of 3 is complete and review is pending.
Updated by `/SPEC_reviewUserStory` on 2026-08-30; result REVISE with REQ-REV-01 through REQ-REV-04.
Updated by `/SPEC_updateUserStory` on 2026-08-30; requirement synchronization attempt 2 of 3 corrected all four review findings and re-review is pending.
Updated by `/SPEC_reviewUserStory` on 2026-08-30; re-review result REVISE with REQ-REV-05, while REQ-REV-01 through REQ-REV-04 pass.
Updated by `/SPEC_updateUserStory` on 2026-08-30; final attempt 3 of 3 corrected REQ-REV-05 routing metadata only, and final re-review is pending.
Updated by `/SPEC_reviewUserStory` on 2026-08-30; final review PASS and transfer to initial detail design.
Updated by `/SPEC_takeDetailDesign` on 2026-08-30; initial lifecycle-checker design is complete and review is pending.
Updated by `/SPEC_reviewDetailDesign` on 2026-08-30; result REVISE with DD-REV-01 through DD-REV-03.
Updated by `/SPEC_updateDetailDesign` on 2026-08-30; attempt 1 of 3 corrected DD-REV-01 through DD-REV-03 and re-review is pending.
Updated after developer architecture decision on 2026-08-30; DetailDesign is removed, ArchDesign is the sole design authority, and architecture review is pending.
Paired with [20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md](20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md).

## Active Story

- **ID:** US-SPECFLOW-REPAIR-01
- **State:** doing / OPEN
- **Priority:** P1 Design / State
- **Branch:** `fix/utcodeagentcli-partial-closure-reconciliation`
- **Source:** [analyzed issue](../analyzedNews/20260830-reconcile-utCodeAgentCLI-closure-and-session-contract-Issue.md)
- **Related closed story:** [US-INVENTOR-01](../doneUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md)
- **Sibling product repair:** [US-UTCLI-REPAIR-01](../todoUS/20260830-utCodeAgentCLI-canonical-asset-session-repair-UserStory.md)

## Current Readiness

| Prerequisite | Status | Evidence or gap |
| --- | --- | --- |
| Lifecycle state | Satisfied | Exactly one active story exists in `doingUS/`; no suspended copy exists. |
| Intent alignment | Satisfied | BRAINSTORM decisions split product/lifecycle repair and define partial closure as AC-01 accepted with AC-02..AC-16 unfinished. |
| Requirement source | Satisfied | Five atomic acceptance criteria define lifecycle reconciliation and checker invocation behavior. |
| Project story ledger | Repository exception | No root `README_UserStories.md` exists; the accepted module authority is `codeAgents/utCodeAgentCLI/README_UserStoryStatus.md`. |
| Requirement surfaces | Reviewed PASS | REQ-REV-01 through REQ-REV-05 are closed after three bounded update/review attempts. |
| Architecture | Satisfied / skipped | No module boundary, dependency direction, runtime placement, or quality trade-off changes. |
| Detail design | Superseded / removed | Developer ADR forbids standalone DetailDesign for `utCodeAgentCLI`; prior commands remain historical evidence only. |
| Architecture policy | Updated / review pending | ArchDesign mirrors, ADR, and subproject context define sole design ownership and the checker boundary. |
| Verification design | Updated / architecture review pending | Current links, historical state, stable repair AC IDs, unfinished delegation ownership, and architecture-review command are explicit. |
| Executable validation | Missing | Existing structure checks pass despite the cross-artifact contradictions. |
| Baseline planning-contract test | Unrelated failure | `test_specflow_take_plan.sh` still expects `*-TASKs.md`; committed `SPEC_makePlan.md` uses `*-UserStory-Tasks.md`. |

## Work Orientation

**Requirement-oriented first, then implementation-oriented.** The first slice synchronizes the formal lifecycle/status meaning across the module ledger and related shared documents. After requirement review passes, design and implement a focused validation that detects lane, link, checklist, status, and authority contradictions.

## Candidate Next Steps

| Candidate | Decision | Rationale |
| --- | --- | --- |
| `SPEC_clearStoryIntent` | Skip | Developer decisions already resolve scope split, partial-closure meaning, preservation policy, and non-goals. |
| `SPEC_updateUserStory` | Completed | Final attempt 3 corrected REQ-REV-05 only. |
| `SPEC_reviewUserStory` | Completed PASS | Final re-review closed REQ-REV-01 through REQ-REV-05. |
| `SPEC_takeArchDesign` / `SPEC_updateArchDesign` | Skip | No architecture-significant decision changes. |
| `SPEC_takeDetailDesign` | Historical / superseded | A draft was created and then removed by the architecture-only ADR. |
| `SPEC_reviewDetailDesign` | Historical / superseded | Attempt 1 findings are preserved, but the design surface was removed by ADR. |
| `SPEC_updateDetailDesign` | Historical / superseded | Corrections were superseded with the removed design surface. |
| `SPEC_updateArchDesign` | Completed | ArchDesign mirrors now own the documentation policy and lifecycle-checker boundary. |
| `SPEC_reviewArchDesign` | Selected | Review the replacement authority before test design. |
| `SPEC_designUnitTests` | Blocked | Requirement/status documents must be synchronized and reviewed first. |
| `SPEC_commitWorks` | Blocked | Reconciliation and executable validation are not implemented or reviewed. |

## Planned Validation Checkpoints

1. Requirement checkpoint: AC-01 is represented as accepted done scope; AC-02..AC-16 have one explicit unfinished owner/forward trace; totals remain 16.
2. Trace checkpoint: no current document points the closed INV-01 story to a nonexistent `doingUS` location or obsolete next command.
3. Archive checkpoint: duplicate USER-01 generations identify one authoritative completed record without deleting historical evidence.
4. Guard checkpoint: a focused automated check fails on the diagnosed fixture/state and passes after reconciliation.
5. Regression checkpoint: README mirror, documentation contract, code-agent structure, slash-command completeness, and relevant Node tests remain green.

## Task Checklist

- [x] **SPEC_importIssue** - Preserve the diagnosis as raw pending input.
- [x] **SPEC_analyzeIssue** - Split product repair from lifecycle reconciliation and archive the source issue.
- [x] **SPEC_openUserStory** - Move US-SPECFLOW-REPAIR-01 to `doingUS/` on its dedicated branch.
- [x] **SPEC_clearStoryIntent** - Skipped as already satisfied by recorded BRAINSTORM decisions; no blocking intent question remains.
- [x] **SPEC_makePlan** - Select requirement-first reconciliation and record downstream validation gates.
- [x] **SPEC_updateUserStory** - Synchronize partial-closure semantics, module AC status, archive authority, verification guidance, and forward traces.
- [x] **SPEC_reviewUserStory** - Attempt 1 result REVISE with REQ-REV-01 through REQ-REV-04.
- [x] **SPEC_updateUserStory** - Attempt 2: assign unfinished-scope ownership, correct AC-02, add stable AC IDs, and add active-story ledger status.
- [x] **SPEC_reviewUserStory** - Re-review attempt 2: REQ-REV-01 through REQ-REV-04 PASS; REQ-REV-05 requires revision.
- [x] **SPEC_updateUserStory** - Attempt 3: normalized only the active story's conflicting current next-command metadata.
- [x] **SPEC_reviewUserStory** - Final re-review PASS; REQ-REV-01 through REQ-REV-05 closed.
- [x] **SPEC_takeDetailDesign** - Define lifecycle-validator ownership, inputs, outputs, diagnostics, fixture strategy, and AC mapping.
- [x] **SPEC_reviewDetailDesign** - Attempt 1 result REVISE with DD-REV-01 through DD-REV-03.
- [x] **SPEC_updateDetailDesign** - Add AC-05 ownership and define closure-pair and verification-target algorithms.
- [x] **Architecture-only decision** - Record ADR and subproject context; remove all `utCodeAgentCLI` DetailDesign files.
- [x] **SPEC_updateArchDesign** - Make ArchDesign the sole authority and preserve the lifecycle-checker boundary.
- [ ] **SPEC_reviewArchDesign** - Review the architecture-only policy and checker boundary before test skeletons.
- [ ] **SPEC_designUnitTests** - Design focused lifecycle-consistency validation from AC-01 through AC-05.
- [ ] **SPEC_implUnitTests** - Implement the validation test first and confirm meaningful RED against the diagnosed inconsistency where applicable.
- [ ] **SPEC_reviewImplUnitTests** - Review traceability, assertions, and RED evidence.
- [ ] **SPEC_implProductCodes** - Apply the minimum reconciliation/validator changes needed for GREEN.
- [ ] **SPEC_reviewProductCodes** - Review lifecycle semantics, history preservation, and regression evidence.
- [ ] **SPEC_reviewImplUnitTests** - Re-run implemented-test review after product changes.
- [ ] **SPEC_commitWorks** - Commit only reviewed story work, excluding unrelated working-tree changes.
- [ ] **SPEC_closeUserStory** - Close after ledger, tasks, reviews, commit, and verification are synchronized.
- [ ] **SPEC_mergeWorks** - Merge the dedicated branch after close if integration is still required.

## Selected Next Command

### `/SPEC_reviewArchDesign`

Review the architecture-only ADR, subproject context, ArchDesign mirrors, deleted DetailDesign surfaces, and lifecycle-checker boundary before test design.

## Rejected Next Steps

| Candidate | Reason rejected now |
| --- | --- |
| `/SPEC_updateUserStory` | All three bounded attempts are complete and final requirement review passed. |
| `/SPEC_reviewUserStory` | Final review passed; repeating it would add no changed evidence. |
| `/SPEC_reviewDetailDesign` | Superseded by the architecture-only ADR; no DetailDesign surface remains to review. |
| `/SPEC_updateDetailDesign` | Forbidden while the architecture-only ADR is active. |
| `/SPEC_designUnitTests` | Detail-design review has not passed. |
| `/SPEC_designUnitTests` | It would encode stale status and ownership before the requirement gate. |
| `/SPEC_partialCloseUserStory` | This story repairs prior evidence; it must not directly re-run partial closure against an already archived story. |
| `/SPEC_commitWorks` | Only opening and planning are complete. |

## Blockers and Open Questions

- No blocker prevents `/SPEC_reviewArchDesign`.
- Requirement rework reached its three-attempt limit and passed; do not reopen that loop without materially new evidence.
- During requirement update, determine the authoritative completed USER-01 generation from existing commit/review evidence; do not invent authority.
- If review finds that the focused validator changes a module boundary or quality trade-off, route to `/SPEC_updateArchDesign` before test design.

## Next Recommended Command

`/SPEC_reviewArchDesign`
