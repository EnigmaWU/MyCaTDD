# 03 callSlashCommands

## What Are Slash Commands?

A slash command is a Markdown file that tells a CodeAgent what to do next. It is not a shell command. It is a written instruction with a contract: read this, do exactly this one step, produce this, keep these things intact, and then say what comes next.

That is why the same command intent can be adapted to different tools. The canonical file is plain Markdown; adapters expose it through tool-specific interfaces.

## 5W1H at a Glance

| Question | Answer |
|---|---|
| **Who** | Developers and compatible CodeAgents using CaTDD |
| **What** | Portable `TEST_*`, `SPEC_*`, and `HARNESS_*` command contracts |
| **When** | Use a command when its declared preconditions and owning flow/kit apply |
| **Where** | Canonical Markdown under `slashCommands/commands/`, organized by flow or kit |
| **Why** | To make one method-defined step repeatable, reviewable, and adapter-independent |
| **How** | Resolve any local `Evolved` overlay, read the method source, run one command, verify its output, and follow its next step |

```
   methodPrompts          slashCommands            CodeAgent
   ─────────────          ─────────────            ─────────
   what the method    →   one step, with a     →   performs the step:
   means: categories,     contract: what to        reads the files,
   gates, US/AC/TP/TC     read, produce,           writes the output,
   format, priorities     preserve, and report     reports the result
```

The commands live in `slashCommands/`. They follow one architectural rule, and it matters more than any other rule in this chapter:

> **When a slash command conflicts with methodPrompts, methodPrompts always wins.**

Commands are the *operational* layer. They sequence work; they do not invent method semantics. A command tells you *when* to design a Typical skeleton. The method prompt still defines what a Typical skeleton is.

### Why commands beat ad-hoc requests

```
   ad-hoc:  "add some tests for IOC_post"
            → code appears, passes, and nobody can say which
              requirement it defends

   command: /TEST_designTypicalSkeleton
            → source-first discovery + qualified US/AC/TP/TC + scope-specific status
            → reviewable before a single line of test code exists
```

Both cost one message to the agent. Only the second leaves a reviewer something to check.

---

## The Three Command Families

```
   ┌────────────────────────────────────────────────────────────────────┐
   │  TEST_*        test design and implementation                        │
   │              works on: skeletons, test files, TODO status          │
   ├────────────────────────────────────────────────────────────────────┤
   │  SPEC_*      story lifecycle orchestration                         │
   │              works on: context, news, stories, designs, commits    │
   ├────────────────────────────────────────────────────────────────────┤
   │  HARNESS_*   engineering tool points around the harness            │
   │              works on: installs, diagnostics, sessions, patches    │
   └────────────────────────────────────────────────────────────────────┘
```

### TEST Commands — Test Design and Implementation

```text
TEST_<verb><Object>
```

`TEST_*` commands execute CaTDD category-level design and implementation steps. The current P0, P1, and P2 flows own functional, design, and quality work; P3 Addons cover demo/example verification where applicable.

**Examples**:

- `TEST_designTypicalSkeleton` — design the Typical category design skeleton
- `TEST_implTestCase` — implement one test case through the RED→GREEN cycle
- `TEST_reviewFuncTestsSkeleton` — review the complete P0 functional skeleton set before implementation
- `TEST_tellMeNextImplTest` — pick the next test case from the TODO tracking section

### SPEC Commands — SpecCoding Lifecycle Orchestration

```text
SPEC_<verb><Object>
```

SPEC commands drive work through a traceable SpecCoding lifecycle. They operate on lifecycle artifacts — project context, pending news, user stories, design docs, tests, product code, commit state — not on test categories or category skeletons directly.

**Examples**:

- `SPEC_initProjectContext` — create the first project context file
- `SPEC_analyzeIssue` — turn an issue into a traceable user story
- `SPEC_takeArchDesign` — produce the high-level architecture design
- `SPEC_designTests` — route reviewed story/design inputs into CaTDD test design
- `SPEC_commitPreStoryWorks` — commit intake and analysis before opening a story
- `SPEC_commitStepWorks` — commit a planned, verified step boundary
- `SPEC_commitStoryWorks` — commit the story span and any required post-close changes
- `SPEC_closeUserStory` — move reviewed completed work to the done archive

### HARNESS Commands — Harness Engineering Tool Points

```text
HARNESS_<verb><Object>
```

HARNESS commands are tool points, not story-lifecycle steps. They maintain the CaTDD harness around the method source: installed target-project assets, native adapter wrappers, execution diagnostics, and guarded patch-back to the original CaTDD repository.

Two boundaries define them: they **never move SpecFlow lifecycle state**, and they **never redefine CaTDD category meaning**.

**Examples**:

- `HARNESS_verifyInstallation` — verify an installed target project has complete, consistent adapter assets
- `HARNESS_diagnoseInstallation` — diagnose a failed or misbehaving installation and recommend repairs
- `HARNESS_diagnoseProject` — diagnose repo correctness and SpecCoding/CaTDD drift without mutating source
- `HARNESS_newTaskSession` — capture session context so a new CodeAgent session can resume without re-investigation
- `HARNESS_evolveHarness` — learn from verified success or failure and evolve the narrowest canonical owner
- `HARNESS_patchCaTDDSource` — patch effective installed-project CaTDD improvements back to the original repository

The three families answer three different questions: *is the test design right?* (`TEST`), *is the story moving correctly?* (`SPEC`), and *is the tooling around the method healthy?* (`HARNESS`).

---

## The Universal Command Template

`TEST_*` and `SPEC_*` commands use their respective Markdown templates, `TEST_slashCommandTemplate.md` and `SPEC_slashCommandTemplate.md`. The templates share an explicit WHO/WHAT/WHEN/WHERE/WHY/HOW, input/output contracts, method references, and a universal stop rule; SPEC commands also state delegation guidance.

| Section | Content |
|---|---|
| **Command Header** | Command name, flow, CaTDD class, category, method source, adapter target |
| **Reasoning pattern** | Declared execution pattern and observable checkpoints; follow public summaries, not hidden chain-of-thought |
| **WHO** | Who invokes this command and who should act on it |
| **WHAT** | Exactly what this command does — the single workflow step it performs |
| **WHEN** | Valid starting conditions, when NOT to use it, previous/next commands |
| **WHERE** | Input files, output files, method references, related flow documents |
| **WHY** | Developer value, CaTDD method reason, how it reduces ambiguity |
| **HOW** | Execution procedure — what to read, preserve, perform, report |
| **Subagent Recommendation** | (SPEC commands only) Whether this command suits background subagent delegation |
| **Input Contract** | Command parameters using portable placeholders |
| **Output Contract** | Expected response shape — summary, files touched, next command |
| **CodeAgent Compatibility** | Plain Markdown, no tool-specific assumptions |

```
   one command file
   ├─ WHO / WHEN / WHERE   ← is this even the right step to run now?
   ├─ WHAT / HOW           ← the single step to perform
   ├─ Input / Output       ← what it consumes, what it must leave behind
   └─ CodeAgent Compat.    ← why any agent can run it
```

Uniformity is the point: portable command intent is separate from the native adapter that exposes it.

---

## The Four Command Flows and Two Kits

Commands are grouped into four flows and two cross-priority kits:

```
  slashCommands/flows/
  ├── P0-FuncTestsFlow.md      ← TEST commands for functional test design
  ├── P1-DesignTestsFlow.md    ← TEST commands for design-oriented tests
  ├── P2-QualityTestsFlow.md   ← TEST commands for quality-oriented tests
  └── Px-SpecFlow.md           ← SPEC commands for full lifecycle orchestration

  slashCommands/kits/
  ├── Px-HarnessKits.md        ← HARNESS_* operational tool points
  └── Px-StatusKits.md         ← read-only TEST/SPEC/HARNESS status reports
```

