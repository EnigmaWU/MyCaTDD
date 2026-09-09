"""
CaTDD Design+Implementation Template (Python)

PURPOSE:
  Start new unit tests from a comment-alive, design-first skeleton.
  This template embodies Test-Driven Development with rich, structured comments.

USAGE:
  1. Copy this file to create new test_{feature}_{category}.py test file
     Example: tests/test_command_execution_funcValidTypical.py
     Feature comes from module-interface usage scenarios; category uses CaTDD filename tokens.
  2. Fill in OVERVIEW: what you're testing and why
  3. Draft ideas freely in comments (FreelyDrafts with discovery ledger)
  4. Structure into US/AC/TC format with explicit TestEvidenceChain
  5. Implement tests first (TDD Red->Green cycle)
  6. Track progress in TODO section

TDD WORKFLOW:
  Design -> Draft -> Structure -> Test (RED) -> Code (GREEN) -> Refactor -> Repeat

REFERENCE: methodPrompts/CaTDD_methodPrompt.md for full methodology
"""

import pytest

# =================================================================================================
# ======>BEGIN OF OVERVIEW OF THIS UNIT TESTING FILE===============================================
"""
OVERVIEW:
  [WHAT] This file verifies [specific functionality/component/behavior]
  [WHERE] in the [module name/subsystem] module
  [WHY] to ensure [key quality attributes: correctness/reliability/performance/etc.]

SUT & TEST LEVEL:
  - @[SUT]: [Declared component/class under test, e.g., ModelRouter or TaskExecutor]
  - @[TestLevel]: UnitTesting (or SysTesting / UserTesting)

SCOPE:
  - [In scope]: What IS tested in this file
  - [Out of scope]: What is NOT tested here (covered elsewhere)

KEY CONCEPTS:
  - [Concept 1]: Brief explanation of core concept
  - [Concept 2]: Brief explanation of key design pattern
  - [Concept 3]: Brief explanation of important constraint

RELATIONSHIPS:
  - Depends on: [List key dependencies]
  - Related tests: [List related test files]
  - Production code: [List source files being tested]

EXAMPLE REAL USAGE:
  This file verifies routing decision logic in the ModelRouter module
  to ensure requests are dispatched to healthy providers within budget.

  SCOPE:
    - In scope: Local provider routing, fallback policies, parameter validation
    - Out of scope: Remote network transport, provider billing synchronization

  KEY CONCEPTS:
    - ModelRouter: Core routing orchestrator determining target provider
    - FallbackPolicy: Sequential degrade rules on provider timeout or failure
    - TokenBudget: Per-session soft and hard quota bounds
"""
# ======>END OF OVERVIEW OF THIS UNIT TESTING FILE=================================================

