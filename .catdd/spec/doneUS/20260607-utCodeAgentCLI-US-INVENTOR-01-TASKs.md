# TASKs: utCodeAgentCLI INVENTOR US-INVENTOR-01 Delegate all CaTDD semantics to methodPrompts

Created by `/SPEC_makePlan` on 2026-08-26.
Updated by `/SPEC_makePlan` after intent clearing on 2026-08-26.
Updated by `/SPEC_reviewUserStory` on 2026-08-28 with result REVISE.
Updated by `/SPEC_reviewUserStory` on 2026-08-28 with re-review result PASS.
Updated by `/SPEC_updateDetailDesign` on 2026-08-28.
Updated by `/SPEC_reviewDetailDesign` on 2026-08-28 with result REVISE.
Updated by `/SPEC_updateDetailDesign` on 2026-08-28 after DD-REV-01 through DD-REV-04.
Updated by `/SPEC_reviewDetailDesign` on 2026-08-28 with re-review result REVISE.
Updated by `/SPEC_updateDetailDesign` on 2026-08-28 after DD-REV-05.
Updated by `/SPEC_reviewDetailDesign` on 2026-08-28 with final result PASS.
Updated by `/SPEC_designUnitTests` on 2026-08-28.
Updated by `/UT_reviewFuncTestsSkeleton` on 2026-08-28 with result REVISE.
Updated by `/SPEC_updateUserStory`, `/SPEC_designUnitTests`, and `/UT_reviewFuncTestsSkeleton` on 2026-08-28 after FUNC-REV-01; skeleton review PASS.
Updated by `/SPEC_reviewUserStory` on 2026-08-28 after FUNC-REV-01; requirement review PASS.
Updated by `/UT_tellMeNextImplTest` on 2026-08-28; TC-DELEGATE-001 selected and remains PLANNED.
Updated by `/SPEC_implUnitTests` on 2026-08-28; TC-DELEGATE-001 is valid RED and TC-level review PASS.
Updated by `/SPEC_reviewImplUnitTests` on 2026-08-28; result FIX IMPLEMENTATION with IMPL-REV-01 and IMPL-REV-02.
Updated by `/SPEC_implUnitTests` on 2026-08-28; both review findings corrected, focused RED and TC-level correction review PASS.
Updated by `/SPEC_reviewImplUnitTests` on 2026-08-28; corrected TC-DELEGATE-001 re-review PASS.
Updated by `/SPEC_implProductCodes` on 2026-08-28; TC-DELEGATE-001 GREEN on correction attempt 1.
Updated by `/SPEC_reviewProductCodes` on 2026-08-28; result UPDATE DESIGN with PROD-REV-01.
Updated by `/SPEC_updateDetailDesign` on 2026-08-29; PROD-REV-01 ownership and test-first correction defined.
Reconciled by `/SPEC_updateUserStory` on 2026-08-30 as historical partial-closure evidence; unchecked steps below remain preserved and are not current commands.
Paired with [20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md](20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md).

## Partial Closure Archive

- **ID:** US-INVENTOR-01
- **Title:** Delegate all CaTDD semantics to methodPrompts
- **Priority:** P0
- **Lifecycle phase:** Partially closed; AC-01 accepted, AC-02 through AC-16 unfinished
- **Branch:** `feat/utcodeagentcli-us-inventor-01`
- **Current reconciliation owner:** [US-SPECFLOW-REPAIR-01](../doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md)
- **Unfinished-scope owner:** [US-INVENTOR-01-FOLLOWUP-01](../todoUS/20260830-utCodeAgentCLI-US-INVENTOR-01-remaining-delegation-UserStory.md)

## Requirement Source Trace

