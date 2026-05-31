# utCodeAgentCLI Requirements

utCodeAgentCLI is the CaTDD-native CLI that turns a natural language goal, source code, and a User Story into traceable test artifacts. Its core promise: **design → review → implement CaTDD test cases, with full traceability from story to skeleton to executable code, without ever redefining CaTDD method semantics.**

Three stakeholder roles drive every requirement in this document. USER has two sub-roles that shape distinct requirement paths:

| Role | Sub-role | Concern |
| --- | --- | --- |
| **USER** | | |
| | **NEW-USER** | "I don't know CaTDD's category system or TDD discipline yet. Don't make me pick Typical from Edge or guess which TC to implement next — show me what coverage structure my code needs, explain gaps in my skeletons, and guide me through one step at a time." |
| | **EXPERIENCED-USER** | "I know the method. Let me invoke surgery: design one specific category, implement an exact TC-ID, chain operations across multiple files. Surface errors, not hand-holding. I also review team coverage and run in CI — give me parseable output and clear exit codes." |
| **INVENTOR** | | "I defined CaTDD. The CLI must orchestrate my method — never corrupt, inline, or bypass it." |
| **DEVELOPER** | | "I build, test, and extend the CLI. I need clear contracts, diagnostics, and adapter boundaries." |

This document is the **single authoritative requirements source** for `utCodeAgentCLI`. Downstream artifacts — [README_UsageDesign.md](README_UsageDesign.md), [README_UserGuide.md](README_UserGuide.md), architecture docs, test plans — must trace back to requirements defined here.

### ID Notation

Acceptance criterion IDs follow the full pattern `US-{ROLE}-{NN}-AC-{MM}` (e.g., `US-USER-03-AC-02`). Within each requirement section, AC headings use the short form `AC-{MM}` — the enclosing `### US-{ROLE}-{NN}` heading provides the qualifier. The AC Summary Table records the full ID for flat cross-reference.

> **Implementation status**: `utCodeAgentCLI` does not yet have a runnable binary. All requirements describe the intended CLI behavior. The [UsageDesign](README_UsageDesign.md) specifies the CLI interface contract that satisfies these requirements. The [UserGuide](README_UserGuide.md) documents invocation-plan patterns that satisfy these requirements today.

---

## Capability Map

Three invocation paths cover every CaTDD workflow:

```
Quick path (zero to RED in one step):
  USER intent
    └─► designAndImplTest → RED test file with full skeletons + executable code
        US-USER-08

Iterative path (review-gated implementation):
  USER intent
    ├─► design*Skeleton → PLANNED test file                 US-USER-02
    ├─► review → coverage report                            US-USER-03
    ├─► tellMeNextImplTest → "TC-04 next"                  US-USER-04
    ├─► implTestCase → TC-04 becomes RED                    US-USER-05
    └─► ...repeat pick→impl until all TCs are RED...        US-USER-04, US-USER-05

Batch path (multi-file / multi-TC):
  USER intent
    ├─► designAllSkeleton → skeletons across N files         US-USER-02, US-USER-07
    └─► implTestFile → all PLANNED TCs become RED            US-USER-06
         (in CaTDD priority order: P0→P1→P2, Typical→Edge→Misuse→Fault within P0)
```

All paths produce a machine-readable trace (US-INVENTOR-02) and validate CaTDD method delegation (US-INVENTOR-01).

---

## Test File State Model

The CLI preserves CaTDD state across invocations. Every `--behave` operates on a test file with a known state and produces a predictable state transition.

### TC State Lifecycle

```
@[Status:PLANNED]  ──(implTestCase)──►  @[Status:RED]  ──(user fixes prod code)──►  @[Status:GREEN]
```

The CLI owns the `PLANNED → RED` transition. The `RED → GREEN` transition is a user action (compile, fix product code, pass test) — the CLI reads GREEN status from existing files but never writes it.

### File-Level States

| State | Description |
| --- | --- |
| **EMPTY** | No CaTDD skeleton TCs exist in the file. |
| **DESIGNED** | File contains skeletons; all TCs are `@[Status:PLANNED]`. |
| **PARTIAL** | Mix of PLANNED, RED, and GREEN TCs. This is the normal working state during iterative implementation. |
| **FULLY_RED** | All TCs are `@[Status:RED]` or `@[Status:GREEN]`. No PLANNED TCs remain. |
| **ALL_GREEN** | All TCs are `@[Status:GREEN]`. |

### Behavior State Contract

| `--behave` | Requires file state | Produces TC state | Produces file state |
| --- | --- | --- | --- |
| `design*Skeleton` | Any | All new TCs → PLANNED | DESIGNED or PARTIAL |
| `reviewFuncTestsSkeleton` | DESIGNED, PARTIAL, or FULLY_RED | No change | No change |
| `reviewDesignTestsSkeleton` | DESIGNED or PARTIAL | No change | No change |
| `reviewQualityTestsSkeleton` | DESIGNED or PARTIAL | No change | No change |
| `reviewImplTestCase` | Target TC is RED or GREEN | No change | No change |
| `tellMeNextImplTest` | Has ≥1 PLANNED TC | No change | No change |
| `implTestCase` | Target TC is PLANNED | Target TC → RED | PARTIAL or FULLY_RED |
| `implTestFile` | Has ≥1 PLANNED TC | All PLANNED → RED | FULLY_RED |
| `designAndImplTest` | Any | All TCs → RED | FULLY_RED |

