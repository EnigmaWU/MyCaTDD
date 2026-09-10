# 06 beyondXyzSpec

## The Spec-Driven Development Landscape

The LLM era produced three major open-source approaches to specification-driven development. All three believe in **spec before code**. They differ in what they put at the center — and in where they stop.

| | GitHub Spec Kit | OpenSpec | CaTDD Px-SpecFlow |
|---|---|---|---|
| **Centers on** | Documents (`spec.md`, `plan.md`) | Changes (`openspec/changes/`) | **User Stories** (US lifecycle) |
| **Stars** | 111k | 54k | — |
| **CLI** | Python (`specify`) | TypeScript/Node.js (`openspec`) | Markdown prompt commands (agent-agnostic) |
| **Agent integrations** | 30+ | 25+ | Copilot, Cline, Continue, utCodeAgentCLI |
| **Testing methodology** | Not embedded | Not embedded | **Embedded** — UT P0/P1/P2 with TDD |

```
   Spec Kit    centers on documents   spec.md → plan.md → tasks.md
   OpenSpec    centers on changes     changes/<change-name>/
   CaTDD       centers on the story   pendingNews → todoUS → doingUS → doneUS
```

This chapter examines all three, then explains why CaTDD's dual-flow architecture — SPEC lifecycle plus UT verification — goes beyond what standalone spec-driven tools can offer.

---

## GitHub Spec Kit — Document-Centric Spec-Driven Development

GitHub Spec Kit (111k stars, `github/spec-kit`) is a Python toolkit that structures development around four core documents:

```
constitution.md  →  spec.md  →  plan.md  →  tasks.md  →  implement
```

### Architecture

| Artifact | Location | What It Holds |
|---|---|---|
| **Constitution** | `.specify/memory/constitution.md` | Project principles, quality standards, governance rules |
| **Spec** | `specs/001-feature/spec.md` | WHAT & WHY — user stories, functional requirements |
| **Plan** | `specs/001-feature/plan.md` | HOW — tech stack, architecture, implementation decisions |
| **Tasks** | `specs/001-feature/tasks.md` | Executable task list with dependencies and `[P]` parallel markers |

```
   .specify/memory/constitution.md     rules for every decision
   specs/001-feature/spec.md           what and why
   specs/001-feature/plan.md           how
   specs/001-feature/tasks.md          in what order
```

### Command Flow

```
/speckit.constitution   — Create project governing principles
/speckit.specify        — Define WHAT to build (requirements, user stories)
/speckit.clarify        — Clarify underspecified areas (required before plan)
/speckit.plan           — Define HOW to build (tech stack, architecture)
/speckit.tasks          — Break plan into actionable tasks with dependencies
/speckit.analyze        — Cross-artifact consistency & coverage analysis
/speckit.checklist      — Generate quality checklists ("unit tests for English")
/speckit.implement      — Execute all tasks to build the feature
```

### Key Capabilities

- **Extensions & Presets** — customize or extend the workflow. Extensions add new commands (for example a Jira integration). Presets override templates (compliance formats, domain terminology). Project-local overrides in `.specify/templates/overrides/` take highest priority.
- **Installation** — `uv tool install specify-cli`, then `specify init <project> --integration copilot`
- **Parallel task execution** — tasks marked `[P]` run concurrently; tasks without `[P]` respect dependency ordering.

### Where Spec Kit Stops

Spec Kit is a **spec-to-tasks pipeline**. It tells you what to build and in what order. It does not tell you how to verify correctness beyond generic checklists.

```
   constitution → spec → plan → tasks → implement → code
                                                      ▲
                                                      └── the spec's job ends here
```

`/speckit.checklist` generates quality validation items, but there is no embedded testing methodology, no US/AC/TC traceability chain, no TDD discipline, and no verification status tracking. Once `/speckit.implement` runs, the spec does not live on as a verifiable living artifact.

---

