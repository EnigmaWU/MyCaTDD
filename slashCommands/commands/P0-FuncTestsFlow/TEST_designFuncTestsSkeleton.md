# TEST_designFuncTestsSkeleton

## Purpose

Design the P0 Functional CaTDD skeleton set for an explicit scope: Typical, Edge, Misuse, and Fault, backed by a reconciled behavior inventory and test-point ledger.

Use this command when a developer wants the full functional skeleton set from one interface, protocol, existing draft, or behavior contract before implementation begins.

## CoT Pattern

**ReACT** — Reasoning + Acting. Discover behavior from sources before drafting one category at a time. Check both US/AC/TP/TC cardinality and the method's Discovery Gate: linked items alone cannot expose a behavior that was never written. Report evidence and decisions, not private reasoning traces.

### ReACT Execution

Before the category loop:

1. Read the main method and [test-point discovery method](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md). Declare SUT, scope, source references, and test level. Resolve relevant behavior documents from the interface and optional `behavior_sources`; ask if expected behavior is missing.
2. Build the source-first Behavior Inventory and perform the P0 Discovery Sweep before consulting existing skeletons for coverage. Use available `deployment_evidence` as discovery input, not as authority for expected results. No incident history is required.
3. Preserve one `discovery_ledger` in FreelyDrafts or test-file overview/design comments. Record rule/TP IDs, concrete scenarios, oracles, category/test level, and dispositions. Missing intent remains QUESTION, not a fabricated AC. Preserve existing IDs and unrelated skeletons.

Then repeat per category in order — Typical, then Edge, Misuse, Fault.

1. **Thought** — Read the matching category prompt and source-backed ledger candidates. Decide ownership by verification lens, not risk priority or implementation convenience.
2. **Action** — Draft or update that category skeleton with `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, `@[TP]`, `@[TC]`. Link each designed TP to actual file/US/AC/TC IDs and observable expectations.
3. **Observation** — Check the [US/AC/TP/TC cardinality](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md#usactptc-contract) for the declared scope: every US has at least one AC, every AC has at least one TP, every TP maps to exactly one TC, and every TC covers at least one TP. Reconcile source obligations to TCs; an unassigned draft TP blocks completion, and a missing behavior is GAP even when the original links pass. Move misplaced scenarios rather than duplicating them; retain concrete P1/P2 or test-level referrals without designing those categories here.
4. **Stop** — After all four categories, apply the method's Discovery Gate and cross-category reconciliation within its bounded review budget. Stop on unresolved intent/no progress and report gaps rather than claiming completeness. An empty category needs a reasoned `@[NoTestPoints]`; missing source is BLOCKED, not a pass. Recommend `TEST_reviewFuncTestsSkeleton` with sources and ledger for independent review; keep `ready_for_implementation: no` until that review passes.

## Usage Example

Designing the full P0 set from a gateway interface. IDs below are abbreviated; generated artifacts use registered Story IDs and qualified AC/TP/TC IDs.

```text
/TEST_designFuncTestsSkeleton
interface_or_protocol_file: services/payment/gatewayPort.h
feature_name: payment gateway retry
target_test_file: services/payment/SysTests/UT_Gateway.ts
behavior_sources: services/payment/README_UsageDesign.md
```

Illustrative source assumptions: authorize accepts amounts 0..10000 inclusive; authorize and capture are both supported normal workflows; the contract specifies malformed-response failure handling. If the actual source does not say this, record questions instead of copying these expectations.

Expected result:

- **Inventory**: normal authorize and capture, their valid range/outcomes, caller constraints, and dependency failures become rule/TP entries before drafting. Unspecified retry policy remains QUESTION, not an invented retry count.
- **Thought/Action (Typical)**: normal authorize/capture paths → US-01 with AC-01, AC-02, each carrying one TP mapped to exactly one TC. `SUT: gatewayPort` declared in the file overview.
- **Observation**: the Typical slice satisfies cardinality; the remaining P0 categories are not yet complete.
- **Thought/Action (Edge)**: zero-amount and max-amount authorizations drafted.
- **Observation**: AC-04 links to TP-04, but TP-04 has no TC → uncovered TP → back to **Action** → TC-04 added as its sole covering case.
- **Thought (Misuse)**: "gateway returns malformed JSON" was drafted here, but that is an *external* failure, not invalid caller usage → back to **Thought** → moved to Fault, not duplicated in both.
- **Reconciliation**: verify both supported operations and their applicable boundaries/outcomes are accounted for, not just AC-04's missing link. Missing oracles block readiness even if all written links pass.
- **Stop**: report cardinality and `discovery_status` separately, ledger location and residual risks, `ready_for_implementation: no`, and `next_command = TEST_reviewFuncTestsSkeleton`. No executable test code written.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: optional related skeletons for consistency.
- `behavior_sources`: optional additional User Story, AC, UsageDesign, workflow, or error-contract sources; resolve references or ask when the interface is insufficient.
- `scope`: optional developer-approved functional boundary; otherwise the full named feature, not a silently selected subset.
- `deployment_evidence`: optional incident/reproduction, usage, or supported-environment evidence; record unavailable evidence without inventing it.
- `discovery_ledger`: optional existing ledger location; otherwise place it in FreelyDrafts or target overview/design comments and return its location.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)
- [../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md)
- [Project-Wide Traceability IDs](../../../methodPrompts/CaTDD_methodPrompt-testStructure.md#project-wide-traceability-ids)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Typical.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Edge.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Misuse.md)
- [../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md](../../../methodPrompts/CaTDD_methodPrompt4Cat-Fault.md)

## Output Contract

- A P0 Functional skeleton set with Typical, Edge, Misuse, and Fault sections/files, with explicit gaps or source-backed no-test-point decisions rather than a false completeness claim.
- Category-specific `@[Class]`, `@[Category]`, `@[Intent]`, `@[UseWhen]`, `@[AvoidWhen]`, `@[US]`, `@[AC]`, `@[TP]`, and `@[TC]` entries with registered Story IDs and story-qualified AC/TP/TC IDs.
- Traceability cardinality gate: each `@[US]` has >=1 linked `@[AC]`, each `@[AC]` has >=1 linked `@[TP]`, each `@[TP]` maps to exactly one `@[TC]`, and each `@[TC]` covers >=1 `@[TP]`. A TC MAY cover multiple TPs when every obligation is explicitly verified.
- Explicit SUT declaration in the test-file overview (for example: `SUT: utCodeAgentCLI`).
- Behavior inventory, discovery dimensions/selection limits, and a linked `discovery_ledger` with source references and disposition evidence.
- Separate cardinality result, `discovery_status`, `ready_for_implementation`, review evidence, open questions, exclusions, referrals, and residual risk per the method's Discovery Gate.
- Review handoff: scope, source files, skeleton files, and ledger location for `TEST_reviewFuncTestsSkeleton`; design alone does not authorize implementation.
- No executable implementation test code.

## Conflict Guard

This command designs P0 Functional coverage only. It should not design P1/P2 categories or implement tests.
Do not report design complete where a US has no AC, an AC has no TP, a TP maps to zero or multiple TCs, or a TC covers no TP.
If missing intent prevents a valid mapping, preserve an explicitly blocked draft and question; do not invent links or report completion. Do not drop GAP/QUESTION rows, approve your own scope exclusions, or equate category presence with discovered coverage.

ONE-MORE-THING: ask developer if something not sure
