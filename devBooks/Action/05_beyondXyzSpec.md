# 05 beyondXyzSpec

## The Spec-Driven Development Landscape

This chapter compares three open-source approaches to specification-driven development. All emphasize **spec before code**, but differ in what they put at the center and how their workflows represent evidence.

## 5W1H at a Glance

| Question | Answer |
|---|---|
| **Who** | Teams choosing or combining specification-driven workflows |
| **What** | A comparison of document-, change-, and story-centered approaches with CaTDD verification |
| **When** | When selecting a workflow for new or existing software work |
| **Where** | Across specification artifacts, lifecycle commands, design sources, and verification evidence |
| **Why** | To distinguish planning a change from proving its behavior |
| **How** | Compare each workflow's center, lifecycle, evidence, and gates; verify CaTDD details against its canonical prompts |

For current CaTDD semantics, start with [CaTDD_methodPrompt.md](../../methodPrompts/CaTDD_methodPrompt.md), [CaTDD_methodPrompt-testPointDiscovery.md](../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md), [CaTDD_methodPrompt-testStructure.md](../../methodPrompts/CaTDD_methodPrompt-testStructure.md), and [CaTDD_methodPrompt-workflow.md](../../methodPrompts/CaTDD_methodPrompt-workflow.md). The command lifecycle lives in [Px-SpecFlow.md](../../slashCommands/flows/Px-SpecFlow.md); category routing lives in [P0-FuncTestsFlow.md](../../slashCommands/flows/P0-FuncTestsFlow.md), [P1-DesignTestsFlow.md](../../slashCommands/flows/P1-DesignTestsFlow.md), and [P2-QualityTestsFlow.md](../../slashCommands/flows/P2-QualityTestsFlow.md).

| | GitHub Spec Kit | OpenSpec | CaTDD Px-SpecFlow |
|---|---|---|---|
| **Centers on** | Documents (`spec.md`, `plan.md`) | Changes (`openspec/changes/`) | **User Stories** (US lifecycle) |
| **Workflow interface** | CLI and agent commands | CLI and agent commands | Portable Markdown command contracts with native adapters |
| **Verification method** | Select separately; do not infer a test method from the spec workflow | Select separately; do not infer a test method from the change workflow | **CaTDD** — source-first discovery, 15 categories, and evidence gates |

```
   Spec Kit    centers on documents   spec.md → plan.md → tasks.md
   OpenSpec    centers on changes     changes/<change-name>/
   CaTDD       centers on the story   pendingNews → todoUS → doingUS → doneUS
```

Tool features and integrations evolve; this chapter compares their workflow shapes rather than volatile popularity counts. It explains how CaTDD pairs its SPEC lifecycle with `TEST_*` verification flows without treating story planning as proof of correctness.

---

## GitHub Spec Kit — Document-Centric Spec-Driven Development

GitHub Spec Kit (`github/spec-kit`) is a toolkit that structures development around four core documents:

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
- **Installation** — use the current upstream installation guide for the target CLI and agent integration
- **Parallel task execution** — tasks marked `[P]` run concurrently; tasks without `[P]` respect dependency ordering.

### Where Spec Kit Stops

Spec Kit provides a **spec-to-tasks pipeline** and checklist tooling. It does not define CaTDD's source-backed discovery ledger, category semantics, test-scope statuses, or story-closure evidence contract; teams can pair it with their own verification method.

```
   constitution → spec → plan → tasks → implement → code
                                                      ▲
                                                      └── the spec's job ends here
```

`/speckit.checklist` generates quality validation items, but those are not CaTDD test cases and do not provide CaTDD's US/AC/TP/TC traceability or test-status semantics. Teams may run automated tests during implementation; the distinction here is that the Spec Kit workflow does not prescribe CaTDD's verification method.

---

## What CaTDD Adopted from Spec Kit

Px-SpecFlow explicitly documents six refinements adopted from Spec Kit, each adapted to the CaTDD method:

| Spec Kit Concept | CaTDD Adoption |
|---|---|
| Constitution governs all decisions | `.catdd/spec/projectContext.md` as a shared guardrail — `SPEC_initProjectContext` records stable principles, constraints, and team conventions before story work begins |
| Prioritized, independently testable user stories | `SPEC_analyzeIssue` produces stories with actor, value, priority, independent-test intent, acceptance scenarios, edge cases, risks, and open questions — structured for testability from analysis |
| Clear intent before design | `SPEC_clearStoryIntent` records a **Mutual Intent Contract** when developer and CodeAgent intent need alignment: scope, non-goals, success signal, assumptions, and open questions |
| Separate WHAT from HOW | `SPEC_makePlan` creates a paired `*-UserStory-Tasks.md` artifact with an append-only `## Trajectory`, classifies work orientation, and picks the next step — technical choices land in project-root `README*` SPEC docs |
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

OpenSpec (`Fission-AI/OpenSpec`) is a tool built on a different philosophy: **fluid not rigid, iterative not waterfall, easy not complex, built for brownfield not just greenfield**.

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
- **Installation** — use the current upstream installation guide for the target CLI and agent integration
- **Self-comparison** — "vs Spec Kit — Thorough but heavyweight. Rigid phase gates. OpenSpec is lighter and lets you iterate freely."

### Where OpenSpec Stops

OpenSpec is a **change management system** with lightweight spec scaffolding. Each change has a proposal, specs, design, and tasks, and its workflow includes a `verify` command. It does not define CaTDD's category-driven discovery, project-wide test traceability, or test-scope closure semantics.

```
   propose → apply → archive
                        ▲
                        └── archiving is a lifecycle action; verification is a separate workflow step
```

OpenSpec can verify a change, but its change lifecycle is distinct from CaTDD's source-first test-point discovery and US/AC/TP/TC evidence chain. A project's use of OpenSpec does not by itself establish the CaTDD statuses or completion conditions described below.

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
| **doneUS** | `doneUS/` | Stories that passed close gates; close-generated file changes require a post-close commit checkpoint |

### The SPEC Command Family

Px-SpecFlow provides SPEC commands across three lifecycle phases; command names and contracts are maintained in `slashCommands/`.

```
   PHASE A: pre-story        PHASE B: design & planning    PHASE C: implementation & closure
   import, analyze, open  →  intent, plan, design, review →  test, code, review, commit, close
```

**Phase A — Pre-Story: Input & Analysis**

```
SPEC_initProjectContext      → .catdd/spec/projectContext.md (shared project guardrails)
SPEC_updateProjectContext    → Update project context
SPEC_importIssue             → Raw issue → pendingNews/
SPEC_importFeature           → Raw feature → pendingNews/
SPEC_importUserStory         → Structured US → todoUS/ (skip analysis)
SPEC_analyzeIssue            → pending input → user story in todoUS/ + archived input with ## Chat History
SPEC_analyzeFeature          → pending input → user story in todoUS/ + archived input with ## Chat History
SPEC_analyzeAbortedUserStory → Selective re-analysis of an aborted story for a later round
SPEC_openUserStory           → Move selected story from todoUS/ to doingUS/ (work begins)
SPEC_commitPreStoryWorks     → Commit intake/analysis changes before a story is opened
```

**Phase B — Design & Planning**

```
SPEC_clearStoryIntent        → Align developer + CodeAgent intent (Mutual Intent Contract)
SPEC_makePlan                → Classify work orientation, create *-UserStory-Tasks.md, pick next command
SPEC_updateMadePlan          → Sync plan checkboxes; append-only Trajectory, sufficiency, and plan-drift updates
SPEC_updateUserStory         → Update project README_UserStories.md / README_UserGuide.md and module surfaces when used
SPEC_reviewUserStory         → Gate requirement quality before downstream work
SPEC_whatsNextTask           → Recommend the single next command from current state
SPEC_whatsWrong              → Freeze the flow and route an unresolved problem to its owning command
SPEC_takeArchDesign          → Initial architecture design (including README_UbiLang.md)
SPEC_reviewArchDesign        → Gate architecture quality
SPEC_updateArchDesign        → Follow-up architecture revision
SPEC_takeDetailDesign        → Initial detail and verification design as required
SPEC_reviewDetailDesign      → Gate detail design quality
SPEC_updateDetailDesign      → Follow-up detail design revision
```

