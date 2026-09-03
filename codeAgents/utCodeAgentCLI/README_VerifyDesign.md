# utCodeAgentCLI Verification Design

This document captures module-scoped verification strategy and US/AC/TC traceability for `utCodeAgentCLI`.

## Story and Design Inputs

- Active lifecycle-reconciliation story: [20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md](../../.catdd/spec/doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md)
- Active lifecycle-reconciliation TASKs: [20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory-Tasks.md](../../.catdd/spec/doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory-Tasks.md)
- Partially closed delegation story: [20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md](../../.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-INVENTOR-01-UserStory.md)
- Partially closed delegation TASKs: [20260607-utCodeAgentCLI-US-INVENTOR-01-TASKs.md](../../.catdd/spec/doneUS/20260607-utCodeAgentCLI-US-INVENTOR-01-TASKs.md)
- Reviewed requirement: [USs/README_UserStory4INVENTOR-01.md](USs/README_UserStory4INVENTOR-01.md)
- Completed regression story: [20260628-utCodeAgentCLI-US-USER-01-UserStory.md](../../.catdd/spec/doneUS/20260628-utCodeAgentCLI-US-USER-01-UserStory.md)
- Completed regression TASKs: [20260628-utCodeAgentCLI-US-USER-01-TASKs.md](../../.catdd/spec/doneUS/20260628-utCodeAgentCLI-US-USER-01-TASKs.md)
- [README_ArchDesign.md](README_ArchDesign.md)
- [README_ArchDesign.md](README_ArchDesign.md)
- [ADRs/ADR_ArchitectureOnlyDesignPolicy.md](ADRs/ADR_ArchitectureOnlyDesignPolicy.md)
- [SPEC_designUnitTests.md](../../slashCommands/commands/Px-SpecFlow/SPEC_designUnitTests.md)
- [UT_designFuncTestsSkeleton.md](../../slashCommands/commands/P0-FuncTestsFlow/UT_designFuncTestsSkeleton.md)
- [CaTDD_designAndImplTemplate.ts](../../methodPrompts/CaTDD_designAndImplTemplate.ts)
- [test_catdd_asset_delegation_funcValidTypical.ts](tests/test_catdd_asset_delegation_funcValidTypical.ts) - AC-01..AC-04
- [test_catdd_asset_delegation_funcValidEdge.ts](tests/test_catdd_asset_delegation_funcValidEdge.ts) - AC-07..AC-08
- [test_catdd_asset_delegation_funcInvalidMisuse.ts](tests/test_catdd_asset_delegation_funcInvalidMisuse.ts) - AC-11..AC-12
- [test_catdd_asset_delegation_funcInvalidFault.ts](tests/test_catdd_asset_delegation_funcInvalidFault.ts) - AC-05..AC-06, AC-09..AC-10, AC-13..AC-16
- [UT_US-USER-01-Typical.ts](tests/UT_US-USER-01-Typical.ts) — 10 Typical ACs (AC-01~AC-10)
- [UT_US-USER-01-Edge.ts](tests/UT_US-USER-01-Edge.ts) — 10 Edge ACs (AC-11~AC-20)
- [UT_US-USER-01-Misuse.ts](tests/UT_US-USER-01-Misuse.ts) — 9 Misuse ACs (AC-21~AC-28, AC-32)
- [UT_US-USER-01-Fault.ts](tests/UT_US-USER-01-Fault.ts) — 3 Fault ACs (AC-29~AC-31)

## Current Lifecycle Status

- Current lifecycle story: [20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md](../../.catdd/spec/doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md)
- Current lifecycle tasks: [20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory-Tasks.md](../../.catdd/spec/doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory-Tasks.md)
- Current lifecycle command: `/SPEC_reviewArchDesign`
- Executable delegation bodies: 2
- US-INVENTOR-01 is partially closed: AC-01 / TC-DELEGATE-001 is accepted DONE/GREEN evidence; AC-02 through AC-16 and TC-DELEGATE-002 through TC-DELEGATE-016 remain TODO/PLANNED under [US-INVENTOR-01-FOLLOWUP-01](../../.catdd/spec/todoUS/20260830-utCodeAgentCLI-US-INVENTOR-01-remaining-delegation-UserStory.md).
- The separate `TC-DELEGATE-001-SYMLINK` executable body is current regression evidence but has no independent CaTDD TC identity; its reconciliation belongs to `US-UTCLI-REPAIR-01`.
- Historical review sections below preserve the decisions that led to the partial closure. They are not current next-command guidance.
- Current lifecycle work is US-SPECFLOW-REPAIR-01; the architecture-only policy supersedes its DetailDesign route and selects `SPEC_reviewArchDesign`.

