# SPEC_reviewImplUnitTests

## Purpose

Review implemented CaTDD unit tests for the active user story after `SPEC_implUnitTests`, and again after `SPEC_implProductCodes` plus `SPEC_reviewProductCodes` before refactor, commit, or closure.

Use this command when one or more TC bodies have been implemented and the developer needs a story-level gate that confirms the implemented tests preserve the **TestPointEvidenceChain**: verifying that implemented test bodies match their US/AC/TC skeletons, category priority, status markers, product-code review findings, and verification evidence.

## CoT Pattern

**ReACT** — Reasoning + Acting with observable checkpoints. This command must inspect implemented TC slices, reason about story-level completeness and per-TC alignment along the **TestPointEvidenceChain**, act by applying `UT_reviewImplTestCase` mechanics to each implemented TC that lacks current review evidence, observe drift, status, and verification gaps, then decide the next lifecycle command.

Use concise public reasoning summaries, not hidden chain-of-thought transcripts.

### ReACT Execution

Repeat until every implemented TC has current review evidence and the verdict is stable.

1. **Thought** — List the implemented TCs that lack current `UT_reviewImplTestCase` evidence, and note their claimed status markers.
2. **Action** — Run the Flow Coupling steps below over that set: apply `UT_reviewImplTestCase` mechanics per TC, apply `test-case-with-readme` or the Builtin README Gates per test file, and check story-level P0-first ordering.
3. **Observation** — Compare each claimed status marker against `verification_output`. Unexplained `GREEN`, `ISSUES`, or `BLOCKED` returns to **Thought**. Separate implementation drift (fix the test body) from skeleton drift (fix the design) — never report them as one finding.
4. **Stop** — Exit when every implemented TC is reviewed and each finding names its TC, its cause, and its route. Report the next lifecycle command.

### Worked Example

Two TCs were just implemented and product code does not exist yet:

```text
/SPEC_reviewImplUnitTests
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
target_test_files: services/payment/SysTests/UT_Gateway-Typical.ts
implementation_status: TC-001 RED, TC-002 RED
verification_output: 0 passing, 2 failing (module not found)
```

Expected result:

- **Thought**: TC-001 and TC-002 are both P0 Functional, both claim `RED`, neither has review evidence yet.
- **Action**: `UT_reviewImplTestCase` mechanics applied to both bodies; companion README gates run on the test file.
- **Observation**: TC-001 matches its AC with strict `SETUP`/`BEHAVIOR`/`VERIFY`/`CLEANUP` phases. TC-002 has a raw assertion outside `VERIFY`. `RED` is meaningful for both — it fails on the missing product module, which is expected before implementation, so the status is explained.
- **Observation**: TC-002's defect is in the test body, not the skeleton → classified as implementation drift, routed to `UT_implTestCase`, **not** back to `SPEC_designUnitTests`.
- **Stop**: reported — fix TC-002 first via `UT_implTestCase`; product-code work does not start until it is aligned.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `target_test_files`: implemented unit test files to review.
- `tc_slices`: selected or implemented test-case slices, including US/AC/TC, category, priority, dependency, target file, and validation checkpoint.
- `implementation_status`: current TC markers such as `TODO`, `RED`, `GREEN`, `ISSUES`, or `BLOCKED`.
- `review_status`: latest `UT_reviewImplTestCase` result for each implemented TC when available.
- `verification_output`: focused test, compile, lint, or manual verification output for the implemented tests.
- `product_review_status`: latest `SPEC_reviewProductCodes` result when this command runs after product-code implementation.
- `test_readme_files`: optional companion test README files, normally `<test_filename_without_extension>_readme.md` beside each target test file.
- `source_files`: optional production files related to the TCs; this command reviews tests and does not implement product behavior.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [P1-DesignTestsFlow](../../flows/P1-DesignTestsFlow.md)
- [P2-QualityTestsFlow](../../flows/P2-QualityTestsFlow.md)
- [UT_reviewImplTestCase](../../commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)

## Skill Integration Policy

- Skill-first rule: if the latest available `test-case-with-readme` skill exists in the workspace or installed agent skill registry, apply it during this review for each target test file.
- Preferred skill and usage:
  - `test-case-with-readme` to verify or create/update the companion `<test_filename_without_extension>_readme.md` file beside each implemented test file.
  - The companion README must include Purpose, Status, Covered, and Manual sections grounded in the implemented test body, US/AC/TC comments, verification output, and product-code review status when present.
- Builtin fallback rule: if `test-case-with-readme` is unavailable, do not block the whole review. Report the missing skill and run the builtin README gates below instead.
- Completion rule: this command must remain executable without skill loading. Use the latest skill when present; otherwise make the fallback evidence explicit.

