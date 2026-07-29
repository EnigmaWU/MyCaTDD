# SPEC_refactUnitTests

## Purpose

Orchestrate no-behavior-change refactoring for implemented CaTDD unit tests in the active user story, using `UT_refactTestCase` as the TC-level mechanic.

Use this command after selected unit tests and product code are GREEN, and before final product-code review or commit, when the test suite needs cleanup without changing story behavior or coverage intent.

## CoT Pattern

**ReACT** — Reasoning + Acting with observable checkpoints. This command must inspect implemented TC status, verification evidence, and active-story scope, reason about safe refactor batches, act by applying `UT_refactTestCase` mechanics to one TC or a small independent batch, observe verification and review results, then decide whether to continue, route back to design/implementation, or hand off to final review.

Use concise public reasoning summaries, not hidden chain-of-thought transcripts.

Example ReACT trace for a single-TC refactor pass:

1. `Reason`: TC-003 is GREEN, reviewed, and has duplicated setup that does not affect behavior.
2. `Act`: Apply `UT_refactTestCase` mechanics to clean setup and assertion naming.
3. `Observe`: Focused TC remains GREEN and US/AC/TC comments are unchanged.
4. `Act`: Apply `UT_reviewImplTestCase` mechanics to confirm no skeleton drift.
5. `Observe`: Review passes; no behavior or coverage change found.
6. `Decide`: Recommend another `SPEC_refactUnitTests` pass for the next independent TC or `SPEC_reviewProductCodes` when cleanup is complete.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `target_test_files`: implemented unit test files to inspect or refactor.
- `selected_tc`: optional TC identifier and name; if omitted, choose the safest GREEN refactor candidate.
- `refactor_scope`: optional explicit list of TC slices, files, or cleanup goals.
- `verification_output`: latest focused or regression test output proving current behavior is GREEN.
- `review_status`: latest `UT_reviewImplTestCase` or `SPEC_reviewProductCodes` result when available.
- `source_files`: optional production files related to the selected TC; product edits remain no-behavior-change only.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [UT_refactTestCase.md](../../commands/P0-FuncTestsFlow/UT_refactTestCase.md)
- [UT_reviewImplTestCase.md](../../commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Story-scoped unit-test refactor summary, grouped by TC and file.
- Evidence that every refactored TC was GREEN before and after cleanup, or a clear blocker.
- Preserved CaTDD metadata, including US/AC/TC, `@[Category]`, `@[Priority]`, `@[SourceSPEC]`, `@[SourceUT]`, `@[Template]`, and `@[SUT]` markers.
- Evidence that each refactored TC still has strict `SETUP`/`BEHAVIOR`/`VERIFY`/`CLEANUP` phase markers and `VERIFY_KEYPOINT_xyz` key checks when available.
- `UT_reviewImplTestCase` review result for each refactored TC or an explicit reason review could not run.
- Refactor boundary decision: continue refactoring, route to `SPEC_designUnitTests`, route to `SPEC_implUnitTests`, route to `SPEC_implProductCodes`, or hand off to `SPEC_reviewProductCodes`.
- Next recommended command: another `SPEC_refactUnitTests` pass, `SPEC_reviewProductCodes`, `SPEC_designUnitTests`, `SPEC_implUnitTests`, `SPEC_implProductCodes`, or ask the developer.

## Flow Coupling

`SPEC_refactUnitTests` owns story-level ordering, batching, and safety gates. `UT_refactTestCase` owns TC-level cleanup mechanics.

1. Confirm the active story, target test files, and current verification evidence.
2. Select only GREEN implemented TCs for refactor. If no TC is selected, choose the smallest safe candidate.
3. Prefer one TC at a time. Batch only independent TCs that do not share fragile setup, production behavior, or unclear review state.
4. Apply `UT_refactTestCase` mechanics to each selected TC.
5. Run focused verification after each TC or safe batch.
6. Run `UT_reviewImplTestCase` after each refactored TC to detect skeleton drift.
7. Stop and route back to design or implementation if refactor reveals missing behavior, new coverage, wrong category, or acceptance ambiguity.
8. Recommend `SPEC_reviewProductCodes` only when refactored TCs remain GREEN and review passes.

## Implementation Rules

- Refactor only within the active story scope.
- Do not change test meaning, expected behavior, public API contracts, acceptance criteria, or observable product behavior.
- Do not redesign skeletons during refactor. If skeleton intent is wrong or incomplete, route to `SPEC_designUnitTests`.
- Do not implement missing product behavior during refactor. Route required behavior changes to `SPEC_implProductCodes` or `SPEC_implUnitTests` as appropriate.
- Keep unrelated test files and unrelated TC status markers untouched.
- Preserve strict phase layout and key verification naming in every refactored TC.

## Prompt Template

Ask the assistant to run an observable ReACT loop: inspect active-story implemented TCs and verification evidence, select the smallest GREEN refactor candidate, apply `UT_refactTestCase` mechanics, verify no behavior change, review with `UT_reviewImplTestCase`, and decide whether to continue refactoring or hand off to `SPEC_reviewProductCodes`. Preserve CaTDD skeleton metadata and stop on any behavior, category, or acceptance ambiguity.

## Conflict Guard

Do not use refactor as a shortcut for adding coverage, fixing RED tests, or implementing product behavior. If a TC is not GREEN before refactor, route to `SPEC_implUnitTests` or `SPEC_implProductCodes`.
Do not proceed to `SPEC_reviewProductCodes` when any refactored TC lacks post-refactor verification or has unresolved `UT_reviewImplTestCase` drift.
Do not batch refactors when shared setup, fixture state, or production behavior makes the blast radius unclear.

ONE-MORE-THING: ask developer if something not sure