## Testing Definition

- SUT: `utCodeAgentCLI` module interface.
- Active unit slice: asset resolution, invocation-local sessions, generic run-plan translation, delegation evidence, prepared-step runtime handoff, and safe trace projection.
- Regression unit slice: CLI argument validation through `SrcTS/cli/main.ts` and `SrcTS/cli/invocationValidator.ts`.
- UnitTesting verifies command-contract behavior and test-file trace structure at repository file scope.
- ModuleTesting verifies `utCodeAgentCLI` preserves CaTDD method delegation and CLI validation behavior.
- UserTesting remains outside this story unless the CLI execution surface is changed.

## Test Strategy

Design P0 Functional coverage first because US-INVENTOR-01 defines externally observable delegation success and failure behavior at the module interface. Use all four categories through `UT_designFuncTestsSkeleton` before implementation:

- Typical (AC-01..AC-04): current prompt/command capture, source provenance, and ordered events.
- Edge (AC-07..AC-08): three independent prompt reads and fresh next-invocation content.
- Misuse (AC-11..AC-12): configured-root escape rejection.
- Fault (AC-05..AC-06, AC-09..AC-10, AC-13..AC-16): empty/deleted assets, missing root, permission denial, missing commands directory, and wrong file kind.

P1/P2 promotion is deferred in this design step. The accepted story classifies these 16 observable contracts as P0, and no additional P1/P2 ACs have been accepted. Reconsider Interaction or Security only after P0 skeleton review and a source-backed story/design update.

The completed US-USER-01 slice remains the regression baseline:

The redesigned TypeScript UnitTesting files use `UT_designFuncTestsSkeleton` semantics for the full P0 set (32-AC redesign via `SPEC_designUnitTests`):

- Typical (AC-01~AC-10): valid invocation proceeds to behavior dispatch readiness.
- Edge (AC-11~AC-20): valid boundary or mode variation — redesigned from non-required to required.
- Misuse (AC-21~AC-28, AC-32): missing required args, empty string args, mutually exclusive pairs, unrecognized/unparseable values, target/behave mismatch, and structurally wrong config rejected.
- Fault (AC-29~AC-31): missing file-path dependencies, invalid YAML config, and directory-as-config surfaced with diagnostics.

## CaTDD Category Coverage

| Priority | Category | Scope | Required Now | Notes |
| --- | --- | --- | --- | --- |
| P0 | Functional: Typical | INV-01 normal delegation (AC-01..AC-04) | Yes | `TC-DELEGATE-001` GREEN; `TC-DELEGATE-002..004` PLANNED. |
| P0 | Functional: Edge | INV-01 valid delegation boundaries (AC-07..AC-08) | Yes | `TC-DELEGATE-007..008`, all PLANNED. |
| P0 | Functional: Misuse | INV-01 rejected configured topology (AC-11..AC-12) | Yes | `TC-DELEGATE-011..012`, all PLANNED. |
| P0 | Functional: Fault | INV-01 filesystem dependency failures (AC-05..06, AC-09..10, AC-13..16) | Yes | `TC-DELEGATE-005..006,009..010,013..016`, all PLANNED. |
| P0 | USER-01 regression: Typical | Valid invocation success path (AC-01~AC-10) | Yes | `TC-ARG-001..010`, GREEN. |
| P0 | USER-01 regression: Edge | Valid boundary or mode variation (AC-11~AC-20) | Yes | `TC-ARG-011..020`, GREEN. |
| P0 | USER-01 regression: Misuse | Invalid caller argument contract checks (AC-21~AC-28, AC-32) | Yes | `TC-ARG-021..031`, GREEN. |
| P0 | USER-01 regression: Fault | File-path failure handling (AC-29~AC-31) | Yes | `TC-ARG-029..035`, GREEN. |
| P1 | Design: State/Capability/Concurrency | Runtime state or capability design | No | Not introduced by this story. |
| P2 | Quality: Performance/Robust/Compatibility/Configuration | Quality envelopes | No | Not introduced by this story. |

