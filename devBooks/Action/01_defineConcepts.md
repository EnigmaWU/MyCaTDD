# 01 defineConcepts

## What Is CaTDD?

**CaTDD** — Comment-alive Test-Driven Development — is a methodology invented by EnigmaWU and practiced since 2023.10. It redefines what "design" means in software development by making comments first-class artifacts that LLMs can parse, preserve, and update.

The core slogan captures the essence:

> Comments is Verification Design. LLM Generates Code. Iterate Forward Together.

In traditional development, design lives in separate documents that go stale the moment code changes. In CaTDD, design lives **in the test file** as structured comments that evolve with the code. Comments are not documentation — they are the verification specification.

### What "Comment-alive" Means

"Comment-alive" is the defining innovation of CaTDD. It has four dimensions:

1. **Design details live IN the test and source file as structured comments.** You don't maintain a separate spec doc, architecture doc, and test plan. The verification design is embedded right where the code lives.

2. **Comments evolve WITH the code, not separate docs that go stale.** When you refactor production code, you update the comments in the same file. Design intent and implementation stay synchronized by construction.

3. **Comments are first-class artifacts that LLMs can parse and update.** An LLM reading a CaTDD test file sees structured `@[US]`, `@[AC]`, `@[TC]` markers it can trace, validate, and generate code from. This is why CaTDD is "LLM-friendly TDD."

4. **US/AC/TC format bridges human intent and machine-executable tests.** User Stories express business value. Acceptance Criteria make stories testable. Test Cases connect criteria to concrete assertions. The chain runs from human need to machine verification without gaps.

### The "TDD" Part

CaTDD inherits the traditional TDD Red→Green→Refactor cycle, but adds structure before code:

| Traditional TDD | CaTDD |
|---|---|
| Write a failing test | Write structured comment design first (US/AC/TC), then write the failing test |
| Implement to pass | Implement minimal production code to pass |
| Refactor | Refactor both test and production code |
| Repeat | Mark TC status (⚪→🔴→🟢), advance to next |
| No explicit design artifacts | Design lives in the same file as tests |

CaTDD is not a replacement for TDD. It is TDD with design structure, traceability, and LLM-readability built in.

---

## Category-Specific Method Prompts

Beyond the master method prompt, CaTDD provides 12 category-specific prompts — one for each test category. These deep-dive files (`CaTDD_methodPrompt4Cat-*.md`) guide CodeAgents when working within a specific category:

| Category | Prompt File | Key Guidance |
|---|---|---|
| Typical | `4Cat-Typical.md` | Core happy-path design, one behavior per test, ≤3 assertions |
| Edge | `4Cat-Edge.md` | Boundary values, mode variations, one edge per test for diagnostics |
| Misuse | `4Cat-Misuse.md` | API contract violations, error prevention, invalid sequences |
| Fault | `4Cat-Fault.md` | External failures, recovery, graceful degradation |
| State | `4Cat-State.md` | Lifecycle transitions, FSM validation, invalid state rejection |
| Capability | `4Cat-Capability.md` | System limits, capacity planning, documented boundaries |
| Concurrency | `4Cat-Concurrency.md` | Thread safety, race conditions, parallel access patterns |
| Performance | `4Cat-Performance.md` | SLO validation, benchmarks, resource usage |
| Robust | `4Cat-Robust.md` | Stress testing, soak tests, long-running stability |
| Compatibility | `4Cat-Compatibility.md` | Cross-platform, version upgrades, integration surfaces |
| Configuration | `4Cat-Configuration.md` | Build flags, deployment variations, feature toggles |
| Demo/Example | `4Cat-DemoExample.md` | Tutorials, documentation, best practice illustrations |

Each category prompt defines: **Position** (where it sits in the priority framework), **Use When** (valid conditions), **Do Not Use When** (when to move the scenario to another category), **Design Focus** (what to emphasize), **Design Skeleton** (the contract shape), **US/AC/TC Pattern** (the canonical format), **Naming Examples** (concrete test names), a **Checklist** (quality validation), and **Common Mistakes** (what to avoid).

These prompts are the LLM's "style guide" for each category. When a CodeAgent designs a Typical skeleton, it reads `4Cat-Typical.md` to apply the right patterns, vocabulary, and constraints. When it classifies a draft into categories, it checks the "Do Not Use When" rules to avoid misclassification.

---

