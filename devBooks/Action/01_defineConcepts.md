# 01 defineConcepts

## What Is CaTDD?

**CaTDD** stands for **Comment-alive Test-Driven Development**. It is a way to build software where the design lives *inside the code file* as structured comments, instead of in separate documents that slowly stop matching the code.

EnigmaWU created the method in 2023.10, and it has been used on real projects ever since.

The whole idea fits in one sentence:

> Comments is Verification Design. LLM Generates Code. Iterate Forward Together.

**Why it matters.** In a normal project, design is written once, then the code changes, and the document quietly becomes wrong. Nobody notices until someone trusts the old document and makes a bad decision. CaTDD removes that failure mode: the design sits next to the code it describes, so you cannot change one without seeing the other.

```
┌────────────────────────────┐      ┌────────────────────────────┐
│     TRADITIONAL PROJECT    │      │        CaTDD PROJECT       │
├────────────────────────────┤      ├────────────────────────────┤
│  design.md                 │      │  test_<feature>.cxx        │
│  architecture.md           │      │    ├── design comments     │
│  test-plan.md              │  vs  │    ├── test cases          │
│  ... three separate files  │      │    └── status tracking     │
├────────────────────────────┤      ├────────────────────────────┤
│  code changes              │      │  code changes              │
│  → documents go stale      │      │  → comments change with it │
└────────────────────────────┘      └────────────────────────────┘
```

### What "Comment-alive" Means

"Comment-alive" is the part that makes CaTDD different. It has four dimensions.

```
   1. DESIGN LIVES IN THE FILE      test_feature.cxx
      no separate spec doc          ├── // @[US-1] ...
                                    ├── // @[AC-1] ...
                                    └── // @[TC-1] ...
   2. COMMENTS MOVE WITH CODE       code refactored → comments updated
                                    in the same edit

   3. MACHINES CAN READ THEM        an LLM sees @[US] @[AC] @[TC] markers
                                    and knows what to build

   4. THE CHAIN NEVER BREAKS        human need → US → AC → TC → assertion
```

1. **Design detail lives in the test file.** You do not maintain a spec document, an architecture document, and a test plan in three places. The verification design sits where the code sits.

2. **Comments evolve with the code.** When you refactor production code, you update the comments in the same file and the same commit. Intent and implementation stay in sync by construction, not by discipline.

3. **Comments are first-class artifacts that LLMs can parse and update.** An LLM reading a CaTDD test file sees `@[US]`, `@[AC]`, and `@[TC]` markers it can trace, validate, and generate code from. That is why CaTDD is LLM-friendly TDD.

4. **US/AC/TC connects human intent to machine checks.** A User Story states business value, Acceptance Criteria make it testable, and Test Cases turn it into concrete assertions. The chain runs from human need to machine verification without a gap.

### The "TDD" Part

CaTDD keeps the classic Red → Green → Refactor cycle. What it adds is structure *before* the code: you write the design as comments first.

| Traditional TDD | CaTDD |
|---|---|
| Write a failing test | Write the structured comment design first (US/AC/TC), then the failing test |
| Implement to pass | Implement the smallest production code that passes |
| Refactor | Refactor test and production code together |
| Repeat | Move the TC status (⚪ → 🔴 → 🟢), then take the next test case |
| Design is not captured | Design lives in the same file as the tests |

> **Key point** — CaTDD is not a replacement for TDD. It is TDD with design structure, traceability, and machine-readability built in.

**Example — the same fix, two ways.** Suppose `IOC_postEVT` starts failing when the queue is full.

```
Without CaTDD                          With CaTDD
──────────────                         ──────────
1. bug reported                        1. read the design comment:
2. search the code                        // @[AC-2] WHEN queue is full
3. guess the intent                          THEN return immediately
4. patch, hope nothing breaks          2. the intent is already written down
5. no record of why                    3. write the test that proves it
                                       4. patch until it is GREEN
                                       5. the reason stays in the file
```

The second path is faster because the *why* was never lost.

---

## Category-Specific Method Prompts

CaTDD does not treat every test as the same kind of test. It defines **15 test categories**, and gives each one its own method prompt: `CaTDD_methodPrompt4Cat-*.md`. A CodeAgent reads the prompt for the category it is working in, so it uses the right vocabulary, the right test points, and the right constraints.

```
                         15 TEST CATEGORIES
                                │
   ┌────────────────┬───────────┴───────────┬────────────────┐
   │      P0        │          P1           │      P2        │      P3
   │  functional    │       design          │    quality     │   addons
   ├────────────────┼───────────────────────┼────────────────┼──────────
   │  Typical       │  State                │  Performance   │  Demo/
   │  Edge          │  Capability           │  Robust        │  Example
   │  Misuse        │  Interaction          │  Compatibility │
   │  Fault         │  Concurrency          │  Configuration │
   │                │                       │  Diagnosis     │
   │                │                       │  Security      │
   └────────────────┴───────────────────────┴────────────────┴──────────
```

