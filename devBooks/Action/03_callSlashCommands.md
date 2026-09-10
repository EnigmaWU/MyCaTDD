# 03 callSlashCommands

## What Are Slash Commands?

A slash command is a Markdown file that tells a CodeAgent what to do next. It is not a shell command. It is a written instruction with a contract: read this, do exactly this one step, produce this, keep these things intact, and then say what comes next.

That is why the same command works in different tools. The file is plain Markdown, so Copilot, Cline, Continue, and `utCodeAgentCLI` can all read it.

```
   methodPrompts          slashCommands            CodeAgent
   ─────────────          ─────────────            ─────────
   what the method    →   one step, with a     →   performs the step:
   means: categories,     contract: what to        reads the files,
   gates, US/AC/TC        read, produce,           writes the output,
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

   command: /UT_designTypicalSkeleton
            → US/AC/TC chain + coverage matrix + TODO status
            → reviewable before a single line of test code exists
```

Both cost one message to the agent. Only the second leaves a reviewer something to check.

---

## The Three Command Families

```
   ┌────────────────────────────────────────────────────────────────────┐
   │  UT_*        test design and implementation                        │
   │              works on: skeletons, test files, TODO status          │
   ├────────────────────────────────────────────────────────────────────┤
   │  SPEC_*      story lifecycle orchestration                         │
   │              works on: context, news, stories, designs, commits    │
   ├────────────────────────────────────────────────────────────────────┤
   │  HARNESS_*   engineering tool points around the harness            │
   │              works on: installs, diagnostics, sessions, patches    │
   └────────────────────────────────────────────────────────────────────┘
```

### UT Commands — Unit Test Design and Implementation

```text
UT_<verb><Object>
```

UT commands execute CaTDD test development steps. They operate on test files, design skeletons, and implementation artifacts, and they belong to category-specific flows (P0, P1, P2).

**Examples**:

- `UT_designTypicalSkeleton` — design the Typical category design skeleton
- `UT_implTestCase` — implement one test case through the RED→GREEN cycle
- `UT_reviewFuncTestsSkeleton` — review the complete P0 functional skeleton set before implementation
- `UT_tellMeNextImplTest` — pick the next test case from the TODO tracking section

### SPEC Commands — SpecCoding Lifecycle Orchestration

```text
SPEC_<verb><Object>
```

SPEC commands drive work through a traceable SpecCoding lifecycle. They operate on lifecycle artifacts — project context, pending news, user stories, design docs, tests, product code, commit state — not on test categories or category skeletons directly.

**Examples**:

- `SPEC_initProjectContext` — create the first project context file
- `SPEC_analyzeIssue` — turn an issue into a traceable user story
- `SPEC_takeArchDesign` — produce the high-level architecture design
- `SPEC_designUnitTests` — enter CaTDD test design, usually through the P0/P1/P2 flows
- `SPEC_commitWorks` — prepare and commit completed work
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

The three families answer three different questions: *is the test design right?* (UT), *is the story moving correctly?* (SPEC), *is the tooling around the method healthy?* (HARNESS).

---

## The Universal Command Template

Every slash command uses the same Markdown structure, defined in `UT_slashCommandTemplate.md` and `SPEC_slashCommandTemplate.md`:

| Section | Content |
|---|---|
| **Command Header** | Command name, flow, CaTDD class, category, method source, adapter target |
| **CoT Pattern** | Declared reasoning pattern — ReACT, ToT, or Linear — with execution steps for that pattern |
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

Uniformity is the point: a command written once runs everywhere, because nothing in it depends on one tool's prompting format.

---

## The Four Command Flows and the HarnessKits Kit

Commands are grouped into four flows plus one operational kit:

```
  slashCommands/flows/
  ├── P0-FuncTestsFlow.md      ← UT commands for functional test design
  ├── P1-DesignTestsFlow.md    ← UT commands for design-oriented tests
  ├── P2-QualityTestsFlow.md   ← UT commands for quality-oriented tests
  └── Px-SpecFlow.md           ← SPEC commands for full lifecycle orchestration

  slashCommands/kits/
  └── Px-HarnessKits.md        ← HARNESS_* operational tool points
```

`Px` in SpecFlow means **cross-priority**. It is not a test category priority like P0/P1/P2 — it is a process flow that orchestrates those test layers.

`Px-HarnessKits` is cross-priority too, but it is a kit rather than a lifecycle flow: it groups tool-point commands without imposing a strict command sequence. Future addon and demo commands belong to `P3 Addons`, which keeps them aligned with `methodPrompts`.

```
   P0 functional  ──►  P1 design  ──►  P2 quality
        │                  │               │
        └────────── Px-SpecFlow ───────────┘
                orchestrates the story

   Px-HarnessKits  ⊥  sits beside the flows:
   install, diagnose, session, patch back
```

---

## P0 FuncTestsFlow — The First Flow to Learn

P0 is the most common entry point because it covers functional test design, which is what every developer needs first. The flow has one job: turn a component into four kinds of functional skeleton (Typical, Edge, Misuse, Fault), review them as a set, then implement them one test case at a time.

```
              Existing demo tests
                      │
                      ▼
         ┌─────────────────────────┐
         │ UT_convertDemoToTypical │
         └───────────┬─────────────┘
                     │
                     ▼
    Interface/protocol ──┬─→ UT_designTypicalSkeleton
                         └─→ UT_designFuncTestsSkeleton (Typical+Edge+Misuse+Fault)
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
              └───────────┬───────────┘
                          ▼
                UT_refactTestCase (optional, GREEN cleanup)
                          │
                          ▼
                 UT_reviewImplTestCase (re-review)
```

### Entry Points

You can start the P0 flow from three places:

1. **Existing demo tests** — use `UT_convertDemoToTypical` to extract core behavior into a CaTDD Typical skeleton. This preserves existing work instead of throwing it away.
2. **Interface or protocol** — use `UT_designTypicalSkeleton` to design the Typical skeleton from the API contract.
3. **Full functional set at once** — use `UT_designFuncTestsSkeleton` to produce all four skeletons (Typical + Edge + Misuse + Fault) in a single step.

### The Ten Steps at a Glance

| # | Command | What it produces |
|---|---|---|
| 1a | `UT_convertDemoToTypical` | Typical skeleton extracted from an existing demo test |
| 1b | `UT_designTypicalSkeleton` | Typical skeleton designed from the interface |
| 3–5 | `UT_designEdgeSkeleton`, `UT_designMisuseSkeleton`, `UT_designFaultSkeleton` | The other three P0 skeletons, in priority order |
| 6 | `UT_reviewFuncTestsSkeleton` | PASS/FAIL review report on the whole P0 set |
| 7 | `UT_tellMeNextImplTest` | The next test case to implement, with blockers |
| 8 | `UT_implTestCase` | One implemented test case with RED→GREEN history |
| 9 | `UT_reviewImplTestCase` | PASS/FAIL review of that implementation |
| 10 | `UT_refactTestCase` (optional) | The same behavior, easier to read |

### Steps 1–5: Design the Skeletons

`UT_convertDemoToTypical` is for demo tests that exercise the component. Note what those tests are *not*: they are raw input material, not CaTDD P3 Demo/Example tests. The command reads the demo, extracts the core behavior patterns, maps them into CaTDD Typical format, and writes a skeleton with `@[US]`, `@[AC]`, `@[TC]` markers and a populated OVERVIEW section.

`UT_designTypicalSkeleton` is for the no-demo case. It reads the interface specification, analyzes the API contract, finds the happy-path scenarios, and writes the full US/AC/TC chain.

Both paths continue to `UT_designEdgeSkeleton`. The next three commands each design one category skeleton, reading the existing skeletons for consistency, the API interface, and the category-specific method prompt. They run in P0 order: Edge after Typical, Misuse after Edge, Fault after Misuse.