## What CaTDD Adopted from Spec Kit

Px-SpecFlow explicitly documents six refinements adopted from Spec Kit, each adapted to the CaTDD method:

| Spec Kit Concept | CaTDD Adoption |
|---|---|
| Constitution governs all decisions | `.catdd/spec/projectContext.md` as a shared guardrail — `SPEC_initProjectContext` records stable principles, constraints, and team conventions before story work begins |
| Prioritized, independently testable user stories | `SPEC_analyzeIssue` produces stories with actor, value, priority, independent-test intent, acceptance scenarios, edge cases, risks, and open questions — structured for testability from analysis |
| Clear intent before design | `SPEC_clearStoryIntent` records a **Mutual Intent Contract** after `SPEC_openUserStory`: developer intent, CodeAgent intent, scope, non-goals, success signal, assumptions, open questions |
| Separate WHAT from HOW | `SPEC_makePlan` creates a paired `*-TASKs.md` artifact that classifies work as intent-clearing, requirement-oriented, design-oriented, or implementation-oriented — technical choices land in project-root `README*` SPEC docs |
| Clarify/analyze before code | `SPEC_reviewArchDesign` and `SPEC_reviewDetailDesign` gate design quality; failed reviews route to `SPEC_update*Design` before downstream work |
| Explicit, parallel-aware execution slices | US/AC/TC slices with P0-first ordering, independent work marked for parallel execution |

```
   Spec Kit idea                  CaTDD home
   ─────────────                  ──────────
   constitution            →      .catdd/spec/projectContext.md
   spec.md (what/why)      →      User Story + Acceptance Criteria
   plan.md (how)           →      README_* design docs
   tasks.md                →      *-UserStory-Tasks.md
```

CaTDD adopted Spec Kit's structural wisdom and embedded it in a user-story-centered lifecycle with an integrated verification engine.

---

## OpenSpec — Change-Centric Spec-Driven Development

OpenSpec (54k stars, `Fission-AI/OpenSpec`) is a TypeScript tool built on a different philosophy: **fluid not rigid, iterative not waterfall, easy not complex, built for brownfield not just greenfield**.

### Architecture

OpenSpec organizes work around **changes** — self-contained folders under `openspec/changes/`. Each change is a proposal for something to build or modify:

```
  openspec/changes/add-dark-mode/
  ├── proposal.md   — WHY we're doing this, WHAT is changing
  ├── specs/        — Requirements and scenarios
  ├── design.md     — Technical approach
  └── tasks.md      — Implementation checklist
```

### Command Flow

**Core workflow** (3 commands):

```
/opsx:propose "add-dark-mode"    — Creates proposal + specs + design + tasks in one step
/opsx:apply                       — Implements all tasks
/opsx:archive                     — Moves to archive, updates specs
```

**Expanded workflow** (6 more commands):

```
/opsx:new          — Create a new change with guiding context
/opsx:continue     — Resume work on the active change
/opsx:ff           — Fast-forward through quick tasks
/opsx:verify       — Verify implementation against specs
/opsx:bulk-archive — Archive multiple completed changes at once
/opsx:onboard      — Walk through the system with guided exploration
```

### Key Capabilities

- **Change folder isolation** — each change lives in its own folder, with no cross-contamination between features. Changes are self-contained and independently archivable.
- **Dashboard** — a visual overview of all changes, their status, and their relationships.
- **Brownfield-first** — designed for existing codebases, not just greenfield projects. You propose changes to what already exists.
- **Installation** — `npm install -g @fission-ai/openspec`, then `openspec init`
- **Self-comparison** — "vs Spec Kit — Thorough but heavyweight. Rigid phase gates. OpenSpec is lighter and lets you iterate freely."

### Where OpenSpec Stops

OpenSpec is a **change management system** with lightweight spec scaffolding. Each change has a proposal, specs, design, and tasks. Like Spec Kit, it stops at implementation.

