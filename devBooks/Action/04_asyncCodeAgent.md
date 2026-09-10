# 04 asyncCodeAgent

## What Is a Code Agent?

A code agent is a tool that runs a development task by itself. It reads the method, plans the work, invokes commands, writes code, runs tests, collects results, and feeds what it learned back into the method. It is not a chatbot waiting for the next prompt — it is an execution engine that keeps going until it hits a checkpoint.

In CaTDD, code agents are the third layer of the four-layer architecture:

```
   methodPrompts    ← what to do        (categories, priorities, gates)
        ↓
   slashCommands    ← how to invoke it  (one step per command)
        ↓
   codeAgents       ← who executes it   (this chapter)
        ↓
   agentSkills      ← how to package it (for other agents to load)
```

The code agent is the **intelligent execution layer**. It is where reusable CaTDD knowledge turns into opinionated, CaTDD-native execution — and where results flow back up to improve the method.

---

## The Two Code Agents

MyCaTDD defines two agents with different scopes. One owns unit tests. The other owns the story lifecycle.

```
   specCodeAgentCLI  ── owns the story ──────────────────────────────┐
   import → analyze → open → plan → route → commit → close           │
                        │                                            │
                        └─ hands off test work ──► utCodeAgentCLI    │
                                                   owns the tests    │
                                                   design → RED →    │
                                                   GREEN → review ───┘
```

### utCodeAgentCLI — The Unit Testing Agent

`utCodeAgentCLI` is the CaTDD-native unit-testing agent. It focuses on one concern: turning a developer goal into verified unit tests.

**What it does**:

- Takes a developer goal, for example "design and implement P0 functional tests for the EventQueue API"
- Plans work from CaTDD method constraints: priority order, category rules, quality gates
- Invokes standardized slash command steps (`UT_designTypicalSkeleton`, `UT_implTestCase`, and so on)
- Collects execution traces: what ran, what passed, what failed, what was blocked
- Reflects on outcomes: were the results correct, did anything unexpected happen?
- Feeds reusable patterns back into methodPrompts and slashCommands

**What it does NOT do**:

- It does not decide product intent — the developer owns that
- It does not redefine CaTDD method semantics — methodPrompts owns that
- It does not manage the SpecFlow lifecycle — `specCodeAgentCLI` owns that, or you drive it directly

### specCodeAgentCLI — The Specification Agent

`specCodeAgentCLI` is the SpecCoding-oriented agent. It focuses on the whole module-level flow, from issue import to story closure.

**What it does**:

- Follows Px-SpecFlow lifecycle rules
- Reuses `utCodeAgentCLI`'s unit-testing strengths for test design and implementation
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

Together the two agents cover the full path from "we have a feature request" to "tests pass, code is committed, story is closed."

---

## The CaTDD-Native Contract

A CaTDD-native code agent is not a generic LLM wrapper with a method prompt stapled on. It has six obligations:

```
   ┌──────────────────────────────────────────────────────────────────┐
   │  1  preserve comment skeletons    @[US] @[AC] @[TC] are structure│
   │  2  follow priority discipline    P0 before P1, Typical before   │
   │                                   Edge, respect risk scoring     │
   │  3  maintain traceability         TC → AC → US, across files     │
   │  4  respect quality gates         stop and verify, never skip    │
   │  5  honor status markers          keep ⚪ 🔴 🟢 accurate         │
   │  6  feed back upstream            new patterns → slashCommands,  │
   │                                   method gaps → methodPrompts    │
   └──────────────────────────────────────────────────────────────────┘
```

