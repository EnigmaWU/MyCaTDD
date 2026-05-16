# methodPrompts

This directory contains method-level prompt assets for CaTDD.

## Role in the 4-layer model

`methodPrompts` is the source-of-truth methodology layer.

- It defines how to design and execute CaTDD workflows.
- It is human-readable and LLM-friendly.
- It should be stable, explicit, and reusable across tools.

## Stage model

CaTDD method prompts support two design stages:

- **Stage-0: Freely Drafting** - capture raw scenarios, risks, examples, and open questions without forcing structure too early.
- **Stage-1: Classifying Design** - classify drafts into CaTDD categories and convert them into US/AC/TC verification design.

Default classification order:

- P1 Functional: Typical -> Edge -> Misuse -> Fault
- P2 Design: State -> Capability -> Concurrency
- P3 Quality: Performance -> Robust -> Compatibility -> Configuration
- P4 Addons: Demo/Example

## Typical contents

- Master method specification (`CaTDD_DesignPrompt.md`)
- Category-specific design prompts (`CaTDD_DesignPrompt4Cat-*.md`)
- User guide (`CaTDD_UserGuide.md`)
- Presentation summary (`CaTDD-UserGuide-PPT*.md`)
- Implementation template (`CaTDD_ImplTemplate.cxx`)

## Prompt map

Use this map when selecting a method prompt:

| Need | Use |
| --- | --- |
| Learn or explain the whole CaTDD method | `CaTDD_DesignPrompt.md` |
| Design core happy-path behavior | `CaTDD_DesignPrompt4Cat-Typical.md` |
| Design valid edge cases, limits, and boundary values | `CaTDD_DesignPrompt4Cat-Edge.md` |
| Design wrong API usage or invalid caller behavior | `CaTDD_DesignPrompt4Cat-Misuse.md` |
| Design dependency, resource, or environment failure handling | `CaTDD_DesignPrompt4Cat-Fault.md` |
| Design lifecycle and FSM verification | `CaTDD_DesignPrompt4Cat-State.md` |
| Design capacity and maximum ability verification | `CaTDD_DesignPrompt4Cat-Capability.md` |
| Design thread-safety or race-condition verification | `CaTDD_DesignPrompt4Cat-Concurrency.md` |
| Write a C++ comment-alive test file | `CaTDD_ImplTemplate.cxx` |

## Upstream / Downstream

- Upstream input: real project experience and lessons learned.
- Downstream consumers:
  - `slashCommands` (commandized method steps)
  - `utCodeAgentCLI` (agent execution constraints)
  - `agentSkill` (packaged reusable capability)

## Maintenance rule

When method intent changes, update this directory first, then propagate to the other 3 layers.