| Category | Prompt File | What it is for |
|---|---|---|
| Typical | `CaTDD_methodPrompt4Cat-Typical.md` | The happy path: one behavior per test, at most 3 assertions |
| Edge | `CaTDD_methodPrompt4Cat-Edge.md` | Boundaries, limits, and modes; one edge per test |
| Misuse | `CaTDD_methodPrompt4Cat-Misuse.md` | Wrong API usage: bad order, invalid parameters, double init |
| Fault | `CaTDD_methodPrompt4Cat-Fault.md` | Outside failures and recovery: network down, disk full |
| State | `CaTDD_methodPrompt4Cat-State.md` | Lifecycle and state machines; invalid transitions |
| Capability | `CaTDD_methodPrompt4Cat-Capability.md` | Designed limits and responsibilities |
| Interaction | `CaTDD_methodPrompt4Cat-Interaction.md` | Order between collaborators and handoff contracts |
| Concurrency | `CaTDD_methodPrompt4Cat-Concurrency.md` | Threads, races, deadlocks, ordering |
| Performance | `CaTDD_methodPrompt4Cat-Performance.md` | SLOs, latency, throughput, resource budgets |
| Robust | `CaTDD_methodPrompt4Cat-Robust.md` | Stress, repetition, long runs, degraded conditions |
| Compatibility | `CaTDD_methodPrompt4Cat-Compatibility.md` | Versions, platforms, protocols, schemas, toolchains |
| Configuration | `CaTDD_methodPrompt4Cat-Configuration.md` | Defaults, precedence, feature flags, bad config |
| Diagnosis | `CaTDD_methodPrompt4Cat-Diagnosis.md` | Observability, debuggability, useful failure evidence |
| Security | `CaTDD_methodPrompt4Cat-Security.md` | Threats, trust boundaries, secrets, protection |
| Demo/Example | `CaTDD_methodPrompt4Cat-DemoExample.md` | Tutorials and documented examples |

Every category prompt answers the same questions, so you always know where to look:

| Section | The question it answers |
|---|---|
| **Position** | Where does this category sit in the priority framework? |
| **Use When** | When is this the right category? |
| **Do Not Use When** | When should this scenario move to another category? |
| **TestPointsInMind** | What should I probe for in this category? |
| **Design Skeleton** | What is the contract shape for this category? |
| **Checklist** | How do I know the work is good enough? |

Ten of the fifteen files (the four P0 categories plus State, Capability, Interaction, Concurrency, Diagnosis, and Security) also carry **Design Focus**, **US/AC/TC Pattern**, **Naming Examples**, and **Common Mistakes**. The five remaining files (Performance, Robust, Compatibility, Configuration, Demo/Example) stay lean and route discovery through `TestPointsInMind`.

> **Why one file per category?** Because "write a test" is not one skill. A boundary test, a race-condition test, and a security test fail in different ways and need different design habits. Splitting them keeps each habit sharp.

**Example — category discipline prevents a weak test.** A developer writes one test that fills a queue and checks five things at once: it is full, the return code is right, no event was queued, the counter did not change, and the next call still works.

```
One test, five checks                    Split by category
────────────────────                     ─────────────────
Typical? Edge? Misuse? Fault?            Edge   : fill to capacity, one more
When it fails, you must re-read          Misuse : call again after full
the whole test to learn why              Typical: normal post still works
```

Four small tests tell you *which* rule broke. One large test only tells you *something* broke.

---

## The Four-Layer Architecture

MyCaTDD is built in four layers. Each layer has one job, and each layer depends only on the one above it.

```
┌─────────────────────────────────────────────────────┐
│ [1] methodPrompts   — where the method is defined   │
│     CaTDD semantics, category meaning, US/AC/TC     │
│     skeleton rules, status discipline, templates    │
├─────────────────────────────────────────────────────┤
│ [2] slashCommands   — how the method is invoked     │
│     Portable UT_*, SPEC_*, HARNESS_* commands       │
│     input/output handoff, tool-neutral execution    │
├─────────────────────────────────────────────────────┤
│ [3] codeAgents      — who executes it               │
│     utCodeAgentCLI (unit testing)                   │
│     specCodeAgentCLI (SpecCoding lifecycle)         │
│     planning, trace collection, reflection loops    │
├─────────────────────────────────────────────────────┤
│ [4] agentSkills     — how it is packaged to go      │
│     Comment-alive TDD skill, SpecCoding skill       │
│     packaged for Copilot, Cline, and other agents   │
└─────────────────────────────────────────────────────┘
```

A simple way to remember the layers:

```
   methodPrompts   =  the RULES
   slashCommands   =  the BUTTONS
   codeAgents      =  the WORKERS
   agentSkills     =  the SHIPPING BOX
```

### Layer 1: methodPrompts — The Source of Truth

`methodPrompts/` is the official definition of CaTDD. Everything else is derived from it. If the method changes, this layer changes first.

| What is in it | What it gives you |
|---|---|
| `CaTDD_methodPrompt.md` | The master entry point and the stable CaTDD contract: skeleton shape, category semantics, mandatory traceability, test-point discovery, workflow, and the default execution order |
| `CaTDD_methodPrompt-*.md` | Subtopic prompts with the deeper material: category semantics, test-point discovery, workflow, test structure, file naming, agent workflow, troubleshooting, and worked examples |
| `CaTDD_methodPrompt4Cat-*.md` | One deep-dive prompt per test category, so a CodeAgent can apply the right rules inside that category |
| `CaTDD_designAndImplTemplate.cxx/.ts/.py/.go` | Working file templates for C++, TypeScript, Python, and Go. They all follow the same OVERVIEW → DESIGN → IMPLEMENTATION → TODO structure. No language is required by the method |
| `README_UserGuide.md`, `README_UserGuide_ZH.md` | Standalone guides that explain how to use the prompts, who uses them, when to apply them, and where to put them |

