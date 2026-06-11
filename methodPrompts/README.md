# methodPrompts

`methodPrompts` contains method-level prompt assets for CaTDD.

This README is the WHAT / WHY entry point for the method layer. For HOW, WHO, WHEN, and WHERE to use `methodPrompts/` standalone, read [README_UserGuide.md](README_UserGuide.md) or [README_UserGuide_ZH.md](README_UserGuide_ZH.md).

## What

`methodPrompts` is the source-of-truth methodology layer in the CaTDD 4-layer model.

It defines the stable CaTDD method contract:

- Master method specification for comment-alive verification design.
- Category-specific method prompts for P0/P1/P2/P3 test design priorities.
- Standalone user guides for people and CodeAgents who use only this directory.
- A C++ implementation template that demonstrates the method shape without making C++ a method requirement.

The layer is human-readable, LLM-friendly, programming-language agnostic, and reusable across code-agent tools.

## Why

`methodPrompts` exists to keep CaTDD method intent independent from any single workflow adapter, code-agent product, programming language, or project module.

Downstream layers should treat this directory as the stable method contract:

- **slashCommands** commandize high-frequency method steps for assistants such as Copilot, Cline, Continue, or similar tools.
- **utCodeAgentCLI** can use it as the CaTDD-native methodology base, then combine it with `slashCommands` for deeper planning and execution.
- **agentSkills** packages it as a reusable capability for code agents.

When method intent changes, this layer changes first so every downstream layer inherits the same CaTDD meaning.

## Stage model

CaTDD method prompts support two design stages:

- **Stage-0: Freely Drafting** - capture raw scenarios, risks, examples, and open questions without forcing structure too early.
- **Stage-1: Classifying Design** - classify drafts into CaTDD categories and convert them into US/AC/TC verification design.

Default classification order:

- P0 Functional: Typical -> Edge -> Misuse -> Fault
- P1 Design: State -> Capability -> Concurrency
- P2 Quality: Performance -> Robust -> Compatibility -> Configuration
- P3 Addons: Demo/Example

## Mandatory traceability constraints

- P0 functional design should cover the full `Typical -> Edge -> Misuse -> Fault` set by default unless the developer explicitly limits scope.
- Each US must map to at least 1 AC.
- Each AC must map to at least 1 TC.
- Design outputs must explicitly declare the SUT in the test-file overview (for example: `SUT: utCodeAgentCLI`).

## Typical contents

- Master method specification (`CaTDD_methodPrompt.md`)
- Category-specific method prompts (`CaTDD_methodPrompt4Cat-*.md`)
- Standalone user guides (`README_UserGuide.md`, `README_UserGuide_ZH.md`)
- Implementation template (`CaTDD_designAndImplTemplate.cxx`)

## Documentation boundary

Keep the documentation split clear:

| File | Owns |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT this layer contains and WHY it exists. |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW to use it, WHO uses it, WHEN to use it, WHERE to place it, and a copy-exec `Usage Example`. |

Operational prompt-selection steps belong in the standalone user guides, not in this README.

## Upstream / Downstream

- Upstream input: real project experience and lessons learned.
- Downstream consumers:
  - `slashCommands` (commandized method steps)
  - `utCodeAgentCLI` (agent execution constraints)
  - `agentSkills` (packaged reusable capability)

## Maintenance rule

When method intent changes, update this directory first, then propagate to the other 3 layers.