`Px` in SpecFlow means **cross-priority**. It is not a test category priority like P0/P1/P2 — it is a process flow that orchestrates those test layers.

`Px-HarnessKits` is cross-priority too, but it is a kit rather than a lifecycle flow: it groups tool-point commands without imposing a strict command sequence. Future addon and demo commands belong to `P3 Addons`, which keeps them aligned with `methodPrompts`.

```
   P0 functional skeletons are decided first
        │
        ├── promote P1 design when the source-backed gate applies
        ├── promote P2 quality when the source-backed gate applies
        └── add P3 Demo/Example surfaces when they are in scope
                 ▲
          Px-SpecFlow orchestrates story state, planning, and reviews

   Px-HarnessKits  ⊥  operational commands: install, diagnose, session, evolve, patch back
   Px-StatusKits   ⊥  read-only status reports: never promote status or invent evidence
```

---

## P0 FuncTestsFlow — The First Flow to Learn

P0 is the most common entry point because it covers functional test design, which is what every developer needs first. The flow has one job: turn a component into four kinds of functional skeleton (Typical, Edge, Misuse, Fault), review them as a set, then implement them one test case at a time.

```
              Existing demo tests
                      │
                      ▼
         ┌─────────────────────────┐
         │ TEST_convertDemoToTypical │
         └───────────┬─────────────┘
                     │
                     ▼
    Interface/protocol ──┬─→ TEST_designTypicalSkeleton
                         └─→ TEST_designFuncTestsSkeleton (Typical+Edge+Misuse+Fault)
                                      │
                                      ▼
                              Typical skeleton
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
    TEST_designEdgeSkeleton    TEST_designMisuseSkeleton   TEST_designFaultSkeleton
              │                       │                       │
              └───────────────────────┼───────────────────────┘
                                      ▼
                          P0 functional skeleton set
                                      │
                                      ▼
                       TEST_reviewFuncTestsSkeleton
                                      │
                                      ▼
                       TEST_tellMeNextImplTest
                                      │
              ┌───────────────────────┘
              ▼
      TEST_implTestCase ──→ TEST_reviewImplTestCase
              │                       │
              └───────────┬───────────┘
                          ▼
                TEST_refactTestCase (optional, GREEN cleanup)
                          │
                          ▼
                 TEST_reviewImplTestCase (re-review)
```

### Entry Points

You can start the P0 flow from three places:

1. **Existing demo tests** — use `TEST_convertDemoToTypical` to extract core behavior into a CaTDD Typical skeleton. This preserves existing work instead of throwing it away.
2. **Interface or protocol** — use `TEST_designTypicalSkeleton` to design the Typical skeleton from the API contract.
3. **Full functional set at once** — use `TEST_designFuncTestsSkeleton` to produce all four skeletons (Typical + Edge + Misuse + Fault) in a single step.

### The P0 Command Path at a Glance

| # | Command | What it produces |
|---|---|---|
| Start | `TEST_convertDemoToTypical`, `TEST_designTypicalSkeleton`, or `TEST_designFuncTestsSkeleton` | P0 design based on demo behavior, interface, or full functional scope |
| Complete P0 | `TEST_designEdgeSkeleton`, `TEST_designMisuseSkeleton`, `TEST_designFaultSkeleton` | Remaining P0 category designs, source-linked to registered requirements |
| Review design | `TEST_reviewFuncTestsSkeleton` | Skeleton review with `PASS`, `REVISE`, `BLOCKED`, or `ASK` disposition |
| Select and implement | `TEST_tellMeNextImplTest` then `TEST_implTestCase` | One ready TC at a time, with meaningful RED/GREEN evidence |
| Review and refactor | `TEST_reviewImplTestCase`; optionally `TEST_refactTestCase` and re-review | TC-level alignment review and optional no-behavior-change cleanup |

### Steps 1–5: Design the Skeletons

`TEST_convertDemoToTypical` is for demo tests that exercise the component. Note what those tests are *not*: they are raw input material, not CaTDD P3 Demo/Example tests. The command reads the demo, extracts the core behavior patterns, maps them into CaTDD Typical format, and writes a skeleton with source-linked, qualified `@[US]`, `@[AC]`, `@[TP]`, and `@[TC]` markers and a populated OVERVIEW section.

`TEST_designTypicalSkeleton` is for the no-demo case. It reads authoritative interface and design sources, uses the discovery ledger and source-backed oracles, and writes qualified US/AC/TP/TC links. It must not infer the full behavior inventory from API signatures or existing tests alone.

Both paths continue to `TEST_designEdgeSkeleton`. The next three commands each design one category skeleton, reading the existing skeletons for consistency, the API interface, and the category-specific method prompt. They run in P0 order: Edge after Typical, Misuse after Edge, Fault after Misuse.

**Important**: preserve the registered project-wide Story ID when its obligations span categories. Category files link to authoritative US/AC/TP/TC IDs; they do not create local duplicate identities just to fill a category.

### Step 6: TEST_reviewFuncTestsSkeleton — the gate that saves money

**When**: all P0 skeletons are designed, none implemented.

**What it checks**:

- **Completeness** — are all four categories present?
- **Traceability** — does every US have an AC, every AC have a TP, every TP map to exactly one TC, and every TC cover at least one TP?
- **Category correctness** — is anything classified as Edge that is really Misuse?
- **Consistency** — do naming, status markers, and formats follow convention?
- **Gate readiness** — is this design ready for P0 implementation?

**Output**: a review disposition (`PASS`, `REVISE`, `BLOCKED`, or `ASK`) with findings and evidence.

```
   TEST_reviewFuncTestsSkeleton  →  REVISE
     completeness    PASS   4/4 categories present
     traceability    REVISE TC-Edge-3 lacks a qualified source link
     category        PASS   no Misuse scenario hiding in Edge
     consistency     PASS   naming and status markers follow convention
     gate readiness  REVISE resolve the finding, then re-run this command
```

**Next command**: PASS → `TEST_tellMeNextImplTest`; REVISE → repair the cited design; BLOCKED or ASK → resolve missing source evidence or a decision before continuing.

Never skip this gate. A design flaw caught here costs a text edit; the same flaw caught after implementation costs a rewritten test, a rewritten production path, and a re-review — which is exactly the 10x difference the method is built to exploit.

### Step 7: TEST_tellMeNextImplTest — remove the "where was I?" tax

**When**: ready to begin implementation — all skeletons reviewed and approved.

**What it does**: reads the TODO tracking section across all test files, applies the P0 default order (Typical → Edge → Misuse → Fault), checks dependencies, and recommends the next test case.

**Output**: the name of the next TC, the file it lives in, its category, its estimated complexity, and any dependencies or blockers.

```
   TODO — IocQueue_Test.cpp
   🟢 TC-Typical-1   verifyEventPost_byAvailableCapacity_expectEventQueued
   🟢 TC-Typical-2   verifyEventPull_byPostedEvent_expectFifoOrder
   ⚪ TC-Edge-1      verifyNonBlockPost_byFullQueue_expectImmediateReturn
   ⚪ TC-Edge-2      verifyPull_byEmptyQueue_expectTimeout
   ⚪ TC-Misuse-1    verifyPost_byDestroyedQueue_expectInvalidState

   → next: TC-Edge-1   (P0 order, no blockers, complexity: low)
```

### Step 8: TEST_implTestCase — one test case, both colors

**When**: a specific TC has been selected for implementation.

**What it does**, in order:

1. Writes the selected TC using the four-phase structure (SETUP / BEHAVIOR / VERIFY / CLEANUP)
2. Runs it and records RED only when the intended domain assertion fails
3. Repairs `BROKEN_TEST` failures (syntax, setup, fixture, or environment) before product implementation
4. Implements the minimum production code needed for the TC
5. Runs the test — confirms GREEN at the declared test level and scope
6. Records `mockSysRtm` and `realSysRtm` status separately
7. Updates the TC evidence and implementation notes

**Output**: one test case with meaningful RED→GREEN history and scope-specific status. `CLOSED` is earned at `mockSysRtm`; a mock pass is not evidence that the real runtime passed.

**Next command**: `TEST_reviewImplTestCase`.

### Step 9: TEST_reviewImplTestCase — check the claim, not the color

**What it reviews**:

- **Correctness** — does the test actually verify the AC it claims to verify?
- **Structure** — does it follow the 4-phase pattern?
- **Assertions** — are there ≤3 key assertions, and are they meaningful?
- **Traceability** — are registered US and qualified AC/TP/TC relationships preserved?
- **Isolation** — does cleanup run and prevent state leakage?
- **Status** — are the markers correctly set?

**Output**: a review disposition and findings. PASS returns to `TEST_tellMeNextImplTest`; REVISE routes to the specific correction; BLOCKED or ASK stops for missing evidence or a decision.

### Step 10: TEST_refactTestCase (optional) — clean up without changing meaning

**When**: a selected TC is GREEN and reviewed, but the test body is hard to read or maintain.

**What it does**: refactors that single test case for clarity, without changing behavior, category routing, or source-linked US/AC/TP/TC traceability.

**Hard boundary**: missing behavior, missing coverage, or wrong category routing must go back to the design or implementation commands. Refactoring is not a side door for new coverage.

**Next command**: `TEST_reviewImplTestCase` again — to prove the cleanup caused no skeleton drift.

---

## The RED→GREEN Discipline in Slash Commands

`TEST_implTestCase` is where CaTDD stops being a design document and starts changing code. The discipline below is what keeps the test honest.

```
   RED ─────────► GREEN ─────────► REVIEW ─────────► next TC
   test fails     minimal code      PASS/FAIL
   on purpose     makes it pass     on meaning
```

### RED Phase

```
1. Read the TC specification (the comment design)
2. Write the test function following the 4-phase pattern
3. Add @[Name] and @[Steps] comments above the test function
4. Update the TODO tracking section: ⚪ → 🔴 RED/FAILING
5. Compile and run — verify the test FAILS
6. If it passes: investigate. Either:
   a) the test is poorly written and doesn't test the right thing
   b) the feature already exists — production code was written first (TDD violation)
   c) the test framework is misconfigured
7. Report: "RED confirmed. Test fails as expected because [reason].
   Ready for production code implementation."
```

Step 6 is the one people skip. A test that passes before the code exists has told you something important, and none of the three explanations is good news.

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

In the GREEN phase, write **only enough production code to make the current test pass**. Not one line more.

This rule prevents four specific failures:

- **Dead code** — code written but never tested
- **Over-engineering** — features no test ever asked for
- **False confidence** — tests passing because extra code happened to satisfy them
- **Lost traceability** — production code with no corresponding TC

```
   TC-Edge-1 needs:  post() returns BUSY immediately when the queue is full

   minimal:          if (isFull()) return RESULT_BUSY;
   too much:         if (isFull()) { log warn; notify observers;
                                      schedule retry; return RESULT_BUSY; }
```

The extra three behaviors are not "free." They are untested paths that now look like tested ones, and the next developer will trust them.

---

## P1-DesignTestsFlow and P2-QualityTestsFlow

P1 and P2 follow the same shape as P0, with one constraint P0 does not have: the **Design Source Gate**.

### The Design and Discovery Gate

Before drafting a P1 or P2 skeleton, read the category's confirmed design source and the appropriate architecture- or detail-level verification design. The verification design owns the strategy and `discovery_ledger`; category files link to that inventory. If a source or oracle is missing, record a QUESTION/GAP and stop or ask rather than inventing the design.

| Priority | Category | Typical source evidence |
|---|---|---|
| P1 | State | `README_ArchDesign.md`, `README_DetailDesign.md`, `README_StateDesign.md`, lifecycle/state models |
| P1 | Capability | `README_ArchDesign.md`, `README_DetailDesign.md`, declared limits and responsibilities |
| P1 | Interaction | `README_ArchDesign.md`, sequence/interaction diagrams, handoff contracts |
| P1 | Concurrency | `README_ArchDesign.md`, `README_DetailDesign.md`, `README_StateDesign.md`, ownership/order model |
| P2 | Performance | `README_PerfDesign.md`, `README_ResourceDesign.md`, measurable budgets |
| P2 | Robust | `README_ErrorDesign.md`, resource/runtime failure and recovery policy |
| P2 | Compatibility | `README_CompatDesign.md`, supported versions/platforms/protocols |
| P2 | Configuration | configuration contract, defaults, precedence, supported matrix |
| P2 | Diagnosis | `README_DiagnosisDesign.md`, required diagnostic evidence |
| P2 | Security | `README_SecurityDesign.md`, threat model, policy, trust boundary, or invariants |

```
  authoritative design sources
        │
        ▼
  README_ArchVerifyDesign.md (composition boundary, test levels/scopes)
  README_DetailVerifyDesign.md (behavior inventory, discovery_ledger)
        │
        ├─ source and oracle confirmed → draft/link category skeleton
        └─ missing or ambiguous       → QUESTION / GAP; ask or block
```

Verification artifacts supplement authoritative requirements and design documents; they do not replace them. The category and declared SUT/test level determine who owns a test point; an unimplemented test or out-of-scope test level is not evidence that the obligation is covered.

### P1-DesignTestsFlow

Addresses architectural validation: State, Capability, Interaction, and Concurrency.

```
P0 functional skeletons (completed)
         │
         ├─ TEST_designStateSkeleton
         ├─ TEST_designCapabilitySkeleton
         ├─ TEST_designConcurrencySkeleton
         └─ Interaction  (method prompt; no dedicated TEST command)
                        │
                        ▼
              TEST_reviewDesignTestsSkeleton
                        │
                        ▼
        TEST_tellMeNextImplTest → TEST_implTestCase → TEST_reviewImplTestCase
```

**Entry conditions**: P0 design is considered first; each P1 category requires a confirmed source and a source-first discovery handoff. P1 promotion follows the flow's explicit gate, not a local guess that the category is unnecessary.

**Routing note**: State, Capability, and Concurrency have dedicated `TEST_design*Skeleton` commands. Interaction has no dedicated slash command; use `CaTDD_methodPrompt4Cat-Interaction.md` with the confirmed sequence/collaboration source and the same discovery ledger and review contract.

**Gate P1**: P1 skeleton review requires both cardinality and Discovery Gates to pass for the declared scope. Implementation respects P0-first priority; moving to P1 requires P0 TCs to be implemented, blocked with evidence, or explicitly bypassed by the developer. Record actual race/deadlock evidence; do not claim a sanitizer result unless it was run.

### P2-QualityTestsFlow

Addresses non-functional quality attributes: Performance, Robust, Compatibility, Configuration, Diagnosis, Security.

```
P0/P1 stable coverage (completed)
         │
         ├─ TEST_designPerformanceSkeleton
         ├─ TEST_designRobustSkeleton
         ├─ TEST_designCompatibilitySkeleton
         ├─ TEST_designConfigurationSkeleton
         ├─ TEST_designSecuritySkeleton
         └─ Diagnosis  (method prompt; no dedicated TEST command)
                        │
                        ▼
             TEST_reviewQualityTestsSkeleton
                        │
                        ▼
        TEST_tellMeNextImplTest → TEST_implTestCase → TEST_reviewImplTestCase
```