- Role index: [README_UserStory4INVENTOR.md](../../../codeAgents/utCodeAgentCLI/README_UserStory4INVENTOR.md)
- Detailed source: [README_UserStory4INVENTOR-01.md](../../../codeAgents/utCodeAgentCLI/USs/README_UserStory4INVENTOR-01.md)
- Paired usage context: [README_UserGuide.md](../../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Module AC dashboard: [README_UserStoryStatus.md](../../../codeAgents/utCodeAgentCLI/README_UserStoryStatus.md)
- Architecture evidence: [README_ArchDesign.md](../../../codeAgents/utCodeAgentCLI/README_ArchDesign.md)
- Former detail-design evidence: `codeAgents/utCodeAgentCLI/README_DetailDesign.md` was removed by `ADR_ArchitectureOnlyDesignPolicy.md`; current design authority is ArchDesign.
- Verification evidence: [README_VerifyDesign.md](../../../codeAgents/utCodeAgentCLI/README_VerifyDesign.md)
- Project context: [projectContext.md](../projectContext.md)

## Current Readiness

| Prerequisite | Status | Evidence or gap |
| --- | --- | --- |
| Story lifecycle | Partially closed | This artifact is archived under `doneUS/`; only AC-01 is accepted done scope. |
| Requirement identity | Satisfied | `US-INVENTOR-01 [P0]` has 16 stable ACs across Typical, Edge, Misuse, and Fault. |
| Module AC status | Reconciled | The detailed source and dashboard show AC-01 DONE and AC-02 through AC-16 TODO. |
| Mutual Intent Contract | Cleared | Fresh-read, diagnostic-proof, version-drift, and ledger decisions are recorded in the active story. |
| Story ledger | Satisfied by developer decision | `codeAgents/utCodeAgentCLI/README_UserStoryStatus.md` is authoritative for this module; a root ledger is out of scope. |
| Canonical requirement wording | Reviewed PASS | Stable ACs use the canonical 4/2/2/8 Typical/Edge/Misuse/Fault distribution. |
| Project context | Corrected | It records the runnable US-USER-01 validation slice and the remaining unimplemented end-to-end boundary. |
| Architecture | Satisfied | Existing architecture defines the resolver/delegation boundaries; the cleared intent changes no module ownership or dependency direction. |
| Detail design | Historical update preserved | PROD-REV-01 design evidence remains historical; canonical-session repair is owned by US-UTCLI-REPAIR-01. |
| Story-specific verification design | Updated | INV-01 category coverage, traceability, flow coupling, and parallel-ready slices are recorded. |
| Test status | In GREEN review | TC-DELEGATE-001 is GREEN; the other 15 TCs remain PLANNED with corrected 4/2/2/8 category ownership. |
| Executable US-INVENTOR-01 tests | One GREEN | TC-DELEGATE-001 passes after minimum product implementation; 38 existing CLI tests also pass. |
| Product-code review | Partial acceptance | AC-01 public-path evidence was accepted; the broader session contract is not implied complete. |

## Work Orientation

**Historical partial-closure record.** The unchecked sequence below shows work that was not completed in this lifecycle artifact. It is retained as evidence and must not be followed as the current plan.

## Cleared Intent Decisions

1. Read canonical semantic assets fresh during every invocation; do not persist semantic content across invocations.
2. Use structured run-plan or fake-runtime capture of resolved paths, current source content, and ordered events as INV-01 proof; keep CLI diagnostic rendering in INV-03.
3. Defer method/CLI version-drift detection to a future compatibility story.
4. Use the module-scoped `README_UserStoryStatus.md` as the authoritative `utCodeAgentCLI` status dashboard.

## Candidate Next Steps

| Candidate | Decision | Rationale |
| --- | --- | --- |
| `SPEC_reviewDetailDesign` | Superseded | This was the historical selection before partial closure. |
| `SPEC_reviewImplUnitTests` | Blocked | Product review has not passed. |
| P1/P2 design commands | Deferred | No additional source-backed AC requires promotion. |

## Historical Task Checklist

Checked items record completed historical steps. Unchecked items remain intentionally unchecked and are not current next actions.

- [x] **SPEC_importUserStory** - Import the structured US-INVENTOR-01 slice into `todoUS/`.
- [x] **SPEC_openUserStory** - Move the story into `doingUS/` on its dedicated branch.
- [x] **SPEC_makePlan** - Classify readiness, orientation, blockers, and the first safe next command.
- [x] **SPEC_clearStoryIntent** - Record a CLEARED Mutual Intent Contract and resolve the four blocking decisions.
- [x] **SPEC_makePlan** - Replan from cleared intent and select requirement synchronization.
- [x] **SPEC_updateUserStory** - Synchronize the four intent decisions and active AC status into module requirement surfaces.
- [x] **SPEC_reviewUserStory** - Review requirement consistency; result REVISE with four requirement findings and one project-context finding.
- [x] **SPEC_updateUserStory** - Correct dependency direction, diagnostic ownership, AC-07 assets, and AC-12 behavior.
- [x] **SPEC_updateProjectContext** - Correct the stale documentation-only CLI project fact.
- [x] **SPEC_reviewUserStory** - Re-review corrected requirements; result PASS and transfer to detail design.
- [x] **SPEC_updateDetailDesign** - Add fresh asset sessions, generic runtime capture, ordered evidence, root containment, and metadata-only projections.
- [x] **SPEC_reviewDetailDesign** - Review the detail-design revision; result REVISE with DD-REV-01 through DD-REV-04.
- [x] **SPEC_updateDetailDesign** - Correct safe path projection, prepared-step lifecycle, static-containment assumption, and content lifetime.
- [x] **SPEC_reviewDetailDesign** - Re-review DD-REV-01 through DD-REV-04; those pass, but DD-REV-05 requires revision.
- [x] **SPEC_updateDetailDesign** - Define redacted `TraceInvocation` and safe `TraceWorkspace` schemas plus whole-trace leakage tests.
- [x] **SPEC_reviewDetailDesign** - Re-review DD-REV-05; result PASS and direct transfer to test design by developer decision.
- [x] **SPEC_designUnitTests** - Design four P0 category files with 16 PLANNED TCs and companion READMEs.
- [x] **UT_reviewFuncTestsSkeleton** - Review category placement and traceability; result REVISE with FUNC-REV-01.
- [x] **SPEC_updateUserStory** - Move AC-05/06 and AC-09/10 to Fault in canonical requirement surfaces.
- [x] **SPEC_designUnitTests** - Redistribute stable TCs and update companion/verification documentation.
- [x] **UT_reviewFuncTestsSkeleton** - Re-review the corrected P0 skeleton set; result PASS.
- [x] **SPEC_reviewUserStory** - Review the corrected canonical category assignment; result PASS.
- [x] **UT_tellMeNextImplTest** - Select TC-DELEGATE-001; status remains PLANNED.
- [x] **SPEC_implUnitTests** - Implement TC-DELEGATE-001 only; meaningful RED and TC-level review PASS.
- [x] **SPEC_reviewImplUnitTests** - Review TC-DELEGATE-001; result FIX IMPLEMENTATION with IMPL-REV-01 and IMPL-REV-02.
- [x] **SPEC_implUnitTests** - Correct TC-DELEGATE-001 resolver coverage and TypeScript module scope; focused RED and TC-level review PASS.
- [x] **SPEC_reviewImplUnitTests** - Re-review corrected TC-DELEGATE-001; result PASS.
- [x] **SPEC_implProductCodes** - Implement the minimum TC-DELEGATE-001 product slice; GREEN on attempt 1.
- [x] **SPEC_reviewProductCodes** - Review the product slice; result UPDATE DESIGN with PROD-REV-01.
- [x] **SPEC_updateDetailDesign** - Assign root canonicalization to `InvocationAssetSession` and define a TC-DELEGATE-001 logical-alias correction.
- [ ] **SPEC_reviewDetailDesign** - Review the PROD-REV-01 detail-design correction before test/product changes.
- [ ] **SPEC_implUnitTests** - Retarget TC-DELEGATE-001 to a logical workspace alias and confirm RED for the wrong root-labeled path.
- [ ] **SPEC_reviewImplUnitTests** - Review the PROD-REV-01 RED correction before product changes.
- [ ] **SPEC_implProductCodes** - Canonicalize and retain all session roots, then make TC-DELEGATE-001 GREEN.
- [ ] **SPEC_reviewProductCodes** - Re-review the corrected product slice.
- [ ] **SPEC_reviewImplUnitTests** - Re-run implemented-test review after product-code review.
- [ ] **SPEC_commitWorks** - Commit the verified story work.
- [ ] **SPEC_closeUserStory** - Move the completed story and task artifact into `doneUS/`.

## Historical Selected Command

### `/SPEC_reviewDetailDesign` (superseded)

This command was selected before the story was partially closed. Current lifecycle work is US-SPECFLOW-REPAIR-01, whose next command is `/SPEC_reviewUserStory`.

## Historical Rejected Next Steps

| Candidate | Reason rejected now |
| --- | --- |
| `SPEC_clearStoryIntent` | Intent is already CLEARED with no blocking questions. |
| `SPEC_updateUserStory` | REQ-REV-01 through REQ-REV-04 are corrected and requirement re-review passed. |
| `SPEC_updateProjectContext` | REQ-REV-05 is corrected and the context remains within budget. |
| `SPEC_reviewUserStory` | Corrected canonical category assignment passed review. |
| `SPEC_updateArchDesign` | No architecture-significant boundary or ownership decision changed. |
| `SPEC_reviewImplUnitTests` | Product-code review is blocked by PROD-REV-01. |
| `SPEC_reviewProductCodes` | The PROD-REV-01 design update, RED correction, and product correction remain upstream. |
| `SPEC_designUnitTests` | Corrected P0 skeleton distribution and verification handoff are complete. |
| `UT_reviewFuncTestsSkeleton` | Corrected functional skeleton review passed. |
| Another TC selection | Product-code review and post-product test review remain pending. |
| `SPEC_commitWorks` | Both downstream reviews remain pending. |

## Blockers

- Current status: this archive has no active blocker or executable next command; unresolved product/session scope is owned by US-UTCLI-REPAIR-01.

- No intent blocker remains.
- No requirement-review blocker remains; all five findings are closed.
- The module-ledger choice is accepted as an explicit project exception with residual process risk.
- DD-REV-01 through DD-REV-05 remain closed; the PROD-REV-01 follow-up design update is pending review.
- The post-PASS SpecFlow route conflict remains explicit for the next review decision.
- FUNC-REV-01 is closed with requirement and skeleton review PASS.
- IMPL-REV-01 and IMPL-REV-02 are corrected with TC-level PASS.
- PROD-REV-01 reproduces incorrect public path classification under a symlinked workspace root.
- Product approval and post-product `/SPEC_reviewImplUnitTests` remain blocked pending detail review, RED correction/review, and product correction/review.
