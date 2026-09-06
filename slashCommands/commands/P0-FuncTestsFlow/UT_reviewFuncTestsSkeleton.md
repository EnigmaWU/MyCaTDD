# UT_reviewFuncTestsSkeleton

## Purpose

Review the P0 functional skeleton set before test-case implementation begins.

Use this command when Typical, Edge, Misuse, or Fault skeletons exist and the developer wants to know whether source-backed behavior is sufficiently discovered and specified for implementation in the declared scope. Apply **Source-First** review to audit the unbroken **TestEvidenceChain** (source -> rule -> TP -> oracle -> category -> US/AC/TC) answering WHY the test point is needed and HOW it will be verified, preventing blind spots.

## CoT Pattern

**ReACT** — Reasoning + Acting. Apply **Source-First** review: independently inspect behavior sources before examining the designer's ledger and skeleton set. Audit the **TestEvidenceChain** for discovery completeness, observable oracles, traceability, and category placement. It is read-only — report findings without editing source, skeletons, or implementation code.

### ReACT Execution

Use the Discovery Gate and bounded review budget in [CaTDD_methodPrompt-testPointDiscovery.md](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md). Every finding must identify a source/rule or TP ID, an owning/provisional category, and a concrete fix or question. Missing behavior may have **no existing US/AC/TC ID**; never reject such a finding or invent an existing ID to satisfy the report format.

1. **Thought** — Resolve and read the original behavior sources from `behavior_sources` or declared skeleton references. If unavailable, report BLOCKED, not a completeness verdict from tests alone. Independently inventory operations, outcomes, relevant partitions/combinations, public workflows, dependency phases, and production differences before consulting existing coverage.
2. **Action** — Read skeletons and `discovery_ledger`; reconcile source -> TP -> US/AC/TC and back. Verify each DESIGNED row actually specifies its scenario and observable oracle. Audit exclusions, missing-source `@[NoTestPoints]`, weak mocks, referrals, unanswered questions, and sampling limits as well as duplicates and category conflicts. A missing ledger is a design gap; report a proposed source-first reconciliation without editing files.
3. **Observation** — Ask which source-backed behavior could still fail while every proposed TC passes. Make findings actionable (source/R2: no Typical capture path; source/R4: no partial-write fault oracle). Unknown policy becomes a question, not a demanded fabricated test. Report independent evidence even when the designer's ledger looks complete; confirm no files were modified.
4. **Stop** — Apply the method's Report Consistency Audit, then return separate cardinality and discovery results plus `ready_for_implementation`. Derive counts/status from the ledger; preserve shared source rules and let unresolved in-scope questions take precedence over GAPS. Only when both gates pass for the stated scope and review is complete may the next action be `UT_tellMeNextImplTest`. Otherwise recommend more design for GAP or developer clarification for QUESTION/BLOCKED. Do not turn a bounded review stop into PASS or claim deployment completeness.

### Worked Example

Gating the P0 set before implementation:

```text
/UT_reviewFuncTestsSkeleton
test_file_or_files: services/payment/SysTests/UT_Gateway.ts
feature_name: payment authorization
scope: authorize and capture
behavior_sources: services/payment/README_UsageDesign.md
discovery_ledger: services/payment/SysTests/UT_Gateway.ts overview
```

Illustrative source: both authorize and capture have supported normal workflows, and the gateway contract defines a late-response failure outcome. If the late-response behavior is unspecified, the finding must instead ask for that decision.

Expected result:

- **Thought**: the independent source inventory includes a normal capture path. Typical, Edge, Misuse, Fault are all present, but `capture` appears only in Misuse (capture-before-authorize). The missing normal path has no existing TC ID. Also AC-07 has no linked TC.
- **Action**: coverage summary written with two findings.
- **Observation**: a third finding read "Fault coverage feels incomplete" — no category, no id, no fix → not actionable → back to **Thought** → restated as "Fault has no AC for a gateway response that arrives after the client timeout".
- **Observation**: no implementation code touched.
- **Stop**: three actionable findings; `discovery_status: GAPS`, `ready_for_implementation: no`. Even repairing AC-07's cardinality would leave the missing source behavior. Recommend designing more skeleton before `UT_tellMeNextImplTest`.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected functional scope.
- `behavior_sources`: original User Story, AC, UsageDesign, interface/protocol, or functional error sources. May be resolved from skeleton references; unresolved sources block approval.
- `discovery_ledger`: optional location of the designer's inventory/ledger; a missing ledger must be reported, not treated as empty coverage.
- `deployment_evidence`: optional relevant usage, incident, or supported-environment evidence for the independent challenge.

## Method References

- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [MAIN::CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
  - [SUB::Typical](../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md)
  - [SUB::Edge](../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md)
  - [SUB::Misuse](../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md)
  - [SUB::Fault](../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md)
- [CaTDD_methodPrompt-testPointDiscovery](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md)

## Output Contract

- Coverage summary for Typical, Edge, Misuse, and Fault.
- Source-first inventory/reconciliation evidence and `discovery_ledger` findings, auditing the **TestEvidenceChain** and capturing wholly missing behaviors with rule/TP IDs rather than requiring pre-existing TCs.
- Conflicts, duplicated scenarios, missing AC/TC links, and unclear assumptions.
- Separate cardinality result, `discovery_status`, `ready_for_implementation`, reviewed scope/sources, exclusions, referrals, and residual risk as defined by the method.
- A recommended next action: design more skeleton, select next TC, or block for clarification.

## Conflict Guard

This command reviews functional skeleton design. It should not redefine category rules or implement tests.
Do not approve readiness solely from four populated categories, valid link cardinality, TC counts, or passing tests. Review is read-only, and pending P1/P2 referrals remain visible follow-up rather than P0 implementation or release approval.