**Entry conditions**: use P2 when in-scope quality concerns have authoritative sources and measurable or otherwise observable predicates. P0 and applicable P1 work follow the promotion gate; unresolved sources remain visible rather than being treated as coverage.

**Routing note**: Performance, Robust, Compatibility, Configuration, and Security have dedicated `TEST_design*Skeleton` commands. Diagnosis has no dedicated command; use `CaTDD_methodPrompt4Cat-Diagnosis.md` with confirmed diagnostic evidence requirements and the source-first ledger.

**Gate P2**: review requires both cardinality and Discovery Gates to pass for the declared scope. Execution and release readiness are separate claims; report actual evidence and approved deferrals rather than inferring that all quality concerns are green.

---

## Px-SpecFlow — The Master Orchestration Flow

Px-SpecFlow is the largest flow because it manages story state and lifecycle gates. TEST flows answer "what should this SUT do, and what verification evidence is required?" SPEC commands answer "where is this work right now, what does it need next, and who can see that it happened?"

```
   TEST flows → work inside a category (Typical, Edge, State, ...)
   SPEC flow  → work across the whole story lifecycle
                import → analyze → plan/design → test → implement → review → commit → close
```

### The SpecFlow Lifecycle

```
pendingNews ──(analyze)──→ todoUS → doingUS → doneUS
                  │                  ↘ suspendUS (paused, resumable)
                  ▼                  ↘ abortUS (unsafe active stories)
              analyzedNews (raw input archive after analysis)
```

Every work item moves through analyzed, active, and archive lanes. `suspendUS` and `abortUS` exist so that a story that cannot continue is *parked with a reason*, instead of lingering in `doingUS` and quietly misrepresenting progress.

| Stage | Directory | Meaning |
|---|---|---|
| **pendingNews** | `.catdd/spec/pendingNews/` | Work waiting to be analyzed. Raw issues and feature requests. |
| **analyzedNews** | `.catdd/spec/analyzedNews/` | Raw inputs archived after analysis — the preserved source trace. |
| **todoUS** | `.catdd/spec/todoUS/` | Work analyzed and ready to pick up. Structured user stories with acceptance criteria candidates. |
| **doingUS** | `.catdd/spec/doingUS/` | Active work in progress. Opened user stories going through design, test, or implementation. |
| **suspendUS** | `.catdd/spec/suspendUS/` | Suspended active stories preserved with a durable resume reference (branch/worktree). |
| **abortUS** | `.catdd/spec/abortUS/` | Aborted active work preserved for later analysis or a next-round improvement input. |
| **doneUS** | `.catdd/spec/doneUS/` | Completed work. Reviewed, committed, CI-passed stories. |

An example of the lanes doing their job:

```
   Day 1  QA files "IOC_post returns success on a destroyed handle"
          SPEC_importIssue          → pendingNews/20260910-ioc-post-destroyed.md
          SPEC_analyzeIssue         → todoUS/20260910-ioc-post-destroyed-UserStory.md
                                      analyzedNews/20260910-ioc-post-destroyed.md
          SPEC_commitPreStoryWorks  → commit intake/analysis before opening

   Day 2  SPEC_openUserStory  → doingUS/...-UserStory.md
          SPEC_makePlan       → doingUS/...-UserStory-Tasks.md + Trajectory

   Day 4  SPEC_suspendUserStory → suspendUS/...  (waiting for HW trace tool)
   Day 9  SPEC_resumeUserStory  → doingUS/...    (reference still valid)
          SPEC_commitStepWorks (at a planned boundary)
          SPEC_commitStoryWorks → SPEC_closeUserStory → doneUS/...
          SPEC_commitStoryWorks (post_close checkpoint if close changed files)
```

Six days of "paused" are now visible as a state with a reason, not as an ambiguous silence.

### The SpecFlow Lifecycle at a Glance

SpecFlow is organized by lifecycle phases; consult [`Px-SpecFlow.md`](../../slashCommands/flows/Px-SpecFlow.md) for the current full sequence and gate contracts.

#### Phase A: Pre-Story (input and analysis)

```
1. SPEC_initProjectContext
   Creates .catdd/spec/projectContext.md — the shared project constitution

2. SPEC_updateProjectContext
   Updates project facts, constraints, or conventions whenever they change

3. SPEC_importIssue / SPEC_importFeature
   Imports work input into pendingNews/

4. SPEC_importUserStory
   Queues already-structured user stories directly into todoUS/ (skips analysis)

5. SPEC_analyzeIssue / SPEC_analyzeFeature
   Converts pending input into traceable user stories in todoUS/
   Archives raw input with a mandatory ## Chat History record

   SPEC_commitPreStoryWorks
   Commits the completed intake/analysis span before story work begins

6. SPEC_openUserStory
   Moves the selected story from todoUS/ to doingUS/ (work begins)
   Asks whether a dedicated story branch should be created or switched
```

#### Phase B: Design and Planning

```
7. SPEC_clearStoryIntent (optional but recommended)
   Aligns developer intent and CodeAgent intent before design
   Records Mutual Intent Contract: scope, non-goals, success signal, assumptions

8. SPEC_makePlan
   Creates the paired task artifact with EPIC sufficiency and append-only Trajectory
   Classifies work as: intent-clearing, requirement-oriented,
   design-oriented, or implementation-oriented
   Decides which SPEC_* step comes next

   SPEC_updateMadePlan
   Synchronizes gate/commit evidence, work orientation, Trajectory, and task slices
   after transitions, reviews, rework, resume, or plan drift

   ┌─ If requirement-oriented ──────────────────────────┐
   │ 9.  SPEC_updateUserStory                            │
   │     Updates README_UserStories.md ledger and paired │
   │     README_UserGuide.md (plus module surfaces)      │
   │ 10. SPEC_reviewUserStory                            │
   │     Reviews requirement quality, normative language,│
   │     Story Completion Conditions, and transformation │
   │     preservation                                 │
   │     If PASS: commit/close, or transfer to design-   │
   │     oriented next steps                             │
   └─────────────────────────────────────────────────────┘

   ┌─ If design-oriented (initial architecture) ─────────┐
   │ 11. SPEC_takeArchDesign                             │
   │     Produces README_ArchDesign.md, README_UbiLang.md,│
   │     and architecture-level verification design      │
   │ 12. SPEC_reviewArchDesign                           │
   │     Gates architecture quality before detail design │
   │ 13. SPEC_updateArchDesign (if review fails)         │
   └─────────────────────────────────────────────────────┘

   ┌─ If design-oriented (initial detail) ───────────────┐
   │ 14. SPEC_takeDetailDesign                           │
   │     Produces README_DetailDesign.md and detail-level│
   │     verification design with discovery_ledger      │
   │ 15. SPEC_reviewDetailDesign                         │
   │     Gates detail design quality                     │
   │ 16. SPEC_updateDetailDesign (if review fails)       │
   └─────────────────────────────────────────────────────┘

   SPEC_whatsNextTask can be called at any point to read
   current state and recommend the single next command.
```

#### Phase C: Implementation and Closure

