# ADR: utCodeAgentCLI Runtime Language

Status: Proposed

Date: 2026-06-05

Context:

`utCodeAgentCLI` needs a primary implementation language before the architecture can move into detail design and test-skeleton design. The active story asks whether the runtime should be TypeScript, Python, or Go, and requests that the choice be captured as a formal ADR.

This ADR does not assume the answer in advance. It records the decision criteria, tradeoffs, and likely consequences so the team can choose the best V1 runtime language before implementation starts.

Decision drivers:

- The runtime language should fit the current repository’s documentation and adapter model.
- The runtime language should minimize friction for local file orchestration, command routing, and machine-readable trace generation.
- The runtime language should preserve a clean adapter boundary so future Copilot, OpenCode, or other runtime surfaces can be added without changing CaTDD semantics.
- The runtime language should keep the eventual V1 implementation realistic for the team to build, test, and maintain.

Alternatives considered:

1. TypeScript on Node.js
2. Python
3. Go

Evaluation criteria:

- Ecosystem fit with the current documentation and likely toolchain.
- Maintainability for a CLI that is orchestration-heavy rather than algorithm-heavy.
- Runtime integration with local files, shell/process execution, JSON trace output, and adapter boundaries.
- Tooling support for tests, packaging, and developer workflow.
- Ability to keep CaTDD semantics delegated instead of hardcoded.

Tradeoff analysis:

TypeScript on Node.js:

- Strengths: aligns with the current architecture and detail-design documentation, fits JSON-heavy trace handling, and keeps the CLI close to the likely adapter surfaces.
- Weaknesses: requires the team to stay disciplined about keeping runtime orchestration separate from CaTDD method semantics; may be less convenient than Python for quick scripting-heavy experiments.

Python:

- Strengths: excellent scripting ergonomics, broad ecosystem, and often fast to prototype for file and process orchestration.
- Weaknesses: would require more translation work against the current TypeScript-facing architecture and could create a wider gap between the CLI design docs and the implementation contracts.

Go:

- Strengths: strong binary distribution model, clear concurrency story, and a compact deployment footprint.
- Weaknesses: would require the biggest rewrite of the current architecture assumptions and would add the most churn for a workflow that is mostly orchestration rather than performance-critical compute.

Decision status:

- This ADR is a proposed decision record, not a final implementation commitment yet.
- The intended outcome is to select the language that best balances current-document fit, maintainability, runtime integration, and future adapter flexibility.
- V1 will be implemented after the choice is finalized, not before.

Consequences:

- Once the language is chosen, the V1 implementation target becomes fixed and detail design can narrow around it.
- The chosen runtime should not force CaTDD semantics into the CLI layer.
- Python and Go may remain future adapter or portability options, but they should not be treated as the default answer without an explicit decision.

Non-goals:

- Implementing `utCodeAgentCLI` runtime code in this ADR.
- Choosing package manager, test runner, or packaging format.
- Rewriting CaTDD method semantics.

Traceability:

- Source issue: [../../.catdd/spec/analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md](../../.catdd/spec/analyzedNews/20260604-decide-utCodeAgentCLI-runtime-language-Issue.md)
- Active story: [../../.catdd/spec/doingUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md](../../.catdd/spec/doingUS/20260604-decide-utCodeAgentCLI-runtime-language-UserStory.md)
- Architecture doc: [../README_ArchDesign.md](../README_ArchDesign.md)
- Detail design doc: [../README_DetailDesign.md](../README_DetailDesign.md)

Follow-up:

- Keep `README_ArchDesign.md` and `README_DetailDesign.md` aligned with the final runtime choice.
- After review, either confirm the selected language or revise this ADR if the evidence favors a different tradeoff.