## US/AC/TC Traceability

| US | AC | TC | Test File | Status |
| --- | --- | --- | --- | --- |
| US-INVENTOR-01 | AC-01..AC-04 | TC-DELEGATE-001..004 | tests/test_catdd_asset_delegation_funcValidTypical.ts | TC-001 GREEN; TC-002..004 PLANNED |
| US-INVENTOR-01 | AC-07..AC-08 | TC-DELEGATE-007..008 | tests/test_catdd_asset_delegation_funcValidEdge.ts | PLANNED |
| US-INVENTOR-01 | AC-11..AC-12 | TC-DELEGATE-011..012 | tests/test_catdd_asset_delegation_funcInvalidMisuse.ts | PLANNED |
| US-INVENTOR-01 | AC-05..06, AC-09..10, AC-13..16 | TC-DELEGATE-005..006,009..010,013..016 | tests/test_catdd_asset_delegation_funcInvalidFault.ts | PLANNED |
| US-USER-01 | AC-01~AC-32 | TC-ARG-001..TC-ARG-035 | tests/UT_US-USER-01-*.ts | GREEN |

## US-INVENTOR-01 Flow Coupling Decision

- P0 route: full `UT_designFuncTestsSkeleton` set in Typical -> Edge -> Misuse -> Fault order.
- Inspected category contracts: `UT_designTypicalSkeleton`, `UT_designEdgeSkeleton`, `UT_designMisuseSkeleton`, and `UT_designFaultSkeleton` through the aggregate command.
- Language template: `methodPrompts/CaTDD_designAndImplTemplate.ts`.
- File naming: `test_catdd_asset_delegation_{category}.ts` with canonical category tokens.
- P1/P2: not promoted in this step because no additional source-backed AC is accepted.
- Required review before implementation: `UT_reviewFuncTestsSkeleton` (PASS after category correction).

## Functional Skeleton Review Result

- Result: PASS on 2026-08-28 after FUNC-REV-01 correction.
- Typical: 4 TCs for AC-01..04.
- Edge: 2 TCs for AC-07..08.
- Misuse: 2 TCs for AC-11..12.
- Fault: 8 TCs for AC-05..06, AC-09..10, and AC-13..16.
- Traceability at the skeleton gate: 16 unique PLANNED TCs; every AC has exactly one TC.
- Provenance: every category file identifies SUT, SPEC/UT commands, and TypeScript template.
- Design-only status passed at the skeleton gate; implementation began only after selection.
- Companion documentation: all four `_readme.md` files match category ownership and counts.
- Requirement review: PASS after canonical category assignments and verification summaries were synchronized.
- TC selection: `TC-DELEGATE-001` selected by `UT_tellMeNextImplTest`.
- RED implementation: PASS; one test runs and fails at the implementation keypoint for missing `SrcTS/catdd/behaviorRegistry.ts`.
- TC-level structural review: PASS for two key assertions, four phases, cleanup, and metadata preservation.
- Story-level implementation re-review: PASS; IMPL-REV-01 and IMPL-REV-02 are closed.
- Product implementation: GREEN on correction attempt 1 for TC-DELEGATE-001 only.
- Product-code review at that historical checkpoint: UPDATE DESIGN with PROD-REV-01.
- PROD-REV-01 detail design was updated on 2026-08-29; later public-path evidence was accepted for AC-01 partial closure.
- Broader canonical-session contract reconciliation is tracked separately by US-UTCLI-REPAIR-01.

## Selected Implementation Test

