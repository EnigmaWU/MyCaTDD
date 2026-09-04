# UT_reviewQualityTestsSkeleton

## Purpose

Review the P2 quality skeleton set before implementation, release-risk review, or TC-by-TC execution continues.

Use this command when Performance, Robust, Compatibility, or Configuration skeletons exist and the developer wants to know whether quality coverage is coherent enough to proceed.

## CoT Pattern

**ReACT** — Reasoning + Acting. The distinguishing gate for P2 review is measurability: a quality AC that cannot be measured cannot be implemented, no matter how sensible it sounds. The loop keeps checking until every finding is specific and every quality target is measurable. It is read-only.

### ReACT Execution

Repeat until every quality target is measurable and every finding is actionable.

1. **Thought** — Read the P2 skeletons. For each, check it declares a clear Class/Category with a full US/AC/TC trace, and judge whether its scenarios sit in Performance, Robust, Compatibility, or Configuration correctly.
2. **Action** — Write the coverage summary across the four categories, listing conflicts, duplicated scenarios, missing AC/TC links, unmeasurable quality targets, and unclear assumptions.
3. **Observation** — Check each finding names a category, an id, and a fix; vague findings return to **Thought**. Any AC without a metric, threshold, matrix entry, or defined precedence is unmeasurable and must be reported as such. Confirm no implementation code was modified.
4. **Stop** — Exit when findings are actionable. Recommend more P2 design, `UT_tellMeNextImplTest`, proceeding to implementation, or blocking for clarification.

### Worked Example

Gating the P2 set:

```text
/UT_reviewQualityTestsSkeleton
test_file_or_files: services/payment/SysTests/UT_Gateway.ts
feature_name: payment gateway
```

Expected result:

- **Thought**: Performance AC-21 carries a metric and threshold → measurable. Robust AC-23 says the service "degrades gracefully" with no observable signal → unmeasurable. Compatibility and Configuration trace cleanly.
- **Action**: coverage summary written with two findings — the unmeasurable AC-23, and a Robust scenario duplicating P0 Fault AC-09.
- **Observation**: a third finding read "Configuration coverage is thin" → no id, no fix → back to **Thought** → restated as "Configuration has no AC for the CLI-flag versus env-var precedence gap".
- **Observation**: no implementation code touched.
- **Stop**: three actionable findings. Because AC-23 is unmeasurable, recommended more P2 design before `UT_tellMeNextImplTest`.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected quality scope.
- `functional_skeletons`: related P0 skeletons.
- `design_skeletons`: optional related P1 skeletons.

## Method References

- [../../flows/P2-QualityTestsFlow.md](../../flows/P2-QualityTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md)

## Output Contract

- Coverage summary for Performance, Robust, Compatibility, and Configuration.
- Conflicts, duplicated scenarios, missing AC/TC links, unmeasurable quality targets, and unclear assumptions.
- A recommended next action: design more P2 skeleton, select the next TC, proceed to implementation, or block for clarification.

## Conflict Guard

This command reviews quality skeletons only. It should not redefine category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