# =================================================================================================
# ======>BEGIN OF UNIT TESTING DESIGN==============================================================
"""
📋 TEST CASE DESIGN ASPECTS/CATEGORIES

DESIGN PRINCIPLE: IMPROVE VALUE • AVOID LOSS • BALANCE SKILL vs COST

DESIGN SKELETON CONTRACT:
  In CaTDD, "design" means a comment skeleton that lives in this test file.
  Each skeleton is organized by SUT, TestLevel, Class/Priority and Category, for example:

    # =============================================================================================
    # [Class] / [Category] Design Skeleton
    # =============================================================================================
    # @[SUT]: ModelRouter
    # @[TestLevel]: UnitTesting
    # @[Class]: P0 Functional / ValidFunc
    # @[Category]: Typical
    # @[Intent]: Prove the core happy-path workflow.
    # @[UseWhen]: Inputs, state, dependencies, and caller behavior are valid.
    # @[AvoidWhen]: Scenario is mainly Edge, Misuse, Fault, State, or Concurrency.
    # @[US]: US-1
    # @[AC]: AC-1
    # @[TP]: TP-1
    # @[TC]: TC-1 verifyCore_byValidInput_expectSuccess
    # =============================================================================================

  Developers fill this skeleton to make verification intent clear.
  CodeAgents preserve and update this skeleton before generating TEST code.

TEST EVIDENCE CHAIN (WHY & HOW):
  Dual-tier evidentiary chain connecting source requirements to executable assertions:
    WHY Tier (Obligation & Target):
      Source Artifact -> Rule/Invariant -> Test Point (TP) -> Observable Oracle -> CaTDD Category
    HOW Tier (Execution & Verification):
      CaTDD Category -> US/AC/TC -> Four-Phase Test Body (SETUP->BEHAVIOR->VERIFY->CLEANUP) -> RED/GREEN

SUT BOUNDARY INVARIANT:
  The declared SUT establishes the contract dividing line:
    - Misuse: Caller violates SUT contract/precondition (SUT rejects invalid input).
    - Fault:  External dependency or environment fails SUT (SUT degrades or handles failure).

CARDINALITIES & PERSPECTIVES:
  - 1 AC : N TPs: AC is from User/Caller perspective (GIVEN context, WHEN action, THEN outcome).
                  TP is from Developer/Defensive perspective (GIVEN state, WHEN action, THEN oracle).
  - TP : TC: Target obligation (WHAT) vs. executable arrow (HOW).
             Cardinality can be 1:1, 1:N (multiple checks), N:1 (parameterized test), or 1:0 (GAP).
             Equating TC == TP hides untested requirements.

PRIORITY FRAMEWORK:
  P0 🥇 FUNCTIONAL:      Must complete before P1 (ValidFunc + InvalidFunc)
  P1 🥈 DESIGN-ORIENTED: Test after P0 (State, Capability, Interaction, Concurrency)
  P2 🥉 QUALITY-ORIENTED: Test for quality attributes (Performance, Robust, Diagnosis, Security, etc.)
  P3 🎯 ADDONS:          Optional (Demo, Examples)

DEFAULT TEST ORDER:
  P0: Typical -> Edge -> Misuse -> Fault
  P1: State -> Capability -> Interaction -> Concurrency
  P2: Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security
  P3: Demo/Example

CONTEXT-SPECIFIC ADJUSTMENTS:
  - New Public API: Complete P0 thoroughly before P1
  - Stateful/FSM: Promote State to early P1 (after Typical+Edge)
  - High Reliability: Promote Fault & Robust
  - Performance SLOs: Promote Performance to P2 level
  - Interaction-heavy: Promote Interaction when sequence or handoff design is architectural core
  - Highly Concurrent: Promote Concurrency within P1 when synchronization correctness is architectural core
  - Security-critical: Promote Security when protection properties are release blocking

RISK-DRIVEN ADJUSTMENT:
  Score = Impact (1-3) × Likelihood (1-3) × Uncertainty (1-3)
  If Score >= 18: Promote category to earlier priority

===================================================================================================
PRIORITY-0: FUNCTIONAL TESTING (ValidFunc + InvalidFunc)
===================================================================================================

ValidFunc - Verifies correct behavior with valid inputs/states.
  ⭐ TYPICAL: Core workflows and "happy paths". (MUST HAVE)
     - Purpose: Verify main usage scenarios.
     - Examples: Standard request dispatch, default model selection, normal response formatting.

  🔲 EDGE: Edge cases, limits, and mode variations. (HIGH PRIORITY)
     - Purpose: Test parameter limits and edge values.
     - Examples: Empty payload, maximum token ceiling, single-candidate fallback.

InvalidFunc - Verifies graceful failure with invalid inputs or states.
  🚫 MISUSE: Incorrect API usage patterns. (ERROR PREVENTION)
     - Purpose: Ensure proper error handling for API abuse.
     - Examples: Missing required model name, negative temperature, invalid parameter types.

  ⚠️ FAULT: Error handling and recovery. (RELIABILITY)
     - Purpose: Test system behavior under external error conditions.
     - Examples: Upstream provider returns 503, connection dropped mid-stream, disk full.

===================================================================================================
PRIORITY-1: DESIGN-ORIENTED TESTING (Architecture Validation)
===================================================================================================

  🔄 STATE: Lifecycle transitions and state machine validation.
     - Purpose: Verify component FSM correctness.
     - Examples: Uninitialized -> Ready -> Active -> Draining -> Closed.

  🏆 CAPABILITY: Maximum capacity and system limits.
     - Purpose: Test architectural limits and saturation thresholds.
     - Examples: Max concurrent requests, route cache saturation.

  🔗 INTERACTION: Collaborator sequence and handoff contracts.
     - Purpose: Validate internal collaboration and order of operations.
     - Examples: Parse -> Authorize -> RateLimit -> Route -> Log.

  🚀 CONCURRENCY: Thread safety and asynchronous synchronization.
     - Purpose: Validate async execution, locks, and task scheduling.
     - Examples: Asyncio task contention, shared token-bucket races.

===================================================================================================
PRIORITY-2: QUALITY-ORIENTED TESTING (Non-Functional Requirements)
===================================================================================================

  ⚡ PERFORMANCE: Speed, throughput, and resource usage.
     - Purpose: Validate latency bounds and memory overhead.
     - Examples: Dispatch latency < 2ms p99, memory footprint stability.

  🛡️ ROBUST: Stress, repetition, and long-running stability.
     - Purpose: Verify stability under sustained load and repeated churn.
     - Examples: 10,000 route iterations without resource exhaustion.

  🔄 COMPATIBILITY: Library and runtime compatibility.
     - Purpose: Ensure consistent behavior across versions and platforms.
     - Examples: Python 3.10 vs 3.12, pydantic v1 vs v2 compatibility.

  🎛️ CONFIGURATION: Different settings and environments.
     - Purpose: Test various configuration precedence and overrides.
     - Examples: CLI args > Environment variables > config.yaml > defaults.

  🧭 DIAGNOSIS: Observability and failure explainability.
     - Purpose: Validate structured logs, trace propagation, and actionable error messages.
     - Examples: Correlation IDs in log output, explicit error reason in exceptions.

  🔐 SECURITY: Protection properties under threat or policy.
     - Purpose: Validate authorization, secret masking, and prompt-injection safety boundaries.
     - Examples: Redaction of ApiKEY in logs, sandbox boundary enforcement.

===================================================================================================
PRIORITY-3: OTHER-ADDONS TESTING (Documentation & Tutorials)
===================================================================================================

  🎨 DEMO/EXAMPLE: End-to-end feature demonstrations.
     - Purpose: Illustrate usage patterns and best practices.
     - Examples: Complete copy-paste tutorial script, golden path demo.
"""

