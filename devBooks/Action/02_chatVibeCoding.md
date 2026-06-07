# 02 chatVibeCoding

## What Is Vibe Coding?

Vibe coding is the practice of using natural language conversations with LLMs to generate code. You describe what you want, the LLM produces an implementation, and you iterate by refining your prompts.

In CaTDD, vibe coding is not an unstructured free-for-all. It is the first mode of LLM interaction — the conversational, exploratory mode where you and a CodeAgent work through design together. But CaTDD adds a crucial distinction: there is unstructured VibeCoding and there is structured SpecCoding. Both have their place, and the method tells you when to use each.

---

## The Two Modes of CaTDD Interaction

In CaTDD terminology, using `methodPrompts` directly in a CodeAgent chat is **VibeCoding**: flexible, method-guided conversation. Using `slashCommands` is **SpecCoding**: structured Spec-Driven Development flow based on the same method definitions.

| Aspect | VibeCoding | SpecCoding |
|---|---|---|
| **Definition** | Flexible, method-guided LLM conversation | Structured flow with explicit lifecycle commands |
| **Method source** | methodPrompts directly | slashCommands (wrapping methodPrompts) |
| **Control** | Developer drives the conversation | Flow commands drive the lifecycle |
| **Artifacts** | Comments, test files, code — ad hoc | SpecFlow artifacts: pendingNews, todoUS, doingUS, doneUS |
| **Traceability** | Optional, depends on developer | Mandatory, enforced by flow |
| **When to use** | Exploration, drafting, brainstorming, quick fixes | Structured delivery, team work, reproducible workflows |
| **Command invocation** | Developer types free-form prompts | Developer invokes `/UT_*` or `/SPEC_*` commands |

---

## When to Use VibeCoding

VibeCoding is the right mode when:

1. **You are exploring a new feature** — You have a rough idea but need the LLM to help you think through coverage dimensions, edge cases, and risks. You paste API headers, ask "what test dimensions should I consider?", and iterate on the LLM's suggestions.

2. **You are freely drafting test ideas** — CaTDD's Stage-0 (Freely Drafting) is pure VibeCoding. You capture raw scenarios, risks, examples, and open questions without forcing category decisions too early. The LLM helps you brainstorm.

3. **You are clarifying requirements** — You paste a module README, ask the LLM to identify ambiguous acceptance criteria, and discuss what the right behavior should be. This is the `SPEC_clearStoryIntent` phase when done informally.

4. **You are troubleshooting** — A test is failing, you paste the error and the test code, and the LLM helps you diagnose whether it's a setup problem, an assertion problem, or a real bug.

5. **You are doing one-off work** — A small validation script, a configuration change, a documentation update. The overhead of SpecCoding is not worth it.

---

## When to Switch to SpecCoding

VibeCoding has a natural limit. When you find yourself:

- Repeating the same instructions to the LLM multiple times
- Losing track of what you've already decided
- Forgetting which tests have been designed vs implemented
- Needing to share progress with teammates
- Needing to resume work after a day or a week

...it is time to switch to SpecCoding. VibeCoding is for exploration and conversation. SpecCoding is for structured delivery and team work. They are not competing modes — they are complementary stages in the same workflow.

---

## How VibeCoding Works with methodPrompts

In VibeCoding mode, you use the methodPrompts layer directly. You share the method prompt with the LLM and then iterate conversationally.

### The Basic Pattern

```
1. Share context:   Paste methodPrompts/CaTDD_methodPrompt.md (or the relevant category prompt)
2. Describe intent: "Using CaTDD, help me design tests for [component]."
3. Provide inputs:  Paste API headers, existing test files, documentation
4. Iterate:         Review, refine, ask for clarification, request alternatives
5. Produce:         The LLM generates US/AC/TC design, test code, or production code
6. Preserve:        Copy the LLM's output into your test files
```

### Example: VibeCoding a Typical Skeleton

**Developer**:
```
Using CaTDD methodology (from methodPrompts/CaTDD_methodPrompt.md),
help me design the Typical skeleton for an event queue component.

Key concerns:
- Producers post events asynchronously
- Consumers pull events with optional blocking
- Queue has a fixed capacity

Coverage dimensions: Producer × Consumer × Mode
Priority: Default P0 order (Typical → Edge → Misuse → Fault)
```

