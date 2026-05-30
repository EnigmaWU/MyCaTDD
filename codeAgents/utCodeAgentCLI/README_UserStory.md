# utCodeAgentCLI Requirements

utCodeAgentCLI is the CaTDD-native CLI that turns a natural language goal, source code, and a User Story into traceable test artifacts. Its core promise: **design → review → implement CaTDD test cases, with full traceability from story to skeleton to executable code, without ever redefining CaTDD method semantics.**

Three roles drive every requirement in this document:

| Role | Concern |
| --- | --- |
| **USER** | "I have source code and a test need. Give me traceable test artifacts." |
| **INVENTOR** | "I defined CaTDD. The CLI must orchestrate my method — never corrupt, inline, or bypass it." |
| **DEVELOPER** | "I build, test, and extend the CLI. I need clear contracts, diagnostics, and adapter boundaries." |

This document is the **single authoritative requirements source** for `utCodeAgentCLI`. Downstream artifacts — [README_UsageDesign.md](README_UsageDesign.md), [README_UserGuide.md](README_UserGuide.md), architecture docs, test plans — must trace back to requirements defined here.

> **Implementation status**: `utCodeAgentCLI` does not yet have a runnable binary. All requirements describe the intended CLI behavior. The [UsageDesign](README_UsageDesign.md) specifies the CLI interface contract that satisfies these requirements. The [UserGuide](README_UserGuide.md) documents invocation-plan patterns that satisfy these requirements today.

---

## Capability Map

```
USER:  "Test my auth service for Typical and Edge coverage."
  │
  ├─(1)─► CLI parses & validates: --goal, --goalStory, --inputFile, --target, --behave
  │         REQ-CLI-U01
  │
  ├─(2)─► CLI delegates to methodPrompts for category meaning
  │         REQ-CLI-I01
  │
  ├─(3)─► CLI designs US/AC/TC skeletons into target test file
  │         REQ-CLI-U02
  │         Output: tests/auth_api_test.cpp ← @[US], @[AC-01], @[TC-01]...@[TC-08]
  │
  ├─(4)─► CLI reviews skeleton quality
  │         REQ-CLI-U03
  │         Output: "8 TCs total. 3 Typical, 2 Edge, 2 Misuse, 1 Fault. All PLANNED."
  │
  ├─(5)─► CLI picks next TC to implement
  │         REQ-CLI-U04
  │         Output: "TC-04 | Edge | empty-password-boundary"
  │
  ├─(6)─► CLI implements TC-04 — writes executable RED test code
  │         REQ-CLI-U05
  │         Output: TC-04 now has compilable test body, @[Status:RED]
  │
  └─(7)─► Trace file records everything: invocation, resolution, output, status
            REQ-CLI-I02
```

---

## Requirement Index

| ID | P | Role | Title | Depends On |
| --- | --- | --- | --- | --- |
| REQ-CLI-U01 | P0 | USER | Parse and validate CLI arguments | — |
| REQ-CLI-U02 | P0 | USER | Design CaTDD test skeletons | U01, I01 |
| REQ-CLI-U03 | P0 | USER | Review skeleton completeness | U02 |
| REQ-CLI-U04 | P0 | USER | Select next test case to implement | U02 |
| REQ-CLI-U05 | P0 | USER | Implement one executable test case (RED) | U01, I01 |
| REQ-CLI-U06 | P1 | USER | Implement all test cases in a file | U05 |
| REQ-CLI-U07 | P1 | USER | Batch skeleton design across multiple files | U02 |
| REQ-CLI-U08 | P1 | USER | Combined design-and-implement in one pass | U02, U05 |
| REQ-CLI-I01 | P0 | INVENTOR | Delegate all CaTDD semantics to methodPrompts | — |
| REQ-CLI-I02 | P0 | INVENTOR | Produce machine-readable execution traces | U01 |
| REQ-CLI-I03 | P1 | INVENTOR | Diagnostic visibility into method resolution | U01 |
| REQ-CLI-D01 | P0 | DEVELOPER | Actionable error messages for all failure states | U01 |
| REQ-CLI-D02 | P1 | DEVELOPER | Configurable logging and diagnostic output | U01 |
| REQ-CLI-D03 | P1 | DEVELOPER | Interactive per-command confirmation | U01 |
| REQ-CLI-D04 | P2 | DEVELOPER | Runtime adapter interface | — |