# =================================================================================================
# ======>BEGIN OF DISCOVERY & EVIDENCE CHAIN (FreelyDrafts)========================================
"""
SOURCE-FIRST TEST-POINT DISCOVERY (Optional living ledger in test file or FreelyDrafts)

DISCOVERY SCOPE: SUT=ModelRouter, feature=provider_routing, level=UnitTesting
DOMAIN / EXECUTION ENVIRONMENT: Python 3.11+, asyncio, zero-allocation fast path
SOURCES / RULES:
  - RouterSpec#2.1 (R-ROUTE-01: route healthy primary provider first)
  - RouterSpec#2.4 (R-ROUTE-02: fallback to secondary provider when primary returns 503)
  - RouterSpec#3.1 (R-ROUTE-03: reject invalid model identifier with ValueError)
  - RouterSpec#4.2 (R-ROUTE-04: mask ApiKEY in all debug logs and exceptions)
DIMENSIONS: ModelTier(Standard, Premium) x ProviderHealth(Healthy, Degraded, Failed) x Fallback(Enabled, Disabled)
SAMPLING: Full pairwise sweep of ModelTier x ProviderHealth
REVIEW: Self-reviewed against routing architecture specification; residual risk: upstream timeout jitter

DISCOVERY LEDGER:
 TP ID | Source/Rule   | Setup / Action                 | Observable Oracle                    | Category/Level | Disposition/Evidence
 ------|---------------|--------------------------------|--------------------------------------|----------------|----------------------
 TP-01 | Spec R-ROUTE-01| Route request with healthy env | Returns PrimaryProvider instance     | Typical/unit   | DESIGNED: US-1/AC-1/TC-1
 TP-02 | Spec R-ROUTE-01| Empty request payload          | Handled cleanly, returns valid route  | Edge/unit      | DESIGNED: US-1/AC-2/TC-1
 TP-03 | Spec R-ROUTE-03| Unknown model name provided    | Raises ValueError with model name    | Misuse/unit    | DESIGNED: US-1/AC-3/TC-1
 TP-04 | Spec R-ROUTE-02| Primary provider returns 503   | Routes to SecondaryProvider fallback | Fault/unit     | DESIGNED: US-2/AC-1/TC-1
 TP-05 | Spec R-ROUTE-04| Error raised during dispatch   | ApiKEY is masked as '***' in logs    | Security/unit  | DESIGNED: US-2/AC-2/TC-1

Discovery Gate: PASS (5 TPs identified, 0 GAPs, 0 BLOCKED)
ready_for_implementation: yes
"""
# ======>END OF DISCOVERY & EVIDENCE CHAIN=========================================================

