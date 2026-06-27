# User Story: utCodeAgentCLI USER US-USER-01 Parse and validate CLI arguments

Created by `/SPEC_importUserStory` on 2026-06-28.
Imported from `codeAgents/utCodeAgentCLI/README_UserStory4USER.md` slice `US-USER-01`.

## Source Trace

- Source story slice: [README_UserStory4USER](../../codeAgents/utCodeAgentCLI/README_UserStory4USER.md)
- Paired usage context: [README_UserGuide](../../codeAgents/utCodeAgentCLI/README_UserGuide.md)
- Formal argument contract: [README_UsageDesign](../../codeAgents/utCodeAgentCLI/README_UsageDesign.md)
- Master requirements index: [README_UserStory](../../codeAgents/utCodeAgentCLI/README_UserStory.md)
- Role area: `codeAgents/utCodeAgentCLI/`
- Import granularity: `US-by-US`
- Imported slice: `US-USER-01 [P0]`

## Active Work Status

- Status: DOING.
- Active state: `.catdd/spec/doingUS/` opened by `SPEC_openUserStory` on 2026-06-28.
- Priority: P0 - critical.
- Confidence: high.
- Next recommended command: `/SPEC_makePlan`.

## Mutual Intent Contract

Cleared by `/SPEC_clearStoryIntent` on 2026-06-28. Review result: **CLEARED**.

### Developer Intent

The developer redesigned US-USER-01 from a flat 5-AC list to a categorized 32-AC structure covering all four CaTDD P0 Functional categories. The intent is:

- Every valid CLI invocation pattern from the UserGuide should be testable (Typical, 10 ACs).
- Every boundary condition that warns but proceeds should be testable (Edge, 10 ACs).
- Every caller contract violation that exits with error should be testable (Misuse, 9 ACs).
- Every external dependency failure that exits with error should be testable (Fault, 3 ACs).
- Edge is now a required category (previously incorrectly marked non-required).
- All 3 acceptance questions are resolved and the category boundaries are clear.

### CodeAgent Intent

- The CodeAgent will respect the 32-AC structure and CaTDD category boundaries established in the spec.
- The CodeAgent will use `README_UsageDesign.md` as the formal argument contract and `README_UserGuide.md` as the usage patterns source when designing tests or verifying behavior.
- The CodeAgent will not invent new ACs or reclassify existing ones without developer approval.
- The CodeAgent will proceed through the SpecFlow lifecycle: SPEC_makePlan → SPEC_designUnitTests → SPEC_implUnitTests → SPEC_reviewProductCodes → SPEC_commitWorks → SPEC_closeUserStory.

### In Scope

- CLI argument parsing and validation.
- 32 acceptance criteria across Typical, Edge, Misuse, and Fault.
- Exit code 0 for success, exit code 1 for error.
- Diagnostic messages to stderr.
- File-path validation for all file-based arguments.

### Out of Scope

- Runtime behavior after argument validation.
- Test skeleton design quality or implementation logic.
- Slash command execution details.
- CI/CD integration or non-CLI invocation patterns.

### Success Signal

The story is complete when all 32 ACs have been verified through the CaTDD lifecycle: designed as skeletons, implemented as RED tests, reviewed, and committed.

### Assumptions

- Required arguments are `--goal`, `--target`, and `--behave`.
- `--goalStory` / `--goalStoryFile` and `--input` / `--inputFile` are mutually exclusive.
- Default log level is `info`. Default config file path is `{PRJROOT}/CaTDD/utCodeAgentCLI/config.yaml`.

### Open Questions

~ None — all 3 acceptance questions resolved during review ~

## Story

As a USER,
I want the CLI to validate my invocation immediately,
so that I get clear, actionable feedback when my arguments are wrong instead of silent misbehavior.

## CaTDD Classification

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-10 | 10 | User intent — normal usage patterns |
| Edge | ValidFunc | AC-11 ~ AC-20 | 10 | Proceed (may warn, no error exit) |
| Misuse | InvalidFunc | AC-21 ~ AC-28, AC-32 | 9 | Error exit — caller's fault |
| Fault | InvalidFunc | AC-29 ~ AC-31 | 3 | Error exit — external dependency failure |

## Independent Test Intent

A reviewer can verify that every CLI argument combination — valid, boundary, caller-mistake, and dependency-failure — produces the documented exit code and diagnostic output.

## Acceptance Criteria

### Typical (ValidFunc) — Normal usage patterns from user perspective

#### AC-01 [Func/Typical]: Design P0 Functional skeletons (full set)
- **Given** the user wants all four P0 Functional categories (Typical, Edge, Misuse, Fault)
- **When** the CLI runs with `--goalStoryFile`, `--inputFile`, `--target` (one TestFile), and `--behave designFuncTestsSkeleton`
- **Then** exit code is 0
- **And** execution proceeds to design the full P0 Functional skeleton set

#### AC-02 [Func/Typical]: Design one P0 category
- **Given** the user wants one specific category (e.g. Edge)
- **When** the CLI runs with `--goalStoryFile`, `--inputFile`, `--target`, and `--behave designEdgeSkeleton`
- **Then** exit code is 0
- **And** execution proceeds to design only that category's skeleton