## The Four-Layer Architecture

MyCaTDD organizes the CaTDD methodology into four layers, each with a clear responsibility:

```
┌─────────────────────────────────────────────────────┐
│ [1] methodPrompts       — Method source              │
│     CaTDD semantics, category meaning, US/AC/TC     │
│     skeleton rules, status discipline, templates    │
├─────────────────────────────────────────────────────┤
│ [2] slashCommands       — Command flow               │
│     Portable UT_* and SPEC_* commands, flow order   │
│     input/output handoff, tool-neutral execution     │
├─────────────────────────────────────────────────────┤
│ [3] codeAgents          — Intelligent execution      │
│     utCodeAgentCLI (unit testing), specCodeAgentCLI │
│     planning, trace collection, reflection loops     │
├─────────────────────────────────────────────────────┤
│ [4] agentSkills         — Reusable capability packs  │
│     Comment-alive TDD skill, SpecCoding skill        │
│     packaged for Copilot, Cline, and other agents    │
└─────────────────────────────────────────────────────┘
```

### Layer 1: methodPrompts — The Source of Truth

`methodPrompts/` is the canonical definition of CaTDD. Everything downstream derives from this layer. If the methodology changes, this layer changes first.

What it contains:

- **`CaTDD_methodPrompt.md`** — The master method specification. Every aspect of CaTDD is defined here: priority framework, category semantics, US/AC/TC contract, TDD Red→Green cycle, quality gates, status tracking, risk-driven prioritization, and the complete agent workflow checklist from understanding through finalization.

- **`CaTDD_methodPrompt4Cat-*.md`** — Category-specific method prompts. Each of the 12 test categories (Typical, Edge, Misuse, Fault, State, Capability, Concurrency, Performance, Robust, Compatibility, Configuration, Demo/Example) has its own deep-dive prompt that CodeAgents can reference when working within that category.

- **`CaTDD_ImplTemplate.cxx`** — A C++ implementation template that demonstrates the complete CaTDD file structure. Despite using C++ syntax, the template is language-agnostic in concept: any language can adopt the OVERVIEW → DESIGN → IMPLEMENTATION → TODO structure.

- **Standalone user guides** — `README_UserGuide.md` and `README_UserGuide_ZH.md` explain HOW to use method prompts, WHO uses them, WHEN to apply them, and WHERE to place them. They exist so someone can use just this directory without reading the entire repository.

### Layer 2: slashCommands — The Commandization Layer

`slashCommands/` turns stable method steps into portable commands. It is the connector between method semantics and CodeAgent invocation surfaces (Copilot, Cline, Continue, utCodeAgentCLI).

Key principle: slashCommands does NOT redefine method semantics. It takes what methodPrompts defines and wraps it into executable command units. When a command conflicts with methodPrompts, methodPrompts wins.

The layer contains:

- **Flow documents** under `flows/` — P0-FuncTestsFlow, P1-DesignTestsFlow, P2-QualityTestsFlow, and Px-SpecFlow. Each flow defines a repeatable command sequence with entry points, gates, and loop-back paths.

- **Command templates** — `UT_slashCommandTemplate.md` and `SPEC_slashCommandTemplate.md` ensure every command follows the same WHO/WHAT/WHEN/WHERE/WHY/HOW structure.

- **Concrete command files** under `commands/` — Each command file tells a CodeAgent exactly what to do: what to read, what to produce, what to preserve, and what command comes next.

### Layer 3: codeAgents — The Execution Layer

`codeAgents/` contains the CaTDD-native CLI agent concepts. Currently these are design documents and architecture specifications — the runnable implementations are in progress.

Two agents are defined:

- **`utCodeAgentCLI`** — The unit-testing code agent. It takes developer goals as input, plans work from CaTDD method constraints, invokes standardized slash command steps, collects traces, reflects on outcomes, and feeds reusable patterns back into the method and command layers. It preserves CaTDD's design skeleton contracts, US/AC/TC traceability, category classification, and RED/GREEN status discipline.

- **`specCodeAgentCLI`** — The specification code agent. It orchestrates module-level SpecCoding flow from input to output. Based on Px-SpecFlow, it reuses utCodeAgentCLI's unit-testing strengths and organizes scenario-level verification from spec intent to executable checks. It keeps traceability between spec flow, validation checkpoints, and implementation outcomes.

These two agents together form a pipeline: spec → ut → results.

