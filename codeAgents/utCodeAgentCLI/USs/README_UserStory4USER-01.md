# US-USER-01 [P0] — Parse and validate CLI arguments

**As a** USER, **I want** the CLI to validate my invocation immediately, **so that** I get clear, actionable feedback when my arguments are wrong instead of silent misbehavior.

## P0 Functional Completeness

| Category | Class | AC Coverage | Count | Rule |
|---|---|---|---|---|
| Typical | ValidFunc | AC-01 ~ AC-10 | 10 | User intent usage patterns |
| Edge | ValidFunc | AC-11 ~ AC-20 | 10 | Valid boundary (warn, continue) |
| Misuse | InvalidFunc | AC-21 ~ AC-28, AC-32 | 9 | Error exit caller's fault |
| Fault | InvalidFunc | AC-29 ~ AC-31 | 3 | Error exit dependency failure |

## AC Status Overview

| Category | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
|---|---|---|---|---|---|---|---|
| Typical | 10 | 0 | 0 | 0 | 0 | 0 | 10 |
| Edge | 10 | 0 | 0 | 0 | 0 | 0 | 10 |
| Misuse | 9 | 0 | 0 | 0 | 0 | 0 | 9 |
| Fault | 3 | 0 | 0 | 0 | 0 | 0 | 3 |
| **Total** | **32** | **0** | **0** | **0** | **0** | **0** | **32** |

---

## Typical (ValidFunc) — Normal usage patterns

### 【PENDING】AC-01 [Func/Typical]: Design P0 Functional skeletons (full set)
- **Given** the user wants all four P0 Functional categories
- **When** the CLI runs with `--goalStoryFile`, `--inputFile`, `--target`, and `--behave designFuncTestsSkeleton`
- **Then** exit code is 0
- **And** execution proceeds to design the full P0 Functional skeleton set

### 【PENDING】AC-02 [Func/Typical]: Design one P0 category
- **Given** the user wants one specific category (e.g. Edge)
- **When** the CLI runs with `--goalStoryFile`, `--inputFile`, `--target`, and `--behave designEdgeSkeleton`
- **Then** exit code is 0
- **And** execution proceeds to design only that category's skeleton

### 【PENDING】AC-03 [Func/Typical]: Design all P0/P1/P2 skeletons
- **Given** the user wants complete CaTDD skeleton coverage
- **When** the CLI runs with `--goalStoryFile`, `--inputFile`, `--target`, and `--behave designAllSkeleton`
- **Then** exit code is 0
- **And** execution proceeds to design functional, design, and quality skeletons

### 【PENDING】AC-04 [Func/Typical]: Review skeletons before implementation
- **Given** the user wants to check existing skeletons
- **When** the CLI runs with `--target` and `--behave reviewFuncTestsSkeleton`
- **Then** exit code is 0
- **And** execution proceeds to review the skeleton coverage

### 【PENDING】AC-05 [Func/Typical]: Pick next TC to implement
- **Given** the user wants to follow TDD priority order
- **When** the CLI runs with `--target` and `--behave tellMeNextImplTest`
- **Then** exit code is 0
- **And** execution proceeds to select the next test case

### 【PENDING】AC-06 [Func/Typical]: Implement one specific TC
- **Given** the user knows which TC to implement
- **When** the CLI runs with `--inputFile`, `--target` (one TC), and `--behave implTestCase`
- **Then** exit code is 0
- **And** execution proceeds to implement that single test case

### 【PENDING】AC-07 [Func/Typical]: Implement all TCs in a TestFile
- **Given** the user wants batch implementation
- **When** the CLI runs with `--inputFile`, `--target` (one TestFile), and `--behave implTestFile`
- **Then** exit code is 0
- **And** execution proceeds to implement every ready TC

### 【PENDING】AC-08 [Func/Typical]: Design with inline story + inline source
- **Given** the user provides short story and source inline
- **When** the CLI runs with `--goalStory "..."`, `--input "..."`, `--target`, and `--behave designFuncTestsSkeleton`
- **Then** exit code is 0
- **And** execution proceeds with the inline values

### 【PENDING】AC-09 [Func/Typical]: Design with reference files
- **Given** the user provides reference documentation
- **When** the CLI runs with `--inputFile`, `--target`, `--behave designAllSkeleton`, and `--reference docs/api.md,docs/schema.md`
- **Then** exit code is 0
- **And** the reference files are consulted during skeleton generation

### 【PENDING】AC-10 [Func/Typical]: Design + extra-prompt + config + diag flags

## Edge (ValidFunc) — Almost-failure-but-valid boundary cases

### 【PENDING】AC-11 [Func/Edge]: Empty-string optional args warn and continue
- **Given** the CLI is invoked with `--input ""`, `--reference ""`, or `--extra-prompt ""`
- **When** argument validation runs
- **Then** exit code is 0
- **And** stderr emits a warning that the empty value is treated as not provided
- **And** execution proceeds normally

### 【PENDING】AC-12 [Func/Edge]: --reference given only commas or whitespace warns and continues
- **Given** the CLI is invoked with `--reference ","` or `--reference ""`
- **When** argument validation runs
- **Then** exit code is 0
- **And** stderr emits a warning
- **And** execution proceeds as if `--reference` was not provided

