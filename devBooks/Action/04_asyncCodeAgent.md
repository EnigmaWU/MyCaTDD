# 04 asyncCodeAgent

## What Is a Code Agent?

A code agent is a software tool that autonomously executes development tasks. It reads method specifications, plans work, invokes commands, produces code, runs tests, collects results, and feeds lessons back into the methodology. It is not a chatbot — it is an execution engine that runs without continuous human prompting.

In CaTDD, code agents are the third layer in the four-layer architecture. They sit below methodPrompts (which defines what to do) and slashCommands (which defines how to invoke steps), and above agentSkills (which packages capabilities for other agents). The code agent is the **intelligent execution layer** — it closes the loop from reusable CaTDD knowledge to opinionated CaTDD-native execution.

---

## The Two Code Agents

MyCaTDD defines two code agents with distinct responsibilities:

### utCodeAgentCLI — The Unit Testing Agent

`utCodeAgentCLI` is the CaTDD-native unit-testing agent. It focuses on one concern: turning developer goals into verified unit tests.

**What it does**:
- Takes a developer goal (e.g., "design and implement P0 functional tests for the EventQueue API")
- Plans work from CaTDD method constraints (priority order, category rules, quality gates)
- Invokes standardized slash command steps (`UT_designTypicalSkeleton`, `UT_implTestCase`, etc.)
- Collects execution traces (what ran, what passed, what failed, what was blocked)
- Reflects on outcomes (were the results correct? did anything unexpected happen?)
- Feeds reusable patterns back into methodPrompts and slashCommands

**What it does NOT do**:
- It does not decide product intent — the developer owns that
- It does not redefine CaTDD method semantics — methodPrompts owns that
- It does not manage the SpecFlow lifecycle — specCodeAgentCLI owns that (or the developer drives it directly)

### specCodeAgentCLI — The Specification Agent

`specCodeAgentCLI` is the SpecCoding-oriented agent. It focuses on module-level flow from input to output — the full lifecycle from issue import to story closure.

**What it does**:
- Based on Px-SpecFlow lifecycle rules
- Reuses utCodeAgentCLI's unit-testing strengths for test design and implementation phases
- Organizes scenario-level verification from spec intent to executable checks
- Keeps traceability between spec flow, validation checkpoints, and implementation outcomes

**The pipeline**:

```text
Developer goal → specCodeAgentCLI (lifecycle orchestration)
                      │
                      ▼
                 SPEC_* commands (import, analyze, design, review)
                      │
                      ▼ (when test-ready)
                 utCodeAgentCLI (unit test design and execution)
                      │
                      ▼
                 UT_* commands (design skeletons, implement TCs, review)
                      │
                      ▼
                 SPEC_* commands (review codes, commit, close story)
```

The two agents together automate the complete path from "we have a feature request" to "tests pass, code is committed, story is closed."

---

## The CaTDD-Native Contract

A CaTDD-native code agent is not a generic LLM wrapper. It has a specific contract with the CaTDD methodology:

1. **Preserve comment skeleton contracts** — The agent must read, preserve, and update `@[US]`, `@[AC]`, `@[TC]`, `@[Category]`, and status markers. These are structural, not cosmetic.

2. **Follow priority discipline** — The agent must complete P0 before P1, Typical before Edge, and respect context-specific priority adjustments and risk scoring.

3. **Maintain US/AC/TC traceability** — Every test case must trace to an acceptance criterion, every acceptance criterion to a user story. The agent must preserve these links across files.

4. **Respect quality gates** — The agent must stop at each gate and verify criteria before advancing to the next priority level. No gate-skipping.

5. **Honor status markers** — The agent must keep ⚪→🔴→🟢 markers accurate and synchronized across test files and TODO tracking sections.

6. **Feed back to upstream layers** — When the agent discovers a pattern that should be reusable, it feeds it back to slashCommands (as new command flows) and methodPrompts (as methodology refinements).

---

## The Agent Workflow Checklist

The CaTDD method prompt defines a complete Agent Workflow Checklist with four phases. This is the execution script for every CodeAgent:

### Phase 1: Understanding (Read-Only Analysis)

Before any design or implementation, the agent must:

1. **Read component interface files** — Locate and read API headers, identify public functions, data structures, constants, signatures, and return types.

