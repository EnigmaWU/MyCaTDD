# slashCommands Command Templates

This directory contains reusable command templates. Each command is a small prompt unit that can be invoked by a developer, GUI assistant, or `utCodeAgentCLI`.

All commands should follow [../UT_slashCommandTemplate.md](../UT_slashCommandTemplate.md) so Copilot, Cline, Continue, `utCodeAgentCLI`, and similar assistants can consume the same command contract.

## Command Groups

- [Px-SpecFlow](Px-SpecFlow): SpecCoding lifecycle for project context, work items, user stories, design, tests, product code, review, CI, and closure.
- [P0-FuncTestsFlow](P0-FuncTestsFlow): first imported flow for functional test skeleton and TC implementation.
- [P1-DesignTestsFlow](P1-DesignTestsFlow): design test skeleton flow for State, Capability, and Concurrency.
- [P2-QualityTestsFlow](P2-QualityTestsFlow): quality test skeleton flow for Performance, Robust, Compatibility, and Configuration.

## Contract

Commands may orchestrate work, request inputs, and define output shape. They must not redefine CaTDD category meaning. Use `methodPrompts` as the source of truth.

- `SPEC_*` commands are SpecCoding lifecycle commands.
- `UT_*` commands are unit-test design and implementation commands.