**Important**: the same US IDs carry across categories. US-1 covers Typical scenarios, and that same US-1 can also have Misuse scenarios — what happens when this capability is used incorrectly inside the same user story. Categories are lenses on the same user value, not four separate backlogs.

### Step 6: UT_reviewFuncTestsSkeleton — the gate that saves money

**When**: all P0 skeletons are designed, none implemented.

**What it checks**:

- **Completeness** — are all four categories present?
- **Traceability** — does every TC reference an AC, and every AC a US?
- **Category correctness** — is anything classified as Edge that is really Misuse?
- **Consistency** — do naming, status markers, and formats follow convention?
- **Gate readiness** — is this design ready for P0 implementation?

**Output**: a PASS/FAIL report per dimension, with the specific issues to fix.

```
   UT_reviewFuncTestsSkeleton  →  FAIL
     completeness    PASS   4/4 categories present
     traceability    FAIL   TC-Edge-3 references no AC
     category        PASS   no Misuse scenario hiding in Edge
     consistency     PASS   naming and status markers follow convention
     gate readiness  FAIL   fix TC-Edge-3, then re-run this command
```

**Next command**: PASS → `UT_tellMeNextImplTest`. FAIL → back to the specific design command.

Never skip this gate. A design flaw caught here costs a text edit; the same flaw caught after implementation costs a rewritten test, a rewritten production path, and a re-review — which is exactly the 10x difference the method is built to exploit.

### Step 7: UT_tellMeNextImplTest — remove the "where was I?" tax

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

### Step 8: UT_implTestCase — one test case, both colors

**When**: a specific TC has been selected for implementation.

**What it does**, in order:

1. Writes the test implementation using the 4-phase structure (SETUP / BEHAVIOR / VERIFY / CLEANUP)
2. Marks it 🔴 RED in the TODO section
3. Runs the test — confirms RED, failing because production code is missing
4. Implements minimal production code
5. Runs the test — confirms GREEN
6. Marks it 🟢 GREEN in the TODO section
7. Updates the TC specification with implementation notes

**Output**: one implemented test case with its RED→GREEN history and an updated status marker.

**Next command**: `UT_reviewImplTestCase`.

### Step 9: UT_reviewImplTestCase — check the claim, not the color

**What it reviews**:

- **Correctness** — does the test actually verify the AC it claims to verify?
- **Structure** — does it follow the 4-phase pattern?
- **Assertions** — are there ≤3 key assertions, and are they meaningful?
- **Traceability** — is the US/AC/TC chain preserved?
- **Isolation** — does cleanup run and prevent state leakage?
- **Status** — are the markers correctly set?

**Output**: a PASS/FAIL report. PASS loops back to `UT_tellMeNextImplTest`; FAIL routes back for fixes.

### Step 10: UT_refactTestCase (optional) — clean up without changing meaning

**When**: a selected TC is GREEN and reviewed, but the test body is hard to read or maintain.

**What it does**: refactors that single test case for clarity, without changing behavior, category routing, or the US/AC/TC traceability chain.

**Hard boundary**: missing behavior, missing coverage, or wrong category routing must go back to the design or implementation commands. Refactoring is not a side door for new coverage.

**Next command**: `UT_reviewImplTestCase` again — to prove the cleanup caused no skeleton drift.

---

## The RED→GREEN Discipline in Slash Commands

`UT_implTestCase` is where CaTDD stops being a design document and starts changing code. The discipline below is what keeps the test honest.

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

### The Design Source Gate

Before drafting a P1 or P2 skeleton, the command must find a confirmed design source. If the source is missing, the command **warns and stops** before drafting anything, and asks the developer where the design lives — instead of inventing architectural decisions inside a test file.