2. **Study existing related tests** — Search for existing test files, review similar test patterns, identify reusable fixtures and helper functions.

3. **Identify dependencies and constraints** — Check build files for dependencies, review design documentation, read source implementation if needed, note special build requirements.

4. **Clarify ambiguities with the developer** — If API behavior is unclear, ask specific questions. If requirements are ambiguous, propose alternatives. If context is insufficient, request specific files.

**Checkpoint 1 output**:

```
"I've analyzed [component]. It provides [key capabilities].

Files reviewed:
- Interface: Include/[HeaderFile.h]
- Implementation: Source/[SourceFile.c]
- Existing tests: Test/UT_[Related].cxx
- Documentation: README_[Topic].md

Key APIs: [list 3-5 main functions]
Dependencies: [list main dependencies]
Unclear aspects: [list questions if any]

Ready to proceed with test design?"
```

The agent stops here. It does not proceed to design until the developer confirms understanding is correct.

### Phase 2: Design (Comment Writing — No Code Yet)

The agent creates comprehensive test design in structured comments:

1. **Fill OVERVIEW section** — WHAT, WHERE, WHY, SCOPE (in-scope vs out-of-scope), KEY CONCEPTS.

2. **Define Coverage Matrix dimensions** — Identify 2-3 key dimensions for systematic coverage, create table showing dimension combinations, map combinations to potential User Stories.

3. **Write User Stories (2-5)** — As a [role], I want [capability], so that [value]. Each story independently valuable. Covers both success and error scenarios.

4. **Write Acceptance Criteria (2-4 per US)** — GIVEN/WHEN/THEN format, independently testable, specific about expected behaviors and error codes.

5. **Detail Test Cases (1+ per AC)** — Name, Purpose, Brief, Steps, Expect, Notes. Classify using priority framework. Mark all as ⚪ TODO.

6. **Populate TODO tracking section** — All planned test cases listed with status, priority indicators, and any dependency/blocker notes.

**Checkpoint 2 output**:

```
"Test design complete for [component]:
- Coverage: [X] User Stories, [Y] Acceptance Criteria, [Z] Test Cases
- Priority distribution: P0=[count], P1=[count], P2=[count]
- Key scenarios covered: [list 3-5 main scenarios]
- Estimated implementation effort: [rough estimate]

Shall I proceed with implementation?"
```

The agent stops here too. Design approval before implementation is mandatory.

### Phase 3: Implementation (TDD Red→Green Cycle)

This is the most detailed phase because it covers the full Red→Green cycle by priority level.

#### 3A: Fast-Fail Six (Quick Validation)

The agent implements these six tests first because they catch API contract violations early:

1. Null/Empty input handling
2. Zero/Negative timeout
3. Duplicate registration/subscription
4. Illegal call sequence (before init, after cleanup)
5. Buffer full/empty boundaries
6. Double-close/re-init idempotency

All six marked 🔴 RED, run, confirm all fail, report.

#### 3B: P0 Functional — ValidFunc (Typical + Edge)

The agent works through Typical then Edge tests:
- Implements test (4-phase: SETUP/BEHAVIOR/VERIFY/CLEANUP)
- Marks 🔴 RED
- Runs, confirms RED (failing)
- Implements minimal production code
- Runs, confirms GREEN (passing)
- Marks 🟢 GREEN
- Commits
- Moves to next test

#### 3C: P0 Functional — InvalidFunc (Misuse + Fault)

Same cycle for Misuse then Fault tests.

**Gate P0 Checkpoint**: Before proceeding to P1, the agent must verify:
- All P0 ValidFunc tests GREEN (Typical + Edge)
- All P0 InvalidFunc tests GREEN (Misuse + Fault)
- Fast-Fail Six all passing
- Code coverage ≥80% for tested modules
- No memory leaks (run with sanitizers)
- No critical functional bugs

The agent reports gate status and asks: "P0 Complete. Proceed to P1?"

#### 3D: P1 Design-Oriented Testing (If Applicable)

State → Capability → Concurrency, following the same RED→GREEN cycle.

**Gate P1 requirements**: ThreadSanitizer/AddressSanitizer clean, no deadlocks, no race conditions, architecture validated against design requirements.

#### 3E: P2 Quality-Oriented Testing (If Required)

Performance → Robust → Compatibility → Configuration.