### State Preservation Guarantees

1. The CLI never downgrades status: a RED TC is never set back to PLANNED.
2. The CLI never overwrites an already-implemented TC without explicit intent.
3. Behavior that requires a specific state exits with a clear error if the file is not in that state.
4. Every state transition is recorded in the execution trace (US-INVENTOR-02).

---

## Requirement Index

| ID | P | Role | Sub-Role | Title | AC Range | Depends On |
| --- | --- | --- | --- | --- | --- | --- |
| US-USER-01 | P0 | USER | Both | Parse and validate CLI arguments | AC-01..05 | — |
| US-USER-02 | P0 | USER | Both | Design CaTDD test skeletons | AC-01..03 | US-USER-01, US-INVENTOR-01 |
| US-USER-03 | P0 | USER | Both | Review design skeletons (all tiers) | AC-01..04 | US-USER-02 |
| US-USER-04 | P0 | USER | NEW-USER | Select next test case to implement | AC-01..03 | US-USER-02 |
| US-USER-05 | P0 | USER | EXPERIENCED-USER | Implement one executable test case (RED) | AC-01..04 | US-USER-01, US-INVENTOR-01 |
| US-USER-06 | P1 | USER | EXPERIENCED-USER | Implement all test cases in a file | AC-01..02 | US-USER-05 |
| US-USER-07 | P1 | USER | EXPERIENCED-USER | Batch skeleton design across multiple files | AC-01 | US-USER-02 |
| US-USER-08 | P1 | USER | NEW-USER | Combined design-and-implement in one pass | AC-01 | US-USER-02, US-USER-05 |
| US-USER-09 | P0 | USER | EXPERIENCED-USER | Review implemented test case | AC-01..03 | US-USER-05 |
| US-USER-10 | P0 | USER | EXPERIENCED-USER | Review all implemented test cases in a file | AC-01..02 | US-USER-06 |
| US-INVENTOR-01 | P0 | INVENTOR | | Delegate all CaTDD semantics to methodPrompts | AC-01..03 | — |
| US-INVENTOR-02 | P0 | INVENTOR | | Produce machine-readable execution traces | AC-01..03 | US-USER-01 |
| US-INVENTOR-03 | P1 | INVENTOR | | Diagnostic visibility into method resolution | AC-01..02 | US-USER-01 |
| US-DEV-01 | P0 | DEVELOPER | | Actionable error messages for all failure states | AC-01..03 | US-USER-01 |
| US-DEV-02 | P1 | DEVELOPER | | Configurable logging and diagnostic output | AC-01..02 | US-USER-01 |
| US-DEV-03 | P1 | DEVELOPER | | Interactive per-command confirmation | AC-01..02 | US-USER-01 |
| US-DEV-04 | P2 | DEVELOPER | | Runtime adapter interface | AC-01..02 | — |

### Priority Scale

| Priority | Meaning |
| --- | --- |
| **P0 Critical** | v0.1 cannot ship without this. The CLI has no reason to exist if this fails. |
| **P1 Important** | v1.0 requires this for a complete end-to-end CaTDD workflow. |
| **P2 Valuable** | v1.x+ extends capability without changing the core design. |

### USER Sub-Role Paths

```
NEW-USER path (guided discovery):
  U01 (validate) → U02 (designAllSkeleton) → U03 (review all tiers)
  → U04 (pick next) → U08 (designAndImplTest, zero to RED)

EXPERIENCED-USER path (surgical control):
  U01 (validate) → U02 (single-category design) → U03 (tier-specific review)
  → U05 (impl one TC) → U09 (review impl) → U04 (pick next)
  → U06 (impl all) → U10 (review all impl) / U07 (batch multi-file)
```

---

## USER Requirements

### US-USER-01 [P0] — Parse and validate CLI arguments

**As a** USER, **I want** the CLI to validate my invocation immediately, **so that** I get clear, actionable feedback when my arguments are wrong instead of silent misbehavior.

#### AC-01: Missing required argument exits with error

- **Given** the CLI is invoked without `--goal`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr contains the string `"--goal"`
- **And** stderr describes what `--goal` is for and why it is required

The same applies to `--target` and `--behave`.

#### AC-02: Mutually exclusive arguments are rejected

- **Given** the CLI is invoked with both `--goalStory "..."` and `--goalStoryFile "..."`, or both `--input "..."` and `--inputFile "..."`
- **When** argument parsing runs
- **Then** exit code is 1
- **And** stderr names both conflicting arguments and states they cannot be used together

#### AC-03: Unrecognized --behave value lists valid alternatives

- **Given** the CLI is invoked with `--behave "nonexistent"`
- **When** behavior resolution runs
- **Then** exit code is 1
- **And** stderr lists every valid `--behave` value

#### AC-04: File-path arguments point to nonexistent files

- **Given** the CLI is invoked with `--inputFile`, `--goalStoryFile`, `--reference`, `--extra-prompt`, or `--config-file` pointing to a nonexistent path
- **When** argument validation runs
- **Then** exit code is 1
- **And** stderr names the missing path

#### AC-05: Valid invocation proceeds without error

- **Given** all required arguments are present, mutually exclusive pairs are not violated, and file paths exist
- **When** argument parsing completes
- **Then** exit code is 0
- **And** execution proceeds to the behavior specified by `--behave`

---

### US-USER-02 [P0] — Design CaTDD test skeletons

