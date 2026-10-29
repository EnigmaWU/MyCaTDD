# 04 applyClassicSWE

## The Knowledge Book of Software Engineering

Software engineering is not a pile of frameworks. It is a body of knowledge that survived decades because it keeps being true about the way humans build complex systems. Three disciplines in that body matter most here:

## 5W1H at a Glance

| Question | Answer |
|---|---|
| **Who** | Developers and teams applying established engineering practices with or without LLMs |
| **What** | A synthesis of TDD verification, BDD behavior specification, and DDD domain modeling |
| **When** | When a feature needs explicit behavior, domain boundaries, and executable evidence |
| **Where** | In authoritative requirements/design artifacts and source-linked test comments |
| **Why** | To ground generated code in domain intent and observable verification |
| **How** | Discover obligations, model the domain, link US/AC/TP/TC, run meaningful RED/GREEN, and review |

Short identifiers such as `US-1`, `AC-1`, and `TC-1` below are illustrative aliases for readability, not IDs to copy into project artifacts. Real CaTDD design preserves the registered project-wide Story ID and uses qualified AC/TP/TC IDs.

For current CaTDD semantics, use [CaTDD_methodPrompt.md](../../methodPrompts/CaTDD_methodPrompt.md), [CaTDD_methodPrompt-testPointDiscovery.md](../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md), [CaTDD_methodPrompt-testStructure.md](../../methodPrompts/CaTDD_methodPrompt-testStructure.md), and [Px-SpecFlow.md](../../slashCommands/flows/Px-SpecFlow.md). This chapter explains the established engineering disciplines; those sources define the current CaTDD implementation contracts.

| Discipline | Core Question | Signature Practice |
|---|---|---|
| **TDD** — Test-Driven Development | How do we prove that code works? | Write a failing test first, implement to pass, refactor |
| **BDD** — Behavior-Driven Development | How do we connect requirements to code? | GIVEN/WHEN/THEN specification, executable specifications |
| **DDD** — Domain-Driven Design | How do we model complex business domains? | Ubiquitous Language, Bounded Contexts, Aggregates, Entities |

They form a triangle, and each side answers a different part of the lifecycle:

```
                    TDD
                   /   \
                  /     \
                 / CaTDD \
                /         \
               /           \
            BDD ─────────── DDD

   BDD says what to build.     (specify behavior)
   DDD says how to model it.   (model the domain)
   TDD says how to prove it.   (verify behavior)
```

---

## The LLM Era Changes Everything — and Nothing

Large Language Models changed how we write code. They did not change what makes software good:

- **Correctness** still matters — an LLM can generate code that looks right and is subtly wrong
- **Traceability** still matters — who asked for this feature, and how do we know it is done?
- **Maintainability** still matters — code that only the LLM understands is unmaintainable
- **Domain understanding** still matters — the LLM does not know your business rules unless you write them down

```
   LLM  ×  no structure  =  more chaos, produced faster
   LLM  ×  structure     =  more verified work, produced faster
```

The classic disciplines supply that structure. CaTDD sits exactly at this intersection: **it translates the Knowledge Book into LLM-readable, comment-alive verification design.** It does not replace TDD, BDD, or DDD. It synthesizes them for the LLM era.

---

## TDD in the LLM Era

### Classical TDD: The Foundation

Test-Driven Development, formalized by Kent Beck, has three laws:

1. Write a failing test before writing production code
2. Write only enough test to fail
3. Write only enough production code to pass

```
   RED       write a test → it fails (the feature does not exist yet)
   GREEN     write minimal production code → the test passes
   REFACTOR  improve code and test structure, tests stay green
```

TDD is not really about testing. It is about **design**. Writing the test first forces you to decide the interface, the behavior, and the contract before you write the implementation. The test is your API's first client.

### TDD's Limitations Before LLMs

Classical TDD had two structural gaps:

1. **No design artifact** — the test *is* the design. But a test shows WHAT to verify, not WHY it matters. The business intent — who asked for this, what value it provides — stayed in the developer's head instead of in the file.
2. **A manual effort ceiling** — writing tests one at a time is disciplined but slow. Each test is conceived, written, debugged, and verified by hand. The number of useful scenarios always exceeds the hours available to write them.

### CaTDD: TDD Enhanced for the LLM Era