**Gate P2 requirements**: Performance SLOs met, stress/soak tests passing, production readiness criteria met.

### Phase 4: Finalization and Documentation

The agent:
1. Refactors tests for clarity (extract common fixtures, remove duplicates, simplify)
2. Updates documentation (ensure comments reflect actual implementation, remove obsolete TODO items)
3. Documents known limitations or issues
4. Marks all completed tests as 🟢 GREEN
5. Provides completion report

**Final Checkpoint**:

```
"Testing complete for [component]:
✅ Tests implemented: [count] (P0=[n], P1=[n], P2=[n])
✅ Test coverage: [percentage]%
✅ All tests passing: [Yes/No]
⚠️ Known issues: [list if any]
🚫 Blocked items: [list if any]

Next steps: [recommendations]"
```

---

## Agent Troubleshooting: The Six Common Issues

The CaTDD method prompt defines a troubleshooting guide for agents. Six issues cover the most common failure modes:

### Issue 1: Test Compilation Fails

**Agent resolves by**:
1. Checking #include statements against the project's include patterns
2. Verifying function signatures against header files (not assumptions)
3. Checking for missing test utility functions
4. Asking the developer with specific error details and what was already checked

### Issue 2: Test Design Seems Incomplete or Wrong

**Agent resolves by**:
1. Verifying alignment: TC → AC → US traceability chain
2. Checking coverage matrix completeness (expected vs actual scenarios)
3. Validating test expectations against known behavior
4. Reviewing the Fast-Fail Six checklist for missing coverage

### Issue 3: Production Code Behavior Unclear

**Agent resolves by**:
1. Searching for similar patterns in the codebase (error codes, AC examples, naming patterns)
2. Reading component documentation in order: spec → architecture → glossary → design docs → source notes
3. Examining existing tests for behavior specification
4. Asking the developer with 2-3 concrete alternatives (not open-ended "what should this do?")

### Issue 4: Test Fails Unexpectedly

**Agent resolves by**:
1. Verifying test setup is correct (initialization, preconditions, resource creation)
2. Adding diagnostic output (printf actual vs expected, intermediate state)
3. Checking test isolation (cleanup in previous tests, global state pollution)
4. Reporting findings to developer with specific expected/actual values and diagnostic output

### Issue 5: Unable to Proceed / Blocked

**Agent resolves by**:
1. Clearly stating the blocker: what's missing, impact, workarounds considered
2. Documenting in the TODO section with 🚫 BLOCKED marker, dependency, and estimated effort
3. Proposing concrete next steps with options (e.g., implement missing API first, defer blocked tests, use hard-coded constant with TODO)
4. Continuing with unblocked work — never waiting idle

### Issue 6: Test Passes When It Should Fail (RED Phase)

**Agent resolves by**:
1. Verifying the test is actually executing (add printf, add temporary failing assertion)
2. Checking if the feature already exists (production code at expected location?)
3. Verifying test assertions are meaningful (not just "something happened")
4. Updating test design if needed — mark GREEN if feature is complete, enhance test if too weak

---

## The Agent's "Do and Don't" Contract

The method prompt defines explicit behavioral rules for agents:

**DO**:
- Ask clarifying questions early (Phase 1) — before design begins
- Wait for human approval at checkpoints — never auto-advance without confirmation
- Update TODO section immediately after each test action — status must reflect reality
- Follow strict RED→GREEN discipline — never skip the RED phase
- Commit after each GREEN achievement — small, traceable commits
- Run tests frequently, report failures immediately — no surprises at the end

**DON'T**:
- Skip directly to implementation without design — design is the comment skeleton
- Implement production code before writing tests — TDD violation
- Let tests stay RED without addressing them — RED means "action needed"
- Batch multiple features into one test — one TC, one behavior
- Guess requirements — ask instead
- Implement P1/P2 before completing P0 — priority discipline is non-negotiable

---

## Trace Collection and Reflection

A CaTDD code agent is not merely an executor — it is a **learner**. After executing a session, it collects:

### Execution Traces

- What commands were invoked and in what order
- What files were read and written
- What test cases were designed and implemented
- Which passed (GREEN), which failed (RED), which are blocked (🚫)
- What errors were encountered and how they were resolved
- What questions were asked of the developer and what answers were received

### Reflection Notes

