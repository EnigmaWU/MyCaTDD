# SPEC_implUnitTests

## Purpose

Implement selected CaTDD test cases for the active user story in test-first order, consuming `SPEC_designUnitTests` handoff slices through `P0-FuncTestsFlow` first and only then P1/P2 slices when they are ready.

## CoT Pattern

**ReACT** — Reasoning + Acting with observable checkpoints. This command must inspect the selected TC slices and skeleton review status, reason about category priority and implementation order, act by selecting (via `UT_tellMeNextImplTest`), implementing (via `UT_implTestCase`), and reviewing (via `UT_reviewImplTestCase`) each TC, observe the review result, then decide whether to implement the next TC or hand off to product-code implementation. The loop is priority locked: complete P0 Functional TC implementation before any P1/P2 promotion.

Use concise public reasoning summaries, not hidden chain-of-thought transcripts.

Example ReACT trace for a single-TC pass:

1. `Reason`: The handoff lists P0 Functional TCs; Typical TC-001 is TODO with no dependencies.
2. `Act`: Apply `UT_implTestCase` mechanics to implement TC-001 in RED stage.
3. `Observe`: Implementation compiles; test runner shows expected RED.
4. `Act`: Apply `UT_reviewImplTestCase` mechanics — implementation aligns with TC-001 skeleton.
5. `Observe`: Review passes; no drift found.
6. `Decide`: Recommend `SPEC_implProductCodes` for GREEN pass, or another `SPEC_implUnitTests` pass for the next TC.

## Inputs

- `selected_tc`: one or more selected TC entries.
- `target_test_files`: test files to update.
- `test_framework`: project test framework.
- `tc_slices`: test-case slices produced by `SPEC_designUnitTests`, including US/AC/TC, category, priority, dependency, and validation checkpoint.
- `category_priority`: default order is P0 Functional, then P1 Design, then P2 Quality.
- `review_status`: latest `UT_reviewFuncTestsSkeleton`, `UT_reviewDesignTestsSkeleton`, or `UT_reviewQualityTestsSkeleton` result when available.
- `source_files`: optional production files related to the selected TC; product changes still belong to later TDD stage or `SPEC_implProductCodes` unless explicitly requested.
- `test_result`: optional test output, failure summary, or review result from the previous implementation pass.

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
- Next recommended command: `SPEC_implProductCodes` (for GREEN pass), another `SPEC_implUnitTests` pass (for the next TC), `UT_reviewImplTestCase` (when drift needs attention), or `SPEC_designUnitTests` (when skeleton revision is needed).

## Flow Coupling

`SPEC_implUnitTests` consumes skeletons produced by the design flows. It does not redesign categories.

1. Use `UT_tellMeNextImplTest` selection rules when no explicit TC is selected.
2. Prefer the highest-priority ready P0 Functional TC from `Typical`, `Edge`, `Misuse`, or `Fault`.
3. Move to P1 `State`, `Capability`, or `Concurrency` TCs only when P0 TCs are implemented, blocked with evidence, or explicitly bypassed by the developer.
4. Move to P2 `Performance`, `Robust`, `Compatibility`, or `Configuration` TCs only when P0 exists and relevant P1 coverage is complete, blocked with evidence, or explicitly not applicable.
5. Use `UT_implTestCase` mechanics for each selected TC: locate the TC, preserve comments, implement exactly the requested test body, update status, and report verification.
6. Use `UT_reviewImplTestCase` mechanics after each implementation: compare implementation against the TC skeleton, check assertions verify the promised expectation, check setup/behavior/verify/cleanup clarity, and report alignment or drift.
7. Decide: if review passes, recommend `SPEC_implProductCodes` (for GREEN pass) or another `SPEC_implUnitTests` pass (for the next TC). If review finds drift, route to the recommended action (fix implementation, revise skeleton, or select next TC).

The SPEC command owns story-level ordering and handoff to product-code implementation. The `UT_*` command contract owns TC-level mechanics.

## Implementation Rules

- Implement exactly the selected TC or selected small batch. If no TC is selected, choose one TC by the flow priority order.
- Keep unrelated skeletons untouched except for status markers that are directly affected by the implemented TC.
- Preserve the design intent and trace comments. Do not collapse US/AC/TC comments into ordinary test names.
- Prefer RED first when behavior is missing. A meaningful failing test is a valid result and should route next to `SPEC_implProductCodes`.
- Do not implement product code inside this command unless the developer explicitly requests a combined TDD step.
- When a selected TC depends on missing P1/P2 design evidence, stop and route back to `SPEC_designUnitTests` or the appropriate design command instead of inventing behavior.
- After implementation, run `UT_reviewImplTestCase` before proceeding to the next TC or `SPEC_implProductCodes`. If review finds implementation-skeleton drift, do not proceed until the drift is resolved: fix the implementation, revise the skeleton, or ask the developer.

## Prompt Template

Ask the assistant to run an observable ReACT loop: reason about TC priority and skeleton review status, act by selecting (via `UT_tellMeNextImplTest`), implementing (via `UT_implTestCase`), and reviewing (via `UT_reviewImplTestCase`) one TC at a time, observe implementation quality and review alignment, then decide the next step. Preserve CaTDD skeleton metadata, respect P0-first ordering, and keep unrelated test skeletons untouched.

## Conflict Guard

Respect test-first order. Do not skip ready P0 Functional TCs in favor of P1/P2 work unless the developer explicitly selected that TC or the P0 TCs are complete, blocked, or not applicable. If tests cannot run or fail unexpectedly, report that before implementing product code.
Do not redesign skeletons during implementation. If the skeleton is untraceable, missing AC/TC links, or in the wrong category, route back to `SPEC_designUnitTests`.
Do not proceed to `SPEC_implProductCodes` or the next TC when `UT_reviewImplTestCase` finds implementation-skeleton drift that is not yet resolved.
Do not skip the review step between TC implementation and product-code handoff: every implemented TC should pass `UT_reviewImplTestCase` before the next lifecycle step.

ONE-MORE-THING: ask developer if something not sure
