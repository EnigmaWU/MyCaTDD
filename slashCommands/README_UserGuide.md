# Slash Commands User Guide

Practical guide for developers and CodeAgents using `slashCommands/` to run CaTDD as repeatable SpecCoding workflows.

For WHAT this layer is and WHY it exists, read [README](README.md). This guide focuses on HOW to use it, WHO uses it, WHEN to choose it, and WHERE the assets live.

## Who

Use this guide if you are one of these readers:

- A developer who wants to run CaTDD through triggerable prompt commands instead of long manual chat prompts.
- A CodeAgent that needs portable command files and clear next-step flow order.
- A maintainer installing CaTDD into a Copilot, Continue, or Cline target project.
- A tooling author wrapping portable CaTDD commands for another assistant or CLI.

## What

`slashCommands/` turns stable CaTDD method steps into small command files and ordered flows.

The source of method truth remains `methodPrompts/`. The slash-command layer only says how to invoke repeatable steps, what each step should read, what it should produce, what it must preserve, and which step should come next.

## When

Use `slashCommands/` when:

- You want structured SpecCoding instead of free-form VibeCoding.
- A CaTDD method step is stable enough to become a repeatable command.
- You want Copilot, Continue, Cline, or another assistant to expose the same portable command intent.
- You are converting demo tests, designing skeletons, reviewing skeletons, selecting the next TC, implementing a TC, or reviewing an implementation.
- You are running the Px SpecFlow lifecycle from project context and work item to reviewed story completion.

Use `methodPrompts/` directly when you are still exploring method meaning or manually drafting one-off design ideas.

## Where

In this source repository, portable command assets live here:

```text
slashCommands/
  README.md
  README_ZH.md
  README_UserGuide.md
  README_UserGuide_ZH.md
  UT_slashCommandTemplate.md
  flows/
  commands/
```

In an installed target project, shared CaTDD assets live under `.catdd/`:

```text
.catdd/
  methodPrompts/
  slashCommands/
  spec/
```

Native adapter outputs live in tool-specific locations:

```text
.github/prompts/UT_*.prompt.md
.github/prompts/SPEC_*.prompt.md
.continue/rules/catdd.md
.continue/prompts/UT_*.prompt
.continue/prompts/SPEC_*.prompt
.clinerules/catdd.md
```

## Why

The command layer reduces repeated prompting cost and keeps CodeAgent execution consistent without copying CaTDD method definitions into every tool adapter.

It also protects the method boundary: `methodPrompts` owns CaTDD meaning, `slashCommands` owns flow execution, and native wrappers stay thin and regenerable.

## How

Follow this workflow when using `slashCommands/`.

1. Read [README](README.md) for the WHAT/WHY layer contract.
2. Choose a flow from the Flow Map below.
3. Read the flow document to understand the command order and expected handoff.
4. If using a target project, install CaTDD with the adapter script for your CodeAgent.
5. Trigger the generated native prompt wrapper, or paste the portable command file into your assistant.
6. Let the command update only the artifact it owns for that step.
7. Preserve US/AC/TC comments, category labels, priority gates, and TC status markers.
8. Continue with the next command named by the current command or flow document.

## Usage Example

Run these commands from the MyCaTDD repository root to install slash-command assets into a temporary Copilot-style target project:

```bash
TARGET_DIR="$(mktemp -d)"
scripts/installCaTDD4Copilot.sh --target "$TARGET_DIR" --clean-prompts
test -f "$TARGET_DIR/.catdd/slashCommands/README_UserGuide.md"
test -f "$TARGET_DIR/.github/prompts/UT_convertDemoToTypical.prompt.md"
echo "$TARGET_DIR"
```

Expected result:

- `.catdd/slashCommands/` contains the portable command source.
- `.catdd/methodPrompts/` contains the method source of truth.
- `.github/prompts/` contains Copilot-native thin wrappers generated from the portable commands.
- The printed temporary path can be inspected and then removed when no longer needed.

## Native Adapter Generation

Generate Copilot-native wrappers from portable `SPEC_*` and `UT_*` command files:

```bash
scripts/makeSlashCmd4Copilot.sh --clean
```

Validate the Copilot generator:

```bash
bash scripts/test_makeSlashCmd4Copilot.sh
```

Install or refresh CaTDD into another Copilot-enabled project:

```bash
scripts/installCaTDD4Copilot.sh --target /path/to/project --clean-prompts
```

Generate Continue-native wrappers:

```bash
scripts/makeSlashCmd4Continue.sh --clean
```

