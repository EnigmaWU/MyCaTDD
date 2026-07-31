# {{ProjectName}} Compatibility Design

This is the SpecCoding template for project-root `README_CompatDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story changes supported versions, platforms, protocols, formats, toolchains, integrations, migration behavior, or backward/forward compatibility rules.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## Compatibility Matrix

| Boundary | Supported Set | Unsupported or Deprecated Set | Compatibility Rule | Detection Method | Owner |
| --- | --- | --- | --- | --- | --- |
| {{Platform/version/protocol/format/toolchain/integration}} | {{Supported values}} | {{Unsupported values}} | {{Accept/reject/migrate/degrade}} | {{probe/metadata/version/handshake}} | {{Owner}} |

## Compatibility Decision Rules

<!-- How: Decide behavior at every boundary before implementation.
	Compatibility should be observable as accept, reject, migrate, fallback, or degrade. -->

| If Caller / Artifact Is | And Environment Is | Then Behavior Is | User/System Signal | CaTDD Category |
| --- | --- | --- | --- | --- |
| {{supported version/format/platform}} | {{supported environment}} | {{accept}} | {{success signal}} | `qualityCompatibility` |
| {{deprecated but supported}} | {{supported environment}} | {{accept with warning / migrate}} | {{warning/result}} | `qualityCompatibility` |
| {{unsupported}} | {{any environment}} | {{reject / fallback / degrade}} | {{diagnostic/result}} | `funcInvalidMisuse` |

## Version and Migration Rules

| From | To | Behavior | Data or API Impact | Rollback Rule |
| --- | --- | --- | --- | --- |
| {{Old version}} | {{New version}} | {{Compatible/migrated/rejected}} | {{Impact}} | {{Rollback or not supported}} |

## Protocol and Format Boundaries

| Boundary | Negotiation / Detection | Accepted Behavior | Rejected Behavior | Migration / Fallback |
| --- | --- | --- | --- | --- |
| Protocol | {{Version negotiation, feature detection, or handshake behavior}} | {{accepted path}} | {{rejection diagnostic}} | {{fallback}} |
| Format | {{File/container/schema/media format detection}} | {{accepted path}} | {{rejection diagnostic}} | {{migration/fallback}} |
| Toolchain | {{Compiler, SDK, runtime, ABI, dependency, generated-code version}} | {{accepted path}} | {{rejection diagnostic}} | {{migration/fallback}} |
| Integration | {{External service, driver, device, plugin}} | {{accepted path}} | {{rejection diagnostic}} | {{migration/fallback}} |

## Compatibility Risk Register

| Risk | Boundary | Impact | Mitigation | Verification Evidence |
| --- | --- | --- | --- | --- |
| {{compatibility risk}} | {{boundary}} | {{breakage/user/system impact}} | {{pin/migrate/detect/fallback/deprecate}} | {{test/manual check/contract evidence}} |

## Embedded and Digital Media Compatibility Points

Embedded software points:

- Hardware revisions: {{board, MCU/SoC, peripheral, register-map, or silicon errata compatibility}}
- Firmware and bootloader: {{image version, upgrade path, rollback, secure boot, calibration data}}
- RTOS/toolchain/SDK: {{ABI, compiler flags, HAL/driver version, scheduler behavior}}
- External devices: {{sensor, codec, bus, timing, electrical, or driver compatibility}}

digital video/audio points:

- Codec compatibility: {{codec, profile, level, container, DRM, or decoder capability}}
- Media format compatibility: {{pixel format, color space, sample rate, bit depth, channel layout}}
- Pipeline compatibility: {{capture/render device, mux/demux, timestamp, subtitle, metadata behavior}}
- Interop fallback: {{transcode, resample, downscale, reject, or degrade policy}}

## Verification Matrix

| Scenario | Compatibility Boundary | Expected Behavior | Test Evidence |
| --- | --- | --- | --- |
| {{Scenario}} | {{Boundary}} | {{Pass/degrade/reject/migrate}} | {{Test/log/manual evidence}} |

## CaTDD Verification Handoff

| Feature Token | Category Token | Suggested Test File | Compatibility Concern | Notes |
| --- | --- | --- | --- | --- |
| `{{feature_token}}` | `qualityCompatibility` | `test_{{feature_token}}_qualityCompatibility.{{ext}}` | {{supported/deprecated/migration/interop behavior}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |
| `{{feature_token}}` | `funcInvalidMisuse` | `test_{{feature_token}}_funcInvalidMisuse.{{ext}}` | {{unsupported caller/artifact rejected}} | {{TC seeds or `@[NoTestPoints]: <reason>`}} |

## Usage Example

Run from the repository root to instantiate this compatibility-design template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_CompatDesign.md"
cp slashCommands/templates/README_CompatDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows compatibility matrix, migration rules, protocol and format boundaries, and domain-specific compatibility sections.

## Review Checklist

- Supported and unsupported versions, platforms, protocols, formats, toolchains, and integrations are explicit.
- Compatibility behavior is observable as accept, reject, migrate, fallback, or degrade.
- Detection and negotiation rules are explicit at each boundary.
- Compatibility risks have mitigation and verification evidence.
- CaTDD handoff maps compatibility and rejection behavior to category-specific test files.
- Embedded software hardware/toolchain and digital video/audio codec/format compatibility are covered when relevant.