> **Why a "source of truth" matters.** When two documents disagree, someone must decide which one wins. CaTDD makes that decision once: methodPrompts wins. Every other layer is a projection of it.

### Layer 2: slashCommands — The Commandization Layer

`slashCommands/` turns the stable steps of the method into commands you can invoke. It is the bridge between method semantics and the tool you happen to use: Copilot, Cline, Continue, or `utCodeAgentCLI`.

The rule is simple:

```
   methodPrompts  ──defines──►  what must happen
   slashCommands  ──wraps────►  how to ask for it

   if a command and the method disagree:
        methodPrompts wins
```

The layer contains:

| Part | Location | What it is |
|---|---|---|
| Flow documents | `flows/` | P0-FuncTestsFlow, P1-DesignTestsFlow, P2-QualityTestsFlow, Px-SpecFlow. Each flow is a repeatable command sequence with entry points, gates, and loop-back paths |
| Kit documents | `kits/` | Px-HarnessKits groups the `HARNESS_*` tool points that maintain CaTDD source, adapters, execution, diagnostics, and patch-back safety, without forcing a strict lifecycle |
| Command templates | `UT_slashCommandTemplate.md`, `SPEC_slashCommandTemplate.md` | The shared shape every command follows: Command Header / CoT Pattern / WHO / WHAT / WHEN / WHERE / WHY / HOW / Input Contract / Output Contract / CodeAgent Compatibility. The SPEC template adds a Subagent Recommendation |
| Command files | `commands/` | The three families `UT_*`, `SPEC_*`, and `HARNESS_*`, grouped by flow or kit. Each file tells a CodeAgent what to read, what to produce, what to preserve, and what to do next |

### Layer 3: codeAgents — The Execution Layer

`codeAgents/` describes the CaTDD-native agents. Today these are design and architecture specifications; the runnable implementations are in progress. Two agents are defined.

```
  developer goal
        │
        ▼
  ┌───────────────────┐      ┌────────────────────────┐
  │ utCodeAgentCLI    │      │ specCodeAgentCLI       │
  │ unit testing      │      │ specification          │
  ├───────────────────┤      ├────────────────────────┤
  │ plans from method │      │ runs module-level      │
  │ constraints       │      │ SpecCoding flow        │
  │ invokes UT_*      │      │ invokes SPEC_*         │
  │ collects traces   │      │ reuses utCodeAgentCLI  │
  │ reflects and      │      │ keeps traceability     │
  │ feeds back        │      │ from intent to checks  │
  └───────────────────┘      └────────────────────────┘
        └───────────────┬───────────────┘
                        ▼
              spec  →  unit tests  →  results
```

- **`utCodeAgentCLI`** takes a developer goal, plans the work from CaTDD method constraints, invokes standardized slash command steps, collects traces, reflects on the outcome, and feeds reusable patterns back into the method and command layers. It preserves the design skeleton contract, US/AC/TC traceability, category classification, and the RED/GREEN status discipline.

- **`specCodeAgentCLI`** orchestrates module-level SpecCoding from input to output. It is built on Px-SpecFlow, reuses the unit-testing strength of `utCodeAgentCLI`, and organizes scenario-level verification from spec intent to executable checks. It keeps traceability between the spec flow, the validation checkpoints, and the implementation outcome.

### Layer 4: agentSkills — The Packaging Layer

`agentSkills/` packages CaTDD and SpecCoding as skills any CodeAgent can pick up. Two are authored:

1. **`comment-alive-test-driven-development`** — the CaTDD testing method as a skill: WHO / WHAT / WHEN / WHERE / WHY sections, phase-by-phase instructions, input and output contracts, constraints, and validation rules. When a developer says "use CaTDD", this skill gives the agent everything it needs.

2. **`user-story-centered-spec-coding`** — the SpecCoding lifecycle as a skill. It covers the full story path `pendingNews → todoUS → doingUS → doneUS`, with `abortUS` preserving unsafe active stories for later analysis, and CaTDD as the default unit-testing method.

The packaging script `makeSkill.sh` produces self-contained distributable packages by copying references from `methodPrompts/` and `slashCommands/`. The authored source is the durable asset; the packages are build output.

---

## The Feedback Loop

The four layers are not a one-way pipe. Information flows back up.

```
   methodPrompts ──► slashCommands ──► codeAgents
         ▲                ▲                │
         │                │                │
         └────────────────┴────────────────┘
                    feedback loop
```

| Direction | What moves |
|---|---|
| methodPrompts → slashCommands | Stable method steps become slash commands |
| methodPrompts → codeAgents | Method semantics constrain what agents may do |
| slashCommands → codeAgents | Agents invoke standardized command steps |
| slashCommands → methodPrompts | Running commands exposes gaps in the method |
| codeAgents → slashCommands | Reflection finds reusable command patterns |
| codeAgents → methodPrompts | Real execution experience improves the methodology |