- Were there patterns that repeated across multiple test files?
- Were there categories that proved unnecessary for this component?
- Were there categories that should have been earlier priority with hindsight?
- Did the developer consistently provide answers that suggest a gap in the method prompt?
- Should any troubleshooting resolution become a standard agent behavior?

### Feedback Loop

The agent feeds reflections back into the upstream layers:

```
Agent discovers pattern → Formalize as slash command → Add to slashCommands/
Agent discovers method gap → Refine method prompt → Update methodPrompts/
Agent discovers reusable skill → Package as agent skill → Update agentSkills/
```

This is the bidirectional improvement loop in action. Every agent execution improves the methodology for every future execution.

---

## utCodeAgentCLI Architecture

At the current repository stage, `utCodeAgentCLI` is a documented architecture and design contract — the runnable CLI implementation is in progress. The architecture separates two systems:

1. **AgentSDK**: a generic LLM agent runtime library. It knows about goals, messages, tools, sessions, permissions, traces, hooks, adapters, and execution control. **It does not know CaTDD.**

2. **utCodeAgentCLI**: a CaTDD application built on top of AgentSDK. It parses CLI arguments, resolves CaTDD behaviors to portable slash commands, injects method prompt references, preserves US/AC/TC traceability, and records CaTDD execution traces. **It is an orchestrator, not a method owner.**

This separation is the architecture's most important risk mitigation: a convenient CLI could easily drift into duplicating CaTDD semantics, inventing category meanings, or bypassing portable slash-command contracts. By keeping AgentSDK generic and utCodeAgentCLI as a thin orchestrator, the architecture prevents method drift.

### The Test File State Model

utCodeAgentCLI tracks each test file through a formal state model:

```
EMPTY ──(designSkeleton)──► DESIGNED ──(implTestCase)──► PARTIAL
                                  │                          │
                                  │                          ▼
                                  │                 FULLY_RED ──(user fixes)──► ALL_GREEN
                                  │
                                  └──(designSkeleton on DESIGNED)──► DESIGNED (adds TCs)
```

| File State | Description |
|---|---|
| **EMPTY** | No CaTDD skeleton TCs exist in the file |
| **DESIGNED** | All TCs are `@[Status:PLANNED]` — design complete, nothing implemented |
| **PARTIAL** | Mix of PLANNED, RED, and GREEN — some implemented, some not |
| **FULLY_RED** | All TCs are RED or GREEN, no PLANNED — all test code written |
| **ALL_GREEN** | All TCs are GREEN — tests passing, coverage achieved |

The CLI owns the `PLANNED → RED` transition (writing test code). The `RED → GREEN` transition is **user-owned** — the CLI reads GREEN status but never writes it. This preserves the TDD contract: the human (or human-approved production code) turns RED into GREEN.

### Behavior State Contract

Every `--behave` value has a precise contract with the file state:

| Behavior | Requires | Produces (TC state) | Produces (file state) |
|---|---|---|---|
| `design*Skeleton` | Any | New TCs → PLANNED | DESIGNED or PARTIAL |
| `review*Skeleton` | DESIGNED, PARTIAL, FULLY_RED | No change | No change |
| `tellMeNextImplTest` | Has ≥1 PLANNED TC | No change | No change |
| `implTestCase` | Target TC is PLANNED | Target TC → RED | PARTIAL or FULLY_RED |
| `implTestFile` | Has ≥1 PLANNED TC | All PLANNED → RED | FULLY_RED |
| `designAndImplTest` | Any | All TCs → RED | FULLY_RED |

**State Preservation Guarantees**:
1. Never downgrade status (RED → PLANNED never happens)
2. Never overwrite an implemented TC without explicit intent
3. State-mismatched behaviors exit with clear errors
4. Every state transition recorded in execution trace

### Core Components

| Component | Responsibility |
|---|---|
| **Parser** | Parse developer commands: `--goal`, `--target`, `--input`, `--behave`, `--model-tier` |
| **Planner** | Decompose goals into ordered sequences of slash command invocations |
| **Executor** | Invoke slash commands against a CodeAgent runtime (model provider + tool surface) |
| **Adapter** | Adapt portable command contracts to specific model runtimes (Copilot API, Cline protocol, direct LLM) |
| **Trace** | Collect structured execution logs: commands, TCs, status transitions, timestamps, errors |
| **Diagnostics** | Validate execution quality: RED→GREEN integrity, gate compliance, traceability preservation |
| **State** | Manage agent session state: active goal, current phase, pending checkpoints |
| **Error** | Handle agent errors: model failures, malformed outputs, missing artifacts, preconditions not met |

