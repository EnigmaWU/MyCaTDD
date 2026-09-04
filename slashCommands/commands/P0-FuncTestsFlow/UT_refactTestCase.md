# UT_refactTestCase

## Purpose

Refactor one already implemented CaTDD test case after it is GREEN, while preserving its comment-alive US/AC/TC design contract and observable behavior.

Use this command after `UT_reviewImplTestCase` passes and the selected TC needs readability, structure, naming, setup, cleanup, or assertion clarity improvements without changing coverage intent.

## CoT Pattern

**ReACT** — Reasoning + Acting. Refactor is only safe if each change is proven not to have changed behavior. This command must clean one TC, then check GREEN and coverage equivalence — that check is the loop's back-edge, and a discovered design gap is a hard stop rather than an invitation to expand the TC.

### ReACT Execution

Repeat for the one selected TC only.

1. **Thought** — Confirm the selected TC is already implemented and GREEN via `verification_result`. Locate it and its linked US/AC. Decide the smallest cleanup that serves `refactor_goal`.
2. **Action** — Refactor only that TC body and the local helpers it directly requires.
3. **Observation** — Rerun the focused TC and relevant regression scope. Check the TC is still GREEN, the US/AC/TC comments, category/priority/source/status markers are intact, the `SETUP`/`BEHAVIOR`/`VERIFY`/`CLEANUP` layout survives, and `VERIFY_KEYPOINT_xyz` assertions are preserved. Any loss returns to **Action** and is reverted. If missing behavior, missing assertions, wrong category, or new coverage is discovered, **stop** and report a design gap — do not absorb it.
4. **Stop** — Exit when the TC is GREEN before and after with no coverage change. Report before/after evidence and recommend `UT_reviewImplTestCase`.

### Worked Example

Cleaning up a GREEN TC:

```text
/UT_refactTestCase
selected_tc: TC-002 verifyAuthorize_byValidCard_expectApproved
test_file: services/payment/SysTests/UT_Gateway.ts
verification_result: GREEN (12 passing)
refactor_goal: remove duplicated setup
```

Expected result:

- **Thought**: TC-002 is GREEN. Its card fixture setup is duplicated from TC-001 → extract a local helper. Scope is TC-002's body only.
- **Action**: helper extracted, assertion names clarified.
- **Observation**: rerun is GREEN, but the extracted helper also absorbed a `VERIFY_KEYPOINT_authorizeApproved` check that TC-002 owned → key assertion lost from `VERIFY` → back to **Action** → reverted, helper limited to setup only.
- **Observation**: rerun GREEN, all markers and the 4-phase layout intact, coverage unchanged.
- **Stop**: before GREEN / after GREEN recorded. TC-001 was left untouched. Recommended `UT_reviewImplTestCase`.

## Inputs

- `selected_tc`: TC identifier and name.
- `test_file`: file containing the GREEN implemented TC.
- `source_files`: optional production files touched only when a no-behavior-change local cleanup is necessary and in scope.
- `verification_result`: latest focused test result proving the TC is GREEN before refactor.
- `refactor_goal`: optional cleanup focus, such as comments, setup, helper extraction, assertion naming, fixture structure, or duplicate removal.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Refactored implementation for exactly one selected GREEN TC.
- Preserved US/AC/TC comments, category labels, priority labels, source markers, and status markers.
- Preserved strict test-body layout: `SETUP` -> `BEHAVIOR` -> `VERIFY` -> `CLEANUP`.
- Preserved `VERIFY_KEYPOINT_xyz` assertions for key checks, or a compatibility mapping when the project lacks those macros/helpers.
- No behavior, API, contract, acceptance-criteria, or observable state change.
- Before/after verification evidence, or a clear reason verification could not be run.
- Recommendation: keep, run `UT_reviewImplTestCase`, select next TC, route back to `SPEC_designUnitTests`, or ask the developer.

## Conflict Guard

Do not batch unrelated TCs. Do not change product behavior while refactoring a TC unless the developer explicitly authorizes a separate implementation step.
Do not smuggle new behavior, new acceptance criteria, or new category coverage into refactor work; route those gaps to `SPEC_designUnitTests`, `UT_implTestCase`, or the developer.
Do not mark refactor complete when the selected TC is not GREEN before and after the cleanup.

ONE-MORE-THING: ask developer if something not sure