**As a** USER, **I want** the CLI to generate US/AC/TC skeletons into a test file from my source code and User Story, **so that** I have a structured, traceable test plan before writing any executable test code.

#### AC-01: P0 Functional skeleton design writes all four categories

- **Given** a User Story (`--goalStory` or `--goalStoryFile`), a source interface file (`--inputFile`), and an empty or nonexistent target test file (`--target`)
- **When** the CLI runs with `--behave designFuncTestsSkeleton`
- **Then** the target test file is created or updated (EMPTY or DESIGNED → DESIGNED)
- **And** it contains a `@[US]` comment whose text matches the provided User Story
- **And** it contains `@[AC-*]` acceptance criteria comments derived from the story
- **And** it contains `@[TC-*]` test case skeleton comments for Typical, Edge, Misuse, and Fault categories
- **And** every TC skeleton has `@[Category:<name>]` and `@[Status:PLANNED]`
- **And** no executable test code is written — only comment skeletons

#### AC-02: Single-category skeleton design

- **Given** a source file and story
- **When** the CLI runs with `--behave designEdgeSkeleton`
- **Then** the target file contains only Edge-category TC skeletons
- **And** no Typical, Misuse, or Fault skeletons are present

#### AC-03: Skeleton design without a User Story is accepted but warns

- **Given** a source file but no `--goalStory` or `--goalStoryFile`
- **When** the CLI runs with a skeleton-design behavior
- **Then** the skeletons are generated
- **And** the `@[US]` comment contains a generated placeholder noting the story was not provided
- **And** stderr emits a warning that traceability is incomplete

---

### US-USER-03 [P0] — Review design skeletons (all tiers)

**As a** USER, **I want** the CLI to audit design skeletons across all CaTDD tiers (P0 Functional, P1 Design, P2 Quality) before I implement anything, **so that** I catch coverage gaps and traceability breaks at every level, not just P0.

Paired with: US-USER-02 (design skeletons). Every design action must be reviewable.

#### AC-01: P0 Functional review reports numeric skeleton status

- **Given** a test file containing CaTDD skeleton TCs — some PLANNED, some RED, some GREEN, some with missing categories (DESIGNED, PARTIAL, or FULLY_RED state)
- **When** the CLI runs with `--behave reviewFuncTestsSkeleton` targeting that file
- **Then** stdout includes:
  - Total TC count
  - Count per P0 category (Typical, Edge, Misuse, Fault)
  - Count per status (PLANNED, RED, GREEN)
  - List of TC-IDs missing `@[Category]` or `@[Status]` tags
- **And** no file is modified

#### AC-02: Review on a file without skeletons reports empty

- **Given** a test file with no CaTDD skeleton comments (EMPTY state)
- **When** review is invoked
- **Then** stdout reports: "0 CaTDD skeleton TCs found"
- **And** exit code is 0 (not an error — the file is valid, just empty)

#### AC-03: P1 Design review reports State/Capability/Concurrency status

- **Given** a test file containing P1 design skeleton TCs (State, Capability, Concurrency categories)
- **When** the CLI runs with `--behave reviewDesignTestsSkeleton`
- **Then** stdout includes count per P1 category and per status
- **And** no file is modified

#### AC-04: P2 Quality review reports Performance/Robust/Compatibility/Configuration status

- **Given** a test file containing P2 quality skeleton TCs (Performance, Robust, Compatibility, Configuration categories)
- **When** the CLI runs with `--behave reviewQualityTestsSkeleton`
- **Then** stdout includes count per P2 category and per status
- **And** no file is modified

---

### US-USER-04 [P0] — Select next test case to implement

**As a** USER, **I want** the CLI to tell me exactly which TC to implement next, **so that** I follow TDD discipline without manually scanning the file or guessing priority.

#### AC-01: Next TC is the first unimplemented P0 TC

- **Given** a test file with TC-01 (Typical, PLANNED), TC-02 (Typical, PLANNED), TC-03 (Edge, PLANNED)
- **When** the CLI runs with `--behave tellMeNextImplTest`
- **Then** stdout outputs exactly one TC-ID: `TC-01` (first PLANNED, CaTDD priority order: P0 before P1 before P2, within P0: Typical → Edge → Misuse → Fault)
- **And** stdout includes the TC's category
- **And** no file is modified

#### AC-02: When some TCs are already implemented

- **Given** a test file with TC-01 (RED), TC-02 (PLANNED), TC-03 (PLANNED)
- **When** `tellMeNextImplTest` is invoked
- **Then** stdout selects `TC-02` (first non-implemented, following CaTDD priority order)
- **And** already-RED and GREEN TCs are skipped

#### AC-03: When all TCs are implemented

- **Given** a test file where every TC has `@[Status:RED]` or `@[Status:GREEN]` (FULLY_RED or ALL_GREEN state)
- **When** `tellMeNextImplTest` is invoked
- **Then** stdout reports: "All TCs are already implemented. Nothing to select."
- **And** exit code is 0

---

### US-USER-05 [P0] — Implement one executable test case (RED)

**As a** USER, **I want** the CLI to turn one skeleton TC into compilable test code, **so that** I enter the RED phase of TDD with executable tests, not just comments.

Paired review: US-USER-09 (review implemented test case). Every implementation action must be reviewable.

#### AC-01: Skeleton TC becomes executable RED test

