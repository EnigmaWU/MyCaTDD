# 06 beyondXyzSpec

## The Spec-Driven Development Landscape

The LLM era has produced three major open-source approaches to specification-driven development. They share a common belief — **spec before code** — but differ fundamentally in what they center on and where they stop.

| | GitHub Spec Kit | OpenSpec | CaTDD Px-SpecFlow |
|---|---|---|---|
| **Centers on** | Documents (`spec.md`, `plan.md`) | Changes (`openspec/changes/`) | **User Stories** (US lifecycle) |
| **Stars** | 111k | 54k | — |
| **CLI** | Python (`specify`) | TypeScript/Node.js (`openspec`) | Markdown prompt commands (agent-agnostic) |
| **Agent integrations** | 30+ | 25+ | Copilot, Cline, Continue, utCodeAgentCLI |
| **Testing methodology** | Not embedded | Not embedded | **Embedded** — UT P0/P1/P2 with TDD |

This chapter examines all three, and explains why CaTDD's dual-flow architecture — SPEC lifecycle + UT verification — goes beyond what standalone spec-driven tools can offer.

---

## GitHub Spec Kit — Document-Centric Spec-Driven Development

GitHub Spec Kit (111k stars, `github/spec-kit`) is a Python-based toolkit that structures development around four core documents:

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

- **Extensions & Presets**: Customize or extend the workflow. Extensions add new commands (e.g., Jira integration). Presets override templates (e.g., compliance formats, domain terminology). Project-local overrides in `.specify/templates/overrides/` take highest priority.
- **Installation**: `uv tool install specify-cli`, then `specify init <project> --integration copilot`
- **Parallel task execution**: Tasks marked `[P]` run concurrently. Tasks without `[P]` respect dependency ordering.

### Where Spec Kit Stops

Spec Kit is a **spec-to-tasks pipeline**. It tells you what to build and in what order, but it does not tell you how to verify correctness beyond generic checklists. The `/speckit.checklist` command generates quality validation items, but there is no embedded testing methodology, no US/AC/TC traceability chain, no TDD discipline, and no verification status tracking. Once `/speckit.implement` runs, the spec's job is done — the spec does not live on as a verifiable living artifact.

---

## What CaTDD Adopted from Spec Kit

CaTDD's Px-SpecFlow explicitly documents six refinements adopted from Spec Kit, each adapted to the CaTDD methodology:

| Spec Kit Concept | CaTDD Adoption |
|---|---|
| Constitution governs all decisions | `.catdd/spec/projectContext.md` as shared guardrail — `SPEC_initProjectContext` records stable principles, constraints, and team conventions before story work begins |
| Prioritized, independently testable user stories | `SPEC_analyzeIssue` produces stories with actor, value, priority, independent-test intent, acceptance scenarios, edge cases, risks, and open questions — structured for testability from analysis |
| Clear intent before design | `SPEC_clearStoryIntent` records a **Mutual Intent Contract** after `SPEC_openUserStory`: developer intent, CodeAgent intent, scope, non-goals, success signal, assumptions, open questions |
| Separate WHAT from HOW | `SPEC_makePlan` creates a paired `*-TASKs.md` artifact that classifies work as intent-clearing, requirement-oriented, design-oriented, or implementation-oriented — technical choices land in project-root `README*` SPEC docs |
| Clarify/analyze before code | `SPEC_reviewArchDesign` and `SPEC_reviewDetailDesign` gate design quality; failed reviews route to `SPEC_update*Design` before downstream work |
| Explicit, parallel-aware execution slices | US/AC/TC slices with P0-first ordering, independent work marked for parallel execution |

CaTDD adopted Spec Kit's structural wisdom but embedded it into a user-story-centered lifecycle with an integrated verification engine.

---

## OpenSpec — Change-Centric Spec-Driven Development