**CodeAgent** (after reading the method prompt):
```
I'll design the P0 Functional / Typical skeleton for the event queue.

Coverage Matrix:
┌──────────────┬──────────────┬───────────┬────────────────────────┐
│ Producer     │ Consumer     │ Mode      │ Scenario               │
├──────────────┼──────────────┼───────────┼────────────────────────┤
│ Single       │ Single       │ Callback  │ US-1: Basic event flow │
│ Single       │ Single       │ Pull      │ US-2: Polling flow     │
│ Multiple     │ Single       │ Callback  │ US-3: Fan-in           │
└──────────────┴──────────────┴───────────┴────────────────────────┘

User Stories:

US-1: As an event producer,
      I want to post events to a queue for asynchronous processing,
      So that my producer thread is not blocked by consumer work.

US-2: As an event consumer,
      I want to pull events from the queue with optional blocking,
      So that I can process events when ready without busy-waiting.

US-3: As a system operator,
      I want multiple producers to safely post to the same queue,
      So that events from different sources are handled correctly.

...
```

The conversation continues: the developer reviews, requests edge case coverage, asks the CodeAgent to generate implementation, and refines iteratively. This is VibeCoding — the LLM is a conversation partner applying the CaTDD method.

---

## The VibeCoding Workflow

CaTDD VibeCoding follows a natural progression through the method's phases:

### Phase 1: Understanding (method-guided exploration)

**What you say to the LLM**:
```
"I'm building a [component]. Here are the API headers.
Using CaTDD, what should I test and how should I prioritize?"
```

**What the LLM does**:
- Reads your interfaces
- Checks existing related tests
- Identifies dependencies and constraints
- Presents an understanding summary
- Asks clarifying questions before proceeding

**CaTDD contract**: The LLM should follow the Agent Workflow Checklist from the methodPrompt (Phase 1: Understanding). It should read files, identify APIs, find similar tests, and clarify ambiguities before designing anything.

### Phase 2: Design (comment-first, no code yet)

**What you say**:
```
"Good. Now design the coverage matrix and User Stories."
```

**What the LLM does**:
- Fills the OVERVIEW section (WHAT/WHERE/WHY/SCOPE)
- Defines Coverage Matrix dimensions
- Writes User Stories (2-5, in As a/I want/So that format)
- Writes Acceptance Criteria (GIVEN/WHEN/THEN)
- Details Test Cases with structured metadata
- Populates the TODO tracking section

**CaTDD contract**: Design before code. The LLM should write comments first — the US/AC/TC chain — before generating any test implementation. This is the "Comment-alive" part: the design lives in comments that stay with the code.

### Phase 3: Implementation (TDD Red→Green)

**What you say**:
```
"Implement the first Typical test case. Follow RED→GREEN."
```

**What the LLM does**:
- Writes the test implementation (4-phase structure)
- Marks it 🔴 RED in the TODO section
- Confirms it fails (should fail because code is missing)
- Implements minimal production code
- Confirms it passes
- Marks it 🟢 GREEN

**CaTDD contract**: The LLM should follow strict TDD discipline. It should never implement production code before writing a failing test. It should update the status markers immediately after each action.

### Phase 4: Iteration and Refinement

**What you say**:
```
"Now the Edge tests. And add tests for queue full behavior."
```

**What the LLM does**:
- Continues through the priority framework
- Advances TC by TC through the RED→GREEN cycle
- Stops at each quality gate for review
- Reports coverage gaps and recommends next steps

---

## VibeCoding vs SpecCoding: The Developer's Decision

The choice between VibeCoding and SpecCoding is a spectrum, not a binary switch. You can start in VibeCoding, reach a natural inflection point, and switch to SpecCoding.

### Start VibeCoding When

- The component is new and requirements are emerging
- You are the sole developer
- You need to explore before committing to structure
- The scope is small (<5 User Stories, <20 test cases)
- You want rapid iteration without lifecycle overhead

### Switch to SpecCoding When

- Requirements have stabilized and need traceability
- You are collaborating with teammates
- You need to pause and resume work across days
- The scope is large (5+ User Stories, 20+ test cases)
- You want reproducible `/UT_*` and `/SPEC_*` command sequences
- Stakeholders need visibility into progress (pendingNews → todoUS → doingUS → doneUS)