- **Given** a test file where TC-04 has a `@[TC-04]` skeleton comment with `@[Status:PLANNED]`, `@[Category:Edge]`, and valid `@[AC]` traceback, and a source file provides implementation context (`--inputFile`)
- **When** the CLI runs with `--behave implTestCase --target tests/auth_test.cpp::TC-04`
- **Then** TC-04's comment skeleton is preserved (all `@[US]`, `@[AC]`, `@[TC]`, `@[Category]` tags remain)
- **And** an executable test function body is added below the TC-04 skeleton comment
- **And** `@[Status:PLANNED]` is replaced with `@[Status:RED]`
- **And** no other TC in the file is modified
- **And** the file state transitions: DESIGNED → PARTIAL, or PARTIAL → PARTIAL/FULLY_RED

#### AC-02: TC already implemented is not overwritten

- **Given** TC-04 already has `@[Status:RED]` or `@[Status:GREEN]`
- **When** `implTestCase` targets TC-04 again
- **Then** exit code is 1
- **And** stderr reports: "TC-04 is already implemented. Use a review behavior or re-design the skeleton first."
- **And** the file is not modified (no state downgrade)

#### AC-03: Target selector does not resolve to a single TC

- **Given** `--target tests/auth_test.cpp` (a whole file, not a specific TC)
- **When** `--behave implTestCase` is invoked
- **Then** exit code is 1
- **And** stderr reports the `--target` / `--behave` mismatch and suggests valid combinations

#### AC-04: Skeleton fails integrity check before implementation

- **Given** TC-04 has a `@[TC-04]` skeleton comment but is missing `@[Category]`, or has an unrecognized `@[Status]` value (not PLANNED/RED/GREEN)
- **When** `implTestCase` targets TC-04
- **Then** the CLI performs a skeleton integrity pre-check
- **And** exit code is 1
- **And** stderr reports: "TC-04 skeleton integrity check failed: missing @[Category]" (with specifics)
- **And** the file is not modified

---

### US-USER-06 [P1] — Implement all test cases in a file

**As a** USER, **I want** the CLI to implement every PLANNED TC in a file in one invocation, following CaTDD priority order, **so that** I don't invoke `implTestCase` once per TC.

Paired review: US-USER-10 (review all implemented test cases). Every implementation action must be reviewable.

#### AC-01: All PLANNED TCs become RED in priority order

- **Given** a test file with TC-01 (Edge, PLANNED), TC-02 (Typical, PLANNED), TC-03 (Misuse, PLANNED), TC-04 (RED) — TC-04 already implemented
- **When** the CLI runs with `--behave implTestFile --target tests/auth_test.cpp`
- **Then** TCs are implemented in CaTDD priority order, not file order:
  - P0 before P1 before P2
  - Within P0: Typical → Edge → Misuse → Fault
  - Within same category: file order
- **And** implementation order for this file is: TC-02 (Typical) → TC-01 (Edge) → TC-03 (Misuse)
- **And** TC-04 is skipped (already RED)
- **And** stdout reports: "3 TCs implemented, 1 skipped (already implemented), 0 failed"
- **And** all `@[US]`/`@[AC]`/`@[TC]` comments are preserved
- **And** each TC transitions PLANNED → RED only after passing skeleton integrity pre-check (US-USER-05-AC-04)

#### AC-02: One TC implementation fails mid-run

- **Given** TC-02's skeleton fails the integrity pre-check or its implementation encounters an unresolvable error
- **When** `implTestFile` processes TC-02
- **Then** TC-02 is left unmodified (still PLANNED)
- **And** the CLI continues to the next TC in priority order
- **And** stdout reports TC-02 as a failure with the error reason
- **And** the final summary distinguishes implemented, skipped, and failed counts

---

### US-USER-07 [P1] — Batch skeleton design across multiple files

**As a** USER, **I want** to design skeletons into several test files from one source and one User Story, **so that** I can prepare multi-module test coverage in one pass.

#### AC-01: Multiple target files each receive skeletons

- **Given** `--target tests/auth_api_test.cpp,tests/auth_error_test.cpp` and a shared `--inputFile` and `--goalStoryFile`
- **When** the CLI runs with `--behave designAllSkeleton`
- **Then** `tests/auth_api_test.cpp` and `tests/auth_error_test.cpp` are both created or updated
- **And** each file contains US/AC/TC skeletons derived from the shared story and source
- **And** stdout reports per-file results

---

### US-USER-08 [P1] — Combined design-and-implement in one pass

**As a** USER, **I want** the CLI to design all skeletons and immediately implement them in one invocation, **so that** I can go from zero to RED test code without intermediate steps.

Paired review: US-USER-03 (design skeletons review) and US-USER-10 (implementation review). Even combined passes must be reviewable after the fact.

#### AC-01: Design all categories then implement all TCs

- **Given** a source file, a User Story, and an empty or nonexistent target test file (EMPTY state)
- **When** the CLI runs with `--behave designAndImplTest`
- **Then** the target file first receives US/AC/TC skeletons for all applicable P0/P1/P2 categories (EMPTY → DESIGNED)
- **And** the `@[US]` comment preserves the provided User Story for traceability
- **And** then every generated TC receives executable test code, in CaTDD priority order (DESIGNED → FULLY_RED)
- **And** all TCs are marked `@[Status:RED]`
- **And** the trace file records the two-phase execution (design → implement)

---

### US-USER-09 [P0] — Review implemented test case

**As a** USER, **I want** the CLI to audit an implemented RED test case before I write product code, **so that** I verify the test is correct, follows its skeleton, and preserves CaTDD traceability before the GREEN phase.

