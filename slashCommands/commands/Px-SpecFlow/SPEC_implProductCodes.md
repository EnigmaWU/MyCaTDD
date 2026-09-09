# SPEC_implProductCodes

## Purpose

Implement the minimum product code for the active story after selected unit tests provide valid RED evidence.

## CoT Pattern

**ReACT** — Reasoning + Acting, bounded. Confirm valid RED evidence, implement the minimum product-code change within the reviewed design, run focused external validation, evaluate the result, then correct or stop. Local correction is bounded by `max_correction_attempts`; design, test, requirement, environment, and ownership defects route to their canonical command instead of being patched inside product code.

### ReACT Execution

The loop body is the Bounded Implementation Loop below. Each pass:

1. **Thought** — Apply the Valid RED Gate. If RED is not valid, do not touch product code; route the defect to its owner. Then record the targeted AC/TC IDs, permitted production files, and the focused validation command.
2. **Action** — Change only the product behavior required by the selected tests and reviewed design. Never modify tests to manufacture GREEN.
3. **Observation** — Run the focused validation plus the narrowest relevant build, lint, type, sanitizer, or regression check. Evaluate to `GREEN`, `CORRECT`, `ROUTE`, or `ASK`.
4. **Stop** — `GREEN` exits. `CORRECT` returns to **Action** with the smallest evidence-grounded fix. Stop also on `max_correction_attempts`, repeated no-progress evidence, scope expansion, conflicting evidence, an ownership boundary, or unavailable validation — and a no-progress stop must report remaining failures, never claim success.

### Worked Example

Implementing against a reviewed RED test:

```text
/SPEC_implProductCodes
doing_user_story: .catdd/spec/doingUS/20260904-multi-gateway-UserStory.md
failing_tests: UT_Gateway-Typical.ts TC-001 (RED: module not found)
focused_validation: node --test services/payment/SysTests/UT_Gateway-Typical.ts
max_correction_attempts: 3
```

Expected result:

- **Thought**: RED gate — the test loads, fails on the missing `gatewayPort` module, and traces to AC-01/TC-001 and the reviewed detail design → valid RED. Scope recorded: `gatewayPort.ts` only.
- **Action**: minimal port implementation written.
- **Observation**: focused validation → TC-001 GREEN, TC-002 now fails → evaluate `CORRECT` (attempt 1), the failure is local and understood.
- **Action**: minimal correction to the port's error branch.
- **Observation**: focused validation → both GREEN, no regression → evaluate `GREEN`.
- **Stop**: 1 correction attempt used of 3. Reported `next_command = SPEC_reviewProductCodes`, followed by the post-product-code `SPEC_reviewImplUnitTests` gate.

A `ROUTE` variant: if TC-002 had failed because the design never defined the error branch, the evaluation would be `ROUTE` → stop, do not invent behavior, hand to `SPEC_updateDetailDesign`.

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

Before editing product code, verify that the selected test satisfies the **Semantic Falsification Gate**:

- loads or compiles and executes cleanly through setup and behavior in the current environment;
- fails **strictly on an expected semantic domain assertion** for the intended missing or incorrect product behavior;
- is not failing because of a test defect, syntax error, missing module/import, stale fixture, unavailable dependency, or unhandled setup exception (such failures must be classified as `⚠️ BROKEN_TEST` and repaired in the test harness before product code work);
- satisfies the **Anti-Test-Theater Rule**: assertions verify real SUT state mutations or domain invariants, never mock returns directly without SUT transformation;
- traces to the active story, acceptance criterion, test case, and reviewed detail design.

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
5. **Correct or stop**: make the smallest evidence-grounded local correction, then re-run the same validation. Stop on `GREEN`, `max_correction_attempts` ($B \le 3$), repeated no-progress evidence, scope expansion, conflicting evidence, an ownership boundary, or unavailable validation.
   - Upon budget exhaustion ($B=3$ attempts reached without `GREEN`):
     1) Restore the working directory to the clean baseline (revert unverified local mutations to prevent partial code contamination);
     2) Emit a structured failure diagnostic report (`failure_type`, `attempt_count: 3`, `assertion_failure_diff`, and `sut_snapshot`);
     3) Mark the affected TC as `⚠️ BLOCKED`;
     4) Escalate with `ASK` to the human developer under Layer 4 governance.

A no-progress stop must preserve the latest observed evidence, report remaining failures, and route or ask; it must not claim success.

## Output Contract

- Product code changes scoped to the active story and intended for commit when review passes.
- Traceability from changed product files to the targeted story, acceptance criteria, test cases, and reviewed detail design.
- Initial RED evidence, validation commands and results, correction-attempt count, evaluation state, and stop reason.
- Remaining failures and exact owner route when the result is `ROUTE` or `ASK`.
- Next recommended command: `SPEC_reviewProductCodes`; when product-code review passes, run `SPEC_reviewImplUnitTests` again before refactor, commit, or closure.

## Conflict Guard

Do not begin without valid RED evidence.
Do not broaden scope beyond the active story or reviewed design.
Do not modify tests to manufacture GREEN.
Route design gaps to `SPEC_updateDetailDesign`, test implementation defects to `SPEC_implUnitTests`, test-design or coverage defects to `SPEC_designUnitTests`, and requirement ambiguity to `SPEC_updateUserStory` or the developer.
Do not continue after no-progress evidence, an ownership boundary, or exhausted `max_correction_attempts`.
Do not route directly to commit after product code changes; product-code review and post-product-code unit-test implementation review must both pass first.

ONE-MORE-THING: ask developer if something not sure
