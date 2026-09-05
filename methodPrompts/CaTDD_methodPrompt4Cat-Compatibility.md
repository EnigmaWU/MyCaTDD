# CaTDD method prompt for Category: Compatibility

Use this prompt when designing P2 Quality tests for cross-platform, version, protocol, dependency, or integration compatibility.

## Position

Compatibility belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security
```

Compatibility proves that the same contract works across supported environments or versions.

## Use When

- The feature must work across operating systems, compilers, runtimes, dependency versions, or API versions.
- Backward or forward compatibility is part of the product contract.
- Integration with another module or product version must remain stable.

## Do Not Use When

- The scenario is simply a configurable setting in one environment; use Configuration.
- The scenario is a fault from an unavailable dependency; use Fault.
- The scenario is performance variation across platforms; use Performance with platform metadata.

## TestPointsInMind

First apply the source inventory and applicable sweep in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md). Record candidates in `discovery_ledger`; apply the Discovery Gate before implementation. Domain examples are optional prompts, not requirements or coverage quotas; use source-defined limits and oracles.

When this category applies, consider test points such as:

- Matrix rows from the compatibility source: operating system, compiler, runtime, dependency version, protocol version, schema version, or API version.
- Contract behavior that must remain identical across the matrix and behavior that is allowed to vary with documented reason.
- Backward and forward compatibility: old client with new server, new client with old server, old data with new parser, or deprecated field handling.
- Boundary formats and integration seams: serialization, path handling, newline conventions, locale, encoding, time zone, or platform-specific permissions.
- Environment metadata captured in the test result so a failing row can be reproduced and triaged.
- Domain-specific questions:
  - *Embedded Linux*: Which board, endianness, word-size, ABI, kernel/libc, and toolchain combinations are actually supported? What behavior must agree and what target-specific differences are allowed?
  - *Microservices*: Which old/new client, server, message, or persisted-schema combinations belong to the compatibility matrix, and what transformations preserve the promised contract?
  - *LLM Agents*: Which model/provider/SDK and tool-schema versions are supported? Verify defined behavioral equivalence without assuming identical generated text or universal multi-model support.

## Design Skeleton

```text
// @[Class]: P2 Quality
// @[Category]: Compatibility
// @[Intent]: Prove contract stability across supported environments or versions.
// @[UseWhen]: OS, compiler, runtime, dependency, protocol, or version variation matters.
// @[AvoidWhen]: The scenario is only configuration or only failure handling.
// @[Matrix]: [environment/version combinations]
// @[Contract]: [behavior that must stay consistent]
// @[TC]: verify[Contract]_by[CompatibilityMatrix]_expect[ConsistentBehavior]
```

## Checklist

- Is the compatibility matrix explicit?
- Which behavior must be identical, and which may vary?
- Are unsupported environments clearly out of scope?
- Does the test record enough environment metadata to debug failures?