# =================================================================================================
# ======>BEGIN OF USER STORY DESIGN================================================================
"""
USER STORIES:

 US-1: As an application developer,
       I want the router to select the optimal healthy model provider,
       So that my requests succeed reliably with minimal latency.

 US-2: As a system operator,
       I want transparent fallback and secure error diagnostics,
       So that provider outages degrade gracefully without leaking credentials.

COVERAGE MATRIX:
┌─────────────────┬──────────────────┬─────────────────┬──────────────────────────────┐
│ Model Tier      │ Provider Health  │ Fallback Policy │ Key Scenarios                │
├─────────────────┼──────────────────┼─────────────────┼──────────────────────────────┤
│ Standard        │ Healthy          │ Enabled         │ US-1: Primary dispatch       │
│ Standard        │ Degraded (503)   │ Enabled         │ US-2: Fallback activation    │
│ Premium         │ Healthy          │ Disabled        │ US-1: Direct premium route   │
└─────────────────┴──────────────────┴─────────────────┴──────────────────────────────┘
"""
# ======>END OF USER STORY DESIGN==================================================================

# =================================================================================================
# ======>BEGIN OF ACCEPTANCE CRITERIA DESIGN=======================================================
"""
ACCEPTANCE CRITERIA:

[@US-1] Optimal healthy provider routing
 AC-1: GIVEN a healthy primary provider and valid model request,
        WHEN route() is called,
        THEN the primary provider is selected and returned.

 AC-2: GIVEN a request with empty optional parameters,
        WHEN route() is called,
        THEN default configuration parameters are applied.

 AC-3: GIVEN an invalid or empty model identifier,
        WHEN route() is called,
        THEN a ValueError is raised with an actionable explanation.

[@US-2] Fault tolerance and security diagnostics
 AC-1: GIVEN the primary provider is unavailable (HTTP 503 or timeout),
        WHEN route() is called with fallback enabled,
        THEN the router automatically falls back to the secondary provider,
         AND emits a warning log with the failover cause.

 AC-2: GIVEN a provider error containing sensitive credentials,
        WHEN the error is logged or re-raised,
        THEN all ApiKEY values are replaced with masked placeholders.
"""
# ======>END OF ACCEPTANCE CRITERIA DESIGN========================================================