```
   propose → apply → archive
                        ▲
                        └── "done" means archived, not verified
```

There is no embedded testing methodology, no US/AC/TC traceability, and no verification lifecycle. The spec describes what to change; it does not define how to prove the change is correct. A change is done when it is archived — there is no RED→GREEN test status driving closure.

---

## CaTDD Px-SpecFlow — User-Story-Centered SpecCoding

Px-SpecFlow is neither document-centric nor change-centric. It is **user-story-centered**. The user story is the central lifecycle artifact, and every SPEC command serves its journey from incoming work to verified, reviewed, committed closure.

### The Story Lifecycle

```
pendingNews/  →  analyzedNews/  →  todoUS/  →  doingUS/  →  doneUS/
 (raw input)    (input archive)  (analyzed)   (active)     (completed)
                                                ↘ suspendUS/ (paused, resumable)
                                                ↘ abortUS/ (preserved)
```

Seven lifecycle directories, all version-controlled under `.catdd/spec/`:

| State | Directory | Meaning |
|---|---|---|
| **pendingNews** | `pendingNews/` | Raw issues, features, or imported user stories waiting for analysis |
| **analyzedNews** | `analyzedNews/` | Raw inputs preserved as source trace after analysis |
| **todoUS** | `todoUS/` | Analyzed user stories ready to be opened for work |
| **doingUS** | `doingUS/` | Active user stories under design, test, or implementation |
| **suspendUS** | `suspendUS/` | Suspended active stories preserved with a durable resume reference (branch/worktree) |
| **abortUS** | `abortUS/` | Aborted stories preserved for later re-analysis or improvement |
| **doneUS** | `doneUS/` | Completed stories after review, commit, and CI |

### The SPEC Command Family

Px-SpecFlow provides **34 SPEC commands** in three lifecycle phases.

```
   PHASE A: pre-story        PHASE B: design & planning    PHASE C: implementation & closure
   import, analyze, open  →  intent, plan, design, review →  test, code, review, commit, close
```

**Phase A — Pre-Story: Input & Analysis**

```
SPEC_initProjectContext      → .catdd/spec/projectContext.md (shared constitution)
SPEC_updateProjectContext    → Update project context
SPEC_importIssue             → Raw issue → pendingNews/
SPEC_importFeature           → Raw feature → pendingNews/
SPEC_importUserStory         → Structured US → todoUS/ (skip analysis)
SPEC_analyzeIssue            → pending input → user story in todoUS/ + archive in analyzedNews/
SPEC_analyzeFeature          → pending input → user story in todoUS/ + archive in analyzedNews/
SPEC_analyzeAbortedUserStory → Selective re-analysis of an aborted story for a later round
SPEC_openUserStory           → Move selected story from todoUS/ to doingUS/ (work begins)
```

**Phase B — Design & Planning**

```
SPEC_clearStoryIntent        → Align developer + CodeAgent intent (Mutual Intent Contract)
SPEC_makePlan                → Classify work orientation, create *-UserStory-Tasks.md, pick next command
SPEC_updateUserStory         → Update module README_UserStory.md + README_UserGuide.md
SPEC_reviewUserStory         → Gate requirement quality before downstream work
SPEC_whatsNextTask           → Recommend the single next command from current state
SPEC_takeArchDesign          → Initial architecture design (README_ArchDesign.md + 7 more)
SPEC_reviewArchDesign        → Gate architecture quality
SPEC_updateArchDesign        → Follow-up architecture revision
SPEC_takeDetailDesign        → Initial detail design (README_DetailDesign.md + README_StateDesign.md)
SPEC_reviewDetailDesign      → Gate detail design quality
SPEC_updateDetailDesign      → Follow-up detail design revision
```

**Phase C — Implementation & Closure**