**Why the loop matters.** A method that cannot learn from being used turns into folklore. Every downstream layer both consumes and improves the layers above it, so CaTDD evolves from real usage rather than from theory.

**Example — a gap found by using it.** A CodeAgent repeatedly stops mid-flow because the command it just ran never says which command comes next.

```
today    : command ends → agent guesses → wrong next step → rework
feedback : "Output Contract must name the next command"
result   : the template is updated once, every command benefits
```

One fix in `slashCommands/` removes the same confusion from every future run.

---

## The Design Skeleton Contract

In CaTDD, "design" is not a UML diagram or a Word file. It is a **reusable comment skeleton inside the test file**.

Every skeleton is organized by two labels:

- **Class** — the priority family: `P0 Functional`, `P1 Design`, `P2 Quality`, `P3 Addons`
- **Category** — the verification angle: `Typical`, `Edge`, `Misuse`, `Fault`, `State`, `Capability`, `Interaction`, `Concurrency`, `Performance`, `Robust`, `Compatibility`, `Configuration`, `Diagnosis`, `Security`, `Demo/Example`

Every skeleton keeps this minimum shape:

```text
//=================================================================================================
// [Class] / [Category] Design Skeleton
//=================================================================================================
// @[SUT]: [Declared SUT matching file overview]
// @[TestLevel]: UnitTesting (or SysTesting / UserTesting)
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

Read the skeleton as a set of promises:

```
   @[SUT]        what is under test        → stops scope creep
   @[TestLevel]  unit / system / user      → sets how deep to test
   @[Intent]     what this proves          → the one-sentence "why"
   @[UseWhen]    when it applies           → protects the category
   @[AvoidWhen]  when to move elsewhere    → prevents misclassification
   @[US] [AC]    what requirement it serves→ traceability upward
   @[TC]         the cases and their status→ the work list
```

This skeleton is the contract that developers and CodeAgents both honor. A developer fills it with verification intent. A CodeAgent reads it and writes test code that satisfies that intent. Both sides update it as the code evolves.

> **What the contract buys you.** A new engineer, or a new LLM session, can open the file and answer "what does this prove, for whom, and what is still missing?" without asking anyone.

**Example — an empty skeleton beats an empty promise.** A reviewer asks "is the full-queue path covered?" Two possible answers:

```
   file with a skeleton                     file without one
   ────────────────────                     ────────────────
   // @[Category]: Edge                     (nothing)
   // @[Intent]: queue boundary behavior
   // @[TC]: TC-1 ⚪ TODO                   "I think so?"
          "not yet — TC-1 is still TODO"    (search code for 20 minutes)
```

The skeleton turns an unanswerable question into a status line.

---

## The Priority Framework

Not every test is equally urgent. CaTDD sorts tests into four priority levels and gives a default order to run them in.

```
                     default order

   P0 Functional ──► P1 Design ──► P2 Quality ──► P3 Addons ──► release
   "does it work?"   "is the      "is it fast,    "can someone
                      design       stable, safe,   learn from it?"
                      right?"      compatible?"
```

| Level | Question it answers | Categories |
|---|---|---|
| **P0 Functional** | Does it work, and does it fail safely? | Typical, Edge, Misuse, Fault |
| **P1 Design** | Are the architectural decisions real? | State, Capability, Interaction, Concurrency |
| **P2 Quality** | Does it hold up under real conditions? | Performance, Robust, Compatibility, Configuration, Diagnosis, Security |
| **P3 Addons** | Can others learn to use it? | Demo/Example |

### P0: Functional Testing

P0 has two halves. One proves the system works; the other proves it fails in a controlled way.

```
   P0 Functional = ValidFunc + InvalidFunc

   ValidFunc   ── the system works correctly
      │  Typical   core happy path
      │  Edge      boundaries, limits, modes
      │
   InvalidFunc ── the system fails gracefully
      │  Misuse    the caller used the API wrongly
      │  Fault     the outside world failed
