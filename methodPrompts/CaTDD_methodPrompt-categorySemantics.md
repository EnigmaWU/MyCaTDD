# CaTDD Method Prompt - Category Semantics

This subtopic defines how CaTDD class/category identity works. Use it when deciding where a test point belongs before writing US/AC/TC comments or category-specific test files.

## Core Rule

CaTDD categories are not labels added after tests are written. They are:

- Thinking lenses before design: what kind of confidence does this test provide?
- Routing rules during skeleton creation: which category file owns this test point?
- Review gates before implementation: what source artifact justifies this test?

Category identity stays in place. Risk may move a category earlier in execution order, but it does not rename or reclassify the test.

## Verification Lenses

| Class | Confidence Lens | Core Question |
| --- | --- | --- |
| P0 Functional | Contract | Does the user-visible contract behave correctly? |
| P1 Design | Model | Does the internal state, capability, or concurrency model hold? |
| P2 Quality | Envelope | Does the behavior remain acceptable under quality constraints? |
| P3 Addons | Learning Surface | Does the demo, example, or guide remain executable and useful? |

## Source-of-Truth Gate

Use the category's source artifact to decide whether a test point is valid.

| Class | Category Family | Primary Source of Truth | Missing Source Behavior |
| --- | --- | --- | --- |
| P0 Functional | Typical / Edge / Misuse / Fault | User Story, Acceptance Criteria, UsageDesign, API contract | Ask for AC/usage contract or mark `@[NoTestPoints]` |
| P1 Design | State / Capability / Concurrency | ArchDesign, DetailDesign, StateDesign | Ask where the design model lives before drafting tests |
| P2 Quality | Performance / Robust / Compatibility / Configuration | PerfDesign, ResourceDesign, CompatDesign, ErrorDesign, DiagnosisDesign, VerifyDesign | Ask for measurable constraints, compatibility rules, or config matrix |
| P3 Addons | Demo/Example | UserGuide, README examples, demo scripts | Ask for executable example intent or mark `@[NoTestPoints]` |

Do not invent test points to fill a category file. A category file with `@[NoTestPoints]: <reason>` is a valid living design decision.

## P0 Functional Split

P0 Functional proves the external contract.

| Category | Caller | Environment | Meaning |
| --- | --- | --- | --- |
| Typical | Correct | Normal | Expected success path |
| Edge | Correct | Normal | Valid but uncommon success path |
| Misuse | Wrong | Any | Caller violated the contract |
| Fault | Correct | Wrong | World, dependency, resource, runtime, or environment failed |

Classification rules:

- Typical: valid caller, normal environment, common path.
- Edge: valid caller, normal environment, unusual but accepted boundary or mode.
- Misuse: invalid caller behavior, invalid input, invalid state request, or API contract violation.
- Fault: valid caller behavior, but dependency, resource, filesystem, network, hardware, runtime, or environment fails.

## P1 Design Split

P1 Design proves the internal design model.

- State protects lifecycle, transitions, invariants, and invalid transition handling.
- Capability protects designed capability boundaries, limits, and component responsibilities.
- Concurrency protects ownership, ordering, synchronization, race freedom, and deadlock avoidance.

Concurrency belongs to P1 when the concern is correctness of the concurrency model. It feeds P2 Robust or Performance when the concern is sustained stress, throughput, latency, or long-running concurrent operation.

## P2 Quality Split

P2 Quality proves the operating envelope.

- Performance proves latency, throughput, timing, power, memory, or resource budgets.
- Robust proves stability under repetition, stress, degraded conditions, or long-running use.
- Compatibility proves version, platform, protocol, schema, toolchain, or integration compatibility.
- Configuration proves defaults, precedence, feature flags, environment variables, and invalid configuration behavior.

## P3 Addons Split

P3 Addons proves the learning surface.

- Demo/Example validates documentation-oriented examples, tutorial flows, and onboarding usage.
- P3 does not replace P0 contract tests; it proves that humans and agents can understand and exercise the capability.

## Filename Tokens

Use `test_{feature}_{category}.<ext>` for category-specific files. `{feature}` is a stable lower_snake_case usage slice. `{category}` must use one of these canonical tokens.

| CaTDD class/category | Filename token |
| --- | --- |
| P0 Functional / ValidFunc / Typical | `funcValidTypical` |
| P0 Functional / ValidFunc / Edge | `funcValidEdge` |
| P0 Functional / InvalidFunc / Misuse | `funcInvalidMisuse` |
| P0 Functional / InvalidFunc / Fault | `funcInvalidFault` |
| P1 Design / State | `designState` |
| P1 Design / Capability | `designCapability` |
| P1 Design / Concurrency | `designConcurrency` |
| P2 Quality / Performance | `qualityPerformance` |
| P2 Quality / Robust | `qualityRobust` |
| P2 Quality / Compatibility | `qualityCompatibility` |
| P2 Quality / Configuration | `qualityConfiguration` |
| P3 Addons / Demo/Example | `addonDemoExample` |

## Routing Checklist

Before placing a test point:

1. Ask what confidence the test provides: contract, model, envelope, or learning surface.
2. Check the source-of-truth artifact for that category.
3. Route the test to the matching category file.
4. If no source exists, ask the developer or use `@[NoTestPoints]: <reason>`.
5. If risk is high, move execution earlier without changing the category token.