Paired with: US-USER-05 (implTestCase).

#### AC-01: Review reports implementation quality

- **Given** a test file where TC-04 has `@[Status:RED]` with executable test code and preserved skeleton comments
- **When** the CLI runs with `--behave reviewImplTestCase --target tests/auth_test.cpp::TC-04`
- **Then** stdout includes:
  - Whether `@[Status:RED]` is correctly set
  - Whether the skeleton comments (`@[US]`, `@[AC]`, `@[TC]`, `@[Category]`) are preserved intact
  - Whether the test code follows CaTDD structure
  - Any deviation from the skeleton's AC coverage
- **And** no file is modified

#### AC-02: Review on PLANNED TC reports not-yet-implemented

- **Given** TC-04 has `@[Status:PLANNED]` (not yet implemented)
- **When** `reviewImplTestCase` targets TC-04
- **Then** stdout reports: "TC-04 is not yet implemented (Status: PLANNED). Use a design review behavior first."
- **And** exit code is 0 (not an error)

#### AC-03: Target selector does not resolve to a single TC

- **Given** `--target tests/auth_test.cpp` (a whole file, not a specific TC)
- **When** `--behave reviewImplTestCase` is invoked
- **Then** exit code is 1
- **And** stderr reports the `--target` / `--behave` mismatch and suggests valid combinations

---

### US-USER-10 [P0] — Review all implemented test cases in a file

**As a** USER, **I want** the CLI to audit every implemented RED TC in a file in one invocation, **so that** I can verify implementation quality across the entire file before writing product code.

Paired with: US-USER-06 (implTestFile).

#### AC-01: Review reports per-TC and file-level summary

- **Given** a test file with TC-01 (RED), TC-02 (RED), TC-03 (PLANNED), TC-04 (RED)
- **When** the CLI runs with `--behave reviewImplTestFile --target tests/auth_test.cpp`
- **Then** stdout reports per-TC review results for TC-01, TC-02, TC-04
- **And** TC-03 is skipped with note: "TC-03 is not yet implemented (PLANNED)"
- **And** a file-level summary reports: total RED TCs reviewed, TCs with preserved skeletons, TCs with issues
- **And** no file is modified

#### AC-02: File has no implemented TCs reports empty

- **Given** a test file where all TCs are PLANNED (DESIGNED state, no RED TCs)
- **When** `reviewImplTestFile` is invoked
- **Then** stdout reports: "0 implemented TCs found. All TCs are PLANNED."
- **And** exit code is 0

---

## INVENTOR Requirements

### US-INVENTOR-01 [P0] — Delegate all CaTDD semantics to methodPrompts

**As an** INVENTOR, **I want** the CLI to own zero CaTDD method knowledge, **so that** I can evolve categories, discipline rules, and prompt contracts without touching or re-releasing the CLI.

#### AC-01: Category definition is never hardcoded in the CLI

- **Given** the CLI needs to generate an Edge-category TC skeleton
- **When** it resolves the Edge category meaning
- **Then** it reads from a file under `methodPrompts/` — never from a hardcoded string, enum, or template in the CLI source
- **And** if the required methodPrompt file is missing or unreadable, the CLI exits with an error naming the missing file

#### AC-02: Slash-command behavior delegates to slashCommands

- **Given** the CLI resolves `--behave designFuncTestsSkeleton`
- **When** it executes that behavior
- **Then** it invokes the corresponding portable command under `slashCommands/commands/`
- **And** it does not inline or duplicate the command's logic

#### AC-03: All CaTDD artifacts in output are produced by delegated layers

- **Given** any CLI invocation that modifies a test file
- **When** CaTDD-specific content appears in the output (`@[US]`, `@[AC]`, `@[TC]`, `@[Category]`, `@[Status]`)
- **Then** that content was produced by a methodPrompt or slashCommand — never generated by the CLI itself from a hardcoded string or template

> **Note**: US-INVENTOR-01 (delegation by design) and US-INVENTOR-03 (diagnostic visibility) form a pair: US-INVENTOR-01 is the architectural guarantee; US-INVENTOR-03 is the runtime proof that delegation actually occurred.

---

### US-INVENTOR-02 [P0] — Produce machine-readable execution traces

**As an** INVENTOR, **I want** every CLI run to leave a structured trace, **so that** I can audit method compliance, replay invocations, and detect drift between what was asked and what was done.

#### AC-01: Trace is written on successful execution

- **Given** a valid CLI invocation completes successfully
- **When** the CLI exits
- **Then** a trace artifact exists in a discoverable location
- **And** the trace includes: timestamp, full invocation string, resolved arguments, resolved slash commands (with file paths), files modified, TC-IDs affected with before/after status, exit code, and duration

#### AC-02: Trace is written on execution failure

- **Given** a valid CLI invocation fails during execution (not during argument parsing)
- **When** the CLI exits with code 1
- **Then** the trace artifact still exists
- **And** it records the failure point: which step was active, the error message, and which steps completed before the failure

#### AC-03: Trace format is machine-parseable

- **Given** any trace artifact written by the CLI
- **When** parsed by a standard JSON or YAML parser
- **Then** it is valid and all fields follow a documented schema

---

### US-INVENTOR-03 [P1] — Diagnostic visibility into method resolution

**As an** INVENTOR, **I want** `--diagMethodPrompts` and `--diagSlashCommands` to reveal exactly which prompts and commands the CLI resolved, **so that** I can verify the CLI did not substitute, skip, or bypass any CaTDD asset.

