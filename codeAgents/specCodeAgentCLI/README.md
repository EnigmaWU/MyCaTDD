# specCodeAgentCLI

`specCodeAgentCLI` represents the SpecCoding-oriented CLI code-agent layer in the CaTDD stack.

This README is the WHAT / WHY entry point for this layer. It intentionally keeps the scope realistic: the directory documents the intended contract and architectural boundary, but the implementation is still an incremental target rather than a finished production CLI.

## What

`specCodeAgentCLI` is the layer responsible for turning a spec-driven workflow into a structured, executable module flow.

It is the repository's SpecCoding-oriented agent concept:

- It operates from the same upstream CaTDD sources as the rest of the repository.
- It is aligned to `Px-SpecFlow` and the project-level lifecycle discipline in `.catdd/spec/`.
- It translates product/story intent into ordered action sequences, validation checkpoints, and traceable outcomes.
- It keeps spec flow, review gates, and result evidence aligned instead of letting them drift into loose documentation or ad hoc execution.
- It complements `utCodeAgentCLI`, which focuses on unit-level validation and technical execution slices.

At the current repository stage, this directory is documenting the intended layer contract rather than shipping a full runnable implementation. It is a design and planning boundary, not yet a complete product runtime.

## Why

`specCodeAgentCLI` exists to make the SpecCoding layer first-class instead of treating it as a side effect of unit-level work.

It keeps a clear execution boundary:

- `methodPrompts` owns the method semantics, category meaning, and verification design contract.
- `slashCommands` owns portable flow commands and lifecycle steps.
- `utCodeAgentCLI` owns unit-testing-oriented execution slices and low-level validation patterns.
- `specCodeAgentCLI` owns module-level spec orchestration: sequencing story work, coordinating review/update cycles, and maintaining traceability across the lifecycle flow.

This split matters because project-level reasoning and unit-level reasoning are not the same thing. A project can have good technical validation while still having weak flow discipline, stale story state, or fuzzy integration between review, implementation, and verification. `specCodeAgentCLI` exists to reduce that gap.

## CaTDD-native contract

The CLI implementation must be based on the upstream layers:

- `methodPrompts` provides the language-agnostic CaTDD method contract.
- `slashCommands` provides the reusable SpecCoding commands and flow steps.
- `utCodeAgentCLI` provides the execution model and unit-test discipline that spec orchestration can reuse.
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
  - `slashCommands` for portable command flow and lifecycle checks
  - `utCodeAgentCLI` where shared validation patterns or runtime conventions are reused
- Separate generic CodeAgent packaging:
  - `agentSkills` helps common CodeAgents use CaTDD patterns, but this layer should not depend on it by default
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
| `README_UserGuide.md` / `README_UserGuide_ZH.md` | HOW to design or use the SpecCoding layer when it is implemented. |
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