| Priority | Category | Required Design Source |
|---|---|---|
| P1 | State | `README_StateDesign.md` or a `State Design` chapter in `README_ArchDesign.md` |
| P1 | Capability | `README_DetailDesign.md` |
| P1 | Interaction | Sequence, interaction, or collaboration sections in `README_ArchDesign.md` |
| P1 | Concurrency | `README_ResourceDesign.md` |
| P2 | Performance | `README_PerfDesign.md` |
| P2 | Robust | `README_ErrorDesign.md` |
| P2 | Compatibility | `README_CompatDesign.md` |
| P2 | Configuration | `README_DetailDesign.md` |
| P2 | Diagnosis | `README_DiagnosisDesign.md` / `README_VerifyDesign.md` evidence requirements |
| P2 | Security | `README_SecurityDesign.md` (+ threat model, security policy, or constitutional invariants ($K$)) |

```
   /UT_designStateSkeleton
        │
        ├─ README_StateDesign.md found?
        │        │
        │        ├─ yes → draft the skeleton
        │        └─ no  → stop and ask:
        │                 "Where does the state architecture design live?
        │                  I need it before I can design state tests."
```

The gate exists because P1 and P2 tests verify **architectural decisions**, not API behavior. Writing a state test without a state design means the test encodes whatever the agent assumed — and assumptions are much harder to review than designs.

### P1-DesignTestsFlow

Addresses architectural validation: State, Capability, Interaction, and Concurrency.

```
P0 functional skeletons (completed)
         │
         ├─ UT_designStateSkeleton
         ├─ UT_designCapabilitySkeleton
         ├─ UT_designConcurrencySkeleton
         └─ Interaction  (direct method prompt, no dedicated command yet)
                        │
                        ▼
              UT_reviewDesignTestsSkeleton
                        │
                        ▼
        UT_tellMeNextImplTest → UT_implTestCase → UT_reviewImplTestCase
```

**Entry conditions**: P0 functional skeletons must exist (especially Typical and Edge). Each P1 category requires a confirmed design source. P1 must have design before skeleton drafting starts.

**Routing note**: State, Capability, and Concurrency have dedicated `UT_design*Skeleton` commands. Interaction has no dedicated slash command yet — the flow routes it through `CaTDD_methodPrompt4Cat-Interaction.md` directly, drafting source-linked US/AC/TC into the canonical `designInteraction` category file under the same Discovery Gate and review contract.

**Gate P1**: before entering P1, all P0 tests must be GREEN. Before leaving P1, the architecture must be validated: State tests GREEN when stateful behavior exists, Capability tests GREEN when designed limits exist, Interaction tests GREEN when sequence/collaboration/handoff rules exist, Concurrency tests GREEN when shared execution exists — with no deadlocks, no race conditions, ThreadSanitizer clean.

### P2-QualityTestsFlow

Addresses non-functional quality attributes: Performance, Robust, Compatibility, Configuration, Diagnosis, Security.

```
P0/P1 stable coverage (completed)
         │
         ├─ UT_designPerformanceSkeleton
         ├─ UT_designRobustSkeleton
         ├─ UT_designCompatibilitySkeleton
         ├─ UT_designConfigurationSkeleton
         ├─ UT_designSecuritySkeleton
         └─ Diagnosis  (direct method prompt)
                        │
                        ▼
             UT_reviewQualityTestsSkeleton
                        │
                        ▼
        UT_tellMeNextImplTest → UT_implTestCase → UT_reviewImplTestCase
```

**Entry conditions**: P0 functional coverage exists, P1 design coverage exists when relevant, and each P2 category has a confirmed project-root design source.

**Routing note**: Performance, Robust, Compatibility, Configuration, and Security have dedicated `UT_design*Skeleton` commands. Diagnosis has no dedicated slash command yet — the flow routes it directly through `CaTDD_methodPrompt4Cat-Diagnosis.md`, drafting source-linked US/AC/TC into the canonical `qualityDiagnosis` category file.

