# 02 chatVibeCoding

## What Is Vibe Coding?

Vibe coding means talking to an LLM in plain language and letting it produce code. You describe what you want, the LLM writes an implementation, and you refine it by talking.

It is fast and it feels natural. It also has a well-known failure mode: the conversation becomes the only place where the design exists. When the chat is gone, the reasoning is gone too.

CaTDD keeps the speed and removes the failure. It treats conversation as the **first mode** of LLM work — the exploratory mode — and gives it a structure that survives the chat.

```
   plain vibe coding                  CaTDD VibeCoding
   ─────────────────                  ────────────────
   "write me a test"                  "read the method prompt,
   → code appears                      then design the skeleton"
   → you run it                      → US/AC/TC comments appear
   → it passes                       → you review the design
   → nobody knows why                → then implement, RED → GREEN
                                     → the design is now in the file
```

The conversation is still free-form. What changes is that every useful result gets written down in a place the next session can find.

---

## The Two Modes of CaTDD Interaction

CaTDD has exactly two ways to work with an LLM, and they use different layers of the method.

| Mode | What you use | How it feels |
|---|---|---|
| **VibeCoding** | `methodPrompts` directly in chat | Free conversation with method guidance |
| **SpecCoding** | `slashCommands` | A structured flow with explicit lifecycle steps |

```
   EXPLORATION ◄──────────────────────────────────────────► DELIVERY
        │                                                       │
    VibeCoding                                             SpecCoding
    ──────────                                             ──────────
    methodPrompts                                          slashCommands
    you drive the conversation                             the flow drives
    traceability is optional                               traceability enforced
    artifacts: comments, drafts                            artifacts: lifecycle
    best for: thinking                                     best for: finishing
        │                                                       │
        └────────── you switch when the design stabilizes ──────┘
```

| Aspect | VibeCoding | SpecCoding |
|---|---|---|
| **Definition** | Flexible, method-guided conversation | Structured flow with explicit lifecycle commands |
| **Method source** | methodPrompts directly | slashCommands (which wrap methodPrompts) |
| **Control** | The developer drives the conversation | The flow commands drive the lifecycle |
| **Artifacts** | Comments, test files, code — whatever you make | SpecFlow artifacts: `pendingNews`, `todoUS`, `doingUS`, `abortUS`, `doneUS` |
| **Traceability** | Optional, depends on the developer | Mandatory, enforced by the flow |
| **Best for** | Exploration, drafting, brainstorming, quick fixes | Structured delivery, teamwork, reproducible workflows |
| **How you invoke it** | You type a free-form prompt | You invoke `/UT_*` or `/SPEC_*` commands |

> **The key idea** — these are not competing tools. They are two stages of the same workflow, and CaTDD tells you when to move between them.

---

## When to Use VibeCoding

VibeCoding is the right choice in five situations.

```
   ┌────────────────────────────────────────────────────────────┐
   │  1  exploring a new feature      idea is still rough        │
   │  2  freely drafting test ideas   Stage-0, no categories yet │
   │  3  clarifying requirements      what does "correct" mean?  │
   │  4  troubleshooting              why is this test failing?  │
   │  5  one-off work                 too small to formalize     │
   └────────────────────────────────────────────────────────────┘
```

1. **You are exploring a new feature.** You have a rough idea and need help thinking through coverage, edge cases, and risks. You paste the API header, ask "what should I test, and what could go wrong?", and iterate on the answers.

2. **You are freely drafting test ideas.** CaTDD calls this Stage-0 (Freely Drafting). You capture raw scenarios, risks, examples, and open questions without forcing a category decision too early. This is pure VibeCoding.

3. **You are clarifying requirements.** You paste a module README, ask the LLM to find the ambiguous acceptance criteria, and discuss what the behavior should be. This is the informal version of the `SPEC_clearStoryIntent` step.

4. **You are troubleshooting.** A test is failing. You paste the error and the test code, and the LLM helps you decide whether it is a setup problem, an assertion problem, or a real bug.

5. **You are doing one-off work.** A small validation script, a configuration change, a documentation update. The overhead of a formal lifecycle costs more than it returns.

**Example — a good first VibeCoding prompt.** Notice that it sets the method, the component, and the question, and nothing else.