CaTDD closes both gaps by embedding **design intent** and **LLM-readability** into the TDD cycle:

| Classical TDD | CaTDD Enhancement |
|---|---|
| Test is the design | Comment-alive verification design links source requirements to US/AC/TP/TC and test code |
| What to test is implicit | Source-first discovery and P0→P3 category lenses expose obligations and gaps |
| RED→GREEN→REFACTOR | Meaningful RED→GREEN is recorded separately for `mockSysRtm` and `realSysRtm` |
| One test at a time, manually | LLM reads the design skeleton, generates test code, implements minimal production code |
| Refactoring is ad hoc | TC-by-TC review, refactoring triggered by review gate failures |
| Tests are code artifacts | Tests are living design documents — comments evolve with the code |

The LLM does not just write tests faster. It writes tests that are **traceable to design intent**. Test comments keep verification design beside the tests, while authoritative stories and project-level architecture, detail, and verification-design documents remain separate sources that the comments link to.

### The CaTDD TDD Cycle (with LLM)

```
1. DISCOVERY:    inventory source-backed rules, test points, oracles, and questions
2. DESIGN:       link registered US/AC/TP/TC IDs; classify and pass the Discovery Gate
3. TC SELECTION: select a ready test case in risk-adjusted priority order
4. RED:          run the test; only an intended domain-assertion failure is meaningful RED
5. GREEN:        make the minimum production change and verify the focused test
6. EVIDENCE:     record mockSysRtm and realSysRtm separately; review and reconcile
7. GATE:         stop on a gap, blocked source, or required human decision
```

Implementation loops are bounded by source evidence, test scope, and review gates. A compile, setup, fixture, or environment failure is `BROKEN_TEST`, not RED. `CLOSED` is earned at `mockSysRtm`; it does not claim that the real runtime was tested.

### Why TDD Matters More in the LLM Era

You might think: if an LLM can generate code, why bother with TDD at all? Three reasons:

- **LLMs generate plausible code faster than correct code.** Without a failing test, the LLM has no feedback. Without a passing test, you have no confidence.
- **LLMs lose context between conversations.** Team-shared story, domain, design, and verification artifacts preserve the authoritative context. Source-linked test comments keep the relevant verification intent close to code and readable by the next session.
- **LLMs are optimistic generators.** They assume their code works. TDD forces verification: every GREEN test is a checkpoint the model cannot hallucinate past.

```
   without TDD:  generate → looks right → ship → learn the truth in production
   with TDD:     generate → RED → GREEN → review → ship
```

TDD is not less important in the LLM era. It is **more** important. It is the grounding wire that keeps generated code from floating into plausible-but-wrong territory.

---

## BDD in the LLM Era

### Classical BDD: From Requirements to Executable Specifications

Behavior-Driven Development, pioneered by Dan North, bridges business stakeholders and developers:

```
Business language:  "As a customer, I want to withdraw cash so I can buy things"
BDD specification:  Scenario: Withdraw from account
                      Given the account has $100
                      When the customer withdraws $20
                      Then the balance is $80
Automated test:     step definitions map Given/When/Then to test code
```

BDD's core insight: **specifications should be executable**. The GIVEN/WHEN/THEN scenario is both the business requirement and the automated test. When the test passes, the requirement holds. When it fails, the requirement is broken.

### BDD's Limitations Before LLMs

Classical BDD needed three artifacts, maintained by humans:

1. **Feature files** (Gherkin `.feature`) — written by product owners or BAs
2. **Step definitions** (code mapping Gherkin steps to actions) — written by developers
3. **Production code** — written by developers

Three artifacts in two languages created maintenance friction. Feature files went stale, step definitions grew fragile, and the vision of "executable specifications" quietly became "specifications that once were executable."

### CaTDD: BDD Embedded in Test Files

CaTDD puts BDD directly into the test file as structured comments, which removes the Gherkin-to-code gap:

```
Classical BDD:                         CaTDD BDD:

Feature: CashWithdrawal.feature        test_account_funcValidTypical.cxx:
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

CaTDD's registered US and acceptance criteria remain authoritative story artifacts; qualified AC/TP/TC links bring their source-backed obligations into test design. When test comments and code share a file, they keep verification intent adjacent to execution without replacing the story or design sources.

### BDD as the CaTDD Acceptance Criteria Contract

Every CaTDD Acceptance Criterion follows the BDD format:

```
AC-n: GIVEN [preconditions and context],
      WHEN [specific action or event],
      THEN [expected observable outcome],
       AND [additional outcome if any].
