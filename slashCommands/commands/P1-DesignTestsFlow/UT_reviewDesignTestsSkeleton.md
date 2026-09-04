# UT_reviewDesignTestsSkeleton

## Purpose

Review the P1 design skeleton set before quality coverage or implementation continues.

Use this command when State, Capability, or Concurrency skeletons exist and the developer wants to know whether design coverage is coherent enough to proceed.

## CoT Pattern

**ReACT** — Reasoning + Acting. This review's distinguishing gate is design-source backing: a P1 skeleton that looks plausible but traces to no confirmed design source must not be approved. The loop keeps checking findings until each is specific and each skeleton's source is verified. It is read-only.

### ReACT Execution

Repeat until every skeleton's design source is verified and every finding is actionable.

1. **Thought** — Read the P1 skeletons. For each, check it declares a clear Class/Category with a full US/AC/TC trace, **and** that it links to a confirmed design source. Judge whether each scenario sits in State, Capability, or Concurrency correctly.
2. **Action** — Write the coverage summary across the three categories, listing conflicts, duplicated scenarios, missing AC/TC links, unbacked skeletons, and unclear assumptions.
3. **Observation** — Check each finding names a category, an id, and a fix; vague findings return to **Thought**. A skeleton with no confirmed design source cannot be approved regardless of how reasonable it reads. Confirm no implementation code was modified.
4. **Stop** — Exit when findings are actionable. Recommend more P1 design, moving to P2 QualityTestsFlow, `UT_tellMeNextImplTest`, or blocking for clarification.

### Worked Example

Gating the P1 set:

```text
/UT_reviewDesignTestsSkeleton
test_file_or_files: services/payment/SysTests/UT_Gateway.ts
feature_name: payment gateway
```

Expected result:

- **Thought**: State traces to the `State Design` chapter → backed. Capability traces to `README_DetailDesign.md` → backed. Concurrency cites no source at all.
- **Action**: coverage summary written with two findings — the unbacked Concurrency skeleton, and a Capability AC duplicated from the Misuse skeleton.
- **Observation**: a third finding read "State could be richer" → no id, no fix → back to **Thought** → restated as "State has no AC for recovery after process restart".
- **Observation**: the Concurrency skeleton reads plausibly, but plausibility is not a design source → not approved.
- **Stop**: three actionable findings; no implementation code touched. Blocked for clarification until the concurrency design source is confirmed.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected design scope.
- `design_sources`: confirmed P1 design sources used by the skeletons under review.
- `functional_skeletons`: related P0 Typical, Edge, Misuse, or Fault skeletons.

## Preconditions

- P1 MUST have DESIGN: every State, Capability, or Concurrency skeleton under review must trace to a confirmed design source.
- WARNING: If a P1 skeleton has no confirmed design source, ask the developer where the design lives or stop before approving the P1 review.

## Method References

- [../../flows/P1-DesignTestsFlow.md](../../flows/P1-DesignTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md)

## Output Contract

- Coverage summary for State, Capability, and Concurrency.
- Conflicts, duplicated scenarios, missing AC/TC links, and unclear assumptions.
- A recommended next action: design more P1 skeleton, move to P2 QualityTestsFlow, select the next TC, or block for clarification.

## Conflict Guard

This command reviews design skeletons only. It should not redefine category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