**Phase C — Implementation & Closure**

```
SPEC_designTests             → Source-first discovery and P0-first category skeleton design
TEST_reviewFuncTestsSkeleton → Review P0 skeletons and cross-artifact semantic delta
SPEC_implTests               → Implement planned tests through matching TEST_* commands
SPEC_reviewImplTests         → Gate test implementation and its evidence
SPEC_implProductCodes        → Implement production code against verified test intent
SPEC_reviewProductCodes      → Review implementation against sources and test evidence
SPEC_refactTests             → No-behavior-change cleanup of eligible GREEN test cases
SPEC_commitStepWorks         → Commit a planned, verified story-step boundary
SPEC_commitStoryWorks        → Commit the story span or required post-close changes
SPEC_suspendUserStory        → Pause active story → suspendUS/ with resume reference
SPEC_resumeUserStory         → Move suspended story back to doingUS/ and continue
SPEC_partialCloseUserStory   → Close accepted scope, move rejected scope to abortUS/
SPEC_abortUserStory          → Abort active story → abortUS/ (preserved for re-analysis)
SPEC_closeUserStory          → Move reviewed, committed story to doneUS/
SPEC_mergeWorks              → Merge a closed story branch when integration is still required
SPEC_patchOriginalCaTDD      → Patch installed-project CaTDD improvements back upstream
```

### What Makes CaTDD Different

These CaTDD capabilities distinguish its workflow; equivalent behavior may be supplied by extensions or project conventions in other systems.

**1. User-story-centered, not document- or change-centered.** Spec Kit centers on `spec.md` / `plan.md` / `tasks.md` — documents. OpenSpec centers on `changes/` — proposal folders. CaTDD centers on the **user story itself** as a living artifact moving through seven lifecycle directories. The story has explicit existence from raw import, through analyzed archive, analyzed todo, active doing, possible suspend or abort, to final closure.

**2. Mutual Intent Contract.** `SPEC_clearStoryIntent` records what the developer thinks the story is about, what the CodeAgent infers, in-scope work, out-of-scope work, the success signal, assumptions, and open questions when intent needs alignment before planning or design.

**3. `SPEC_abortUserStory` — explicit failure preservation.** When an active story has a blocking scope problem, invalid assumptions, or a quality issue that should not be patched in place, CaTDD preserves it in `abortUS/`. That feeds back into `SPEC_analyzeAbortedUserStory` or `SPEC_importIssue` for deliberate re-analysis.

```
   issue/change workflows: follow their project-defined exception path
   CaTDD:                  bad story → abortUS/ with reasons → re-analysis
```

**4. `SPEC_makePlan` — work orientation classification.** Before any downstream work, `SPEC_makePlan` classifies the story as intent-clearing, requirement-oriented, design-oriented, or implementation-oriented. It distinguishes initial design (`SPEC_take*Design`) from follow-up revision (`SPEC_update*Design`), and it creates a paired `*-UserStory-Tasks.md` artifact with Markdown checkbox tasks showing the next required steps.

**5. Project-root README SPEC docs.** CaTDD maintains project-root README SPEC artifacts when the story requires them. The set is not a fixed checklist; it includes architecture, detailed design, verification, domain-language, requirement, and usage surfaces:

| Surface | Examples |
|---|---|
| Architecture and language | `README_ArchDesign.md`, `README_UbiLang.md`, `README_ArchVerifyDesign.md` |
| Detailed design and verification | `README_DetailDesign.md`, `README_DetailVerifyDesign.md`, `README_StateDesign.md` |
| Quality and operating concerns | `README_ErrorDesign.md`, `README_ResourceDesign.md`, `README_PerfDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, `README_SecurityDesign.md` |
| Requirements and usage | `README_UserStories.md`, `README_UserGuide.md`, module-level `README_UserStory.md` / `README_UserGuide.md` |

`README_VerifyDesign.md` is a routing index; it does not replace the architecture- or detail-level verification design. These are not templates dumped at initialization: SPEC commands create or revise the relevant surfaces as the accepted work requires.

**6. Model tier guidance.** Px-SpecFlow provides default tiers for command classes—SOTA reasoning for architecture decisions, High Performance for multi-artifact reasoning and review, and Flash Speed for deterministic lifecycle movements. Escalate when uncertainty or risk demands it.

---

## The TEST Flows — CaTDD's Embedded Verification Method

CaTDD separates the SpecCoding lifecycle from category-level verification work. `SPEC_*` commands orchestrate story state and lifecycle gates; `TEST_*` commands and method prompts define category-level test design and implementation. Spec Kit and OpenSpec can be paired with testing tools, but they do not supply this repository's CaTDD contracts.

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
                                          SPEC_designTests
                                                  │
                              ┌───────────────────┼───────────────────┐
                              ▼                   ▼                   ▼
                         P0-FuncTestsFlow    P1-DesignTestsFlow   P2-QualityTestsFlow
                              │                   │                   │
                    Typical→Edge→Misuse→Fault  State→Cap→Interact  Perf→Robust→Compat→Config
                                               →Concur             →Diagnosis→Security
                              └───────────────┬───────────────────┘
                                              ▼
                                    TEST_* implementation commands
                                    (scope-specific evidence)
                         P3 Addons: Demo / Example flows as applicable
```

`SPEC_designTests` performs source-first discovery and designs the P0 Functional skeleton set first. P1 or P2 promotion requires the applicable design-source evidence and explicit rationale; P3 is an add-on surface, not a substitute for functional verification. `SPEC_implTests` then uses the matching `TEST_*` contracts and execution flow.

Interaction (P1) and Diagnosis (P2) currently have no dedicated `TEST_design*Skeleton` commands. Their method prompts and flow discovery/review contracts still apply. Security (P2) has `TEST_designSecuritySkeleton`, which requires the relevant security design evidence. The separate `HARNESS_*` family maintains harnesses and does not move SpecFlow lifecycle state.

### What the CaTDD Verification Method Provides

**1. Category-driven test design.** CaTDD defines 15 categories across P0 Functional, P1 Design, P2 Quality, and P3 Addons. The category method prompts define their meaning and routing. Use matching `TEST_*` command contracts when they exist; where they do not, follow the method prompt and the flow's discovery/review contract. The prompts are the source of truth for category meaning.

**2. Source-first discovery and project-wide traceability.** Derive expected obligations from authoritative sources before consulting existing tests as coverage evidence. Maintain the `discovery_ledger` and evidence chain in the appropriate verification-design artifact, then connect source-backed Test Points to registered US and qualified AC/TP/TC IDs. Living test comments keep the relevant design close to executable evidence; they do not replace story, domain, or design sources.

```
   source artifacts → rule/invariant → TP → observable oracle → category
                     → registered US / qualified AC / TP / TC → test evidence
```

**3. Discovery and promotion gates.** `README_DetailVerifyDesign.md` owns the detail-level behavior inventory, `discovery_ledger`, and category strategy; `README_ArchVerifyDesign.md` owns system-composition verification strategy. `README_VerifyDesign.md` is only a routing index. P1/P2 promotion requires the relevant source-backed design, measurable oracle where applicable, and explicit category rationale—not merely the presence of a document.

If source or a human decision is missing, report `BLOCKED` or `ASK` through the review contract and route the gap to its owning command. A missing source is not proof that a category is inapplicable; do not invent design decisions inside a test file.

