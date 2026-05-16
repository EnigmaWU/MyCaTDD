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

## Typical contents

- Command prompt files for specific CaTDD phases
- Parameterized command templates
- Examples of invocation patterns

## Upstream / Downstream

- Upstream input: `methodPrompts` (method definitions)
- Downstream consumers:
  - `utCodeAgentCLI` (agent pipelines calling commands)
  - Developers using assistant GUI/chat mode
  - Any compatible code assistant, such as Copilot, Cline, Continue, or similar tools

## Maintenance rule

When a method step becomes high-frequency and stable, extract it here as a slash command.