**Gate P2**: before entering P2, P1 must be complete. Before leaving P2, quality SLOs must be met, required diagnosis/observability evidence verified, security protection tests GREEN where a threat model or policy applies, and production-readiness criteria satisfied.

---

## Px-SpecFlow — The Master Orchestration Flow

Px-SpecFlow is the largest flow because it does not manage tests — it manages stories. UT flows answer "what should this component do, and is it proven?" SPEC commands answer "where is this work right now, what does it need next, and who can see that it happened?"

```
   UT flows   → work inside one category (Typical, Edge, State, ...)
   SPEC flow  → work across the whole story lifecycle
                import → analyze → design → test → implement → commit → close
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

   Day 2  SPEC_openUserStory  → doingUS/...-UserStory.md
          SPEC_makePlan       → doingUS/...-UserStory-Tasks.md

   Day 4  SPEC_suspendUserStory → suspendUS/...  (waiting for HW trace tool)
   Day 9  SPEC_resumeUserStory  → doingUS/...    (reference still valid)
   Day 9  SPEC_commitWorks + SPEC_closeUserStory → doneUS/...
```

Six days of "paused" are now visible as a state with a reason, not as an ambiguous silence.

### The Full Command Sequence

The complete SpecFlow lifecycle has **34 SPEC commands** organized into three phases.

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
   Moves raw input from pendingNews/ to analyzedNews/ for traceability

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
   Creates the paired task artifact (*-UserStory-Tasks.md) in doingUS/
   Classifies work as: intent-clearing, requirement-oriented,
   design-oriented, or implementation-oriented
   Decides which SPEC_* step comes next

   ┌─ If requirement-oriented ──────────────────────────┐
   │ 9.  SPEC_updateUserStory                            │
   │     Updates README_UserStories.md ledger and paired │
   │     README_UserGuide.md (plus module surfaces)      │
   │ 10. SPEC_reviewUserStory                            │
   │     Reviews requirement quality                     │
   │     If PASS: commit/close, or transfer to design-   │
   │     oriented next steps                             │
   └─────────────────────────────────────────────────────┘

   ┌─ If design-oriented (initial architecture) ─────────┐
   │ 11. SPEC_takeArchDesign                             │
   │     Produces README_ArchDesign.md                   │
   │ 12. SPEC_reviewArchDesign                           │
   │     Gates architecture quality before detail design │
   │ 13. SPEC_updateArchDesign (if review fails)         │
   └─────────────────────────────────────────────────────┘

   ┌─ If design-oriented (initial detail) ───────────────┐
   │ 14. SPEC_takeDetailDesign                           │
   │     Produces README_DetailDesign.md and ACs         │
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
   │ 17. SPEC_designUnitTests                            │
   │     Enters CaTDD test design via P0/P1/P2 flows     │
   │ 18. SPEC_implUnitTests                              │
   │     Implements selected TCs (RED→GREEN)             │
   │     then SPEC_reviewImplUnitTests                   │
   │ 19. SPEC_implProductCodes                           │
   │     Implements production code to pass tests        │
   │ 20. SPEC_reviewProductCodes                         │
   │     Reviews implementation quality; re-runs         │
   │     SPEC_reviewImplUnitTests before commit          │
   │     SPEC_refactUnitTests (optional) cleans one      │
   │     GREEN test, then review again                   │
   │                                                     │
   │     If review FAILS:                                │
   │ 21. SPEC_abortUserStory (when unsafe to continue)   │
   │     Moves the active story to abortUS for analysis  │
   └─────────────────────────────────────────────────────┘

   Suspend/resume is a global interrupt at any post-open,
   pre-close step:
   SPEC_suspendUserStory → suspendUS/ with durable resume ref
   SPEC_resumeUserStory  → back to doingUS/ and continue

22. SPEC_commitWorks
    Prepares and commits completed work

23. SPEC_closeUserStory
    Moves the reviewed, committed story from doingUS/ to doneUS/
    Moves the paired task artifact from doingUS/ to doneUS/

