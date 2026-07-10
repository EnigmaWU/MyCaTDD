# slashCommands Kits

This directory records operational command kits for CaTDD slash commands.

Kits group related tool-point commands without requiring a strict lifecycle sequence or SpecFlow state transition. They sit beside `flows/`, whose documents define ordered command workflows.

## Kit List

- [Px-HarnessKits.md](Px-HarnessKits.md)

## Import Rule

Kit documents may describe command families, operational guards, and reusable tool-point tasks, but they must not redefine CaTDD category semantics, priority order, or skeleton design rules. Category meaning stays in `methodPrompts/CaTDD_methodPrompt4Cat-*.md`.

`HARNESS_*` commands may inspect and maintain operational harness assets, but they must not move SpecFlow lifecycle state unless explicitly invoked by a `SPEC_*` command.