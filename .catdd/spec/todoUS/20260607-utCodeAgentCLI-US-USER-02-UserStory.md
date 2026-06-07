# User Story: utCodeAgentCLI USER US-USER-02 Design CaTDD test skeletons

Created by `/SPEC_importUserStory` on 2026-06-07.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` slice `US-USER-02`.

## Source Trace

- Source story slice: [../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md](../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- Paired usage context: [../../codeAgents/utCodeAgentCLI/README_UserGuide.md](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Master requirements index: [../../codeAgents/utCodeAgentCLI/README_UserStory.md](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-USER-02 [P0]`

## Active Work Status

- Status: TODO.
- Active state: `.catdd/spec/todoUS/` ready for `SPEC_openUserStory`.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_openUserStory`.

## Story

As a USER,
I want the CLI to generate US/AC/TC skeletons into a test file from my source code and User Story,
so that I have a structured, traceable test plan before writing any executable test code.

## Independent Test Intent

A reviewer can inspect the generated test file and verify that the requested categories, US/AC traceability, and PLANNED TC skeletons exist without any executable test code being written.

## Acceptance Criteria

### AC-01: P0 Functional skeleton design writes all four categories
- **Given** a User Story (`--goalStory` or `--goalStoryFile`), a source interface file (`--inputFile`), and an empty or nonexistent target test file
- **When** the CLI runs with `--behave designFuncTestsSkeleton`
- **Then** the target test file is created or updated (EMPTY or DESIGNED → DESIGNED)
- **And** it contains a `@[US]` comment matching the provided User Story
- **And** it contains `@[AC-*]` acceptance criteria comments derived from the story
- **And** it contains `@[TC-*]` test case skeleton comments for Typical, Edge, Misuse, and Fault categories
- **And** every TC skeleton has `@[Category:<name>]` and `@[Status:PLANNED]`
- **And** no executable test code is written — only comment skeletons

### AC-02: Single-category skeleton design
- **Given** a source file and story
- **When** the CLI runs with `--behave designEdgeSkeleton`
- **Then** the target file contains only Edge-category TC skeletons
- **And** no Typical, Misuse, or Fault skeletons are present

### AC-03: Skeleton design without a User Story is accepted but warns
- **Given** a source file but no `--goalStory` or `--goalStoryFile`
- **When** the CLI runs with a skeleton-design behavior
- **Then** the skeletons are generated
- **And** the `@[US]` comment contains a generated placeholder noting the story was not provided
- **And** stderr emits a warning that traceability is incomplete

## Scope

In scope:

- P0 functional skeleton generation.
- Source-story traceability into the test file.
- Category-specific skeleton selection.

Out of scope:

- Executable test code.
- Review or implementation behaviors.
- Non-test-space target selection.

## Risks

- Missing `@[US]` trace can reduce auditability.
- Category coverage drift can cause incomplete skeletons.
- Overwriting a target file without preserving structure would break traceability.

## Assumptions

- The CLI can resolve a source user story and source file together.
- Skeleton generation writes only comments and status markers.
- P0 functional categories are Typical, Edge, Misuse, and Fault.

## Acceptance Questions

- Should skeleton design preserve any pre-existing non-CaTDD comments in the target file?
- Should warnings be emitted to stderr or a dedicated diagnostic stream?
- Should the story placeholder be machine-identifiable when no story is provided?

## Next Recommended Action

Run `/SPEC_openUserStory` to move this imported story into `.catdd/spec/doingUS/`.