#### AC-01: --diagMethodPrompts logs resolved prompts

- **Given** any valid CLI invocation with `--diagMethodPrompts`
- **When** the CLI resolves method prompts during execution
- **Then** stderr (or the diagnostic log stream) lists each resolved prompt file path and the CaTDD category or rule it was resolved for

#### AC-02: --diagSlashCommands logs resolved commands

- **Given** a `--behave designFuncTestsSkeleton` invocation with `--diagSlashCommands`
- **When** the CLI resolves the behavior to one or more slash commands
- **Then** the diagnostic output lists each slash command name and file path in resolution order

---

## DEVELOPER Requirements

### US-DEV-01 [P0] — Actionable error messages for all failure states

**As a** DEVELOPER, **I want** every error message to name the problem, identify the affected argument, and suggest the correction, **so that** I can debug invocation issues without reading CLI source code.

#### AC-01: Unrecognized argument value suggests a correction

- **Given** the CLI is invoked with `--behave "deisgnAllSkeleton"` (typo)
- **When** validation fails
- **Then** stderr includes the string `"deisgnAllSkeleton"` is not recognized
- **And** stderr includes a suggestion: `"Did you mean 'designAllSkeleton'?"` (best match)
- **And** stderr includes the full list of valid values

#### AC-02: Missing file error includes the exact path

- **Given** `--inputFile nonexistent/path.h`
- **When** validation fails
- **Then** stderr includes the full resolved path `nonexistent/path.h`
- **And** stderr states the argument name (`--inputFile`)

#### AC-03: Target/behavior mismatch explains why and suggests alternatives

- **Given** `--target tests/auth_test.cpp::TC-03 --behave designAllSkeleton`
- **When** validation detects the mismatch
- **Then** stderr explains: skeleton design requires a file-level `--target`, not a TC-level target
- **And** stderr suggests valid `--target` forms for skeleton design or valid `--behave` values for TC-level targets

---

### US-DEV-02 [P1] — Configurable logging and diagnostic output

**As a** DEVELOPER, **I want** `--log-level` to control output verbosity, **so that** I can run quietly in production or verbosely when debugging.

#### AC-01: --log-level error suppresses non-error output

- **Given** any valid invocation with `--log-level error`
- **When** the CLI executes successfully
- **Then** only error-class messages appear in stderr
- **And** stdout is unaffected (behavior output still appears)

#### AC-02: --log-level debug reveals internal resolution

- **Given** any valid invocation with `--log-level debug`
- **When** the CLI executes
- **Then** stderr includes state transitions: argument parsing, behavior resolution, slash-command selection, file writes

---

### US-DEV-03 [P1] — Interactive per-command confirmation

**As a** DEVELOPER, **I want** to preview each slash command before it runs, **so that** I can approve, skip, or abort multi-step invocations without blind execution.

#### AC-01: Each slash command prompts before execution

- **Given** a `designAndImplTest` invocation with `--interactive-slash-commands`
- **When** the CLI resolves a slash command (e.g., `UT_designFuncTestsSkeleton`)
- **Then** stdout prompts: "Execute UT_designFuncTestsSkeleton on tests/auth_api_test.cpp? [y/n/s(kip)/a(bort)]"
- **And** the CLI waits for input before proceeding

#### AC-02: Abort stops all further execution

- **Given** an interactive session with multiple pending slash commands
- **When** the user inputs "a" (abort) at any prompt
- **Then** no further slash commands execute
- **And** the CLI exits with code 1
- **And** the trace records which commands were skipped

---

### US-DEV-04 [P2] — Runtime adapter interface

**As a** DEVELOPER, **I want** the CLI's slash-command execution backend to be replaceable through a documented adapter interface, **so that** `utCodeAgentCLI` can run on top of Copilot-native, OpenCode, or custom agent runtimes without rewriting the CLI core.

#### AC-01: Adapter conforms to a defined interface

- **Given** a runtime adapter implementing the `CliRuntimeAdapter` interface
- **When** the CLI needs to invoke a slash command
- **Then** it calls the adapter's `invoke(slashCommand, context)` method
- **And** the adapter receives the resolved command path, target, source, and goal context
- **And** the CLI does not assume any specific runtime (TypeScript, Python, shell)

#### AC-02: Default adapter is provided

- **Given** no custom adapter is configured
- **When** the CLI runs
- **Then** a built-in default adapter executes slash commands directly

---

## Acceptance Criteria Summary