### The Natural Transition Point

The most common transition point is after Stage-0 Freely Drafting. You explore in VibeCoding mode, brainstorming ideas, discussing risks, and sketching test scenarios. When you have enough clarity to classify drafts into CaTDD categories (Stage-1), you switch to SpecCoding and start invoking structured commands.

```
VibeCoding:   Explore → Brainstorm → Draft → Discuss
                        ↓ (inflection point)
SpecCoding:   Classify → Design Skeletons → Review → Implement → Commit → Close
```

---

## The Method Prompt as Chat Context

In VibeCoding, the method prompt is your shared context with the LLM. You don't need to re-explain CaTDD every time — you share the method prompt once and the LLM applies it throughout the conversation.

### What to Share

The minimal context for effective VibeCoding:

1. **The master method prompt** (`CaTDD_methodPrompt.md`) — Establishes the methodology contract: priority framework, category definitions, US/AC/TC format, status tracking, quality gates.

2. **The relevant category prompt** (`CaTDD_methodPrompt4Cat-Typical.md`, etc.) — When working within a specific category, share the category-specific guidance.

3. **The API interfaces** — Header files, spec docs, or protocol definitions for the component under test.

4. **Existing test files** — So the LLM can follow existing patterns and avoid duplication.

### How Much Context Is Enough?

The CaTDD method prompt is comprehensive (1500+ lines of specification). You don't need to paste the entire thing into every conversation. Instead:

- **First conversation**: Share the full method prompt. The LLM now understands CaTDD.
- **Subsequent conversations**: Reference it: "Continue using CaTDD method as before."
- **Focused conversations**: Share only the relevant category prompt for the specific work.

The LLM's context window is your constraint. Prioritize:
1. The component interfaces and spec docs (mandatory — the LLM needs to know WHAT to test)
2. The relevant category prompt (important — the LLM needs to know HOW to test it)
3. Existing test code (helpful — the LLM follows conventions)

---

## The Model Tier Strategy for VibeCoding

VibeCoding puts you in direct conversation with an LLM. The model you choose matters for decision quality. CaTDD recommends using the smallest model tier that preserves decision quality:

| Tier | When to Use in VibeCoding |
|---|---|
| **SOTA reasoning** (GPT-5.5-xHigh) | Architecture decisions, system boundaries, quality trade-offs, cross-module constraints. Use when the conversation involves irreversible design choices. |
| **High performance** | Requirements analysis, US/AC/TC design, test design, code review. Use when reasoning must span multiple artifacts (specs, tests, production code). |
| **Flash speed** | Deterministic tasks: writing a single test implementation, updating TODO status, simple refactoring. Use when inputs are clear and action is narrow. |

**Escalation rule**: If a flash-speed model produces a design that seems shallow, escalate to high-performance. If a high-performance model makes an architecture decision that feels risky, escalate to SOTA.

---

## Common VibeCoding Patterns

### Pattern 1: The Design Review Loop

```
Developer: "Design the Typical skeleton for this API."
CodeAgent: [Produces US/AC/TC design]
Developer: "US-2 doesn't capture the non-blocking requirement. Revise."
CodeAgent: [Revises US-2 and updates affected ACs and TCs]
Developer: "Good. Now add coverage for the timeout mode."
CodeAgent: [Adds AC-4 and TCs for timeout behavior]
Developer: "Looks complete. Switch to SpecCoding and start implementation."
```

This is the most natural pattern: the developer reviews the LLM's design output and guides refinement. The LLM preserves traceability (updating a US cascades to affected ACs and TCs).

### Pattern 2: The Coverage Gap Analysis

```
Developer: "Here are my current test files. What coverage gaps do you see?"
CodeAgent: [Analyzes existing US/AC/TC chains against the priority framework]
CodeAgent: "Missing: P0 Edge for queue full behavior, P0 Misuse for double-close,
           P1 State for lifecycle transitions after cleanup."
Developer: "Design the Edge skeleton first. Then we'll do Misuse."
```

The LLM uses the CaTDD priority framework as a checklist against your existing tests. It identifies what should exist but doesn't.

