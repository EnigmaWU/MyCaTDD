# {{ProjectName}} MicroService Usage Design

This is the SpecCoding template for project-root `README_UsageDesign.md` when a story defines or changes a networked or deployed microservice: HTTP/gRPC endpoints, event topics, request/response schemas, service dependencies, runtime configuration, health checks, observability, compatibility, or service-to-service behavior.

Use this template from `SPEC_takeDetailDesign` before implementing tests or product code. Keep it traceable to the active story and synchronized with `README_UserGuide.md`, `README_ArchDesign.md`, `README_DetailDesign.md`, `README_ErrorDesign.md`, `README_CompatDesign.md`, `README_DiagnosisDesign.md`, and CaTDD verification artifacts.

## Who

- Primary consumer: {{frontend/service/client/team/persona}}
- Secondary consumer: {{operator/SRE/support engineer/integration partner}}
- Service owner: {{owning team or module}}
- Assistant consumer: CodeAgent or contract-test generator that must understand API behavior

## What

`{{service-name}}` is a microservice that {{one-sentence capability}}.

The service is optimized for:

- Stable API or event contracts.
- Predictable runtime behavior under deployment constraints.
- Observable failures and recoverable client behavior.
- Compatibility across service versions and clients.

## When

Use this service when:

- {{usage condition 1}}
- {{usage condition 2}}
- {{usage condition 3}}

Do not use this service when:

- {{non-goal or unsupported condition 1}}
- {{non-goal or unsupported condition 2}}

## Where

- Runtime boundary: {{service / namespace / deployment / host}}
- API base URL or service name: `{{base-url-or-service-name}}`
- Protocols: {{HTTP REST / gRPC / event bus / WebSocket / other}}
- Reads from: {{request body / headers / query params / topics / storage / dependencies}}
- Writes to: {{response / events / database / cache / object store / logs}}
- Related overview: [README.md](README.md)
- Related user guide: [README_UserGuide.md](README_UserGuide.md)
- Related architecture design: [README_ArchDesign.md](README_ArchDesign.md)
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related error design: [README_ErrorDesign.md](README_ErrorDesign.md)
- Related compatibility design: [README_CompatDesign.md](README_CompatDesign.md)
- Related diagnosis design: [README_DiagnosisDesign.md](README_DiagnosisDesign.md)
- Source story: {{.catdd/spec/doingUS path or issue link}}

## Why

- Outcome: {{business or platform outcome this service enables}}
- Risk reduced: {{integration drift, unclear API semantics, weak observability, deployment surprise, etc.}}
- Success signal: {{observable proof that the outcome was achieved}}

## Usage Outcome Model

Use this OOPSI-style section to work backward from service outcome to exact client inputs.

| Layer | Design answer |
| --- | --- |
| Outcome | {{What valuable result the caller or system gets}} |
| Outputs | {{Response, events, persisted state, metrics, traces, logs}} |
| Process | {{Service workflow from request/event to output}} |
| Scenarios | {{Happy path, edge cases, dependency failures, retries, compatibility variants}} |
| Inputs | {{Path params, query params, headers, body, auth, event payload, config}} |

## Service Interface

| Interface | Contract |
| --- | --- |
| Protocol | {{HTTP/gRPC/event bus/etc.}} |
| Endpoint/topic/method | `{{METHOD /path}}` or `{{topic.name}}` |
| Request schema | {{schema name or inline contract}} |
| Response/event schema | {{schema name or inline contract}} |
| AuthN/AuthZ | {{token type, scope, role, tenant rule}} |
| Idempotency | {{idempotency key / natural idempotency / not idempotent}} |
| Timeout budget | {{client timeout / server timeout / deadline propagation}} |
| Retry policy | {{safe retry conditions and backoff}} |
| Rate limit/backpressure | {{limits, headers, queue behavior, rejection code}} |
| Versioning | {{URI/header/schema/event versioning rule}} |

## API Contract

### Request

```json
{
  "{{field}}": "{{value}}"
}
```

| Field | Location | Type/format | Required | Default | Validation | Description |
| --- | --- | --- | --- | --- | --- | --- |
| `{{field}}` | body | string | yes | none | {{allowed values or pattern}} | {{meaning}} |
| `{{header}}` | header | string | yes | none | {{required scope or format}} | {{meaning}} |
| `{{query}}` | query | integer | no | `{{default}}` | {{range}} | {{meaning}} |

### Response

```json
{
  "status": "{{success|failure}}",
  "{{field}}": "{{value}}"
}
```

| Field | Type/format | Required | Description |
| --- | --- | --- | --- |
| `status` | enum | yes | {{success/failure semantics}} |
| `{{field}}` | string | {{yes/no}} | {{meaning}} |

## Runtime Contract

| Surface | Contract |
| --- | --- |
| Deployment unit | {{container/function/process/service}} |
| Configuration | {{env vars, config maps, secrets, feature flags}} |
| Startup behavior | {{required dependencies, migrations, warmup}} |
| Shutdown behavior | {{drain, flush, timeout, in-flight handling}} |
| Persistence | {{database/cache/object store/none}} |
| Upstream dependencies | {{services this service calls}} |
| Downstream consumers | {{clients, services, event consumers}} |
| Resource assumptions | {{CPU, memory, connection pool, queue depth}} |
| Data ownership | {{owned data, borrowed data, cache-only data}} |

## Behavior Scenarios

