# UT_reviewImplTestCase

## Purpose

Review one implemented CaTDD test case against its US/AC/TC skeleton.

Use this command after `UT_implTestCase` or when the developer suspects a test implementation drifted away from the design comments. It audits the terminal implementation link in the **TestEvidenceChain**: verifying that the executable test body (`SETUP` -> `BEHAVIOR` -> `VERIFY` -> `CLEANUP`) faithfully implements the observable oracle defined in `@[Expect]` and the acceptance criteria without implementation drift (confirming HOW the test is executed matches WHY it was designed).

Scope boundary: this command owns one implemented TC. Story-scoped review across all selected unit-test slices belongs to [SPEC_reviewImplUnitTests](../Px-SpecFlow/SPEC_reviewImplUnitTests.md), which applies this command's per-TC mechanics across the story and consumes the TC-level findings reported here.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command compares one implementation against its design comments and reports drift in the **TestEvidenceChain**. The loop's defining constraint is that it must **not** resolve a disagreement on its own — when implementation and skeleton conflict, neither is automatically truth, so the finding is reported and the developer decides.

### ReACT Execution

Repeat until every drift finding is specific and correctly attributed.

1. **Thought** — Read the implemented TC and its design comments. Compare implementation steps against what the TC promised, and read `test_result` when available.
2. **Action** — Record findings: missing assertions, excessive assertions, assertions that verify something other than the promised expectation, Anti-Test-Theater violations (mock-testing-mock or vacuous non-null checks without SUT domain verification), setup/cleanup gaps, unclear phase layout, and status-marker issues.
3. **Observation** — Check each finding names the TC, the specific line or phase, and what would resolve it. Then check attribution: if implementation and skeleton disagree, do **not** pick a winner — report the conflict and ask whether the design or the implementation should change. Silently rewriting design intent returns to **Action**.
4. **Stop** — Exit when findings are specific and attributed. Report one `review_verdict`: `PASS` with `next_command = UT_tellMeNextImplTest` when the implementation matches the design and no repair is needed, `REVISE` with `rework_route = UT_implTestCase` for an implementation fix or `rework_route = UT_designTypicalSkeleton` (or the matching category design command) for skeleton drift, or `ASK` when the conflict needs a developer decision.

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

- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [MAIN::CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
  - [SUB::Typical](../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md)
  - [SUB::Edge](../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md)
  - [SUB::Misuse](../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md)
  - [SUB::Fault](../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md)
- [CaTDD_methodPrompt-testPointDiscovery](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md)

## Skill Integration Policy

- Skill-first rule: if relevant testing or verification skills exist in the workspace, use them during this implementation review.
- Preferred skills and usage:
  - `test-driven-development` to verify the test asserts real behavior rather than mocked internals, and check that RED-phase evidence was based on assertion failure rather than execution error.
  - `design-agent-reward-functions` to audit whether `VERIFY` checks represent deterministic, observable exit criteria rather than subjective or superficial evaluations.
- Builtin fallback rule: if skills are unavailable, review using the builtin Anti-Test-Theater and phase layout checks in this command.
- Completion rule: this command must remain executable without skill loading.

## Output Contract

- Alignment check between implementation and US/AC/TC in the **TestEvidenceChain**.
- Anti-Test-Theater audit: confirms assertions verify real SUT state mutation or domain invariants, not trivial mock echoes.
- Missing assertions, excessive assertions, setup/cleanup gaps, and status issues.
- `review_verdict` and routing: `PASS` covers keep and select-next-TC; `REVISE` covers fix implementation (`rework_route = UT_implTestCase`) and revise skeleton (`rework_route` = the matching design command); `ASK` covers a conflict the developer must settle. `BLOCKED` applies when the design or the test result needed for the comparison is unavailable.

## Review Gate Contract

- Reviews: one implemented TC against its US/AC/TC skeleton and the `@[Expect]` oracle.
- Does not: decide which side is truth when design and implementation disagree, rewrite either artifact, or review sibling TCs in the same story.
- `review_verdict`: exactly one of `PASS`, `REVISE`, `BLOCKED`, or `ASK` per pass. `ASK` brings the human developer into the loop and is the same outcome `ONE-MORE-THING` produces.
- `severity`: optional `blocking | advisory` (default `blocking`); `advisory` marks findings that do not stop the gate.
- `rework_route`: required whenever the verdict is not `PASS`; it names the owning command for each finding.
- Read-only by default: report and route. Do not repair the reviewed artifact unless the developer explicitly approves a repair.
- Source-first: read the upstream source artifact before judging the artifact under review.
- Every finding cites a file, an ID, or a verification signal; an uncitable finding is dropped or chased with one more read.
- One verdict per pass, stable across passes; a repeat pass with identical findings and no changed evidence is the last pass.
- Rework is bounded by `max_rework_attempts` (default `3`) and the `Px-SpecFlow` Loop Guard stop conditions.
- Report `next_command = <COMMAND>` whenever the verdict is not `PASS`. The mapping from older verdict wording lives in the flow's Review Gate Contract table.

## Conflict Guard

If the implementation and skeleton disagree, do not choose automatically which one is truth. Report the conflict and ask whether method design or implementation should change.

ONE-MORE-THING: ask developer if something not sure
