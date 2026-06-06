# Architectural Decision Record: Agentic Reliability Policy Defaults

Date: 2026-06-07
Decision Type: Property and process-control

| Field | Value |
| :--- | :--- |
| 1. Issue | The architecture needs explicit reliability and safety policy defaults (retry, fallback, failure routing, rollback boundary, escalation, shell safety) so behavior is bounded and reviewable before detail implementation. |
| 2. Decision | Adopt v1 architecture defaults: `maxStepRetry = 2`, `maxRunCorrectionLoop = 3`; unknown behavior routes to diagnostics fallback with argument-error exit; failure taxonomy uses TRANSIENT vs PERMANENT with retry only for transient failures; rollback boundary is step-scoped snapshot plus compensation boundary (no full workspace rollback); escalation in non-interactive mode forces abort with trace tag `ESCALATED_NON_INTERACTIVE`; execution policy is allowlist-first with sensitive-path deny-by-default and trace redaction. |
| 3. Status | Decided |
| 4. Group | reliability, safety, diagnosability |
| 5. Assumptions | v1 is architecture-contract-first and design-oriented-only for this story; thresholds may be tuned later based on runtime evidence; adapter capability can vary, but policy ownership remains in architecture. |
| 6. Alternatives | A1 unbounded retries with operator judgment; A2 stricter one-shot failure policy; A3 adaptive policy by adapter without shared defaults. |
| 7. Argument | Bounded deterministic defaults reduce runaway loop risk and make CI behavior predictable. Diagnostics fallback prevents silent behavior coercion. Two-class failure taxonomy balances resiliency and fail-fast correctness. Step-scoped compensation avoids unsafe global rollback while preserving consistent trace boundaries. Non-interactive forced abort prevents hanging pipelines. Allowlist execution with sensitive-path deny-by-default reduces credential exposure and shell misuse risk. |
| 8. Implications | Detail design must map these defaults to concrete interfaces and error classes. Verify design should include tests for budget exhaustion, fallback routing, failure classification, and non-interactive escalation. Threshold values can be revised only through follow-up ADR update. |
| 9. Related Decisions | Complements runtime-language ADR and constrains executor, control, diagnostics, and trace policies. |
| 10. Related Requirements | [../ASRs/ASR_AgenticReliabilityContracts.md](../ASRs/ASR_AgenticReliabilityContracts.md) (ASR-R1 to ASR-R6), mapped to executable requirements in [../README_UserStory4DEVELOPER.md](../README_UserStory4DEVELOPER.md) US-DEV-05 AC-01..AC-06 and supporting ACs in US-DEV-01/US-DEV-03/US-INVENTOR-01/US-INVENTOR-02. |
| 11. Affected Artifacts | [../README_ArchDesign.md](../README_ArchDesign.md), [../README_ArchDesign_ZH.md](../README_ArchDesign_ZH.md), [../README_DetailDesign.md](../README_DetailDesign.md), [../README_DetailDesign_ZH.md](../README_DetailDesign_ZH.md). |
| 12. Notes | This ADR sets architecture defaults, not implementation code. Any threshold tuning should keep traceability to ASR and review findings. |

## Alternatives Comparison Matrix

| Alternative | Benefit | Risk | Decision |
| :--- | :--- | :--- | :--- |
| A1 Unbounded retries | Maximizes automatic recovery attempts. | Runaway loops, non-deterministic runtime, poor CI behavior. | Rejected |
| A2 One-shot fail-fast | Simple and highly predictable failure handling. | Too brittle for transient infrastructure errors. | Rejected |
| A3 Adapter-specific independent defaults | Optimizes for each runtime adapter. | Fragments behavior and weakens cross-adapter diagnosability. | Rejected |
| Selected bounded shared defaults | Predictable, diagnosable, and resilient enough for v1. | May need evidence-based tuning in later iterations. | Accepted |

## Traceability

- Active story: [../../../.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md](../../../.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md)
- TASKs: [../../../.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-TASKs.md](../../../.catdd/spec/doneUS/20260606-harden-utCodeAgentCLI-agentic-reliability-TASKs.md)

### ASR -> US/AC Binding

| ASR ID | Bound US/AC |
| :--- | :--- |
| ASR-R1 | US-DEV-05 AC-01 |
| ASR-R2 | US-DEV-05 AC-02, US-DEV-01 AC-01 |
| ASR-R3 | US-DEV-05 AC-03, US-DEV-01 AC-03 |
| ASR-R4 | US-DEV-05 AC-04, US-INVENTOR-02 AC-02 |
| ASR-R5 | US-DEV-05 AC-05, US-DEV-03 AC-02 |
| ASR-R6 | US-DEV-05 AC-06, US-INVENTOR-01 AC-03, US-INVENTOR-02 AC-01 |