| AC ID | Requirement | Given | When | Then |
| --- | --- | --- | --- | --- |
| US-USER-01-AC-01 | US-USER-01 | CLI invoked without --goal | argument parsing runs | exit 1, stderr names --goal |
| US-USER-01-AC-02 | US-USER-01 | both --goalStory and --goalStoryFile provided | argument parsing runs | exit 1, stderr names conflicting args |
| US-USER-01-AC-03 | US-USER-01 | --behave "nonexistent" | behavior resolution runs | exit 1, stderr lists valid values |
| US-USER-01-AC-04 | US-USER-01 | file-path arg points to nonexistent file | validation runs | exit 1, stderr names missing path |
| US-USER-01-AC-05 | US-USER-01 | all args valid | parsing completes | exit 0, execution proceeds |
| US-USER-02-AC-01 | US-USER-02 | story + source + empty target | designFuncTestsSkeleton | file gets US/AC/TC skeletons for all 4 P0 categories |
| US-USER-02-AC-02 | US-USER-02 | story + source + target | designEdgeSkeleton | file gets only Edge skeletons |
| US-USER-02-AC-03 | US-USER-02 | source but no story | skeleton design behavior | skeletons generated, @[US] placeholder, stderr warns |
| US-USER-03-AC-01 | US-USER-03 | file has skeleton TCs | reviewFuncTestsSkeleton | stdout reports P0 counts per category and status |
| US-USER-03-AC-02 | US-USER-03 | file is EMPTY | review invoked | stdout reports "0 skeletons found", exit 0 |
| US-USER-03-AC-03 | US-USER-03 | file has P1 design skeletons | reviewDesignTestsSkeleton | stdout reports counts per P1 category and status |
| US-USER-03-AC-04 | US-USER-03 | file has P2 quality skeletons | reviewQualityTestsSkeleton | stdout reports counts per P2 category and status |
| US-USER-04-AC-01 | US-USER-04 | file has PLANNED TCs | tellMeNextImplTest | stdout outputs first PLANNED TC-ID in CaTDD priority |
| US-USER-04-AC-02 | US-USER-04 | TC-01 RED, TC-02/03 PLANNED | tellMeNextImplTest | stdout selects TC-02, skips RED |
| US-USER-04-AC-03 | US-USER-04 | all TCs RED or GREEN | tellMeNextImplTest | stdout reports all implemented, exit 0 |
| US-USER-05-AC-01 | US-USER-05 | TC-04 skeleton is PLANNED + valid | implTestCase | TC-04 gets test code, status → RED, others unchanged |
| US-USER-05-AC-02 | US-USER-05 | TC-04 already RED | implTestCase | exit 1, stderr reports already implemented, no changes |
| US-USER-05-AC-03 | US-USER-05 | --target is whole file not single TC | implTestCase | exit 1, stderr reports mismatch |
| US-USER-05-AC-04 | US-USER-05 | TC-04 skeleton missing @[Category] | implTestCase pre-check | exit 1, stderr reports integrity failure, no changes |
| US-USER-06-AC-01 | US-USER-06 | file has mixed PLANNED/RED TCs | implTestFile | TCs implemented in CaTDD priority order, summary reported |
| US-USER-06-AC-02 | US-USER-06 | TC-02 fails during run | implTestFile mid-execution | TC-02 left PLANNED, continues to next, summary counts failures |
| US-USER-07-AC-01 | US-USER-07 | multiple --target files + shared source | designAllSkeleton | each file receives skeletons, per-file results reported |
| US-USER-08-AC-01 | US-USER-08 | story + source + empty target | designAndImplTest | skeletons designed then all TCs implemented → FULLY_RED |
| US-USER-09-AC-01 | US-USER-09 | TC-04 is RED with preserved skeleton | reviewImplTestCase | stdout reports skeleton preservation and test quality |
| US-USER-09-AC-02 | US-USER-09 | TC-04 is PLANNED (not implemented) | reviewImplTestCase | stdout reports not yet implemented, exit 0 |
| US-USER-09-AC-03 | US-USER-09 | --target is whole file not single TC | reviewImplTestCase | exit 1, stderr reports mismatch |
| US-USER-10-AC-01 | US-USER-10 | file has mixed RED/PLANNED TCs | reviewImplTestFile | per-TC review for RED TCs, PLANNED skipped, file summary |
| US-USER-10-AC-02 | US-USER-10 | file has no RED TCs (all PLANNED) | reviewImplTestFile | stdout reports "0 implemented TCs", exit 0 |
| US-INVENTOR-01-AC-01 | US-INVENTOR-01 | CLI needs Edge category meaning | resolves category | reads from methodPrompts/, exits if file missing |
| US-INVENTOR-01-AC-02 | US-INVENTOR-01 | --behave designFuncTestsSkeleton | executes behavior | invokes slashCommands/, no inline logic |
| US-INVENTOR-01-AC-03 | US-INVENTOR-01 | CLI modifies test file | CaTDD content appears | content from methodPrompt or slashCommand, never hardcoded |
| US-INVENTOR-02-AC-01 | US-INVENTOR-02 | valid invocation succeeds | CLI exits | trace artifact exists with invocation, resolution, output data |
| US-INVENTOR-02-AC-02 | US-INVENTOR-02 | valid invocation fails during execution | CLI exits code 1 | trace records failure point and completed steps |
| US-INVENTOR-02-AC-03 | US-INVENTOR-02 | trace artifact exists | parsed by JSON/YAML | valid, all fields match documented schema |
| US-INVENTOR-03-AC-01 | US-INVENTOR-03 | invocation with --diagMethodPrompts | CLI resolves prompts | diagnostic output lists prompt paths and categories |
| US-INVENTOR-03-AC-02 | US-INVENTOR-03 | invocation with --diagSlashCommands | CLI resolves commands | diagnostic output lists command names and paths |
| US-DEV-01-AC-01 | US-DEV-01 | --behave with typo | validation fails | stderr suggests correction + lists valid values |
| US-DEV-01-AC-02 | US-DEV-01 | --inputFile points to missing file | validation fails | stderr names path + argument name |
| US-DEV-01-AC-03 | US-DEV-01 | TC target + skeleton design behavior | validation detects mismatch | stderr explains why + suggests alternatives |
| US-DEV-02-AC-01 | US-DEV-02 | --log-level error | execution succeeds | stderr has only errors, stdout unaffected |
| US-DEV-02-AC-02 | US-DEV-02 | --log-level debug | execution runs | stderr shows state transitions |
| US-DEV-03-AC-01 | US-DEV-03 | designAndImplTest + interactive | CLI resolves slash command | prompts for confirmation [y/n/s/a] |
| US-DEV-03-AC-02 | US-DEV-03 | interactive session, user inputs "a" | at any prompt | no further commands, exit 1, trace records skipped |
| US-DEV-04-AC-01 | US-DEV-04 | adapter implements CliRuntimeAdapter | CLI invokes slash command | calls adapter.invoke() with full context |
| US-DEV-04-AC-02 | US-DEV-04 | no custom adapter configured | CLI runs | built-in default adapter executes directly |

