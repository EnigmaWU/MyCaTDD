# UT_refactTestCase

## Purpose

Refactor one already implemented CaTDD test case after it is GREEN, while preserving its comment-alive US/AC/TC design contract and observable behavior.

Use this command after `UT_reviewImplTestCase` passes and the selected TC needs readability, structure, naming, setup, cleanup, or assertion clarity improvements without changing coverage intent.

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

## Prompt Template

Ask the assistant to:

1. Confirm the selected TC is already implemented and GREEN.
2. Locate the selected TC and its linked US/AC.
3. Refactor only the selected TC body and directly required local helpers.
4. Preserve comment-alive traceability, status markers, and strict 4-phase implementation layout.
5. Improve clarity without changing the TC purpose, expected behavior, coverage intent, or acceptance meaning.
6. Stop and report a design gap if missing behavior, missing assertions, wrong category, or new coverage is discovered.
7. Rerun the focused TC and relevant regression scope when available.
8. Recommend `UT_reviewImplTestCase` after the refactor.

## Conflict Guard

Do not batch unrelated TCs. Do not change product behavior while refactoring a TC unless the developer explicitly authorizes a separate implementation step.
Do not smuggle new behavior, new acceptance criteria, or new category coverage into refactor work; route those gaps to `SPEC_designUnitTests`, `UT_implTestCase`, or the developer.
Do not mark refactor complete when the selected TC is not GREEN before and after the cleanup.

ONE-MORE-THING: ask developer if something not sure