- TC: `TC-DELEGATE-001 verifyEdgePromptResolution_byValidInvocation_expectCurrentContentCapture`.
- Trace: US-INVENTOR-01 / AC-01 / P0 Functional / ValidFunc / Typical.
- Selection reason: all INV-01 TCs are PLANNED, Typical is the highest ready category, and no source-backed risk override changes the default order.
- Dependency value: this slice establishes current prompt resolution and fake-runtime capture used by later provenance, ordering, and freshness tests.
- Initial result: meaningful RED because `SrcTS/catdd/behaviorRegistry.ts` did not exist.
- Current status: GREEN; the other 15 INV-01 TCs remain PLANNED.
- Correction evidence: behavior, planning, command resolution, prompt resolution, and run-plan translation are invoked once; the expected public path is no longer supplied to the run plan.
- Module-scope evidence: the test and two support files are diagnostic-clean.
- Product-code result: GREEN and accepted as the AC-01 partial-closure slice; broader session-contract review is not implied complete.

## Story-Level Implemented-Test Review

- Result: FIX IMPLEMENTATION on 2026-08-28.
- IMPL-REV-01: TC-DELEGATE-001 does not call `resolveBehavior`, `planCatddRun`, or `resolveMethodPrompts`; assigning the same Edge path literal to the run-plan input and expected value makes the path check self-fulfilling.
- IMPL-REV-02: Pylance reports three block-scoped redeclarations because the CommonJS-style test and support files are global scripts rather than isolated TypeScript modules.
- Preserved evidence: the test is meaningfully RED, P0-first ordering is correct, all required metadata and four phase markers remain, two key assertions are inside VERIFY, and cleanup is deterministic.
- Companion README: reviewed and updated through `test-case-with-readme`; Purpose, Status, Covered, Manual, and review evidence match the implementation.
- Required correction: start from a valid invocation whose behavior is `designEdgeSkeleton`, traverse the approved behavior/planning/prompt-resolution chain, assert only the fake runtime's derived context asset, and add module scope to the test/support files.
- Next command: `SPEC_implUnitTests` for TC-DELEGATE-001 only; do not add product code.

### Correction Result

- Applied by `SPEC_implUnitTests` on 2026-08-28.
- IMPL-REV-01: corrected; the approved resolver chain derives all command and prompt assets before fake-runtime preparation.
- IMPL-REV-02: corrected; type-only module markers remove all three redeclaration diagnostics without changing CommonJS execution.
- Focused result: one test executes and remains RED for missing `SrcTS/catdd/behaviorRegistry.ts`.
- TC-level correction review: PASS; one-TC scope, phases, keypoints, cleanup, metadata, and 1 RED / 15 PLANNED status are preserved.
- Story-level status: re-review PASS; product-code implementation may begin for TC-DELEGATE-001 only.

### Re-review Result

- Result: PASS on 2026-08-28.
- US/AC/TC alignment: PASS; `designEdgeSkeleton` drives resolver-derived Edge prompt capture for US-INVENTOR-01 AC-01.
- Assertions and phases: PASS; two keypoints are inside VERIFY and all four phases plus cleanup are explicit.
- P0/status discipline: PASS; TC-DELEGATE-001 is the only RED and the other 15 TCs remain PLANNED.
- RED evidence: PASS; one test fails at the first missing product module, `SrcTS/catdd/behaviorRegistry.ts`.
- Diagnostics: PASS; the test and support files have zero reported errors.
- Companion README: PASS using `test-case-with-readme`; naming, required sections, status, grounding, and manual command are current.
- Product review correlation: not applicable because no product code exists yet.
- Drift findings: none remain.
- Next command: `SPEC_implProductCodes` for the minimum TC-DELEGATE-001 implementation.

## Product Implementation Result