```
Using CaTDD (methodPrompts/CaTDD_methodPrompt.md), help me design
the P0 Functional skeleton for an event queue component.

Context:
  - producers post events asynchronously
  - consumers pull events, optionally blocking
  - the queue has a fixed capacity

Start with coverage dimensions, then propose US/AC/TC.
Do not write implementation code yet.
```

The last line is the important one. It forces the design step to happen before the code step.

---

## When to Switch to SpecCoding

VibeCoding has a natural limit. You have reached it when you notice any of these symptoms.

```
   SYMPTOM                              WHAT IT MEANS
   ───────                              ─────────────
   repeating the same instructions      the method is not written down
   losing track of decisions            the design has no home
   unsure which tests exist             there is no status list
   can't hand work to a teammate        progress is not shareable
   can't resume after a week            context lived only in the chat
```

When you see these, switch. VibeCoding is for exploring; SpecCoding is for delivering. They are complementary stages in one workflow, not competitors.

```
   VibeCoding                                        SpecCoding
   ──────────                                        ──────────
   Explore → Brainstorm → Draft → Discuss
                              │
                              └── inflection point ──►  Classify → Design
                                                        Skeletons → Review
                                                        → Implement → Commit
                                                        → Close
```

## How VibeCoding Works with methodPrompts

VibeCoding works because the method travels with the conversation. You paste the method prompt once, and the LLM stops behaving like a general code generator. It starts behaving like a CaTDD practitioner: it designs before it codes, it labels categories, and it keeps a status list.

### The Basic Pattern

```
   1  SHARE      paste methodPrompts/CaTDD_methodPrompt.md
   2  DESCRIBE   "Using CaTDD, design tests for [component]"
   3  SUPPLY     API headers, spec docs, existing test files
   4  ITERATE    review, refine, ask for alternatives
   5  PRODUCE    US/AC/TC design, test code, production code
   6  PRESERVE   copy the output into your own files
```

Step 1 is the one people skip, and it is the one that changes the answer. Without the method prompt you get generic TDD: a test appears, it passes, and nobody can say which requirement it defends. With the method prompt you get a US/AC/TC chain you can review *before* any code exists.

> **Common mistake** — Treating step 6 as optional. The LLM's answer lives in a chat window; your design has to live in your repository. Copy the skeleton into the test file in the same session, or you will be retyping it from memory tomorrow.

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

Three details in that prompt do the heavy lifting: the method source, the coverage dimensions, and the priority order. The LLM does not have to guess any of them.

**CodeAgent** (after reading the method prompt):

```
Coverage Matrix:  Producer × Consumer × Mode

   ┌────────────┬────────────┬───────────┬──────────────────────────┐
   │ Producer   │ Consumer   │ Mode      │ Scenario                 │
   ├────────────┼────────────┼───────────┼──────────────────────────┤
   │ Single     │ Single     │ Callback  │ US-1: basic event flow   │
   │ Single     │ Single     │ Pull      │ US-2: polling flow       │
   │ Multiple   │ Single     │ Callback  │ US-3: fan-in             │
   └────────────┴────────────┴───────────┴──────────────────────────┘

P0 Functional / Typical User Stories:

US-1: As an event producer,
      I want to post events to a queue for asynchronous processing,
      So that my producer thread is not blocked by consumer work.

US-2: As an event consumer,
      I want to pull events from the queue with optional blocking,
      So that I can process events when ready without busy-waiting.

US-3: As a system operator,
      I want multiple producers to safely post to the same queue,
      So that events from different sources are handled correctly.
```

The conversation continues in the same shape: the developer reviews, asks for Edge coverage, asks for implementation, refines. The LLM is not "writing code for you" — it is applying the method with you at conversation speed.

Notice what the matrix buys you. Three rows is not a test plan; it is a claim about which combinations are covered. When someone asks next week "is fan-in covered?", the row answers in one second instead of a source re-read.

---

## The VibeCoding Workflow

CaTDD VibeCoding follows the same phases the method already defines. The difference is that a conversation carries you between them.

