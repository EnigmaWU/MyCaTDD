# {{ProjectName}} Security Design

This is the SpecCoding template for project-root `README_SecurityDesign.md`. Create or update it from `SPEC_takeArchDesign` or `SPEC_takeDetailDesign` when a story changes threat models, trust boundaries, credentials, permissions, tenant isolation, sandboxing, constitutional security invariants ($K$), or data protection policies.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related architecture design: [README_ArchDesign.md](README_ArchDesign.md)
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## Threat Model & Trust Boundaries

<!-- How: Catalog sensitive assets and apply STRIDE threat modeling across boundaries.
     (→ SKILL: design-architecture-viewpoints) -->

| Trust Boundary | Protected Asset | Threat Actor | STRIDE Threat | Potential Impact | Security Objective |
| --- | --- | --- | --- | --- | --- |
| {{Public API / Network}} | {{User credentials, PII}} | {{External attacker}} | {{Spoofing / Info Disclosure}} | {{Unauthorized access}} | {{Mutual TLS, OAuth2/JWT verification}} |
| {{Tenant boundary}} | {{Tenant private database}} | {{Compromised client}} | {{Elevation of Privilege}} | {{Cross-tenant leakage}} | {{Strict tenant-context partition}} |
| {{Tool execution sandbox}} | {{Host filesystem / shell}} | {{Prompt injection}} | {{Tampering / DoS}} | {{Arbitrary code execution}} | {{Read-only sandbox, HITL approval}} |

## Constitutional Invariants (K)

Non-negotiable security, compliance, and safety rules ($K$) that must be preserved by construction in all generated code and verified deterministically:

| Rule ID | Invariant Obligation | CWE / Standard | Observable Oracle | Enforcement Mechanism |
| --- | --- | --- | --- | --- |
| `K-SEC-01` | Proactive injection exclusion: raw string concatenation into queries/commands forbidden | CWE-89, CWE-78 | Parameterized queries, type-safe API builders | Static lint AST check & injection payload tests |
| `K-SEC-02` | Credential isolation: tokens, ApiKEYs, passphrases never output in cleartext | CWE-200, CWE-312 | Output masked as `***`, redaction verified | Regex mask filter, stderr/log assertion |
| `K-SEC-03` | Least privilege & mutative action approval: destructive operations require human confirmation | CWE-285, CWE-862 | Unauthorized request rejected with 403 / confirmation gate | HITL approval gate, container isolation |
| `K-SEC-04` | Deterministic security oracles: security test points must assert observable protection outcomes | CWE-693 | Access denied, exception raised, status 401/403 | Concrete assertion (no mock-asserting-mock) |

## Security Quality Attribute Scenarios

<!-- How: Express security policies as 6-part measurable scenarios.
     (→ SKILL: apply-architectural-tactics) -->

| Scenario | Source | Stimulus | Environment | Response | Response Measure | Priority |
| --- | --- | --- | --- | --- | --- | --- |
| {{Auth failure}} | {{Untrusted client}} | {{Forged or expired JWT}} | {{Public edge API}} | {{Reject request, log security event}} | {{HTTP 401 within 10ms, zero PII logged}} | {{H}} |
| {{Tenant isolation}} | {{Tenant A client}} | {{Request Tenant B resource ID}} | {{Multi-tenant runtime}} | {{Enforce tenant partition filter}} | {{HTTP 403 / 404, no data leaked}} | {{H}} |
| {{Injection attempt}} | {{Malicious payload}} | {{SQL/Command meta-characters}} | {{Input parser}} | {{Sanitize and reject input}} | {{Parser error, no shell execution}} | {{H}} |

## Agentic Tool Sandboxing & Execution Invariants

<!-- How: Enforce read-only vs mutative execution boundaries for AI agents.
     (→ SKILL: design-tool-use-sandboxing) -->

| Tool / Capability | Tool Classification | Execution Mode | Security Guardrail | Rejection / Approval Action |
| --- | --- | --- | --- | --- |
| `read_file`, `list_dir`, `grep_search` | Safe (Read-Only) | Autonomous permitted | Path boundary check (jail within workspace) | Reject paths outside workspace |
| `write_file`, `replace_string` | Mutative (State change) | Sandbox / Human approval | Backup before edit, schema validation | Human prompt on high-impact files |
| `run_in_terminal` | Dangerous (Code exec) | Approval / Containerized | Block sudo/rm -rf, 30s timeout | Human-in-the-loop explicit confirmation |

## Embedded and Digital Media Security Points

Embedded software points:

- Hardware and memory protection: {{MPU/MMU configuration, stack canary (-fstack-protector), W^X memory}}
- Firmware integrity and secure boot: {{cryptographic signature verification, secure key storage in TPM/eFuse, rollback protection}}
- Privilege separation: {{privilege drop after initialization, isolated user-space daemon, restricted peripheral access}}
- Interface hardening: {{JTAG/debug port disable in production, watchdog timeout on authentication stall, bus tamper detection}}

digital video/audio points:

- Content protection: {{HDCP encryption, DRM license exchange, secure media pipeline memory}}
- Stream authentication: {{stream signature, tamper-proof RTP/SRTP headers, watermark embedding}}
- Key exchange: {{ephemeral session keys, secure key derivation, revocation protocol}}

## CaTDD Verification Handoff

| Feature Token | Category Token | Suggested Test File | Security Concern | Notes |
| --- | --- | --- | --- | --- |
| `{{feature_token}}` | `qualitySecurity` | `test_{{feature_token}}_qualitySecurity.{{ext}}` | {{enforcement of constitutional rules K-SEC-* under threat scenario}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `funcInvalidMisuse` | `test_{{feature_token}}_funcInvalidMisuse.{{ext}}` | {{caller passes malformed credentials or missing auth headers}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `qualityDiagnosis` | `test_{{feature_token}}_qualityDiagnosis.{{ext}}` | {{verify auth failure logs carry correlation ID without leaking secrets}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |

## Usage Example

Run from the repository root to instantiate this security-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_SecurityDesign.md"
cp slashCommands/templates/README_SecurityDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows threat model, constitutional invariants ($K$), security scenarios, agentic sandboxing, and embedded/media security sections.

## Review Checklist

<!-- How: Apply the architectural tactics questionnaire to evaluate security completeness.
     (→ SKILL: analyze-with-tactics-questionnaires) -->

- Threat model identifies protected assets, trust boundaries, threat actors, and STRIDE categories.
- Constitutional invariants ($K$) are explicit, non-negotiable, and verifiable.
- Security scenarios define measurable response measures (safe denial, HTTP status, time ceiling).
- Secrets, tokens, and private data are protected by redaction and isolation rules.
- Agentic tools are partitioned into safe (read-only) and dangerous (mutative/exec) with approval gates.
- Embedded firmware integrity, memory protection, and digital media content protection points are addressed when relevant.
- CaTDD handoff maps security concerns to `test_{{feature_token}}_qualitySecurity.{{ext}}` with observable protection oracles.
