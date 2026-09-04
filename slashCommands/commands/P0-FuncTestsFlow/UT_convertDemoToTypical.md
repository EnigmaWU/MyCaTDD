# UT_convertDemoToTypical

## Purpose

Convert existing demo tests into CaTDD `P0 Functional / Typical` skeletons.

Use this command when a developer has demo tests and wants to convert them into CaTDD instead of starting from a blank template.

## CoT Pattern

**ReACT** — Reasoning + Acting. Demo tests mix the happy path with incidental setup and stray edge assertions. This command must extract the core valid behavior, then check that nothing non-Typical was dragged along and that nothing was invented to fill a gap the demo left.

### ReACT Execution

Repeat until the Typical skeleton reflects only what the demo actually demonstrates.

1. **Thought** — Read `demo_test_file` as Stage-0 raw material. Identify the core happy-path behavior it demonstrates, separating it from incidental setup noise.
2. **Action** — Convert that behavior into a Typical skeleton with US/AC/TC comments traced back to the demo, naming TCs as `verifyBehavior_byCondition_expectResult`.
3. **Observation** — Check two things: behavior that is really Edge, Misuse, or Fault must be noted for another category rather than kept here → back to **Thought**; and any AC not actually demonstrated by the demo must become an open question rather than an invented requirement → back to **Action**.
4. **Stop** — Exit when every AC traces to demo behavior or is marked as a question. Report the category notes and the next command.

### Worked Example

Converting an existing demo test:

```text
/UT_convertDemoToTypical
demo_test_file: services/payment/demo/gateway_demo_test.ts
feature_name: payment authorization
target_test_file: services/payment/SysTests/UT_Gateway.ts
```

Expected result:

- **Thought**: the demo authorizes a card, prints the response, then also asserts behavior for a zero amount. The core happy path is the successful authorization.
- **Action**: US-01/AC-01 drafted as `verifyAuthorize_byValidCard_expectApproved`, traced to the demo's line range.
- **Observation**: the zero-amount assertion is invalid input → not Typical → back to **Thought** → recorded as a note for `UT_designMisuseSkeleton`, not kept.
- **Observation**: a draft AC claimed "authorization expires after 7 days" — the demo never shows this → invented → back to **Action** → replaced with an open question for the developer.
- **Stop**: one traced AC, one category note, one open question. The demo file itself is left as input material and is **not** relabeled `P3 Demo/Example`.

## Inputs

- `demo_test_file`: existing demo or example test file.
- `feature_name`: feature or behavior being extracted.
- `target_test_file`: new or existing CaTDD test file to update.
- `language` and `test_framework`: optional context for generated examples.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md)

## Output Contract

- A `P0 Functional / ValidFunc` and `Typical` design skeleton.
- US/AC/TC comments extracted from demo behavior.
- TC names following `verifyBehavior_byCondition_expectResult`.
- Clear notes for behavior that should move to Edge, Misuse, Fault, or another category.

## Conflict Guard

Demo tests are input material. Do not classify them as CaTDD `P3 Demo/Example` unless the goal is documentation-oriented demo coverage.
