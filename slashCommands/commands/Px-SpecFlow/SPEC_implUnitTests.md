# SPEC_implUnitTests

## Purpose

Implement selected CaTDD test cases for the active user story in test-first order, consuming `SPEC_designUnitTests` handoff slices through `P0-FuncTestsFlow` first and only then P1/P2 slices when they are ready.

## CoT Pattern

**ReACT** — Reasoning + Acting with observable checkpoints. This command must inspect the selected TC slices and skeleton review status, reason about category priority and implementation order, act by selecting (via `UT_tellMeNextImplTest`), implementing (via `UT_implTestCase`), and reviewing (via `UT_reviewImplTestCase`) each TC, observe the review result, then decide whether to implement the next TC or hand off to product-code implementation. The loop is priority locked: complete P0 Functional TC implementation before any P1/P2 promotion.

Use concise public reasoning summaries, not hidden chain-of-thought transcripts.

### ReACT Execution

Repeat once per TC; the loop is priority locked to P0 Functional before any P1/P2 slice.

1. **Thought** — From the handoff slices and skeleton review status, pick the next TC via `UT_tellMeNextImplTest`. Respect declared dependencies and category priority.
2. **Action** — Implement that one TC via `UT_implTestCase` mechanics, then review it via `UT_reviewImplTestCase`.
3. **Observation** — Confirm the test compiles and produces *meaningful* RED — failing for missing product behavior, not for a test defect, stale fixture, or environment error. A defective RED, or review drift against the skeleton, returns to **Action**.
4. **Stop** — After each reviewed TC, decide: another pass for the next TC, or hand off to `SPEC_reviewImplUnitTests` before product-code work begins.

### Worked Example

Implementing the first TC from the design handoff:

```text
/SPEC_implUnitTests
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
tc_slices: TC-001 (Typical, P0, TODO)
```

Expected result:

- **Thought**: the handoff lists P0 Functional TCs; Typical TC-001 is `TODO` with no dependencies → selected.
- **Action**: `UT_implTestCase` mechanics applied; TC-001 written with strict `SETUP`/`BEHAVIOR`/`VERIFY`/`CLEANUP` phases.
- **Observation**: first run fails on a missing fixture path, not on missing product behavior → that is a test defect, not meaningful RED → back to **Action** → fixture path corrected.
- **Observation**: rerun now fails on the missing `gatewayPort` module → meaningful RED. `UT_reviewImplTestCase` finds no drift from the skeleton.
- **Stop**: reported — `next_command = SPEC_reviewImplUnitTests` before product-code work, or another pass for TC-002.

## Inputs

