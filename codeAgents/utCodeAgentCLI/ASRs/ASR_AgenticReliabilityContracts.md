# Architecturally Significant Requirements: Agentic Reliability Contracts

Date: 2026-06-07
Status: Accepted for architecture gate

## Scope

This ASR set defines architecture-level reliability and safety requirements for utCodeAgentCLI command execution and runtime control. It is the requirement source for architecture contracts and detail-design follow-up.

## Source Trace

- Active story: [../../../.catdd/spec/doingUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md](../../../.catdd/spec/doingUS/20260606-harden-utCodeAgentCLI-agentic-reliability-UserStory.md)
- Source issue: [../../../.catdd/spec/analyzedNews/20260606-treat-updates-as-issue-first-Issue.md](../../../.catdd/spec/analyzedNews/20260606-treat-updates-as-issue-first-Issue.md)
- Architecture document: [../README_ArchDesign.md](../README_ArchDesign.md)

## ASR Set

| ASR ID | Requirement | Architecture impact | Acceptance signal |
| --- | --- | --- | --- |
| ASR-R1 | Retry and correction loops shall be bounded and deterministic at budget exhaustion. | Requires retry-budget owner in execution layer and escalation behavior at exhaustion. | ArchDesign states explicit budget owner and deterministic exhaustion route. |
| ASR-R2 | Unknown or unsupported behavior routing shall be deterministic and diagnosable. | Requires behavior registry fallback and explicit argument-error path. | ArchDesign states no silent coercion and explicit diagnostics fallback. |
| ASR-R3 | Failure handling shall distinguish transient and permanent classes with explicit routing. | Requires failure taxonomy and routing policy by class. | ArchDesign states classes and class-specific control flow. |
| ASR-R4 | Multi-step execution shall define snapshot/rollback or compensation boundary. | Requires step-boundary consistency model and post-failure mutation control. | ArchDesign states snapshot boundary and compensation policy. |
| ASR-R5 | Escalation policy shall define threshold and non-interactive behavior. | Requires explicit escalation trigger and CI-safe non-interactive action. | ArchDesign states threshold trigger and non-interactive abort/escalation trace tag. |
| ASR-R6 | Shell execution shall enforce safety policy and sensitive-path protection. | Requires allowlist execution model, sensitive-path gating, and redaction policy. | ArchDesign states allowed execution surface and denied sensitive paths by default. |

## ASR-ID -> US/AC Trace Matrix

| ASR ID | Executable requirement mapping | Acceptance criteria mapping |
| --- | --- | --- |
| ASR-R1 | US-DEV-05 | US-DEV-05 AC-01 |
| ASR-R2 | US-DEV-05 and US-DEV-01 | US-DEV-05 AC-02 and US-DEV-01 AC-01 |
| ASR-R3 | US-DEV-05 and US-DEV-01 | US-DEV-05 AC-03 and US-DEV-01 AC-03 |
| ASR-R4 | US-DEV-05 and US-INVENTOR-02 | US-DEV-05 AC-04 and US-INVENTOR-02 AC-02 |
| ASR-R5 | US-DEV-05 and US-DEV-03 | US-DEV-05 AC-05 and US-DEV-03 AC-02 |
| ASR-R6 | US-DEV-05 and US-INVENTOR-01/US-INVENTOR-02 | US-DEV-05 AC-06, US-INVENTOR-01 AC-03, and US-INVENTOR-02 AC-01 |

## Requirement Source Links

- Master index: [../README_UserStory.md](../README_UserStory.md)
- Developer ACs: [../README_UserStory4DEVELOPER.md](../README_UserStory4DEVELOPER.md)
- Inventor ACs: [../README_UserStory4INVENTOR.md](../README_UserStory4INVENTOR.md)
- Status tracker: [../README_UserStoryStatus.md](../README_UserStoryStatus.md)

## Notes

- ASRs define what must hold at architecture boundary level.
- Numeric defaults are decision artifacts and are tracked in ADR form.

## Next Link

- Decision record: [../ADRs/ADR_AgenticReliabilityPolicy.md](../ADRs/ADR_AgenticReliabilityPolicy.md)