# =================================================================================================
# ======>BEGIN OF TEST CASES DESIGN================================================================
"""
TEST CASES DESIGN:

===================================================================================================
DETAILED FORMAT WITH STATUS:
===================================================================================================

═════════════════════════════════════════════════════════════════════════════════════════════════
📋 [CLASS: P0 Functional / ValidFunc] [CATEGORY: Typical] Core Routing Functionality
═════════════════════════════════════════════════════════════════════════════════════════════════
 @[SUT]: ModelRouter
 @[TestLevel]: UnitTesting
 @[Class]: P0 Functional / ValidFunc
 @[Category]: Typical
 @[Intent]: Prove the core happy-path routing under valid ordinary use.
 @[UseWhen]: Inputs, state, and provider dependencies are valid and healthy.
 @[AvoidWhen]: The scenario is mainly Edge, Misuse, Fault, State, Capability, or Concurrency.
 @[US]: US-1
 @[AC]: AC-1
 @[TP]: TP-01
 @[TC]: TC-1

[@AC-1,US-1] Primary provider dispatch
 🟢 TC-1: verifyRouting_byHealthyPrimary_expectPrimarySelected
     @[TP]: TP-01 (Source: RouterSpec#2.1, Rule R-ROUTE-01)
     @[Purpose]: Validate fundamental happy-path routing to healthy primary provider
     @[Brief]: Provide valid model request, verify primary provider instance returned
     @[Expect]: router.route() returns PrimaryProvider, status is ACTIVE
     @[Status]: PASSED/GREEN ✅

═════════════════════════════════════════════════════════════════════════════════════════════════
📋 [CLASS: P0 Functional / InvalidFunc] [CATEGORY: Misuse] Incorrect API Usage
═════════════════════════════════════════════════════════════════════════════════════════════════
 @[SUT]: ModelRouter
 @[TestLevel]: UnitTesting
 @[Class]: P0 Functional / InvalidFunc
 @[Category]: Misuse
 @[Intent]: Prove fast-fail validation when caller provides invalid model configuration.
 @[UseWhen]: Caller violates API contract (e.g. unknown model name, bad types).
 @[AvoidWhen]: The failure is caused by external network or provider outage.
 @[US]: US-1
 @[AC]: AC-3
 @[TP]: TP-03
 @[TC]: TC-1

[@AC-3,US-1] Invalid model identifier
 ⚪ TC-1: verifyRouting_byUnknownModel_expectValueError
     @[TP]: TP-03 (Source: RouterSpec#3.1, Rule R-ROUTE-03)
     @[Purpose]: Validate that unrecognized models are rejected immediately
     @[Brief]: Call route() with model_name="nonexistent-model", verify ValueError raised
     @[Expect]: pytest.raises(ValueError, match="Unknown model")
     @[Status]: PLANNED/TODO

═════════════════════════════════════════════════════════════════════════════════════════════════
📋 [CLASS: P0 Functional / InvalidFunc] [CATEGORY: Fault] Provider Outage & Fallback
═════════════════════════════════════════════════════════════════════════════════════════════════
 @[SUT]: ModelRouter
 @[TestLevel]: UnitTesting
 @[Class]: P0 Functional / InvalidFunc
 @[Category]: Fault
 @[Intent]: Prove graceful fallback when primary provider suffers external outage.
 @[UseWhen]: External dependency fails (e.g., HTTP 503, connection dropped).
 @[AvoidWhen]: The caller passed bad arguments (that is Misuse).
 @[US]: US-2
 @[AC]: AC-1
 @[TP]: TP-04
 @[TC]: TC-1

[@AC-1,US-2] Provider failover
 ⚪ TC-1: verifyRouting_byPrimaryUnavailable_expectSecondaryFallback
     @[TP]: TP-04 (Source: RouterSpec#2.4, Rule R-ROUTE-02)
     @[Purpose]: Validate automatic degrade to secondary provider on primary failure
     @[Brief]: Primary provider raises 503, verify route() returns SecondaryProvider
     @[Expect]: router.route() returns SecondaryProvider, failover logged
     @[Status]: PLANNED/TODO
"""
# ======>END OF TEST CASES DESIGN==================================================================
# ======>END OF UNIT TESTING DESIGN================================================================

# =================================================================================================
# ======>BEGIN OF UNIT TESTING IMPLEMENTATION=======================================================

"""
TEST CASE TEMPLATE:
  @[Name]: verifyBehavior_byCondition_expectResult
  @[Steps]:
    1) 🔧 SETUP: prepare fixtures, mock providers, build inputs
    2) 🎯 BEHAVIOR: execute function under test
    3) ✅ VERIFY: assert <= 3 key outcomes
    4) 🧹 CLEANUP: teardown resources if needed
"""


def test_verifyRouting_byHealthyPrimary_expectPrimarySelected():
    # ===>>> 🔧 SETUP <<<===
    # Build fixtures and initial conditions
    primary_mock = {"name": "primary", "healthy": True}
    secondary_mock = {"name": "secondary", "healthy": True}
    providers = [primary_mock, secondary_mock]

    # ===>>> 🎯 BEHAVIOR <<<===
    # Execute the behavior under test
    # selected = router.route(model="gpt-4", providers=providers)
    selected = providers[0]

    # ===>>> ✅ VERIFY <<<===
    # Check key expectations (keep <= 3 key assertions)
    assert selected["name"] == "primary"
    assert selected["healthy"] is True

    # ===>>> 🧹 CLEANUP <<<===
    # Reset state or close mock clients if necessary
    pass


# Fixture-based example using pytest
@pytest.fixture
def configured_router():
    """Setup reusable router instance and clean up after test."""
    # Setup
    router = {"initialized": True, "cache": {}}
    yield router
    # Teardown / Cleanup
    router["cache"].clear()


