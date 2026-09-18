# UT_reviewQualityTestsSkeleton

## Purpose

Review the P2 quality skeleton set before implementation, release-risk review, or TC-by-TC execution continues.

Use this command to review the declared Performance, Robust, Compatibility, Configuration, Diagnosis, and Security scope, including source-backed concerns absent from the existing skeletons. Apply **Source-First** review to audit the unbroken **TestEvidenceChain** (WHY: quality attributes and threat policies -> HOW: observable response measures) from quality requirements, budgets, matrices, and policies to observable response measures.

## CoT Pattern

**ReACT** — Reasoning + Acting. Apply **Source-First** review: audit the **TestEvidenceChain** from quality sources and policies to observable response measures before examining existing skeletons. This is a bounded, source-first review of quality obligations and observable evidence. Numeric budgets and exact symbolic predicates are both valid. The command is read-only; return findings and proposed corrections without changing design or implementation files.

### ReACT Execution

Use one discovery sweep and one independent challenge, with at most two repair/recheck rounds for the review report. Stop earlier on missing intent, conflicting sources, or no progress; do not loop until PASS. Apply the canonical P2 Discovery Gate in [CaTDD_methodPrompt-testPointDiscovery.md](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md).

1. **Thought** — Read source artifacts first, before the designer's ledger or skeletons. Declare SUT, in-scope categories, domain profile(s), test level, and execution environment. Derive an independent checklist of budgets, sustained-use invariants, supported matrix rows, precedence, evidence fields, and protection policies. Capture source conflicts and missing expectations as questions; domain examples cannot supply thresholds or technologies.
2. **Action** — Read the discovery_ledger and skeletons, then reconcile the checklist in both directions. Check each source-backed six-part quality scenario, including the response measure and artifact reference: numeric budgets need units/workloads/targets; exact predicates need expected matrix/policy/evidence results. A missing obligation may have no existing US/AC/TC ID; use its source/rule or TP ID. Manual or hybrid procedures are valid when their observation and evidence capture are explicit.
3. **Observation** — Audit actual disposition counts, exclusions, routing, review provenance, and US/AC/TC links. An in-scope handoff is not coverage; a TODO TC is not a missing test point. Report weak oracles and missing ledger/review evidence as gaps, and unknown expectations as questions. Correct vague or inconsistent findings only within the remaining budget; confirm no files were modified.
4. **Stop** — Report `BLOCKED` for unresolved in-scope source, oracle, ownership, or scope questions; otherwise `REVISE` with `rework_route = SPEC_updateDetailDesign` for missing design or review evidence; otherwise `PASS` for this scope only. `ready_for_implementation: yes` requires both sub-gates to pass. Route `ASK` when the developer must settle a decision. Report `next_command = UT_tellMeNextImplTest` on `PASS`; do not infer release readiness from a design review.

### Worked Example

Illustrative embedded-daemon review: `R-CONFIG` says an explicit environment setting overrides the config file; `R-DIAG` requires error code, operation, and device fields while excluding credentials. Configuration is adequately designed, but the diagnostic TC only checks that an error occurred. Device-access authorization is explicitly requested in Security scope, yet its policy is missing; the diagnostic redaction rule does not define device permissions. Other P2 categories are outside this declared slice.

```text
/UT_reviewQualityTestsSkeleton
test_file_or_files: Test/test_device_session_freelyDrafts.cxx
feature_name: device session
scope: P2 Configuration, Diagnosis, Security
quality_sources: supplied R-CONFIG, R-DIAG; device-authorization policy missing
```

Expected result:

- **Thought**: source-first checklist includes the required and forbidden diagnostic fields. The configuration winner and field predicates are valid non-numeric oracles.
- **Action**: report GAP for the weak diagnostic TC and QUESTION for the missing in-scope security policy. Do not invent a latency target, authentication technology, or alternative configuration hierarchy.
- **Observation**: cardinality may pass while these findings remain. Keep design evidence separate from whether the target board is currently available; do not infer disposition totals from this abbreviated example.
- **Stop**: `discovery_status: BLOCKED`, `ready_for_implementation: no`; retain the diagnostic GAP alongside the question. No source or test files are changed.

## Inputs

