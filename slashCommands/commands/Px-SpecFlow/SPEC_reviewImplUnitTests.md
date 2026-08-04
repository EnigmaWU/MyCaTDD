# SPEC_reviewImplUnitTests

## Purpose

Review implemented CaTDD unit tests for the active user story after `SPEC_implUnitTests`, and again after `SPEC_implProductCodes` plus `SPEC_reviewProductCodes` before refactor, commit, or closure.

Use this command when one or more TC bodies have been implemented and the developer needs a story-level gate that confirms the implemented tests still match their US/AC/TC skeletons, category priority, status markers, product-code review findings, and verification evidence.

## CoT Pattern

**ReACT** — Reasoning + Acting with observable checkpoints. This command must inspect implemented TC slices, reason about story-level completeness and per-TC alignment, act by applying `UT_reviewImplTestCase` mechanics to each implemented TC that lacks current review evidence, observe drift, status, and verification gaps, then decide the next lifecycle command.

Use concise public reasoning summaries, not hidden chain-of-thought transcripts.

Example ReACT trace for a story-level unit-test implementation review:

1. `Reason`: TC-001 and TC-002 were implemented by `SPEC_implUnitTests`; both are P0 Functional and claim RED because product code is still missing.
2. `Act`: Apply `UT_reviewImplTestCase` mechanics to each implemented TC body.
3. `Observe`: TC-001 matches its AC and has strict phases; TC-002 has a raw assertion outside `VERIFY`.
4. `Decide`: Route TC-002 back to `SPEC_implUnitTests` or `UT_implTestCase` before product-code work starts.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `target_test_files`: implemented unit test files to review.
- `tc_slices`: selected or implemented test-case slices, including US/AC/TC, category, priority, dependency, target file, and validation checkpoint.
- `implementation_status`: current TC markers such as `TODO`, `RED`, `GREEN`, `ISSUES`, or `BLOCKED`.
- `review_status`: latest `UT_reviewImplTestCase` result for each implemented TC when available.
- `verification_output`: focused test, compile, lint, or manual verification output for the implemented tests.
- `product_review_status`: latest `SPEC_reviewProductCodes` result when this command runs after product-code implementation.
- `source_files`: optional production files related to the TCs; this command reviews tests and does not implement product behavior.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [P1-DesignTestsFlow](../../flows/P1-DesignTestsFlow.md)
- [P2-QualityTestsFlow](../../flows/P2-QualityTestsFlow.md)
- [UT_reviewImplTestCase](../../commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Story-scoped implementation review result for unit tests: pass, fix implementation, revise skeleton, continue implementing tests, implement product code, refactor tests, review product code, or ask the developer.
- Per-TC alignment summary against US/AC/TC design comments.
- Missing assertions, excessive assertions, setup/cleanup gaps, phase-layout issues, `VERIFY_KEYPOINT_xyz` issues, and status-marker inconsistencies.
- Evidence that P0-first priority was preserved, or an explicit developer override/blocker for skipped P0 TCs.
- Verification result summary, including whether RED is expected because product behavior is not implemented yet, or whether GREEN is traceable after product-code review.
- Product-code review correlation when this command runs after `SPEC_reviewProductCodes`.
- Drift findings that distinguish implementation drift from skeleton/design drift.
- Next recommended command: `SPEC_implUnitTests`, `UT_implTestCase`, `UT_reviewImplTestCase`, `SPEC_designUnitTests`, `SPEC_implProductCodes`, `SPEC_refactUnitTests`, `SPEC_reviewProductCodes`, `SPEC_commitWorks`, or ask the developer.

## Flow Coupling

`SPEC_reviewImplUnitTests` owns story-level implementation review across selected unit-test slices. `UT_reviewImplTestCase` owns TC-level alignment mechanics.

1. Confirm the active story, implemented TC slices, and target test files.
2. Check that every implemented TC preserves US/AC/TC comments and required CaTDD metadata.
3. Check that each implemented TC has strict `SETUP`/`BEHAVIOR`/`VERIFY`/`CLEANUP` phase markers and key checks written with `VERIFY_KEYPOINT_xyz` macros when available.
4. Apply `UT_reviewImplTestCase` mechanics to each implemented TC that lacks current review evidence.
5. Review story-level ordering: P0 Functional before P1 Design, P1 before P2 Quality, unless blocked or explicitly overridden.
6. Review status markers against verification output: meaningful RED is acceptable before product-code implementation; after product-code review, GREEN must be traceable to expected product behavior; unexplained GREEN, ISSUES, or BLOCKED states require evidence.
7. Decide the next lifecycle step:
   - If implemented tests are aligned and product behavior is missing, route to `SPEC_implProductCodes`.
   - If implemented tests are aligned and product code has not been reviewed, route to `SPEC_reviewProductCodes`.
   - If implemented tests are aligned and GREEN but need cleanup, route to `SPEC_refactUnitTests`.
   - If implemented tests, product code, and product-code review are aligned and no cleanup is needed, route to `SPEC_commitWorks`.
   - If implementation drift exists, route to `SPEC_implUnitTests`, `UT_implTestCase`, or `UT_reviewImplTestCase`.
   - If skeleton/design intent is wrong or incomplete, route to `SPEC_designUnitTests` or ask the developer.

## Review Rules

- Review only active-story test implementation scope.
- Do not implement product code or refactor tests inside this command.
- Do not redesign skeletons silently. Report skeleton-vs-implementation conflicts and route deliberately.
- Do not treat a RED test as a failure when RED is the expected test-first result and assertions align with the skeleton.
- When run after `SPEC_reviewProductCodes`, confirm product-code review findings did not require test or skeleton changes before commit.
- Do not accept a TC as reviewed when strict phase markers or key verification macros are missing.
- Do not proceed to product-code work while implementation-skeleton drift is unresolved.

## Prompt Template

Ask the assistant to run an observable ReACT loop: inspect active-story implemented TC slices, verify P0-first ordering and CaTDD metadata, apply `UT_reviewImplTestCase` mechanics per TC, compare implementation against US/AC/TC comments, check strict phase layout and `VERIFY_KEYPOINT_xyz` usage, interpret verification output and any `SPEC_reviewProductCodes` result, then recommend the next lifecycle command.

## Conflict Guard

If implementation and skeleton disagree, do not choose automatically which one is truth. Report the conflict and ask whether method design or implementation should change.
Do not skip story-level review evidence before `SPEC_implProductCodes`, `SPEC_refactUnitTests`, or `SPEC_reviewProductCodes` when implemented unit tests changed.
Do not skip the post-product-code `SPEC_reviewImplUnitTests` pass before `SPEC_commitWorks` when product code changed or product-code review findings touched test behavior.
Do not claim review complete when implemented TCs are missing verification evidence, unless the missing evidence is explicitly reported as a blocker.

ONE-MORE-THING: ask developer if something not sure
