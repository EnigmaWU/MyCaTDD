---
description: "Run CaTDD slash command TEST_designCapabilitySkeleton"
agent: "agent"
argument-hint: "Fill required command inputs, source files, target files, language, and test framework"
---
# TEST_designCapabilitySkeleton

You are running a Copilot-native wrapper around a portable CaTDD slash command.

## Source Command

- Portable command path: slashCommands/commands/P1-DesignTestsFlow/TEST_designCapabilitySkeleton.md
- Default workspace link: [slashCommands/commands/P1-DesignTestsFlow/TEST_designCapabilitySkeleton.md](../../slashCommands/commands/P1-DesignTestsFlow/TEST_designCapabilitySkeleton.md)
- Flow or kit: P1-DesignTestsFlow

## Method Source of Truth

- CaTDD method index: [methodPrompts/README.md](../../methodPrompts/README.md)
- Slash command contract: [slashCommands/TEST_slashCommandTemplate.md](../../slashCommands/TEST_slashCommandTemplate.md)
- Flow docs: [slashCommands/flows](../../slashCommands/flows)
- Kit docs: [slashCommands/kits](../../slashCommands/kits)

## Execution Rules

1. Read and follow the portable source command before acting.
2. Treat this file as a thin Copilot adapter; do not redefine CaTDD method semantics here.
3. Use methodPrompts for category meaning, priority order, design skeleton rules, and CaTDD constraints.
4. Use the source command for inputs, outputs, conflict guards, and next-step flow or kit contract.
5. Ask for missing product intent instead of inventing requirements.
6. Report the next recommended slash command when the step finishes.

ONE-MORE-THING: ask developer if something not sure