1. **Preserve comment skeleton contracts** — the agent must read, preserve, and update `@[US]`, `@[AC]`, `@[TC]`, `@[Category]`, and status markers. These are structural, not cosmetic.
2. **Follow priority discipline** — complete P0 before P1, Typical before Edge, and respect context-specific priority adjustments and risk scoring.
3. **Maintain US/AC/TC traceability** — every test case traces to an acceptance criterion, every acceptance criterion to a user story. The agent preserves those links across files.
4. **Respect quality gates** — the agent stops at each gate and verifies the criteria before advancing to the next priority level.
5. **Honor status markers** — keep ⚪→🔴→🟢 markers accurate and synchronized between test files and TODO tracking sections.
6. **Feed back to upstream layers** — when it finds a pattern worth reusing, it feeds it back to slashCommands (new command flows) and methodPrompts (method refinements).

Obligations 3 and 5 are what make an agent's work reviewable by someone who was not present. Without them, a run produces tests that only the agent understands.

---

## The Agent Workflow Checklist

The method prompt defines a four-phase Agent Workflow Checklist. This is the execution script every CodeAgent follows.

```
   PHASE 1        PHASE 2          PHASE 3            PHASE 4
   Understand  →  Design       →   Implement      →   Finalize
   read-only      comments         RED → GREEN        clean up,
   checkpoint 1   checkpoint 2     gate checkpoints   document,
                                                      report
```

### Phase 1: Understanding (Read-Only Analysis)

Before any design or implementation, the agent must:

1. **Read component interface files** — locate and read API headers; identify public functions, data structures, constants, signatures, and return types.
2. **Study existing related tests** — search for existing test files, review similar test patterns, identify reusable fixtures and helper functions.
3. **Identify dependencies and constraints** — check build files for dependencies, review design documentation, read source implementation when needed, note special build requirements.
4. **Clarify ambiguities with the developer** — if API behavior is unclear, ask specific questions. If requirements are ambiguous, propose alternatives. If context is insufficient, request specific files.

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

The agent stops here. It does not start designing until the developer confirms the understanding is right.

This stop is not politeness. Phase 1 is the cheapest place to discover that the agent read the wrong header — one question now versus a full design rewrite later.

### Phase 2: Design (Comment Writing — No Code Yet)

The agent writes the test design as structured comments:

1. **Fill the OVERVIEW section** — WHAT, WHERE, WHY, SCOPE (in-scope vs out-of-scope), KEY CONCEPTS.
2. **Define Coverage Matrix dimensions** — pick 2–3 key dimensions for systematic coverage, build the table of combinations, and map combinations to candidate User Stories.
3. **Write User Stories (2–5)** — As a [role], I want [capability], so that [value]. Each story independently valuable, covering success and error scenarios.
4. **Write Acceptance Criteria (2–4 per US)** — GIVEN/WHEN/THEN format, independently testable, specific about expected behaviors and error codes.
5. **Detail Test Cases (1+ per AC)** — Name, Purpose, Brief, Steps, Expect, Notes. Classify with the priority framework, and mark every one ⚪ TODO.
6. **Populate the TODO tracking section** — every planned test case with its status, priority indicator, and dependency/blocker notes.

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

This is the longest phase, because it walks the full RED→GREEN cycle by priority level.

#### 3A: Fast-Fail Six (Quick Validation)

The agent implements these six tests first, because they catch API contract violations early:

1. Null/Empty input handling
2. Zero/Negative timeout
3. Duplicate registration/subscription
4. Illegal call sequence (before init, after cleanup)
5. Buffer full/empty boundaries
6. Double-close/re-init idempotency

All six are marked 🔴 RED, run, confirmed failing, and reported together. Six cheap tests, one report — that is the fastest way to learn whether the API contract is what everyone assumed.

#### 3B: P0 Functional — ValidFunc (Typical + Edge)

The agent works through Typical, then Edge:

```
   implement test (SETUP / BEHAVIOR / VERIFY / CLEANUP)
        ↓
   mark 🔴 RED  →  run  →  confirm it fails
        ↓
   implement minimal production code
        ↓
   run  →  confirm GREEN  →  mark 🟢 GREEN  →  commit
        ↓
   next test
```

#### 3C: P0 Functional — InvalidFunc (Misuse + Fault)

The same cycle, for Misuse then Fault.