### Builtin README Gates (when `test-case-with-readme` is unavailable)

- Companion-name gate: each target test file should have or be assigned an expected same-directory `<test_filename_without_extension>_readme.md` path.
- Section gate: the companion README should include Purpose, Status, Covered, and Manual sections.
- Grounding gate: Purpose and Covered must trace to the real test body and US/AC/TC comments; do not invent coverage.
- Status gate: Status must match current TC markers and verification output, including expected RED before product-code implementation or GREEN after product-code review.
- Manual gate: Manual steps must be executable or explicitly marked as not needed; generic filler is a review issue.

## Output Contract

- Story-scoped implementation review result for unit tests: pass, fix implementation, revise skeleton, continue implementing tests, implement product code, refactor tests, review product code, or ask the developer.
- Per-TC alignment summary against US/AC/TC design comments.
- Missing assertions, excessive assertions, setup/cleanup gaps, phase-layout issues, `VERIFY_KEYPOINT_xyz` issues, and status-marker inconsistencies.
- Evidence that P0-first priority was preserved, or an explicit developer override/blocker for skipped P0 TCs.
- Verification result summary, including whether RED is expected because product behavior is not implemented yet, or whether GREEN is traceable after product-code review.
- Product-code review correlation when this command runs after `SPEC_reviewProductCodes`.
- Test README evidence: `test-case-with-readme` applied, unavailable with builtin fallback, missing companion README, updated companion README, or ask the developer.
- Drift findings that distinguish implementation drift from skeleton/design drift.
- Next recommended command: `SPEC_implUnitTests`, `UT_implTestCase`, `UT_reviewImplTestCase`, `SPEC_designUnitTests`, `SPEC_implProductCodes`, `SPEC_refactUnitTests`, `SPEC_reviewProductCodes`, `SPEC_commitWorks`, or ask the developer.

## Flow Coupling

`SPEC_reviewImplUnitTests` owns story-level implementation review across selected unit-test slices. `UT_reviewImplTestCase` owns TC-level alignment mechanics.

1. Confirm the active story, implemented TC slices, and target test files.
2. Check that every implemented TC preserves US/AC/TC comments and required CaTDD metadata.
3. Check that each implemented TC has strict `SETUP`/`BEHAVIOR`/`VERIFY`/`CLEANUP` phase markers and key checks written with `VERIFY_KEYPOINT_xyz` macros when available.
4. Apply `UT_reviewImplTestCase` mechanics to each implemented TC that lacks current review evidence.
5. Apply the latest `test-case-with-readme` skill when available, or the builtin README gates when the skill is unavailable, to review companion test README evidence for each target test file.
6. Review story-level ordering: P0 Functional before P1 Design, P1 before P2 Quality, unless blocked or explicitly overridden.
7. Review status markers against verification output: meaningful RED is acceptable before product-code implementation; after product-code review, GREEN must be traceable to expected product behavior; unexplained GREEN, ISSUES, or BLOCKED states require evidence.
8. Decide the next lifecycle step:
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
- Do not modify test code while applying `test-case-with-readme`; companion README documentation is allowed only when grounded in available evidence.
- Do not treat a RED test as a failure when RED is the expected test-first result and assertions align with the skeleton.
- When run after `SPEC_reviewProductCodes`, confirm product-code review findings did not require test or skeleton changes before commit.
- Do not accept a TC as reviewed when strict phase markers or key verification macros are missing.
- Do not proceed to product-code work while implementation-skeleton drift is unresolved.

## Loop Guard

Rework routes from this review to `SPEC_implUnitTests`, `UT_implTestCase`, `UT_reviewImplTestCase`, or `SPEC_designUnitTests` must record structured findings. Each `impl -> review` rework cycle is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions: after repeated no-progress or exhausted attempts, route to `SPEC_abortUserStory` or `ASK`, never a third silent retry. Do not claim unit-test review progress without changed evidence between passes.

## Conflict Guard

If implementation and skeleton disagree, do not choose automatically which one is truth. Report the conflict and ask whether method design or implementation should change.
Do not skip story-level review evidence before `SPEC_implProductCodes`, `SPEC_refactUnitTests`, or `SPEC_reviewProductCodes` when implemented unit tests changed.
Do not skip the post-product-code `SPEC_reviewImplUnitTests` pass before `SPEC_commitWorks` when product code changed or product-code review findings touched test behavior.
Do not claim the `test-case-with-readme` skill was applied when it is unavailable; report the fallback gates used instead.
Do not claim review complete when implemented TCs are missing verification evidence, unless the missing evidence is explicitly reported as a blocker.

ONE-MORE-THING: ask developer if something not sure