24. SPEC_mergeWorks (when a dedicated story branch was used)
    Merges the closed branch into the integration branch
    Skipped automatically when no story branch was created

SPEC_partialCloseUserStory splits an active story: the accepted
slice closes with traceability while the rejected/deferred slice
moves to abortUS/ with its reasons preserved.

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
    updateStory  takeDesign  designUnitTests
    reviewStory  reviewDesign impl/review tests
         │           │       impl/review code
         ▼           ▼           │
    commitWorks  commitWorks    │
    closeStory   closeStory     ▼
         │           │    SPEC_commitWorks
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

The 34 commands are easier to remember as six jobs: set context, bring work in, align intent, plan, design-and-gate, then implement-and-close.

```
   CONTEXT      SPEC_initProjectContext / SPEC_updateProjectContext
   INTAKE       SPEC_import* / SPEC_analyze*
   ALIGN        SPEC_clearStoryIntent
   PLAN         SPEC_makePlan  →  SPEC_whatsNextTask at any time
   DESIGN+GATE  SPEC_take*Design → SPEC_review*Design (never one without the other)
   DELIVER      SPEC_designUnitTests → SPEC_impl* → SPEC_review* → commit → close
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

**Why it matters**: without project context, every CodeAgent session starts from zero and re-derives your conventions — usually slightly differently each time. With it, the agent reads one file and knows the rules, the conventions, and the current state.

#### SPEC_analyzeIssue

**Purpose**: convert a raw issue or feature request into a traceable user story.

**What it does**:

1. Reads the pending issue/feature file from `pendingNews/`
2. Analyzes the input against project context and existing stories
3. Produces a structured user story in `todoUS/` containing role/capability/value, acceptance criteria candidates, a risk assessment, and open questions for the developer
4. Moves the raw input to `analyzedNews/` for traceability
5. Does **not** invent product intent — unclear aspects stay as open questions

**Output**: a user story file in `todoUS/` plus the archived raw input in `analyzedNews/`.

**CoT pattern**: ReACT — the command inspects current state, decides what to extract, acts by writing the story, and observes the result iteratively.

#### SPEC_makePlan

**Purpose**: create the execution plan for an opened user story.

**What it does**:

1. Reads the active story in `doingUS/`
2. Classifies the work as one of: **intent-clearing**, **requirement-oriented**, **design-oriented** (initial or follow-up), or **implementation-oriented**
3. Creates a `*-UserStory-Tasks.md` file with Markdown checkbox tasks
4. Decides the next SPEC command from that classification

**Output**: a task artifact in `doingUS/`.

**Why it matters**: this single classification is what stops teams from jumping to code on a story that first needed intent alignment or architecture. The most expensive mistake in the whole lifecycle is implementing the wrong scope correctly.

```
   SPEC_makePlan classifies, and the classification chooses the road:

   intent-clearing        → SPEC_clearStoryIntent
   requirement-oriented   → SPEC_updateUserStory → SPEC_reviewUserStory
   design-oriented        → SPEC_take*Design      → SPEC_review*Design
   implementation-oriented→ SPEC_designUnitTests  → P0/P1/P2 flows
