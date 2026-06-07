# 05 applyClassicSWE

## The Knowledge Book of Software Engineering

Software engineering is not a collection of trendy frameworks. It is a body of enduring knowledge — principles, practices, and patterns that have survived decades because they reflect something true about how humans build complex systems. The Knowledge Book of Software Engineering includes:

| Discipline | Core Question | Signature Practice |
|---|---|---|
| **TDD** — Test-Driven Development | How do we prove that code works? | Write failing test first, implement to pass, refactor |
| **BDD** — Behavior-Driven Development | How do we connect requirements to code? | GIVEN/WHEN/THEN specification, executable specifications |
| **DDD** — Domain-Driven Design | How do we model complex business domains? | Ubiquitous Language, Bounded Contexts, Aggregates, Entities |

These three disciplines form a triangle: TDD verifies behavior, BDD specifies behavior, DDD models behavior. Together they answer the full lifecycle of software: what to build (BDD), how to model it (DDD), and how to prove it works (TDD).

---

## The LLM Era Changes Everything — and Nothing

Large Language Models have transformed how we write code. But they have not changed what makes software good:

- **Correctness** still matters — LLMs can generate plausible-looking code that is subtly wrong
- **Traceability** still matters — who asked for this feature, and how do we know it's done?
- **Maintainability** still matters — code that only the LLM understands is unmaintainable
- **Domain understanding** still matters — the LLM doesn't know your business rules unless you tell it

The LLM is a force multiplier for code generation. But without structure, multiplying chaos just produces more chaos. The classic SWE disciplines — TDD, BDD, DDD — provide the structure that keeps LLM-driven development from becoming LLM-driven chaos.

CaTDD exists precisely at this intersection: **it translates the Knowledge Book of Software Engineering into LLM-readable, comment-alive verification design.** It does not replace TDD, BDD, or DDD. It synthesizes them for the LLM era.

---

## TDD in the LLM Era

### Classical TDD: The Foundation

Test-Driven Development, formalized by Kent Beck, has three laws:

1. Write a failing test before writing production code
2. Write only enough test to fail
3. Write only enough production code to pass

The Red→Green→Refactor cycle is the heartbeat of TDD:

```
RED:    Write a test → it fails (the feature doesn't exist yet)
GREEN:  Write minimal production code → test passes
REFACTOR: Improve code and test structure while tests stay green
```

TDD is not about testing. It is about **design**. The test-first discipline forces you to think about interface, behavior, and contract before implementation. Tests are the first client of your API.

### TDD's Limitations Before LLMs

Classical TDD had two structural gaps:

1. **No design artifact**: The test is the design. But the test shows WHAT to verify, not WHY that verification matters. The business intent — who asked for this, what value it provides — is implicit in the developer's mind, not explicit in the test file.

2. **Manual effort ceiling**: Writing tests one at a time is disciplined but slow. Each test must be conceived, written, debugged, and verified by hand. The number of possible test scenarios always exceeds the time available to write them.

### CaTDD: TDD Enhanced for the LLM Era

CaTDD addresses both gaps by embedding **design intent** and **LLM-readability** into the TDD cycle:

| Classical TDD | CaTDD Enhancement |
|---|---|
| Test is the design | Comment skeleton IS the design — US/AC/TC structure makes business intent explicit |
| What to test is implicit | Priority framework (P0→P3) makes coverage strategy explicit |
| RED→GREEN→REFACTOR | ⚪TODO→🔴RED→🟢GREEN, with quality gates between priority levels |
| One test at a time, manually | LLM reads the design skeleton, generates test code, implements minimal prod code |
| Refactoring is ad hoc | TC-by-TC review, refactoring triggered by review gate failures |
| Tests are code artifacts | Tests are living design documents — comments evolve with code |

The LLM doesn't just write tests faster. It writes tests that are **traceable to design intent** because the design intent is embedded in the same file the LLM reads.

### The CaTDD TDD Cycle (with LLM)

