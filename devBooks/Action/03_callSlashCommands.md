# 03 callSlashCommands

## What Are Slash Commands?

Slash commands are the operational layer of CaTDD — they turn method prompts into executable command flows that any CodeAgent can consume. A slash command is not a CLI command in the traditional sense. It is a **Markdown prompt file** that tells a CodeAgent exactly what to do: what step to run now, what to read, what to produce, what to preserve, and what command should come next.

The layer lives in `slashCommands/` and follows a strict architectural principle: **slashCommands does not redefine CaTDD method semantics**. It transforms what `methodPrompts` defines into portable, repeatable command units. When a slash command conflicts with methodPrompts, methodPrompts always wins.

---

## The Two Command Families

Slash commands are organized into two families that serve different purposes:

### UT Commands — Unit Test Design and Implementation

```text
UT_<verb><Object>
```

UT commands execute CaTDD test development steps. They operate on test files, design skeletons, and implementation artifacts. They belong to category-specific flows (P0, P1, P2).

**Examples**:
- `UT_designTypicalSkeleton` — Design the Typical category design skeleton
- `UT_implTestCase` — Implement a single test case following the RED→GREEN cycle
- `UT_reviewFuncTestsSkeleton` — Review the complete P0 functional skeleton set before implementation
- `UT_tellMeNextImplTest` — Select the next test case to implement from the TODO tracking section

### SPEC Commands — SpecCoding Lifecycle Orchestration

```text
SPEC_<verb><Object>
```

SPEC commands drive work through a traceable SpecCoding lifecycle. They operate on lifecycle artifacts — project context, pending news, user stories, design docs, tests, product code, and commit/CI state — not on test categories or category skeletons directly.

**Examples**:
- `SPEC_initProjectContext` — Create the first project context file
- `SPEC_analyzeIssue` — Convert an issue into a traceable user story
- `SPEC_takeArchDesign` — Produce high-level architecture design
- `SPEC_designUnitTests` — Enter CaTDD test design, typically through P0/P1/P2 flows
- `SPEC_commitWorks` — Prepare and commit completed work
- `SPEC_closeUserStory` — Move reviewed completed work to the done archive

---

## The Universal Command Template

Every slash command follows the same Markdown structure defined in `UT_slashCommandTemplate.md` and `SPEC_slashCommandTemplate.md`:

| Section | Content |
|---|---|
| **Command Header** | Command name, flow, CaTDD class, category, method source, adapter target |
| **WHO** | Who invokes this command and who should act on it |
| **WHAT** | Exactly what this command does — the single workflow step it performs |
| **WHEN** | Valid starting conditions, when NOT to use it, previous/next commands |
| **WHERE** | Input files, output files, method references, related flow documents |
| **WHY** | Developer value, CaTDD method reason, how it reduces ambiguity |
| **HOW** | Execution procedure — what to read, preserve, perform, report |
| **Input Contract** | Command parameters using portable placeholders |
| **Output Contract** | Expected response shape — summary, files touched, next command |
| **CodeAgent Compatibility** | Plain Markdown, no tool-specific assumptions |

This consistency means every CodeAgent (Copilot, Cline, Continue, utCodeAgentCLI) can parse and execute any slash command using the same structure.

---

## The Four Command Flows

Commands are organized into four flows, each with a documented command sequence:

```
slashCommands/flows/
├── P0-FuncTestsFlow.md    ← UT commands for functional test design
├── P1-DesignTestsFlow.md   ← UT commands for design-oriented tests
├── P2-QualityTestsFlow.md  ← UT commands for quality-oriented tests
└── Px-SpecFlow.md          ← SPEC commands for full lifecycle orchestration
```

`Px` in SpecFlow means "cross-priority" — it is not a test category priority like P0/P1/P2. It is a process flow that orchestrates those test layers.

---

## P0 FuncTestsFlow — The First Flow to Learn

P0 is the most common entry point because it covers functional test design — what every developer needs first. The flow diagram shows the complete command sequence:

```
              Existing demo tests
                      │
                      ▼
         ┌─────────────────────────┐
         │ UT_convertDemoToTypical │
         └───────────┬─────────────┘
                     │
                     ▼
    Interface/protocol ──→ UT_designTypicalSkeleton
                                      │
                                      ▼
                              Typical skeleton
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
    UT_designEdgeSkeleton    UT_designMisuseSkeleton   UT_designFaultSkeleton
              │                       │                       │
              └───────────────────────┼───────────────────────┘
                                      ▼
                          P0 functional skeleton set
                                      │
                                      ▼
                       UT_reviewFuncTestsSkeleton
                                      │
                                      ▼
                       UT_tellMeNextImplTest
                                      │
              ┌───────────────────────┘
              ▼
      UT_implTestCase ──→ UT_reviewImplTestCase
              │                       │
              └───────────────────────┘
                      (loop)
```