### Pattern 3: The Troubleshooting Session

```
Developer: "TC-3 is failing. Expected IOC_RESULT_INVALID_PARAM, got success."
CodeAgent: [Reads test code, reads production code]
CodeAgent: "The test calls IOC_post(NULL, ...) but the production code has a
           guard clause returning SUCCESS for NULL handles. This is either:
           A) A production code bug (should return INVALID_PARAM), or
           B) A test misunderstanding (NULL is allowed in this API).
           Which is correct for this API contract?"
```

The LLM acts as a diagnostic partner, comparing test expectations with production behavior and surfacing the contract ambiguity.

### Pattern 4: The "What's Next" Inquiry

```
Developer: "I've completed all P0 Typical tests. What should I do next?"
CodeAgent: [Reads the TODO tracking section]
CodeAgent: "You have 4 Edge test cases at ⚪ TODO, 2 Misuse cases at ⚪ TODO,
           and 1 Fault case at ⚪ TODO. According to the P0 default order,
           implement the Edge cases next. TC-Edge-1 depends on capacity API
           which you haven't implemented — consider marking it BLOCKED and
           proceeding with TC-Edge-2 instead."
```

The LLM reads the CaTDD tracking section and recommends the next action based on priority rules and dependency analysis.

---

## The Two Design Stages in VibeCoding

CaTDD method prompts support two design stages that map naturally to VibeCoding:

### Stage-0: Freely Drafting

This is pure VibeCoding. You capture raw scenarios, risks, examples, and open questions without forcing category decisions. The goal is coverage breadth, not structure.

**What you say**:
```
"I'm building an event queue. What could go wrong? What should I test?"
```

**What the LLM produces**:
```
FreelyDrafts:
- What if the queue is full and producer tries to post?
- What if consumer tries to pull from empty queue?
- What if multiple producers post simultaneously?
- What if consumer blocks waiting for events that never arrive?
- What if queue capacity is 0 — should that be allowed?
- What if we post after the queue has been destroyed?
- What if event sizes vary dramatically?
- What if callback consumer throws an exception?
- Risk: Consumer deadlock if callback tries to post back to same queue
- Risk: Memory leak if events are posted but never consumed
- Question: Should zero-capacity queue be a valid configuration?
- Question: Should we support priority-based event ordering?
```

Stage-0 output is intentionally unstructured. The goal is idea capture. Structure comes in Stage-1.

### Stage-1: Classifying Design

After drafting, you classify drafts into CaTDD categories before writing final US/AC/TC. This is the bridge between VibeCoding and SpecCoding.

**What you say**:
```
"Classify these drafts into CaTDD categories and design the skeletons."
```

**What the LLM produces** (structured by category):

```
P0 Functional / Typical:
  US-1: As a producer, I want to post events so they are queued for processing.
  AC-1: GIVEN queue with available capacity, WHEN producer posts, THEN event is queued.
  TC-1: verifyEventPost_byAvailableCapacity_expectEventQueued

P0 Functional / Edge:
  US-2: As a producer, I want non-blocking behavior when queue is full.
  AC-2: GIVEN full queue, WHEN producer posts with NonBlock, THEN returns immediately with error.
  TC-2: verifyNonBlockPost_byFullQueue_expectImmediateReturn

P0 Functional / Misuse:
  US-3: As a developer, I want proper error codes for incorrect queue usage.
  AC-3: GIVEN destroyed queue, WHEN producer posts, THEN returns INVALID_STATE.
  TC-3: verifyPost_byDestroyedQueue_expectInvalidState

P0 Functional / Fault:
  US-4: As a system operator, I want graceful recovery from consumer failures.
  AC-4: GIVEN consumer callback crashes, WHEN posted events remain, THEN queue stays operational.
  TC-4: verifyQueue_byConsumerCrash_expectQueueRemainsOperational
```

Stage-1 bridges the gap between free exploration and structured execution. Once classified, you can switch to SpecCoding and invoke slash commands to implement each skeleton.

---

## VibeCoding with Real-Time Feedback

One of VibeCoding's strengths is instant feedback. You see the LLM's output immediately and iterate. This creates a tight feedback loop:

```
Your prompt → LLM response → Your review → Revised prompt → Better response
     ↑                                                              ↓
     └────────────────────── Continuous refinement ─────────────────┘
```

This loop is fast but fragile. If you don't preserve the outputs (copying them into test files, updating TODO status), the conversation becomes the only record of decisions. When the chat expires, the design is lost.

**The VibeCoding preservation rule**: After every significant design output, copy it into a file. After every test implementation, run it and update the TODO section. Don't let the chat be your only source of truth.

---

## The CodeAgent's Role in VibeCoding

In VibeCoding, the CodeAgent is a **method-aware conversation partner**. It:

- **Reads method prompts** to understand CaTDD semantics, not just generic TDD
- **Preserves comment skeleton contracts** — it knows that `@[US]`, `@[AC]`, `@[TC]` markers are structural, not cosmetic
- **Follows priority discipline** — it designs P0 before P1, Typical before Edge
- **Tracks status** — it updates ⚪→🔴→🟢 markers as the conversation progresses
- **Asks before assuming** — when product intent is unclear, it asks rather than guesses
- **Reports what it doesn't know** — it surfaces missing information, not hiding gaps behind confident-sounding output

The CodeAgent does not replace the developer's judgment. It amplifies it by applying method consistency and generating structured output faster than a human can type.

---

## VibeCoding Anti-Patterns

### Anti-Pattern 1: VibeCoding Forever

Some developers stay in VibeCoding mode indefinitely, treating every LLM conversation as ad hoc. Without structure, you accumulate:

- Orphaned test cases with no traceability to requirements
- Tests that pass but don't verify anything meaningful (the "green but empty" problem)
- Inconsistent naming, structure, and priority order across files
- Lost design decisions that only exist in expired chat sessions

**Fix**: Switch to SpecCoding when the design stabilizes. Move from conversation to structured artifacts.

### Anti-Pattern 2: Skipping Design in VibeCoding

VibeCoding's speed can tempt you to jump straight to implementation: "Write me a test for the event queue." The LLM generates test code, you run it, it passes. Feels productive. But:

- No US/AC/TC traceability: what business value does this test verify?
- No priority classification: is this Typical, Edge, or a random test?
- No coverage reasoning: what should be tested but isn't?

**Fix**: Even in VibeCoding mode, follow the "design before code" principle. Ask the LLM to design the skeleton first, review it, then implement.

### Anti-Pattern 3: Context Starvation

You ask the LLM to design tests without providing API headers, existing test patterns, or project conventions. The LLM fills gaps with plausible but wrong assumptions.

**Fix**: Before asking for design, provide:
- The method prompt (so the LLM follows CaTDD)
- The component interfaces (so the LLM knows WHAT to test)
- Existing test examples (so the LLM follows conventions)
- Your specific concerns or risk areas (so the LLM prioritizes correctly)

### Anti-Pattern 4: The Silent Approval

The LLM produces a design. You read it, it looks reasonable, you say "implement." But "looks reasonable" is not the same as "correct."

**Fix**: Explicitly review each output against the CaTDD contract:
- Do the User Stories express real user value?
- Do the Acceptance Criteria use GIVEN/WHEN/THEN precisely?
- Do the Test Cases trace back to ACs and USs?
- Are the categories correct (is this really Edge and not Misuse?)?
- Are the assertions testing the right thing?

---

## From VibeCoding to SpecCoding: The Bridge

The bridge between VibeCoding (Chapter 2) and SpecCoding (Chapter 3) is the slash command system. When you are ready to move from conversation to structured execution:

1. **Preserve the VibeCoding output**: Copy the US/AC/TC design into test files as comment skeletons.
2. **Initialize SpecFlow**: Run `/SPEC_initProjectContext` to establish shared project context.
3. **Import the work**: Use `/SPEC_importFeature` or `/SPEC_importIssue` to create a traceable story artifact.
4. **Open the story**: Use `/SPEC_openUserStory` to move the work into active state.
5. **Begin structured execution**: Use `/UT_designTypicalSkeleton`, `/UT_implTestCase`, and other slash commands to work through the priority framework with reproducible, traceable steps.

VibeCoding discovered the design. SpecCoding delivers it. Together they form the complete CaTDD workflow.