**Gate P0 checkpoint** — before proceeding to P1, the agent must verify:

```
   ✅ all P0 ValidFunc tests GREEN          (Typical + Edge)
   ✅ all P0 InvalidFunc tests GREEN        (Misuse + Fault)
   ✅ Fast-Fail Six all passing
   ✅ code coverage ≥80% for tested modules
   ✅ no memory leaks (run with sanitizers)
   ✅ no critical functional bugs
```

The agent reports gate status and asks: "P0 Complete. Proceed to P1?"

#### 3D: P1 Design-Oriented Testing (If Applicable)

State → Capability → Interaction → Concurrency, following the same RED→GREEN cycle.

**Gate P1 requirements**: ThreadSanitizer/AddressSanitizer clean, no deadlocks, no race conditions, interaction/collaboration contracts verified against their design source, architecture validated against design requirements.

#### 3E: P2 Quality-Oriented Testing (If Required)

Performance → Robust → Compatibility → Configuration → Diagnosis → Security.

**Gate P2 requirements**: performance SLOs met, stress/soak tests passing, diagnosis/observability evidence verified where required, security protection tests GREEN where a threat model or policy applies, production readiness criteria met.

### Phase 4: Finalization and Documentation

The agent:

1. Refactors tests for clarity — extract common fixtures, remove duplicates, simplify
2. Updates documentation — comments match the real implementation, obsolete TODO items removed
3. Documents known limitations or issues
4. Marks all completed tests 🟢 GREEN
5. Provides a completion report

**Final checkpoint**:

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

The method prompt defines a troubleshooting guide for agents. Six issues cover most failure modes.

```
   compile fails        → check includes and real signatures
   design looks wrong   → re-check the TC → AC → US chain
   behavior unclear     → search, read docs, then ask with options
   test fails oddly     → check setup, add diagnostics, check isolation
   blocked              → mark 🚫 BLOCKED, propose options, keep working
   passes when RED      → investigate before celebrating
```

### Issue 1: Test Compilation Fails

The agent resolves it by:

1. Checking `#include` statements against the project's include patterns
2. Verifying function signatures against header files — not against its own assumptions
3. Checking for missing test utility functions
4. Asking the developer with the specific error details and what was already checked

### Issue 2: Test Design Seems Incomplete or Wrong

The agent resolves it by:

1. Verifying alignment of the TC → AC → US traceability chain
2. Checking coverage matrix completeness — expected scenarios versus actual ones
3. Validating test expectations against known behavior
4. Reviewing the Fast-Fail Six checklist for missing coverage

### Issue 3: Production Code Behavior Unclear

The agent resolves it by:

1. Searching for similar patterns in the codebase — error codes, AC examples, naming patterns
2. Reading component documentation in order: spec → architecture → glossary → design docs → source notes
3. Examining existing tests for a behavior specification
4. Asking the developer with 2–3 concrete alternatives, not an open-ended "what should this do?"

Step 4 is the difference between a useful question and a stall:

```
   weak:    "What should IOC_post(NULL) do?"
   useful:  "Either (A) return IOC_RESULT_INVALID_PARAM and leave the queue
             untouched, or (B) treat NULL as a no-op and return SUCCESS.
             Existing tests in IOC_Test.cxx assume (A). Which is correct?"
```

### Issue 4: Test Fails Unexpectedly

The agent resolves it by:

1. Verifying the test setup is correct — initialization, preconditions, resource creation
2. Adding diagnostic output: actual vs expected values, intermediate state
3. Checking test isolation — cleanup in previous tests, global state pollution
4. Reporting findings with specific expected/actual values and the diagnostic output

### Issue 5: Unable to Proceed / Blocked

The agent resolves it by:

1. Clearly stating the blocker: what is missing, the impact, and the workarounds considered
2. Documenting it in the TODO section with a 🚫 BLOCKED marker, its dependency, and an effort estimate
3. Proposing concrete next steps with options — implement the missing API first, defer blocked tests, or use a hard-coded constant with a TODO
4. Continuing with unblocked work — never waiting idle

