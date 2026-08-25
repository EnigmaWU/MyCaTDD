# SPEC_implProductCodes

## Purpose

Implement the minimum product code for the active story after selected unit tests provide valid RED evidence.

## CoT Pattern

**Bounded Correction/TDD** — Confirm valid RED evidence, implement the minimum product-code change within the reviewed design, run focused external validation, evaluate the result, then correct or stop. Local correction is bounded by `max_correction_attempts`; design, test, requirement, environment, and ownership defects route to their canonical command instead of being patched inside product code.

## Inputs

- `doing_user_story`: active story under `.catdd/spec/doingUS/`.
- `failing_tests`: selected tests and current RED output.
- `acceptance_and_test_scope`: targeted acceptance-criterion and test-case IDs.
- `production_files`: product code files to create or update.
- `detail_design`: reviewed design and acceptance criteria.
- `focused_validation`: narrowest executable test command that can falsify the implementation.
- `max_correction_attempts`: optional maximum number of local product-code correction attempts. Default: `3`.

## Method References

- [Px-SpecFlow](../../flows/Px-SpecFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)

## Valid RED Gate

Before editing product code, verify that the selected test:

- loads or compiles and executes in the current environment;
- fails for the intended missing or incorrect product behavior;
- traces to the active story, acceptance criterion, test case, and reviewed detail design;
- is not failing because of a test defect, stale fixture, unavailable dependency, or unrelated environment error.

If valid RED evidence is absent, do not mutate product code. Route a test implementation defect to `SPEC_implUnitTests`, a test-design or coverage defect to `SPEC_designUnitTests`, a requirement ambiguity to `SPEC_updateUserStory` or `ASK`, and a design gap to `SPEC_updateDetailDesign`.

## Bounded Implementation Loop

1. **Scope**: record the targeted AC/TC IDs, permitted production files, initial RED evidence, and focused validation command.
2. **Implement minimally**: change only the product behavior required by the selected tests and reviewed design. Do not modify tests to manufacture GREEN.
3. **Observe**: run focused validation and the narrowest relevant build, lint, type, sanitizer, or regression check when applicable.
4. **Evaluate**:
   - `GREEN`: targeted behavior passes and no relevant regression is observed.
   - `CORRECT`: the failure is local, understood, and another minimal correction remains inside the reviewed design.
   - `ROUTE`: evidence identifies a requirement, design, test, environment, or ownership defect.
   - `ASK`: evidence conflicts or the correct owner is unclear.
5. **Correct or stop**: make the smallest evidence-grounded local correction, then re-run the same validation. Stop on `GREEN`, `max_correction_attempts`, repeated no-progress evidence, scope expansion, conflicting evidence, an ownership boundary, or unavailable validation.

A no-progress stop must preserve the latest observed evidence, report remaining failures, and route or ask; it must not claim success.

## Output Contract

- Product code changes scoped to the active story and intended for commit when review passes.
- Traceability from changed product files to the targeted story, acceptance criteria, test cases, and reviewed detail design.
- Initial RED evidence, validation commands and results, correction-attempt count, evaluation state, and stop reason.
- Remaining failures and exact owner route when the result is `ROUTE` or `ASK`.
- Next recommended command: `SPEC_reviewProductCodes`; when product-code review passes, run `SPEC_reviewImplUnitTests` again before refactor, commit, or closure.

## Prompt Template

Ask the assistant to confirm valid RED evidence, state the AC/TC and file boundary, write the minimum product code required by the reviewed design, run focused external validation, and correct locally only while evidence supports a bounded in-scope change. On GREEN, route to `SPEC_reviewProductCodes` and the post-product-code `SPEC_reviewImplUnitTests` gate; otherwise report the stop evidence and route to the canonical owner.

## Conflict Guard

Do not begin without valid RED evidence.
Do not broaden scope beyond the active story or reviewed design.
Do not modify tests to manufacture GREEN.
Route design gaps to `SPEC_updateDetailDesign`, test implementation defects to `SPEC_implUnitTests`, test-design or coverage defects to `SPEC_designUnitTests`, and requirement ambiguity to `SPEC_updateUserStory` or the developer.
Do not continue after no-progress evidence, an ownership boundary, or exhausted `max_correction_attempts`.
Do not route directly to commit after product code changes; product-code review and post-product-code unit-test implementation review must both pass first.

ONE-MORE-THING: ask developer if something not sure
