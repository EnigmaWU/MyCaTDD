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

#### P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-06 | 6 | ✅ Normal design flows |
| Edge | ValidFunc | AC-07 ~ AC-11 | 5 | ✅ Warn, proceed |
| Misuse | InvalidFunc | AC-12 ~ AC-16 | 5 | ❌ Behavior-specific contract |
| Fault | InvalidFunc | AC-17 ~ AC-20 | 4 | ❌ Design-time dependency |

---

### Typical (ValidFunc) — Normal usage patterns

##### AC-01 [Func/Typical]: Design P0 Functional skeletons all four categories
- **Given** `--goalStoryFile`, `--inputFile`, and empty/nonexistent `--target` test file
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit code 0, target file created/updated (EMPTY → DESIGNED)
- **And** contains `@[US]`, `@[AC-*]`, `@[TC-*]` for Typical/Edge/Misuse/Fault
- **And** every TC has `@[Category:<name>]` and `@[Status:PLANNED]`
- **And** no executable code — only comment skeletons

##### AC-02 [Func/Typical]: Design one P0 category
- **Given** source and story
- **When** `--behave designEdgeSkeleton`
- **Then** exit code 0, target file contains only Edge-category skeletons

##### AC-03 [Func/Typical]: Design all P0/P1/P2 skeletons
- **Given** source and story
- **When** `--behave designAllSkeleton`
- **Then** exit code 0, target file has P0 Functional + P1 Design + P2 Quality skeletons

##### AC-04 [Func/Typical]: Inline story + inline source
- **Given** `--goalStory "..."` and `--input "..."`
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit code 0, skeletons generated from inline values

##### AC-05 [Func/Typical]: Design with reference files
- **Given** `--reference docs/api.md,docs/schema.md`
- **When** `--behave designAllSkeleton`
- **Then** exit code 0, reference content informs skeleton generation

##### AC-06 [Func/Typical]: Design with all optional args together
- **Given** `--extra-prompt`, `--config-file`, `--diagMethodPrompts`, `--diagSlashCommands`
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit code 0, all options coexist without conflict

### Edge (ValidFunc) — Boundary cases

##### AC-07 [Func/Edge]: Design into existing file preserves non-CaTDD content
- **Given** target file has hand-written test code and non-CaTDD content
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit code 0, non-CaTDD content preserved, skeletons appended

##### AC-08 [Func/Edge]: Design without User Story uses placeholder
- **Given** source file but no `--goalStory` or `--goalStoryFile`
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit code 0, `@[US]` has placeholder, stderr warns about traceability

##### AC-09 [Func/Edge]: Empty `--goalStory ""` treated as not provided
- **Given** `--goalStory ""`
- **When** skeleton design runs
- **Then** exit code 0, `@[US]` has placeholder, stderr warns

##### AC-10 [Func/Edge]: `--reference` with only whitespace ignored with warning
- **Given** `--reference " , "`
- **When** skeleton design runs
- **Then** exit code 0, stderr warns empty references ignored

##### AC-11 [Func/Edge]: Single-category into existing skeletons merges
- **Given** target already has Typical skeletons from previous run
- **When** `--behave designEdgeSkeleton`
- **Then** exit code 0, Edge skeletons added alongside existing, no duplicates

### Misuse (InvalidFunc) — Behavior-specific contract

##### AC-12 [Func/Misuse]: `--inputFile` is not valid source code
- **Given** `--inputFile` points to binary or no recognizable code structure
- **When** skeleton design parses the source
- **Then** exit code 1, stderr: file is not a parseable source file

##### AC-13 [Func/Misuse]: Design into FULLY_RED file
- **Given** target file is FULLY_RED (all TCs RED)
- **When** `--behave designFuncTestsSkeleton`
- **Then** exit code 1, stderr: file has implemented TCs, use review or re-design missing categories

##### AC-14 [Func/Misuse]: `--goalStoryFile` has no story structure
- **Given** file is readable but has no role/US/AC structure
- **When** skeleton design runs
- **Then** exit code 1, stderr: no User Story content found

##### AC-15 [Func/Misuse]: Config incompatible with design scope
- **Given** config has `categoryMode: strict-p0-only` with `--behave designAllSkeleton`
- **When** config applied to design behavior
- **Then** exit code 1, stderr reports config/skeleton scope conflict

##### AC-16 [Func/Misuse]: `--reference` file provides no usable context
- **Given** reference file has no API/schema/test-relevant content
- **When** skeleton design runs
- **Then** exit code 0, stderr warns reference provided no usable context, skeletons still generated

### Fault (InvalidFunc) — Design-time dependency failures

##### AC-17 [Func/Fault]: `--inputFile` has no testable interface surface
- **Given** `--inputFile` has empty class or no public methods
- **When** skeleton design runs
- **Then** exit code 1, stderr: no testable interface surface found

##### AC-18 [Func/Fault]: Target parent directory does not exist and can't be created
- **Given** `--target missing/deep/path/test.cpp`
- **When** CLI attempts to create target file
- **Then** exit code 1, stderr: directory creation failure

##### AC-19 [Func/Fault]: `--reference` file is a broken symlink
- **Given** `--reference docs/broken-link.md` where target doesn't exist
- **When** CLI reads the reference
- **Then** exit code 1, stderr names the broken symlink path

##### AC-20 [Func/Fault]: `--goalStoryFile` is a directory
- **Given** `--goalStoryFile codeAgents/` (a directory)
- **When** validation detects this
- **Then** exit code 1, stderr: path is a directory, expected a story file

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