### Issue 6: Test Passes When It Should Fail (RED Phase)

The agent resolves it by:

1. Verifying the test is actually executing — add a printf, add a temporary failing assertion
2. Checking whether the feature already exists — is there production code at the expected location?
3. Verifying the assertions are meaningful, not just "something happened"
4. Updating the test design if needed — mark GREEN if the feature is genuinely complete, strengthen the test if it is too weak

A test that passes before its feature exists is never neutral news. Either the test is weak, or the code was written before the test — and both need an answer.

---

## The Agent's "Do and Don't" Contract

**DO**:

- Ask clarifying questions early, in Phase 1 — before design begins
- Wait for human approval at checkpoints — never auto-advance without confirmation
- Update the TODO section immediately after each test action — status must reflect reality
- Follow strict RED→GREEN discipline — never skip the RED phase
- Commit after each GREEN achievement — small, traceable commits
- Run tests frequently and report failures immediately — no surprises at the end

**DON'T**:

- Skip directly to implementation without design — design is the comment skeleton
- Implement production code before writing tests — that is a TDD violation
- Let tests stay RED without addressing them — RED means "action needed"
- Batch multiple features into one test — one TC, one behavior
- Guess requirements — ask instead
- Implement P1/P2 before completing P0 — priority discipline is not negotiable

```
   DO    →  checkpoint, status, RED first, small commits
   DON'T →  guess, batch, skip design, skip gates, reorder priority
```

---

## Trace Collection and Reflection

A CaTDD code agent is not only an executor — it is a learner. After a session it collects two kinds of records.

### Execution Traces

- What commands were invoked, and in what order
- What files were read and written
- What test cases were designed and implemented
- Which passed (GREEN), which failed (RED), which are blocked (🚫)
- What errors were encountered, and how they were resolved
- What questions were asked of the developer, and what answers came back

### Reflection Notes

- Were there patterns that repeated across multiple test files?
- Were there categories that proved unnecessary for this component?
- Were there categories that, with hindsight, deserved an earlier priority?
- Did the developer's answers consistently suggest a gap in the method prompt?
- Should any troubleshooting resolution become standard agent behavior?

### Feedback Loop

The agent feeds reflections back into the upstream layers:

```
Agent discovers pattern      → formalize as slash command  → slashCommands/
Agent discovers method gap   → refine method prompt        → methodPrompts/
Agent discovers reusable skill → package as agent skill    → agentSkills/
```

This is the bidirectional improvement loop in action: every agent execution improves the method for every future execution. A run that only produced tests spent half its value.

---

## utCodeAgentCLI Architecture

At the current repository stage, `utCodeAgentCLI` is a documented architecture and design contract; the runnable CLI implementation is in progress. The architecture separates two systems:

1. **AgentSDK** — a generic LLM agent runtime library. It knows about goals, messages, tools, sessions, permissions, traces, hooks, adapters, and execution control. **It does not know CaTDD.**
2. **utCodeAgentCLI** — a CaTDD application built on top of AgentSDK. It parses CLI arguments, resolves CaTDD behaviors to portable slash commands, injects method prompt references, preserves US/AC/TC traceability, and records CaTDD execution traces. **It is an orchestrator, not a method owner.**

```
   ┌──────────────────────────────────────────────────────────────┐
   │  utCodeAgentCLI      CaTDD application layer                 │
   │                      behavior → slash command, traces        │
   ├──────────────────────────────────────────────────────────────┤
   │  AgentSDK            generic agent runtime                   │
   │                      goals, tools, sessions, adapters        │
   │                      knows nothing about CaTDD               │
   └──────────────────────────────────────────────────────────────┘
```

This separation is the architecture's most important risk mitigation. A convenient CLI could easily drift into duplicating CaTDD semantics, inventing category meanings, or bypassing portable slash-command contracts. Keeping AgentSDK generic and utCodeAgentCLI thin is what prevents method drift.

