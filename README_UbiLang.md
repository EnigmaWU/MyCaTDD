# CaTDD Ubiquitous Language

This file defines the project-root vocabulary that CaTDD installers distribute to target projects.
It is the canonical meaning contract for terms that must stay consistent across method prompts, slash commands, code agents, and generated adapters.

## Who

- Method maintainers evolving `methodPrompts/`.
- Flow maintainers evolving `slashCommands/`.
- Code-agent maintainers evolving `codeAgents/` and `agentSkills/`.
- Project teams installing CaTDD into their repositories.

## What

This is the shared glossary for CaTDD execution environments.

### Core Concepts

| Term | Meaning |
| --- | --- |
| CaTDD | Comment-alive Test-Driven Development. |
| Comment-alive | Verification intent is explicitly encoded in structured comments before code generation. |
| US / AC / TC | User Story / Acceptance Criteria / Test Case traceability chain. |
| Skeleton | Comment-only test design artifact containing traceability markers and planned test intent. |
| RED | Executable failing test state before product-code changes. |
| GREEN | Passing test state after product-code changes. |
| SpecCoding | CaTDD workflow that treats verification design artifacts as the executable spec lifecycle. |
| VibeCoding | Fast ideation/prototyping mode; results should still be reconciled back into CaTDD traceability. |

### Category Vocabulary

| Tier | Categories |
| --- | --- |
| P0 Functional | Typical, Edge, Misuse, Fault |
| P1 Design | State, Capability, Concurrency |
| P2 Quality | Performance, Robust, Compatibility, Configuration |

### Ownership Vocabulary

| Layer | Responsibility |
| --- | --- |
| `methodPrompts/` | Source of truth for category semantics and CaTDD method constraints. |
| `slashCommands/` | Portable command/flow wrappers over method semantics. |
| `codeAgents/` | Goal-driven orchestration and execution policy. |
| `agentSkills/` | Packaged skills for non-native code agents. |

## When

Use this glossary when:

- defining new terms in READMEs, prompts, rules, or architecture docs,
- naming new UT_*/SPEC_* commands,
- reviewing wording drift across EN/ZH or across adapters,
- installing CaTDD into a new project.

## Where

- Source of truth in this repository: `README_UbiLang.md` (project root).
- Installed destination in target projects: `<target>/README_UbiLang.md`.
- Referenced by installed rules/instructions (`.github/instructions`, `.continue/rules`, `.clinerules`, `.antigravityrules`, and custom adapter rules).

## Why

CaTDD is method-driven. If key words drift, behavior drifts.

A shared ubiquitous language keeps generated prompts, command flows, review output, and implementation decisions aligned across different code-agent runtimes.

## How

1. Add new domain terms here before spreading them to other docs.
2. Keep wording stable for status/category names used by tools.
3. Reject synonyms that change semantics (for example, do not rename categories casually).
4. During installer updates, ensure this file is copied to target project root.

## Usage Example

Check vocabulary consistency before release:

```bash
rg -n "Typical|Edge|Misuse|Fault|State|Capability|Concurrency|Performance|Robust|Compatibility|Configuration|US/AC/TC|SpecCoding|VibeCoding" README*.md methodPrompts slashCommands codeAgents agentSkills
```

Expected result: terms are used with the same meanings as defined in this file.