- Target: US-INVENTOR-01 / AC-01 / TC-DELEGATE-001.
- Permitted scope: `SrcTS/catdd/behaviorRegistry.ts`, `planner.ts`, `invocationAssetSession.ts`, `slashCommandResolver.ts`, `methodPromptResolver.ts`, and `agentRunPlanBuilder.ts`.
- Initial RED: one test failed for missing `SrcTS/catdd/behaviorRegistry.ts`.
- Focused validation: `node --test codeAgents/utCodeAgentCLI/SysTests/test_catdd_asset_delegation_funcValidTypical.ts`.
- Correction attempts: 1 of 3; no follow-up correction was required.
- Evaluation: GREEN; one focused test passes and 38 existing CLI regressions pass.
- Delegation boundary: product code contains routing paths only; current method/command content is read from injected asset roots and translated into generic runtime inputs.
- Remaining failures: none in the selected scope.
- Stop reason: targeted GREEN reached without scope expansion.
- Next command: `SPEC_reviewProductCodes`; after PASS, rerun `SPEC_reviewImplUnitTests`.

## Historical Product-Code Review Result

- Result: UPDATE DESIGN on 2026-08-28.
- Passing evidence: TC-DELEGATE-001 and all 38 existing CLI regressions pass; product/test diagnostics and semantic-isolation checks pass.
- Traceability and minimality: PASS for US-INVENTOR-01 / AC-01 / TC-DELEGATE-001 and the six reviewed product files.
- Delegation boundary: PASS; product code contains path/routing metadata and loads semantic bytes from injected assets.
- PROD-REV-01: `invocationAssetSession.ts` compares a canonical asset path with `path.resolve(context.workspaceRoot)`, which is absolute but not canonical.
- Reproduction: with `/workspace-link -> /real/workspace`, the internal Edge prompt projects as `<methodPromptsRoot>/CaTDD_methodPrompt4Cat-Edge.md` instead of `methodPrompts/CaTDD_methodPrompt4Cat-Edge.md`.
- Contract impact: this contradicts the reviewed rule that assets inside the workspace use workspace-relative `PublicAssetPath` values.
- Design gap: `CliExecutionContext` does not state whether its `workspaceRoot` is already canonical or whether `InvocationAssetSession`/`toPublicAssetPath` owns canonicalization.
- Future-scope observations: typed asset errors and eager root/`commands/` validation remain covered by PLANNED Fault/Misuse TCs and are not blockers for TC-DELEGATE-001 review.
- Required action: use `SPEC_updateDetailDesign` to assign workspace-root canonicalization ownership and matching verification guidance before changing product code.
- Product approval: BLOCKED; do not run the post-product `SPEC_reviewImplUnitTests` until PROD-REV-01 is corrected and product review passes.

### PROD-REV-01 Detail-Design Correction

- Updated by `SPEC_updateDetailDesign` on 2026-08-29.
- Ownership: `CliExecutionContext` carries normalized logical roots that may be symlinks; `openAssetSession` asynchronously canonicalizes workspace, method-prompt, slash-command, and `commands/` roots through `AssetFileSystem`.
- Session invariant: immutable `CanonicalAssetRoots` are retained for the invocation, and public projection compares canonical asset paths with the canonical workspace root only.
- Public projection: canonical workspace-contained assets use normalized workspace-relative paths; canonical workspace-external assets use configured-root labels.
- Test-first correction: preserve TC-DELEGATE-001 and change its fake topology so `/workspace-link` canonicalizes to `/real/workspace`; the current product must become RED by emitting a root-labeled path before product correction.
- Product correction after RED review: make `openAssetSession` return `Promise<InvocationAssetSession>`, retain canonical roots once per session, and use those roots for containment and projection.
- Scope: no new user-story AC or TC; typed error and eager root-validation behavior remains with the existing PLANNED Fault/Misuse TCs.
- Later evidence corrected the workspace-relative public-path output, but the reviewed asynchronous session-opening and immutable-root contract remains tracked by US-UTCLI-REPAIR-01.
- This section is historical and does not select the current lifecycle command.

## Parallel-Ready Implementation Handoff