```
1. DESIGN: Write the comment skeleton (US/AC/TC) — this IS the design
2. TC SELECTION: LLM reads the skeleton, selects next TC by priority
3. RED: LLM generates test code for the TC → marks ⚪→🔴 → test fails
4. GREEN: LLM generates minimal production code → test passes → marks 🔴→🟢
5. REVIEW: LLM reviews the implementation against the design contract
6. REPEAT: Advance to next TC
7. GATE: Stop at P0/P1/P2 gates, verify criteria, ask developer to approve
```

Steps 3-5 happen in a tight LLM loop. Steps 1, 2, 6, 7 are where human judgment operates. The LLM handles the mechanical TDD work. The developer handles the design judgment.

### Why TDD Matters More in the LLM Era

You might think: "If an LLM can generate code, why bother with TDD at all?" Because:

- **LLMs generate plausible code faster than they generate correct code.** Without a failing test, the LLM has no feedback. Without a passing test, you have no confidence.
- **LLMs lose context across conversations.** The test file IS the context. The CaTDD comment skeleton is the durable record of what the code should do, readable by the next LLM session.
- **LLMs are optimistic generators.** They assume their code works. TDD forces the discipline of verification. Every GREEN test is a checkpoint the LLM cannot hallucinate past.

TDD is not less important in the LLM era. It is **more** important. It is the grounding wire that prevents LLM-generated code from floating into plausible-but-wrong territory.

---

## BDD in the LLM Era

### Classical BDD: From Requirements to Executable Specifications

Behavior-Driven Development, pioneered by Dan North, bridges the gap between business stakeholders and developers:

```
Business Language:  "As a customer, I want to withdraw cash so I can buy things"
BDD Specification:   Scenario: Withdraw from account
                      Given the account has $100
                      When the customer withdraws $20
                      Then the balance is $80
Automated Test:      Step definitions map Given/When/Then to test code
```

BDD's core insight: **specifications should be executable**. The GIVEN/WHEN/THEN scenario is both the business requirement and the automated test. When the test passes, the requirement is satisfied. When the test fails, the requirement is broken.

### BDD's Limitations Before LLMs

Classical BDD required three artifacts maintained by humans:

1. **Feature files** (Gherkin `.feature` files) — Written by product owners or BAs
2. **Step definitions** (code that maps Gherkin steps to test actions) — Written by developers
3. **Production code** (the implementation) — Written by developers

Three artifacts across two languages (Gherkin + code) created maintenance friction. Feature files went stale. Step definitions were fragile. The vision of "executable specifications" often became "specifications that once were executable."

### CaTDD: BDD Embedded in Test Files

CaTDD embeds BDD directly into the test file as structured comments, eliminating the Gherkin-code gap:

```
Classical BDD:                         CaTDD BDD:

Feature: CashWithdrawal.feature        UT_Account.cxx:
                                       // US-1: As a customer,
  Scenario: Withdraw from account      //       I want to withdraw cash
    Given the account has $100         //       So that I can buy things.
    When the customer withdraws $20    //
    Then the balance is $80            // AC-1: GIVEN account has $100,
                                       //       WHEN customer withdraws $20,
Step definitions: CashWithdrawal.java  //       THEN balance is $80.
  @Given("account has $100")           //
  public void accountHas100() { ... }  // TC-1: verifyWithdraw_bySufficientBalance
                                       //       _expectReducedBalance
Test runner: Cucumber/JBehave          TEST(Account, verifyWithdraw_
                                              bySufficientBalance_
                                              expectReducedBalance) { ... }
```

CaTDD's US/AC/TC chain IS the BDD specification, but it lives in the test file as comments, not in a separate `.feature` file. The step definitions and test implementations are the same artifact — the TEST function. The gap between specification and verification does not exist.

### BDD as the CaTDD Acceptance Criteria Contract

Every CaTDD Acceptance Criteria follows the BDD format:

```
AC-n: GIVEN [preconditions and context],
      WHEN [specific action or event],
      THEN [expected observable outcome],
       AND [additional outcome if any].
```

This is not coincidence — it is BDD's GIVEN/WHEN/THEN format as the **canonical testable condition** in CaTDD. Create a living documentation reconciliation checklist to verify BDD consistency.

### BDD Reconciliation Checklist

Establish automated reconciliation tests that assert the consistency between source code, BDD specifications, and external documentation:

- Enforce that every CaTDD AC can be mapped to one or more TC implementations (no orphan acceptance criteria, no undocumented test cases)
- Verify that AC descriptions are distinct from step-specific implementation details — a TC should verify one AC, not duplicate other AC's steps
- Generate clean Markdown reports summarizing which ACs are tested, which are planned, and which are blocked

### Why BDD Matters More in the LLM Era

LLMs are pattern matchers, not business analysts. They generate GIVEN/WHEN/THEN structures convincingly, but they cannot judge whether the THEN clause reflects actual business rules. BDD with CaTDD provides the guardrails:

- **The developer writes the AC** — the business rule expressed in GIVEN/WHEN/THEN
- **The LLM generates the TC** — the concrete test that verifies the AC
- **The developer reviews the TC** — does this test actually verify what the AC states?
- **The LLM implements the test code** — the 4-phase implementation
- **The test passes** — the AC is satisfied

The developer owns the business rule (the AC). The LLM owns the verification mechanism (the TC and code). This division of labor is BDD optimized for the LLM era.

---

## DDD in the LLM Era

### Classical DDD: Modeling Complex Domains

Domain-Driven Design, introduced by Eric Evans, is a methodology for modeling complex business domains in software. Its core concepts include:

**Ubiquitous Language** — A shared language between domain experts and developers, used consistently in code, conversation, and documentation. If the business says "policy," the code has a `Policy` class, not an `InsuranceMathHelper`.

**Bounded Contexts** — A boundary within which a model applies. The word "Account" means different things in Billing (a payment account) vs. CRM (a customer account). Each bounded context has its own model.