```

This is not a coincidence. GIVEN/WHEN/THEN is the **canonical testable condition** in CaTDD. A living documentation reconciliation checklist keeps it honest.

### BDD Reconciliation Checklist

Set up automated reconciliation tests that assert consistency between source code, BDD specifications, and external documentation:

- Every CaTDD AC maps to one or more TC implementations — no orphan acceptance criteria, no undocumented test cases
- AC descriptions stay distinct from step-specific implementation detail — a TC verifies one AC instead of duplicating another AC's steps
- Clean Markdown reports summarize which ACs are tested, which are planned, and which are blocked

### Why BDD Matters More in the LLM Era

LLMs are pattern matchers, not business analysts. They produce convincing GIVEN/WHEN/THEN structures without being able to judge whether the THEN clause matches the real business rule. BDD inside CaTDD supplies the guardrail by splitting ownership:

```
   developer writes the AC      the business rule, in GIVEN/WHEN/THEN
   LLM generates the TC         the concrete test that verifies the AC
   developer reviews the TC     does this test verify what the AC states?
   LLM implements the code      the 4-phase test implementation
   test passes                  the AC is satisfied
```

The developer owns the business rule. The LLM owns the verification mechanism. That division is BDD optimized for the LLM era.

---

## DDD in the LLM Era

### Classical DDD: Modeling Complex Domains

Domain-Driven Design, introduced by Eric Evans, models complex business domains in software. Its core concepts:

**Ubiquitous Language** — one shared language between domain experts and developers, used consistently in code, conversation, and documentation. If the business says "policy," the code has a `Policy` class, not an `InsuranceMathHelper`.

**Bounded Contexts** — a boundary inside which a model applies. "Account" means different things in Billing (a payment account) and CRM (a customer account). Each context keeps its own model.

**Strategic Design** — the relationships between contexts: Core Domain (your competitive advantage), Supporting Subdomains (necessary, not differentiating), Generic Subdomains (buy, don't build).

**Tactical Design** — the building blocks inside a context: Entities (identity over attributes), Value Objects (attributes over identity), Aggregates (consistency boundaries), Domain Events (something happened), Repositories (retrieve aggregates), Services (stateless operations).

### DDD's Limitations Before LLMs

DDD depended on deep domain knowledge that was hard to transfer to new team members:

- **Ubiquitous Language was fragile** — one developer wrote `Customer`, another `Client`, a third `Account`, all for the same concept. The model fragmented.
- **Bounded contexts were implicit** — they lived in architects' heads and on whiteboards, not in the code.
- **Model evolution was slow** — refactoring a domain model meant updating documentation, tests, production code, and everyone's understanding, by hand.

### CaTDD: DDD as an LLM-Readable Domain Model

CaTDD brings DDD into the LLM era through four mechanisms.

#### 1. The OVERVIEW Section as Bounded Context Declaration

Every CaTDD test file starts with an OVERVIEW that declares its bounded context:

```cpp
/**
 * [WHAT] This file verifies event queue behavior
 * [WHERE] in the IOC Event Subsystem module
 * [WHY] to ensure reliable asynchronous event delivery
 *
 * SCOPE:
 *   - In scope: Event posting, queue capacity, consumer callback
 * - Out of scope: Event persistence (see test_eventPersistence_funcValidTypical.cxx)
 *
 * KEY CONCEPTS:
 *   - Conet vs Conles: Connection-oriented vs connection-less event modes
 *   - EvtDescQueue: Fixed-capacity event descriptor queue
 *   - CbExecCmd_F: Callback function for immediate command processing
 */
```

That OVERVIEW is DDD's bounded context expressed as an LLM-readable comment. It tells the LLM: inside this file these are the concepts, and these other concepts belong to other files.

#### 2. DDD Context and CaTDD Verification Links

DDD classifies domain importance; CaTDD independently classifies verification concerns. The relationship is contextual, not a one-to-one mapping:

```
DDD Domain Classification           CaTDD Verification Classification

