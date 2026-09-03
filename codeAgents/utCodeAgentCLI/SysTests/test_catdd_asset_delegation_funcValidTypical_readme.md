# Test Case: catdd_asset_delegation_funcValidTypical

## Purpose

Verify and plan the normal successful US-INVENTOR-01 delegation tests: current Edge prompt capture, portable aggregate-command invocation, resolved-asset provenance, and prompt-before-command event order.

## Status

PARTIAL / GREEN / DETAIL-DESIGN REVIEW PENDING. TC-DELEGATE-001 drives behavior, planning, slash-command resolution, prompt resolution, and run-plan translation, then captures the current Edge prompt through the fake runtime. TC-DELEGATE-002 through TC-DELEGATE-004 remain PLANNED.

## Covered

- SUT: `utCodeAgentCLI` CaTDD asset-delegation module interface.
- Category: P0 Functional / ValidFunc / Typical.
- Story: US-INVENTOR-01.
- Acceptance criteria: AC-01 through AC-04.
- Test cases: TC-DELEGATE-001 through TC-DELEGATE-004.
- Implemented scope: TC-DELEGATE-001 exercises behavior resolution, planning, session-backed command/prompt resolution, run-plan translation, and fake-runtime preparation.
- Source: `README_UserStory4INVENTOR-01.md` and `README_DetailDesign.md`.

## Manual

Run from the repository root:

```bash
node --test codeAgents/utCodeAgentCLI/tests/test_catdd_asset_delegation_funcValidTypical.ts
```

Expected result: TC-DELEGATE-001 passes; one test runs with zero failures.

## Review

- Previous result: FIX IMPLEMENTATION.
- IMPL-REV-01 corrected: `behaviorName: "designEdgeSkeleton"` now drives `resolveBehavior`, `planCatddRun`, `resolveSlashCommands`, and `resolveMethodPrompts`; only resolver outputs enter the run plan.
- IMPL-REV-02 corrected: erased type exports give the test and support files isolated TypeScript module scope with zero diagnostics.
- TC-level correction review: PASS; strict phases, two keypoints, cleanup, metadata, and one-TC scope remain intact.
- Story-level re-review: PASS; RED is valid and aligned with US-INVENTOR-01 AC-01.
- Product implementation: GREEN on correction attempt 1 with no test changes used to manufacture the result.
- Product review: UPDATE DESIGN because public path projection mixes a canonical asset path with a non-canonical workspace root.
- Detail-design correction: `InvocationAssetSession` owns asynchronous canonicalization and immutable canonical roots; review pending.
- Next command: `/SPEC_reviewDetailDesign`.

## Product Implementation

- `behaviorRegistry.ts` resolves `designEdgeSkeleton` to path-only command routing metadata.
- `planner.ts` creates the single invocation step.
- `invocationAssetSession.ts` performs invocation-local contained reads, current-content decoding, safe public-path projection, caching, and disposal.
- `slashCommandResolver.ts` and `methodPromptResolver.ts` read command/prompt assets without embedding their content.
- `agentRunPlanBuilder.ts` translates resolved assets into generic instruction/context inputs.

## Product Review

- Result: UPDATE DESIGN.
- PROD-REV-01: a symlinked workspace root is treated as external because `toPublicPath` compares `canonicalPath` with `path.resolve(context.workspaceRoot)` instead of a canonical workspace root.
- Reproduced result: an internal Edge prompt is emitted as `<methodPromptsRoot>/CaTDD_methodPrompt4Cat-Edge.md` instead of `methodPrompts/CaTDD_methodPrompt4Cat-Edge.md`.
- Design decision: `CliExecutionContext` roots may be logical symlink paths; `InvocationAssetSession` owns canonicalizing and retaining all roots.
- Test-first route: after detail review, retarget this same TC to a logical workspace alias, confirm RED, review the RED, then correct product code.