| Slice | US / AC / TC | Target file | Dependency | Validation checkpoint |
| --- | --- | --- | --- | --- |
| A | INV-01 / AC-01..04 / TC-DELEGATE-001..004 | `test_catdd_asset_delegation_funcValidTypical.ts` | Generic run-plan and evidence contracts | Focused node:test run after RED implementation |
| B | INV-01 / AC-07..08 / TC-DELEGATE-007..008 | `test_catdd_asset_delegation_funcValidEdge.ts` | InvocationAssetSession and three-prompt registry | Focused node:test run after RED implementation |
| C | INV-01 / AC-11..12 / TC-DELEGATE-011..012 | `test_catdd_asset_delegation_funcInvalidMisuse.ts` | Root containment and safe path projection | Focused node:test run after RED implementation |
| D | INV-01 / AC-05..06,09..10,13..16 / TC-DELEGATE-005..006,009..010,013..016 | `test_catdd_asset_delegation_funcInvalidFault.ts` | Fake filesystem hooks and typed dependency errors | Focused node:test run after RED implementation |

The four test files can be implemented in parallel after shared fake-port interfaces are frozen. Product-code implementation remains downstream of valid RED review because all slices touch shared resolver/session behavior.

## Regression Surface

The existing `US-USER-01` CLI validation tests must remain GREEN after any redesign:

```bash
node --test codeAgents/utCodeAgentCLI/SysTests/UT_US-USER-01-Typical.ts codeAgents/utCodeAgentCLI/SysTests/UT_US-USER-01-Edge.ts codeAgents/utCodeAgentCLI/SysTests/UT_US-USER-01-Misuse.ts codeAgents/utCodeAgentCLI/SysTests/UT_US-USER-01-Fault.ts
```

Expected result: all 38 executable USER-01 regression cases pass.

All executable `UT_US-USER-01` cases invoke `utCodeAgentCLI` as a subprocess. They do not call `validateInvocation(...)` directly.

## Risks and Deferred Coverage

- Shared fake filesystem/runtime contracts must be frozen before parallel test implementation.
- The V1 stable-filesystem assumption excludes concurrent adversarial topology mutation.
- P1 Interaction and P2 Security remain deferred until source-backed ACs explicitly request promotion.
- Further canonical-session product work belongs to US-UTCLI-REPAIR-01 and must follow that story's test-first gates.

## Usage Example

Run from the repository root to verify the INV-01 package has one metadata-bearing GREEN TC, 15 remaining PLANNED TCs, and two current executable test bodies:

```bash
FILES=(
  codeAgents/utCodeAgentCLI/SysTests/test_catdd_asset_delegation_funcValidTypical.ts
  codeAgents/utCodeAgentCLI/SysTests/test_catdd_asset_delegation_funcValidEdge.ts
  codeAgents/utCodeAgentCLI/SysTests/test_catdd_asset_delegation_funcInvalidMisuse.ts
  codeAgents/utCodeAgentCLI/SysTests/test_catdd_asset_delegation_funcInvalidFault.ts
)

test "$(rg -o '@\[TC\]: TC-DELEGATE-[0-9]{3}' "${FILES[@]}" | sed 's/.*TC-DELEGATE/TC-DELEGATE/' | sort -u | wc -l | tr -d ' ')" -eq 16
test "$(rg -c '@\[Status:PLANNED\]' "${FILES[@]}" | awk -F: '{sum += $2} END {print sum}')" -eq 15
test "$(rg -c '@\[Status:GREEN\]' "${FILES[@]}" | awk -F: '{sum += $2} END {print sum}')" -eq 1
test "$(rg -c '^test\(' "${FILES[@]}" | awk -F: '{sum += $2} END {print sum}')" -eq 2
```

Expected result: no output and exit code 0.

## Review Checklist

- SUT is explicit in the UnitTesting overviews and category skeletons.
- P0 Functional coverage is complete before P1/P2 promotion.
- Every INV-01 AC has one TC with explicit PLANNED or GREEN status and every TC traces to its US and AC.
- Typical, Edge, Misuse, and Fault use canonical category-specific filenames.
- Each new test file has an exact `_readme.md` companion.
- P1/P2 deferral is source-backed and explicit.
- `UT_designFuncTestsSkeleton` remains design-only.
- TypeScript targets use `CaTDD_designAndImplTemplate.ts`.
- CLI validation behavior remains unchanged.

## Next Step

Run `/SPEC_reviewArchDesign` to review the architecture-only policy and lifecycle-checker boundary before validator test design.
