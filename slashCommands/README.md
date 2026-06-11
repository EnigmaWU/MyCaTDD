# slashCommands

`slashCommands` contains reusable slash-command prompts and flows that operationalize CaTDD methods.

This README is the WHAT / WHY entry point for the command connector layer. For HOW, WHO, WHEN, and WHERE to use `slashCommands/`, read [README_UserGuide.md](README_UserGuide.md) or [README_UserGuide_ZH.md](README_UserGuide_ZH.md).

## What

`slashCommands` is the flow-oriented connector and commandization layer between `methodPrompts` and existing CodeAgents.

It defines portable command intent and flow order for automated or semi-automated CaTDD execution:

- Flow documents that arrange repeatable command phases.
- Small command prompt templates that describe one action at a time.
- A shared command template that keeps portable prompts consistent.
- SpecCoding flow contracts that move from project context to completed stories.
- Functional, design, and quality test flows aligned with CaTDD priority classes.

`slashCommands` is code-agent agnostic. The same portable command files can be wrapped for Copilot, Cline, Continue, `utCodeAgentCLI`, or any assistant that can consume prompt text.

## Why

`slashCommands` exists so stable CaTDD method steps can be invoked repeatably without duplicating method semantics in every CodeAgent adapter.

It keeps a clean separation:

- `methodPrompts` owns CaTDD method meaning, category semantics, priority order, and design skeleton rules.
- `slashCommands` owns portable flow intent, command order, and execution handoff between steps.
- Native adapters own only tool-specific exposure, such as Copilot prompt files, Continue prompt files, Cline rules, or CLI integration.

This prevents every tool integration from inventing its own CaTDD workflow while still allowing each tool to expose commands in its native shape.

## SpecCoding contract

`slashCommands` is CaTDD's Spec-Driven Development-style workflow layer. It is not a loose collection of prompt shortcuts.

- The governing spec is comment-alive verification design from `methodPrompts`.
- Flow commands move a developer and CodeAgent through repeatable phases: convert or design skeletons, review skeletons, select the next TC, implement one TC, and review the implementation.
- Living artifacts are US/AC/TC comments, category labels, priority gates, TC status markers, test files, and SpecFlow state under `.catdd/spec/`.
- Command files describe what to do now, what to read, what to produce, what to preserve, and what command should come next.

In CaTDD terminology, using `methodPrompts` directly in CodeAgent chat is **VibeCoding**: flexible, method-guided conversation. Using `slashCommands` is **SpecCoding**: structured Spec-Driven Development flow based on the same method definitions.

## Layer boundary

`slashCommands` should behave as an adapter layer, not as a second methodology layer.

- It does not redefine CaTDD category meaning.
- It does not replace `methodPrompts`.
- It does not depend on one editor, one model provider, or one programming language.
- It does not make native generated wrapper files the source of truth.

When a command conflicts with `methodPrompts`, update `methodPrompts` first, then revise or regenerate the command layer.

## Priority contract

Slash command flow priority uses the same Pn numbering as the CaTDD class priority defined in `methodPrompts`, starting from `P0`.

- **P0 = FuncTestsFlow**: functional test flow for Typical, Edge, Misuse, and Fault skeletons. It is CaTDD `P0 Functional`.
- **P1 = DesignTestsFlow**: design-oriented flow for State, Capability, and Concurrency skeletons. It is CaTDD `P1 Design`.
- **P2 = QualityTestsFlow**: quality-oriented flow for Performance, Robust, Compatibility, and Configuration skeletons. It is CaTDD `P2 Quality`.

Future addon/demo commands should use `P3 Addons` to stay aligned with `methodPrompts`.

## Traceability and SUT constraints

- `SPEC_designUnitTests` and related `UT_design*Skeleton` commands should enforce minimum traceability cardinality: each US has at least 1 AC, and each AC has at least 1 TC.
- Test design outputs must explicitly declare the SUT in the test-file overview (for example: `SUT: utCodeAgentCLI`).
- Outputs with dangling traceability (US without AC or AC without TC) should be blocked from being marked complete.

## Typical contents

- Standalone user guides (`README_UserGuide.md`, `README_UserGuide_ZH.md`)
- Flow documents under `flows/`
- Shared command template [UT_slashCommandTemplate.md](UT_slashCommandTemplate.md)
- Command prompt templates under `commands/`
- Compatibility notes that prevent conflicts with `methodPrompts`

## Upstream / Downstream

- Upstream input: `methodPrompts` method definitions.
- Downstream consumers:
  - Native adapter generators for Copilot and Continue.
  - Installers for Copilot, Continue, and Cline target projects.
  - `utCodeAgentCLI` agent pipelines calling command units.
  - Developers using assistant GUI/chat mode.
  - Any compatible code assistant that can consume prompt text.

## Documentation boundary

Keep the documentation split clear:

| File | Owns |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT this layer contains and WHY it exists. |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW to use it, WHO uses it, WHEN to use it, WHERE installed assets live, and a copy-exec `Usage Example`. |

Operational generator commands, installer commands, flow maps, and command maps belong in the standalone user guides, not in this README.

## Maintenance rule

When a method step becomes high-frequency and stable, extract it here as a slash command.

When command behavior changes, keep portable command files as the source, then regenerate native adapters for target tools.