### Entry Points

You can start P0 flow from two places:

1. **Existing demo tests**: If you have demo/example code that exercises the component, use `UT_convertDemoToTypical` to extract core behavior into a CaTDD Typical skeleton. This preserves existing work rather than starting from scratch.

2. **Interface or protocol**: If you have API headers or a spec document, use `UT_designTypicalSkeleton` to design the Typical skeleton from the interface contract.

### Command-by-Command Walkthrough

#### Option A: UT_convertDemoToTypical

**When**: You have existing demo tests that demonstrate component usage. These are NOT CaTDD P3 Demo/Example tests — they are raw input material that captures core workflows.

**What it does**: Reads the demo test, extracts the core behavior patterns, maps them to CaTDD Typical category format, and writes a Typical design skeleton with US/AC/TC structure.

**Output**: A CaTDD Typical skeleton in the target test file, with `@[US]`, `@[AC]`, `@[TC]` markers and the OVERVIEW section populated.

**Next command**: `UT_designEdgeSkeleton`

#### Option B: UT_designTypicalSkeleton

**When**: Starting from an interface or protocol — no existing demo code.

**What it does**: Reads the interface specification, analyzes the API contract, identifies core happy-path scenarios, and designs the Typical skeleton with User Stories, Acceptance Criteria, and Test Cases.

**Output**: The Typical design skeleton with complete US/AC/TC chain.

**Next command**: `UT_designEdgeSkeleton`

#### Step 3-5: UT_designEdgeSkeleton, UT_designMisuseSkeleton, UT_designFaultSkeleton

Each command designs one category skeleton by reading the existing skeletons (for consistency), the API interface, and the category-specific method prompt. They follow the P0 order: Edge after Typical, Misuse after Edge, Fault after Misuse.

**Alternative**: Use `UT_designFuncTestsSkeleton` to design all four P0 skeletons (Typical + Edge + Misuse + Fault) as a single behavior when you want to design the complete functional set at once.

**Important**: Each skeleton references the same US IDs across categories. For example, US-1 covers Typical scenarios, and the same US-1 might also have Misuse scenarios (what happens when this capability is used incorrectly within the same user story).

#### Step 6: UT_reviewFuncTestsSkeleton

**When**: All P0 skeletons are designed but not yet implemented.

**What it does**: Reviews the complete P0 functional skeleton set for:
- Completeness: Are all four categories present?
- Traceability: Does every TC reference an AC, every AC reference a US?
- Category correctness: Are Misuse scenarios classified correctly (not accidentally in Edge)?
- Consistency: Do skeleton names, status markers, and formats follow conventions?
- Gate readiness: Is the design ready for P0 implementation?

**Output**: Review report with PASS/FAIL for each quality dimension and specific issues to fix.

**Next command**: If PASS → `UT_tellMeNextImplTest`. If FAIL → back to the specific design command.

**Important**: Never skip this review gate. Design flaws caught here are 10x cheaper than implementation flaws caught later.

#### Step 7: UT_tellMeNextImplTest

**When**: Ready to begin implementation — all skeletons reviewed and approved.