Install or refresh CaTDD into Continue or Cline projects:

```bash
scripts/installCaTDD4Continue.sh --target /path/to/project
scripts/installCaTDD4Cline.sh --target /path/to/project
```

Validate installer and generator behavior:

```bash
bash scripts/test_installCaTDD4Copilot.sh
bash scripts/test_makeSlashCmd4Continue.sh
bash scripts/test_installCaTDD4Continue.sh
bash scripts/test_installCaTDD4Cline.sh
```

## SpecCoding Artifact Policy

UserGuide keeps this short. The detailed artifact policy is defined in [flows/Px-SpecFlow.md](flows/Px-SpecFlow.md).

Quick rules:

- Team-shared lifecycle state lives under `.catdd/spec/` and should be committed: `.catdd/spec/doingUS/`, `.catdd/spec/suspendUS/`, `.catdd/spec/abortUS/`, and other lifecycle directories.
- Team-shared `README*` SPEC docs live in the project root and should be committed.
- Local process trace stays gitignored: `.catdd/spec/WorkingProcessLog.md`.
- If policy details and this guide ever diverge, follow [Px-SpecFlow](flows/Px-SpecFlow.md) as the source of detailed lifecycle rules.

## Flow Map

| Flow | Purpose | Start here |
| --- | --- | --- |
| Px SpecFlow | Drive SpecCoding from project context and work item to reviewed, committed story | [Px-SpecFlow](flows/Px-SpecFlow.md) |
| P0 FuncTestsFlow | Convert or design functional test skeletons, then implement TC-by-TC | [P0-FuncTestsFlow](flows/P0-FuncTestsFlow.md) |
| P1 DesignTestsFlow | Extend stable functional coverage into design-gated State, Capability, and Concurrency skeletons | [P1-DesignTestsFlow](flows/P1-DesignTestsFlow.md) |
| P2 QualityTestsFlow | Extend stable behavior into Performance, Robust, Compatibility, and Configuration | [P2-QualityTestsFlow](flows/P2-QualityTestsFlow.md) |

## Command Map

Key commands only. For full flow-specific command maps, use [Px-SpecFlow](commands/Px-SpecFlow/README.md), [P0-FuncTestsFlow](flows/P0-FuncTestsFlow.md), [P1-DesignTestsFlow](flows/P1-DesignTestsFlow.md), and [P2-QualityTestsFlow](flows/P2-QualityTestsFlow.md).

| Developer need | Command template |
| --- | --- |
| Create or revise a portable SPEC slash command | [SPEC_slashCommandTemplate](SPEC_slashCommandTemplate.md) |
| Create or revise a portable UT slash command | [UT_slashCommandTemplate](UT_slashCommandTemplate.md) |
| Drive a full SpecCoding lifecycle | [Px-SpecFlow](commands/Px-SpecFlow/README.md) |
| Tell me what SpecCoding task to do next | [SPEC_whatsNextTask](commands/Px-SpecFlow/SPEC_whatsNextTask.md) |
| Create checkbox TASKs and choose the next SPEC step for an opened user story | [SPEC_makePlan](commands/Px-SpecFlow/SPEC_makePlan.md) |
| Import an existing structured User Story or AC slice | [SPEC_importUserStory](commands/Px-SpecFlow/SPEC_importUserStory.md) |
| Convert demo tests into CaTDD Typical skeleton | [UT_convertDemoToTypical](commands/P0-FuncTestsFlow/UT_convertDemoToTypical.md) |
| Select the next test case from existing skeletons | [UT_tellMeNextImplTest](commands/P0-FuncTestsFlow/UT_tellMeNextImplTest.md) |
| Implement the selected test case | [UT_implTestCase](commands/P0-FuncTestsFlow/UT_implTestCase.md) |
| Review the implemented test case | [UT_reviewImplTestCase](commands/P0-FuncTestsFlow/UT_reviewImplTestCase.md) |

## Quality Checklist

Before calling a slash-command change complete, verify:

- Portable command files still point to `methodPrompts` as the method source of truth.
- Generated native wrappers are thin and regenerable.
- Flow order names the next command clearly.
- Commands preserve US/AC/TC traceability and TC status markers.
- P0/P1/P2 naming stays aligned with `methodPrompts`.
- Shared SpecCoding artifacts are separated from local work-in-progress state.

## Next Step

For method meaning, return to `methodPrompts/README_UserGuide.md` and `methodPrompts/CaTDD_methodPrompt.md`.

For execution, choose a flow from the Flow Map and run the matching native wrapper or portable command file.