```
   PHASE 1          PHASE 2           PHASE 3           PHASE 4
   Understanding →  Design        →   Implementation →  Iteration
   ─────────────    ─────────────     ──────────────    ─────────────
   read files       write comments    RED → GREEN       next TC,
   ask questions    US / AC / TC      one TC at a time  gate review
   no output yet    no code yet       code appears      status updated
```

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

**CaTDD contract**: the LLM follows the Agent Workflow Checklist from the methodPrompt (Phase 1: Understanding). It reads files, identifies APIs, finds similar tests, and clarifies ambiguities *before* designing anything.

### Phase 2: Design (comment-first, no code yet)

**What you say**:

```
"Good. Now design the coverage matrix and User Stories."
```

**What the LLM does**:

- Fills the OVERVIEW section (WHAT/WHERE/WHY/SCOPE)
- Defines Coverage Matrix dimensions
- Writes User Stories (2–5, in As a / I want / So that format)
- Writes Acceptance Criteria (GIVEN/WHEN/THEN)
- Details Test Cases with structured metadata
- Populates the TODO tracking section

**CaTDD contract**: design before code. The LLM writes the US/AC/TC chain as comments before generating any test implementation. This is the Comment-alive part: the design lives in comments that stay with the code.

### Phase 3: Implementation (TDD Red→Green)

**What you say**:

```
"Implement the first Typical test case. Follow RED→GREEN."
```

**What the LLM does**:

- Writes the test implementation (4-phase structure)
- Marks it 🔴 RED in the TODO section
- Confirms it fails (it should fail: the code does not exist yet)
- Implements minimal production code
- Confirms it passes
- Marks it 🟢 GREEN

**CaTDD contract**: strict TDD discipline. The LLM never implements production code before a failing test exists, and it updates the status markers immediately after each action.

### Phase 4: Iteration and Refinement

**What you say**:

```
"Now the Edge tests. And add tests for queue full behavior."
```

**What the LLM does**:

- Continues through the priority framework
- Advances TC by TC through the RED→GREEN cycle
- Stops at each quality gate for your review
- Reports coverage gaps and recommends next steps

```
   one turn of the loop
   ───────────────────
   design 1 TC  →  RED  →  minimal code  →  GREEN  →  update status
        │                                                    │
        └────────────── next TC in priority order ◄──────────┘
```

---

## VibeCoding vs SpecCoding: The Developer's Decision

The choice is a spectrum, not a switch. Most work starts in VibeCoding and finishes in SpecCoding.

### Start in VibeCoding When

```
   ┌──────────────────────────────────────────────────────────────┐
   │  the component is new, requirements are still emerging       │
   │  you are the only developer on it                            │
   │  you need to explore before committing to structure          │
   │  scope is small:  <5 User Stories,  <20 test cases           │
   │  you want fast iteration with no lifecycle overhead          │
   └──────────────────────────────────────────────────────────────┘
```

### Switch to SpecCoding When

```
   ┌──────────────────────────────────────────────────────────────┐
   │  requirements stabilized and need traceability               │
   │  teammates are involved                                      │
   │  work must pause and resume across days                      │
   │  scope is large:  5+ User Stories,  20+ test cases           │
   │  you want reproducible /UT_* and /SPEC_* sequences           │
   │  stakeholders need progress visibility                       │
   └──────────────────────────────────────────────────────────────┘
```

That last point has a concrete shape. Progress is visible as story state: `pendingNews` → `todoUS` → `doingUS` → `doneUS`, with `abortUS` available when an active story should not continue.

### The Natural Transition Point

The most common transition happens right after Stage-0 Freely Drafting. You explored in VibeCoding, brainstormed risks, sketched scenarios. The moment you can sort those drafts into CaTDD categories, you are at Stage-1 — and structured commands start paying for themselves.

```
   VibeCoding:   Explore → Brainstorm → Draft → Discuss
                                            │
                              inflection point
                                            │
   SpecCoding:   Classify → Design Skeletons → Review → Implement
                                                       → Commit → Close
```

---

## The Method Prompt as Chat Context

In VibeCoding the method prompt *is* your shared context. Share it once and the LLM applies it for the rest of the conversation — no need to re-explain CaTDD every session.

### What to Share

