# UT_reviewFuncTestsSkeleton

## Purpose

Review the P0 functional skeleton set before test-case implementation begins.

Use this command when Typical, Edge, Misuse, or Fault skeletons exist and the developer wants to know whether they are coherent enough to implement.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must inspect the skeleton set, judge coverage and category placement, and check that each finding is specific enough to act on. It is read-only — review never edits implementation code.

### ReACT Execution

Repeat until every finding names a category, a US/AC/TC id, and a fix.

1. **Thought** — Read the skeleton files. For each skeleton, check it declares a clear Class/Category and a full US/AC/TC trace, and decide whether each scenario sits in the right category.
2. **Action** — Write the coverage summary across Typical, Edge, Misuse, and Fault, listing conflicts, duplicated scenarios, missing AC/TC links, and unclear assumptions.
3. **Observation** — Check each finding is specific: "Edge is thin" is not actionable; "Edge has no maximum-amount AC" is. Vague findings return to **Thought**. Confirm no implementation code was modified.
4. **Stop** — Exit when findings are actionable. Recommend designing more skeleton, proceeding to `UT_tellMeNextImplTest`, or blocking for clarification.

### Worked Example

Gating the P0 set before implementation:

```text
/UT_reviewFuncTestsSkeleton
test_file_or_files: services/payment/SysTests/UT_Gateway.ts
feature_name: payment authorization
scope: authorize and capture
```

Expected result:

- **Thought**: Typical, Edge, Misuse, Fault all present. But `capture` appears only in Misuse (capture-before-authorize) — there is no Typical capture path. Also AC-07 has no linked TC.
- **Action**: coverage summary written with two findings.
- **Observation**: a third finding read "Fault coverage feels incomplete" — no category, no id, no fix → not actionable → back to **Thought** → restated as "Fault has no AC for a gateway response that arrives after the client timeout".
- **Observation**: no implementation code touched.
- **Stop**: three actionable findings. Because a declared scope behavior has no Typical coverage, recommended designing more skeleton before `UT_tellMeNextImplTest`.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected functional scope.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Coverage summary for Typical, Edge, Misuse, and Fault.
- Conflicts, duplicated scenarios, missing AC/TC links, and unclear assumptions.
- A recommended next action: design more skeleton, select next TC, or block for clarification.

## Conflict Guard

This command reviews functional skeleton design. It should not redefine category rules or implement tests.
