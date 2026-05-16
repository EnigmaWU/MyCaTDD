# slashCommands Command Templates

This directory contains reusable command templates. Each command is a small prompt unit that can be invoked by a developer, GUI assistant, or `utCodeAgentCLI`.

All commands should follow [../UT_slashCommandTemplate.md](../UT_slashCommandTemplate.md) so Copilot, Cline, Continue, `utCodeAgentCLI`, and similar assistants can consume the same command contract.

## Command Groups

- [P0-FuncTestsFlow](P0-FuncTestsFlow): first imported flow for functional test skeleton and TC implementation.

## Contract

Commands may orchestrate work, request inputs, and define output shape. They must not redefine CaTDD category meaning. Use `methodPrompts` as the source of truth.