```
   ┌────────────────────────────────────────────────────────────────┐
   │  1  master method prompt   CaTDD_methodPrompt.md               │
   │     priority framework, categories, US/AC/TC format,           │
   │     status tracking, quality gates                             │
   ├────────────────────────────────────────────────────────────────┤
   │  2  category prompt        CaTDD_methodPrompt4Cat-*.md         │
   │     only when the work sits inside one specific category       │
   ├────────────────────────────────────────────────────────────────┤
   │  3  API interfaces         headers, spec docs, protocol defs   │
   │     the component under test                                   │
   ├────────────────────────────────────────────────────────────────┤
   │  4  existing test files    so the LLM follows your conventions │
   │     and does not duplicate what already exists                 │
   └────────────────────────────────────────────────────────────────┘
```

### How Much Context Is Enough?

The CaTDD method prompt is comprehensive (1500+ lines of specification). You do not need to paste all of it into every conversation:

- **First conversation** — share the full method prompt. The LLM now understands CaTDD.
- **Subsequent conversations** — reference it: "Continue using CaTDD method as before."
- **Focused conversations** — share only the category prompt that applies to the work.

The context window is your constraint, so spend it in priority order:

```
   highest  ┌──────────────────────────────────────────────┐
   priority │  component interfaces + spec docs   MANDATORY │
            ├──────────────────────────────────────────────┤
            │  relevant category prompt           IMPORTANT │
            ├──────────────────────────────────────────────┤
            │  existing test code                 HELPFUL   │
   lowest   └──────────────────────────────────────────────┘
            tells the LLM WHAT  →  HOW  →  house style
```

Drop the interfaces and the LLM invents an API. Drop the category prompt and it designs a Typical case in Edge clothing. Drop the existing tests and it invents a second naming convention beside yours.

---

## The Model Tier Strategy for VibeCoding

VibeCoding puts you in direct conversation with a model, so the tier you pick sets the ceiling on decision quality. CaTDD recommends the smallest tier that preserves that quality.

| Tier | Use it for | Why |
|---|---|---|
| **SOTA reasoning** (GPT-5.5-xHigh) | Architecture decisions, system boundaries, quality trade-offs, cross-module constraints | The conversation contains irreversible choices |
| **High performance** | Requirements analysis, US/AC/TC design, test design, code review | Reasoning must span several artifacts: specs, tests, production code |
| **Flash speed** | Single test implementation, TODO status updates, simple refactoring | Inputs are clear and the action is narrow |

```
   task feels shallow or mis-categorized?
        flash  ──────────────►  high performance
        high performance  ────►  SOTA reasoning
                                  (architecture feels risky)
```

**Escalation rule**: if a flash-speed model produces a design that looks shallow, escalate to high-performance. If a high-performance model makes an architecture decision that feels risky, escalate to SOTA.

> **Why this matters** — a story split that is wrong at the architecture tier costs a rewrite of every AC and TC underneath it. A TODO marker updated by a cheaper model costs nothing. Spend the expensive model where the decision fans out.

---

## Common VibeCoding Patterns

Four conversations cover most of what developers actually do.

```
   1 DESIGN REVIEW      "revise US-2, then re-check its ACs"
   2 COVERAGE GAP       "what am I missing against the framework?"
   3 TROUBLESHOOTING    "TC-3 fails — test bug or product bug?"
   4 WHAT'S NEXT        "P0 Typical is done. Now what?"
```

### Pattern 1: The Design Review Loop

```
Developer: "Design the Typical skeleton for this API."
CodeAgent: [produces US/AC/TC design]
Developer: "US-2 doesn't capture the non-blocking requirement. Revise."
CodeAgent: [revises US-2 and updates the ACs and TCs that depend on it]
Developer: "Good. Now add coverage for the timeout mode."
CodeAgent: [adds AC-4 and the TCs for timeout behavior]
Developer: "Looks complete. Switch to SpecCoding and start implementation."
```

This is the most natural pattern: you review the design, the LLM keeps traceability while it edits. Revise one US and the affected ACs and TCs move with it — which is exactly the bookkeeping humans skip when they edit by hand.

### Pattern 2: The Coverage Gap Analysis