Core Domain                    →    choose category by verification lens
(your competitive advantage)        P0/P1/P2/P3 can all apply
business importance informs risk     not a category assignment

Supporting Subdomain           →    choose category by verification lens
(necessary, not unique)             State, Capability, Interaction, etc.
domain role does not assign priority

Generic Subdomain              →    choose category by verification lens
(buy, don't build)                  Performance, Robust, Security, etc.
quality concern remains P2 regardless of domain tier

Documentation / Education      →    P3 Addons
(demos, examples, tutorials)        Demo/Example
```

The priority framework classifies what confidence a test provides: P0 contract, P1 design model, P2 operating envelope, or P3 learning surface. Domain importance can influence risk-based execution order, but it does not rename the category.

#### 3. Design Skeletons as Ubiquitous Language

The skeleton establishes Ubiquitous Language inside the test file:

```cpp
// @[Class]: P0 Functional / ValidFunc
// @[Category]: Typical
// @[SUT]: Event Queue API
// @[TestLevel]: UnitTesting
// @[TestScope]: mockSysRtm (realSysRtm when required)
// @[Intent]: Prove the core event posting and delivery workflow
// @[UseWhen]: Producer and consumer are valid, queue has capacity
// @[AvoidWhen]: Queue is full, consumer is blocking, or producer is invalid
// @[US]: US-<registered-story-id> (event posting and delivery)
// @[AC]: qualified story-specific AC IDs from README_UserStories.md
// @[TP]: qualified, source-backed TP IDs from README_DetailVerifyDesign.md
// @[TC]: qualified, story-specific TC IDs
// @[Status]: mockSysRtm <marker> | realSysRtm <marker>
```

"Producer," "consumer," "queue," "capacity," "blocking" — these are not generic test words. They are the domain's Ubiquitous Language, and the LLM reads them before generating any code.

#### 4. SpecFlow Artifacts as Domain Knowledge

Px-SpecFlow's lifecycle artifacts preserve domain knowledge in version-controlled files:

```
.catdd/spec/projectContext.md   →  domain vision, bounded contexts, conventions
README_ArchDesign.md            →  strategic design, context mapping
README_DetailDesign.md          →  tactical design, aggregate boundaries
README_UbiLang.md               →  canonical domain vocabulary
README_ArchVerifyDesign.md      →  system-composition verification strategy
README_DetailVerifyDesign.md    →  behavior inventory, discovery_ledger, category strategy
README_VerifyDesign.md          →  verification-design routing index
```

These are DDD's knowledge-crunching output in Markdown form: readable by LLMs, reviewable by humans, and durable across code changes.

### DDD Reconciliation Checklist

Use these checkpoints to verify DDD alignment:

- Scan test files for domain term consistency — is the same concept named the same way everywhere?
- Verify bounded context boundaries — does `test_eventQueue_funcValidTypical.cxx` reference only EventQueue concepts, or does it leak `CommandExecutor` concepts?
- Check that the OVERVIEW declares its bounded context clearly enough for an LLM to understand
- For each in-scope aggregate behavior, verify a source-linked discovery and test record exists; do not infer completeness from a file or link count

### Why DDD Matters More in the LLM Era

LLMs are domain-agnostic. They know syntax, not semantics. They can generate code for any domain and understand none of them. DDD fills that gap:

- **Ubiquitous Language gives the LLM consistent terminology** — it reads "event producer," "event consumer," "EvtDescQueue" and learns the domain vocabulary from the comments
- **Bounded Contexts stop the LLM from mixing models** — a `Billing.Account` test file uses billing terms, a `CRM.Account` file uses CRM terms, and the OVERVIEW says which one you are in
- **Strategic Design tells the LLM which domain model applies** — category identity is still chosen by the CaTDD verification lens, not by whether a subdomain is core, supporting, or generic

Without DDD, the LLM can treat every test file as a flat, interchangeable artifact. With canonical `README_UbiLang.md`, bounded-context design, and consistent CaTDD comments, domain meaning is explicit without making comments the sole source of truth.

---

## CaTDD: The Synthesis of TDD + BDD + DDD

CaTDD is not a fourth methodology stacked on top of three others. It connects TDD, BDD, and DDD through authoritative sources, living verification design, and executable test evidence. No single test file replaces the project's story, domain, and design artifacts.

```
   ┌───────────────────────────────────────────────────────────────┐
   │              THE CaTDD VERIFICATION EVIDENCE                   │
   │                                                               │
   │  AUTHORITATIVE SOURCES: domain, story, design                  │
   │                          │ source-backed                       │
   │  TP: obligation + observable oracle in verification design    │
   │                          │ routed into                         │
   │  US: registered User Story — business intent (BDD)            │
   │  As a [role], I want [capability], So that [value]            │
   │                          │ traces to                          │
   │  AC: qualified Acceptance Criteria (BDD)                      │
   │  GIVEN/WHEN/THEN with canonical terms and normative outcomes  │
   │                          │                                    │
   │  TC: Test Cases — Verification Design (TDD + BDD)             │
   │  qualified IDs + scope-specific status + @[Expect]            │
   │                          │ implements                         │
   │  TEST CODE: Implementation (TDD)                              │
   │  SETUP → BEHAVIOR → VERIFY → CLEANUP                          │
   │  Status: mockSysRtm | realSysRtm                              │
   └───────────────────────────────────────────────────────────────┘
```

The test file keeps relevant verification design beside executable evidence; it links to, but does not replace, authoritative story, domain, and verification-design artifacts.

- **DDD's bounded context** — the OVERVIEW section
- **BDD's behavior contract** — registered US/AC identities and canonical GIVEN/WHEN/THEN outcomes
- **Source-backed discovery** — qualified TPs and the verification-design ledger
- **TDD's verification cycle** — TC implementation with scope-specific RED/GREEN evidence
- **DDD's domain model** — bounded context and canonical terms from project design sources

---

## The LLM as a Knowledge Book Reader

The Knowledge Book teaches a handful of principles. CaTDD turns each one into something an LLM can act on:

| Principle | What It Means | How CaTDD Applies It |
|---|---|---|
| **Design before code** | Understand what to build before building it | Comment skeletons ARE the design |
| **Verify before releasing** | Prove correctness before shipping | RED→GREEN cycle + quality gates |
| **Speak the domain language** | Use business terms in code | OVERVIEW + US/AC use domain vocabulary |
| **Bound the model** | One model per context, don't mix them | One test file per aggregate/bounded context |
| **Test from the outside in** | Verify behavior, not implementation | GIVEN/WHEN/THEN focuses on observable outcomes |
| **Small, reversible changes** | Commit small, roll back easily | One TC at a time, RED→GREEN commits |
| **Knowledge in the code** | Don't let knowledge live only in heads | Comment-alive design preserves decisions |

### The LLM Reads the Knowledge Book Through CaTDD

When you share a CaTDD test file with an LLM, you are handing it the Knowledge Book encoded in comments:

```
   LLM reads   OVERVIEW section       → learns the bounded context and concepts
   LLM reads   US section             → learns business value and actor roles
   LLM reads   AC section             → learns the executable specifications (BDD)
   LLM reads   TC section             → learns what to verify and how
   LLM reads   TODO tracking section  → learns progress and next actions
   LLM reads   TEST CODE section      → learns the implementation patterns
   LLM reads   @[Category] tags       → learns priority and risk level
```

The LLM does not need to know the term "DDD" to benefit from DDD. It reads a file that declares its bounded context in plain English, uses consistent domain terms, and follows priority rules. The methodology is embedded in the artifact.

---

## BDD → CaTDD: From Feature Files to Comment Chains

Classical BDD keeps Gherkin `.feature` files separate from test code:

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

CaTDD converts it into a comment chain inside the test file:

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

The structure of BDD survives; the separation between specification and test does not. GIVEN/WHEN/THEN lives in the AC comment, and the scenario implementation sits right below it. An LLM reading the file sees the whole chain — business requirement to executable verification — in one continuous context.

---

## DDD → CaTDD: From Domain Models to Comment Skeletons

Classical DDD produces a domain model as class diagrams, context maps, and design documents:

```
DDD artifacts:
  - Bounded Context: Account Management
  - Aggregate Root: Account
  - Entity: Transaction
  - Value Object: Money
  - Domain Service: TransferService
  - Ubiquitous Language: balance, withdraw, deposit, transfer, overdraft
```

CaTDD declares the SUT and bounded-context terms in the test overview, and links them to the canonical domain and design sources:

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
 *   - Out of scope: User authentication (see test_authentication_funcValidTypical.cxx)
 *   - Out of scope: Notification delivery (see test_notification_funcValidTypical.cxx)
 *
 * KEY CONCEPTS:
 *   - Account (Aggregate Root): Manages balance and transaction history
 *   - Money (Value Object): Immutable amount + currency pair
 *   - Transaction (Entity): Recorded entry in account history
 *   - TransferService (Domain Service): Coordinates two-account transfer
 */
//======>END OF OVERVIEW==================================================================
```

From this OVERVIEW the LLM learns: this file covers one bounded context; the aggregate root is Account, so tests target Account behavior; Money is a value object, so tests verify value equality rather than identity; Transaction is an entity, so tests verify it gets recorded; and authentication and notifications are explicitly out of scope.

---

## The P0→P3 Framework and DDD

Do not equate CaTDD priority classes with DDD subdomains. CaTDD categories are verification lenses; DDD classifies the domain model. A core-domain behavior can require P0 contract tests and P1/P2 evidence, while a generic component can still have important P0 behavior.

```
  DDD domain role                  CaTDD verification lens
  ───────────────                  ────────────────────────
  Core Domain       ─┐
  Supporting        ─┼─ each may need any category, based on the
  Generic           ─┘  source-backed behavior and risk surface
                                │
  Example: core workflow ──────► P0 Functional
  Example: core concurrency ───► P1 Concurrency
  Example: generic API contract ► P0 Functional
  Example: documented demo ────► P3 Addons
```

DDD domain significance can inform risk and execution ordering, but it does not reclassify a test point. P0 is addressed first under the flow gates; a P1/P2 promotion still needs the applicable source evidence and review.

---

## Living Documentation in the LLM Era

The Knowledge Book says documentation must evolve with code. CaTDD makes that concrete through **comment-alive design**.

### The Living Glossary

CaTDD test files establish a Ubiquitous Language through consistent domain terminology:

- Scan only the files inside the target bounded context
- Filter out test utilities, framework configuration, and boilerplate
- Map canonical test file names to domain terms — `test_account_funcValidTypical.cxx` concerns the Account aggregate's Typical contract
- Let AC comments define term behavior — "GIVEN account has balance $100" is where "balance" gets defined

The LLM reads the project-root `README_UbiLang.md` as the canonical glossary, then follows consistent terms in OVERVIEW and AC comments. Comments must not introduce competing synonyms.

### Living Diagrams

SpecFlow's architecture-oriented SPEC docs act as living diagrams:

```
   README_ArchDesign.md     →  bounded context map
   README_DetailDesign.md   →  aggregate boundaries and class relationships
   README_ArchVerifyDesign.md   →  system-composition verification strategy
   README_DetailVerifyDesign.md →  behavior inventory, discovery_ledger, and category strategy
   README_VerifyDesign.md       →  verification-design routing index
```

These are text documents, which is why LLMs can parse them, but they can also be rendered as Mermaid or PlantUML diagrams when a human wants the picture. The text stays the source of truth; the diagram is a view.

### From Gherkin to CaTDD's Linked Verification Evidence

In classical BDD, reconciliation checks that feature files, step definitions, and production code agree. CaTDD keeps the relevant test design near executable code while retaining authoritative project artifacts:

```
   source artifacts = registered story, AC, domain, and design contracts
   test design      = source-linked TP / AC / TC comments and ledger entries
   test evidence    = TC implementation and scope-specific results
   production code  = changed in response to meaningful RED evidence
```

The checks become:

- Each in-scope AC has source-backed TP/TC design or an explicit unresolved disposition
- Every TC's assertions actually verify the AC it claims to verify
- RED is distinguished from broken setup/harness execution; meaningful GREEN earns `CLOSED` at `mockSysRtm`

Tooling may parse structured comment markers, but CaTDD's method contracts define their meaning; parsing alone does not establish traceability or coverage.

---

## Applying the Knowledge Book: A Complete Example

Here is one feature traced through all three disciplines and both roles.

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
// P0 Functional / Typical — ordinary successful behavior
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

The LLM reads the authoritative story and domain sources, then follows source-backed TP/oracle and qualified AC/TC design while implementing each case:

```
TC-1: RED → implement TransferService.transfer($100)   → GREEN
TC-2: RED → implement InsufficientFunds check          → GREEN
TC-3: RED → implement zero-amount guard clause         → GREEN
TC-4: RED → implement same-account check               → GREEN
```

Each implementation is bounded by the domain: the LLM knows from the OVERVIEW that Transfer is a domain operation, Money is a value object, and Account is an aggregate root, so the generated code uses those names.

### 5. Review: Verify Against the Knowledge Book

```
✅ BDD: each in-scope AC links to its source-backed TP/TC design
✅ DDD: OVERVIEW declares the bounded context — the domain model is explicit
✅ TDD: meaningful GREEN is recorded at mockSysRtm; realSysRtm evidence is separate
✅ Synthesis: source → TP/oracle → US/AC/TC → test evidence is traceable
```

---

## The Knowledge Book Applied

| Knowledge Book Principle | CaTDD Practice |
|---|---|
| TDD: test first, code second | Comment skeleton first, LLM generates TC → RED → GREEN |
| BDD: specify behavior, not implementation | Registered US/AC and source-linked TP/TC evidence |
| DDD: speak the domain language | OVERVIEW + US/AC use canonical project terms consistently |
| DDD: bound the model | Declare the SUT/bounded context and link to authoritative domain design |
| TDD: small, verified steps | One ready TC at a time, with scope-specific status |
| BDD: keep specs and tests together | Keep relevant verification comments near tests while linking to authoritative story and design sources |
| DDD: strategic prioritization | Domain role informs risk; CaTDD category follows the verification concern |
| SWE: knowledge in the code | Comment-alive design preserves decisions in the artifact |

The LLM era does not make TDD, BDD, or DDD obsolete. It makes them **operational**. CaTDD is the operating system that runs all three on LLM hardware.

### Agent Skills and Canonical Sources

Agent skills are task-oriented entry points, not a replacement source of CaTDD semantics. `comment-alive-test-driven-development` guides creation of new CaTDD tests; `UnitTesting-convert2CaTDD` addresses conversion of existing tests. For current category meaning, traceability, discovery, status, and workflow requirements, follow `methodPrompts/` and `slashCommands/` rather than assuming a packaged skill reference is current.

**`user-story-centered-spec-coding`** packages the SpecCoding lifecycle as a reusable workflow. It tells the agent how to move work through pendingNews → todoUS → doingUS → doneUS, with abortUS preserving unsafe active stories for later analysis, CaTDD as the default testing method, and typical TDD as an alternative when requested. The skill bundles the complete Px-SpecFlow lifecycle: the flow document, all 27 `SPEC_*` command files, project-root README SPEC templates, and CaTDD method references as the default testing engine.

```
   authored source (methodPrompts/)          generated packages
        │                                          │
        └── agentSkills/makeSkill.sh ──────────────┴─► skill packages
            the durable asset                        build output
```

Both skills are generated from authored source by `agentSkills/makeSkill.sh`. The authored source is the durable asset; the generated packages are build output. That separation preserves the Knowledge Book's integrity: the method changes in one place, and the change propagates to every skill package through the build script.

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
   CaTDD links all three through
   source-backed verification design and test evidence.
```

The Knowledge Book of Software Engineering is not a museum of past practices. It is the operating manual for building correct, maintainable, domain-aligned software—with or without LLMs. CaTDD connects its practices through source-backed discovery, canonical domain language, registered US/AC/TP/TC identities, and test evidence. Living comments travel with tests; authoritative story, architecture, and verification-design artifacts remain their sources.

**Comments is Verification Design. LLM Generates Code. Iterate Forward Together.**

## Usage Example

Use this prompt in an assistant with access to the project sources and CaTDD method files:

```text
Apply TDD, BDD, and DDD through CaTDD.
Read the authoritative story, Ubiquitous Language, design, and verification
sources first. Inventory source-backed obligations and observable oracles.
Do not treat the test comment as a replacement for those sources.
Create or preserve the registered Story ID and qualified AC/TP/TC IDs.
Design and review the test before implementation; establish meaningful RED,
then GREEN at mockSysRtm. Record realSysRtm separately if required.
```

Expected result: a source-linked design and a test plan that distinguishes mocked closure from real-runtime evidence.