def test_verifyRouting_byCachedRoute_expectInstantReturn(configured_router):
    # ===>>> 🔧 SETUP <<<===
    configured_router["cache"]["fast-model"] = "local-provider"

    # ===>>> 🎯 BEHAVIOR <<<===
    result = configured_router["cache"].get("fast-model")

    # ===>>> ✅ VERIFY <<<===
    assert result == "local-provider"

    # ===>>> 🧹 CLEANUP <<<===
    # Handled by fixture yield
    pass


# ======>END OF UNIT TESTING IMPLEMENTATION=======================================================

# =================================================================================================
# ======>BEGIN OF TODO/IMPLEMENTATION TRACKING SECTION============================================
"""
🔴 IMPLEMENTATION STATUS TRACKING - Organized by Priority and Category

STATUS LEGEND:
  ⚪ TODO/PLANNED:      Designed but not implemented yet.
  🔴 RED/FAILING:       Test written, but production code is missing or failing.
  🟢 GREEN/PASSED:      Test written and passing.
  ⚠️ ISSUES:           Known problem needing attention.
  🚫 BLOCKED:          Cannot proceed due to external dependency.

===================================================================================================
P0 🥇 FUNCTIONAL TESTING – ValidFunc (Typical + Edge)
===================================================================================================

  🟢 [@AC-1,US-1] TC-1: verifyRouting_byHealthyPrimary_expectPrimarySelected
       - Description: Validate happy-path routing to healthy primary.
       - Category: Typical (ValidFunc)
       - Status: GREEN

  ⚪ [@AC-2,US-1] TC-1: verifyRouting_byEmptyPayload_expectDefaultConfig
       - Description: Validate defaults on empty request payload.
       - Category: Edge (ValidFunc)
       - Status: TODO

===================================================================================================
P0 🥇 FUNCTIONAL TESTING – InvalidFunc (Misuse + Fault)
===================================================================================================

  ⚪ [@AC-3,US-1] TC-1: verifyRouting_byUnknownModel_expectValueError
       - Description: Fast-fail invalid model name with ValueError.
       - Category: Misuse (InvalidFunc)
       - Status: TODO

  ⚪ [@AC-1,US-2] TC-1: verifyRouting_byPrimaryUnavailable_expectSecondaryFallback
       - Description: Fallback to secondary provider on primary 503.
       - Category: Fault (InvalidFunc)
       - Status: TODO

🚪 GATE P0: All P0 tests must be GREEN before proceeding to P1.

===================================================================================================
P1 🥈 DESIGN-ORIENTED TESTING – State, Capability, Interaction, Concurrency
===================================================================================================

  ⚪ [@AC-4,US-2] TC-1: verifyState_byRouterDraining_expectNewRequestsRejected
       - Description: State machine validation during shutdown.
       - Category: State
       - Status: TODO

  ⚪ [@AC-5,US-2] TC-1: verifyInteraction_byDispatchSequence_expectAuthBeforeRoute
       - Description: Validate collaborator sequence contracts.
       - Category: Interaction
       - Status: TODO

🚪 GATE P1: All P1 tests GREEN, architecture validated.

===================================================================================================
P2 🥉 QUALITY-ORIENTED TESTING – Performance, Robust, Compatibility, Configuration, Diagnosis, Security
===================================================================================================

  ⚪ [@AC-6,US-2] TC-1: verifySecurity_byProviderError_expectApiKeyRedacted
       - Description: Ensure ApiKEY is masked in all logs and errors.
       - Category: Security
       - Constitutional rule: K-SEC-02 (CWE-200 / Token Masking)
       - Status: TODO

  ⚪ [@AC-7,US-2] TC-1: verifyDiagnosis_byRoutingFailure_expectTraceIdInLog
       - Description: Ensure correlation IDs propagate on errors.
       - Category: Diagnosis
       - Status: TODO

🚪 GATE P2: Quality attributes validated, production ready.

===================================================================================================
P3 🎯 OTHER-ADDONS TESTING – Demo, Examples (Optional)
===================================================================================================

  ⚪ [@AC-8,US-3] TC-1: verifyDemo_byFullWorkflow_expectWorkingExample
       - Description: Golden path tutorial demonstration.
       - Category: Demo
       - Status: TODO

===================================================================================================
✅ COMPLETED TESTS
===================================================================================================

  🟢 [@AC-1,US-1] TC-1: verifyRouting_byHealthyPrimary_expectPrimarySelected
"""
# ======>END OF TODO/IMPLEMENTATION TRACKING SECTION===============================================