```
SPEC_designUnitTests         → Enter CaTDD test design (routes to P0/P1/P2 UT flows)
SPEC_implUnitTests           → Implement test cases (RED→GREEN via UT commands)
SPEC_reviewImplUnitTests     → Gate unit-test implementation before product code
SPEC_implProductCodes        → Implement production code to pass tests
SPEC_reviewProductCodes      → Review implementation quality
SPEC_refactUnitTests         → No-behavior-change cleanup of one GREEN unit test
SPEC_suspendUserStory        → Pause active story → suspendUS/ with resume reference
SPEC_resumeUserStory         → Move suspended story back to doingUS/ and continue
SPEC_partialCloseUserStory   → Close accepted scope, move rejected scope to abortUS/
SPEC_abortUserStory          → Abort active story → abortUS/ (preserved for re-analysis)
SPEC_commitWorks             → Prepare and commit completed work
SPEC_closeUserStory          → Move reviewed, committed story to doneUS/
SPEC_mergeWorks              → Merge a closed story branch when integration is still required
SPEC_patchOriginalCaTDD      → Patch installed-project CaTDD improvements back upstream
```

### What Makes CaTDD Different

Six things in Px-SpecFlow go beyond what Spec Kit or OpenSpec offer.

**1. User-story-centered, not document- or change-centered.** Spec Kit centers on `spec.md` / `plan.md` / `tasks.md` — documents. OpenSpec centers on `changes/` — proposal folders. CaTDD centers on the **user story itself** as a living artifact moving through seven lifecycle directories. The story has explicit existence from raw import, through analyzed archive, analyzed todo, active doing, possible suspend or abort, to final closure.

**2. Mutual Intent Contract.** Neither other tool aligns human and LLM intent before design begins. `SPEC_clearStoryIntent` records what the developer thinks the story is about, what the CodeAgent infers, in-scope work, out-of-scope work, the success signal, assumptions, and open questions. Design does not proceed until intent is aligned.

**3. `SPEC_abortUserStory` — explicit failure preservation.** When an active story has a blocking scope problem, invalid assumptions, or a quality issue that should not be patched in place, CaTDD aborts the story into `abortUS/` as preserved history. That feeds back into `SPEC_analyzeAbortedUserStory` or `SPEC_importIssue` for deliberate re-analysis. Neither Spec Kit nor OpenSpec has an explicit abort-and-preserve path.

```
   other tools:  bad story → delete the folder / close the issue
   CaTDD:        bad story → abortUS/ with reasons → re-analysis later
```

**4. `SPEC_makePlan` — work orientation classification.** Before any downstream work, `SPEC_makePlan` classifies the story as intent-clearing, requirement-oriented, design-oriented, or implementation-oriented. It distinguishes initial design (`SPEC_take*Design`) from follow-up revision (`SPEC_update*Design`), and it creates a paired `*-UserStory-Tasks.md` artifact with Markdown checkbox tasks showing the next required steps.

**5. Project-root README SPEC docs.** CaTDD manages 13 project-root README SPEC document types, grouped into architecture-oriented, detail-oriented, and general/requirements docs, each with a purpose and an owner:

| Architecture-Oriented | Detail-Oriented |
|---|---|
| `README_ArchDesign.md` — Module decomposition, dependencies, trade-offs | `README_DetailDesign.md` — Class design, API signatures |
| `README_UsageDesign.md` — Public boundaries, CLI/API contracts | `README_StateDesign.md` — State machines, lifecycle, concurrency |
| `README_ErrorDesign.md` — Fault-tolerance, fail-safe states | |
| `README_ResourceDesign.md` — Resource allocations, memory/CPU budgets | |
| `README_PerfDesign.md` — Performance budgets, latency limits | |
| `README_CompatDesign.md` — Compatibility matrices, platform versions | |
| `README_DiagnosisDesign.md` — Observability, logging, telemetry | |
| `README_VerifyDesign.md` — Verification topology, test strategy | |

