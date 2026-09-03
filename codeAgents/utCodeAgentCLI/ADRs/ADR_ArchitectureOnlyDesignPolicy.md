# Architectural Decision Record: Architecture-Only Design Policy

Date: 2026-08-30
Decision Type: Ban / nonexistence (anticrisis)

| Field | Value |
| :--- | :--- |
| 1. Issue | `utCodeAgentCLI` accumulated standalone DetailDesign documents that duplicated architecture, requirements, verification, and implementation facts, creating conflicting design authority and lifecycle routing. |
| 2. Decision | Ban standalone DetailDesign artifacts for `utCodeAgentCLI`. Keep `README_ArchDesign.md` and `README_ArchDesign_ZH.md` as the sole module design authority. Store durable decisions in ADRs, behavior in requirement/usage docs, verification in VerifyDesign/tests, and executable truth in source. |
| 3. Status | Decided |
| 4. Group | documentation architecture, governance, maintainability |
| 5. Assumptions | ArchDesign can preserve module ownership and dependency direction; source and tests remain authoritative for executable details; module SpecFlow can use architecture review without a DetailDesign gate. |
| 6. Alternatives | A1 retain bilingual module DetailDesign; A2 retain a root DetailDesign for the lifecycle checker; A3 use ArchDesign plus ADRs, requirements, verification, and source/tests. |
| 7. Argument | A1 and A2 create overlapping authorities and synchronization cost. A3 gives the module one design authority while keeping decisions durable and executable details close to code/tests. Reduced drift outweighs losing a separate low-level narrative. |
| 8. Implications | Delete root and module DetailDesign files for `utCodeAgentCLI`; remove live links and mirror checks; route current module design through ArchDesign and architecture review; preserve old DetailDesign mentions only as labeled history. |
| 9. Related Decisions | Overrides the former module documentation boundary that assigned implementation contracts to DetailDesign. Constrains the continuing implications of ADR_RuntimeLanguage and ADR_AgenticReliabilityPolicy without changing their runtime or reliability decisions. |
| 10. Related Requirements | US-SPECFLOW-REPAIR-01 requires one trustworthy project state and non-conflicting design guidance. The policy applies to future `utCodeAgentCLI` work. |
| 11. Affected Artifacts | Module ArchDesign mirrors, module README/UserGuide/UbiLang/VerifyDesign, both SpecFlow project contexts, active story/tasks, mirror validation, prior ADR references, and former DetailDesign files. |
| 12. Notes | Developer decision: remove all DetailDesign for `utCodeAgentCLI` and keep its ArchDesign as the design authority. This does not ban DetailDesign for other projects or modules. |

## Alternatives Comparison Matrix

| Concern | A1 Module DetailDesign | A2 Root DetailDesign | A3 Architecture-Only |
| :--- | :--- | :--- | :--- |
| Single module design authority | No | No | Yes |
| Synchronization cost | High | High | Low |
| Durable decision trace | Partial | Partial | Yes, through ADRs |
| Executable detail near code | Partial | No | Yes |
| Fits developer direction | No | No | Yes |

## Supersession

- No new `README_DetailDesign*` file may be created for `utCodeAgentCLI` unless this ADR is explicitly superseded.
- Historical lifecycle prose may mention former DetailDesign evidence, but current links and instructions must point to ArchDesign, ADRs, requirements, verification, or source/tests.

## Traceability

- Subproject context: [../../../.catdd/spec/projectContext-utCodeAgentCLI.md](../../../.catdd/spec/projectContext-utCodeAgentCLI.md)
- Architecture: [../README_ArchDesign.md](../README_ArchDesign.md)
- Chinese architecture mirror: [../README_ArchDesign_ZH.md](../README_ArchDesign_ZH.md)
- Active story: [../../../.catdd/spec/doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md](../../../.catdd/spec/doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md)