```

#### ValidFunc — Proves the system works correctly

| Category | What it covers | Example test points |
|---|---|---|
| **Typical** ⭐ | Core happy-path workflows | Service registration, event publishing, command execution |
| **Edge** 🔲 | Boundary values, limits, modes | Min/max values, empty inputs, Block / NonBlock / Timeout modes |

#### InvalidFunc — Proves the system fails gracefully

| Category | What it covers | Example test points |
|---|---|---|
| **Misuse** 🚫 | Incorrect API usage | Wrong call sequence, double init, invalid parameters |
| **Fault** ⚠️ | Outside failures and recovery | Network failure, disk full, process crash recovery |

> **Why split ValidFunc and InvalidFunc?** A function that passes every success case can still corrupt data on the first bad call. The two halves catch different bugs, and both belong to P0.

### P1: Design-Oriented Testing

P1 tests the architectural decisions: state, limits, collaboration order, and concurrency. These are the choices that are expensive to change later.

| Category | What it covers | Example test points |
|---|---|---|
| **State** 🔄 | Lifecycle and state machines | `Init → Ready → Running → Stopped` |
| **Capability** 🏆 | Designed capacity and limits | Max connections, queue limits, pool exhaustion |
| **Interaction** 🔗 | Collaborator order and handoffs | Orchestrator → plugin order, validate-before-dispatch, rollback after partial failure |
| **Concurrency** 🚀 | Threads and races | Parallel access, deadlock, lock-free validation |

**Example — Design versus functional.** Registering a plugin is a Typical test. The rule that *all plugins must be validated before any plugin is dispatched* is an Interaction test. The first checks a feature; the second checks an architectural promise.

### P2: Quality-Oriented Testing

P2 covers non-functional requirements: speed, stability, compatibility, configuration, diagnosability, and security.

| Category | What it covers | Example test points |
|---|---|---|
| **Performance** ⚡ | Speed, throughput, resources | Latency benchmarks, memory growth |
| **Robust** 🛡️ | Stress, repetition, long runs | 1000x repetition, 24-hour soak |
| **Compatibility** 🔄 | Platforms, versions | Windows / Linux / macOS, API version compatibility |
| **Configuration** 🎛️ | Settings and deployment | Debug versus Release, feature flags, environment variables |
| **Diagnosis** 🔎 | Observability and evidence | Correlation IDs in logs, actionable errors, health output |
| **Security** 🔐 | Protection under threat | AuthN / authZ denial, secret redaction, trust boundaries, injection defense |

### P3: Addons Testing

| Category | What it covers |
|---|---|
| **Demo/Example** 🎨 | End-to-end demonstrations, tutorials, and best-practice illustrations |

### Default Test Order

```
   P0:  Typical → Edge → Misuse → Fault
   P1:  State → Capability → Interaction → Concurrency
   P2:  Performance → Robust → Compatibility → Configuration → Diagnosis → Security
   P3:  Demo/Example
```

This is the default, not a law. The rest of this section explains when to move a category earlier.

---

## Context-Specific Priority Adjustments

Different products carry different risk. A device driver and a batch report generator should not be tested in the same order. CaTDD lists adjustment rules for common situations.

```
             default order            adjusted order
   ┌──────────────────────────┐   ┌──────────────────────────┐
   │ P0 Typical Edge Misuse   │   │ P0 Typical Edge Fault    │
   │    Fault                 │   │    Misuse                │
   │ P1 State Capability ...  │   │ P1 State Capability ...  │
   │ P2 Performance Robust    │   │ P2 Robust Performance    │
   └──────────────────────────┘   └──────────────────────────┘
                                    reliability-critical service
```

### New Public API

```
P0: Typical → Edge → Misuse → Fault       (complete P0 thoroughly)
P1: State → Capability → Interaction → Concurrency
P2: Performance
```

*Why*: the API contract must be correct before anything advanced is worth testing.

### Stateful/FSM-Heavy Component

```
P0: Typical → Edge                        (basic functional first)
P1: State (promoted early) → Capability → Interaction → Concurrency
P0: Misuse → Fault                        (finish functional coverage)
P2: Performance → Robust
```

*Why*: the state machine is the architectural core. Test it right after basic function works.

### Reliability-Critical Service

```
P0: Typical → Edge → Fault (promoted) → Misuse
P1: State → Capability → Interaction → Concurrency
P2: Robust (promoted) → Performance → Compatibility
```

*Why*: when downtime is expensive, error handling and stability outrank feature breadth.

### High-Performance System (SLOs)

```
P0: Typical → Edge → Misuse
P2: Performance (promoted) → Robust
P1: State → Capability → Interaction → Concurrency
P0: Fault                                 (finish functional coverage)
```

*Why*: when a latency budget is a design constraint, measuring it early prevents a redesign later.

### Highly Concurrent Design

```
P0: Typical → Edge → Misuse
P1: Concurrency (promoted first) → State → Capability → Interaction
P0: Fault                                 (finish functional coverage)
P2: Performance → Robust
```

*Why*: thread safety is the foundation everything else sits on.

### Data Processing Pipeline

```
P0: Typical → Edge → Fault → Misuse
P2: Performance (promoted) → Robust (promoted)
P1: State → Capability → Interaction → Concurrency
```

*Why*: data integrity and throughput are the quality attributes that define the product.

> **Common mistake** — promoting a category and then never finishing P0. A promoted category is a *temporary* reorder. The rule that P0 completes before P1 still holds.

---

## Risk-Driven Priority Adjustment

When a component fits none of the situations above, score the risk instead of guessing.

```
   Risk Score = Impact × Likelihood × Uncertainty

   Impact        1 (low)      →  3 (critical)
   Likelihood    1 (rare)     →  3 (frequent)
   Uncertainty   1 (known)    →  3 (unknown)

   maximum score: 27
```

Then move the category:

| Score | Action |
|---|---|
| ≥ 18 | Move it immediately after Edge |
| 12 – 17 | Move it up 2 positions |
| 9 – 11 | Move it up 1 position |
| ≤ 8 | Keep the default position |

**Example — two categories, two very different scores.**

```
Concurrency in a multi-threaded queue
  Impact       3   data corruption
  Likelihood   3   many threads touch the queue
  Uncertainty  3   interactions are hard to reason about
  ─────────────────────────────────────────────────
  Score       27   → test right after Edge

Performance in a batch processor
  Impact       2   slower, but still correct
  Likelihood   2   depends on the load
  Uncertainty  2   some benchmarks already exist
  ─────────────────────────────────────────────────
  Score        8   → keep the default position
