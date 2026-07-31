# CaTDD method prompt for Category: Diagnosis

Use this prompt when designing P2 Quality tests for observability, debuggability, actionable evidence, and failure explainability.

## Position

Diagnosis belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security
```

Diagnosis proves that when behavior succeeds, degrades, or fails, the system leaves enough evidence for humans and tools to understand what happened.

## Use When

- Logs, traces, metrics, health output, debug output, or diagnostic reports are part of the quality contract.
- Errors must include actionable evidence without leaking unsafe information.
- CLI stderr, service health details, or operation reports must help users recover.
- The design includes correlation IDs, event IDs, structured fields, or failure classification.

## Do Not Use When

- The concern is only whether the operation succeeds or fails; use P0 Functional.
- The concern is recovery or survival under stress; use Robust.
- The concern is preventing information disclosure; use Security.
- The concern is internal component sequence; use Interaction.

## Design Focus

- Define which evidence must exist and who consumes it.
- Verify diagnostic output is stable enough for operators or tools.
- Check that messages are actionable and tied to the failing cause.
- Avoid asserting noisy prose when structured fields or codes are available.

## Design Skeleton

```text
// @[Class]: P2 Quality
// @[Category]: Diagnosis
// @[Intent]: Prove behavior leaves actionable diagnostic evidence.
// @[UseWhen]: Logs, traces, metrics, health, stderr, or debug reports are part of the quality contract.
// @[AvoidWhen]: The scenario is only success/failure correctness, robustness, security, or internal interaction.
// @[EvidenceSurface]: [logs, traces, metrics, stderr, health endpoint, report]
// @[RequiredFields]: [correlation ID, component, cause, remediation, status]
// @[TC]: verify[Behavior]_by[DiagnosticScenario]_expect[ActionableEvidence]
```

## US/AC/TC Pattern

```text
US-n: As an operator or developer,
      I want [behavior] to emit [diagnostic evidence],
      So that [failure or state can be understood and acted on].

AC-n: GIVEN [operation context with observable diagnostic surface],
      WHEN [success, degradation, or failure occurs],
      THEN [required evidence is emitted],
       AND [the evidence is actionable and safe to expose].

TC-n:
  @[Name]: verify[Behavior]_by[DiagnosticScenario]_expect[ActionableEvidence]
  @[Purpose]: Validate observability or failure explainability.
  @[Brief]: Execute the scenario, collect diagnostic evidence, verify stable fields and actionable content.
  @[Expect]: Evidence identifies component, cause, correlation, and next action without unsafe leakage.
```

## Naming Examples

```text
verifyCommandFailure_byMissingConfig_expectActionableStderr
verifyRequestTrace_byDependencyTimeout_expectCorrelationIdAndCause
verifyHealthReport_byDatabaseDown_expectDegradedStatusWithReason
verifyMetricEmission_byRetryLoop_expectRetryCountAndOutcome
```

## Checklist

- Who consumes the evidence: developer, operator, user, support tool, or automated monitor?
- Which evidence surface is authoritative?
- Are required structured fields defined?
- Does the evidence explain cause and next action?
- Does the evidence avoid secrets, tokens, PII, or misleading detail?

## Common Mistakes

- Treating Diagnosis as Robust because both involve failures.
- Asserting entire log strings instead of stable fields or codes.
- Emitting noisy evidence that cannot guide action.
- Forgetting to test that sensitive values are not exposed.
