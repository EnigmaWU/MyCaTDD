# CaTDD Method Prompt - File Naming

This subtopic defines the canonical CaTDD test file naming rule. It is the single authority for category-specific test file names; when another CaTDD document shows a different pattern, this file wins and that document is corrected.

## Pattern

Use this pattern for category-specific test files:

```text
test_{feature}_{category}.<ext>
```

- `{feature}` is a stable lower_snake_case module-interface usage slice.
- `{category}` is one canonical CaTDD category token, and it is always the last segment.
- `<ext>` follows the target language, such as `cxx`, `ts`, `py`, or `go`.

Test level is not encoded in the filename. Declare it inside the file with `@[TestLevel]: UnitTesting | SysTesting | UserTesting` (see `CaTDD_methodPrompt-testStructure.md`), so one naming rule covers all three levels.

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

## Superseded Names

Level-prefixed and hyphenated names are deprecated and must not be introduced in new documents, commands, or tests:

```text
UT_<Feature>-<Category>.<ext>          deprecated
<LEVEL>_<Feature>-<Category>.<ext>     deprecated
```

Map an older name to the canonical name by translating the level out of the filename and the category into its token:

| Deprecated name | Canonical name |
| --- | --- |
| `UT_PaymentRetry-Typical.ts` | `test_payment_retry_funcValidTypical.ts` |
| `UT_PaymentRetry-Fault.ts` | `test_payment_retry_funcInvalidFault.ts` |
| `UT_Gateway-Edge.ts` | `test_gateway_funcValidEdge.ts` |
| `UT_US-USER-01-Misuse.ts` | `test_us_user_01_funcInvalidMisuse.ts` |

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

The same token rule applies across languages and test levels. A `SysTesting` file and a `UserTesting` file for the same feature use the same `{feature}_{category}` tail and differ only by `@[TestLevel]`.

## Related

- `CaTDD_methodPrompt-testStructure.md` — comment skeleton, `@[TestLevel]`, and the four-phase body.
- `CaTDD_methodPrompt-categorySemantics.md` — which category owns a test point.