### Layer 4: agentSkills — The Packaging Layer

`agentSkills/` packages CaTDD and SpecCoding as reusable skills that any CodeAgent can consume. Two skills are authored:

1. **`comment-alive-test-driven-development`** — The CaTDD testing methodology packaged as a skill. It includes WHO/WHAT/WHEN/WHERE/WHY sections, phase-by-phase execution instructions, input/output contracts, constraints, and validation rules. When a developer says "use CaTDD" to a CodeAgent, this skill provides the agent with everything it needs.

2. **`user-story-centered-spec-coding`** — The SpecCoding lifecycle orchestration packaged as a skill. It covers the full story lifecycle: pendingNews → todoUS → doingUS → doneUS, with CaTDD as the default unit-testing method.

The packaging script `makeSkill.sh` generates self-contained distributable packages by copying references from methodPrompts and slashCommands. The authored source is the durable asset; generated packages are build output.

---

## The Feedback Loop

The four layers are not a one-way pipeline. They form a bidirectional improvement loop:

```
methodPrompts ──→ slashCommands ──→ codeAgents
      ↑               ↑                │
      └───────────────┴────────────────┘
           feedback loop
```

- **methodPrompts → slashCommands**: Stable method steps are commandized into slash commands.
- **methodPrompts → codeAgents**: Agent behavior is constrained by method semantics.
- **slashCommands → codeAgents**: Agents invoke standardized command steps.
- **slashCommands → methodPrompts**: Command execution reveals method gaps — the method improves.
- **codeAgents → slashCommands**: Agent reflection identifies reusable command patterns — slash commands grow.
- **codeAgents → methodPrompts**: Execution experience feeds back into methodology improvements.

This loop ensures CaTDD evolves from real usage, not theoretical design. Every downstream layer both consumes and improves the upstream layers.

---

## The Design Skeleton Contract

In CaTDD, "design" is not a UML diagram or a Word document. It is a **reusable comment skeleton** inside the test file. Each skeleton is organized by:

- **Class**: The priority family — `P0 Functional`, `P1 Design`, `P2 Quality`, `P3 Addons`
- **Category**: The specific verification angle — `Typical`, `Edge`, `Misuse`, `Fault`, `State`, `Capability`, `Concurrency`, `Performance`, `Robust`, `Compatibility`, `Configuration`, `Demo/Example`

Every skeleton preserves this minimum shape:

```text
//=================================================================================================
// [Class] / [Category] Design Skeleton
//=================================================================================================
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: What this category proves for this component
// @[UseWhen]: When this category applies
// @[AvoidWhen]: When to move the scenario to another category
// @[US]: User Story IDs covered by this category
// @[AC]: Acceptance Criteria IDs covered by this category
// @[TC]: Test Cases, status, and expected TDD next action
//=================================================================================================
```

This skeleton is the "contract" that developers and CodeAgents both honor. Developers fill the skeleton with verification intent. CodeAgents read the skeleton and generate test code that satisfies the intent. Both sides update the skeleton as the code evolves.

---

## The Priority Framework

CaTDD organizes tests into four priority levels with a strict execution order. This is the architecture of verification.

### P0: Functional Testing

**Formula**: `P0 = ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)`

P0 is the default gate before everything else. In the standard order, you complete P0 before advancing to P1 — this ensures the API contract is verified for both success and failure paths. However, context-specific adjustments (described below) may promote certain P1 categories to interleave with P0 completion when the domain demands it.

#### ValidFunc — Proves the system works correctly

| Category | Purpose | Examples |
|---|---|---|
| **Typical** ⭐ | Core happy-path workflows | Service registration, event publishing, command execution |
| **Edge** 🔲 | Boundary values, limits, modes | Min/max values, empty inputs, Block/NonBlock/Timeout modes |

#### InvalidFunc — Proves the system fails gracefully

| Category | Purpose | Examples |
|---|---|---|
| **Misuse** 🚫 | Incorrect API usage patterns | Wrong call sequence, double-init, invalid parameters |
| **Fault** ⚠️ | External failures and recovery | Network failures, disk full, process crash recovery |

### P1: Design-Oriented Testing

Tests that validate architectural decisions: state management, capacity planning, and concurrency models.