**Strategic Design** — The relationships between bounded contexts: Core Domain (your competitive advantage), Supporting Subdomains (necessary but not differentiating), Generic Subdomains (buy, don't build).

**Tactical Design** — The building blocks within a bounded context: Entities (identity over attributes), Value Objects (attributes over identity), Aggregates (consistency boundaries), Domain Events (something happened), Repositories (retrieve aggregates), Services (stateless operations).

### DDD's Limitations Before LLMs

DDD required deep domain knowledge that was difficult to transfer to new team members:

- **Ubiquitous Language was fragile** — One developer used `Customer`, another used `Client`, a third used `Account` for the same concept. The model fragmented.
- **Bounded contexts were implicit** — They existed in architects' heads and whiteboard drawings, not in the code or the LLM's training data.
- **Model evolution was slow** — Refactoring a domain model required updating documentation, tests, production code, and team understanding — all manually.

### CaTDD: DDD as an LLM-Readable Domain Model

CaTDD brings DDD's concepts into the LLM era through several mechanisms:

#### 1. The OVERVIEW Section as Bounded Context Declaration

Every CaTDD test file begins with an OVERVIEW that declares its bounded context:

```cpp
/**
 * [WHAT] This file verifies event queue behavior
 * [WHERE] in the IOC Event Subsystem module
 * [WHY] to ensure reliable asynchronous event delivery
 *
 * SCOPE:
 *   - In scope: Event posting, queue capacity, consumer callback
 *   - Out of scope: Event persistence (see UT_EventPersistence.cxx)
 *
 * KEY CONCEPTS:
 *   - Conet vs Conles: Connection-oriented vs connection-less event modes
 *   - EvtDescQueue: Fixed-capacity event descriptor queue
 *   - CbExecCmd_F: Callback function for immediate command processing
 */
```

This OVERVIEW is DDD's bounded context expressed as an LLM-readable comment. It tells the LLM: "Within this test file, these are the concepts. Do not cross into these other bounded contexts."

#### 2. US/AC/TC as Executable Domain Specifications

Each User Story in CaTDD maps to DDD's strategic design:

```
DDD Strategic Design               CaTDD US/AC/TC

Core Domain                →    P0 Functional (the business-critical tests)
  What makes you unique?        Typical, Edge, Misuse, Fault

Supporting Subdomain       →    P1 Design (the architectural tests)
  Necessary, not competitive    State, Capability, Concurrency

Generic Subdomain          →    P2 Quality (the infrastructure tests)
  Buy, don't build              Performance, Robust, Compatibility

Documentation/Examples     →    P3 Addons (tutorials and demos)
```

The priority framework is not just a test ordering — it is a **domain classification**. P0 tests verify your Core Domain. P1 tests validate your architecture. P2 tests check your quality attributes. The framework tells the LLM: "Focus on what makes this domain unique before optimizing infrastructure."

#### 3. Design Skeletons as Ubiquitous Language

The CaTDD design skeleton establishes Ubiquitous Language in the test file:

```cpp
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[Intent]: Prove the core event posting and delivery workflow
// @[UseWhen]: Producer and consumer are valid, queue has capacity
// @[AvoidWhen]: Queue is full, consumer is blocking, or producer is invalid
// @[US]: US-1 (event posting), US-2 (event delivery)
// @[AC]: AC-1 through AC-4
// @[TC]: TC-1 verifyEventPost_byAvailableCapacity_expectEventQueued
//        TC-2 verifyEventDelivery_byCallbackConsumer_expectEventProcessed
```

The skeleton uses domain terms consistently: "producer," "consumer," "queue," "capacity," "blocking." These are not generic test terms — they are the domain's Ubiquitous Language. The LLM reads the skeleton and understands the domain model before generating any code.

#### 4. SpecFlow Artifacts as Domain Knowledge

Px-SpecFlow's lifecycle artifacts preserve domain knowledge in version-controlled files:

```
.catdd/spec/projectContext.md     → Domain vision, bounded contexts, conventions
README_ArchDesign.md              → Strategic design, context mapping
README_DetailDesign.md            → Tactical design, aggregate boundaries
README_VerifyDesign.md            → Domain verification topology
```

These artifacts are DDD's knowledge crunching output, but in Markdown form that LLMs can read and that survives code changes.

### DDD Reconciliation Checklist

Use these checkpoints to verify DDD alignment in CaTDD artifacts:

- Scan test files for domain term consistency — is the same concept named the same way across all test files?
- Verify bounded context boundaries — does `UT_EventQueue.cxx` reference only EventQueue domain concepts, or does it leak into CommandExecutor concepts?
- Check that the OVERVIEW section declares its bounded context clearly enough for an LLM to understand
- For each aggregate root, verify there is a corresponding test file with US/AC/TC coverage

### Why DDD Matters More in the LLM Era

LLMs are domain-agnostic. They know syntax but not semantics. They can generate code for any domain but understand none of them. DDD fills this gap:

- **Ubiquitous Language gives the LLM consistent terminology** — The LLM reads the test file and sees "event producer," "event consumer," "EvtDescQueue" consistently. It learns the domain vocabulary from the test comments.
- **Bounded Contexts prevent the LLM from mixing models** — A test file for `Billing.Account` uses billing terminology. A test file for `CRM.Account` uses CRM terminology. The LLM does not confuse them because the OVERVIEW declares which context it's in.
- **Strategic Design tells the LLM what to prioritize** — The priority framework (P0 core domain, P1 supporting, P2 generic) tells the LLM where to focus its limited context window.

Without DDD, the LLM treats every test file as a flat, interchangeable code artifact. With DDD embedded in CaTDD comments, the LLM understands the domain architecture.

---

## CaTDD: The Synthesis of TDD + BDD + DDD

CaTDD is not a fourth methodology stacked on top of three others. It is the **synthesis** — the way TDD, BDD, and DDD work together in a single, LLM-readable artifact (the test file):

```
┌─────────────────────────────────────────────────────────────────┐
│                      THE CaTDD TEST FILE                         │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ OVERVIEW: Domain Context Declaration (DDD)                 │ │
│  │ WHAT, WHERE, WHY, SCOPE, KEY CONCEPTS                     │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ US: User Stories — Business Intent (BDD)                  │ │
│  │ As a [role], I want [capability], So that [value]         │ │
│  └──────────────────────────┬────────────────────────────────┘ │
│                             │ traces to                          │
│  ┌──────────────────────────▼────────────────────────────────┐ │
│  │ AC: Acceptance Criteria — Executable Specs (BDD)          │ │
│  │ GIVEN [context], WHEN [action], THEN [outcome]            │ │
│  └──────────────────────────┬────────────────────────────────┘ │
│                             │ traces to                          │
│  ┌──────────────────────────▼────────────────────────────────┐ │
│  │ TC: Test Cases — Verification Design (TDD + BDD)          │ │
│  │ @[Name]: verifyBehavior_byCondition_expectResult          │ │
│  │ @[Purpose], @[Brief], @[Steps], @[Expect], @[Notes]       │ │
│  └──────────────────────────┬────────────────────────────────┘ │
│                             │ implements                         │
│  ┌──────────────────────────▼────────────────────────────────┐ │
│  │ TEST CODE: Implementation (TDD)                            │ │
│  │ SETUP → BEHAVIOR → VERIFY → CLEANUP                       │ │
│  │ Status: ⚪ TODO → 🔴 RED → 🟢 GREEN                        │ │
│  └───────────────────────────────────────────────────────────┘ │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │ TODO TRACKING: Progress Dashboard (TDD)                    │ │
│  │ P0→P1→P2→P3 priority, status markers, quality gates       │ │
│  └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

A single test file contains:
- **DDD's bounded context** (OVERVIEW section)
- **BDD's executable specifications** (US/AC chain with GIVEN/WHEN/THEN)
- **TDD's verification cycle** (TC implementation with RED→GREEN markers)
- **DDD's strategic prioritization** (P0→P3 framework mapping to core/supporting/generic)

This is the synthesis. One file. Three classic disciplines. LLM-readable throughout.

---

## The LLM as a Knowledge Book Reader

The Knowledge Book of Software Engineering teaches us that:

| Principle | What It Means | How CaTDD Applies It |
|---|---|---|
| **Design before code** | Understand what to build before building it | Comment skeletons ARE the design |
| **Verify before releasing** | Prove correctness before shipping | RED→GREEN cycle + quality gates |
| **Speak the domain language** | Use business terms in code | OVERVIEW + US/AC use domain vocabulary |
| **Bound the model** | One model per context, don't mix them | One test file per aggregate/bounded context |
| **Test from the outside in** | Verify behavior, not implementation | GIVEN/WHEN/THEN focus on observable outcomes |
| **Small, reversible changes** | Commit small, rollback easily | One TC at a time, RED→GREEN commits |
| **Knowledge in the code** | Don't let knowledge live only in heads | Comment-alive design preserves decisions |

The LLM era does not invalidate these principles. It demands them more urgently — because without them, LLM-generated code has no guardrails.

### The LLM Reads the Knowledge Book Through CaTDD

When you share a CaTDD test file with an LLM, you are sharing the Knowledge Book encoded in comments:

```
LLM reads:   OVERVIEW section        → Learns the bounded context and domain concepts
LLM reads:   US section              → Learns the business value and actor roles
LLM reads:   AC section              → Learns the executable specifications (BDD)
LLM reads:   TC section              → Learns what to verify and how to verify it
LLM reads:   TODO tracking section   → Learns current progress and next actions
LLM reads:   TEST CODE section       → Learns the implementation patterns
LLM reads:   @[Category] tags        → Learns the test priority and risk level
```

The LLM does not need to know DDD terminology to benefit from DDD. It reads a test file that declares its bounded context in plain English (the OVERVIEW), uses consistent domain terms (the Ubiquitous Language in US/AC), and follows priority rules (the strategic design in P0→P3). The methodology is embedded in the artifact.

---

## BDD → CaTDD: From Feature Files to Comment Chains

Classical BDD uses Gherkin `.feature` files separate from test code:

```gherkin
Feature: Cash Withdrawal
  As a customer
  I want to withdraw cash from my account
  So that I can make purchases

  Scenario: Successful withdrawal
    Given my account has a balance of $100
    When I withdraw $20
    Then my balance should be $80
    And the ATM should dispense $20

  Scenario: Insufficient funds
    Given my account has a balance of $50
    When I withdraw $100
    Then the withdrawal should be rejected
    And my balance should remain $50
```

CaTDD converts this to a comment chain in the test file:

```cpp
// US-1: As a customer,
//       I want to withdraw cash
//       So that I can make purchases.
//
// AC-1: GIVEN account has balance $100,
//       WHEN customer withdraws $20,
//       THEN balance is $80,
//        AND ATM dispenses $20.
//
// AC-2: GIVEN account has balance $50,
//       WHEN customer withdraws $100,
//       THEN withdrawal is rejected,
//        AND balance remains $50.

// [@AC-1,US-1] P0 Functional / Typical
//  TC-1:
//    @[Name]: verifyWithdraw_bySufficientBalance_expectReducedBalance
//    @[Purpose]: Ensure valid withdrawals are processed correctly
//    @[Brief]: Set up account with $100, withdraw $20, verify balance $80
//    @[Expect]: Balance is $80, dispense event is triggered

TEST(AccountWithdraw, verifyWithdraw_bySufficientBalance_expectReducedBalance) {
    //===SETUP===
    Account acc(100);
    
    //===BEHAVIOR===
    auto result = acc.withdraw(20);
    
    //===VERIFY===
    ASSERT_TRUE(result.success);
    ASSERT_EQ(80, acc.balance());
    ASSERT_TRUE(result.dispensed);
}
```

The transformation preserves BDD's structure but eliminates the separation between specification and test. The GIVEN/WHEN/THEN lives in the AC comment. The scenario implementation lives in the TEST function right below it. An LLM reading this file sees the full chain from business requirement to executable verification in one continuous context.

---

## DDD → CaTDD: From Domain Models to Comment Skeletons

Classical DDD produces a domain model expressed in class diagrams, context maps, and design documents:

```
DDD Artifacts:
  - Bounded Context: Account Management
  - Aggregate Root: Account
  - Entity: Transaction
  - Value Object: Money
  - Domain Service: TransferService
  - Ubiquitous Language: balance, withdraw, deposit, transfer, overdraft
```

CaTDD embeds this domain model into the test file's OVERVIEW and design skeletons:

```cpp
//=========================================================================================
//======>BEGIN OF OVERVIEW===============================================================
/**
 * [WHAT] This file verifies Account aggregate behavior
 * [WHERE] in the Account Management bounded context
 * [WHY] to ensure correct balance operations and transfer integrity
 *
 * SCOPE:
 *   - In scope: Account withdrawal, deposit, transfer logic
 *   - Out of scope: User authentication (see UT_Authentication.cxx)
 *   - Out of scope: Notification delivery (see UT_Notification.cxx)
 *
 * KEY CONCEPTS:
 *   - Account (Aggregate Root): Manages balance and transaction history
 *   - Money (Value Object): Immutable amount + currency pair
 *   - Transaction (Entity): Recorded entry in account history
 *   - TransferService (Domain Service): Coordinates two-account transfer
 */
//======>END OF OVERVIEW==================================================================
```

The LLM reads this OVERVIEW and understands:
- This test file covers one bounded context (Account Management)
- The aggregate root is Account — tests should target Account behavior
- Money is a value object — tests should verify value equality, not identity
- Transaction is an entity — tests should verify it is recorded
- This file does NOT test authentication or notifications (out of scope)

This is DDD knowledge transferred to the LLM through structured comments.

---

## The P0→P3 Framework as Strategic DDD

CaTDD's priority framework maps directly to DDD's strategic design:

```
DDD Strategic Classification           CaTDD Priority Mapping

Core Domain                           P0 Functional
(Your competitive advantage)          (Typical, Edge, Misuse, Fault)
│                                     │
├── What makes money                  ├── Business-critical workflows
├── Unique to your business           ├── Domain-specific behavior
└── Invest most effort here           └── Complete before any other testing

Supporting Subdomain                  P1 Design
(Necessary but not unique)            (State, Capability, Concurrency)
│                                     │
├── Supports the core domain          ├── Architectural validation
├── Could be outsourced               ├── Lifecycle and FSM
└── Invest enough to keep it running  └── Complete after P0

Generic Subdomain                     P2 Quality
(Buy, don't build)                    (Performance, Robust, Compatibility)
│                                     │
├── Common to all businesses          ├── Non-functional quality
├── Use existing solutions            ├── Platform compatibility
└── Minimal custom investment         └── Complete after P1

Documentation / Education             P3 Addons
(Demo, examples, tutorials)           (Demo/Example)
```

A CaTDD CodeAgent reading this mapping understands:
- "P0 tests = this is what makes this domain valuable — invest heavily"
- "P1 tests = this is what supports the core — test architecture thoroughly"
- "P2 tests = this is infrastructure — verify quality, don't over-test"

This prevents the common LLM anti-pattern of treating all tests equally. The LLM learns to prioritize based on domain significance, not just code coverage metrics.

---

## Living Documentation in the LLM Era

The Knowledge Book teaches that documentation must evolve with code. CaTDD makes this principle concrete through **comment-alive design**:

### The Living Glossary

CaTDD test files establish a Ubiquitous Language through consistent domain terminology in comments:

- Scan only files in the target bounded context
- Filter out test utilities, framework configurations, and boilerplate
- Class names in test file names map to domain terms (e.g., `UT_Account.cxx` → Account aggregate)
- AC comments define term behavior: "GIVEN account has balance $100" — the term "balance" is defined by this condition

The LLM builds its domain glossary by reading the OVERVIEW section and the AC comments. No separate glossary file needed.

### Living Diagrams

SpecFlow's architecture-oriented SPEC docs serve as living diagrams:

- `README_ArchDesign.md` → Bounded context map, expressed in text that LLMs can read
- `README_DetailDesign.md` → Aggregate boundaries and class relationships
- `README_VerifyDesign.md` → Test topology and verification coverage

These are text documents, not images. LLMs can parse them. But they can also be rendered as diagrams using Mermaid or PlantUML when a human needs the visual. The text is the source of truth — the diagram is a view.

### BDD Reconciliation in CaTDD

Reconciliation in classical BDD means verifying that feature files, step definitions, and production code are consistent. In CaTDD, reconciliation is simpler because there is no gap:

- Feature file = AC comment in the test file
- Step definition = TC comment + TEST function in the same file
- Production code = implemented in the GREEN phase for that TC

Reconciliation checks become:
- Every AC has at least one TC that traces to it
- Every TC's assertions actually verify the AC it claims to verify
- Every production code change was driven by a RED TC

These checks can be automated by parsing the comment markers — no external BDD tool required.

---

## Applying the Knowledge Book: A Complete Example

Let's trace a feature through TDD, BDD, and DDD as CaTDD applies them:

### 1. BDD: Express the Requirement

```
US-1: As a customer,
      I want to transfer money between my accounts
      So that I can manage my funds across accounts.

AC-1: GIVEN checking account has $500 and savings account has $200,
      WHEN customer transfers $100 from checking to savings,
      THEN checking balance is $400,
       AND savings balance is $300.

AC-2: GIVEN checking account has $100,
      WHEN customer transfers $200 from checking to savings,
      THEN transfer is rejected,
       AND checking balance remains $100,
       AND savings balance is unchanged.
```

### 2. DDD: Model the Domain in OVERVIEW

```cpp
/**
 * [WHAT] This file verifies cross-account money transfer
 * [WHERE] in the Account Management bounded context
 *
 * KEY CONCEPTS:
 *   - Transfer (Domain Operation): Moves Money between two Accounts
 *   - Money (Value Object): amount + currency, immutable
 *   - Account (Aggregate Root): owns balance and transaction history
 *   - TransferLimit (Policy): maximum per-transfer amount
 */
```

### 3. TDD: Design the Test Cases

```cpp
// P0 Functional / Typical — Core Domain
//  TC-1: verifyTransfer_byBasicTransfer_expectUpdatedBalances
//    @[Purpose]: Verify the fundamental transfer operation
//    @[Brief]: Set up two accounts, transfer $100, verify both balances

// P0 Functional / Edge — Domain boundaries
//  TC-2: verifyTransfer_byExceedingBalance_expectRejected
//    @[Purpose]: Verify overdraw protection
//    @[Brief]: Attempt to transfer more than available balance

// P0 Functional / Edge — Domain precision
//  TC-3: verifyTransfer_byZeroAmount_expectNoOperation
//    @[Purpose]: Verify zero-amount transfer is a no-op
//    @[Brief]: Transfer $0, verify no balance change

// P0 Functional / Misuse — Domain misuse
//  TC-4: verifyTransfer_bySameAccount_expectRejected
//    @[Purpose]: Prevent transfer to the same account
//    @[Brief]: Set source and destination to same account
```

### 4. LLM: Implement the TDD Cycle

The LLM reads the US/AC/TC design (BDD specification + DDD domain model) and implements:

```
TC-1: RED → Implement TransferService.transfer($100) → GREEN
TC-2: RED → Implement InsufficientFunds check          → GREEN
TC-3: RED → Implement zero-amount guard clause         → GREEN
TC-4: RED → Implement same-account check               → GREEN
```

Each implementation is bounded by the domain: the LLM knows from the OVERVIEW that Transfer is a domain operation, Money is a value object, and Account is an aggregate root. The generated code uses these terms.

### 5. Review: Verify Against the Knowledge Book

```
✅ BDD: Every AC has one or more TCs — executable specifications exist
✅ DDD: OVERVIEW declares the bounded context — domain model is explicit
✅ TDD: All TCs follow RED→GREEN cycle — verification is complete
✅ Synthesis: Changes are traceable from US → AC → TC → Code → Git commit
```

---

## The Knowledge Book Applied

The Knowledge Book of Software Engineering teaches enduring principles. CaTDD is their application in the LLM era:

| Knowledge Book Principle | CaTDD Practice |
|---|---|
| TDD: Test first, code second | Comment skeleton first, LLM generates TC → RED → GREEN |
| BDD: Specify behavior, not implementation | US/AC/TC chain is the executable specification |
| DDD: Speak the domain language | OVERVIEW + US/AC use domain terms consistently |
| DDD: Bound the model | One test file per bounded context / aggregate root |
| TDD: Small, verified steps | One TC at a time, ⚪→🔴→🟢 markers |
| BDD: Keep specs and tests together | AC comments and TEST functions in same file |
| DDD: Strategic prioritization | P0(core) → P1(supporting) → P2(generic) → P3(docs) |
| SWE: Knowledge in the code | Comment-alive design preserves decisions in the artifact |

The LLM era does not make TDD, BDD, or DDD obsolete. It makes them **operational**. CaTDD is the operating system that runs TDD, BDD, and DDD on LLM hardware.

### Packaging the Knowledge Book as Agent Skills

The Knowledge Book does not live only in human-written books. CaTDD operationalizes it in two reusable agent skills that any CodeAgent can load:

**`comment-alive-test-driven-development`** — Packages CaTDD as a reusable capability. When a Copilot user loads this skill and says "use CaTDD," the agent has the full Knowledge Book at its disposal: the complete `CaTDD_methodPrompt.md`, the `CaTDD_designAndImplTemplate.cxx` template, and the `slashCommands` flow materials. The skill tells the agent WHO uses it, WHAT to create (a test file as a living design document), WHEN to apply it, WHERE to place output, WHY it matters (structured comments give LLMs the context to generate correct code), and HOW to execute (4 phases: Scope → Design → Implement → Validate).

**`user-story-centered-spec-coding`** — Packages the SpecCoding lifecycle as a reusable workflow. It tells the agent how to move work through pendingNews → todoUS → doingUS → doneUS, with CaTDD as the default testing method and typical TDD as an alternative when requested. The skill bundles the complete Px-SpecFlow lifecycle: flow document, all 27 `SPEC_*` command files, project-root README SPEC templates, and CaTDD method references as the default testing engine.

Both skills are generated from authored source by `agentSkills/makeSkill.sh`. The authored source is the durable asset; generated packages are build output. This separation preserves the Knowledge Book's integrity — the method changes in one place (methodPrompts) and propagates to all skill packages through the build script.

---

## Conclusion: The Triangle of Classic SWE

```
                         TDD
                        /   \
                       /     \
                      / CaTDD \
                     /         \
                    /           \
                 BDD-------------DDD

   TDD proves behavior.
   BDD specifies behavior.
   DDD models behavior.
   CaTDD synthesizes all three into
   one LLM-readable test file.
```

The Knowledge Book of Software Engineering is not a museum of past practices. It is the operating manual for building correct, maintainable, domain-aligned software — with or without LLMs. CaTDD is the methodology that reads that manual and translates it into comment-alive verification design that LLMs, developers, and code agents can all understand, execute, and improve.

**Comments is Verification Design. LLM Generates Code. Iterate Forward Together.**