```
Developer: "Here are my current test files. What coverage gaps do you see?"
CodeAgent: [checks existing US/AC/TC chains against the priority framework]
CodeAgent: "Missing: P0 Edge for queue full behavior, P0 Misuse for double-close,
           P1 State for lifecycle transitions after cleanup."
Developer: "Design the Edge skeleton first. Then we'll do Misuse."
```

The LLM uses the priority framework as a checklist against what you already have. It answers a question that is hard to answer by reading your own test file: what *should* exist and does not.

### Pattern 3: The Troubleshooting Session

```
Developer: "TC-3 is failing. Expected IOC_RESULT_INVALID_PARAM, got success."
CodeAgent: [reads the test code, reads the production code]
CodeAgent: "The test calls IOC_post(NULL, ...) but production has a guard clause
           returning SUCCESS for a NULL handle. Either:
           A) production bug — it should return INVALID_PARAM, or
           B) test misunderstanding — NULL is allowed by this API.
           Which one matches the API contract?"
```

The LLM compares the test's expectation with the production behavior and surfaces the ambiguity in the contract. That ambiguity is the real finding — the failing assertion is only its symptom.

### Pattern 4: The "What's Next" Inquiry

```
Developer: "I've completed all P0 Typical tests. What should I do next?"
CodeAgent: [reads the TODO tracking section]
CodeAgent: "You have 4 Edge cases at ⚪ TODO, 2 Misuse cases at ⚪ TODO,
           and 1 Fault case at ⚪ TODO. In the P0 default order, Edge comes
           next. TC-Edge-1 depends on a capacity API you haven't implemented —
           consider marking it BLOCKED and proceeding with TC-Edge-2."
```

The LLM reads your tracking section and recommends the next action from priority order plus dependency analysis. This is the cheapest use of a model in the whole workflow, and one of the most valuable: it removes the "where was I?" tax at the start of every session.

---

## The Two Design Stages in VibeCoding

The method prompt supports two design stages, and VibeCoding is where they feel natural.

```
   STAGE-0  freely drafting          STAGE-1  classifying design
   ────────────────────────          ────────────────────────────
   raw ideas, risks, questions  →    US / AC / TC per category
   breadth over structure            structure over breadth
   "what could go wrong?"            "which category, which gate?"
   output: messy notes               output: reviewable skeleton
```

### Stage-0: Freely Drafting

This is pure VibeCoding: capture scenarios, risks, examples, and open questions without forcing categories. The goal is coverage breadth, not structure.

**What you say**:

```
"I'm building an event queue. What could go wrong? What should I test?"
```

**What the LLM produces**:

```
FreelyDrafts:
- What if the queue is full and a producer tries to post?
- What if a consumer tries to pull from an empty queue?
- What if multiple producers post simultaneously?
- What if a consumer blocks waiting for events that never arrive?
- What if queue capacity is 0 — should that be allowed?
- What if we post after the queue has been destroyed?
- What if event sizes vary dramatically?
- What if the callback consumer throws an exception?
- Risk: consumer deadlock if a callback posts back to the same queue
- Risk: memory leak if events are posted but never consumed
- Question: should a zero-capacity queue be a valid configuration?
- Question: should we support priority-based event ordering?
```

Nothing here is a test yet. That is the point: two open questions and two risks are cheaper to discuss now than to discover after the implementation is written.

### Stage-1: Classifying Design

Now you sort the drafts into CaTDD categories and write real skeletons. This is the bridge between VibeCoding and SpecCoding.

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
  US-2: As a producer, I want non-blocking behavior when the queue is full.
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

Compare the two blocks. Stage-0 asked "what if?" four different ways. Stage-1 answers each one with a category, a story, a criterion, and a test name — so a slash command can pick up TC-1 and run it end to end.

---

## VibeCoding with Real-Time Feedback

VibeCoding's strength is instant feedback: you see output and steer immediately.

```
   your prompt → LLM response → your review → revised prompt → better response
        ↑                                                              │
        └──────────────── continuous refinement ───────────────────────┘
```

The loop is fast, and it is fragile in one specific way: it has no memory of its own. If you do not copy results out — into test files, into the TODO section — then the chat is the only record of the decision.

```
   chat open    design lives here  ──►  you can still resume
   chat closed  design is gone     ──►  you rebuild it from memory
```