Beyond those two groups, the general/requirements group holds `README.md` (project overview and master SPEC directories), `README_UserStories.md` (the mandatory project-level TODO/DONE story ledger with AC trace status), and `README_UserGuide.md` (user-facing usage guidance). The developer creates these first; `SPEC_updateUserStory` and `SPEC_reviewUserStory` update them later.

These are not templates dumped at initialization. SPEC commands create them on demand, only when the project needs that surface.

**6. Model tier guidance per command.** Every SPEC command carries a model tier — SOTA reasoning for architecture decisions, High Performance for multi-artifact reasoning and review, Flash Speed for deterministic lifecycle movements. That prevents overpaying for simple tasks and under-investing in architecture-significant ones.

---

## The UT Flow — CaTDD's Embedded Verification Engine

This is the defining differentiator. **Neither Spec Kit nor OpenSpec has a testing methodology.** They describe what to build and in what order, and they stop at implementation. CaTDD embeds a complete category-driven TDD methodology inside the spec lifecycle.

### The Dual-Flow Architecture

```
                        SPEC Flow (Px-SpecFlow)
                        User-story-centered lifecycle
                                │
                ┌───────────────┼───────────────┐
                ▼               ▼               ▼
          Pre-Story        Design & Plan     Implementation
        (import, analyze,  (intent, arch,    (test design,
         open)              detail)           impl, review)
                                                  │
                                                  ▼
                                          SPEC_designUnitTests
                                                  │
                              ┌───────────────────┼───────────────────┐
                              ▼                   ▼                   ▼
                         P0-FuncTestsFlow    P1-DesignTestsFlow   P2-QualityTestsFlow
                              │                   │                   │
                    Typical→Edge→Misuse→Fault  State→Cap→Interact  Perf→Robust→Compat→Config
                                               →Concur             →Diagnosis→Security
                              │                   ▼                   ▼
                              └──────► UT_implTestCase (RED→GREEN cycle for each TC)
```

When `SPEC_designUnitTests` runs, it does not produce a generic "write tests" task. It routes into the UT flows: P0 for functional verification, P1 for design-oriented tests, P2 for quality attributes. Each flow has its own command sequence, review gates, and Design Source Gate requirements.

Interaction (P1) and Diagnosis (P2) currently have no dedicated `UT_design*Skeleton` commands. Their flows route directly through the matching `CaTDD_methodPrompt4Cat-*.md` method prompts, drafting source-linked US/AC/TC into the canonical category files under the same Discovery Gate and review contract. Security (P2) does have one — `UT_designSecuritySkeleton`, gated on project-root `README_SecurityDesign.md` and constitutional invariants ($K$). Beside these lifecycle flows, `slashCommands` also carries an operational `HARNESS_*` family (`Px-HarnessKits`) for harness maintenance — and it never moves SpecFlow lifecycle state.

### What the UT Flow Provides That No Other Spec Tool Does

**1. Category-driven test design.** 15 test categories, each with its own method prompt (`CaTDD_methodPrompt4Cat-*.md`) defining its position, use-when/avoid-when routing rules, test-point probes, a design skeleton contract, and a checklist; most prompts also carry naming examples and common-mistake guidance. A CodeAgent designing a Typical skeleton reads `CaTDD_methodPrompt4Cat-Typical.md` and knows exactly which patterns, vocabulary, and constraints apply.

**2. US/AC/TC traceability embedded in the test file.** The specification does not live in a separate document. User Story, Acceptance Criteria, and Test Case specifications live as structured comments in the same file as the test code. When the spec changes, the comment changes. When the comment changes, the LLM regenerates the test.

```
   other tools:   spec.md  ──(hope)──►  code
   CaTDD:         US/AC/TC comments + TEST code in one file, adjacent and in sync
```

**3. Design Source Gate for P1 and P2.** Before any P1 or P2 skeleton can be drafted, the required project-root design document must exist:

| P1 Category | Required Source |
|---|---|
| State | `README_StateDesign.md` or `State Design` chapter in `README_ArchDesign.md` |
| Capability | `README_DetailDesign.md` |
| Interaction | Sequence, interaction, or collaboration sections in `README_ArchDesign.md` |
| Concurrency | `README_ResourceDesign.md` |

| P2 Category | Required Source |
|---|---|
| Performance | `README_PerfDesign.md` |
| Robust | `README_ErrorDesign.md` |
| Compatibility | `README_CompatDesign.md` |
| Configuration | `README_DetailDesign.md` |
| Diagnosis | `README_DiagnosisDesign.md` / `README_VerifyDesign.md` evidence requirements |
| Security | `README_SecurityDesign.md` (+ threat model, security policy, or constitutional invariants ($K$)) |

If the design source is missing, the UT command — or the direct method-prompt route — **stops and asks the developer**. No guessing, no inventing architectural decisions inside a test file.

**4. TDD RED→GREEN discipline integrated into the lifecycle.** Every test case has a status marker:

```
⚪ TODO/PLANNED  →  🔴 RED/FAILING  →  🟢 GREEN/PASSED
```

`SPEC_implUnitTests` invokes `UT_implTestCase`, which follows the strict cycle: write the test (RED), implement minimal production code (GREEN), review (TRACE). The story cannot close until all required TCs are GREEN.

**5. Quality gates at every level.** You do not advance from P0 to P1 until all P0 tests are GREEN. You do not advance from P1 to P2 until the architecture is validated: no deadlocks, no race conditions, ThreadSanitizer clean. Each gate is a checkpoint where the developer reviews and approves before the work proceeds.

---

## Three-Way Comparison

| Dimension | GitHub Spec Kit | OpenSpec | CaTDD Px-SpecFlow |
|---|---|---|---|
| **Center of gravity** | Documents (`spec.md`, `plan.md`) | Changes (`openspec/changes/`) | **User Stories** (lifecycle states) |
| **Lifecycle states** | 3 implicit (spec → plan → tasks) | 3 explicit (propose → apply → archive) | **7 explicit** (pending → analyzed → todo → doing → suspend/abort → done) |
| **Abort mechanism** | None (close issue/PR manually) | None (delete change folder manually) | **`SPEC_abortUserStory`** — preserved in `abortUS/` with a re-analysis path |
| **Intent alignment** | Free-form clarification chat | Free-form conversation | **Mutual Intent Contract** (`SPEC_clearStoryIntent`) |
| **Testing methodology** | None embedded (checklist only) | None embedded | **Embedded CaTDD** — P0/P1/P2 UT flows with 15 categories |
| **Spec-code gap** | spec.md → plan.md → code (3 documents) | proposal.md → design.md → code (3 documents) | **No gap** — US/AC/TC comments live in the same file as the test code |
| **TDD integration** | Not present | Not present | **RED→GREEN cycle** with ⚪→🔴→🟢 status markers |
| **Comment-alive design** | No — docs separate from code | No — docs separate from code | **Yes** — the design skeleton lives in the test file |
| **Priority framework** | None | None | **P0(core) → P1(design) → P2(quality) → P3(addons)** |
| **Design source gate** | None | None | **Yes** — P1/P2 require confirmed `README_*` docs |
| **Model tier guidance** | Not present | Recommends high-reasoning models | **Per-command tier mapping** (SOTA / HighPerf / Flash) |
| **Review gates** | `/speckit.analyze` (cross-artifact) | `/opsx:verify` (post-implementation) | **Arch → Detail → Story → Test → Code → Commit** (6 review gates) |
| **Artifact persistence** | File system (specs directory) | File system (changes directory) | **Team-shared `.catdd/spec/`** with a commit policy per artifact |
| **Project-root docs** | Spec + plan, then manual | Proposal + design, then manual | **13 README* SPEC doc types** created on demand by SPEC commands |
| **Brownfield** | Primarily greenfield | **Brownfield-first** (designed for existing codebases) | **Both** — analyze existing code into US/AC/TC |
| **Install method** | `uv tool install specify-cli` (Python) | `npm install -g @fission-ai/openspec` (TypeScript) | Markdown prompt files (agent-agnostic) |
| **Agent integrations** | 30+ | 25+ | Copilot, Cline, Continue, utCodeAgentCLI |
| **Customization** | Extensions + presets + overrides | Community schemas | `methodPrompts/` as source of truth, `slashCommands/` as command layer, `agentSkills/` as packages |