**4. Separate test level and runtime scope.** `TestLevel` is `UnitTesting`, `SysTesting`, or `UserTesting`; `TestScope` is `mockSysRtm` or `realSysRtm`. They describe different axes. Each tracked case records both scope results. Meaningful GREEN at `mockSysRtm` earns `CLOSED`; real-runtime evidence is reported separately and never substitutes for that closure.

```
@[Status]: mockSysRtm <marker> | realSysRtm <marker>
```

`BROKEN_TEST` is not RED: it indicates a test implementation or harness problem, not a product failure. Missing runtime equipment is an execution limitation, not automatically a design blocker; the procedure and evidence expectations still need to be designed.

**5. Review and story-completion gates.** Reviews report one canonical verdict—`PASS`, `REVISE`, `BLOCKED`, or `ASK`—with a rework route where required. P0 skeleton design is decided before P1/P2 promotion; promotion is source- and risk-driven, not a blanket rule to implement every category. Review commands reconcile semantic changes across artifacts and preserve the decision in the task `Trajectory`. `SPEC_closeUserStory` checks the story's own completion conditions, verification evidence, required documents, review/commit/CI evidence, and plan sufficiency. It does not assume that every possible TC or runtime scope must be green.

---

## Three-Way Comparison

| Dimension | GitHub Spec Kit | OpenSpec | CaTDD Px-SpecFlow |
|---|---|---|---|
| **Center of gravity** | Documents (`spec.md`, `plan.md`) | Changes (`openspec/changes/`) | **User Stories** (lifecycle states) |
| **Lifecycle shape** | Document pipeline (spec → plan → tasks) | Change workflow (propose → apply → verify → archive) | **7 lifecycle directories** (pending → analyzed → todo → doing → suspend/abort → done) |
| **Abort mechanism** | Use the host issue/PR workflow | Use the change workflow | **`SPEC_abortUserStory`** — preserves the story in `abortUS/` for re-analysis |
| **Intent alignment** | Clarification workflow | Iterative clarification | **Mutual Intent Contract** (`SPEC_clearStoryIntent`) |
| **Verification method** | Checklist and project-selected tests | `verify` command and project-selected tests | **CaTDD** — 15 categories, source-first discovery, and explicit status/evidence contracts |
| **Traceability** | Documents link requirements and plans | Change artifacts link proposal, specs, design, tasks | **Registered US + qualified AC/TP/TC IDs**, linked to source artifacts and the discovery ledger |
| **Living test design** | Project-selected | Project-selected | **Comment-alive skeletons** adjacent to test code; authoritative sources remain external artifacts |
| **TDD / status** | Project-selected | Project-selected | `mockSysRtm` GREEN earns `CLOSED`; `realSysRtm` evidence is separate |
| **Category framework** | Project-selected | Project-selected | **P0 Functional → P1 Design → P2 Quality → P3 Addons**; DDD subdomain type does not assign category |
| **Design source gate** | Project-selected | Project-selected | Source-backed discovery and applicable P1/P2 promotion gates |
| **Model tier guidance** | Tool/project dependent | Tool/project dependent | Per-command guidance in `Px-SpecFlow` |
| **Review gates** | Cross-artifact analysis and checklist tools | Change verification | Requirement, architecture, detail, test, and code reviews with canonical verdicts and owning rework routes |
| **Artifact persistence** | File system (specs directory) | File system (changes directory) | **Team-shared `.catdd/spec/`** with a commit policy per artifact |
| **Project-root docs** | Spec + plan, then project-defined | Proposal + design, then project-defined | Relevant `README*` sources are created or revised on demand; verification design has architecture- and detail-level ownership |
| **Brownfield** | Primarily greenfield | **Brownfield-first** (designed for existing codebases) | **Both** — analyze existing code into US/AC/TC |
| **Install method** | `uv tool install specify-cli` (Python) | `npm install -g @fission-ai/openspec` (TypeScript) | Markdown prompt files (agent-agnostic) |
| **Customization** | Extensions + presets + overrides | Schemas | `methodPrompts/` as method source of truth, `slashCommands/` as command layer, `agentSkills/` as packages |