### The Test File State Model

`utCodeAgentCLI` tracks each test file through a formal state model:

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
| **FULLY_RED** | All TCs are RED or GREEN, none PLANNED — all test code written |
| **ALL_GREEN** | All TCs are GREEN — tests passing, coverage achieved |

The CLI owns the `PLANNED → RED` transition (writing test code). The `RED → GREEN` transition is **user-owned**: the CLI reads GREEN status but never writes it. That single boundary is what keeps the TDD contract intact — the human, or human-approved production code, turns RED into GREEN.

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

**State preservation guarantees**:

1. Never downgrade status — RED → PLANNED never happens
2. Never overwrite an implemented TC without explicit intent
3. State-mismatched behaviors exit with clear errors
4. Every state transition is recorded in the execution trace

The contract is what makes the CLI safe to run repeatedly: a re-run is not a re-write.

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
| **Error** | Handle agent errors: model failures, malformed outputs, missing artifacts, unmet preconditions |

### CLI Interface Design

```bash
utCodeAgentCLI \
  --goal "Design and implement P0 functional tests for EventQueue" \
  --target codeAgents/utCodeAgentCLI/SysTests/UT_EventQueue.ts \
  --input spec/EventQueue.h \
  --behave designFuncTestsSkeleton \
  --model-tier high-performance
```

`--target` defines the test-space scope: one TestCase in one TestFile, one TestFile, or several TestFiles. `--input` carries source and context: an interface, protocol, schema, draft, or production source. `--behave` names a compatible UT slash-command behavior or a stable CLI alias.

### Runtime Decisions

- **V1 (PoC)**: TypeScript/Node.js — rapid prototyping, easy Adapter SDK integration for Copilot and similar agents
- **V2 (production)**: Go — compiled single binary, zero runtime dependencies, easy distribution
- **Python**: evaluated but not selected — performance concerns for concurrent agent sessions, weaker typing for protocol contracts

### User Story Hierarchy

`utCodeAgentCLI`'s own requirements are organized by role, not by feature:

| Role | Stories | Focus |
|---|---|---|
| **USER** | 10 stories | Guided discovery (NEW-USER) and surgical control (EXPERIENCED-USER) |
| **INVENTOR** | 3 stories | Method delegation verification, traceability integrity, diagnostic proof |
| **DEVELOPER** | 5 stories | Error messages, logging, interactive mode, adapter interface, reliability policy execution |

**USER journeys**: a NEW-USER follows guided discovery (validate → design all skeletons → review all tiers → pick next → design and implement). An EXPERIENCED-USER uses surgical control (validate → single-category design → tier review → implement one TC → review implementation). Both paths produce machine-readable execution traces.

**INVENTOR requirements** keep the CLI a faithful CaTDD delegate: it must reference `methodPrompts` for category semantics (never hardcode them), route through `slashCommands` for portable execution (never bypass them), and produce structured trace files proving both constraints hold.

**DEVELOPER requirements** cover runtime quality: deterministic error messages for every known failure mode, structured logging at configurable levels, an interactive confirmation mode for review gates with a CI-safe non-interactive fallback, a clean adapter boundary for different model runtimes, and executable reliability/safety contracts.

### Non-Requirements (What utCodeAgentCLI Does NOT Own)

What the CLI refuses to own matters as much as what it does:

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

Six reliability and safety requirements sit at the architecture boundary:

| ASR | Requirement | Signal |
|---|---|---|
| **ASR-R1** | Retry and correction loops shall be bounded and deterministic at budget exhaustion | Explicit retry-budget owner and deterministic exhaustion route |
| **ASR-R2** | Unknown or unsupported behavior routing shall be deterministic and diagnosable | No silent coercion; explicit diagnostics fallback |
| **ASR-R3** | Failure handling shall distinguish transient and permanent classes with explicit routing | Failure taxonomy and class-specific control flow |
| **ASR-R4** | Multi-step execution shall define snapshot/rollback or compensation boundary | Step-boundary consistency model and post-failure mutation control |
| **ASR-R5** | Escalation policy shall define threshold and non-interactive behavior | Explicit escalation trigger and CI-safe abort action |
| **ASR-R6** | Shell execution shall enforce safety policy and sensitive-path protection | Allowlist execution model, sensitive-path gating, redaction policy |

