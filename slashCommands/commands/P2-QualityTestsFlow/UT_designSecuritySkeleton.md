# UT_designSecuritySkeleton

## Purpose

Design a CaTDD Security skeleton from project-root `README_SecurityDesign.md` and constitutional invariants ($K$).

Use this command after P0 functional coverage exists and the component enforces authentication, authorization, data protection, secret isolation, sandboxing, or threat-model defenses.

## CoT Pattern

**ReACT** — Reasoning + Acting. Security is easily confused with P0 Misuse. The loop's gate is the threat model and constitutional boundary: Misuse verifies ordinary invalid caller input; Security proves protection of sensitive assets, safe denial under threat scenarios, credential redaction, and compliance with constitutional invariants ($K$). Every AC is checked against that boundary.

### ReACT Execution

Repeat until every AC is verifiable, tied to a threat model or constitutional rule ($K$), and sourced.

1. **Thought** — Design-source gate first: check project-root `README_SecurityDesign.md` exists. If project-root `README_SecurityDesign.md` is missing, stop before drafting the Security skeleton and warn the developer with a **WARNING**. Then read it as the security and threat-model source, along with constitutional invariants ($K$) in `projectContext.md`.
2. **Action** — Draft only the Security skeleton with the full `@[...]` metadata set (`@[SUT]`, `@[Class]`, `@[Category]`, `@[ProtectedAsset]`, `@[ThreatOrPolicy]`, `@[ConstitutionalRule]`, `@[US]`, `@[AC]`, `@[TC]`). Cover allowed/denied contrasts, credential redaction, sandbox containment, and CWE exclusion. Preserve unrelated categories.
3. **Observation** — Check the Misuse boundary: an AC describing ordinary invalid input without a security protection property belongs to P0 Misuse → back to **Thought**. Check that every test assertion verifies real SUT protection (status 401/403, sanitized output, redaction) rather than mock-asserting-mock (Anti-Test-Theater). Check that no secrets are exposed in test assertions or expectations.
4. **Stop** — Exit when every AC is grounded in a threat model or constitutional rule ($K$). Recommend another P2 category or `UT_reviewQualityTestsSkeleton`.

### Worked Example

Adding security coverage:

```text
/UT_designSecuritySkeleton
feature_name: session token validation and credential redaction
target_test_file: services/auth/SysTests/UT_TokenAuth.ts
```

Expected result:

- **Thought**: `README_SecurityDesign.md` exists → gate passes. It defines `K-SEC-02` (credential isolation) and cross-tenant access denial.
- **Action**: US-10 drafted with AC-25 (cross-tenant request denied with HTTP 403, zero data leaked) and AC-26 (authentication failure logs ApiKEY masked as `***`).
- **Observation**: a third AC read "empty password returns 400" — that is ordinary invalid input, covered by P0 Misuse AC-04 → wrong category → back to **Thought** → removed from Security.
- **Observation**: AC-25 and AC-26 state explicit protection oracles and map to `K-SEC-02` and `K-SEC-03` → gate passes.
- **Stop**: two verified security ACs, sourced. Recommended `UT_reviewQualityTestsSkeleton`.

## Inputs

- `interface_or_protocol_file`: API, protocol, header, schema, or behavior contract.
- `feature_name`: feature under test.
- `target_test_file`: test file to create or update.
- `existing_skeletons`: P0/P1 skeletons that define stable behavior.
- `security_design_doc`: required project-root `README_SecurityDesign.md` with threat model, trust boundaries, constitutional invariants ($K$), and protection policies.

## Preconditions

- Project-root `README_SecurityDesign.md` must exist before drafting the Security skeleton.
- WARNING: If project-root `README_SecurityDesign.md` is missing, stop before drafting the Security skeleton and warn the developer.
- If `README_SecurityDesign.md` is stale or incomplete, warn the developer and recommend updating it with `SPEC_takeDetailDesign` or `SPEC_updateDetailDesign` before continuing.

## Method References

- [P2-QualityTestsFlow](../../flows/P2-QualityTestsFlow.md)
- [README_SecurityDesignTemplate](../../templates/README_SecurityDesignTemplate.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_methodPrompt4Cat-Security](../../../methodPrompts/CaTDD_methodPrompt4Cat-Security.md)

## Skill Integration Policy

- Skill-first rule: if relevant security and architecture skills exist in the workspace, use them to enrich security skeleton design.
- Preferred skills and usage:
  - `apply-architectural-tactics` for security tactics (detect, resist, react, recover) and formulating 6-part security quality attribute scenarios.
  - `design-tool-use-sandboxing` for agent tool classification (safe read-only vs. dangerous mutative) and designing human-in-the-loop approval test cases.
  - `analyze-with-tactics-questionnaires` for verifying completeness across detect, resist, react, and recover dimensions.
- Builtin fallback rule: if one or more relevant skills are unavailable, draft using the learned builtin security checklist below.
- Completion rule: command completion must not depend on skill loading; builtin-skill behavior is mandatory fallback.

### Builtin Skill Checklist (when skills are unavailable)

- Protection property check: verify real SUT security protection (allowed/denied contrast, safe denial, redaction).
- Constitutional rule mapping: map each security TC to a constitutional invariant ($K$-SEC-01..04).
- Anti-test-theater gate: ensure assertions verify real SUT defense without asserting mocks directly.
- Zero credential exposure: ensure test inputs, assertions, and expectations do not contain unredacted secrets or tokens.

## Output Contract

- A Security quality skeleton with `@[SUT]`, `@[Class]`, `@[Category]`, `@[ProtectedAsset]`, `@[ThreatOrPolicy]`, `@[ConstitutionalRule]`, `@[US]`, `@[AC]`, and `@[TC]`.
- US/AC/TC entries for authorization, token redaction, injection exclusion, sandboxing, and trust-boundary defenses.
- Traceability to functional or design scenarios that must preserve protection properties under attack or policy constraints.

## Conflict Guard

This command designs Security coverage only. It should not redefine Security category rules or implement tests.

ONE-MORE-THING: ask developer if something not sure