```

> **Why multiply instead of add?** Multiplying keeps a category low when *any* factor is low. A rare failure with huge impact and unknown behavior still scores 18 and moves up; a harmless and well-understood one does not.

---

## The US/AC/TC Contract

CaTDD connects a human need to a machine check with three linked artifacts. Each one answers a different question, and each one points at the next.

```
   User Story (US)          Acceptance Criteria (AC)        Test Case (TC)
   ───────────────          ───────────────────────        ─────────────
   why anyone cares    ──►  what must be true      ──►     how we check it

   business value           testable condition             concrete assertion

        └────────────────────────┴──────────────────────────────┘
                       every TC cites an AC, every AC cites a US
```

### User Story (US) Template

```text
US-n: As a [specific role/persona],
      I want [specific capability or feature],
      So that [concrete business value or benefit].
```

A module usually carries 2–5 User Stories. Each one should represent a distinct piece of user value, not a piece of code.

**Example from the IOC Event System:**

```text
US-1: As an event producer in high-load scenarios,
      I want to post events without blocking when the queue is full,
      So that my application remains responsive under load.
```

> **Test for a good US:** can a product owner read it and say "yes, that is what I asked for"? If only an engineer can judge it, it is too technical.

### Acceptance Criteria (AC) Template

```text
AC-n: GIVEN [initial context and preconditions],
      WHEN [specific trigger, action, or event],
      THEN [expected observable outcome or behavior],
       AND [additional expected outcomes if any].
```

Define 1–4 ACs per User Story. Each AC must be verifiable on its own.

**Example:**

```text
AC-1: GIVEN an event producer calling IOC_postEVT_inConlesMode,
      WHEN IOC's EvtDescQueue is full in ASyncMode by blocking consumer,
      THEN producer returns immediately without waiting,
       AND returns IOC_RESULT_TOO_MANY_QUEUING_EVTEDESC,
       AND the event is not queued for processing.
```

This is one sentence, and it already tells the tester three separate facts to check.

### Test Case (TC) Template

```text
[@AC-n,US-n]
 TC-n:
   @[Name]: verifyBehavior_byCondition_expectResult
   @[Purpose]: Why this test matters and what it validates
   @[Brief]: What the test does in simple terms
   @[Steps]: Detailed execution steps (optional, for complex tests)
   @[Expect]: How to verify success
   @[Notes]: Additional context, gotchas, or dependencies
```

The name follows one pattern everywhere, so a test name reads like a sentence:

```
verifyServiceRegistration_byValidName_expectSuccess
verifyEventPost_byFullQueue_expectNonBlockReturn
verifyCommandExec_byMultipleClients_expectIsolatedExecution
verifyStateTransition_byInvalidSequence_expectError
       └──── behavior ────┘ └── condition ──┘ └── outcome ──┘
```

### The full chain in one place

A single requirement is traceable end to end:

```
  US-1   a producer must not block when the queue is full
   │
   ├─► AC-1  returns immediately, with IOC_RESULT_TOO_MANY_QUEUING_EVTEDESC
   │    │
   │    ├─► TC-1  verifyEventPost_byFullQueue_expectNonBlockReturn
   │    ├─► TC-2  verifyEventPost_byFullQueue_expectNotQueued
   │    └─► TC-3  verifyEventPost_byFullQueue_expectImmediateReturn
   │
   └─► code    the queue check in IOC_postEVT_inConlesMode
        │
        └─► commit   "AC-1: non-blocking post when queue is full"
```

One AC can produce several TCs, because "returns immediately", "returns this code", and "does not queue the event" are three different claims.

**Example — the same requirement, badly written.** Compare these two ways to record the same intent:

```
Weak AC                                  Strong AC
───────                                  ─────────
"handle full queue properly"             GIVEN the queue is full
                                         WHEN the producer posts
  → what does "properly" mean?           THEN it returns immediately
  → how would a test fail?               AND returns
                                            IOC_RESULT_TOO_MANY_QUEUING_EVTEDESC
                                         AND the event is not queued
```

Only the right-hand version can be turned into a test without asking a question.

---

## The TDD Red→Green Cycle (CaTDD Style)

CaTDD keeps the classic cycle and adds an explicit status for every test case.

```
   ⚪ TODO / PLANNED  ──►  🔴 RED / FAILING  ──►  🟢 GREEN / PASSED
        designed              test written,           test passes,
        in comments           code missing            move to next

        └──────────────────────────────────────────────────────┘
                        status lives in the file
```

| Status | Meaning | What you do next |
|---|---|---|
| ⚪ TODO | The test is designed in comments but not written | Write the test code |
| 🔴 RED | The test exists and fails because production code is missing | Implement the smallest production code that passes |
| 🟢 GREEN | The test passes | Move to the next test case |

> **Never skip RED.** If a test is green the first time you run it, either the code already exists or the test is not checking anything. Both are worth knowing before you trust it.

### The 4-Phase Test Structure

Every test is written in the same four phases, in the same order.

```cpp
TEST(CategoryName, verifyBehavior_byCondition_expectResult) {
    //===SETUP===
    // Create resources and set up the preconditions.

    //===BEHAVIOR===
    printf("🎯 BEHAVIOR: verifyBehavior_byCondition_expectResult\n");
    // Perform the single action this test is about.

    //===VERIFY===
    // Check the outcome. Keep at most three key assertions.

    //===CLEANUP===
    // Release resources and restore the state.
}
```

```
   SETUP ──► BEHAVIOR ──► VERIFY ──► CLEANUP
      │          │           │          │
   preconditions  one     at most    no leaks
   are explicit   action   3 checks   for the next test
