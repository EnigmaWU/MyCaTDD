# UT_reviewDesignTestsSkeleton

## Purpose

Review the P1 design skeleton set before quality coverage or implementation continues.

Use this command to review the declared State, Capability, Interaction, and Concurrency scope, including source-backed concerns for which no skeleton or TC exists yet.

## CoT Pattern

**ReACT** — Reasoning + Acting. This is a bounded, source-first independent review, not only an audit of existing skeleton links. A plausible skeleton without a confirmed design source cannot be approved. The command is read-only; return findings and proposed corrections without changing design or implementation files.

### ReACT Execution

Use one discovery sweep and one independent challenge, with at most two repair/recheck rounds for the review report. Stop earlier on missing intent, conflicting sources, or no progress; do not loop until PASS. Apply the canonical P1 Discovery Gate in [CaTDD_methodPrompt-testPointDiscovery.md](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md).

1. **Thought** — Read source artifacts first, before the designer's ledger or skeletons. Declare SUT, in-scope categories, domain profile(s), test level, and execution environment. Independently derive the source-backed state/guard, capability/responsibility, handoff, and interleaving obligations. Record a source-derived checklist and any missing source or applicability question.
2. **Action** — Read the discovery_ledger and skeletons, then reconcile the independent checklist in both directions. Check source-backed setup/oracles, category placement, verification procedures, and US/AC/TC links. A missing obligation may have no existing US/AC/TC ID: identify it by source/rule or TP ID, category, and a concrete correction or question. A TODO TC can be DESIGNED; it is not a discovery gap merely because it is unimplemented.
3. **Observation** — Audit actual disposition counts, exclusions, routing, and review provenance. In-scope handoffs retain GAP/QUESTION until resolved; do not count referrals as coverage. Check manual/model-facing evidence as well as automated assertions. Report missing ledger/review evidence as a gap. Correct vague or inconsistent findings only within the remaining review budget; confirm no files were modified.
4. **Stop** — Report BLOCKED for unresolved in-scope source/oracle/ownership/scope questions; otherwise GAPS for missing design or review evidence; otherwise PASS for this scope only. `ready_for_implementation: yes` requires both cardinality and discovery gates to pass. Recommend clarification/design repair on non-PASS, or `UT_tellMeNextImplTest` or further P2 design on PASS; do not claim release readiness.

### Worked Example

Illustrative embedded-device review: the supplied lifecycle rule `R-STATE` defines stopping and handle release; `R-CAP` defines a configured handle-pool limit; `R-INT` requires callback detachment before closing the device. Existing skeletons cover the first two, but omit the handoff order. Concurrency is requested in scope, yet its design source is missing.

```text
/UT_reviewDesignTestsSkeleton
test_file_or_files: Test/test_device_session_freelyDrafts.cxx
feature_name: device session
scope: P1 State, Capability, Interaction, Concurrency
design_sources: supplied R-STATE, R-CAP, R-INT; concurrency model missing
```

Expected result:

- **Thought**: source-first checklist captures `R-INT` before examining existing TC counts; missing concurrency intent remains a question.
- **Action**: report the unlinked `R-INT` obligation as GAP without inventing an existing TC ID. Ask where the concurrency model lives instead of assuming interrupt or locking behavior.
- **Observation**: valid links for State/Capability do not close either finding. Record the reviewer/process, sources, checklist, and ledger reconciliation; do not infer counts from this abbreviated example.
- **Stop**: `discovery_status: BLOCKED`, `ready_for_implementation: no`; retain the known GAP alongside the question. No source or test files are changed.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected design scope.
- `design_sources`: confirmed P1 design sources used by the skeletons under review.
- `discovery_ledger`: feature-level inventory, dimension/sampling evidence, and candidate dispositions; if absent, report the missing review input.
- `domain_profile` / `execution_environment`: applicable embedded/service/agent context and host, simulator, target/HIL, or other verification boundary.
- `functional_skeletons`: related P0 Typical, Edge, Misuse, or Fault skeletons.

## Preconditions

- P1 MUST have DESIGN: every State, Capability, Interaction, or Concurrency skeleton under review must trace to a confirmed design source.
- Apply the P1 Discovery Gate to the declared scope, not only existing files; source-backed obligations with no skeleton remain reviewable.
- WARNING: If a P1 skeleton has no confirmed design source, ask the developer where the design lives or stop before approving the P1 review.

## Method References

- [P1-DesignTestsFlow](../../flows/P1-DesignTestsFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_methodPrompt-testPointDiscovery](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md)
- [CaTDD_methodPrompt4Cat-State](../../../methodPrompts/CaTDD_methodPrompt4Cat-State.md)
- [CaTDD_methodPrompt4Cat-Capability](../../../methodPrompts/CaTDD_methodPrompt4Cat-Capability.md)
- [CaTDD_methodPrompt4Cat-Interaction](../../../methodPrompts/CaTDD_methodPrompt4Cat-Interaction.md)
- [CaTDD_methodPrompt4Cat-Concurrency](../../../methodPrompts/CaTDD_methodPrompt4Cat-Concurrency.md)

## Output Contract

- SUT, declared scope across State/Capability/Interaction/Concurrency, source references, domain/test-level/environment, and verification methods.
- `discovery_ledger`: location or explicit missing-evidence finding; disposition counts reconciled to actual rows, with exclusions, routing, and sampling limits separate from coverage.
- `review_evidence`: independent source-derived checklist, reviewer/process (or labeled self-review), sources examined, reconciliation, and residual risk.
- Findings keyed by source/rule or TP ID, with US/AC/TC IDs only when they exist; identify gaps, unknowns, category conflicts, weak oracles, or unsupported assumptions and the required correction/decision.
- `cardinality_gate`: PASS | FAIL; `discovery_status`: PASS | GAPS | BLOCKED; `ready_for_implementation`: yes | no. Any non-PASS gate means no; PASS applies only to the reviewed scope, not execution or release readiness.
- Bounded-review stop reason and next action: clarify/repair on non-PASS, or choose a TC or continue P2 design on PASS.

## Conflict Guard

This command reviews design skeletons only. It should not redefine category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