### CLI Interface Design

```bash
utCodeAgentCLI \
  --goal "Design and implement P0 functional tests for EventQueue" \
  --target codeAgents/utCodeAgentCLI/tests/UT_EventQueue.ts \
  --input spec/EventQueue.h \
  --behave designFuncTestsSkeleton \
  --model-tier high-performance
```

The `--target` parameter defines the test-space scope: one TestCase in one TestFile, one TestFile, or some TestFiles. The `--input` parameter carries source/context such as interface, protocol, schema, draft, or production source. The `--behave` parameter names a compatible UT slash-command behavior or a stable CLI alias.

### Runtime Decisions

The utCodeAgentCLI architecture design includes these decisions:

- **V1 (PoC)**: TypeScript/Node.js — rapid prototyping, easy Adapter SDK integration for Copilot and similar agents
- **V2 (production)**: Go — compiled single binary, zero runtime dependencies, easy distribution
- **Python**: Evaluated but not selected — performance concerns for concurrent agent sessions, weaker typing for protocol contracts

### User Story Hierarchy

utCodeAgentCLI requirements are organized by role, not by feature:

| Role | Stories | Focus |
|---|---|---|
| **USER** | 10 stories | Guided discovery (NEW-USER) and surgical control (EXPERIENCED-USER) |
| **INVENTOR** | 3 stories | Method delegation verification, traceability integrity, diagnostic proof |
| **DEVELOPER** | 5 stories | Error messages, logging, interactive mode, adapter interface, reliability policy execution |

**USER journeys**: A NEW-USER follows guided discovery (validate → design all skeletons → review all tiers → pick next → design and implement). An EXPERIENCED-USER uses surgical control (validate → single-category design → tier review → implement one TC → review implementation). Both paths produce machine-readable execution traces.

**INVENTOR requirements** ensure the CLI is a faithful CaTDD delegate: it must reference `methodPrompts` for category semantics (never hardcode them), it must route through `slashCommands` for portable execution (never bypass them), and it must produce structured trace files proving these constraints are satisfied.

**DEVELOPER requirements** cover runtime quality: deterministic error messages for every known failure mode, structured logging at configurable levels, an interactive confirmation mode for review gates (with a CI-safe non-interactive fallback), a clean adapter boundary for different model runtimes, and executable reliability/safety contracts.

### Non-Requirements (What utCodeAgentCLI Does NOT Own)

Just as important as what the CLI does is what it explicitly does not:

| Concern | Owned By |
|---|---|
| Define CaTDD categories, discipline rules, or method meaning | `methodPrompts/` |
| Define portable slash-command execution logic | `slashCommands/` |
| Wrap CaTDD as a generic CodeAgent skill | `agentSkills/` |
| Compile, run, or verify test code | User's build system |
| Generate production/source code | CLI produces test code only |
| Manage git branches, commits, or version control | User's workflow |
| Transition TC from RED to GREEN | User's TDD workflow |

### Architecturally Significant Requirements (ASRs)

The utCodeAgentCLI architecture defines six reliability/safety requirements that operate at the architecture boundary level:

| ASR | Requirement | Signal |
|---|---|---|
| **ASR-R1** | Retry and correction loops shall be bounded and deterministic at budget exhaustion | Explicit retry-budget owner and deterministic exhaustion route |
| **ASR-R2** | Unknown or unsupported behavior routing shall be deterministic and diagnosable | No silent coercion; explicit diagnostics fallback |
| **ASR-R3** | Failure handling shall distinguish transient and permanent classes with explicit routing | Failure taxonomy and class-specific control flow |
| **ASR-R4** | Multi-step execution shall define snapshot/rollback or compensation boundary | Step-boundary consistency model and post-failure mutation control |
| **ASR-R5** | Escalation policy shall define threshold and non-interactive behavior | Explicit escalation trigger and CI-safe abort action |
| **ASR-R6** | Shell execution shall enforce safety policy and sensitive-path protection | Allowlist execution model, sensitive-path gating, redaction policy |

