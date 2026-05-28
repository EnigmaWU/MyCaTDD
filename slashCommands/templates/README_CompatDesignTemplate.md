# {{ProjectName}} Compatibility Design

This is the SpecCoding template for project-root `README_CompatDesign.md`. Create or update it from `SPEC_takeDetailDesign` when a story changes supported versions, platforms, protocols, formats, toolchains, integrations, migration behavior, or backward/forward compatibility rules.

## Story Context

- Story: {{US identifier and title}}
- Source artifact: {{.catdd/spec/doingUS path or issue link}}
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)
- Related verification design: [README_VerifyDesign.md](README_VerifyDesign.md)

## Compatibility Matrix

| Boundary | Supported Set | Unsupported or Deprecated Set | Compatibility Rule | Owner |
| --- | --- | --- | --- | --- |
| {{Platform/version/protocol/format/toolchain/integration}} | {{Supported values}} | {{Unsupported values}} | {{Accept/reject/migrate/degrade}} | {{Owner}} |

## Version and Migration Rules

| From | To | Behavior | Data or API Impact | Rollback Rule |
| --- | --- | --- | --- | --- |
| {{Old version}} | {{New version}} | {{Compatible/migrated/rejected}} | {{Impact}} | {{Rollback or not supported}} |

## Protocol and Format Boundaries

- Protocol rule: {{Version negotiation, feature detection, or handshake behavior}}
- Format rule: {{File/container/schema/media format acceptance and rejection}}
- Toolchain rule: {{Compiler, SDK, runtime, ABI, dependency, or generated-code version}}
- Integration rule: {{External service, driver, device, or plugin compatibility}}

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
- Embedded software hardware/toolchain and digital video/audio codec/format compatibility are covered when relevant.