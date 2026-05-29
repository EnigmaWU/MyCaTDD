# User Story: Assemble utCodeAgentCLI User Stories

Created by `/SPEC_analyzeIssue` on 2026-05-30.

## Source Trace

- Pending issue: [../pendingNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../pendingNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md)
- Source text: `assemble UserStories for utCodeAgentCLI`
- Area: `codeAgents/utCodeAgentCLI/`

## Analysis Status

- Status: TODO.
- Priority: P0 candidate, because the story set should guide future CLI design and implementation work.
- Confidence: medium. The intent is clear enough to create a planning story, but the exact story-set scope still needs confirmation before detail design.

## Observed Behavior

`utCodeAgentCLI` now has a startup UserGuide and a UsageDesign contract, but it does not yet have an assembled User Story artifact that explains the intended users, goals, acceptance criteria, and independently testable slices for the future CLI layer.

Without that story set, future CLI design work may continue from scattered docs and chat context instead of an explicit SpecFlow artifact.

## Expected Behavior

The repository should have an assembled, traceable `utCodeAgentCLI` User Story set that can guide later detail design, unit-test design, and CLI implementation planning.

The story set should stay aligned with the current design-only state of `utCodeAgentCLI` while marking future runnable-CLI behavior separately from documented invocation-plan behavior.

## User Story

As a MyCaTDD maintainer,
I want to assemble a traceable User Story set for `utCodeAgentCLI`,
So that future CLI design and implementation work can proceed from explicit user intent, acceptance criteria, and independently testable slices.

## Independent Test Intent

A reviewer can inspect the resulting User Story artifact or project-root User Story document and verify that it covers the current `utCodeAgentCLI` user roles, argument model, behavior-selection scenarios, non-goals, open questions, and trace links back to the source issue.

## Acceptance Scenarios

### AC-1: Capture user roles for the CLI layer

- **Given** the current `utCodeAgentCLI` UserGuide identifies developers, CodeAgents, maintainers, and tooling authors as readers,
- **When** the User Story set is assembled,
- **Then** it includes stories or explicit coverage notes for those roles,
- **And** any role intentionally deferred is listed as out of scope or an open question.

### AC-2: Cover the core invocation argument model

- **Given** `README_UsageDesign.md` defines `--goal`, `--goalStory`/`--goalStoryFile`, `--input`/`--inputFile`, `--target`, and `--behave`,
- **When** the User Story set is assembled,
- **Then** it includes at least one story that explains how a user moves from intent to a valid invocation plan,
- **And** it preserves the rule that `--target` is test-space scope while source/context belongs in `--input` or `--inputFile`.

### AC-3: Cover common behavior-selection scenarios

- **Given** the UserGuide includes `IF: What You Want` scenarios for skeleton design, review, next-TC selection, single-TC implementation, and whole-TestFile implementation,
- **When** the User Story set is assembled,
- **Then** it includes story coverage for the typical startup scenarios a user needs first,
- **And** it uses stable CLI aliases such as `designFuncTestsSkeleton`, `designAllSkeleton`, `reviewFuncTestsSkeleton`, `tellMeNextImplTest`, `implTestCase`, and `implTestFile` where appropriate.

### AC-4: Separate current documentation behavior from future runnable CLI behavior

- **Given** `utCodeAgentCLI` is currently a documented future CLI layer and not a runnable binary,
- **When** the User Story set is assembled,
- **Then** stories that describe current documentation and invocation-plan behavior are clearly separated from stories that require future implementation,
- **And** no story claims that runnable CLI behavior already exists.

### AC-5: Provide traceability for later SpecFlow steps

- **Given** SpecFlow will later run detail-design, test-design, implementation, and review commands,
- **When** the User Story set is assembled,
- **Then** each story has a stable identifier, priority, acceptance criteria, and source trace,
- **And** unresolved product or scope questions are preserved instead of being silently resolved.

## Edge Cases

- The story set may discover that some `utCodeAgentCLI` needs are already documentation-only and should not become implementation stories yet.
- The story set may need to split user-facing CLI usage from maintainer-facing CLI design and orchestration responsibilities.
- Some scenarios may belong in `slashCommands/` rather than `utCodeAgentCLI` if they describe a single portable command instead of CLI orchestration.
- Some future runnable CLI stories may need to remain blocked until the repository chooses a concrete implementation language, runtime, or command parser.

## Scope

In scope:

- Assemble user stories for `codeAgents/utCodeAgentCLI/`.
- Cover the current UserGuide and UsageDesign argument model.
- Capture typical user scenarios and stable behavior aliases.
- Mark future runnable-CLI behavior separately from current invocation-plan behavior.

Out of scope:

- Implementing a runnable `utCodeAgentCLI` binary.
- Designing unit-test skeletons for an external product feature.
- Redefining CaTDD P0/P1/P2 category semantics owned by `methodPrompts/`.
- Replacing portable `UT_*` or `SPEC_*` slash-command contracts.

## Risks

- If the story set tries to cover all future CLI automation at once, it may become too broad for one SpecFlow cycle.
- If current documentation behavior and future runnable behavior are mixed, users may believe the CLI already exists.
- If the story set duplicates `methodPrompts` semantics, it can drift from the method source of truth.

## Assumptions

- The first story set should cover developers, CodeAgents, maintainers, and tooling authors unless the developer narrows the scope.
- The initial output should live under `.catdd/spec/todoUS/`; a project-root `README_UserStories.md` can be created later if the story set becomes a shared user-facing reference.
- The current `utCodeAgentCLI` UserGuide and UsageDesign are accepted as the main evidence for the first analysis pass.

## Acceptance Questions

- Should this story set cover only the current documentation/design-only CLI contract, or should it also include future runnable CLI implementation stories now?
- Should the final assembled User Stories also be mirrored into a project-root `README_UserStories.md`?
- Should the first story set be minimum-startup only, or should it cover the full CLI lifecycle from planning through reflection?
- Which user role should be treated as primary for priority ordering: developer, CodeAgent, maintainer, or tooling author?

## Next Recommended Command

`/SPEC_openUserStory`