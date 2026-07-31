# CaTDD Method Prompt - File Naming

This subtopic defines the canonical CaTDD test file naming rule.

## Pattern

Use this pattern for category-specific test files:

```text
test_{feature}_{category}.<ext>
```

- `{feature}` is a stable lower_snake_case module-interface usage slice.
- `{category}` is one canonical CaTDD category token.
- `<ext>` follows the target language, such as `cxx`, `ts`, or `py`.

## Canonical Category Tokens

| CaTDD class/category | Filename token |
| --- | --- |
| P0 Functional / ValidFunc / Typical | `funcValidTypical` |
| P0 Functional / ValidFunc / Edge | `funcValidEdge` |
| P0 Functional / InvalidFunc / Misuse | `funcInvalidMisuse` |
| P0 Functional / InvalidFunc / Fault | `funcInvalidFault` |
| P1 Design / State | `designState` |
| P1 Design / Capability | `designCapability` |
| P1 Design / Interaction | `designInteraction` |
| P1 Design / Concurrency | `designConcurrency` |
| P2 Quality / Performance | `qualityPerformance` |
| P2 Quality / Robust | `qualityRobust` |
| P2 Quality / Compatibility | `qualityCompatibility` |
| P2 Quality / Configuration | `qualityConfiguration` |
| P2 Quality / Diagnosis | `qualityDiagnosis` |
| P2 Quality / Security | `qualitySecurity` |
| P3 Addons / Demo/Example | `addonDemoExample` |

## Freely Drafts

Start exploration in a draft file when category placement is not clear yet:

```text
test_{feature}_freelyDrafts.<ext>
```

Move mature test points into category-specific files after classification.

## No-Test-Points Rule

Each feature should create or preserve one file for every canonical category token. If a category has no applicable test points, keep that file as a living decision with:

```text
@[NoTestPoints]: <reason>
```

Do not silently omit categories.

## Examples

```text
test_command_execution_funcValidTypical.cxx
test_command_execution_funcValidEdge.cxx
test_command_execution_funcInvalidMisuse.cxx
test_command_execution_funcInvalidFault.cxx
test_command_execution_designState.cxx
test_command_execution_designInteraction.cxx
test_command_execution_designConcurrency.cxx
test_command_execution_qualityPerformance.cxx
test_command_execution_qualityDiagnosis.cxx
test_command_execution_qualitySecurity.cxx
test_command_execution_qualityConfiguration.ts
```

The same token rule applies across languages.