| Category | Purpose | Examples |
|---|---|---|
| **State** 🔄 | State machine transitions and lifecycle | Init→Ready→Running→Stopped |
| **Capability** 🏆 | Maximum capacity and system limits | Max connections, queue limits, resource pool exhaustion |
| **Concurrency** 🚀 | Thread safety and race conditions | Parallel access, deadlock scenarios, lock-free validation |

### P2: Quality-Oriented Testing

Non-functional requirements: performance, stability, and compatibility.

| Category | Purpose | Examples |
|---|---|---|
| **Performance** ⚡ | Speed, throughput, resource usage | Latency benchmarks, memory leak detection |
| **Robust** 🛡️ | Stress, repetition, long-running stability | 1000x repetition, 24-hour soak tests |
| **Compatibility** 🔄 | Cross-platform, version testing | Windows/Linux/macOS, API version compatibility |
| **Configuration** 🎛️ | Settings and deployment variations | Debug vs Release, feature flags, environment variables |

### P3: Addons Testing

| Category | Purpose |
|---|---|
| **Demo/Example** 🎨 | End-to-end demonstrations, tutorials, best practice illustrations |

### Default Test Order

```
P0: Typical → Edge → Misuse → Fault
P1: State → Capability → Concurrency
P2: Performance → Robust → Compatibility → Configuration
P3: Demo/Example
```

This order is not rigid — it adapts to context.

---

## Context-Specific Priority Adjustments

Different project types demand different test priorities. CaTDD provides adjustment rules for common contexts:

### New Public API

```
P0: Typical → Edge → Misuse → Fault (complete P0 thoroughly)
P1: State → Capability → Concurrency
P2: Performance
```

*Rationale*: API contract correctness before advanced testing.

### Stateful/FSM-Heavy Component

```
P0: Typical → Edge (basic functional)
P1: State (promote to early) → Capability → Concurrency
P0: Misuse → Fault (complete functional)
P2: Performance → Robust
```

*Rationale*: State transitions are architectural core — test them after basic functionality.

### Reliability-Critical Service

```
P0: Typical → Edge → Fault (promote) → Misuse
P1: State → Capability → Concurrency
P2: Robust (promote) → Performance → Compatibility
```

*Rationale*: Error handling and stability are paramount.

### High-Performance System (SLOs)

```
P0: Typical → Edge → Misuse
P2: Performance (promote within P2) → Robust
P1: State → Capability → Concurrency
P0: Fault (complete P0)
```

*Rationale*: Performance characteristics are design constraints, not afterthoughts.

### Highly Concurrent Design

```
P0: Typical → Edge → Misuse
P1: Concurrency (promote to first P1) → State → Capability
P0: Fault (complete P0)
P2: Performance → Robust
```

*Rationale*: Thread safety is the architectural foundation.

### Data Processing Pipeline

```
P0: Typical → Edge → Fault → Misuse
P2: Performance (promote) → Robust (promote)
P1: State → Capability → Concurrency
```

*Rationale*: Data integrity and throughput are critical quality attributes.

---

## Risk-Driven Priority Adjustment

When context-specific adjustments are not enough, use the risk scoring formula:

```
Risk Score = Impact × Likelihood × Uncertainty

Impact:      1 (low) → 3 (critical)
Likelihood:  1 (rare) → 3 (frequent)
Uncertainty: 1 (known) → 3 (unknown)

Max score: 27
```

**Priority Rules**:

- Score ≥ 18: Move category immediately after Edge
- Score 12-17: Move up 2 positions from default
- Score 9-11: Move up 1 position from default
- Score ≤ 8: Keep default position

**Example Assessment**:

```
Concurrency in multi-threaded queue:
  Impact: 3 (data corruption)
  Likelihood: 3 (many threads)
  Uncertainty: 3 (complex interactions)
  Score: 27 → Test immediately after Edge

Performance in batch processor:
  Impact: 2 (slower but functional)
  Likelihood: 2 (depends on load)
  Uncertainty: 2 (some benchmarks exist)
  Score: 8 → Keep default position
```

---

## The US/AC/TC Contract

The heart of CaTDD is the traceable chain from human need to machine-executable test:

```
User Story (US) → Acceptance Criteria (AC) → Test Case (TC)
      ↓                    ↓                      ↓
  Business value       Testable condition      Concrete assertion
```

### User Story (US) Template

```
US-n: As a [specific role/persona],
      I want [specific capability or feature],
      So that [concrete business value or benefit].
```