OpenSpec (54k stars, `Fission-AI/OpenSpec`) is a TypeScript-based tool built on a different philosophy: **fluid not rigid, iterative not waterfall, easy not complex, built for brownfield not just greenfield**.

### Architecture

OpenSpec organizes work around **changes** — self-contained folders in `openspec/changes/`. Each change is a proposal for something to build or modify:

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

**Expanded workflow** (additional 6 commands):
```
/opsx:new          — Create a new change with guiding context
/opsx:continue     — Resume work on the active change
/opsx:ff           — Fast-forward through quick tasks
/opsx:verify       — Verify implementation against specs
/opsx:bulk-archive — Archive multiple completed changes at once
/opsx:onboard      — Walk through the system with guided exploration
```

### Key Capabilities

- **Change folder isolation**: Each change lives in its own folder. No cross-contamination between features. Changes are self-contained and independently archivable.
- **Dashboard**: Visual overview of all changes, their status, and relationships.
- **Brownfield-first**: Designed for existing codebases, not just greenfield projects. You propose changes to what already exists.
- **Installation**: `npm install -g @fission-ai/openspec`, then `openspec init`
- **Self-comparison**: "vs Spec Kit — Thorough but heavyweight. Rigid phase gates. OpenSpec is lighter and lets you iterate freely."

### Where OpenSpec Stops

OpenSpec is a **change management system** with lightweight spec scaffolding. Each change has a proposal, specs, design, and tasks. But like Spec Kit, it stops at implementation — there is no embedded testing methodology, no US/AC/TC traceability, and no verification lifecycle. The spec describes what to change; it does not define how to prove the change is correct. A change is "done" when archived — there is no RED→GREEN test status driving closure.

---

## CaTDD Px-SpecFlow — User-Story-Centered SpecCoding

CaTDD Px-SpecFlow is neither document-centric nor change-centric. It is **user-story-centered**. The user story is the central lifecycle artifact. Every SPEC command serves the story's journey from incoming work to verified, reviewed, committed closure.

### The Story Lifecycle

```
pendingNews/  →  todoUS/  →  doingUS/  →  abortUS/ or doneUS/
 (raw input)    (analyzed)   (active)      (preserved)  (completed)
```

Six lifecycle states, each in a version-controlled directory under `.catdd/spec/`:

| State | Directory | Meaning |
|---|---|---|
| **pendingNews** | `pendingNews/` | Raw issues, features, or imported user stories waiting for analysis |
| **analyzedNews** | `analyzedNews/` | Raw inputs preserved as source trace after analysis |
| **todoUS** | `todoUS/` | Analyzed user stories ready to be opened for work |
| **doingUS** | `doingUS/` | Active user stories under design, test, or implementation |
| **abortUS** | `abortUS/` | Aborted stories preserved for later re-analysis or improvement |
| **doneUS** | `doneUS/` | Completed stories after review, commit, and CI |

### The SPEC Command Family

Px-SpecFlow provides 21 SPEC commands organized into three lifecycle phases:

**Phase A — Pre-Story: Input & Analysis**
```
SPEC_initProjectContext     → .catdd/spec/projectContext.md (shared constitution)
SPEC_updateProjectContext   → Update project context
SPEC_importIssue            → Raw issue → pendingNews/
SPEC_importFeature          → Raw feature → pendingNews/
SPEC_importUserStory        → Structured US → todoUS/ (skip analysis)
SPEC_analyzeIssue           → pending input → user story in todoUS/ + archive in analyzedNews/
SPEC_analyzeFeature         → pending input → user story in todoUS/ + archive in analyzedNews/
SPEC_openUserStory          → Move selected story from todoUS/ to doingUS/ (work begins)
```

