# utCodeAgentCLI Requirements — USER

> Master index, state model, and quick-reference AC checklist: [README_UserStory.md](README_UserStory.md)

Two sub-roles shape distinct USER paths:

| Sub-role | Concern |
| --- | --- |
| **NEW-USER** | "I don't know CaTDD's category system or TDD discipline yet. Don't make me pick Typical from Edge or guess which TC to implement next — show me what coverage structure my code needs, explain gaps in my skeletons, and guide me through one step at a time." |
| **EXPERIENCED-USER** | "I know the method. Let me invoke surgery: design one specific category, implement an exact TC-ID, chain operations across multiple files. Surface errors, not hand-holding. I also review team coverage and run in CI — give me parseable output and clear exit codes." |

---

### US-USER-01 [P0] — Parse and validate CLI arguments

**As a** USER, **I want** the CLI to validate my invocation immediately, **so that** I get clear, actionable feedback when my arguments are wrong instead of silent misbehavior.

#### AC-01: Missing required argument exits with error
- **Given** the CLI is invoked without `--goal`
- **When** argument parsing runs
- **Then** exit code is 1, stderr contains `"--goal"`, and stderr describes what `--goal` is for and why it is required
- **And** the same applies to `--target` and `--behave`

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
- **And** it contains a `@[US]` comment matching the provided User Story
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
- **Then** stdout includes: total TC count, count per P0 category (Typical, Edge, Misuse, Fault), count per status (PLANNED, RED, GREEN), list of TC-IDs missing `@[Category]` or `@[Status]` tags
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
- **Then** TCs are implemented in CaTDD priority order, not file order: P0 before P1 before P2, within P0 Typical → Edge → Misuse → Fault, within same category file order
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
- **Then** stdout includes: whether `@[Status:RED]` is correctly set, whether the skeleton comments are preserved intact, whether the test code follows CaTDD structure, any deviation from the skeleton's AC coverage
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