### Priority Scale

| Priority | Meaning |
| --- | --- |
| **P0 Critical** | v0.1 cannot ship without this. The CLI has no reason to exist if this fails. |
| **P1 Important** | v1.0 requires this for a complete end-to-end CaTDD workflow. |
| **P2 Valuable** | v1.x+ extends capability without changing the core design. |

---

## USER Requirements

### REQ-CLI-U01 [P0] — Parse and validate CLI arguments

**As a** USER, **I want** the CLI to validate my invocation immediately, **so that** I get clear, actionable feedback when my arguments are wrong instead of silent misbehavior.

#### Scenario: Missing required argument exits with error

- **Given** the CLI is invoked without `--goal`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr contains the string `"--goal"`
- **And** stderr describes what `--goal` is for and why it is required

The same applies to `--target` and `--behave`.

#### Scenario: Mutually exclusive arguments are rejected

- **Given** the CLI is invoked with both `--goalStory "..."` and `--goalStoryFile "..."`, or both `--input "..."` and `--inputFile "..."`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names both conflicting arguments and states they cannot be used together

#### Scenario: Unrecognized --behave value lists valid alternatives

- **Given** the CLI is invoked with `--behave "nonexistent"`
- **When** behavior resolution runs
- **Then** exit code is 1
- **And** stderr lists every valid `--behave` value

#### Scenario: File-path arguments point to nonexistent files