**Phase B — Design & Planning**
```
SPEC_clearStoryIntent       → Align developer + CodeAgent intent (Mutual Intent Contract)
SPEC_makePlan               → Classify work orientation, create *-TASKs.md, pick next command
SPEC_updateUserStory        → Update module README_UserStory.md + README_UserGuide.md
SPEC_reviewUserStory        → Gate requirement quality before downstream work
SPEC_takeArchDesign         → Initial architecture design (README_ArchDesign.md + 7 more)
SPEC_reviewArchDesign       → Gate architecture quality
SPEC_updateArchDesign       → Follow-up architecture revision
SPEC_takeDetailDesign       → Initial detail design (README_DetailDesign.md + README_StateDesign.md)
SPEC_reviewDetailDesign     → Gate detail design quality
SPEC_updateDetailDesign     → Follow-up detail design revision
```

**Phase C — Implementation & Closure**
```
SPEC_designUnitTests        → Enter CaTDD test design (routes to P0/P1/P2 UT flows)
SPEC_implUnitTests          → Implement test cases (RED→GREEN via UT commands)
SPEC_implProductCodes       → Implement production code to pass tests
SPEC_reviewProductCodes     → Review implementation quality
SPEC_refactorIssue          → Route quality failures back to design/tests/code
SPEC_abortUserStory         → Abort active story → abortUS/ (preserved for re-analysis)
SPEC_commitWorks            → Prepare and commit completed work
SPEC_closeUserStory         → Move reviewed, committed story to doneUS/
```

### What Makes CaTDD Different

Px-SpecFlow's innovations go beyond what Spec Kit or OpenSpec offer:

**1. User-story-centered, not document-centered or change-centered.** Spec Kit centers on `spec.md`/`plan.md`/`tasks.md` — documents. OpenSpec centers on `changes/` — proposal folders. CaTDD centers on the **user story itself** as a living artifact that moves through six lifecycle states. Every SPEC command serves the story's journey. The story has explicit existence from raw import through analyzed todo, active doing, potential abort, or final closure.

**2. Mutual Intent Contract.** Neither Spec Kit nor OpenSpec has a mechanism for aligning human and LLM intent before design begins. CaTDD's `SPEC_clearStoryIntent` records a contract: what the developer thinks the story is about, what the CodeAgent infers, in-scope work, out-of-scope work, success signal, assumptions, and open questions. Design does not proceed until intent is aligned.

**3. `SPEC_abortUserStory` — explicit failure preservation.** When an active story has a blocking scope problem, invalid assumptions, or a quality issue that should not be patched in place, CaTDD aborts the story into `abortUS/` as preserved history. The abort lifecycle feeds back into `SPEC_analyzeUserStory` or `SPEC_importIssue` for deliberate re-analysis. Neither Spec Kit nor OpenSpec has an explicit abort-and-preserve path.

**4. `SPEC_makePlan` — work orientation classification.** Before any downstream work, `SPEC_makePlan` classifies the story into one of four orientations: intent-clearing, requirement-oriented, design-oriented, or implementation-oriented. It distinguishes initial design (`SPEC_take*Design`) from follow-up revision (`SPEC_update*Design`). It creates a paired `*-TASKs.md` artifact with Markdown checkbox tasks showing the next required steps.

**5. Project-root README SPEC docs.** CaTDD manages 11 project-root architecture/detail document types, each with a clear purpose and owner:

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

These are not templates dumped at initialization — they are created on demand by SPEC commands only when the project needs that surface.

**6. Model tier guidance per command.** Every SPEC command is assigned a model tier — SOTA reasoning for architecture decisions, High Performance for multi-artifact reasoning and review, Flash Speed for deterministic lifecycle movements. This prevents overpaying for compute on simple tasks and under-investing on architecture-significant decisions.

---

## The UT Flow — CaTDD's Embedded Verification Engine

This is the defining differentiator. **Neither Spec Kit nor OpenSpec has a testing methodology.** They describe what to build and in what order. They stop at implementation. CaTDD goes further: it embeds an entire category-driven TDD methodology into the spec lifecycle.

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
                    Typical→Edge→Misuse→Fault  State→Cap→Concur   Perf→Robust→Compat→Config
                              │                   │                   │
                              ▼                   ▼                   ▼
                         UT_implTestCase (RED→GREEN cycle for each TC)
