# CaTDD method prompt for Category: Compatibility

Use this prompt when designing P2 Quality tests for cross-platform, version, protocol, dependency, or integration compatibility.

## Position

Compatibility belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration
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