**The VibeCoding preservation rule**: after every significant design output, copy it into a file. After every test implementation, run it and update the TODO section. Never let the chat be your only source of truth.

---

## The CodeAgent's Role in VibeCoding

In VibeCoding the CodeAgent is a **method-aware conversation partner**, not an autocomplete with manners.

```
   ┌───────────────────────────────────────────────────────────────────┐
   │  reads method prompts      CaTDD semantics, not generic TDD       │
   │  preserves skeleton        @[US] @[AC] @[TC] are structural       │
   │  follows priority          P0 before P1, Typical before Edge      │
   │  tracks status             updates ⚪ → 🔴 → 🟢 as work moves      │
   │  asks instead of guessing  when product intent is unclear         │
   │  reports the unknown       gaps stay visible, not papered over    │
   └───────────────────────────────────────────────────────────────────┘
```

The last two rows are what separate a partner from a generator. A generator that does not know the intended behavior will invent one that sounds reasonable — and a reasonable invention is the most expensive kind of defect, because it passes review.

The CodeAgent does not replace the developer's judgment. It applies the method consistently and produces structured output faster than a human types, which leaves your attention for the part only you can do: deciding whether the design is right.

---

## VibeCoding Anti-Patterns

### Anti-Pattern 1: VibeCoding Forever

Some developers stay in VibeCoding mode indefinitely and treat every conversation as disposable. What accumulates:

- Isolated test cases with no traceability to requirements
- Tests that pass without verifying anything meaningful — the green-but-hollow problem
- Inconsistent naming, structure, and priority order across files
- Design decisions that exist only in an expired chat session

**Fix**: switch to SpecCoding once the design stops changing. Move from conversation to structured artifacts.

### Anti-Pattern 2: Skipping Design in VibeCoding

VibeCoding's speed tempts you to jump straight to implementation: "write me a test for the event queue." The LLM produces test code, you run it, it passes. It feels productive. But:

- No US/AC/TC traceability — which business value does this test defend?
- No priority classification — is this Typical, Edge, or an accident?
- No coverage reasoning — what *should* be tested and is not?

**Fix**: even in VibeCoding mode, keep design-before-code. Ask for the skeleton first, review it, then ask for the implementation.

### Anti-Pattern 3: Context Starvation

You ask the LLM to design tests without giving it API headers, existing test patterns, or project conventions. It fills the gaps with plausible assumptions, and plausible assumptions are exactly what a reviewer skips over.

**Fix**: before asking for a design, provide:

- The method prompt — so the LLM follows CaTDD
- The component interfaces — so the LLM knows **what** to test
- Existing test examples — so the LLM follows your conventions
- Your specific concerns or risk areas — so it prioritizes correctly

### Anti-Pattern 4: Silent Approval

The LLM produces a design. You read it. It looks reasonable. You say "implement it." But looking reasonable is not the same as being correct.

**Fix**: review every output against the CaTDD contract by name:

- Do the User Stories express real user value?
- Do the Acceptance Criteria use GIVEN/WHEN/THEN precisely?
- Do the Test Cases trace back to an AC and a US?
- Is the category right — is this really Edge and not Misuse?
- Does the assertion verify the claim the test is named for?

---

## From VibeCoding to SpecCoding: The Bridge

The bridge between VibeCoding (this chapter) and SpecCoding (chapter 03) is the slash command system. Five steps carry your conversation into a structured flow:

```
   1  preserve    copy US/AC/TC design into the test file as a comment skeleton
   2  initialize  /SPEC_initProjectContext      shared project context
   3  import      /SPEC_importFeature           traceable story artifacts
                  /SPEC_importIssue
   4  open        /SPEC_openUserStory           move the story into active work
   5  execute     /UT_designTypicalSkeleton     reproducible, traceable steps
                  /UT_implTestCase
```

The handoff is the whole point of having two modes. VibeCoding *finds* the design; SpecCoding *delivers* it. Nothing you discovered in the conversation is thrown away — it becomes the skeleton the commands operate on.

```
   chapter 02                                 chapter 03
   ──────────                                 ──────────
   conversation                               lifecycle
   US/AC/TC drafted by hand in chat    ──►    US/AC/TC carried by commands
   traceability optional                      traceability enforced
```
