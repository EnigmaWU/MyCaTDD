# CaTDD Method Prompt - Test Point Discovery

This subtopic explains how to find test points before writing US/AC/TC comments. Use it after reading `CaTDD_methodPrompt-categorySemantics.md` and before filling a category prompt's `## TestPointsInMind` ideas into concrete test cases.

## Purpose

`TestPointsInMind` is a thinking aid, not a coverage quota. It should help agents discover source-backed test points without inventing behavior.

Use this rule:

```text
Source artifact -> Rule -> Concrete Example -> Open Question -> CaTDD category -> US/AC/TC
```

If a test point cannot trace back to a source artifact, ask for the missing design or mark the category file with `@[NoTestPoints]: <reason>`.

## Example Mapping First

Use Example Mapping as the first test-point discovery move for every category.

| Example Mapping card | CaTDD meaning |
| --- | --- |
| Story | The feature, capability, design concern, or quality attribute being verified. |
| Rule | The contract, design invariant, policy, threshold, source-of-truth statement, or category boundary. |
| Example | A concrete test point candidate with real inputs, state, actors, environment, and expected observable result. |
| Question | Missing acceptance criteria, missing source artifact, ambiguous threshold, unclear owner, or category-routing uncertainty. |

Workflow:

1. Name the story or design concern being verified.
2. Extract rules from the source artifact.
3. For each rule, find at least one concrete example and one counter-example when useful.
4. Capture questions instead of guessing.
5. Route each example to the CaTDD category that matches its verification lens.
6. Convert only source-backed examples into US/AC/TC.

## Category-by-Category Example Mapping Prompts

Use these prompts to turn `TestPointsInMind` into concrete examples.

| Category | Rule to Extract | Example to Ask For | Question to Preserve |
| --- | --- | --- | --- |
| Typical | Main success contract from User Story, AC, UsageDesign, or API contract. | What is the shortest valid workflow that delivers the promised output? | What observable result proves the core behavior rather than just no error? |
| Edge | Valid boundary, valid mode, or documented non-success result. | What happens at zero, empty, first, last, min, max, full, timeout, sync, async, or one-before/at boundary? | Is this still valid Edge, or did it cross into Misuse, Fault, Capability, Performance, State, Interaction, Concurrency, Diagnosis, or Security? |
| Misuse | Caller contract, precondition, or call-sequence rule. | What exact wrong caller action should be rejected safely? | Is the caller wrong, or is the world/dependency wrong? |
| Fault | Dependency, resource, environment, process, runtime, or infrastructure failure rule. | What deterministic injected fault proves graceful failure, cleanup, or recovery? | What fault injection seam makes the test repeatable? |
| State | State model, transition table, lifecycle rule, or invariant. | Which allowed or rejected transition proves the state model? | How can the state be observed without relying only on a return code? |
| Capability | Capacity source, limit, responsibility boundary, or maximum ability claim. | What below-limit, at-limit, and one-over-limit examples prove the ability contract? | Is this maximum ability, or is it speed, sustained stability, or concurrency correctness? |
| Interaction | Sequence diagram, collaboration rule, handoff contract, or orchestration policy. | Which collaborators must coordinate in what order, with what handoff data? | Is this internal design interaction, or externally visible P0 behavior? |
| Concurrency | Shared resource, synchronization rule, ownership rule, or interleaving invariant. | What controlled interleaving could lose work, duplicate work, corrupt state, or deadlock? | Can the interleaving be made deterministic enough to diagnose? |
| Performance | SLO, threshold, metric, workload, or resource budget. | What metric, target, workload, sample size, and tolerance prove the budget? | Who owns the threshold, and what environment makes the measurement meaningful? |
| Robust | Sustained-use invariant, repeat count, soak window, stress shape, or resource-churn rule. | What repeated or long-running scenario proves stable invariants and cleanup? | What evidence will make a late-cycle failure diagnosable? |
| Compatibility | Compatibility matrix, version rule, supported environment, protocol, schema, or integration contract. | Which old/new, platform, version, schema, path, locale, or encoding example proves compatibility? | What variation is supported, unsupported, or allowed to differ? |
| Configuration | Setting source, default, precedence rule, feature flag, profile, or deployment mode. | What default, override, precedence, supported combination, or invalid config proves configuration behavior? | Which setting source wins, and how is global state cleaned after the test? |
| Diagnosis | Required evidence field, surface, diagnostic contract, or explainability rule. | What log, trace, metric, stderr, health report, or error field makes the situation actionable? | What sensitive value must be absent from diagnostic output? |
| Security | Threat model, policy, trust boundary, protected asset, or compliance rule. | What allowed/denied contrast or threat attempt proves the protection property? | What source policy justifies the test, and what must not leak? |
| DemoExample | UserGuide flow, README example, onboarding path, or copy-exec command. | What smallest documented workflow can a new user run and observe? | Does this demo rely on behavior already proven by P0/P1/P2 instead of replacing it? |

## Agile Testing Quadrants in CaTDD

Agile Testing Quadrants are a balance check, not a replacement for CaTDD category identity.

CaTDD answers:

```text
What confidence lens owns this test point?
```

Agile Testing Quadrants answer:

```text
Is our overall test strategy balanced across team support and product critique?
```

Map them this way:

| Agile Quadrant | Purpose | CaTDD Categories That Often Contribute | How to Use in CaTDD |
| --- | --- | --- | --- |
| Q1 Technology-facing / supports the team | Guide implementation with fast technical feedback. | P0 Typical, Edge, Misuse, Fault; P1 State, Capability, Interaction, Concurrency. | Use for unit/component RED-GREEN slices and internal design confidence. |
| Q2 Business-facing / supports the team | Prove business rules and user-visible story behavior. | P0 Typical, Edge, Misuse, Fault; P3 DemoExample when examples are story-facing. | Use Example Mapping to connect rules and concrete examples to ACs. |
| Q3 Business-facing / critiques the product | Explore usability, workflow fit, surprise cases, and user learning. | P3 DemoExample; selected P0 Edge/Misuse scenarios; exploratory notes outside automated unit scope. | Use to discover questions and manual/exploratory gaps; do not force all Q3 items into unit tests. |
| Q4 Technology-facing / critiques the product | Evaluate quality attributes and technical risk. | P2 Performance, Robust, Compatibility, Configuration, Diagnosis, Security. | Use tactics-style questions to find measurable quality scenarios and missing source artifacts. |

Rules:

- Do not rename CaTDD categories to quadrant names.
- Do not treat quadrants as execution order; CaTDD workflow owns execution order.
- Do not force every story to fill every quadrant.
- Use quadrants to detect blind spots after category routing is done.

## Discovery Review Checklist

Before converting discovered examples into US/AC/TC, verify:

- Every example has a source-backed rule.
- Every rule has at least one concrete example or a recorded open question.
- Every unresolved question is visible and not silently converted into a test.
- Every example is routed by verification lens, not by implementation proximity.
- P2 examples have measurable thresholds, matrices, policies, or evidence surfaces.
- Q1/Q2/Q3/Q4 have been considered as a balance check where the feature risk justifies it.