```

**Example — why three assertions is a real limit.** One test that checks return code, queue depth, counter value, log output, and thread state fails with a wall of output. You then spend ten minutes finding out which claim broke. Three focused tests fail with one clear message each.

### Why at most 3 assertions per test?

- You can see immediately **what** failed
- Tests stay independent of each other
- Each test has one clear purpose
- Need more checks? Write another test case

---

## Quality Gates

Between priority levels there are gates. A gate is not paperwork; it is a checkpoint that stops a known-bad state from moving forward.

```
   P0 Functional  ──►  ┌ GATE P0 ┐  ──►  P1 Design
                       └─────────┘
                            │
   P1 Design      ──►  ┌ GATE P1 ┐  ──►  P2 Quality
                       └─────────┘
                            │
   P2 Quality     ──►  ┌ GATE P2 ┐  ──►  release
                       └─────────┘
                            │
   P3 Addons      ──►  ┌ GATE P3 ┐  ──►  documentation complete
                       └─────────┘
```

### Gate P0: Before Leaving Functional Testing

Must complete: `ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)`

- All Typical tests GREEN (80–90% core workflow coverage)
- All Edge tests GREEN (boundaries and limits validated)
- All Misuse tests GREEN or documented
- All Fault tests GREEN or documented
- No critical correctness bugs
- **Fast-Fail Six** tests all passing
- Basic memory and resource leak checks clean

**Exit criteria**: the API contract is tested on both the success and the failure path.

### Gate P1: Before Quality-Oriented Testing

- State tests GREEN (if the component is stateful)
- Capability tests GREEN (limits are characterized)
- Interaction tests GREEN (if sequence, collaboration, or handoff rules exist)
- Concurrency tests GREEN (if the component is multi-threaded)
- No known deadlocks or races
- ThreadSanitizer / AddressSanitizer clean
- The architecture matches the design requirements

### Gate P2: Before Release

- Performance tests GREEN (SLOs met, if defined)
- Robust tests GREEN (stress and soak tests pass)
- Compatibility tests GREEN (if multi-platform)
- Configuration tests GREEN (if configurable)
- Diagnosis tests GREEN (when observability or explainability is required)
- Security tests GREEN (when threat, policy, or protection requirements exist)
- Production readiness criteria met

### Optional Gate P3: Documentation Complete

- Demo/Example tests GREEN
- Tutorial code validated
- Best practices documented

> **Common mistake** — treating a gate as a formality because the tests are green. A gate asks "is the *claim* covered?", not "did the run pass?" Fifty green tests that never touch the failure path still fail Gate P0.

---

## The Fast-Fail Six

Six cheap tests catch the majority of API-level mistakes. Run them early, before detailed test design.

```
   ┌──────────────────────────────────────────────────────────────┐
   │  1 null / empty input        4 illegal call sequence         │
   │  2 zero / negative timeout   5 buffer full and buffer empty  │
   │  3 duplicate registration    6 double close / re-init        │
   └──────────────────────────────────────────────────────────────┘
                 minutes to write  →  hours of debugging saved
```

| # | Test | The question it asks |
|---|---|---|
| 1 | **Null / Empty Input** | Does every API reject `NULL` and empty strings with a proper error code? |
| 2 | **Zero / Negative Timeout** | What happens with timeout `0`, `-1`, or `UINT_MAX`? |
| 3 | **Duplicate Registration** | Does double registration return ALREADY_EXISTS? |
| 4 | **Illegal Call Sequence** | What happens if you call before init, or after cleanup? |
| 5 | **Buffer Full / Empty** | Fill to capacity and try one more. Empty it and try one more. |
| 6 | **Double Close / Re-Init** | Is the operation idempotent, or does it return a proper error? |

**Example — the failure these tests prevent.**

```c
// Looks harmless, ships a segfault
handle = IOC_create();
IOC_destroy(handle);
IOC_destroy(handle);          // ← second close, no check anywhere
```

```
   Fast-Fail Test 6 would have caught this at design time:

   IOC_destroy(handle);       →  OK
   IOC_destroy(handle);       →  must return an error, not crash
```

Six small tests, written once, protect every caller of the API.

---

## Test Organization Strategies

CaTDD supports two layouts. Pick by project size, not by preference.

```
   SINGLE FILE                        MULTI-FILE
   ───────────                        ──────────
   test_queue.cxx                     test_queue_funcValidTypical.cxx
     ├── Typical suite                test_queue_funcValidEdge.cxx
     ├── Edge suite                   test_queue_funcInvalidMisuse.cxx
     ├── Misuse suite                 test_queue_funcInvalidFault.cxx
     └── Fault suite                  test_queue_designState.cxx
                                      test_queue_qualityPerformance.cxx
                                        └── one file per category

   < 50 tests                         grows without collisions
   simplest to start                  clearer ownership per category