#### AC-03 [Func/Typical]: Design all P0/P1/P2 skeletons
- **Given** the user wants complete CaTDD skeleton coverage
- **When** the CLI runs with `--goalStoryFile`, `--inputFile`, `--target`, and `--behave designAllSkeleton`
- **Then** exit code is 0
- **And** execution proceeds to design functional, design, and quality skeletons

#### AC-04 [Func/Typical]: Review skeletons before implementation
- **Given** the user wants to check existing skeletons
- **When** the CLI runs with `--target` and `--behave reviewFuncTestsSkeleton`
- **Then** exit code is 0
- **And** execution proceeds to review the skeleton coverage

#### AC-05 [Func/Typical]: Pick next TC to implement
- **Given** the user wants to follow TDD priority order
- **When** the CLI runs with `--target` and `--behave tellMeNextImplTest`
- **Then** exit code is 0
- **And** execution proceeds to select the next test case

#### AC-06 [Func/Typical]: Implement one specific TC
- **Given** the user knows which TC to implement
- **When** the CLI runs with `--inputFile`, `--target` (one TC in one TestFile), and `--behave implTestCase`
- **Then** exit code is 0
- **And** execution proceeds to implement that single test case

#### AC-07 [Func/Typical]: Implement all TCs in a TestFile
- **Given** the user wants batch implementation
- **When** the CLI runs with `--inputFile`, `--target` (one TestFile), and `--behave implTestFile`
- **Then** exit code is 0
- **And** execution proceeds to implement every ready TC

#### AC-08 [Func/Typical]: Design with inline story + inline source
- **Given** the user provides short story and source inline
- **When** the CLI runs with `--goalStory "..."`, `--input "..."`, `--target`, and `--behave designFuncTestsSkeleton`
- **Then** exit code is 0
- **And** execution proceeds with the inline values

#### AC-09 [Func/Typical]: Design with reference files
- **Given** the user provides reference documentation
- **When** the CLI runs with `--inputFile`, `--target`, `--behave designAllSkeleton`, and `--reference docs/api.md,docs/schema.md`
- **Then** exit code is 0
- **And** the reference files are consulted during skeleton generation

#### AC-10 [Func/Typical]: Design + extra-prompt + config + diag flags
- **Given** the user provides extra prompts, config, and diagnostics
- **When** the CLI runs with `--inputFile`, `--target`, `--behave designAndImplTest`, `--extra-prompt`, `--config-file`, `--diagMethodPrompts`, and `--diagSlashCommands`
- **Then** exit code is 0
- **And** all optional arguments are accepted together without conflict

### Edge (ValidFunc) — Almost-failure-but-valid boundary cases

#### AC-11 [Func/Edge]: Empty-string optional args warn and continue
- **Given** the CLI is invoked with `--input ""`, `--reference ""`, or `--extra-prompt ""`
- **When** argument validation runs
- **Then** exit code is 0
- **And** stderr emits a warning that the empty value is treated as not provided
- **And** execution proceeds normally

#### AC-12 [Func/Edge]: --reference given only commas or whitespace warns and continues
- **Given** the CLI is invoked with `--reference ","` or `--reference ""`
- **When** argument validation runs
- **Then** exit code is 0
- **And** stderr emits a warning
- **And** execution proceeds as if `--reference` was not provided

#### AC-13 [Func/Edge]: --extra-prompt given only commas or whitespace warns and continues
- **Given** the CLI is invoked with `--extra-prompt ","` or `--extra-prompt ""`
- **When** argument validation runs
- **Then** exit code is 0
- **And** stderr emits a warning
- **And** execution proceeds as if `--extra-prompt` was not provided

#### AC-14 [Func/Edge]: Both --diagMethodPrompts and --diagSlashCommands together
- **Given** the CLI is invoked with both `--diagMethodPrompts` and `--diagSlashCommands`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** both DIAG-level log messages are emitted during execution
- **And** no conflict error is raised

#### AC-15 [Func/Edge]: Neither diag flag
- **Given** the CLI is invoked without any `--diag*` flag
- **When** argument parsing completes
- **Then** exit code is 0
- **And** no DIAG-level log messages are emitted

#### AC-16 [Func/Edge]: --log-level set to default value explicitly
- **Given** the CLI is invoked with `--log-level info`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** log output uses the default info verbosity as expected

#### AC-17 [Func/Edge]: --log-level set to non-default value
- **Given** the CLI is invoked with `--log-level debug`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** log output uses the requested debug verbosity

#### AC-18 [Func/Edge]: --config-file pointing to valid YAML
- **Given** the CLI is invoked with `--config-file` pointing to a readable, valid YAML file
- **When** argument validation runs
- **Then** exit code is 0
- **And** the config file is loaded without error

#### AC-19 [Func/Edge]: --interactive-slash-commands flag
- **Given** the CLI is invoked with `--interactive-slash-commands`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** execution prompts for confirmation before each slash command

#### AC-20 [Func/Edge]: --interactive-slash-commands absent
- **Given** the CLI is invoked without `--interactive-slash-commands`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** execution proceeds without any interactive prompts

