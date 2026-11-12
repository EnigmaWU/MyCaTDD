# specCodeAgentCLI

`specCodeAgentCLI` represents the SpecCoding-oriented CLI code-agent layer in the CaTDD stack.

This README is the WHAT / WHY entry point for this layer. It intentionally keeps the scope realistic: the directory documents the intended contract and architectural boundary, but the implementation is still an incremental target rather than a finished production CLI.

## What

`specCodeAgentCLI` is the layer responsible for turning a spec-driven workflow into a structured, executable module flow.

It is the repository's unified SpecCoding-oriented agent layer:

- It operates directly from `methodPrompts` and `slashCommands` with zero runtime or architectural dependency on the deprecated `utCodeAgentCLI`.
- It is aligned to `Px-SpecFlow` and the project-level lifecycle discipline in the resolved `metaspec_root` (`.catdd/metaspec/` by default, with `.agents/metaspec/` and legacy `.catdd/spec/` supported).
- It translates product/story intent into ordered action sequences, validation checkpoints, and traceable outcomes across `SPEC_*`, orchestrated `TEST_*`, and status/harness commands.
- It keeps spec flow, review gates, and result evidence aligned instead of letting them drift into loose documentation or ad hoc execution.

At the current repository stage, this directory is documenting the intended layer contract rather than shipping a full runnable implementation. It is a design and planning boundary, not yet a complete product runtime.

## Why

`specCodeAgentCLI` exists to make the SpecCoding layer first-class as a single unified CLI runner rather than splitting lifecycle orchestration from unit-test execution.

It keeps a clear execution boundary:

- `methodPrompts` owns the method semantics, category meaning, and verification design contract.
- `slashCommands` owns portable flow commands (`SPEC_*`, `TEST_*`, `HARNESS_*`) and lifecycle steps.
- `specCodeAgentCLI` owns unified CLI orchestration: driving `Px-SpecFlow` in `autonomousMode` or `manualMode`, sequencing story and test steps, enforcing review/commit gates, and maintaining traceability across the lifecycle flow.
- `utCodeAgentCLI` is deprecated and kept only as historical reference; `specCodeAgentCLI` does not delegate to or depend on it.

This split matters because project-level flow discipline and category-level test execution belong in one coherent CaTDD-native runner backed directly by `methodPrompts` and `slashCommands`.

## CaTDD-native contract

The CLI implementation must be based directly on the canonical upstream layers:

- `methodPrompts` provides the language-agnostic CaTDD method contract.
- `slashCommands` provides the reusable `SPEC_*`, `TEST_*`, and `HARNESS_*` commands and flow steps.
- `specCodeAgentCLI` adds mode-aware (`autonomousMode` vs `manualMode`) CLI execution, plan-driven progression, `ONE-MORE-THING` halt governance, and traceable output contracts.

## Execution Mode Contract

`specCodeAgentCLI` is a flow driver, so it runs Px-SpecFlow in `autonomousMode` by default:

- The runner declares its mode explicitly instead of relying on the absence of a chat window; the declared value is recorded in `*-UserStory-Tasks.md` and carried to later steps.
- `autonomousMode` is only a default, never an exemption. `SPEC_makePlan` still classifies orientation, and intent-clearing, requirement-oriented, or design-oriented stories halt back to `manualMode` for human confirmation.
- The runner calls the next `SPEC_doXYZ` itself, takes `SPEC_commitStepWorks` at the step boundaries `SPEC_makePlan` planned, and makes the final `SPEC_commitStoryWorks` commits at `pre_close` and `post_close`.
- A question that cannot be answered from artifacts halts the run through `ONE-MORE-THING` with a structured `manual_required` inquiry; the runner never guesses.
- A discipline switch is not available headlessly. VibeCoding needs a human intent source, so when the flow cannot name what is wrong the run halts and the developer chooses `ASK`, abort, or `SPEC_whatsWrong` in `manualMode`.
- When the run hands control back to a human, it records the mode change so the artifacts never claim an autonomy that is no longer active.
- `specCodeAgentCLI` adds higher-level workflow sequencing, lifecycle observability, and module-oriented execution planning.

It may target many programming languages, but it must preserve the repository's comment-alive verification design and CaTDD story traceability.

## Typical contents

The layer is expected to contain some or all of the following as the design and implementation matures:

- standalone spec-flow and lifecycle docs for the module layer
- runnable CLI entry points for story-centered execution
- module-level plan builders and task sequencing logic
- command wrappers or adapters that route to portable `SPEC_*` steps
- lifecycle state capture and trace generation for story progression
- validation summaries that connect committee-level flow progress to concrete evidence
- future integration hooks for review, implementation, and project-level diagnosis

## Upstream / Downstream

- Upstream inputs:
  - `methodPrompts` for methodological constraints and category semantics
  - `slashCommands` for portable `SPEC_*`, `TEST_*`, and `HARNESS_*` command contracts and lifecycle checks
- Separate generic CodeAgent packaging:
  - `agentSkills` helps common CodeAgents use CaTDD patterns, but this layer should not depend on it by default
- Deprecated sibling reference:
  - `utCodeAgentCLI` is deprecated; `specCodeAgentCLI` has no runtime or design dependency on it
- Downstream outputs:
  - structured story execution
  - lifecycle and review evidence
  - traceable verification checkpoints
  - feedback into methods and command flows for improvement

## Documentation boundary

Keep the documentation split clear:

| File | Owns |
| --- | --- |
| `README.md` / `README_ZH.md` | WHAT this layer is and WHY it exists. |
| `README_UsageDesign.md` / `README_UsageDesign_ZH.md` | Public bash CLI synopsis, `autonomousMode` vs `manualMode` invocation contract, options, stdout/stderr, exit codes, and scenario traces. |
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW, WHO, WHEN, and WHERE to design or operate `specCodeAgentCLI`. |
| `README_UserStory.md` / `README_UserStory_ZH.md` | WHO this layer serves and which module-flow scenarios it should satisfy. |
| `README_ArchDesign.md` / `README_ArchDesign_ZH.md` | Module architecture, workflow boundaries, and orchestrator responsibilities. |
| `README_DetailDesign.md` / `README_DetailDesign_ZH.md` | Concrete contracts, state transitions, and execution sequencing decisions. |
| `README_VerifyDesign.md` | Validation strategy and test-plan logic for the SpecCoding layer. |
| `src/` / `tests/` | Incremental product implementation and executable verification. |

Current reality: most of these artifacts are intentionally future-facing. The layer is planned, but not yet fully implemented or validated.

## Maintenance rule

When recurring spec-flow patterns emerge, formalize them here.

When those patterns stabilize as reusable prompt steps or command flows, feed them back into `slashCommands` and `methodPrompts`.

The design goal is simple: keep the module-level SpecCoding layer explicit, bounded, and traceable instead of letting it become an informal wrapper around unit-test execution.