```
   ┌─ If implementation-oriented ────────────────────────┐
   │ 17. SPEC_designTests                                │
   │     Designs and reviews source-linked skeletons     │
   │ 18. SPEC_implTests                                  │
   │     Implements selected TCs; review tests before    │
   │     production code with SPEC_reviewImplTests       │
   │ 19. SPEC_implProductCodes                           │
   │     Implements production code to pass tests        │
   │ 20. SPEC_reviewProductCodes                         │
   │     Reviews implementation quality; re-runs         │
   │     SPEC_reviewImplTests before commit          │
   │     SPEC_refactTests (optional) cleans one      │
   │     GREEN test, then review again                   │
   │                                                     │
   │     REVISE routes through bounded rework and        │
   │     SPEC_updateMadePlan; unresolved issues stop     │
   │ 21. SPEC_abortUserStory (when unsafe to continue)   │
   │     Moves the active story to abortUS for analysis  │
   └─────────────────────────────────────────────────────┘

   Suspend/resume is a global interrupt at any post-open,
   pre-close step:
   SPEC_suspendUserStory → suspendUS/ with durable resume ref
   SPEC_resumeUserStory  → back to doingUS/ and continue

22. SPEC_commitStepWorks (when planned) /
    SPEC_commitStoryWorks
    Commits planned step boundaries or the story span

23. SPEC_closeUserStory
    Enforces Story Completion Conditions, review/test/commit/CI evidence,
    then moves the story from doingUS/ to doneUS/
    Moves the paired task artifact from doingUS/ to doneUS/

24. SPEC_mergeWorks (when a dedicated story branch was used)
    Merges the closed branch into the integration branch
    Skipped automatically when no story branch was created

SPEC_partialCloseUserStory closes only an accepted slice with traceability
and preserves the remaining scope in abortUS/ with its reasons.

SPEC_patchOriginalCaTDD (non-default branch) sends effective
installed-project CaTDD meta-file improvements back upstream.
```

### Flow Diagram: The Complete Lifecycle

```
                    SPEC_initProjectContext /
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
             pendingNews/*.md                      │
              │             │                     │
              ▼             ▼                     │
     SPEC_analyzeIssue  SPEC_analyzeFeature        │
              │             │                     │
              ▼             ▼                     │
        analyzedNews/*.md  todoUS/*-UserStory.md ◄┘
                     │
                     ▼
              SPEC_openUserStory
                     │
                     ▼
              doingUS/*-UserStory.md
                     │
                     ▼
        SPEC_clearStoryIntent (if intent unclear)
                     │
                     ▼
        SPEC_makePlan (create *-UserStory-Tasks.md)
                     │
         ┌───────────┼───────────┐
         ▼           ▼           ▼
    Requirement  Design       Implementation
    -oriented    -oriented    -oriented
         │           │           │
         ▼           ▼           ▼
    updateStory  takeDesign  SPEC_designTests
    reviewStory  reviewDesign impl/review tests
         │           │       impl/review code
         ▼           ▼           │
    commitStory  commitStory    │
    closeStory   closeStory     ▼
         │           │    SPEC_commitStoryWorks
         └───────────┼──── SPEC_closeUserStory
                     ▼
    Global interrupts from any active step:
    SPEC_suspendUserStory → suspendUS/ (resume reference)
    SPEC_resumeUserStory  → back to doingUS/
    SPEC_abortUserStory   → abortUS/ (later analyze or re-import)
    SPEC_partialCloseUserStory splits accepted vs rejected scope
                     ▼
              doneUS/*-UserStory.md + tasks
                     ▼
    SPEC_mergeWorks when a dedicated story branch was used
```

### Key SpecFlow Commands in Detail

The commands are easier to remember as lifecycle jobs: set context, bring work in, align intent, plan, design-and-gate, then implement-and-close. Consult the flow source for the current command set.

```
   CONTEXT      SPEC_initProjectContext / SPEC_updateProjectContext
   INTAKE       SPEC_import* / SPEC_analyze*
   ALIGN        SPEC_clearStoryIntent
   PLAN         SPEC_makePlan  →  SPEC_whatsNextTask at any time
   DESIGN+GATE  SPEC_take*Design → SPEC_review*Design (never one without the other)
   DELIVER      SPEC_designTests → SPEC_impl* → SPEC_review* → commit → close
```

#### SPEC_initProjectContext

**Purpose**: create the project's shared constitution — the facts, constraints, conventions, and decisions that every later SPEC command references.

**What it records**:

- Project facts: repository, owner, primary purpose
- Layer model: methodPrompts → slashCommands → codeAgents → agentSkills
- Installed project surface: the `.catdd/` directory structure
- Stable conventions: documentation split, English/Chinese mirror rules, method-semantics boundaries
- Current design decisions: P0/P1/P2 category lists, design skeleton naming rules
- Validation commands: scripts that verify documentation and packaging integrity

**Output**: `.catdd/spec/projectContext.md`

**Why it matters**: without project context, every CodeAgent session starts from zero and re-derives your conventions—usually slightly differently each time. The shared context records stable project facts and constraints; use the lifecycle artifacts or `SPEC_showMeStatus` for current story state.

#### SPEC_analyzeIssue

**Purpose**: convert a raw issue or feature request into a traceable user story.

**What it does**:

1. Reads the pending issue/feature file from `pendingNews/`
2. Analyzes the input against project context and existing stories
3. Produces a structured user story in `todoUS/` containing role/capability/value, acceptance criteria candidates, a risk assessment, and open questions for the developer
4. Moves the raw input to `analyzedNews/` for traceability
5. Does **not** invent product intent — unclear aspects stay as open questions

**Output**: a user story file in `todoUS/` plus the raw input archived in `analyzedNews/` with a `## Chat History` record preserving analysis decisions.

**CoT pattern**: ReACT — the command inspects current state, decides what to extract, acts by writing the story, and observes the result iteratively.

#### SPEC_makePlan

**Purpose**: create the execution plan for an opened user story.

**What it does**:

1. Reads the active story in `doingUS/`
2. Classifies the work as one of: **intent-clearing**, **requirement-oriented**, **design-oriented** (initial or follow-up), or **implementation-oriented**
3. Creates a paired `*-UserStory-Tasks.md` file with an EPIC specification-sufficiency ledger, append-only `## Trajectory`, and Markdown checklist
4. Decides the next SPEC command from that classification

**Output**: a task artifact in `doingUS/`.

**Why it matters**: this single classification is what stops teams from jumping to code on a story that first needed intent alignment or architecture. The most expensive mistake in the whole lifecycle is implementing the wrong scope correctly.

```
   SPEC_makePlan classifies, and the classification chooses the road:

   intent-clearing        → SPEC_clearStoryIntent
   requirement-oriented   → SPEC_updateUserStory → SPEC_reviewUserStory
   design-oriented        → SPEC_take*Design      → SPEC_review*Design
   implementation-oriented→ SPEC_designTests  → P0/P1/P2 flows
```

Use [`SPEC_updateMadePlan`](../../slashCommands/commands/Px-SpecFlow/SPEC_updateMadePlan.md) after gate/review transitions, rework, resume, or plan drift. It synchronizes the evidence-backed checklist and orientation, appends Trajectory history, and expands coarse work into design or US/AC/TP/TC slices linked to source-backed TPs. Do not mark a skipped or unverified task complete.

#### Story and design review gates

Before moving work downstream, the SPEC review commands check more than trace links. They use the verdicts `PASS`, `REVISE`, `BLOCKED`, or `ASK`; design reviews also evaluate the cross-artifact Semantic-Delta Matrix, preserving each source obligation as `KEPT`, `DETAILED`, `REASSIGNED`, `EXCLUDED`, `VIOLATED`, or `UNKNOWN`. `UNKNOWN` is not a pass. Review findings route back through the owning update command and `SPEC_updateMadePlan`.

User stories also state story-specific `## Story Completion Conditions` (EPIC E3.4): required test levels/scopes and categories, documentation surfaces, not-done conditions, and approved deferrals. `SPEC_closeUserStory` and `SPEC_partialCloseUserStory` enforce the applicable completion contract rather than relying on a generic checklist alone.