### 【PENDING】AC-13 [Func/Edge]: --extra-prompt given only commas or whitespace warns and continues
- **Given** the CLI is invoked with `--extra-prompt ","` or `--extra-prompt ""`
- **When** argument validation runs
- **Then** exit code is 0
- **And** stderr emits a warning
- **And** execution proceeds as if `--extra-prompt` was not provided

### 【PENDING】AC-14 [Func/Edge]: Both --diagMethodPrompts and --diagSlashCommands together
- **Given** the CLI is invoked with both `--diagMethodPrompts` and `--diagSlashCommands`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** both DIAG-level log messages are emitted during execution
- **And** no conflict error is raised

### 【PENDING】AC-15 [Func/Edge]: Neither diag flag
- **Given** the CLI is invoked without any `--diag*` flag
- **When** argument parsing completes
- **Then** exit code is 0
- **And** no DIAG-level log messages are emitted

### 【PENDING】AC-16 [Func/Edge]: --log-level set to default value explicitly
- **Given** the CLI is invoked with `--log-level info`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** log output uses the default info verbosity as expected

### 【PENDING】AC-17 [Func/Edge]: --log-level set to non-default value
- **Given** the CLI is invoked with `--log-level debug`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** log output uses the requested debug verbosity

### 【PENDING】AC-18 [Func/Edge]: --config-file pointing to valid YAML
- **Given** the CLI is invoked with `--config-file` pointing to a readable, valid YAML file
- **When** argument validation runs
- **Then** exit code is 0
- **And** the config file is loaded without error

### 【PENDING】AC-19 [Func/Edge]: --interactive-slash-commands flag
- **Given** the CLI is invoked with `--interactive-slash-commands`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** execution prompts for confirmation before each slash command

### 【PENDING】AC-20 [Func/Edge]: --interactive-slash-commands absent
- **Given** the CLI is invoked without `--interactive-slash-commands`
- **When** argument parsing completes
- **Then** exit code is 0
- **And** execution proceeds without any interactive prompts
- **Given** the user provides extra prompts, config, and diagnostics
- **When** the CLI runs with `--inputFile`, `--target`, `--behave designAndImplTest`, `--extra-prompt`, `--config-file`, `--diagMethodPrompts`, and `--diagSlashCommands`
- **Then** exit code is 0
- **And** all optional arguments are accepted together without conflict

## Misuse (InvalidFunc) — Caller contract violations that exit with error

### 【PENDING】AC-21 [Func/Misuse]: Missing required argument exits with error
- **Given** the CLI is invoked without one of `--goal`, `--target`, or `--behave`, or with `--target ""`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names the missing argument and describes what it is for and why it is required

### 【PENDING】AC-22 [Func/Misuse]: Empty --goal string exits with error
- **Given** the CLI is invoked with `--goal ""` (empty string)
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr indicates that `--goal` must not be empty
- **And** usage information is printed

### 【PENDING】AC-23 [Func/Misuse]: Mutually exclusive --goalStory and --goalStoryFile
- **Given** the CLI is invoked with both `--goalStory "..."` and `--goalStoryFile "..."`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names both conflicting arguments and states they cannot be used together

### 【PENDING】AC-24 [Func/Misuse]: Mutually exclusive --input and --inputFile
- **Given** the CLI is invoked with both `--input "..."` and `--inputFile "..."`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names both conflicting arguments and states they cannot be used together

### 【PENDING】AC-25 [Func/Misuse]: Unrecognized --behave value
- **Given** the CLI is invoked with `--behave "nonexistent"`
- **When** behavior resolution runs
- **Then** exit code is 1
- **And** stderr lists every valid `--behave` value

### 【PENDING】AC-26 [Func/Misuse]: Unparseable --target form
- **Given** the CLI is invoked with `--target` in an unparseable form
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr shows the supported selector forms

### 【PENDING】AC-27 [Func/Misuse]: --target TestCase with skeleton design --behave
- **Given** the CLI is invoked with `--target tests/auth_test.cpp::TC-03` and `--behave designFuncTestsSkeleton`
- **When** behavior and target resolution runs
- **Then** exit code is 1
- **And** stderr reports the unsupported combination and suggests valid pairings

### 【PENDING】AC-28 [Func/Misuse]: Unrecognized --log-level value
- **Given** the CLI is invoked with `--log-level "verbose"`
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr lists every valid `--log-level` value

### 【PENDING】AC-32 [Func/Misuse]: --config-file with valid YAML but structurally wrong content
- **Given** the CLI is invoked with `--config-file` pointing to valid YAML missing required keys
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr reports the structural error and lists required keys

---

## Fault (InvalidFunc) — External dependency failures that exit with error

### 【PENDING】AC-29 [Func/Fault]: File-path arguments point to nonexistent or unreadable files
- **Given** CLI invoked with `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, or `--config-file` pointing to nonexistent or unreadable paths
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr names the problematic path and describes the issue

### 【PENDING】AC-30 [Func/Fault]: --config-file not valid YAML
- **Given** CLI invoked with `--config-file` pointing to an existing file that is not valid YAML
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr includes a parse error for the config file

### 【PENDING】AC-31 [Func/Fault]: --config-file path is a directory
- **Given** CLI invoked with `--config-file` pointing to a directory instead of a file
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr reports that the path is a directory, not a file