```

When `SPEC_designUnitTests` runs, it does not produce a generic "write tests" task. It routes into CaTDD's UT flows — P0 for functional verification, P1 for design-oriented tests, P2 for quality attributes. Each flow has its own command sequence, review gates, and Design Source Gate requirements.

### What the UT Flow Provides That No Other Spec Tool Does

**1. Category-driven test design.** 12 test categories, each with its own method prompt (`CaTDD_methodPrompt4Cat-*.md`), design skeleton contract, use-when/avoid-when rules, and common mistake checklist. A CodeAgent designing a Typical skeleton reads `4Cat-Typical.md` and knows exactly what patterns, vocabulary, and constraints to apply.

**2. US/AC/TC traceability embedded in the test file.** The specification DOES NOT live in a separate document. The User Story, Acceptance Criteria, and Test Case specifications live as structured comments in the same file as the test code. When the spec changes, the comment changes. When the comment changes, the LLM regenerates the test. There is no spec-code gap.

**3. Design Source Gate for P1 and P2.** Before any P1 or P2 skeleton can be drafted, the required project-root design document must exist:

| P1 Category | Required Source |
|---|---|
| State | `README_StateDesign.md` or `State Design` chapter in `README_ArchDesign.md` |
| Capability | `README_DetailDesign.md` |
| Concurrency | `README_ResourceDesign.md` |

If the design source is missing, the UT command **stops and asks the developer** — no guessing, no inventing architectural decisions.

**4. TDD RED→GREEN discipline integrated into the lifecycle.** Every test case has a status marker:
```
⚪ TODO/PLANNED  →  🔴 RED/FAILING  →  🟢 GREEN/PASSED
```
The `SPEC_implUnitTests` command invokes `UT_implTestCase`, which follows the strict cycle: write test (RED), implement minimal production code (GREEN), review (TRACE). The story cannot close until all required TCs are GREEN.

**5. Quality gates at every level.** You do not advance from P0 to P1 until all P0 tests are GREEN. You do not advance from P1 to P2 until architecture is validated (no deadlocks, no race conditions, ThreadSanitizer clean). Each gate is a checkpoint where the developer reviews and approves before proceeding.

---

## Three-Way Comparison

| Dimension | GitHub Spec Kit | OpenSpec | CaTDD Px-SpecFlow |
|---|---|---|---|
| **Center of gravity** | Documents (`spec.md`, `plan.md`) | Changes (`openspec/changes/`) | **User Stories** (lifecycle states) |
| **Lifecycle states** | 3 implicit (spec → plan → tasks) | 3 explicit (propose → apply → archive) | **6 explicit** (pending → analyzed → todo → doing → abort/done) |
| **Abort mechanism** | None (close issue/PR manually) | None (delete change folder manually) | **`SPEC_abortUserStory`** — preserved in `abortUS/` with re-analysis path |
| **Intent alignment** | Free-form clarification chat | Free-form conversation | **Mutual Intent Contract** (`SPEC_clearStoryIntent`) |
| **Testing methodology** | None embedded (checklist only) | None embedded | **Embedded CaTDD** — P0/P1/P2 UT flows with 12 categories |
| **Spec-code gap** | spec.md → plan.md → code (3 documents) | proposal.md → design.md → code (3 documents) | **No gap** — US/AC/TC comments live in same file as test code |
| **TDD integration** | Not present | Not present | **RED→GREEN cycle** with ⚪→🔴→🟢 status markers |
| **Comment-alive design** | No — docs separate from code | No — docs separate from code | **Yes** — design skeleton lives in test file |
| **Priority framework** | None | None | **P0(core)→P1(design)→P2(quality)→P3(addons)** |
| **Design source gate** | None | None | **Yes** — P1/P2 require confirmed README_* docs |
| **Model tier guidance** | Not present | Recommends high-reasoning models | **Per-command tier mapping** (SOTA/HighPerf/Flash) |
| **Review gates** | `/speckit.analyze` (cross-artifact) | `/opsx:verify` (post-implementation) | **Arch→Detail→Story→Test→Code→Commit** (6 review gates) |
| **Artifact persistence** | File system (specs directory) | File system (changes directory) | **Team-shared `.catdd/spec/` with commit policy per artifact** |
| **Project-root docs** | Spec + plan, then manual | Proposal + design, then manual | **11 README* SPEC doc types** created on demand via SPEC commands |
| **Brownfield** | Primarily greenfield | **Brownfield-first** (designed for existing codebases) | **Both** — analyze existing code into US/AC/TC |
| **Install method** | `uv tool install specify-cli` (Python) | `npm install -g @fission-ai/openspec` (TypeScript) | Markdown prompt files (agent-agnostic) |
| **Agent integrations** | 30+ | 25+ | Copilot, Cline, Continue, utCodeAgentCLI |
| **Customization** | Extensions + presets + overrides | Community schemas | `methodPrompts/` as source of truth, `slashCommands/` as command layer, `agentSkills/` as packages |

---

## Why CaTDD Is BEYOND

Spec Kit and OpenSpec are valuable tools. They solve the spec-first problem. But they solve only half of it.

**Spec Kit** gives you a structured pipeline: constitution → spec → plan → tasks → implement. It tells you what to build, in what order, with what technology. But when implementation is done, you have code — without systematic proof that it's correct beyond a checklist.

**OpenSpec** gives you fluid change management: propose → apply → archive. It tells you what changed, what the design is, and what tasks to run. But when archived, you have a completed change — without embedded verification that the change satisfies its own acceptance criteria.

**CaTDD Px-SpecFlow** gives you both — and goes further:

1. **It manages user stories through their full lifecycle**, from raw import to verified closure, with an explicit abort path for when scope or assumptions are wrong.

2. **It aligns human and LLM intent before design begins**, preventing the most expensive mistake in LLM-driven development: building the wrong thing perfectly.

3. **It embeds a complete testing methodology (UT P0/P1/P2)** into the spec lifecycle. Every user story's acceptance criteria are verified by category-driven test cases. Every test case drives a RED→GREEN TDD cycle. Every GREEN test proves one piece of the story is correct.

4. **It eliminates the spec-code gap.** The specification lives as structured comments (`@[US]`, `@[AC]`, `@[TC]`) in the same file as the test code. When the code changes, the comment changes. When the comment changes, the test changes. The spec and the verification are inseparable.

5. **It classifies verification by domain significance.** P0 tests your Core Domain (what makes your business unique). P1 tests your architecture. P2 tests your quality attributes. This is DDD's strategic design applied to verification — it tells the LLM not just "test this" but "test this because it's core to the business."

### The Spec-Driven Stack

Think of them as layers of a spec-driven development stack:

```
┌────────────────────────────────────────────────┐
│  CaTDD Px-SpecFlow + UT flows                   │
│  "Prove it's correct"                           │
│  User-story lifecycle + embedded TDD            │
├────────────────────────────────────────────────┤
│  Spec Kit / OpenSpec                            │
│  "Decide what to build & how"                   │
│  Document-centric or change-centric             │
├────────────────────────────────────────────────┤
│  AI Coding Agents (Copilot, Cline, Claude, ...) │
│  "Generate the code"                            │
└────────────────────────────────────────────────┘
```

Spec Kit and OpenSpec operate at the middle layer — they structure what to build. CaTDD operates at the top layer — it verifies that what was built is correct. They are not competitors. They are complementary.

But if you can only have one, and you must choose between "knowing what to build" and "knowing that what you built is correct" — CaTDD gives you the verification guarantee that no spec-first tool alone can provide.

> **Comments is Verification Design. LLM Generates Code. Iterate Forward Together.**
