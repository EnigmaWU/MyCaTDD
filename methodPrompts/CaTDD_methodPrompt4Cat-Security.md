# CaTDD method prompt for Category: Security

Use this prompt when designing P2 Quality tests for protection properties, threat boundaries, secret handling, authorization, and hostile or risky conditions.

## Position

Security belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security
```

Security proves that the system preserves protection properties under a defined threat model. Security architecture shape may feed P1 Design categories, but behavior that enforces confidentiality, integrity, authorization, sandboxing, or least privilege belongs here.

## Use When

- The system must enforce authentication, authorization, permissions, tenant isolation, sandboxing, or least privilege.
- Inputs may be malicious, injected, replayed, tampered with, or used to cross trust boundaries.
- Secrets, credentials, tokens, private data, or sensitive configuration must be protected.
- A SecurityDesign, threat model, policy, or compliance rule defines expected protection behavior.

## Do Not Use When

- The scenario is ordinary invalid caller input without a threat or protection property; use Misuse.
- The concern is internal trust-boundary structure or security component collaboration; use Interaction or Capability.
- The concern is diagnostic evidence quality; use Diagnosis.
- The source artifact does not define a threat, policy, or protection requirement; ask before drafting tests.

## Design Focus

- Name the protected asset and threat actor.
- Define the trust boundary, policy, and denied behavior.
- Verify both allowed and denied paths where the policy requires contrast.
- Check that failure is safe, deterministic, and does not leak secrets.

## TestPointsInMind

When this category applies, consider test points such as:

- A policy-backed allowed/denied contrast: authorized actor succeeds, unauthorized actor is denied, and the denial is safe.
- Trust-boundary attempts: cross-tenant access, sandbox escape, path traversal, command injection, replay, tampering, or privilege escalation.
- Secret and sensitive-data handling: token redaction, credential omission, private data isolation, safe logs, and safe error output.
- Integrity protection: signed payload validation, checksum mismatch, stale nonce, invalid signature, or unauthorized mutation is rejected.
- Source trace to SecurityDesign, threat model, policy, or compliance rule; if no source exists, stop and ask instead of inventing fear-based tests.

## Design Skeleton

```text
// @[Class]: P2 Quality
// @[Category]: Security
// @[Intent]: Prove a defined protection property under a threat model or policy.
// @[UseWhen]: Authentication, authorization, secrets, injection, sandboxing, or trust boundaries matter.
// @[AvoidWhen]: The scenario is only ordinary misuse, design interaction, diagnosis, or unspecified fear.
// @[ProtectedAsset]: [asset or boundary]
// @[ThreatOrPolicy]: [threat actor, policy, or security rule]
// @[TC]: verify[Protection]_by[ThreatScenario]_expect[SafeDenialOrContainment]
```

## US/AC/TC Pattern

```text
US-n: As the owner of [protected asset],
      I want [security policy] enforced under [threat scenario],
      So that [confidentiality, integrity, availability, or boundary] is preserved.

AC-n: GIVEN [policy, actor, protected asset, and trust boundary],
      WHEN [threat or unauthorized behavior is attempted],
      THEN [the behavior is denied, contained, or sanitized],
       AND [no sensitive evidence is leaked].

TC-n:
  @[Name]: verify[Protection]_by[ThreatScenario]_expect[SafeDenialOrContainment]
  @[Purpose]: Validate a defined security protection property.
  @[Brief]: Arrange policy and actor context, attempt threat behavior, verify denial or containment.
  @[Expect]: Protection holds and observable failure remains safe.
```

## Naming Examples

```text
verifySecretHandling_byCommandFailure_expectTokenNotLogged
verifyAuthorization_byCrossTenantRequest_expectAccessDenied
verifyInputParser_byInjectionPayload_expectPayloadRejected
verifySandbox_byDisallowedFileAccess_expectOperationContained
```

## Checklist

- What protected asset or trust boundary is under test?
- What SecurityDesign, threat model, policy, or compliance rule defines expected behavior?
- Which actor is authorized, unauthorized, malicious, or compromised?
- What safe failure behavior is expected?
- What must not be leaked in logs, errors, traces, or output?

## Common Mistakes

- Treating every invalid input as Security instead of Misuse.
- Writing security tests without a source threat model or policy.
- Testing only denial without verifying no secret or sensitive detail leaked.
- Mixing security architecture structure with protection behavior in one category.