- **Given** the CLI is invoked with `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, or `--config-file` pointing to a nonexistent path
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr names the missing path

#### Scenario: Valid invocation proceeds without error

- **Given** all required arguments are present, mutually exclusive pairs are not violated, and file paths exist
- **When** argument parsing completes
- **Then** exit code is 0
- **And** execution proceeds to the behavior specified by `--behave`

---

### REQ-CLI-U02 [P0] — Design CaTDD test skeletons

**As a** USER, **I want** the CLI to generate US/AC/TC skeletons into a test file from my source code and User Story, **so that** I have a structured, traceable test plan before writing any executable test code.

#### Scenario: P0 Functional skeleton design writes all four categories

- **Given** a User Story (`--goalStory` or `--goalStoryFile`), a source interface file (`--inputFile`), and an empty or nonexistent target test file (`--target`)
- **When** the CLI runs with `--behave designFuncTestsSkeleton`
- **Then** the target test file is created or updated
- **And** it contains a `@[US]` comment whose text matches the provided User Story
- **And** it contains `@[AC-*]` acceptance criteria comments derived from the story
- **And** it contains `@[TC-*]` test case skeleton comments for Typical, Edge, Misuse, and Fault categories
- **And** every TC skeleton has `@[Category:<name>]` and `@[Status:PLANNED]`
- **And** no executable test code is written — only comment skeletons

#### Scenario: Single-category skeleton design

- **Given** a source file and story
- **When** the CLI runs with `--behave designEdgeSkeleton`
- **Then** the target file contains only Edge-category TC skeletons
- **And** no Typical, Misuse, or Fault skeletons are present

#### Scenario: Skeleton design without a User Story is accepted but warns

- **Given** a source file but no `--goalStory` or `--goalStoryFile`
- **When** the CLI runs with a skeleton-design behavior
- **Then** the skeletons are generated
- **And** the `@[US]` comment contains a generated placeholder noting the story was not provided
- **And** stderr emits a warning that traceability is incomplete

---

### REQ-CLI-U03 [P0] — Review skeleton completeness

**As a** USER, **I want** the CLI to audit an existing skeleton file before I implement anything, **so that** I catch coverage gaps and traceability breaks before writing code.

#### Scenario: Review reports numeric skeleton status

- **Given** a test file containing CaTDD skeleton TCs — some PLANNED, some IMPLEMENTED, some with missing categories
- **When** the CLI runs with `--behave reviewFuncTestsSkeleton` targeting that file
- **Then** stdout includes:
  - Total TC count
  - Count per category (Typical, Edge, Misuse, Fault)
  - Count per status (PLANNED, RED, GREEN)
  - List of TC-IDs missing `@[Category]` or `@[Status]` tags
- **And** no file is modified

#### Scenario: Review on a file without skeletons reports empty

- **Given** a test file with no CaTDD skeleton comments
- **When** review is invoked
- **Then** stdout reports: "0 CaTDD skeleton TCs found"
- **And** exit code is 0 (not an error — the file is valid, just empty)

---

### REQ-CLI-U04 [P0] — Select next test case to implement

**As a** USER, **I want** the CLI to tell me exactly which TC to implement next, **so that** I follow TDD discipline without manually scanning the file or guessing priority.

#### Scenario: Next TC is the first unimplemented P0 TC

- **Given** a test file with TC-01 (Typical, PLANNED), TC-02 (Typical, PLANNED), TC-03 (Edge, PLANNED)
- **When** the CLI runs with `--behave tellMeNextImplTest`
- **Then** stdout outputs exactly one TC-ID: `TC-01` (first PLANNED, P0 before P1/P2)
- **And** stdout includes the TC's category
- **And** no file is modified

#### Scenario: When some TCs are already implemented

- **Given** a test file with TC-01 (RED), TC-02 (PLANNED), TC-03 (PLANNED)
- **When** `tellMeNextImplTest` is invoked
- **Then** stdout selects `TC-02` (first non-implemented)
- **And** already-RED TCs are skipped

#### Scenario: When all TCs are implemented

- **Given** a test file where every TC has `@[Status:RED]` or `@[Status:GREEN]`
- **When** `tellMeNextImplTest` is invoked
- **Then** stdout reports: "All TCs are already implemented. Nothing to select."
- **And** exit code is 0

---

### REQ-CLI-U05 [P0] — Implement one executable test case (RED)

**As a** USER, **I want** the CLI to turn one skeleton TC into compilable test code, **so that** I enter the RED phase of TDD with executable tests, not just comments.

#### Scenario: Skeleton TC becomes executable RED test

- **Given** a test file where TC-04 has a `@[TC-04]` skeleton comment with `@[Status:PLANNED]` and `@[Category:Edge]`, and a source file provides implementation context (`--inputFile`)
- **When** the CLI runs with `--behave implTestCase --target tests/auth_test.cpp::TC-04`
- **Then** TC-04's comment skeleton is preserved (all `@[US]`, `@[AC]`, `@[TC]`, `@[Category]` tags remain)
- **And** an executable test function body is added below the TC-04 skeleton comment
- **And** `@[Status:PLANNED]` is replaced with `@[Status:RED]`
- **And** no other TC in the file is modified

#### Scenario: TC already implemented is not overwritten

- **Given** TC-04 already has `@[Status:RED]` or `@[Status:GREEN]`
- **When** `implTestCase` targets TC-04 again
- **Then** exit code is 1
- **And** stderr reports: "TC-04 is already implemented. Use a review behavior or re-design the skeleton first."
- **And** the file is not modified

#### Scenario: Target selector does not resolve to a single TC

- **Given** `--target tests/auth_test.cpp` (a whole file, not a specific TC)
- **When** `--behave implTestCase` is invoked
- **Then** exit code is 1
- **And** stderr reports the `--target` / `--behave` mismatch and suggests valid combinations

---

### REQ-CLI-U06 [P1] — Implement all test cases in a file

**As a** USER, **I want** the CLI to implement every PLANNED TC in a file in one invocation, **so that** I don't invoke `implTestCase` once per TC.

#### Scenario: All PLANNED TCs become RED

- **Given** a test file with TC-01 (PLANNED), TC-02 (PLANNED), TC-03 (RED) — TC-03 already implemented
- **When** the CLI runs with `--behave implTestFile --target tests/auth_test.cpp`
- **Then** TC-01 and TC-02 receive executable test code and are marked RED
- **And** TC-03 is skipped (already RED)
- **And** stdout reports: "2 TCs implemented, 1 skipped (already implemented), 0 failed"
- **And** all `@[US]`/`@[AC]`/`@[TC]` comments are preserved

#### Scenario: One TC implementation fails mid-run

- **Given** TC-02's implementation encounters an unresolvable error (e.g., source context insufficient)
- **When** `implTestFile` processes TC-02
- **Then** TC-02 is left unmodified (still PLANNED)
- **And** the CLI continues to the next TC (TC-03)
- **And** stdout reports TC-02 as a failure with the error reason
- **And** the final summary distinguishes implemented, skipped, and failed counts

---

### REQ-CLI-U07 [P1] — Batch skeleton design across multiple files

**As a** USER, **I want** to design skeletons into several test files from one source and one User Story, **so that** I can prepare multi-module test coverage in one pass.

#### Scenario: Multiple target files each receive skeletons

- **Given** `--target tests/auth_api_test.cpp,tests/auth_error_test.cpp` and a shared `--inputFile` and `--goalStoryFile`
- **When** the CLI runs with `--behave designAllSkeleton`
- **Then** `tests/auth_api_test.cpp` and `tests/auth_error_test.cpp` are both created or updated
- **And** each file contains US/AC/TC skeletons derived from the shared story and source
- **And** stdout reports per-file results

---

### REQ-CLI-U08 [P1] — Combined design-and-implement in one pass

**As a** USER, **I want** the CLI to design all skeletons and immediately implement them in one invocation, **so that** I can go from zero to RED test code without intermediate steps.

#### Scenario: Design all categories then implement all TCs

- **Given** a source file, a User Story, and an empty target test file
- **When** the CLI runs with `--behave designAndImplTest`
- **Then** the target file first receives US/AC/TC skeletons for all applicable P0/P1/P2 categories
- **And** then every generated TC receives executable test code
- **And** all TCs are marked `@[Status:RED]`
- **And** the trace file records the two-phase execution (design → implement)

---

## INVENTOR Requirements

### REQ-CLI-I01 [P0] — Delegate all CaTDD semantics to methodPrompts

**As an** INVENTOR, **I want** the CLI to own zero CaTDD method knowledge, **so that** I can evolve categories, discipline rules, and prompt contracts without touching or re-releasing the CLI.

#### Scenario: Category definition is never hardcoded in the CLI

- **Given** the CLI needs to generate an Edge-category TC skeleton
- **When** it resolves the Edge category meaning
- **Then** it reads from a file under `methodPrompts/` — never from a hardcoded string, enum, or template in the CLI source
- **And** if the required methodPrompt file is missing or unreadable, the CLI exits with an error naming the missing file

#### Scenario: Slash-command behavior delegates to slashCommands

- **Given** the CLI resolves `--behave designFuncTestsSkeleton`
- **When** it executes that behavior
- **Then** it invokes the corresponding portable command under `slashCommands/commands/`
- **And** it does not inline or duplicate the command's logic

#### Scenario: All CaTDD artifacts in output are produced by delegated layers

- **Given** any CLI invocation that modifies a test file
- **When** CaTDD-specific content appears in the output (`@[US]`, `@[AC]`, `@[TC]`, `@[Category]`, `@[Status]`)
- **Then** that content was produced by a methodPrompt or slashCommand — never generated by the CLI itself from a hardcoded string or template

---

### REQ-CLI-I02 [P0] — Produce machine-readable execution traces

**As an** INVENTOR, **I want** every CLI run to leave a structured trace, **so that** I can audit method compliance, replay invocations, and detect drift between what was asked and what was done.

#### Scenario: Trace is written on successful execution

- **Given** a valid CLI invocation completes successfully
- **When** the CLI exits
- **Then** a trace artifact exists in a discoverable location
- **And** the trace includes: timestamp, full invocation string, resolved arguments, resolved slash commands (with file paths), files modified, TC-IDs affected with before/after status, exit code, and duration

#### Scenario: Trace is written on execution failure

- **Given** a valid CLI invocation fails during execution (not during argument parsing)
- **When** the CLI exits with code 1
- **Then** the trace artifact still exists
- **And** it records the failure point: which step was active, the error message, and which steps completed before the failure

#### Scenario: Trace format is machine-parseable

- **Given** any trace artifact written by the CLI
- **When** parsed by a standard JSON or YAML parser
- **Then** it is valid and all fields follow a documented schema

---

### REQ-CLI-I03 [P1] — Diagnostic visibility into method resolution

**As an** INVENTOR, **I want** `--diagMethodPrompts` and `--diagSlashCommands` to reveal exactly which prompts and commands the CLI resolved, **so that** I can verify the CLI did not substitute, skip, or bypass any CaTDD asset.

#### Scenario: --diagMethodPrompts logs resolved prompts

- **Given** any valid CLI invocation with `--diagMethodPrompts`
- **When** the CLI resolves method prompts during execution
- **Then** stderr (or the diagnostic log stream) lists each resolved prompt file path and the CaTDD category or rule it was resolved for

#### Scenario: --diagSlashCommands logs resolved commands

- **Given** a `--behave designFuncTestsSkeleton` invocation with `--diagSlashCommands`
- **When** the CLI resolves the behavior to one or more slash commands
- **Then** the diagnostic output lists each slash command name and file path in resolution order

---

## DEVELOPER Requirements

### REQ-CLI-D01 [P0] — Actionable error messages for all failure states

**As a** DEVELOPER, **I want** every error message to name the problem, identify the affected argument, and suggest the correction, **so that** I can debug invocation issues without reading CLI source code.

#### Scenario: Unrecognized argument value suggests a correction

- **Given** the CLI is invoked with `--behave "deisgnAllSkeleton"` (typo)
- **When** validation fails
- **Then** stderr includes the string `"deisgnAllSkeleton"` is not recognized
- **And** stderr includes a suggestion: `"Did you mean 'designAllSkeleton'?"` (best match)
- **And** stderr includes the full list of valid values

#### Scenario: Missing file error includes the exact path

- **Given** `--inputFile nonexistent/path.h`
- **When** validation fails
- **Then** stderr includes the full resolved path `nonexistent/path.h`
- **And** stderr states the argument name (`--inputFile`)

#### Scenario: Target/behavior mismatch explains why and suggests alternatives

- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** validation detects the mismatch
- **Then** stderr explains: skeleton design requires a file-level `--target`, not a TC-level target
- **And** stderr suggests valid `--target` forms for skeleton design or valid `--behave` values for TC-level targets

---

### REQ-CLI-D02 [P1] — Configurable logging and diagnostic output

**As a** DEVELOPER, **I want** `--log-level` to control output verbosity, **so that** I can run quietly in production or verbosely when debugging.

#### Scenario: --log-level error suppresses non-error output

- **Given** any valid invocation with `--log-level error`
- **When** the CLI executes successfully
- **Then** only error-class messages appear in stderr
- **And** stdout is unaffected (behavior output still appears)

#### Scenario: --log-level debug reveals internal resolution

- **Given** any valid invocation with `--log-level debug`
- **When** the CLI executes
- **Then** stderr includes state transitions: argument parsing, behavior resolution, slash-command selection, file writes

---

### REQ-CLI-D03 [P1] — Interactive per-command confirmation

**As a** DEVELOPER, **I want** to preview each slash command before it runs, **so that** I can approve, skip, or abort multi-step invocations without blind execution.

#### Scenario: Each slash command prompts before execution

- **Given** a `designAndImplTest` invocation with `--interactive-slash-commands`
- **When** the CLI resolves a slash command (e.g., `UT_designFuncTestsSkeleton`)
- **Then** stdout prompts: "Execute UT_designFuncTestsSkeleton on tests/auth_api_test.cpp? [y/n/s(kip)/a(bort)]"
- **And** the CLI waits for input before proceeding

#### Scenario: Abort stops all further execution

- **Given** an interactive session with multiple pending slash commands
- **When** the user inputs "a" (abort) at any prompt
- **Then** no further slash commands execute
- **And** the CLI exits with code 1
- **And** the trace records which commands were skipped

---

### REQ-CLI-D04 [P2] — Runtime adapter interface

**As a** DEVELOPER, **I want** the CLI's slash-command execution backend to be replaceable through a documented adapter interface, **so that** `utCodeAgentCLI` can run on top of Copilot-native, OpenCode, or custom agent runtimes without rewriting the CLI core.

#### Scenario: Adapter conforms to a defined interface

- **Given** a runtime adapter implementing the `CliRuntimeAdapter` interface
- **When** the CLI needs to invoke a slash command
- **Then** it calls the adapter's `invoke(slashCommand, context)` method
- **And** the adapter receives the resolved command path, target, source, and goal context
- **And** the CLI does not assume any specific runtime (TypeScript, Python, shell)

#### Scenario: Default adapter is provided

- **Given** no custom adapter is configured
- **When** the CLI runs
- **Then** a built-in default adapter executes slash commands directly

---

## Requirement Dependency Graph

```
REQ-CLI-U01 (parse & validate)
  │
  ├──► REQ-CLI-D01 (error messages) ── applies to all validation in U01
  ├──► REQ-CLI-D02 (logging)
  ├──► REQ-CLI-D03 (interactive)
  ├──► REQ-CLI-I02 (execution traces) ── depends on parsed args from U01
  │
  ├──► REQ-CLI-U02 (design skeletons) ── needs REQ-CLI-I01 (delegate semantics)
  │       │
  │       ├──► REQ-CLI-U03 (review) ── depends on U02 output
  │       ├──► REQ-CLI-U04 (pick next) ── depends on U02 output
  │       └──► REQ-CLI-U07 (batch design) ── reuses U02 per file
  │
  ├──► REQ-CLI-U05 (implement one TC) ── needs REQ-CLI-I01
  │       │
  │       └──► REQ-CLI-U06 (implement all) ── loops U05
  │
  └──► REQ-CLI-U08 (design+implement) ── chains U02 → U05/U06

