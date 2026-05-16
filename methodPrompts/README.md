# methodPrompts

This directory contains method-level prompt assets for CaTDD.

## Role in the 4-layer model

`methodPrompts` is the source-of-truth methodology layer.

- It defines how to design and execute CaTDD workflows.
- It is human-readable and LLM-friendly.
- It should be stable, explicit, and reusable across tools.
- It is programming-language agnostic; language-specific files are examples or implementation templates, not method limits.

## Consumer contract

Downstream tools should treat this directory as the stable CaTDD method contract:

- **Developers** read it to understand the method and fill comment-alive design skeletons by hand.
- **CodeAgents** read it to classify scenarios, preserve US/AC/TC comments, and generate tests without changing method intent.
- **slashCommands** can extract high-frequency method steps from it into command prompts for any code assistant, such as Copilot, Cline, Continue, or similar tools.
- **utCodeAgentCLI** can use it as the CaTDD-native methodology base, then combine it with `slashCommands` for deeper planning and execution.

Do not encode one programming language, one code-agent product, or one project module as a method requirement here.

## Stage model

CaTDD method prompts support two design stages:

- **Stage-0: Freely Drafting** - capture raw scenarios, risks, examples, and open questions without forcing structure too early.
- **Stage-1: Classifying Design** - classify drafts into CaTDD categories and convert them into US/AC/TC verification design.

Default classification order:

- P0 Functional: Typical -> Edge -> Misuse -> Fault
- P1 Design: State -> Capability -> Concurrency
- P2 Quality: Performance -> Robust -> Compatibility -> Configuration
- P3 Addons: Demo/Example

## Typical contents

- Master method specification (`CaTDD_methodPrompt.md`)
- Category-specific method prompts (`CaTDD_methodPrompt4Cat-*.md`)
- Root user guide (`../README_UserGuide.md`)
- Presentation summary (`CaTDD-UserGuide-PPT*.md`)
- Implementation template (`CaTDD_ImplTemplate.cxx`)

## Prompt map

Use this map when selecting a method prompt:

| Need | Use |
| --- | --- |
| Learn the user-facing workflow first | `../README_UserGuide.md` |
| Learn or explain the whole CaTDD method | `CaTDD_methodPrompt.md` |
| Design core happy-path behavior | `CaTDD_methodPrompt4Cat-Typical.md` |
| Design valid edge cases, limits, and boundary values | `CaTDD_methodPrompt4Cat-Edge.md` |
| Design wrong API usage or invalid caller behavior | `CaTDD_methodPrompt4Cat-Misuse.md` |
| Design dependency, resource, or environment failure handling | `CaTDD_methodPrompt4Cat-Fault.md` |
| Design lifecycle and FSM verification | `CaTDD_methodPrompt4Cat-State.md` |
| Design capacity and maximum ability verification | `CaTDD_methodPrompt4Cat-Capability.md` |
| Design thread-safety or race-condition verification | `CaTDD_methodPrompt4Cat-Concurrency.md` |
| Design speed, latency, throughput, or resource-use checks | `CaTDD_methodPrompt4Cat-Performance.md` |
| Design stress, repetition, soak, or stability checks | `CaTDD_methodPrompt4Cat-Robust.md` |
| Design cross-platform, version, or integration compatibility checks | `CaTDD_methodPrompt4Cat-Compatibility.md` |
| Design configuration, feature-flag, or environment-variable checks | `CaTDD_methodPrompt4Cat-Configuration.md` |
| Design documentation-oriented demos and examples | `CaTDD_methodPrompt4Cat-DemoExample.md` |
| Write a C++ comment-alive test file | `CaTDD_ImplTemplate.cxx` |

## Upstream / Downstream

- Upstream input: real project experience and lessons learned.
- Downstream consumers:
  - `slashCommands` (commandized method steps)
  - `utCodeAgentCLI` (agent execution constraints)
  - `agentSkill` (packaged reusable capability)

## Maintenance rule

When method intent changes, update this directory first, then propagate to the other 3 layers.