#### SPEC_clearStoryIntent

**Purpose**: align what the developer thinks the story means with what the CodeAgent thinks it means — before design starts.

**What it records** (the Mutual Intent Contract):

- **Developer intent** — what the developer believes the story is about
- **CodeAgent intent** — what the agent infers from reading the story
- **In-scope work** — what is included
- **Out-of-scope work** — what is explicitly excluded
- **Success signal** — how we know the story is done
- **Assumptions** — what is assumed but not confirmed
- **Open questions** — what needs a developer answer

**Why it matters**: if intent is not cleared, the agent may optimize for the wrong success signal. An expensive architecture design that solves the wrong problem is worse than no design at all, because it looks like progress.

#### SPEC_takeArchDesign and SPEC_takeDetailDesign

**Purpose**: produce design artifacts at two levels of abstraction.

**Architecture Design** (`SPEC_takeArchDesign`):

- High-level module decomposition
- Dependency direction and data flow
- Runtime placement and key trade-offs
- Maintains canonical domain terms in `README_UbiLang.md`
- Creates or updates architecture-level verification design in `README_ArchVerifyDesign.md`

**Detail Design** (`SPEC_takeDetailDesign`):

- Class-level API signatures and data structures
- State machines and lifecycle transitions
- Active-story design and detail-level behavior inventory
- Creates or updates `README_DetailVerifyDesign.md` with the `discovery_ledger`
- Keeps `README_VerifyDesign.md` as the verification-design routing index

**Model tier**: both commands require SOTA reasoning for initial design, because they decide boundaries, trade-offs, and constraints. Follow-up revision (`SPEC_updateArchDesign`, `SPEC_updateDetailDesign`) can use High Performance models.

**Important**: `SPEC_take*Design` is for **initial** design work. `SPEC_update*Design` is for **follow-up** revision against existing design evidence, review feedback, or story-level design gaps. Do not mix them.

#### SPEC_reviewArchDesign and SPEC_reviewDetailDesign

**Purpose**: gate design quality before downstream lifecycle steps consume it.

**What they check**:

- **Completeness** — are all necessary design aspects covered?
- **Traceability** — does the design connect to requirements?
- **Consistency** — are there internal contradictions?
- **Feasibility** — is it implementable given the constraints?
- **Clarity** — can a developer read this and implement it correctly?

**Critical rule**: every design-producing step (`SPEC_take*Design`, `SPEC_update*Design`) must be followed by its review gate before downstream lifecycle steps. Never skip review.

```
   production step              gate step
   ───────────────              ─────────
   SPEC_takeArchDesign     →    SPEC_reviewArchDesign
   SPEC_takeDetailDesign   →    SPEC_reviewDetailDesign
   SPEC_updateArchDesign   →    SPEC_reviewArchDesign   (re-gate)
   SPEC_updateDetailDesign →    SPEC_reviewDetailDesign (re-gate)

   a revision is a new claim — it gets the same gate as the original
```

#### SPEC_designTests

**Purpose**: enter CaTDD test design after reviewed story and design inputs are ready.

**What it does**:

1. Reads authoritative story and design sources before existing tests
2. Uses source-first discovery to identify obligations, TPs, and unresolved questions
3. Decides the P0 Functional skeleton set first, then considers source-backed P1/P2 promotion
4. Inspects matching `TEST_*` contracts when available and records command provenance
5. Reports the appropriate category-skeleton review command before implementation

**Verification method**: follow CaTDD method prompts and the declared `TestLevel`/`TestScope`. A project-specific alternative requires explicit project direction; it must not be inferred from the absence of a command.

#### Commit checkpoints

Use the commit command that matches the lifecycle span:

- `SPEC_commitPreStoryWorks` records intake/analysis work before the story moves into `doingUS/`.
- `SPEC_commitStepWorks` records a planned, verified step boundary.
- `SPEC_commitStoryWorks` commits the open-to-close story span and handles a required post-close checkpoint.
- `SPEC_commitWorks` remains available for its command contract; follow the flow's specific checkpoint instead of treating it as a universal lifecycle substitute.

#### SPEC_closeUserStory

**Purpose**: move completed work to the done archive.

**What it does**:

1. Verifies the story is actually complete (reviews, tests, commits done)
2. Moves the story from `doingUS/` to `doneUS/`
3. Moves the paired task artifact alongside it
4. Records the closure date and any lessons learned
5. Refuses to close a story that is not reviewed and committed

#### SPEC_updateProjectContext, SPEC_suspendUserStory, SPEC_resumeUserStory, SPEC_mergeWorks, and SPEC_partialCloseUserStory

- `SPEC_updateProjectContext` — refresh the shared project constitution whenever project facts, constraints, or conventions change; run it after a merge when lifecycle or project-context facts changed.
- `SPEC_suspendUserStory` — pause an active story at any post-open, pre-close step when an external dependency or environment blocks it. The story and task artifact move to `suspendUS/` with a durable resume reference (branch or worktree).
- `SPEC_resumeUserStory` — move a suspended story and its task artifact back to `doingUS/` after validating that the resume reference still exists, then continue via `SPEC_whatsNextTask`.
- `SPEC_mergeWorks` — after `SPEC_closeUserStory`, merge the closed story branch into the target integration branch when branch integration is still required; it is auto-skipped when no dedicated story branch was used.
- `SPEC_partialCloseUserStory` — split one active story when only part of its scope is accepted: the accepted slice closes with traceability while the rejected or deferred slice moves to `abortUS/` with explicit reasons and evidence.

`SPEC_whatsNextTask` can be invoked at any point to read the current `.catdd/spec/` state and recommend the single next command. It is the cheapest way to answer "what now?" without re-reading the whole lifecycle.

---

## Model Tier Guidance for Commands

Px-SpecFlow gives explicit model tier guidance. The rule is the same as elsewhere in CaTDD: use the smallest model that preserves decision quality.

| Tier | Purpose | SPEC Commands |
|---|---|---|
| **SOTA reasoning** | Architecture decisions, system boundaries, quality trade-offs, irreversible choices | `SPEC_takeArchDesign`, `SPEC_reviewArchDesign` |
| **High Performance** | Requirements analysis, intent alignment, planning, requirement updates, local design, review gates, test design, code review, correction routing, controlled patch-back | `SPEC_initProjectContext`, `SPEC_updateProjectContext`, `SPEC_analyzeIssue`, `SPEC_analyzeFeature`, `SPEC_analyzeAbortedUserStory`, `SPEC_clearStoryIntent`, `SPEC_makePlan`, `SPEC_updateMadePlan`, `SPEC_updateUserStory`, `SPEC_whatsNextTask`, `SPEC_whatsWrong`, `SPEC_takeArchDesign`, `SPEC_reviewArchDesign`, `SPEC_updateArchDesign`, `SPEC_takeDetailDesign`, `SPEC_reviewDetailDesign`, `SPEC_updateDetailDesign`, `SPEC_reviewUserStory`, `SPEC_designTests`, `SPEC_reviewImplTests`, `SPEC_reviewProductCodes`, `SPEC_patchOriginalCaTDD` |
| **Flash Speed** | Deterministic import, move, suspend, resume, partial-close, abort, commit, close, or small test-driven implementation/refactor steps | `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, `SPEC_openUserStory`, `SPEC_suspendUserStory`, `SPEC_resumeUserStory`, `SPEC_partialCloseUserStory`, `SPEC_abortUserStory`, `SPEC_implTests`, `SPEC_implProductCodes`, `SPEC_refactTests`, `SPEC_commitPreStoryWorks`, `SPEC_commitStepWorks`, `SPEC_commitStoryWorks`, `SPEC_commitWorks`, `SPEC_closeUserStory` |

**Escalation rule**: move from a lower tier to a higher one when a command reveals architecture-significant uncertainty — competing non-functional requirements, safety or security risk, real-time or embedded constraints, concurrency boundaries, data migration, compatibility matrices, or irreversible module/API ownership decisions.

```
   cheaper model                        expensive model
   ─────────────                        ───────────────
   import, move, commit, close     ←→   design, review, plan, align
   reversible, mechanical               fans out into everything below it
