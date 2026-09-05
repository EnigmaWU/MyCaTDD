# CaTDD method prompt for Category: Configuration

Use this prompt when designing P2 Quality tests for settings, feature flags, modes, environment variables, build profiles, and deployment configuration.

## Position

Configuration belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration -> Diagnosis -> Security
```

Configuration proves that supported settings produce the intended behavior.

## Use When

- Behavior changes by configuration file, environment variable, feature flag, build profile, or deployment option.
- The same feature must be verified under multiple supported settings.
- Misconfiguration should be detected or handled clearly.

## Do Not Use When

- The scenario is a runtime input edge value; use Edge.
- The scenario is an unsupported caller action; use Misuse.
- The scenario is cross-platform behavior rather than settings; use Compatibility.

## TestPointsInMind

First apply the source inventory and applicable sweep in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md). Record candidates in `discovery_ledger`; apply the Discovery Gate before implementation. Domain examples are optional prompts, not requirements or coverage quotas; use source-defined limits and oracles.

When this category applies, consider test points such as:

- Default configuration behavior when no explicit setting is provided.
- Precedence across setting sources: CLI argument, environment variable, config file, profile, feature flag, build option, or deployment override.
- Supported setting combinations that select different modes, limits, integrations, paths, or policy behavior.
- Invalid or conflicting configuration that should fail clearly before unsafe behavior starts.
- Cleanup of global process state, environment variables, temp config files, and feature flags after each test.
- Domain-specific questions:
  - *Embedded Linux*: Which user-space, build, boot, or device settings are part of this SUT? Use actual precedence and supported combinations; DeviceTree or Kconfig is not required for every daemon/library.
  - *Microservices*: Which supplied flag, environment, file, or deployment sources win, and when are changes applied? Do not assume a hierarchy or hot-reload support.
  - *LLM Agents*: Which provider settings, prompt/tool policies, or endpoint options are supported, with what defaults and invalid-setting behavior? Not every model exposes the same parameters.

## Design Skeleton

```text
// @[Class]: P2 Quality
// @[Category]: Configuration
// @[Intent]: Prove supported settings map to expected behavior.
// @[UseWhen]: Config files, environment variables, flags, or modes affect behavior.
// @[AvoidWhen]: The scenario is input validation, platform compatibility, or caller misuse.
// @[ConfigMatrix]: [setting combinations]
// @[ExpectedMode]: [behavior for each setting]
// @[TC]: verify[Behavior]_by[ConfigSetting]_expect[ConfiguredResult]
```

## Checklist

- Is each setting source explicit?
- Are default values tested?
- Is invalid configuration handled or documented?
- Does cleanup restore global or environment state?