- `selected_tc`: one or more selected TC entries.
- `target_test_files`: test files to update.
- `test_framework`: project test framework.
- `tc_slices`: test-case slices produced by `SPEC_designUnitTests`, including US/AC/TC, category, priority, dependency, and validation checkpoint.
- `category_priority`: default order is P0 Functional, then P1 Design, then P2 Quality.
- `review_status`: latest `UT_reviewFuncTestsSkeleton`, `UT_reviewDesignTestsSkeleton`, or `UT_reviewQualityTestsSkeleton` result when available.
- `source_files`: optional production files related to the selected TC; product changes still belong to later TDD stage or `SPEC_implProductCodes` unless explicitly requested.
- `test_result`: optional test output, failure summary, or review result from the previous implementation pass.
- `max_rework_attempts`: optional maximum number of test-implementation rework attempts in the `SPEC_implUnitTests -> UT_reviewImplTestCase` cycle. Default: `3`.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [UT_tellMeNextImplTest.md](../../commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md)
- [UT_implTestCase.md](../../commands/P0-FuncTestsFlow/UT_implTestCase.md)
- [UT_reviewImplTestCase.md](../../commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Implemented test case code in committed test files, tied to selected TC comments.
- Preserved comment-alive CaTDD design sections, including US/AC/TC, `@[Category]`, `@[Priority]`, `@[SourceSPEC]`, `@[SourceUT]`, `@[Template]`, and `@[SUT]` markers.
- Test status update showing `TODO`, `RED`, `GREEN`, `ISSUES`, or `BLOCKED` state when known.
- Evidence that TC selection respected P0-first priority, or an explicit developer override for a P1/P2 TC.
- Verification command and result when available.
- TC review result: alignment check against the US/AC/TC skeleton, missing or excessive assertions, setup/cleanup gaps, and drift findings.
- Next recommended command: `SPEC_reviewImplUnitTests` (story-level test implementation review), another `SPEC_implUnitTests` pass (for the next TC), `UT_reviewImplTestCase` (when drift needs attention), or `SPEC_designUnitTests` (when skeleton revision is needed).
- STRICT implementation evidence for each implemented TC:
 	- Explicit `SETUP`/`BEHAVIOR`/`VERIFY`/`CLEANUP` phase markers in test body.
 	- Key checks written with `VERIFY_KEYPOINT_xyz` macros in `VERIFY` block.
 	- If project utility macros are unavailable, a local compatibility mapping is added and `VERIFY_KEYPOINT_xyz` naming is still preserved in test code.

## Flow Coupling

`SPEC_implUnitTests` consumes skeletons produced by the design flows. It does not redesign categories.

1. Use `UT_tellMeNextImplTest` selection rules when no explicit TC is selected.
2. Prefer the highest-priority ready P0 Functional TC from `Typical`, `Edge`, `Misuse`, or `Fault`.
3. Move to P1 `State`, `Capability`, or `Concurrency` TCs only when P0 TCs are implemented, blocked with evidence, or explicitly bypassed by the developer.
4. Move to P2 `Performance`, `Robust`, `Compatibility`, or `Configuration` TCs only when P0 exists and relevant P1 coverage is complete, blocked with evidence, or explicitly not applicable.
5. Use `UT_implTestCase` mechanics for each selected TC: locate the TC, preserve comments, implement exactly the requested test body, update status, and report verification.
6. Use `UT_reviewImplTestCase` mechanics after each implementation: compare implementation against the TC skeleton, check assertions verify the promised expectation, check setup/behavior/verify/cleanup clarity, and report alignment or drift.
7. Decide: if TC-level review passes, recommend `SPEC_reviewImplUnitTests` before `SPEC_implProductCodes`, or another `SPEC_implUnitTests` pass for the next TC. If review finds drift, route to the recommended action (fix implementation, revise skeleton, or select next TC).

The SPEC command owns story-level ordering and handoff to product-code implementation. The `UT_*` command contract owns TC-level mechanics.

## Implementation Rules

- Implement exactly the selected TC or selected small batch. If no TC is selected, choose one TC by the flow priority order.
- Keep unrelated skeletons untouched except for status markers that are directly affected by the implemented TC.
- Preserve the design intent and trace comments. Do not collapse US/AC/TC comments into ordinary test names.
- Prefer RED first when behavior is missing. A meaningful failing test is a valid result and should route next to `SPEC_implProductCodes`.
- Do not implement product code inside this command unless the developer explicitly requests a combined TDD step.
- When a selected TC depends on missing P1/P2 design evidence, stop and route back to `SPEC_designUnitTests` or the appropriate design command instead of inventing behavior.
- After implementation, run `UT_reviewImplTestCase` before proceeding to the next TC or `SPEC_reviewImplUnitTests`. If review finds implementation-skeleton drift, do not proceed until the drift is resolved: fix the implementation, revise the skeleton, or ask the developer.
- Enforce strict phase layout for each selected TC: keep a visible 4-phase structure (`SETUP` -> `BEHAVIOR` -> `VERIFY` -> `CLEANUP`) and keep key assertions inside `VERIFY`.
- Prefer `VERIFY_KEYPOINT_xyz` macros for key assertions; if macros are missing in this repository, add a compatibility mapping and keep `VERIFY_KEYPOINT_xyz` calls in the test body.

## Loop Guard

Test-implementation rework is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions: stop on passed `UT_reviewImplTestCase`, exhausted attempts, or repeated no-progress evidence; on stop, preserve the latest evidence and route to `SPEC_designUnitTests`, `SPEC_abortUserStory`, or `ASK`, never a third silent retry.

## Conflict Guard

Respect test-first order. Do not skip ready P0 Functional TCs in favor of P1/P2 work unless the developer explicitly selected that TC or the P0 TCs are complete, blocked, or not applicable. If tests cannot run or fail unexpectedly, report that before implementing product code.
Do not redesign skeletons during implementation. If the skeleton is untraceable, missing AC/TC links, or in the wrong category, route back to `SPEC_designUnitTests`.
Do not proceed to `SPEC_reviewImplUnitTests`, `SPEC_implProductCodes`, or the next TC when `UT_reviewImplTestCase` finds implementation-skeleton drift that is not yet resolved.
Do not skip the review step between TC implementation and product-code handoff: every implemented TC should pass `UT_reviewImplTestCase` before the next lifecycle step.
Do not claim implementation complete when strict phase markers or `VERIFY_KEYPOINT_xyz` usage is missing for implemented TCs.

ONE-MORE-THING: ask developer if something not sure