```

---

## Chain-of-Thought Patterns in Commands

Each command declares one of three reasoning patterns, chosen by decision complexity. The declaration is part of the contract: the agent knows how much thinking the step deserves.

```
   Linear  ──►  fixed steps, complete inputs      (move it, commit it)
   ReACT   ──►  inspect → act → observe, repeat   (analyze, review)
   ToT     ──►  generate options → compare → pick  (architecture, scope)
```

### ReACT (Reasoning + Acting)

Used when a command must inspect lifecycle state, decide, act, and observe the result iteratively.

1. **Thought** — inspect input artifacts; identify current state, gaps, conflicts
2. **Action** — create, update, review, or move the named artifact
3. **Observation** — verify the output meets the contract; check for missing traceability, unresolved questions, quality failures
4. If observation reveals a quality issue, surface it as a question or assumption and stop

**Used by**: `SPEC_analyzeIssue`, `SPEC_makePlan`, `SPEC_reviewArchDesign`, `SPEC_reviewDetailDesign`, `SPEC_reviewProductCodes`

### ToT (Tree of Thoughts)

Used when a command must generate several candidate approaches, evaluate them, and select the best.

1. **Generate** — produce 2+ candidate approaches or artifact outlines
2. **Evaluate** — assess each against quality criteria
3. **Select** — choose the best; if none is clearly best, present the options to the developer
4. **Execute** — apply the selected candidate to produce the output artifact
5. **Verify** — confirm the output meets the contract

**Used by**: `SPEC_takeArchDesign` (comparing architectural alternatives), `SPEC_clearStoryIntent` (evaluating different scopes)

### Linear (Direct Execution)

Used when the action is deterministic given complete, valid inputs.

1. Read inputs and method references
2. Preserve existing traceability, status markers, and conventions
3. Perform only this command's requested step
4. Report the artifact produced and the next recommended command

**Used by**: `SPEC_importIssue`, `SPEC_openUserStory`, `SPEC_commitWorks`, `SPEC_closeUserStory`

---

## SpecFlow Artifacts

### Lifecycle Artifacts (under `.catdd/spec/`)

| Artifact | Purpose | Git Policy |
|---|---|---|
| `projectContext.md` | Shared project constitution | Commit — teammates and agents need the same facts |
| `pendingNews/*.md` | Imported work waiting for analysis | Commit — team visibility |
| `analyzedNews/*.md` | Archived raw inputs after analysis | Commit — traceability preserved |
| `todoUS/*-UserStory.md` | Analyzed stories ready to pick up | Commit — team backlog |
| `doingUS/*-UserStory.md` | Active stories in progress | Commit — cross-machine visibility |
| `doingUS/*-UserStory-Tasks.md` | Active task plan with checkbox tasks | Commit — explicit, checkable steps |
| `suspendUS/*` | Suspended stories with durable resume references | Commit — resumable across machines |
| `abortUS/*` | Aborted work preserved with reasons | Commit — later analysis or re-import |
| `doneUS/*-UserStory.md` | Completed, reviewed, committed stories | Commit — project history |
| `doneUS/*-UserStory-Tasks.md` | Completed task artifact | Commit — later diagnosis |
| `WorkingProcessLog.md` | Local work-state trace | Gitignore — personal, not team-shared |

### Project-Root SPEC Docs

| File | Purpose | Managed By |
|---|---|---|
| `README.md` | Project overview, ownership, master directories | Other SPEC steps |
| `README_ArchDesign.md` | High-level architecture, modules, dependencies | `SPEC_takeArchDesign` |
| `README_DetailDesign.md` | Class design, API signatures, data structures | `SPEC_takeDetailDesign` |
| `README_UserStories.md` | Project-scoped user stories, trace links | Other SPEC steps |
| `README_UserGuide.md` | User-facing runtime usage guidance | Other SPEC steps |
| `README_ArchVerifyDesign.md` | System-composition boundary, TestLevel/TestScope strategy, double credibility | SpecFlow and system verification |
| `README_DetailVerifyDesign.md` | Behavior inventory, source-first `discovery_ledger`, category strategy | SpecFlow and category-level verification |
| `README_VerifyDesign.md` | Routing index to verification-design sources | SpecFlow |
| `README_UbiLang.md` | Canonical project terminology | Architecture and all downstream design |
| `README_ErrorDesign.md` | Fault-tolerance architecture, fail-safe states | `SPEC_takeArchDesign` |
| `README_ResourceDesign.md` | Resource allocations, memory/CPU budgets | `SPEC_takeArchDesign` |
| `README_StateDesign.md` | State machines, lifecycle transitions | `SPEC_takeDetailDesign` |
| `README_PerfDesign.md` | Performance budgets, latency limits | `SPEC_takeArchDesign` |
| `README_CompatDesign.md` | Compatibility matrices, platform/toolchain versions | `SPEC_takeArchDesign` |
| `README_DiagnosisDesign.md` | Observability, logging, telemetry, diagnostics | `SPEC_takeArchDesign` |
| `README_UsageDesign.md` | Public boundaries, CLI/API contracts | `SPEC_takeArchDesign` |

Create project-root SPEC docs only when the project needs that surface. Use templates from `slashCommands/templates/` the first time you create one.

---

## The Command Template as a Contract

Every slash command is a contract between the developer and the CodeAgent. The developer invokes it, signalling intent. The CodeAgent executes it, applying the method faithfully. The contract has five parts:

1. **Preconditions** — inputs that must exist before invocation (API headers, existing skeletons, project context)
2. **Action** — the single step the command performs. Not "design, implement, and review" — pick one
3. **Postconditions** — outputs that must exist after execution (a designed skeleton, an implemented test, a review report)
4. **Invariants** — what must be preserved: CaTDD comment skeletons, source-linked US/AC/TP/TC traceability, category labels, status markers
5. **Next** — what command should come next. Never leave the CodeAgent guessing

```
   invoke ──► preconditions ok? ──► perform ONE action ──► postconditions met?
                     │                                            │
                    no                                          yes
                     ▼                                            ▼
              stop and say what's missing              report + name the next command
```

This structure is why commands are reproducible. Every invocation of `TEST_designTypicalSkeleton` produces a CaTDD Typical skeleton regardless of which CodeAgent runs it, because the contract defines the output precisely — not the tool, and not the model.

---

## Conflict Guard Rules

Px-SpecFlow defines seven guard rules so the layers cannot violate each other's boundaries:

1. **Px-SpecFlow defines lifecycle orchestration only** — CaTDD method semantics remain in methodPrompts.
2. **SPEC commands may call TEST commands, but must not replace method-prompt semantics or P0/P1/P2/P3 category rules.**
3. **Do not skip `SPEC_reviewUserStory` after `SPEC_updateUserStory`** in requirement-oriented work.
4. **Do not start design when developer intent and CodeAgent intent are not cleared** for the active story.
5. **After `SPEC_makePlan`**, use `SPEC_take*Design` only for initial design work and `SPEC_update*Design` only for follow-up design revision.
6. **Every design-producing step must be followed by its review gate** before downstream lifecycle steps.
7. **If product intent is unclear, keep the user story open and ask the developer** instead of inventing requirements.

Rules 3, 6, and 7 are the ones that most often save a project. Each of them exists because the cheap-looking shortcut (skip the review, skip the question, revise without re-gating) produces work that looks finished and is not.

---

## Execution Modes and the ONE-MORE-THING Stop Rule

Px-SpecFlow runs the same flow interactively or headlessly.

| Mode | How it behaves |
|---|---|
| **manualMode** (default) | Interactive chat. One slash command at a time; the assistant asks focused questions when intent, criteria, or safety is unclear. |
| **autonomousMode** (opt-in) | A flow-level mode selected through a compatible driver or entry command. It may auto-advance only within the allowed lifecycle orientation and must stop on uncertainty; it is not itself a standalone CLI. |

**Safety boundary**: only implementation-oriented stories support `autonomousMode`. If autonomy is triggered on an intent-clearing, requirement-oriented, or design-oriented story, the flow must halt, force `manualMode`, and require developer confirmation. Requirements analysis and architecture design need human intent and trade-offs.

```
   autonomousMode allowed?
     implementation-oriented   →  yes
     requirement-oriented      →  no   → halt, force manualMode
     design-oriented           →  no   → halt, force manualMode
     intent-clearing           →  no   → halt, force manualMode
```

Command-level `analysis_mode` (`BRAINSTORM` default, or `AUTONOMOUS`) is a local setting inside `SPEC_analyzeIssue` / `SPEC_analyzeFeature`. It does not switch the flow into `autonomousMode`.

Every CaTDD command enforces the **ONE-MORE-THING** universal stop rule: ask the developer when something is not certain. In `manualMode`, the assistant stops and asks immediately. In `autonomousMode`, autonomy is never a license to guess—the run must halt and return control for a decision.

The lifecycle can end by closing, aborting, or suspending a story. A compatible driver owns its process-level exit behavior; the portable command contract does not promise particular exit codes.

```
   SPEC_closeUserStory   →  reviewed, completed story
   SPEC_abortUserStory   →  active work preserved as aborted
   SPEC_suspendUserStory →  active work paused with resume evidence
```

---

## Command Invocation in Practice

The same command file is invoked differently depending on the CodeAgent.

### In Copilot Chat

```
/TEST_designTypicalSkeleton
```

When the Copilot adapter is installed, `.github/prompts/TEST_*.prompt.md` wrappers expose the portable command contracts. The wrapper is an adapter; the source command and method prompt remain canonical.

### In Cline/Continue

The command prompt file is read directly. You type the command name or select it from the assistant's command palette.

### In utCodeAgentCLI

`utCodeAgentCLI` is a separate agent integration, not the slash-command filename convention. Its implementation and usage guide own the current CLI flags and behavior aliases; do not infer them from `TEST_*` command names.

### Portable Placeholders

Command files use portable placeholders that adapters fill in:

- `{{feature_name}}` — name of the feature/module being tested
- `{{category}}` — CaTDD category (Typical, Edge, etc.)
- `{{source_files}}` — API headers or spec documents
- `{{test_files}}` — existing test files to read and extend
- `{{language}}` — target programming language
- `{{test_framework}}` — test framework in use
- `{{developer_goal}}` — developer intent not captured in artifacts

```
   portable command file            adapter                tool
   ────────────────────             ───────                ────
   {{feature_name}}          →      filled from context  →  Copilot / Cline /
   {{category}}                     per tool format         Continue / CLI
```

---

## When to Use Which Flow

| Starting Point | Flow to Use |
|---|---|
| New component, no existing tests | P0-FuncTestsFlow → `TEST_designTypicalSkeleton` |
| Existing demo code | P0-FuncTestsFlow → `TEST_convertDemoToTypical` |
| Full functional test design | P0-FuncTestsFlow → `TEST_designFuncTestsSkeleton` |
| Need architecture validation | P1-DesignTestsFlow (after P0 complete) |
| Need performance/capacity data | P2-QualityTestsFlow (after P0/P1 complete) |
| New feature request from product team | Px-SpecFlow → `SPEC_importFeature` → `SPEC_analyzeFeature` |
| Bug report from QA | Px-SpecFlow → `SPEC_importIssue` → `SPEC_analyzeIssue` |
| Already have a user story | Px-SpecFlow → `SPEC_importUserStory` → `SPEC_openUserStory` |
| Unsure what to do next | Px-SpecFlow → `SPEC_whatsNextTask` (reads current state and recommends the next action) |
| Resume a suspended story | Px-SpecFlow → `SPEC_resumeUserStory` (validates the durable resume reference) |
| Architecture decision needed | Px-SpecFlow → `SPEC_takeArchDesign` |
| Ready to code after design | Px-SpecFlow → `SPEC_designTests` → P0/P1/P2 flow |
| Installed CaTDD harness looks broken | Px-HarnessKits → `HARNESS_verifyInstallation` → `HARNESS_diagnoseInstallation` |
| Reusable lesson from a verified run | Px-HarnessKits → `HARNESS_evolveHarness` |
| Need a read-only lifecycle snapshot | Px-StatusKits → `SPEC_showMeStatus` |

```
   "I have a bug"        → SPEC_importIssue   → SPEC_analyzeIssue
   "I have a feature"    → SPEC_importFeature → SPEC_analyzeFeature
   "I have a story"      → SPEC_importUserStory → SPEC_openUserStory
   "I don't know"        → SPEC_whatsNextTask
```

---

## The Subagent Pattern

Some SPEC commands support background delegation via subagents.

- **When to delegate**: a new issue surfaces while other work is in progress
- **What to capture**: the source text or URL and the relevant project context
- **What to expect back**: the output file name (for example, a new story in `todoUS/`)
- **Caller behavior**: the main conversation continues without waiting

**Suitable for delegation**: `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_analyzeIssue`, `SPEC_analyzeFeature`.

**Must run synchronously**: `SPEC_takeArchDesign` (its output is needed immediately for review), `SPEC_makePlan` (it determines the next step), `SPEC_commitWorks` (it must be synchronous with the developer's workspace).

```
   main conversation ──── continues ────►  next design step
          │
          └─ delegate ─► subagent: import + analyze issue
                              │
                              └─ returns: todoUS/...-UserStory.md
```

Follow the target command's `Subagent Recommendation` and the team's delegation policy. A delegated result still requires review against its output contract; delegation does not bypass human decisions, safety boundaries, or lifecycle gates.

---

## From Commands to Automation

Slash commands are the bridge between VibeCoding's conversational flexibility and repeatable SpecCoding. When a developer invokes `/TEST_implTestCase`, a compatible CodeAgent reads the portable contract and applies the CaTDD method. `/SPEC_analyzeIssue` reads the raw input, creates a traceable story, and archives the source with its Chat History. The command layer is usable independently of the still-incremental `specCodeAgentCLI` design target.

The next chapter, **applyClassicSWE**, connects these repeatable workflows to the enduring TDD, BDD, and DDD practices they build on.

## Evolved Command Overlays

When a project has a local `<Name>Evolved.md` beside a canonical command, flow, or kit, use the self-contained overlay for that project. It supersedes the canonical file locally; it is not an upstream source edit and is not part of the installation manifest. `HARNESS_evolveHarness` creates or refines one sibling overlay; `HARNESS_patchCaTDDSource` is the guarded promotion path back to the CaTDD source. Do not ignore a local overlay or silently overwrite it during refresh.

## Usage Example

In a target project with CaTDD SpecFlow installed and an active story, run this read-only status command in the assistant:

```text
/SPEC_showMeStatus
```

Expected result: a SPEC viewpoint report with evidence, findings, and an owning `next_command`. The status command reports state; it does not change story files or perform the recommended action.
