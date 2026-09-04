# UT_reviewImplTestCase

## Purpose

Review one implemented CaTDD test case against its US/AC/TC skeleton.

Use this command after `UT_implTestCase` or when the developer suspects a test implementation drifted away from the design comments.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command compares one implementation against its design comments and reports drift. The loop's defining constraint is that it must **not** resolve a disagreement on its own — when implementation and skeleton conflict, neither is automatically truth, so the finding is reported and the developer decides.

### ReACT Execution

Repeat until every drift finding is specific and correctly attributed.

1. **Thought** — Read the implemented TC and its design comments. Compare implementation steps against what the TC promised, and read `test_result` when available.
2. **Action** — Record findings: missing assertions, excessive assertions, assertions that verify something other than the promised expectation, setup/cleanup gaps, unclear phase layout, and status-marker issues.
3. **Observation** — Check each finding names the TC, the specific line or phase, and what would resolve it. Then check attribution: if implementation and skeleton disagree, do **not** pick a winner — report the conflict and ask whether the design or the implementation should change. Silently rewriting design intent returns to **Action**.
4. **Stop** — Exit when findings are specific and attributed. Recommend keep, fix implementation, revise skeleton, or select the next TC.

### Worked Example

Checking an implemented TC for drift:

```text
/UT_reviewImplTestCase
selected_tc: TC-002 verifyAuthorize_byValidCard_expectApproved
test_file: services/payment/SysTests/UT_Gateway.ts
test_result: 1 passing
```

Expected result:

- **Thought**: AC-02 promises the authorization id is echoed back, but the implementation only asserts the approval status.
- **Action**: two findings recorded — a missing assertion for the echoed id, and a `CLEANUP` phase that never releases the fake gateway connection.
- **Observation**: a third finding said "this test is weak" → no line, no phase, no fix → back to **Action** → dropped as unusable.
- **Observation**: the missing-id finding is a genuine conflict — the implementation may be incomplete, *or* AC-02 may over-promise. Not resolved here; reported as a conflict for the developer to settle.
- **Stop**: reported — fix `CLEANUP` in the implementation, and ask whether AC-02's echoed-id promise should be implemented or dropped from the skeleton.

## Inputs

- `selected_tc`: TC identifier and name.
- `test_file`: file containing the implemented TC.
- `test_result`: optional test output or failure summary.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Alignment check between implementation and US/AC/TC.
- Missing assertions, excessive assertions, setup/cleanup gaps, and status issues.
- Recommendation: keep, fix implementation, revise skeleton, or select next TC.

## Conflict Guard

If the implementation and skeleton disagree, do not choose automatically which one is truth. Report the conflict and ask whether method design or implementation should change.