These ASRs are traced to executable US/AC contracts in the DEVELOPER requirements (US-DEV-05). Each ASR maps to specific acceptance criteria — they are not aspirational statements but architecture-level requirements that produce verification-ready acceptance signals.

### Architecture Decision Records (ADRs)

Key architecture decisions are formally recorded as ADRs:

**ADR: Runtime Language** — utCodeAgentCLI adopts a staged runtime decision:
- **V1 (PoC)**: TypeScript on Node.js — the target adapter ecosystem (Copilot SDK, MCP, OpenCode) is Node/TypeScript-native, so TS/Node provides first-class adapters with no cross-language bridge
- **V2 (production)**: Go — pre-selected for production distribution because of static single-binary output; to be confirmed by a follow-up ADR when production scope opens
- **Python**: evaluated and not selected — scripting velocity does not outweigh adapter integration cost for a PoC

The ADR records the full decision process: issue, decision, status, alternatives comparison matrix (5 criteria across 3 languages), argument, implications, and traceability to the source story and affected artifacts. This is DDD's knowledge crunching applied to architecture decisions.

### Pipeline Integration

The utCodeAgentCLI is designed to fit into development pipelines:

```
Developer goal → utCodeAgentCLI
                      │
                      ├── Read methodPrompts/ (method constraints)
                      ├── Read slashCommands/ (execution units)
                      │
                      ├── Plan: decompose goal into command sequence
                      ├── Execute: invoke commands via model runtime
                      ├── Trace: collect structured execution logs
                      ├── Reflect: analyze results, identify patterns
                      │
                      └── Output: verified tests + trace log + feedback to layers
```

---

## specCodeAgentCLI Architecture

`specCodeAgentCLI` orchestrates the larger lifecycle. It is based on Px-SpecFlow and reuses `utCodeAgentCLI` for the unit-testing phases.

### Layer Contract

| Concern | Owned By |
|---|---|
| SpecCoding lifecycle rules | Px-SpecFlow (in slashCommands/flows) |
| Lifecycle orchestration and sequencing | specCodeAgentCLI |
| Unit test design and implementation | utCodeAgentCLI (invoked as sub-agent) |
| CaTDD method semantics | methodPrompts |
| Portable command execution units | slashCommands |

### Orchestration Flow

```text
1. Receive: Import issue/feature request
2. Analyze: Convert to user story → todoUS/
3. Open: Move to doingUS/
4. Clear Intent: Align developer and agent intent
5. Plan: Classify work orientation, create task artifact
6. Route:
   ┌─ Requirement-oriented → updateUserStory → reviewUserStory → commit/close
   ├─ Design-oriented → takeArchDesign → review → takeDetailDesign → review
   └─ Implementation-oriented → designUnitTests → implUnitTests → implProductCodes
                                                                       ↓
                                                                 reviewProductCodes
                                                                       ↓
                                                               commitWorks → closeUserStory
```

At each step, specCodeAgentCLI invokes the corresponding SPEC command and passes control between the developer (who owns product intent), the SPEC command (which owns lifecycle rules), and utCodeAgentCLI (which owns test execution).

### The Sub-Agent Pattern

specCodeAgentCLI treats utCodeAgentCLI as a sub-agent:

```
specCodeAgentCLI: "Story US-5 is implementation-ready. Design and implement P0 tests."
       │
       ▼
utCodeAgentCLI:  Reads methodPrompts, reads test files, plans, executes, collects traces
       │
       ▼
utCodeAgentCLI:  Returns: "3 Typical, 2 Edge, 1 Misuse tests designed. 3 implemented GREEN. 3 ⚪ TODO."
       │
       ▼
specCodeAgentCLI: Updates story state. Routes to SPEC_reviewProductCodes.
```

This separation keeps unit-testing logic out of the lifecycle orchestrator and lifecycle logic out of the unit-testing agent.

---

## Async Code Agent Workflow

Code agents operate asynchronously — you define a goal, invoke the agent, and receive results when complete. This enables several patterns:

### Fire-and-Forget

```
Developer: utCodeAgentCLI --goal "Design all P0 skeletons for EventQueue"
Agent:     [Works autonomously for several minutes]
Agent:     Returns: "P0 skeletons complete. 4 categories, 8 US, 14 AC, 22 TC. Ready for review."
```

The developer defines the goal and goes to other work. The agent returns when done.