Each US represents a distinct user value. A module typically has 2-5 User Stories.

**Real example from the IOC Event System**:

```
US-1: As an event producer in high-load scenarios,
      I want to post events without blocking when the queue is full,
      So that my application remains responsive under load.
```

### Acceptance Criteria (AC) Template

```
AC-n: GIVEN [initial context and preconditions],
      WHEN [specific trigger, action, or event],
      THEN [expected observable outcome or behavior],
       AND [additional expected outcomes if any].
```

For each US, define 1-4 ACs. Each AC must be independently verifiable.

**Real example**:

```
AC-1: GIVEN an event producer calling IOC_postEVT_inConlesMode,
      WHEN IOC's EvtDescQueue is full in ASyncMode by blocking consumer,
      THEN producer returns immediately without waiting,
       AND returns IOC_RESULT_TOO_MANY_QUEUING_EVTDESC,
       AND the event is not queued for processing.
```

### Test Case (TC) Template

```
[@AC-n,US-n]
 TC-n:
   @[Name]: verifyBehavior_byCondition_expectResult
   @[Purpose]: Why this test matters and what it validates
   @[Brief]: What the test does in simple terms
   @[Steps]: Detailed execution steps (optional for complex tests)
   @[Expect]: How to verify success
   @[Notes]: Additional context, gotchas, or dependencies
```

**Naming Convention**: `verifyBehavior_byCondition_expectResult`

```
verifyServiceRegistration_byValidName_expectSuccess
verifyEventPost_byFullQueue_expectNonBlockReturn
verifyCommandExec_byMultipleClients_expectIsolatedExecution
verifyStateTransition_byInvalidSequence_expectError
```

The chain must be traceable: every TC references its AC, every AC references its US. CaTDD CodeAgents read this traceability chain to understand what to generate and why.

---

## The TDD Red→Green Cycle (CaTDD Style)

CaTDD formalizes the TDD cycle with explicit status tracking:

```
⚪ TODO/PLANNED  →  🔴 RED/FAILING  →  🟢 GREEN/PASSED
   (designed)         (test written,        (test passing)
                       code missing)
```

Each test case starts as ⚪ TODO (designed in comments). You implement the test, mark it 🔴 RED (should fail because production code is missing). You implement minimal production code, run the test, mark it 🟢 GREEN. Then you advance to the next test case.

### The 4-Phase Test Structure

Every test follows a consistent pattern:

```cpp
TEST(CategoryName, verifyBehavior_byCondition_expectResult) {
    //===SETUP===
    // Initialize environment, create resources, configure preconditions

    //===BEHAVIOR===
    printf("🎯 BEHAVIOR: verifyBehavior_byCondition_expectResult\n");
    // Execute the action being tested

    //===VERIFY===
    // Validate outcomes (keep ≤3 key assertions)

    //===CLEANUP===
    // Release resources, reset state
}
```

**Why ≤3 assertions per test?**

- Easier to identify what failed
- Better test isolation
- Clearer test purpose
- If you need more assertions, create additional test cases

---

## Quality Gates

CaTDD defines explicit gates between priority levels. You do not proceed through a gate until all criteria are satisfied.

### Gate P0: Before Leaving Functional Testing

Must complete: ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)

- All Typical tests GREEN (80-90% core workflow coverage)
- All Edge tests GREEN (edge cases, boundaries, limits validated)
- All Misuse tests GREEN or documented (wrong usage handled)
- All Fault tests GREEN or documented (error recovery verified)
- No critical correctness bugs
- **Fast-Fail Six** tests all passing
- Basic memory/resource leak checks clean

**Exit criteria**: Complete API contract tested — both success and failure paths.

### Gate P1: Before Quality-Oriented Testing

- State tests GREEN (if stateful component)
- Capability tests GREEN (limits characterized)
- Concurrency tests GREEN (if multi-threaded)
- No known deadlock or race conditions
- ThreadSanitizer/AddressSanitizer clean
- Architecture validated against design requirements

### Gate P2: Before Release

- Performance tests GREEN (SLOs met if defined)
- Robust tests GREEN (stress/soak tests passing)
- Compatibility tests GREEN (if multi-platform)
- Configuration tests GREEN (if configurable)
- Production readiness criteria met

### Optional Gate P3: Documentation Complete

- Demo/Example tests GREEN
- Tutorial code validated
- Best practices documented

---