These ASRs trace to executable US/AC contracts in the DEVELOPER requirements (US-DEV-05). Each maps to specific acceptance criteria — they are requirements with verification signals, not aspirations.

### Architecture Decision Records (ADRs)

Key architecture decisions are formally recorded as ADRs. **ADR: Runtime Language** is the worked example:

- **V1 (PoC)**: TypeScript on Node.js — the target adapter ecosystem (Copilot SDK, MCP, OpenCode) is Node/TypeScript-native, so TS/Node gives first-class adapters with no cross-language bridge
- **V2 (production)**: Go — pre-selected for production distribution because of its static single-binary output; to be confirmed by a follow-up ADR when production scope opens
- **Python**: evaluated and not selected — scripting velocity does not outweigh adapter integration cost for a PoC

The ADR records the whole decision: issue, decision, status, an alternatives comparison matrix (5 criteria across 3 languages), argument, implications, and traceability to the source story and affected artifacts. That is DDD's knowledge crunching applied to architecture decisions.

### Pipeline Integration

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

`specCodeAgentCLI` orchestrates the larger lifecycle. It follows Px-SpecFlow and reuses `utCodeAgentCLI` for the unit-testing phases.

### Layer Contract

| Concern | Owned By |
|---|---|
| SpecCoding lifecycle rules | Px-SpecFlow (in `slashCommands/flows`) |
| Lifecycle orchestration and sequencing | `specCodeAgentCLI` |
| Unit test design and implementation | `utCodeAgentCLI` (invoked as a sub-agent) |
| CaTDD method semantics | `methodPrompts` |
| Portable command execution units | `slashCommands` |

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

At each step, `specCodeAgentCLI` invokes the corresponding SPEC command and passes control between three owners: the developer (product intent), the SPEC command (lifecycle rules), and `utCodeAgentCLI` (test execution).

### The Sub-Agent Pattern

`specCodeAgentCLI` treats `utCodeAgentCLI` as a sub-agent:

```
specCodeAgentCLI: "Story US-5 is implementation-ready. Design and implement P0 tests."
       │
       ▼
utCodeAgentCLI:  reads methodPrompts, reads test files, plans, executes, collects traces
       │
       ▼
utCodeAgentCLI:  returns "3 Typical, 2 Edge, 1 Misuse tests designed.
                          3 implemented GREEN. 3 ⚪ TODO."
       │
       ▼
specCodeAgentCLI: updates story state → routes to SPEC_reviewProductCodes
```

This separation keeps unit-testing logic out of the lifecycle orchestrator, and lifecycle logic out of the unit-testing agent. Each side can change without destabilizing the other.

---

## Async Code Agent Workflow

Code agents run asynchronously: you define a goal, invoke the agent, and get results when it finishes. Three patterns follow from that.

```
   FIRE-AND-FORGET   one goal, one agent, come back later
   PARALLEL SESSIONS several agents, different scopes, review in a batch
   PIPELINE CHAINING each finished step triggers the next one
```

### Fire-and-Forget

```
Developer: utCodeAgentCLI --goal "Design all P0 skeletons for EventQueue"
Agent:     [works autonomously for several minutes]
Agent:     returns "P0 skeletons complete. 4 categories, 8 US, 14 AC, 22 TC.
                    Ready for review."
```

You define the goal and go do other work. The agent comes back when it is done.

### Parallel Agent Sessions

```
Session A: utCodeAgentCLI   --goal "P0 tests for EventQueue"
Session B: utCodeAgentCLI   --goal "P0 tests for CommandExecutor"
Session C: specCodeAgentCLI --goal "Analyze pending issues into stories"
```