| Scenario ID | Given | When | Then | Response/event | Status/code | Side effects | Trace |
| --- | --- | --- | --- | --- | --- | --- | --- |
| USAGE-SC-001 | {{valid request and dependencies healthy}} | {{client calls endpoint or publishes event}} | {{expected behavior}} | {{body/event}} | `{{200/OK/etc.}}` | {{state changes}} | {{US/AC/TC}} |
| USAGE-SC-002 | {{valid request repeated with idempotency key}} | {{client retries}} | {{same result or safe no-op}} | {{body/event}} | `{{status}}` | {{state changes}} | {{US/AC/TC}} |
| USAGE-SC-003 | {{invalid request}} | {{client calls service}} | {{validation failure}} | {{error body}} | `{{400/INVALID_ARGUMENT}}` | none | {{US/AC/TC}} |
| USAGE-SC-004 | {{dependency timeout}} | {{service processes request}} | {{fallback, retry, or error behavior}} | {{error body/event}} | `{{status}}` | {{state changes}} | {{US/AC/TC}} |

## Error Model

| Error | Trigger | Client-visible response | Retryable | Observability signal |
| --- | --- | --- | --- | --- |
| Validation error | {{bad field or missing field}} | {{status/code/body}} | no | {{log/metric/trace}} |
| Unauthorized | {{missing or invalid auth}} | {{status/code/body}} | maybe | {{log/metric/trace}} |
| Conflict | {{duplicate or incompatible state}} | {{status/code/body}} | maybe | {{log/metric/trace}} |
| Dependency failure | {{upstream unavailable}} | {{status/code/body}} | yes | {{log/metric/trace}} |
| Internal failure | {{unexpected exception}} | {{status/code/body}} | maybe | {{log/metric/trace}} |

## Health and Operations

| Operation surface | Contract |
| --- | --- |
| Liveness | `{{GET /health/live}}` returns {{contract}} |
| Readiness | `{{GET /health/ready}}` returns {{contract and dependency checks}} |
| Startup probe | {{contract}} |
| Metrics | {{metric names, labels, SLO indicators}} |
| Logs | {{structured fields, levels, correlation IDs}} |
| Traces | {{trace propagation, span names, attributes}} |
| Dashboards/runbooks | {{links or required docs}} |

## Compatibility and Versioning

- Current API version: {{version}}
- Backward-compatible changes: {{allowed changes}}
- Breaking changes: {{disallowed without version bump}}
- Deprecation policy: {{notice period and signal}}
- Client compatibility matrix: {{supported client versions or SDKs}}

## Local and Contract-Test Examples

```bash
# Local happy-path request
curl -sS -X {{METHOD}} "{{base-url}}/{{path}}" \
  -H 'Authorization: Bearer {{token}}' \
  -H 'Content-Type: application/json' \
  -d '{"{{field}}":"{{value}}"}'

# Health check
curl -fsS "{{base-url}}/health/ready"

# Capture response for contract test inspection
curl -sS -o "$TMPDIR/{{response-file}}.json" -w '%{http_code}\n' "{{base-url}}/{{path}}"
```

## CaTDD Verification Handoff

| Usage scenario | Feature token | Category token | Suggested test file | Test points |
| --- | --- | --- | --- | --- |
| {{happy path API scenario}} | `{{feature_token}}` | `funcValidTypical` | `test_{{feature_token}}_funcValidTypical.{{ext}}` | {{TC list}} |
| {{valid boundary or compatibility scenario}} | `{{feature_token}}` | `funcValidEdge` | `test_{{feature_token}}_funcValidEdge.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{invalid caller request}} | `{{feature_token}}` | `funcInvalidMisuse` | `test_{{feature_token}}_funcInvalidMisuse.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{dependency failure}} | `{{feature_token}}` | `funcInvalidFault` | `test_{{feature_token}}_funcInvalidFault.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{concurrency or race scenario}} | `{{feature_token}}` | `designConcurrency` | `test_{{feature_token}}_designConcurrency.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{latency or throughput scenario}} | `{{feature_token}}` | `qualityPerformance` | `test_{{feature_token}}_qualityPerformance.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |
| {{compatibility scenario}} | `{{feature_token}}` | `qualityCompatibility` | `test_{{feature_token}}_qualityCompatibility.{{ext}}` | {{TC list or `@[NoTestPoints]: <reason>`}} |

## Open Questions

- {{Question about auth, schema, compatibility, dependency failure, observability, or test trace}}

## Usage Example

Run from the repository root to instantiate this microservice usage-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp slashCommands/templates/README_UsageDesignMicroServiceTemplate.md "$TMP_DOC"
sed -n '1,200p' "$TMP_DOC"
```

Expected result: the temporary file shows 5W1H context, usage outcome model, service interface, API contract, runtime contract, behavior scenarios, error model, operations, compatibility, and CaTDD verification handoff sections.

## Review Checklist

- 5W1H context is complete enough for service consumers, operators, and CodeAgents.
- Outcome, outputs, process, scenarios, and inputs are traceable to the active story.
- Endpoint/topic/method contracts include request and response schemas.
- AuthN/AuthZ, tenancy, idempotency, retries, timeouts, and rate limits are explicit.
- Runtime dependencies, configuration, startup, shutdown, and data ownership are explicit.
- Health, readiness, metrics, logs, and traces are testable.
- Error model defines client-visible response, retryability, and observability signal.
- Compatibility/versioning policy is clear before implementation begins.
- Usage scenarios map to CaTDD feature/category test files or explicit `@[NoTestPoints]: <reason>` decisions.
- Open questions are resolved or intentionally carried before `SPEC_reviewDetailDesign` passes.