### Misuse (InvalidFunc) — Caller contract violations that exit with error

#### AC-21 [Func/Misuse]: Missing required argument exits with error
- **Given** the CLI is invoked without one of `--goal`, `--target`, or `--behave`, or with `--target ""` (empty string)
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names the missing argument and describes what it is for and why it is required

#### AC-22 [Func/Misuse]: Empty --goal string exits with error
- **Given** the CLI is invoked with `--goal ""` (empty string)
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr indicates that `--goal` must not be empty
- **And** usage information is printed

#### AC-23 [Func/Misuse]: Mutually exclusive --goalStory and --goalStoryFile
- **Given** the CLI is invoked with both `--goalStory "..."` and `--goalStoryFile "..."`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names both conflicting arguments and states they cannot be used together

#### AC-24 [Func/Misuse]: Mutually exclusive --input and --inputFile
- **Given** the CLI is invoked with both `--input "..."` and `--inputFile "..."`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names both conflicting arguments and states they cannot be used together

#### AC-25 [Func/Misuse]: Unrecognized --behave value
- **Given** the CLI is invoked with `--behave "nonexistent"`
- **When** behavior resolution runs
- **Then** exit code is 1
- **And** stderr lists every valid `--behave` value

#### AC-26 [Func/Misuse]: Unparseable --target form
- **Given** the CLI is invoked with `--target` in a form that cannot be parsed as one TestCase, one TestFile, or some TestFiles
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr shows the supported selector forms

#### AC-27 [Func/Misuse]: --target TestCase combined with skeleton design --behave
- **Given** the CLI is invoked with `--target tests/auth_test.cpp::TC-03` and `--behave designFuncTestsSkeleton`
- **When** behavior and target resolution runs
- **Then** exit code is 1
- **And** stderr reports the unsupported combination and suggests valid pairings

#### AC-28 [Func/Misuse]: Unrecognized --log-level value
- **Given** the CLI is invoked with `--log-level "verbose"`
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr lists every valid `--log-level` value

#### AC-32 [Func/Misuse]: --config-file with valid YAML but structurally wrong content
- **Given** the CLI is invoked with `--config-file` pointing to a valid YAML file that is missing required keys or has structurally invalid content
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr reports the structural error and lists the required configuration keys

### Fault (InvalidFunc) — External dependency failures that exit with error

#### AC-29 [Func/Fault]: File-path arguments point to nonexistent or unreadable files
- **Given** the CLI is invoked with `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, or `--config-file` pointing to a nonexistent path, or a path that exists but is not a readable file (e.g. broken symlink, permission denied, directory)
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr names the problematic path and describes the issue

#### AC-30 [Func/Fault]: --config-file not valid YAML
- **Given** the CLI is invoked with `--config-file` pointing to an existing file that is not valid YAML
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr includes a parse error for the config file

#### AC-31 [Func/Fault]: --config-file path is a directory
- **Given** the CLI is invoked with `--config-file` pointing to a directory instead of a file
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr reports that the path is a directory, not a file

## Scope

In scope:

- CLI argument parsing and validation.
- Typical valid invocation patterns from documented user intents.
- Edge boundary cases that warn but proceed.
- Misuse caller contract violations that exit with error.
- Fault dependency failures that exit with error.
- Exit code 0 for success, exit code 1 for any error.
- Diagnostic messages to stderr.

Out of scope:

- Runtime behavior after argument validation.
- Test skeleton design quality or implementation logic.
- Slash command execution details.
- CI/CD integration or non-CLI invocation patterns.

## Risks

- Undocumented argument combinations may produce unspecified behavior.
- Invalid YAML config files may produce unhelpful parse error messages.
- Path normalization and relative vs absolute paths may differ across platforms.

## Assumptions

- Required arguments are `--goal`, `--target`, and `--behave`.
- `--goalStory` and `--goalStoryFile` are mutually exclusive.
- `--input` and `--inputFile` are mutually exclusive.
- Default log level is `info`.
- Default config file path is `{PRJROOT}/CaTDD/utCodeAgentCLI/config.yaml`.

## Acceptance Questions

~ All resolved during review ~

Resolved Questions:

| # | Question | Answer | Impact |
|---|---|---|---|
| 1 | Should empty-string `--target` be treated as missing (error) or as unparseable form (error)? | **Misuse**: treated as missing required argument (AC-21 expanded). | AC-21 now includes `--target ""`, AC-26 unchanged for truly garbled forms. |
| 2 | Should `--reference` pointing to a valid file path that is not a readable file (e.g. broken symlink) be Fault or Edge? | **Fault**: expanded AC-29 covers nonexistent AND unreadable paths. | AC-29 covers both nonexistent paths and non-readable files. |
| 3 | Should `--config-file` with valid YAML but structurally wrong content (e.g. missing required keys) be Fault or separate Misuse? | **Misuse**: new AC-32 for structurally invalid config. | AC-30 [Fault] remains for parse errors; AC-32 [Misuse] for structural errors. |

## Next Recommended Action

Run `/SPEC_makePlan` to plan the design and implementation sequence for this story.