```

### Single File Strategy (simpler projects, under 50 tests)

Keep every test for a component in one file and organize it with TEST suites per category. Good for small and medium modules, and the fastest way to start.

### Multi-File Strategy (larger projects)

One file per category, using the canonical name `test_{feature}_{category}.<ext>`. `{feature}` is a stable `lower_snake_case` usage slice; `{category}` is a fixed CaTDD token.

| File | Category |
|---|---|
| `test_{feature}_freelyDrafts.cxx` | Exploration and idea capture (Stage-0 drafts) |
| `test_{feature}_funcValidTypical.cxx` | Core workflows |
| `test_{feature}_funcValidEdge.cxx` | Edge cases, boundaries, limits |
| `test_{feature}_funcInvalidMisuse.cxx` | API abuse patterns |
| `test_{feature}_funcInvalidFault.cxx` | Error handling and recovery |
| `test_{feature}_designState.cxx` | State transitions |
| `test_{feature}_designCapability.cxx` | Capability limits and responsibilities |
| `test_{feature}_designInteraction.cxx` | Collaborator sequence and handoffs |
| `test_{feature}_designConcurrency.cxx` | Thread safety |
| `test_{feature}_qualityPerformance.cxx` | SLOs and resource budgets |
| `test_{feature}_qualityRobust.cxx` | Stress and long-running stability |
| `test_{feature}_qualityCompatibility.cxx` | Version, platform, and toolchain compatibility |
| `test_{feature}_qualityConfiguration.cxx` | Feature flags and environment variations |
| `test_{feature}_qualityDiagnosis.cxx` | Observability and failure evidence |
| `test_{feature}_qualitySecurity.cxx` | Protection properties under threat |
| `test_{feature}_addonDemoExample.cxx` | Tutorials and documented examples |

Mature test points move out of the freely-drafts file into their category file. Each feature keeps one file per canonical token; a category with nothing to test keeps `@[NoTestPoints]: <reason>`, which is a living decision rather than an empty file.

> **Why keep a file for a category with no tests?** Because "we decided this does not apply" and "we forgot about it" look identical in a repository. The `@[NoTestPoints]` line makes the decision visible.

**Example — a name that tells you where to look.** A failing build reports `test_queue_designConcurrency.cxx`. You already know the failure is about thread safety, not about the happy path, before you open the file.

---

## The Implementation Tracking Template

Every CaTDD test file carries a TODO / Implementation Tracking section. It lists every test case, its status, and where the work stands.

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

Read it as a dashboard:

```
   ⚪  not written yet        → the backlog for this file
   🔴  written, still failing → what you are working on now
   🟢  passing                → done, and provably done

   every line also names its @[AC] and @[US], so a status
   report can be traced back to a requirement
```

**Example — the section answers the daily question.** "What is left before I can start P1?" You read the P0 block, count the ⚪ and 🔴 lines, and answer in seconds. No separate status meeting and no separate tracker to update.

---

## Design as a Living Contract

CaTDD redefines design. Design is not an activity that finishes before coding starts. It is a living contract that lives in the test file, changes with the code, and is readable by both people and LLMs.

The contract answers five questions, in one place:

```
   ┌──────────────────────────────────────────────────────────┐
   │  1  WHAT MATTERS      User Stories with business value    │
   │  2  WHAT TO VERIFY    Acceptance Criteria, GIVEN/WHEN/THEN│
   │  3  HOW TO VERIFY     Test Cases with concrete assertions │
   │  4  WHAT PRIORITY     P0 → P1 → P2 → P3                   │
   │  5  WHAT STATUS       ⚪ → 🔴 → 🟢                        │
   └──────────────────────────────────────────────────────────┘
                       the design skeleton holds all five
```

This is the foundation of everything else in CaTDD. It is what `methodPrompts` defines, what `slashCommands` operationalizes, what `codeAgents` execute, and what `agentSkills` package. Every other layer depends on these concepts.

---

## From Concepts to Action

The remaining chapters move from *what* to *how*.

```
   Ch 1  defineConcepts     ── the vocabulary            (you are here)
    │
   Ch 2  chatVibeCoding     ── talk to an LLM, with structure
    │
   Ch 3  callSlashCommands  ── run the command flows
    │
   Ch 4  asyncCodeAgent     ── let an agent do the work
    │
   Ch 5  applyClassicSWE    ── the TDD / BDD / DDD foundation
    │
   Ch 6  beyondXyzSpec      ── where CaTDD sits next to other tools
```

| Chapter | Chapter | What you get |
|---|---|---|
| **Chapter 2** | chatVibeCoding | How to work with an LLM in chat, and the difference between VibeCoding and SpecCoding |
| **Chapter 3** | callSlashCommands | How to invoke the slash command system for repeatable execution |
| **Chapter 4** | asyncCodeAgent | How code agents automate test design, test implementation, and the SpecCoding lifecycle |
| **Chapter 5** | applyClassicSWE | The Knowledge Book of Software Engineering (TDD, BDD, DDD) and how CaTDD combines them |
| **Chapter 6** | beyondXyzSpec | How CaTDD compares with other spec-driven tools, and what it adds |