**What it does**: Reads the TODO tracking section across all test files, evaluates the P0 default order (Typical → Edge → Misuse → Fault), checks for dependencies (is TC-3 blocked because capability API doesn't exist?), and recommends the next test case to implement.

**Output**: The name of the next TC, the file it lives in, its category, its estimated complexity, and any dependencies or blockers.

#### Step 8: UT_implTestCase

**When**: A specific TC has been selected for implementation.

**What it does**: Implements one test case following the strict TDD cycle:
1. Writes the test implementation (4-phase: SETUP/BEHAVIOR/VERIFY/CLEANUP)
2. Marks it 🔴 RED in the TODO section
3. Runs the test — confirms RED (failing because production code is missing)
4. Implements minimal production code
5. Runs the test — confirms GREEN (passing)
6. Marks it 🟢 GREEN in the TODO section
7. Updates the TC specification with implementation notes

**Output**: An implemented test case with RED→GREEN history and updated status marker.

**Next command**: `UT_reviewImplTestCase`

#### Step 9: UT_reviewImplTestCase

**What it does**: Reviews the implementation for:
- Correctness: Does the test actually verify the AC it claims to verify?
- Structure: Does it follow the 4-phase pattern?
- Assertions: Are there ≤3 key assertions, and are they meaningful?
- Traceability: Is the US/AC/TC chain preserved?
- Isolation: Does cleanup happen and prevent state leakage?
- Status: Are the markers correctly set?

**Output**: Review report with PASS/FAIL. If PASS, loop back to `UT_tellMeNextImplTest` for the next TC. If FAIL, route back for fixes.

---

## The RED→GREEN Discipline in Slash Commands

The `UT_implTestCase` command enforces strict TDD discipline. Here is what happens in detail:

### RED Phase

```
1. Read the TC specification (the comment design)
2. Write the test function following the 4-phase pattern
3. Add @[Name] and @[Steps] comments above the test function
4. Update the TODO tracking section: ⚪ → 🔴 RED/FAILING
5. Compile and run — verify the test FAILS
6. If it passes: investigate. Either:
   a) The test is poorly written (doesn't test the right thing)
   b) The feature already exists (production code was written first — TDD violation!)
   c) The test framework is misconfigured
7. Report: "RED confirmed. Test fails as expected because [reason].
   Ready for production code implementation."
```

### GREEN Phase

```
1. Read the test code and understand what production code is needed
2. Write minimal production code — just enough to make this test pass
3. Do NOT implement untested features or over-engineer
4. Compile and run — verify the test PASSES
5. Update the TODO tracking section: 🔴 → 🟢 GREEN/PASSED
6. Run the full test file — verify no regressions
7. Commit the change
8. Report: "GREEN confirmed. Test passes. [N] tests remain in P0."
```

### The "Minimal Production Code" Rule

This is critical. When `UT_implTestCase` is in the GREEN phase, it must implement **only enough production code to make the current test pass**. Not one line more. This prevents:

- Dead code: code written but never tested
- Over-engineering: implementing features not requested by any test
- False confidence: tests passing because extra code accidentally satisfies them
- Lost traceability: production code with no corresponding TC

---

## P1-DesignTestsFlow and P2-QualityTestsFlow

P1 and P2 flows follow the same structure as P0 but for their respective categories. However, they have a critical constraint that P0 does not: **the Design Source Gate**.

### The Design Source Gate

P1 and P2 commands require a confirmed design source before any skeleton drafting can begin. This prevents tests from being designed without architectural decisions:

| Priority | Category | Required Design Source |
|---|---|---|
| P1 | State | `README_StateDesign.md` or a `State Design` chapter in `README_ArchDesign.md` |
| P1 | Capability | `README_DetailDesign.md` |
| P1 | Concurrency | `README_ResourceDesign.md` |
| P2 | Performance | `README_PerfDesign.md` |
| P2 | Robust | `README_ErrorDesign.md` |
| P2 | Compatibility | `README_CompatDesign.md` |
| P2 | Configuration | `README_DetailDesign.md` |

If the required design source is missing, the command **warns and stops** before drafting the skeleton. It asks the developer: "Where does the state architecture design live? I need it before I can design state tests." This gate enforces the principle that P1 and P2 tests verify **architectural decisions**, not just API behavior.

### P1-DesignTestsFlow

Addresses architectural validation: State, Capability, and Concurrency.

```
P0 functional skeletons (completed)
         │
    ┌────┼────┐
    ▼    ▼    ▼
UT_designStateSkeleton  UT_designCapabilitySkeleton  UT_designConcurrencySkeleton
    │         │                    │
    └────┬────┘                    │
         ▼                         │
 UT_reviewDesignTestsSkeleton ←────┘
         │
         ▼
 UT_tellMeNextImplTest → UT_implTestCase → UT_reviewImplTestCase
```

**Entry conditions**: P0 functional skeletons must exist (especially Typical and Edge). Each P1 category requires a confirmed design source. P1 MUST have DESIGN before skeleton drafting starts.

**Gate P1**: Before entering P1, all P0 tests must be GREEN. Before leaving P1, architecture must be validated (no deadlocks, no race conditions, ThreadSanitizer clean).

### P2-QualityTestsFlow

Addresses non-functional quality attributes: Performance, Robust, Compatibility, Configuration.

```
P0/P1 stable coverage (completed)
         │
    ┌────┼────┬────┐
    ▼    ▼    ▼    ▼
UT_designPerformanceSkeleton  UT_designRobustSkeleton  UT_designCompatibilitySkeleton  UT_designConfigurationSkeleton
    │         │                    │                              │
    └────┬────┘                    │                              │
         ▼                         │                              │
 UT_reviewQualityTestsSkeleton ←───┘──────────────────────────────┘
         │
         ▼
 UT_tellMeNextImplTest → UT_implTestCase → UT_reviewImplTestCase
```

**Entry conditions**: P0 functional coverage exists, P1 design coverage exists when relevant, and each P2 category has a confirmed project-root design source.

**Gate P2**: Before entering P2, P1 must be complete. Before leaving P2, quality SLOs must be met and production readiness criteria satisfied.

---

## Px-SpecFlow — The Master Orchestration Flow

Px-SpecFlow is the largest and most important flow because it orchestrates the full SpecCoding lifecycle. While UT flows execute test-specific steps, SPEC commands manage the entire story lifecycle from import to closure.

### The SpecFlow Lifecycle

```
pendingNews → todoUS → doingUS → doneUS
                         ↘ abortUS for unsafe active stories
```

Every work item normally moves through four stages, with `abortUS` preserving active stories that should not continue in place:

| Stage | Directory | Meaning |
|---|---|---|
| **pendingNews** | `.catdd/spec/pendingNews/` | Work waiting to be analyzed. Raw issues, feature requests, imported user stories. |
| **todoUS** | `.catdd/spec/todoUS/` | Work analyzed and ready to pick up. Structured user stories with acceptance criteria candidates. |
| **doingUS** | `.catdd/spec/doingUS/` | Active work in progress. Opened user stories going through design, test, or implementation. |
| **abortUS** | `.catdd/spec/abortUS/` | Aborted active work preserved for later analysis or a next-round improvement input. |
| **doneUS** | `.catdd/spec/doneUS/` | Completed work. Reviewed, committed, CI-passed stories. |

### The Full Command Sequence

The complete SpecFlow lifecycle has 21+ commands organized into three phases:

#### Phase A: Pre-Story (input and analysis)

```
1. SPEC_initProjectContext
   Creates .catdd/spec/projectContext.md — the shared project constitution

2. SPEC_importIssue / SPEC_importFeature
   Imports work input into pendingNews/

3. SPEC_importUserStory
   Queues already-structured user stories directly into todoUS/ (skips analysis)

4. SPEC_analyzeIssue / SPEC_analyzeFeature
   Converts pending input into traceable user stories in todoUS/
   Moves raw input from pendingNews/ to analyzedNews/ for traceability

5. SPEC_openUserStory
   Moves selected story from todoUS/ to doingUS/ (work begins)
```

#### Phase B: Design and Planning

```
6. SPEC_clearStoryIntent (optional but recommended)
   Aligns developer intent and CodeAgent intent before design
   Records Mutual Intent Contract: scope, non-goals, success signal, assumptions

7. SPEC_makePlan
   Creates paired task artifact (*-TASKs.md) in doingUS/
   Classifies work as: intent-clearing, requirement-oriented, design-oriented, or implementation-oriented
   Decides which SPEC_* step comes next

   ┌─ If requirement-oriented ──────────────────────────┐
   │ 8.  SPEC_updateUserStory                            │
   │     Updates module README_UserStory.md and README_UserGuide.md
   │ 9.  SPEC_reviewUserStory                            │
   │     Reviews requirement quality                      │
   │     If PASS: SPEC_commitWorks → SPEC_closeUserStory  │
   │     or transfers to design-oriented next steps       │
   └─────────────────────────────────────────────────────┘

   ┌─ If design-oriented (initial architecture) ─────────┐
   │ 10. SPEC_takeArchDesign                              │
   │     Produces README_ArchDesign.md                     │
   │ 11. SPEC_reviewArchDesign                            │
   │     Gates architecture quality before detail design   │
   │ 12. SPEC_updateArchDesign (if review fails)           │
   └─────────────────────────────────────────────────────┘

   ┌─ If design-oriented (initial detail) ───────────────┐
   │ 13. SPEC_takeDetailDesign                            │
   │     Produces README_DetailDesign.md and ACs           │
   │ 14. SPEC_reviewDetailDesign                          │
   │     Gates detail design quality                       │
   │ 15. SPEC_updateDetailDesign (if review fails)         │
   └─────────────────────────────────────────────────────┘
```

#### Phase C: Implementation and Closure

```
   ┌─ If implementation-oriented ────────────────────────┐
   │ 16. SPEC_designUnitTests                             │
   │     Enters CaTDD test design via P0/P1/P2 flows      │
   │ 17. SPEC_implUnitTests                               │
   │     Implements selected TCs (RED→GREEN)              │
   │ 18. SPEC_implProductCodes                            │
   │     Implements production code to pass tests          │
   │ 19. SPEC_reviewProductCodes                          │
   │     Reviews implementation quality                    │
   │                                                       │
   │     If review FAILS:                                  │
   │ 20. SPEC_abortUserStory (when unsafe to continue)     │
   │     Moves active story to abortUS for later analysis  │
   └─────────────────────────────────────────────────────┘

21. SPEC_commitWorks
    Prepares and commits completed work

22. SPEC_closeUserStory
    Moves reviewed, committed story from doingUS/ to doneUS/
    Moves paired task artifact from doingUS/ to doneUS/
```

### Flow Diagram: The Complete Lifecycle

```
                    SPEC_initProjectContext
                    SPEC_updateProjectContext
                            │
                            ▼
                  .catdd/spec/projectContext.md
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
     SPEC_importIssue  SPEC_importFeature  SPEC_importUserStory
              │             │                     │
              ▼             ▼                     │
      pendingNews/*.md  pendingNews/*.md           │
              │             │                     │
              ▼             ▼                     │
     SPEC_analyzeIssue  SPEC_analyzeFeature        │
              │             │                     │
              └──────┬──────┘                     │
                     ▼                            ▼
              todoUS/*-UserStory.md
                     │
                     ▼
              SPEC_openUserStory
                     │
                     ▼
              doingUS/*-UserStory.md
                     │
                     ▼
              SPEC_clearStoryIntent (align intent)
                     │
                     ▼
              SPEC_makePlan (create task artifact)
                     │
         ┌───────────┼───────────┐
         ▼           ▼           ▼
    Requirement   Design     Implementation
    -oriented    -oriented   -oriented
         │           │           │
         ▼           ▼           ▼
    updateStory  takeDesign  designTests
    reviewStory  reviewDesign implTests
         │           │       implCode
         ▼           ▼       reviewCode
    commitWorks  commitWorks commitWorks
    closeStory   closeStory  closeStory
         │           │           │
         └───────────┼───────────┘
                     ▼
              doneUS/*-UserStory.md
```

### Key SpecFlow Commands in Detail

#### SPEC_initProjectContext

**Purpose**: Creates the project's shared constitution — the facts, constraints, conventions, and decisions that every subsequent SPEC command references.

**What it records**:
- Project facts: repository, owner, primary purpose
- Layer model: methodPrompts → slashCommands → codeAgents → agentSkills
- Installed project surface: `.catdd/` directory structure
- Stable conventions: documentation split, English/Chinese mirror rules, method semantics boundaries
- Current design decisions: P0/P1/P2 category lists, design skeleton naming rules
- Validation commands: scripts to verify documentation and packaging integrity

**Output**: `.catdd/spec/projectContext.md`

**Why it matters**: Without project context, every CodeAgent session starts from zero. With project context, the agent reads one file and understands the project's rules, conventions, and current state.

#### SPEC_analyzeIssue

**Purpose**: Converts a raw issue or feature request into a traceable user story.

**What it does**:
1. Reads the pending issue/feature file from `pendingNews/`
2. Analyzes the input against project context and existing stories
3. Produces a structured user story in `todoUS/` containing:
   - Role, capability, value (the US format)
   - Acceptance criteria candidates
   - Risk assessment
   - Open questions for the developer
4. Moves the raw input to `analyzedNews/` for traceability
5. Does NOT invent product intent — leaves unclear aspects as open questions

**Output**: A user story file in `todoUS/` and an archived raw input in `analyzedNews/`.

**CoT Pattern**: ReACT (Reasoning + Acting) — the command must inspect current state, decide what to extract, act by writing the story, and observe the result iteratively.

#### SPEC_makePlan

**Purpose**: Creates the execution plan for an opened user story.

**What it does**:
1. Reads the active story in `doingUS/`
2. Classifies the work into one of:
   - **Intent-clearing**: Developer and CodeAgent intent not yet aligned
   - **Requirement-oriented**: Requirements docs need updating
   - **Design-oriented**: Architecture or detail design needed (initial or follow-up)
   - **Implementation-oriented**: Ready for test design and code
3. Creates a `*-TASKs.md` file with Markdown checkbox tasks
4. Decides the next SPEC command based on classification

**Output**: A task artifact in `doingUS/YYYYMMDD-TASKs.md`.

**Why it matters**: This is the planning step that prevents premature design and implementation. Without it, teams skip straight to coding when they should be aligning intent or designing architecture.

#### SPEC_clearStoryIntent

**Purpose**: Aligns what the developer thinks the story means with what the CodeAgent thinks it means — before design begins.

**What it records** (the "Mutual Intent Contract"):
- Developer intent: What the developer believes the story is about
- CodeAgent intent: What the agent infers from reading the story
- In-scope work: What is included
- Out-of-scope work: What is explicitly excluded
- Success signal: How we know the story is done
- Assumptions: What we're assuming but haven't confirmed
- Open questions: What we need the developer to answer

**Why it matters**: If intent is not cleared, the agent might optimize for the wrong scope or success signal. An expensive architecture design that solves the wrong problem is worse than no design at all.

#### SPEC_takeArchDesign and SPEC_takeDetailDesign

**Purpose**: Produce design artifacts at two levels of abstraction.

**Architecture Design** (`SPEC_takeArchDesign`):
- High-level module decomposition
- Dependency direction and data flow
- Runtime placement and key trade-offs
- Creates `README_ArchDesign.md` and other architecture-oriented SPEC docs

**Detail Design** (`SPEC_takeDetailDesign`):
- Class-level API signatures and data structures
- State machines and lifecycle transitions
- Acceptance criteria for the active story
- Creates `README_DetailDesign.md` and other detail-oriented SPEC docs

**Model Tier**: Both commands require SOTA reasoning for initial design (deciding boundaries, trade-offs, constraints). Follow-up revision (`SPEC_updateArchDesign`, `SPEC_updateDetailDesign`) can use High Performance models.

**Important**: `SPEC_take*Design` is for **initial** design work. `SPEC_update*Design` is for **follow-up** revision against existing design evidence, review feedback, or story-level design gaps. Do not mix them.

#### SPEC_reviewArchDesign and SPEC_reviewDetailDesign

**Purpose**: Gate design quality before downstream lifecycle steps.

**What they check**:
- Completeness: Are all necessary design aspects covered?
- Traceability: Does design connect to requirements?
- Consistency: Are there internal contradictions?
- Feasibility: Is the design implementable given constraints?
- Clarity: Can a developer read this and implement correctly?

**Critical rule**: Every design-producing step (`SPEC_take*Design`, `SPEC_update*Design`) must be followed by its review gate before downstream lifecycle steps. Never skip review.

#### SPEC_designUnitTests

**Purpose**: Enter CaTDD test design mode, typically routing through P0/P1/P2 flows.

**What it does**:
1. Determines the testing method (defaults: CaTDD)
2. Identifies which test categories are needed based on the story and design
3. Routes to the appropriate UT flow commands
4. May invoke `UT_designTypicalSkeleton`, `UT_designEdgeSkeleton`, etc.

**Testing method default**: CaTDD is the default UnitTesting method in SpecFlow. Typical TDD or another project-specific method may be used when the project explicitly requests it.

#### SPEC_commitWorks

**Purpose**: Prepare and commit completed work with traceable commit messages.

**What it does**:
1. Reviews what changed: test files, production code, design docs, spec artifacts
2. Groups changes by story/concern
3. Drafts commit messages referencing US IDs
4. Commits with appropriate scope
5. Does NOT push — pushing is a separate developer action

#### SPEC_closeUserStory

**Purpose**: Move completed work to the done archive.

**What it does**:
1. Verifies the story is actually complete (reviews, tests, commits done)
2. Moves the story from `doingUS/` to `doneUS/`
3. Moves the paired task artifact alongside it
4. Records closure date and any lessons learned
5. Does NOT close a story that isn't reviewed and committed

---

## Model Tier Guidance for Commands

Px-SpecFlow provides explicit model tier guidance — use the smallest model that preserves decision quality:

| Tier | Purpose | SPEC Commands |
|---|---|---|
| **SOTA reasoning** | Architecture decisions, system boundaries, quality trade-offs, irreversible choices | `SPEC_takeArchDesign`, `SPEC_reviewArchDesign` |
| **High Performance** | Multi-artifact reasoning, design, review, planning | `SPEC_initProjectContext`, `SPEC_analyzeIssue`, `SPEC_analyzeUserStory`, `SPEC_makePlan`, `SPEC_takeDetailDesign`, `SPEC_reviewDetailDesign`, `SPEC_designUnitTests`, `SPEC_reviewProductCodes` |
| **Flash Speed** | Deterministic artifact moves, imports, commits, closures | `SPEC_importIssue`, `SPEC_openUserStory`, `SPEC_abortUserStory`, `SPEC_implUnitTests`, `SPEC_implProductCodes`, `SPEC_commitWorks`, `SPEC_closeUserStory` |

**Escalation rule**: Move from lower to higher tier when the command reveals architecture-significant uncertainty: competing non-functional requirements, safety/security risk, real-time constraints, concurrency boundaries, or irreversible API decisions.

---

## Chain-of-Thought Patterns in Commands

SPEC commands use three CoT reasoning patterns, chosen based on the command's decision complexity:

### ReACT (Reasoning + Acting)

Used for commands that must inspect current lifecycle state, decide what to do, act, and observe the result iteratively. Suitable for analysis, design, and review commands.

**Execution cycle**:
1. **Thought**: Inspect input artifacts. Identify current state, gaps, conflicts.
2. **Action**: Create, update, review, or move the named artifact.
3. **Observation**: Verify output meets the contract. Check for missing traceability, unresolved questions, quality failures.
4. If observation reveals a quality issue, surface it as a question or assumption and stop.

**Used by**: `SPEC_analyzeIssue`, `SPEC_makePlan`, `SPEC_reviewArchDesign`, `SPEC_reviewDetailDesign`, `SPEC_reviewProductCodes`

### ToT (Tree of Thoughts)

Used when the command must generate multiple candidate approaches, evaluate each against quality criteria, and select the best.

**Execution cycle**:
1. **Generate**: Produce 2+ candidate approaches or artifact outlines.
2. **Evaluate**: Assess each against quality criteria.
3. **Select**: Choose the best. If no candidate is clearly best, present options to developer.
4. **Execute**: Apply the selected candidate to produce the output artifact.
5. **Verify**: Confirm the output meets the contract.

**Used by**: `SPEC_takeArchDesign` (comparing architectural alternatives), `SPEC_clearStoryIntent` (evaluating different scopes)

### Linear (Direct Execution)

Used when the command's action is deterministic given complete and valid inputs.

**Execution cycle**:
1. Read inputs and method references.
2. Preserve existing traceability, status markers, and conventions.
3. Perform only this command's requested step.
4. Report the artifact produced and next recommended command.

**Used by**: `SPEC_importIssue`, `SPEC_openUserStory`, `SPEC_commitWorks`, `SPEC_closeUserStory`

---

## SpecFlow Artifacts

SpecFlow creates and maintains a set of traceable artifacts:

### Lifecycle Artifacts (under `.catdd/spec/`)

| Artifact | Purpose | Git Policy |
|---|---|---|
| `projectContext.md` | Shared project constitution | Commit — teammates and agents need same facts |
| `pendingNews/*.md` | Imported work waiting for analysis | Commit — team visibility |
| `analyzedNews/*.md` | Archived raw inputs after analysis | Commit — traceability preserved |
| `todoUS/*-UserStory.md` | Analyzed stories ready to pick up | Commit — team backlog |
| `doingUS/*-UserStory.md` | Active stories in progress | Commit — cross-machine visibility |
| `doingUS/*-TASKs.md` | Active task plan with checkbox tasks | Commit — explicit, checkable steps |
| `doneUS/*-UserStory.md` | Completed, reviewed, committed stories | Commit — project history |
| `doneUS/*-TASKs.md` | Completed task artifact | Commit — later diagnosis |
| `WorkingProcessLog.md` | Local work-state trace | Gitignore — personal, not team-shared |

### Project-Root SPEC Docs

| File | Purpose | Managed By |
|---|---|---|
| `README.md` | Project overview, ownership, master directories | Other SPEC steps |
| `README_ArchDesign.md` | High-level architecture, modules, dependencies | `SPEC_takeArchDesign` |
| `README_DetailDesign.md` | Class design, API signatures, data structures | `SPEC_takeDetailDesign` |
| `README_UserStories.md` | Project-scoped user stories, trace links | Other SPEC steps |
| `README_UserGuide.md` | User-facing runtime usage guidance | Other SPEC steps |
| `README_VerifyDesign.md` | Verification topology, test strategy, US/AC/TC traceability | SpecFlow + UT flows |
| `README_ErrorDesign.md` | Fault-tolerance architecture, fail-safe states | `SPEC_takeArchDesign` |
| `README_ResourceDesign.md` | Resource allocations, memory/CPU budgets | `SPEC_takeArchDesign` |
| `README_StateDesign.md` | State machines, lifecycle transitions | `SPEC_takeDetailDesign` |
| `README_PerfDesign.md` | Performance budgets, latency limits | `SPEC_takeArchDesign` |
| `README_CompatDesign.md` | Compatibility matrices, platform/toolchain versions | `SPEC_takeArchDesign` |
| `README_DiagnosisDesign.md` | Observability, logging, telemetry, diagnostics | `SPEC_takeArchDesign` |
| `README_UsageDesign.md` | Public boundaries, CLI/API contracts | `SPEC_takeArchDesign` |

Create project-root SPEC docs only when the project needs that surface. Use templates from `slashCommands/templates/` when creating one for the first time.

---

## The Command Template as a Contract

Every slash command is a **contract** between the developer and the CodeAgent. The developer invokes the command (signaling intent). The CodeAgent executes the contract (faithfully applying method rules). The contract has:

1. **Preconditions**: Inputs that must exist before invocation (e.g., API headers, existing skeletons, project context)
2. **Action**: The single step the command performs (not "design, implement, and review" — pick one)
3. **Postconditions**: Outputs that must exist after execution (e.g., a designed skeleton, an implemented test, a review report)
4. **Invariants**: What must be preserved (CaTDD comment skeletons, US/AC/TC traceability, category labels, status markers)
5. **Next**: What command should come next (never leave the CodeAgent guessing)

This contract structure is why slash commands are reproducible. Every invocation of `UT_designTypicalSkeleton` produces a CaTDD Typical skeleton, regardless of which CodeAgent executes it, because the contract defines the output precisely.

---

## Conflict Guard Rules

Px-SpecFlow defines strict conflict guard rules that prevent layers from violating each other's boundaries:

1. **Px-SpecFlow defines lifecycle orchestration only; CaTDD method semantics remain in methodPrompts.**
2. **SPEC commands may call UT commands, but must not replace P0/P1/P2 category rules.**
3. **Do not skip SPEC_reviewUserStory after SPEC_updateUserStory in requirement-oriented work.**
4. **Do not start design when developer intent and CodeAgent intent are not cleared for the active story.**
5. **After SPEC_makePlan, use SPEC_take*Design only for initial design work and SPEC_update*Design only for follow-up design revision.**
6. **Every design-producing step must be followed by its review gate before downstream lifecycle steps.**
7. **If product intent is unclear, keep the user story open and ask the developer instead of inventing requirements.**

---

## Command Invocation in Practice

Slash commands are invoked differently depending on the CodeAgent:

### In Copilot Chat

```
/UT_designTypicalSkeleton
```

The Copilot prompt wrapper (generated by `scripts/makeSlashCmd4Copilot.sh`) adapts the portable Markdown command to Copilot's prompt format. The developer types the slash command, Copilot reads the adapted prompt, and executes the contract.

### In Cline/Continue

The command prompt file is read directly. The developer types the command name or selects it from the assistant's command palette.

### In utCodeAgentCLI (future)

```bash
utCodeAgentCLI --target myTestFile.ts --input spec/IOC.h --behave designTypicalSkeleton
```

The CLI maps `--behave` values to slash command behaviors. Aliases like `reviewFuncTestsSkeleton` and `tellMeNextImplTest` resolve to their full UT command names.

### Portable Placeholders

Command files use portable placeholders that adapters fill in:

- `{{feature_name}}` — Name of the feature/module being tested
- `{{category}}` — CaTDD category (Typical, Edge, etc.)
- `{{source_files}}` — API headers or spec documents
- `{{test_files}}` — Existing test files to read and extend
- `{{language}}` — Target programming language
- `{{test_framework}}` — Test framework in use
- `{{developer_goal}}` — Developer intent not captured in artifacts

---

## When to Use Which Flow

| Starting Point | Flow to Use |
|---|---|
| New component, no existing tests | P0-FuncTestsFlow → `UT_designTypicalSkeleton` |
| Existing demo code | P0-FuncTestsFlow → `UT_convertDemoToTypical` |
| Full functional test design | P0-FuncTestsFlow → `UT_designFuncTestsSkeleton` |
| Need architecture validation | P1-DesignTestsFlow (after P0 complete) |
| Need performance/capacity data | P2-QualityTestsFlow (after P0/P1 complete) |
| New feature request from product team | Px-SpecFlow → `SPEC_importFeature` → `SPEC_analyzeFeature` |
| Bug report from QA | Px-SpecFlow → `SPEC_importIssue` → `SPEC_analyzeIssue` |
| Already have a user story | Px-SpecFlow → `SPEC_importUserStory` → `SPEC_openUserStory` |
| Resume paused work | Px-SpecFlow → `SPEC_whatsNextTask` (reads current state and recommends next action) |
| Architecture decision needed | Px-SpecFlow → `SPEC_takeArchDesign` |
| Ready to code after design | Px-SpecFlow → `SPEC_designUnitTests` → P0/P1/P2 flow |

---

## The Subagent Pattern

Some SPEC commands support background delegation via subagents. When a command is suitable for mid-conversation delegation:

- **When to delegate**: A new issue surfaces while other work is in progress
- **What to capture**: Source text or URL and relevant project context
- **What to expect back**: The output file name (e.g., a new story in `todoUS/`)
- **Caller behavior**: The main conversation continues without waiting

Commands suitable for subagent delegation: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_analyzeIssue`, `SPEC_analyzeFeature`.

Commands that must run synchronously: `SPEC_takeArchDesign` (output needed immediately for review), `SPEC_makePlan` (determines the next step), `SPEC_commitWorks` (must be synchronous with the developer's workspace).

---

## From Commands to Automation

Slash commands are the bridge between VibeCoding's conversational flexibility and CodeAgent automation. When a developer invokes `/UT_implTestCase`, a CodeAgent reads the command contract, applies the CaTDD method, and produces a structured output. When a developer invokes `/SPEC_analyzeIssue`, a CodeAgent reads the raw issue, converts it into a user story, and moves it through the lifecycle.

The next chapter, **asyncCodeAgent**, takes this further: instead of waiting for the developer to invoke each command, a CaTDD-native code agent plans, executes, collects traces, and reflects — automating the entire loop from goal to verified implementation.