### Parallel Agent Sessions

```
Session A: utCodeAgentCLI --goal "P0 tests for EventQueue"
Session B: utCodeAgentCLI --goal "P0 tests for CommandExecutor"
Session C: specCodeAgentCLI --goal "Analyze pending issues into stories"
```

Multiple agents run concurrently, each focused on a different scope. The developer reviews results in batches.

### Pipeline Chaining

```
specCodeAgentCLI (analyze issue → story in todoUS/)
       │
       ▼ (triggered by: story moved to doingUS)
specCodeAgentCLI (take detail design → ACs designed)
       │
       ▼ (triggered by: design review PASS)
utCodeAgentCLI (design P0 tests → implement → verify)
       │
       ▼ (triggered by: all P0 tests GREEN)
specCodeAgentCLI (review codes → commit → close → doneUS)
```

Each agent invocation triggers the next step in the pipeline. The developer sets up the pipeline once and monitors checkpoints.

---

## The Agent's Relationship with Developer Checkpoints

Code agents are autonomous but not unsupervised. The CaTDD workflow embeds checkpoints where the developer must approve before the agent continues:

| Checkpoint | Agent State | Developer Action |
|---|---|---|
| After Understanding (Phase 1) | "Ready to proceed with test design?" | Review understanding summary. Confirm or correct. |
| After Design (Phase 2) | "Shall I proceed with implementation?" | Review US/AC/TC design. Approve or request revisions. |
| After Gate P0 | "P0 Complete. Proceed to P1?" | Review P0 results. Decide whether P1 is needed. |
| After Gate P1 | "Architecture validated. Proceed to P2?" | Review architecture test results. Decide whether P2 is needed. |
| After Implementation | "Testing complete. Ready to commit?" | Review final report. Commit or request changes. |

The agent honors the checkpoint contract: it stops at each gate and waits for developer input. It does not auto-advance. This preserves the developer's ownership of quality decisions.

---

## Agent Skills vs Code Agents

It is important to distinguish between two related but different concepts:

| Concept | What It Is | Where It Lives |
|---|---|---|
| **agentSkills** | Reusable capability packages for generic CodeAgents (Copilot, Cline) | `agentSkills/` — skill definitions + generated packages |
| **codeAgents** | CaTDD-native CLI agents with built-in methodology knowledge | `codeAgents/` — architecture + future implementation |

**agentSkills** says: "Here is a skill package. Any CodeAgent can load this and follow CaTDD."

**codeAgents** says: "We are CaTDD-native agents. We know the method, we plan autonomously, and we feed back learnings."

They serve different audiences:

- **agentSkills** is for developers using Copilot/Cline/Continue who want their existing agent to follow CaTDD.
- **codeAgents** is for the CaTDD project itself — building first-class automation that doesn't depend on any third-party agent.

A Copilot user loads the `comment-alive-test-driven-development` skill pack. A CaTDD-native user invokes `utCodeAgentCLI` directly. Both follow the same method. Both produce the same structured output. The difference is the execution engine.

---

## The Future of Code Agents

The current repository documents the intended layer contract for both agents. The runnable implementations are in design and development. The architecture includes:

- **TypeScript-based V1 (PoC)** for utCodeAgentCLI — rapid iteration on AgentSDK integration
- **Go-based V2 (production)** for utCodeAgentCLI — compiled binary, no runtime dependencies
- **SpecFlow-native execution** for specCodeAgentCLI — lifecycle orchestration with built-in traceability

The key insight: code agents are not an afterthought to the method. They are the **destination** of the CaTDD evolution path:

```
Manual execution (methodPrompts)
       ↓
Commandized execution (slashCommands)
       ↓
Agent-driven execution (codeAgents)
       ↓
Packaged reusable capability (agentSkills)
```

Each layer automates more of the previous layer's manual work. The code agent is where manual becomes autonomous.

---

## From Automation to Integration

Code agents automate the CaTDD workflow. But automation is built on enduring principles — the Knowledge Book of Software Engineering. The next chapter, **applyClassicSWE**, shows how TDD, BDD, and DDD find their full expression in the LLM era through CaTDD's synthesis of all three disciplines.

The agent generates the tests. The pipeline runs them. The team reviews them. CaTDD does not replace your engineering culture — it strengthens it with structured, traceable, LLM-readable verification design.