```

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
- Creates `README_ArchDesign.md` and other architecture-oriented SPEC docs

**Detail Design** (`SPEC_takeDetailDesign`):

- Class-level API signatures and data structures
- State machines and lifecycle transitions
- Acceptance criteria for the active story
- Creates `README_DetailDesign.md` and other detail-oriented SPEC docs

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

#### SPEC_designUnitTests

**Purpose**: enter CaTDD test design mode, typically routing through the P0/P1/P2 flows.

**What it does**:

1. Determines the testing method (default: CaTDD)
2. Identifies which test categories the story and design need
3. Routes to the appropriate UT flow commands
4. May invoke `UT_designTypicalSkeleton`, `UT_designEdgeSkeleton`, and so on

**Testing method default**: CaTDD is the default UnitTesting method in SpecFlow. Typical TDD or another project-specific method may be used when the project explicitly requests it.

#### SPEC_commitWorks

**Purpose**: prepare and commit completed work with traceable commit messages.

**What it does**:

1. Reviews what changed: test files, production code, design docs, spec artifacts
2. Groups changes by story/concern
3. Drafts commit messages referencing US IDs
4. Commits with the appropriate scope
5. Does **not** push — pushing stays a separate developer action

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
| **High Performance** | Requirements analysis, intent alignment, planning, requirement updates, local design, review gates, test design, code review, correction routing, controlled patch-back | `SPEC_initProjectContext`, `SPEC_updateProjectContext`, `SPEC_analyzeIssue`, `SPEC_analyzeFeature`, `SPEC_analyzeAbortedUserStory`, `SPEC_clearStoryIntent`, `SPEC_makePlan`, `SPEC_updateUserStory`, `SPEC_whatsNextTask`, `SPEC_takeArchDesign`, `SPEC_reviewArchDesign`, `SPEC_updateArchDesign`, `SPEC_takeDetailDesign`, `SPEC_reviewDetailDesign`, `SPEC_updateDetailDesign`, `SPEC_reviewUserStory`, `SPEC_designUnitTests`, `SPEC_reviewImplUnitTests`, `SPEC_reviewProductCodes`, `SPEC_patchOriginalCaTDD` |
| **Flash Speed** | Deterministic import, move, suspend, resume, partial-close, abort, commit, close, or small test-driven implementation/refactor steps | `SPEC_importIssue`, `SPEC_importFeature`, `SPEC_importUserStory`, `SPEC_openUserStory`, `SPEC_suspendUserStory`, `SPEC_resumeUserStory`, `SPEC_partialCloseUserStory`, `SPEC_abortUserStory`, `SPEC_implUnitTests`, `SPEC_implProductCodes`, `SPEC_refactUnitTests`, `SPEC_commitWorks`, `SPEC_closeUserStory` |

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
| `README_VerifyDesign.md` | Verification topology, test strategy, US/AC/TC traceability | SpecFlow + UT flows |
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
4. **Invariants** — what must be preserved: CaTDD comment skeletons, US/AC/TC traceability, category labels, status markers
5. **Next** — what command should come next. Never leave the CodeAgent guessing

```
   invoke ──► preconditions ok? ──► perform ONE action ──► postconditions met?
                     │                                            │
                    no                                          yes
                     ▼                                            ▼
              stop and say what's missing              report + name the next command
```

This structure is why commands are reproducible. Every invocation of `UT_designTypicalSkeleton` produces a CaTDD Typical skeleton regardless of which CodeAgent runs it, because the contract defines the output precisely — not the tool, and not the model.

---

## Conflict Guard Rules

Px-SpecFlow defines seven guard rules so the layers cannot violate each other's boundaries:

1. **Px-SpecFlow defines lifecycle orchestration only** — CaTDD method semantics remain in methodPrompts.
2. **SPEC commands may call UT commands, but must not replace P0/P1/P2 category rules.**
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
| **autonomousMode** (opt-in) | Continuous CLI execution via `specCodeAgentCLI` or entry commands with `execution_mode: autonomousMode`. The agent auto-advances through safe steps using explicit file artifacts and records assumptions instead of stopping at every turn. |

**Safety boundary**: only implementation-oriented stories support `autonomousMode`. If autonomy is triggered on an intent-clearing, requirement-oriented, or design-oriented story, the flow must halt, force `manualMode`, and require developer confirmation. Requirements analysis and architecture design need human intent and trade-offs.

```
   autonomousMode allowed?
     implementation-oriented   →  yes
     requirement-oriented      →  no   → halt, force manualMode
     design-oriented           →  no   → halt, force manualMode
     intent-clearing           →  no   → halt, force manualMode