- `test_file_or_files`: skeleton files to review.
- `feature_name`: feature under review.
- `scope`: expected quality scope.
- `quality_sources`: confirmed budgets, design rules, matrices, diagnostic contracts, or protection policies.
- `discovery_ledger`: feature-level inventory, dimension/sampling evidence, and candidate dispositions; if absent, report the missing review input.
- `domain_profile` / `execution_environment`: applicable embedded/service/agent context and host, simulator, target/HIL, or other verification boundary.
- `functional_skeletons`: related P0 skeletons.
- `design_skeletons`: optional related P1 skeletons.

## Preconditions

- Each in-scope quality obligation needs a confirmed source and an observable response measure: numeric budgets or exact predicates. A generic tactic or domain example is not that source.
- Missing source or oracle prevents approval and becomes a QUESTION; missing automation does not invalidate an explicit manual/hybrid verification procedure.
- Apply the P2 Discovery Gate to the declared scope, including obligations absent from existing files.

## Method References

- [P2-QualityTestsFlow](../../flows/P2-QualityTestsFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_methodPrompt-testPointDiscovery](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md)
- [CaTDD_methodPrompt4Cat-Performance](../../../methodPrompts/CaTDD_methodPrompt4Cat-Performance.md)
- [CaTDD_methodPrompt4Cat-Robust](../../../methodPrompts/CaTDD_methodPrompt4Cat-Robust.md)
- [CaTDD_methodPrompt4Cat-Compatibility](../../../methodPrompts/CaTDD_methodPrompt4Cat-Compatibility.md)
- [CaTDD_methodPrompt4Cat-Configuration](../../../methodPrompts/CaTDD_methodPrompt4Cat-Configuration.md)
- [CaTDD_methodPrompt4Cat-Diagnosis](../../../methodPrompts/CaTDD_methodPrompt4Cat-Diagnosis.md)
- [CaTDD_methodPrompt4Cat-Security](../../../methodPrompts/CaTDD_methodPrompt4Cat-Security.md)

## Skill Integration Policy

- Skill-first rule: if relevant quality, architecture, or security skills exist in the workspace, use them during this review.
- Preferred skills and usage:
  - `apply-architectural-tactics` to evaluate whether quality scenarios across Performance, Robust, Compatibility, Configuration, Diagnosis, and Security have valid, measurable response measures or exact predicates.
  - `analyze-with-tactics-questionnaires` to audit quality skeletons against architectural questionnaires (Performance, Availability/Robustness, Security).
  - `design-tool-use-sandboxing` to review agent tool-use test skeletons for safe vs. dangerous tool classification and human-in-the-loop approval coverage.
- Builtin fallback rule: if one or more skills are unavailable, review with the learned builtin-skill checklist in this command.
- Completion rule: this command must remain executable and decisive without skill loading.

## Output Contract

- SUT, declared scope across Performance/Robust/Compatibility/Configuration/Diagnosis/Security, source references, domain/test-level/environment, and verification methods.
- `discovery_ledger`: location or explicit missing-evidence finding; disposition counts reconciled to actual rows, auditing the **TestEvidenceChain** with exclusions, routing, and sampling limits separate from coverage.
- `review_evidence`: independent source-derived checklist, reviewer/process (or labeled self-review), sources examined, reconciliation, and residual risk.
- Findings keyed by source/rule or TP ID, with US/AC/TC IDs only when they exist; identify missing obligations, weak oracles, unknown targets/policies, and required corrections or decisions.
- `cardinality_gate`: `PASS | FAIL`; `discovery_status`: `PASS | GAPS | BLOCKED`; `ready_for_implementation`: `yes | no`. Any non-PASS sub-gate means no; `PASS` applies only to the reviewed scope, not execution or release readiness.
- `review_verdict`: one of `PASS`, `REVISE`, `BLOCKED`, or `ASK`, derived from the two sub-gates: both `PASS` → `PASS`; any `FAIL` or `GAPS` → `REVISE` with `rework_route = SPEC_updateDetailDesign`; unresolved source or scope question → `BLOCKED`; developer decision required → `ASK`.
- Bounded-review stop reason and next action: `rework_route` on non-PASS, or `next_command = UT_tellMeNextImplTest` on `PASS`.

## Review Gate Contract

- Reviews: the P2 quality skeleton set (Performance, Robust, Compatibility, Configuration, Diagnosis, Security) and its discovery ledger for one declared SUT scope.
- Does not: draft or edit skeletons, change category semantics, implement tests, or review P0/P1 skeletons owned by their own gates.
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

This command reviews quality skeletons only. It should not redefine category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
