# Architectural Decision Record: utCodeAgentCLI Runtime Language

Date: 2026-06-05
Decision Type: Property (diacrisis)

| Field | Value |
| :--- | :--- |
| 1. Issue | The project must choose a primary runtime language for utCodeAgentCLI (TypeScript on Node.js, Python, or Go) before implementation begins, because this choice constrains detail design, adapter strategy, packaging, and team workflow. |
| 2. Decision | Staged decision: adopt TypeScript on Node.js as the V1 (PoC) runtime for adapter-native development speed, and pre-select Go as the preferred V2 runtime for production distribution. The two phases are decided together so detail design can keep the V1/V2 boundary explicit. |
| 3. Status | Decided |
| 4. Group | integration, tooling |
| 5. Assumptions | utCodeAgentCLI ships in phases: V1 is a proof-of-concept, V2 targets real production deployment; CLI work is orchestration-heavy (files, child processes, JSON traces); adapter boundaries to Copilot/MCP/OpenCode must remain explicit; detail design keeps the V1/V2 runtime boundary clean. |
| 6. Alternatives | A1 TypeScript on Node.js, A2 Python, A3 Go. See Alternatives Comparison Matrix below. |
| 7. Argument | The deciding force is phase fit, not prior-doc continuity. For V1 (PoC), the target adapter ecosystem (Copilot SDK, MCP, OpenCode) is itself Node/TypeScript-native, so TS/Node gives first-class adapters with no cross-language bridge and matches the async-I/O + native-JSON shape of orchestration/trace work; this outweighs Python's scripting velocity (C2) for a PoC because adapter integration, not raw scripting, is the dominant cost. For V2 (production), single-binary distribution becomes the dominant force, where Go's static binaries (C5) outweigh keeping TS, so Go is pre-selected to be revisited when V2 scope opens. |
| 8. Implications | V1 detail design proceeds on TS/Node now; architecture must keep the AgentSDK/adapter boundary runtime-portable so the V2 Go migration is contained; a future ADR revisits and confirms Go when V2 production scope is formally opened. |
| 9. Related Decisions | Constrains future packaging/test-runner decision for utCodeAgentCLI; enables adapter-boundary decisions in architecture docs; conflicts with any immediate implementation that assumes final language choice before review closure. |
| 10. Related Requirements | Runtime-language ACs in the active user story: evaluate alternatives by explicit criteria, select one primary runtime, capture formal ADR, and clarify non-goals/boundaries. |
| 11. Affected Artifacts | [../README_ArchDesign.md](../README_ArchDesign.md), [../README_ArchDesign_ZH.md](../README_ArchDesign_ZH.md), [../README_DetailDesign.md](../README_DetailDesign.md), [../README_DetailDesign_ZH.md](../README_DetailDesign_ZH.md), [../../.catdd/spec/doneUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md](../../.catdd/spec/doneUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md), [../../.catdd/spec/doneUS/20260604-decide-utCodeAgentCLI-runtime-language-TASKs.md](../../.catdd/spec/doneUS/20260604-decide-utCodeAgentCLI-runtime-language-TASKs.md). |
| 12. Notes | This ADR records a decision state and comparison process, not implementation code. V1 implementation proceeds on TS/Node; Go is a pre-selected V2 target to be confirmed by a follow-up ADR when production scope opens. |

## Alternatives Comparison Matrix

| ID | Architectural Concern | Option 1: TypeScript on Node.js | Option 2: Python | Option 3: Go |
| :--- | :--- | :--- | :--- | :--- |
| C1 | Fit with current architecture/detail docs | Yes | Partial | Partial |
| C2 | Developer workflow speed for orchestration CLI | Partial | Yes | Partial |
| C3 | Adapter-boundary continuity (Copilot/OpenCode planning) | Yes | Partial | Partial |
| C4 | Migration churn from current doc baseline | Yes | Partial | No |
| C5 | Distribution simplicity for end users | Partial | Partial | Yes |

Tradeoff summary (phase-weighted):

- V1 (PoC) weights C3 adapter-boundary continuity and orchestration/JSON fit highest; TypeScript on Node.js wins because the adapter ecosystem is Node-native, so it needs no cross-language bridge.
- Python's C2 scripting velocity does not outweigh adapter integration cost for a PoC, so it is not selected.
- V2 (production) weights C5 distribution simplicity highest; Go's static single-binary output wins there, so Go is pre-selected for V2 and deferred until production scope opens.

## Traceability

- Source issue: [../../.catdd/spec/analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md](../../.catdd/spec/analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md)
- Active story: [../../.catdd/spec/doingUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md](../../.catdd/spec/doingUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md)
- TASKs artifact: [../../.catdd/spec/doneUS/20260604-decide-utCodeAgentCLI-runtime-language-TASKs.md](../../.catdd/spec/doneUS/20260604-decide-utCodeAgentCLI-runtime-language-TASKs.md)

## Follow-up

- V1: proceed to SPEC_takeDetailDesign on TypeScript/Node.js; keep the AgentSDK/adapter boundary runtime-portable to contain the future V2 migration.
- V2: open a follow-up ADR to confirm Go (or re-evaluate) when production-distribution scope is formally started.