---

## Requirement Dependency Graph

```
US-USER-01 (parse & validate)
  │
  ├──► US-DEV-01 (error messages) ── applies to all validation in US-USER-01
  ├──► US-DEV-02 (logging)
  ├──► US-DEV-03 (interactive)
  ├──► US-INVENTOR-02 (execution traces) ── depends on parsed args from US-USER-01
  │
  ├──► US-USER-02 (design skeletons) ── needs US-INVENTOR-01 (delegate semantics)
  │       │
  │       ├──► US-USER-03 (review design, all tiers) ── paired review of US-USER-02
  │       ├──► US-USER-04 (pick next) ── depends on US-USER-02 output
  │       └──► US-USER-07 (batch design) ── reuses US-USER-02 per file
  │
  ├──► US-USER-05 (implement one TC) ── needs US-INVENTOR-01
  │       │
  │       ├──► US-USER-09 (review one impl) ── paired review of US-USER-05
  │       └──► US-USER-06 (implement all) ── loops US-USER-05 in CaTDD priority order
  │               │
  │               └──► US-USER-10 (review all impl) ── paired review of US-USER-06
  │
  └──► US-USER-08 (design+implement) ── chains US-USER-02 → US-USER-05
                                          post-review via US-USER-03 + US-USER-10

US-INVENTOR-01 (delegate semantics) ── required by: US-USER-02, US-USER-05, US-USER-06, US-USER-08, US-USER-09, US-USER-10
US-INVENTOR-03 (diagnostic visibility) ── cross-cutting, depends on US-USER-01
                                           (runtime proof of US-INVENTOR-01)

US-DEV-04 (adapter interface) ── P2, independent of all other requirements
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
| Transition a TC from RED to GREEN (`@[Status:GREEN]`) | User's TDD workflow; CLI reads GREEN but never writes it |

---

## Traceability

| Artifact | Relationship to these requirements |
| --- | --- |
| [README_UsageDesign.md](README_UsageDesign.md) | Specifies the CLI argument contract that satisfies US-USER-01, US-USER-02, US-USER-05. Defines `--behave` aliases — including `review*Skeleton` and `reviewImpl*` — for US-USER-03, US-USER-09, US-USER-10. Error handling satisfies US-DEV-01. |
| [README_UserGuide.md](README_UserGuide.md) | Documents the invocation-plan workflow that satisfies all USER requirements. Behavior Selection Guide maps user intent to US-USER-02–US-USER-10. |
| [README.md](README.md) | Defines WHAT the CLI layer is and WHY it exists — the architectural context for all requirements. |
| `methodPrompts/` | Supplies category semantics required by US-INVENTOR-01. Every USER design/implementation requirement depends on this layer. |
| `slashCommands/` | Supplies portable command execution required by US-INVENTOR-01. Every `--behave` value resolves to assets in this layer. |
| [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md) | Original request that initiated these requirements. |

### Old → New ID Mapping

| Old ID | New ID |
| --- | --- |
| REQ-CLI-U01 | US-USER-01 |
| REQ-CLI-U02 | US-USER-02 |
| REQ-CLI-U03 | US-USER-03 |
| REQ-CLI-U04 | US-USER-04 |
| REQ-CLI-U05 | US-USER-05 |
| REQ-CLI-U06 | US-USER-06 |
| REQ-CLI-U07 | US-USER-07 |
| REQ-CLI-U08 | US-USER-08 |
| REQ-CLI-I01 | US-INVENTOR-01 |
| REQ-CLI-I02 | US-INVENTOR-02 |
| REQ-CLI-I03 | US-INVENTOR-03 |
| REQ-CLI-D01 | US-DEV-01 |
| REQ-CLI-D02 | US-DEV-02 |
| REQ-CLI-D03 | US-DEV-03 |
| REQ-CLI-D04 | US-DEV-04 |

---

## Open Questions

- What is the trace file output directory and naming convention? Should the user control it via `--trace-dir`?
- Should `--log-level` support a `trace` level below `debug` for raw prompt/response logging?
- For US-DEV-04 (adapters), which runtimes should the first adapter target: raw TypeScript CLI, Copilot-native, or OpenCode-compatible?
- Should `--target` accept a target-list file (`--target-file`) as an alternative to comma-separated inline paths?
- Should `--interactive-slash-commands` support a timeout for unattended CI runs?

---

## Maintenance Rule

Add a new requirement when a user need cannot be traced to any existing US-* ID. Each requirement must have at least one verifiable acceptance criterion with a unique AC ID.

Do **not** place architecture decisions or detailed implementation behavior here — those belong in `README_ArchDesign.md` and `README_DetailDesign.md`.

This document is the requirements mandate. Downstream docs implement it — they do not drive it.