## The Fast-Fail Six

Run these six tests early and often to catch common issues before they waste time in detailed testing:

1. **Null/Empty Input Handling** — Does every API reject `NULL` and empty strings with proper error codes?

2. **Zero/Negative Timeout** — What happens when timeout is 0, -1, or UINT_MAX?

3. **Duplicate Registration/Subscription** — Does double-registration return ALREADY_EXISTS?

4. **Illegal Call Sequence** — What happens if you call APIs before init or after cleanup?

5. **Buffer Full/Empty Edge Cases** — Fill to capacity, try one more. Empty completely, try one more.

6. **Double-Close/Re-Init Idempotency** — Is the system idempotent or does it return proper errors?

These six tests are the minimum defense against API misuse. They establish the contract boundaries before deeper test design begins.

---

## Test Organization Strategies

CaTDD supports two organizational strategies depending on project size:

### Single File Strategy (simpler projects, <50 tests)

Keep all tests for a component in one file. Use TEST suites to organize by category. Good for small-to-medium modules.

### Multi-File Strategy (larger projects)

All test files in a `Test/` directory:

- `UT_ComponentFreelyDrafts.cxx` — Exploration and idea capture
- `UT_ComponentTypical.cxx` — Core workflows
- `UT_ComponentEdge.cxx` — Edge cases, boundaries, limits
- `UT_ComponentState.cxx` — State transitions
- `UT_ComponentConcurrency.cxx` — Thread safety
- `UT_ComponentMisuse.cxx` — API abuse patterns
- `UT_ComponentFault.cxx` — Error handling and recovery
- Common utilities in `_UT_Common.h`

Mature, stable tests move from exploration files to category-specific files.

---

## The Implementation Tracking Template

Every CaTDD test file includes a TODO/Implementation Tracking section that records all test cases with their status:

```
//===========================================================================================
// 🥇 HIGH PRIORITY – Core Functionality
//===========================================================================================
//   ⚪ [@AC-1,US-1] TC-1: verifyCore_byBasicOperation_expectSuccess
//   🔴 [@AC-2,US-1] TC-1: verifyCore_byMaxCapacity_expectProperHandling
//
//===========================================================================================
// 🥈 MEDIUM PRIORITY – Edge & Error Handling
//===========================================================================================
//   ⚪ [@AC-3,US-1] TC-1: verifyEdge_byEmptyQueue_expectEmptyResult
//   ⚪ [@AC-4,US-2] TC-1: verifyMisuse_byDoubleInit_expectError
//
//===========================================================================================
// 🥉 LOW PRIORITY – Advanced Scenarios
//===========================================================================================
//   ⚪ [@AC-5,US-2] TC-1: verifyPerformance_byHighLoad_expectAcceptableLatency
//
// 🚪 GATE P0: All P0 tests must be GREEN before proceeding to P1.
```

This tracking section is the dashboard for the entire test effort. Developers and CodeAgents both read it to know what is done, what is in progress, and what is planned.

---

## Design as a Living Contract

CaTDD fundamentally redefines design. Design is not an upstream activity that finishes before coding begins. Design is a living contract that lives in the test file, evolves with the code, and is readable by both humans and LLMs.

The contract states:

1. **What matters** — expressed in User Stories with business value
2. **What to verify** — expressed in Acceptance Criteria with GIVEN/WHEN/THEN
3. **How to verify** — expressed in Test Cases with concrete assertions
4. **What priority** — expressed in the P0→P1→P2→P3 framework
5. **What status** — expressed in ⚪→🔴→🟢 markers

This is the foundation of everything CaTDD. It is what methodPrompts defines, what slashCommands operationalize, what codeAgents execute, and what agentSkills package. Every other layer depends on these concepts.

---

## From Concepts to Action

The remaining chapters move from "what" to "how":

- **Chapter 2: chatVibeCoding** — How to use LLMs with CaTDD in chat-based development, the distinction between VibeCoding and SpecCoding
- **Chapter 3: callSlashCommands** — How to invoke the slash command system for structured, repeatable CaTDD execution
- **Chapter 4: asyncCodeAgent** — How code agents automate test design, test implementation, and the full SpecCoding lifecycle
- **Chapter 5: applyClassicSWE** — The Knowledge Book of Software Engineering (TDD, BDD, DDD) applied in the LLM era through CaTDD's synthesis of all three disciplines