REQ-CLI-I01 (delegate semantics) ── required by: U02, U05, U08
REQ-CLI-I03 (diagnostic visibility) ── cross-cutting, depends on U01

REQ-CLI-D04 (adapter interface) ── P2, independent of all other requirements
```

---

## Non-Requirements

The following are explicitly **out of scope** for `utCodeAgentCLI`. These capabilities belong to other layers or are intentionally excluded:

| Capability | Owned by |
| --- | --- |
| Define CaTDD categories, discipline rules, or method meaning | `methodPrompts/` |
| Define portable slash-command execution logic | `slashCommands/` |
| Wrap CaTDD as a generic CodeAgent skill | `agentSkills/` |
| Compile, run, or verify test code | User's build system |
| Generate production/source code | Not in scope — CLI produces test code only |
| Manage git branches, commits, or version control | User's workflow |
| Parse or validate the user's source code language | Delegated to slash commands; CLI only validates its own arguments |

---

## Traceability

| Artifact | Relationship to these requirements |
| --- | --- |
| [README_UsageDesign.md](README_UsageDesign.md) | Specifies the CLI argument contract that satisfies REQ-CLI-U01, U02, U05. Defines `--behave` aliases, `--target` forms, and error handling for REQ-CLI-D01. |
| [README_UserGuide.md](README_UserGuide.md) | Documents the invocation-plan workflow that satisfies all USER requirements. Behavior Selection Guide maps user intent to REQ-CLI-U02–U08. |
| [README.md](README.md) | Defines WHAT the CLI layer is and WHY it exists — the architectural context for all requirements. |
| `methodPrompts/` | Supplies category semantics required by REQ-CLI-I01. Every USER design/implementation requirement depends on this layer. |
| `slashCommands/` | Supplies portable command execution required by REQ-CLI-I01. Every `--behave` value resolves to assets in this layer. |
| [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md) | Original request that initiated these requirements. |
| Old story set (US-CLI-01 through US-CLI-06, now retired) | US-CLI-01/02/04 → folded into USER requirements. US-CLI-03 → folded into U01 (behavior validation). US-CLI-05 → became I01. US-CLI-06 → became D04. |

---

## Open Questions

- What is the trace file output directory and naming convention? Should the user control it via `--trace-dir`?
- Should `--log-level` support a `trace` level below `debug` for raw prompt/response logging?
- For REQ-CLI-D04 (adapters), which runtimes should the first adapter target: raw TypeScript CLI, Copilot-native, or OpenCode-compatible?
- Should `--target` accept a target-list file (`--target-file`) as an alternative to comma-separated inline paths?
- Should `--interactive-slash-commands` support a timeout for unattended CI runs?

---

## Maintenance Rule

Add a new requirement when a user need cannot be traced to any existing REQ-CLI-* ID. Each requirement must have at least one verifiable acceptance scenario.

Do **not** place architecture decisions or detailed implementation behavior here — those belong in `README_ArchDesign.md` and `README_DetailDesign.md`.

This document is the requirements mandate. Downstream docs implement it — they do not drive it.