---

## Why CaTDD Is BEYOND

Spec Kit and OpenSpec are valuable tools. They solve the spec-first problem — but only half of it.

**Spec Kit** gives you a structured pipeline: constitution → spec → plan → tasks → implement. It tells you what to build, in what order, with what technology. When implementation ends, you have code — without systematic proof that it is correct beyond a checklist.

**OpenSpec** gives you fluid change management: propose → apply → archive. It tells you what changed, what the design is, and what tasks to run. When the change is archived, you have completed work — without embedded verification that it satisfies its own acceptance criteria.

### One bug, three tools

Here is the same defect seen through each tool. QA reports: *"IOC_post returns success on a destroyed handle."*

```
   Spec Kit   →  tells you which document the fix belongs to,
                 and which task to add to tasks.md

   OpenSpec   →  tells you which change folder to create,
                 and what the design says the behavior should be

   CaTDD      →  tells you which story this is, which AC it violates,
                 which TC proves the violation, and which gate the fix
                 must pass before the story can close
```

The first two answers are about **planning the change**. The third is about **proving the change** — and the proof survives the conversation, because it lives in the test file as US/AC/TC comments with a RED→GREEN history.

### What CaTDD adds

1. **It manages user stories through their full lifecycle**, from raw import to verified closure, with an explicit abort path for when scope or assumptions turn out wrong.
2. **It aligns human and LLM intent before design begins**, preventing the most expensive mistake in LLM-driven development: building the wrong thing perfectly.
3. **It embeds a complete testing methodology (UT P0/P1/P2)** in the spec lifecycle. Every story's acceptance criteria are verified by category-driven test cases. Every test case drives a RED→GREEN cycle. Every GREEN test proves one piece of the story is correct.
4. **It eliminates the spec-code gap.** The specification lives as structured comments (`@[US]`, `@[AC]`, `@[TC]`) in the same file as the test code. When the code changes, the comment changes; when the comment changes, the test changes. Spec and verification are inseparable.
5. **It classifies verification by domain significance.** P0 tests your Core Domain — what makes the business unique. P1 tests your architecture. P2 tests your quality attributes. That is DDD's strategic design applied to verification: the LLM is told not only *test this*, but *test this because it is core to the business*.

### The Spec-Driven Stack

Think of the three tools as layers of one stack:

```
   ┌──────────────────────────────────────────────────┐
   │  CaTDD Px-SpecFlow + UT flows                    │
   │  "Prove it's correct"                            │
   │  user-story lifecycle + embedded TDD             │
   ├──────────────────────────────────────────────────┤
   │  Spec Kit / OpenSpec                             │
   │  "Decide what to build and how"                  │
   │  document-centric or change-centric              │
   ├──────────────────────────────────────────────────┤
   │  AI Coding Agents (Copilot, Cline, Claude, ...)  │
   │  "Generate the code"                             │
   └──────────────────────────────────────────────────┘
```

Spec Kit and OpenSpec operate in the middle layer: they structure what to build. CaTDD operates at the top layer: it verifies that what was built is correct, and keeps the evidence in the artifact itself. They are not competitors — they are complementary.

But if you can only have one, and the choice is between knowing what to build and knowing that what you built is correct, CaTDD provides the verification guarantee that no spec-first tool alone can give you.

> **Comments is Verification Design. LLM Generates Code. Iterate Forward Together.**
