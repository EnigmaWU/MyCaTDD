# slashCommands

This directory contains reusable slash-command prompts that operationalize CaTDD methods.

## Role in the 4-layer model

`slashCommands` is the commandization layer between method docs and full agent automation.

- It turns method chunks into triggerable command units.
- It reduces invocation cost for GUI or chat-driven workflows.
- It improves consistency when applying the method repeatedly.
- It is code-agent agnostic; commands should be usable by Copilot, Cline, Continue, or any assistant that can consume prompt text.

## Portability contract

Slash commands should not depend on one editor, one model provider, or one programming language.

- Source of method truth: `methodPrompts`
- Command form: small, triggerable, parameterized prompt units
- Expected consumers: human developers, GUI/chat assistants, and `utCodeAgentCLI`
- Stability rule: when a command conflicts with `methodPrompts`, update `methodPrompts` first and regenerate or revise the command.

## Template contract

All concrete slash commands should follow [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md).

The template uses a 5W1H structure and plain Markdown so command text stays portable across Copilot, Cline, Continue, `utCodeAgentCLI`, and similar assistants.

## Priority contract

Slash command flow priority uses the same Pn numbering as the CaTDD class priority defined in `methodPrompts`, starting from `P0`.

- **P0 = FuncTestsFlow**: functional test flow for Typical, Edge, Misuse, and Fault skeletons. It is CaTDD `P0 Functional`.
- **P1 = DesignTestsFlow**: design-oriented flow for State, Capability, and Concurrency skeletons. It is CaTDD `P1 Design`.
- **P2 = QualityTestsFlow**: quality-oriented flow for Performance, Robust, Compatibility, and Configuration skeletons. It is CaTDD `P2 Quality`.

Future addon/demo commands should use `P3 Addons` to stay aligned with `methodPrompts`.

## Developer entry points

Use slash commands when a developer has one of these starting points:

- Existing demo tests and wants to convert them into CaTDD functional skeletons.
- A defined interface or protocol and wants to design a Typical skeleton before implementation.
- Existing Typical, Edge, Misuse, Fault, or later category skeletons and wants to select and implement the next test case.

## Flow map

| Flow | Purpose | Start here |
| --- | --- | --- |
| P0 FuncTestsFlow | Convert or design functional test skeletons, then implement TC-by-TC | [flows/P0-FuncTestsFlow.md](flows/P0-FuncTestsFlow.md) |
| P1 DesignTestsFlow | Extend stable functional coverage into State, Capability, and Concurrency | [flows/P1-DesignTestsFlow.md](flows/P1-DesignTestsFlow.md) |
| P2 QualityTestsFlow | Extend stable behavior into Performance, Robust, Compatibility, and Configuration | [flows/P2-QualityTestsFlow.md](flows/P2-QualityTestsFlow.md) |

## Command map

| Developer need | Command template |
| --- | --- |
| Create or revise a portable UT slash command | [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md) |
| Convert demo tests into CaTDD Typical skeleton | [commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md](commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md) |
| Design Typical, Edge, Misuse, or Fault skeleton from interface/protocol | [commands/P0-FuncTestsFlow/UT_designCatSkeleton.md](commands/P0-FuncTestsFlow/UT_designCatSkeleton.md) |
| Review the functional skeleton set before implementation | [commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md](commands/P0-FuncTestsFlow/UT_reviewFuncTestsSkeleton.md) |
| Select the next test case from existing skeletons | [commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md](commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md) |
| Implement the selected test case | [commands/P0-FuncTestsFlow/UT_implTestCase.md](commands/P0-FuncTestsFlow/UT_implTestCase.md) |
| Review the implemented test case | [commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md](commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md) |

## Typical contents

- Flow documents under `flows/`
- Shared command template [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md)
- Command prompt templates under `commands/`
- Parameterized invocation examples
- Compatibility notes that prevent conflicts with `methodPrompts`

## Upstream / Downstream

- Upstream input: `methodPrompts` (method definitions)
- Downstream consumers:
  - `utCodeAgentCLI` (agent pipelines calling commands)
  - Developers using assistant GUI/chat mode
  - Any compatible code assistant, such as Copilot, Cline, Continue, or similar tools

## Maintenance rule

When a method step becomes high-frequency and stable, extract it here as a slash command.
