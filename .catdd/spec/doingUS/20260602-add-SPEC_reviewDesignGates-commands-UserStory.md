# User Story: Add SPEC_reviewArchDesign and SPEC_reviewDetailDesign portable slash commands

Created by `/SPEC_analyzeFeature` on 2026-06-03.
Opened by `/SPEC_openUserStory` on 2026-06-03.

## Source Trace

- Analyzed raw feature: [../analyzedNews/20260602-add-SPEC_reviewDesignGates-commands-Feature.md](../analyzedNews/20260602-add-SPEC_reviewDesignGates-commands-Feature.md)
- Area: `.catdd/slashCommands/commands/Px-SpecFlow/`
- Pipeline position: After architecture design and detailed design steps respectively.

## Active Work Status

- Status: OPEN.
- Active state: `.catdd/spec/doingUS/` active story.
- Opened from: [../todoUS/20260602-add-SPEC_reviewDesignGates-commands-UserStory.md](../todoUS/20260602-add-SPEC_reviewDesignGates-commands-UserStory.md)
- Next recommended command: `/SPEC_takeDetailDesign` is not needed for this command-contract story; implement the command specs and update `Px-SpecFlow.md` directly, then run `/SPEC_reviewArchDesign` on the current `utCodeAgentCLI` architecture design.

## Implementation Status

- Added command specs: `slashCommands/commands/Px-SpecFlow/SPEC_reviewArchDesign.md` and `slashCommands/commands/Px-SpecFlow/SPEC_reviewDetailDesign.md`.
- Updated flow: `slashCommands/flows/Px-SpecFlow.md` now gates `SPEC_takeArchDesign` with `SPEC_reviewArchDesign` before `SPEC_takeDetailDesign`, and gates `SPEC_takeDetailDesign` with `SPEC_reviewDetailDesign` before final `SPEC_reviewUserStory` readiness review.
- Updated discovery map: `slashCommands/commands/Px-SpecFlow/README.md` lists `SPEC_takeArchDesign`, `SPEC_reviewArchDesign`, and `SPEC_reviewDetailDesign` in sequence.
- Applied review gate: `/SPEC_reviewArchDesign` PASS recorded on `.catdd/spec/doingUS/20260530-design-utCodeAgentCLI-architecture-UserStory.md` for the current `utCodeAgentCLI` architecture design.

## Analysis Status

- Status: TODO.
- Priority: P0 — required to enforce the "review each action" philosophy for incoming design work.
- Confidence: High. The requirements and positioning of these review gates are clear.

## Observed Behavior

The current SpecFlow pipeline only has one monolithic review step `SPEC_reviewUserStory` that runs after both the architecture and detailed designs are done. In agent-driven development workflows, this delayed verification allows early design mistakes (like architectural boundary mismatch) to propagate into low-level class designs before being detected, causing significant waste and complex refactoring loops.

## Expected Behavior

Two new review slash commands are introduced into the pipeline:
1. `SPEC_reviewArchDesign` checks `README_ArchDesign.md` (and its ZH mirror) against requirements, `projectContext.md`, and industry references.
2. `SPEC_reviewDetailDesign` checks `README_DetailDesign.md` (and its ZH mirror) against `README_ArchDesign.md` and story requirements.
The SpecFlow pipeline diagram and sequence are updated to gate each design phase with these specific commands.

## User Story

As a MyCaTDD developer,
I want to add the `SPEC_reviewArchDesign` and `SPEC_reviewDetailDesign` portable slash commands,
So that every generative design action is gated and verified immediately, keeping the agent aligned and preventing downstream design errors or hallucinations.

## Independent Test Intent

A reviewer can inspect the command specifications (`SPEC_reviewArchDesign.md` and `SPEC_reviewDetailDesign.md`) and verify that they define distinct inputs, CoT patterns (ReACT), and output contracts. They can also verify that the `Px-SpecFlow.md` flow diagram and command sequence are updated to include these steps.

## Acceptance Scenarios

### AC-1: Define SPEC_reviewArchDesign command contract
- **Given** we have designed the high-level architecture using `SPEC_takeArchDesign`,
- **When** `SPEC_reviewArchDesign` is run,
- **Then** it inspects the active story, `projectContext.md`, and `README_ArchDesign.md` (both English and Chinese versions),
- **And** it outputs a review finding (PASS/REVISE) detailing module boundaries, AgentSDK decoupling, and adaptability constraints,
- **And** it prevents moving to detailed design if the review fails.

### AC-2: Define SPEC_reviewDetailDesign command contract
- **Given** we have detailed the design using `SPEC_takeDetailDesign`,
- **When** `SPEC_reviewDetailDesign` is run,
- **Then** it inspects the active story, `README_ArchDesign.md`, and `README_DetailDesign.md` (both English and Chinese versions),
- **And** it outputs a review finding (PASS/REVISE) detailing API signatures, local state models, and testability of acceptance criteria,
- **And** it prevents moving to test design if the review fails.

### AC-3: Align SpecFlow pipeline flow
- **Given** the flow file `slashCommands/flows/Px-SpecFlow.md`,
- **When** inspected,
- **Then** it shows `SPEC_reviewArchDesign` positioned after `SPEC_takeArchDesign` and before `SPEC_takeDetailDesign`,
- **And** it shows `SPEC_reviewDetailDesign` positioned after `SPEC_takeDetailDesign` and before `SPEC_designUnitTests`,
- **And** the Mermaid flow diagram and command sequence are updated to reflect these new gates.

### AC-4: Keep existing SPEC_reviewUserStory as a final readiness check
- **Given** the new intermediate design gates are in place,
- **When** the pipeline is evaluated,
- **Then** `SPEC_reviewUserStory` is retained as a final checklist-style readiness check before entering test skeleton design, validating overall story completeness and traceability.

## Scope

In scope:
- Create `SPEC_reviewArchDesign.md` command specification under `slashCommands/commands/Px-SpecFlow/`.
- Create `SPEC_reviewDetailDesign.md` command specification under `slashCommands/commands/Px-SpecFlow/`.
- Update `slashCommands/flows/Px-SpecFlow.md` description, Mermaid diagram, and command sequence.
- Verify prompt-wrapper generation and target-project installation.

Out of scope:
- Performing the actual reviews for any active user story.
- Implementing the execution logic of the review gates inside a concrete runner.

## Risks

- Adding more gates increases flow overhead. If the review commands are too slow or verbose, they may hinder developer velocity.

## Assumptions

- We will use the ReACT pattern for both review commands, as review actions require reasoning about current design files, checking checklist items, and reporting structured findings.

## Acceptance Questions

- Should `SPEC_reviewArchDesign` generate an explicit review report file (e.g., `README_ArchReview.md` or a local work log entry), or should it report inline/stdout and update the active user story status?
- How should a failed review route the flow? Should it route back to `SPEC_takeArchDesign` or `SPEC_updateDetailDesign` respectively?