Several agents run at once, each on a different scope. You review the results in a batch. The constraint is human, not technical: three sessions that all need the same architectural decision will produce three different answers.

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

Each agent invocation triggers the next pipeline step. Set the pipeline up once, then monitor the checkpoints.

---

## The Agent's Relationship with Developer Checkpoints

Code agents are autonomous but not unsupervised. CaTDD embeds checkpoints where the developer must approve before the agent continues:

| Checkpoint | Agent State | Developer Action |
|---|---|---|
| After Understanding (Phase 1) | "Ready to proceed with test design?" | Review the understanding summary. Confirm or correct. |
| After Design (Phase 2) | "Shall I proceed with implementation?" | Review the US/AC/TC design. Approve or request revisions. |
| After Gate P0 | "P0 Complete. Proceed to P1?" | Review P0 results. Decide whether P1 is needed. |
| After Gate P1 | "Architecture validated. Proceed to P2?" | Review architecture test results. Decide whether P2 is needed. |
| After Implementation | "Testing complete. Ready to commit?" | Review the final report. Commit or request changes. |

```
   agent runs ──► checkpoint ──► developer decides ──► agent continues
                       ▲                                    │
                       └──── never auto-advance past here ──┘
```

The agent honors the checkpoint contract: it stops at each gate and waits for developer input. It does not auto-advance. That is what preserves the developer's ownership of quality decisions — the agent moves fast, the human stays accountable for what "done" means.

---

## Agent Skills vs Code Agents

Two related concepts, two different audiences:

| Concept | What It Is | Where It Lives |
|---|---|---|
| **agentSkills** | Reusable capability packages for generic CodeAgents (Copilot, Cline) | `agentSkills/` — skill definitions + generated packages |
| **codeAgents** | CaTDD-native CLI agents with built-in methodology knowledge | `codeAgents/` — architecture + future implementation |

```
   agentSkills:  "Here is a skill package. Any CodeAgent can load this and follow CaTDD."
   codeAgents:   "We are CaTDD-native. We know the method, we plan autonomously,
                  and we feed learnings back."
```

- **agentSkills** is for developers using Copilot, Cline, or Continue who want their existing agent to follow CaTDD.
- **codeAgents** is for the CaTDD project itself — first-class automation that depends on no third-party agent.

A Copilot user loads the `comment-alive-test-driven-development` skill pack. A CaTDD-native user invokes `utCodeAgentCLI` directly. Both follow the same method and produce the same structured output. The difference is the execution engine.

---

## The Future of Code Agents

The repository currently documents the intended layer contract for both agents; the runnable implementations are in design and development. The architecture includes:

- **TypeScript-based V1 (PoC)** for `utCodeAgentCLI` — rapid iteration on AgentSDK integration
- **Go-based V2 (production)** for `utCodeAgentCLI` — compiled binary, no runtime dependencies
- **SpecFlow-native execution** for `specCodeAgentCLI` — lifecycle orchestration with built-in traceability

The key insight: code agents are not an afterthought to the method. They are the **destination** of the CaTDD evolution path.

```
   Manual execution    (methodPrompts)   — you read the method, you follow it
          ↓
   Commandized execution (slashCommands) — you invoke one step at a time
          ↓
   Agent-driven execution (codeAgents)   — the agent plans and runs the steps
          ↓
   Packaged reusable capability (agentSkills) — other agents load and reuse it
```

Each layer automates more of the previous layer's manual work. The code agent is where manual becomes autonomous.

---

## From Automation to Integration

Code agents automate the CaTDD workflow. But automation is built on enduring principles — the Knowledge Book of Software Engineering. The next chapter, **applyClassicSWE**, shows how TDD, BDD, and DDD find their full expression in the LLM era through CaTDD's synthesis of all three disciplines.

The agent generates the tests. The pipeline runs them. The team reviews them. CaTDD does not replace your engineering culture — it strengthens it with structured, traceable, LLM-readable verification design.