```

Command-level `analysis_mode` (`BRAINSTORM` default, or `AUTONOMOUS`) is a local setting inside `SPEC_analyzeIssue` / `SPEC_analyzeFeature`. It does not switch the flow into `autonomousMode`.

Every CaTDD command enforces the **ONE-MORE-THING** universal stop rule: ask the developer when something is not certain. In `manualMode`, the assistant stops and asks immediately. In `autonomousMode`, autonomy is never a license to guess — the run must halt, output `status: manual_required: ONE-MORE-THING: <question>`, and wait.

Autonomous runs terminate on exactly three outcomes:

```
   SPEC_closeUserStory   →  exit 0        (completed)
   SPEC_abortUserStory   →  non-zero exit (aborted)
   SPEC_suspendUserStory →  clean exit    (suspended)
```

---

## Command Invocation in Practice

The same command file is invoked differently depending on the CodeAgent.

### In Copilot Chat

```
/UT_designTypicalSkeleton
```

The Copilot prompt wrapper (generated by `scripts/makeSlashCmd4Copilot.sh`) adapts the portable Markdown command to Copilot's prompt format. You type the slash command, Copilot reads the adapted prompt, and executes the contract.

### In Cline/Continue

The command prompt file is read directly. You type the command name or select it from the assistant's command palette.

### In utCodeAgentCLI

```bash
utCodeAgentCLI --target myTestFile.ts --input spec/IOC.h --behave designTypicalSkeleton
```

The CLI maps `--behave` values to slash command behaviors. Aliases such as `reviewFuncTestsSkeleton` and `tellMeNextImplTest` resolve to their full UT command names.

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
| New component, no existing tests | P0-FuncTestsFlow → `UT_designTypicalSkeleton` |
| Existing demo code | P0-FuncTestsFlow → `UT_convertDemoToTypical` |
| Full functional test design | P0-FuncTestsFlow → `UT_designFuncTestsSkeleton` |
| Need architecture validation | P1-DesignTestsFlow (after P0 complete) |
| Need performance/capacity data | P2-QualityTestsFlow (after P0/P1 complete) |
| New feature request from product team | Px-SpecFlow → `SPEC_importFeature` → `SPEC_analyzeFeature` |
| Bug report from QA | Px-SpecFlow → `SPEC_importIssue` → `SPEC_analyzeIssue` |
| Already have a user story | Px-SpecFlow → `SPEC_importUserStory` → `SPEC_openUserStory` |
| Unsure what to do next | Px-SpecFlow → `SPEC_whatsNextTask` (reads current state and recommends the next action) |
| Resume a suspended story | Px-SpecFlow → `SPEC_resumeUserStory` (validates the durable resume reference) |
| Architecture decision needed | Px-SpecFlow → `SPEC_takeArchDesign` |
| Ready to code after design | Px-SpecFlow → `SPEC_designUnitTests` → P0/P1/P2 flow |
| Installed CaTDD harness looks broken | Px-HarnessKits → `HARNESS_verifyInstallation` → `HARNESS_diagnoseInstallation` |
| Reusable lesson from a verified run | Px-HarnessKits → `HARNESS_evolveHarness` |

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

The distinction is simple: **delegate intake, keep decisions.** Importing and analyzing produce an artifact you will review later. Designing, planning, and committing change what happens next.

---

## From Commands to Automation

Slash commands are the bridge between VibeCoding's conversational flexibility and CodeAgent automation. When a developer invokes `/UT_implTestCase`, a CodeAgent reads the command contract, applies the CaTDD method, and produces a structured output. When a developer invokes `/SPEC_analyzeIssue`, a CodeAgent reads the raw issue, converts it into a user story, and moves it through the lifecycle.

The next chapter, **asyncCodeAgent**, takes this one step further: instead of waiting for the developer to invoke each command, a CaTDD-native code agent plans, executes, collects traces, and reflects — automating the loop from a goal to a verified implementation.
