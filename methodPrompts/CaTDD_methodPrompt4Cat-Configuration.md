# CaTDD method prompt for Category: Configuration

Use this prompt when designing P2 Quality tests for settings, feature flags, modes, environment variables, build profiles, and deployment configuration.

## Position

Configuration belongs to P2 Quality-oriented testing.

```text
P2 Quality = Performance -> Robust -> Compatibility -> Configuration
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
