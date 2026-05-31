# User Story: Add SPEC_takeArchDesign portable slash command

Created by `/SPEC_analyzeIssue` retrospectively on 2026-05-31.
Closed on 2026-05-31 after verification and merge.

## Source Trace

- Analyzed raw issue: [../analyzedNews/20260531-add-SPEC_takeArchDesign-command-Issue.md](../analyzedNews/20260531-add-SPEC_takeArchDesign-command-Issue.md)
- Area: `.catdd/slashCommands/commands/Px-SpecFlow/`
- Pipeline position: after requirement assembly, before detailed design

## Active Work Status

- Status: CLOSED.
- Active state: `.catdd/spec/doneUS/` completed story archive.
- Closed from: `.catdd/spec/doingUS/`
- Retrospective confirmation: Command implemented in `d9028b2`, all validation and mirror-check tests pass.
- Verification Details: Checked via `/SPEC_reviewUserStory` on 2026-05-31 (Result: PASS).

## Analysis Status

- Status: CLOSED.
- Priority: P0 — required to unlock target-project architecture design.
- Confidence: high.

## Observed Behavior

The original SpecFlow skipped the architectural design phase, moving directly from user stories to detailed class/API designs. For complex target agents like `utCodeAgentCLI`, this skip leads to poorly defined component boundaries and loose data flow specifications.

## Expected Behavior

A new command `SPEC_takeArchDesign` is added to orchestrate the generation and update of project-root `README_ArchDesign.md` based on a standard template.

## User Story

As a MyCaTDD developer,
I want to add the `SPEC_takeArchDesign` portable slash command,
So that team-shared architecture designs can be systematically drafted and traced before low-level detailing or testing begins.

## Acceptance Scenarios

### AC-1: Define the command contract
- **Given** the file `slashCommands/commands/Px-SpecFlow/SPEC_takeArchDesign.md` is loaded,
- **When** analyzed,
- **Then** it specifies its inputs (`doing_user_story`, `projectContext_file`, `readme_arch_template`), and its output contract (producing project-root `README_ArchDesign.md`).

### AC-2: Align pipeline flow
- **Given** `slashCommands/flows/Px-SpecFlow.md` defines the pipeline,
- **When** inspected,
- **Then** `SPEC_takeArchDesign` is correctly positioned after requirements work and before `SPEC_takeDetailDesign` in both the Mermaid flow diagram and the command sequence.

### AC-3: Architecture template created
- **Given** a new project needs an architecture design doc,
- **When** the command is run for the first time,
- **Then** it references `slashCommands/templates/README_ArchDesignTemplate.md` as the design standard.

## Scope

In scope:
- Create `SPEC_takeArchDesign.md` command specification.
- Add `README_ArchDesignTemplate.md` standard layout.
- Update `Px-SpecFlow.md` to reflect the new pipeline step.
- Verify prompt-wrapper generation and target-project installation.

Out of scope:
- Implementing the architecture design for any specific `utCodeAgentCLI` story (this is done by running the command).

## Review Gate Finding

- **Review Date**: 2026-05-31
- **Review Result**: **PASS**
- **Clarity**: High. Command purpose and outputs are completely aligned with the SpecFlow lifecycle.
- **Testability**: Verified. Dynamic prompt wrappers generated, installer scripts tested, and all checks pass successfully.