---

## Why CaTDD Is BEYOND

Spec Kit and OpenSpec are valuable specification workflows. They organize project intent and change artifacts; verification practices can be provided by either tool's surrounding project setup or by a complementary method such as CaTDD.

**Spec Kit** gives you a structured pipeline: constitution → spec → plan → tasks → implement, with analysis and checklist commands. CaTDD adds a distinct source-backed test-point and test-case evidence contract.

**OpenSpec** gives you fluid change management: propose → apply → verify → archive. CaTDD adds a user-story lifecycle and verification design/evidence model; it does not imply OpenSpec cannot run or verify tests.

### One bug, three tools

Here is the same defect seen through each tool. QA reports: *"IOC_post returns success on a destroyed handle."*

```
   Spec Kit   →  helps organize requirements, plan, tasks, and checklist
                 evidence in its document workflow

   OpenSpec   →  helps organize the change proposal, specs, design,
                 tasks, and verification in a change folder

   CaTDD      →  links the source rule to a TP, observable oracle,
                 registered story, qualified AC/TC, test status,
                 and the owning review / story-completion gate
```

These workflows emphasize different artifact models. CaTDD's differentiator is the explicit, source-linked chain from design obligation to verification evidence, with the relevant test design kept alongside executable tests.

### What CaTDD adds

1. **It manages user stories through their full lifecycle**, from raw import to verified closure, with an explicit abort path for when scope or assumptions turn out wrong.
2. **It aligns human and LLM intent before design begins**, preventing the most expensive mistake in LLM-driven development: building the wrong thing perfectly.
3. **It defines source-first verification design.** The discovery ledger tracks source-backed TPs, observable oracles, category routing, and disposition before implementation; cardinality alone is not treated as proof of completeness.
4. **It keeps test design near executable evidence without replacing its sources.** Registered US and qualified AC/TP/TC identities connect test comments and code to authoritative story, domain, and design artifacts.
5. **It separates category, test level, and runtime scope.** P0/P1/P2/P3 describe verification concerns; `TestLevel` declares the SUT boundary; `TestScope` distinguishes mocked from real runtime evidence. DDD's subdomain classification may inform risk but does not assign a test category.

### The Spec-Driven Stack

Think of the three tools as layers of one stack:

```
   ┌──────────────────────────────────────────────────┐
   │  CaTDD Px-SpecFlow + TEST flows                  │
   │  "Design and record verification evidence"       │
   │  story lifecycle + source-linked test method     │
   ├──────────────────────────────────────────────────┤
   │  Spec Kit / OpenSpec                             │
   │  "Decide what to build and how"                  │
   │  document-centric or change-centric              │
   ├──────────────────────────────────────────────────┤
   │  AI Coding Agents (Copilot, Cline, Claude, ...)  │
   │  "Generate the code"                             │
   └──────────────────────────────────────────────────┘
```

Spec Kit and OpenSpec structure specifications or changes. CaTDD contributes a story lifecycle and explicit verification design/evidence. They are not mutually exclusive; projects can compose these approaches with clear artifact ownership.

Choose based on the workflow and evidence contracts the project needs. No workflow guarantees correctness by itself; meaningful verification still depends on source-backed expectations, sound tests, and credible execution evidence.

> **Comments is Verification Design. LLM Generates Code. Iterate Forward Together.**

## Usage Example

For an active story whose detail design has passed review, start CaTDD test design with the canonical SpecFlow command:

```text
/SPEC_designTests
doing_user_story: .catdd/spec/doingUS/<story>-UserStory.md
detail_design: README_DetailDesign.md
verify_design: README_DetailVerifyDesign.md
```

Expected result: the command derives obligations from sources before reviewing existing tests, updates source-linked discovery and traceability, decides the P0 Functional skeleton set first, and reports any P1/P2 promotion only with its source evidence. It also names the matching `TEST_*` contracts and the required next skeleton-review command; unresolved human decisions remain questions rather than invented requirements.
