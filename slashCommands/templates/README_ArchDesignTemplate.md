# {{ProjectName}} Architecture Design

This is the SpecCoding template for project-root `README_ArchDesign.md`. Create or update it from `SPEC_takeArchDesign` when a story changes architecture views, module boundaries, dependencies, data flow, runtime placement, or key decisions.

## Context

- Story link: {{.catdd/spec/doingUS/YYYYMMDD-UserStory.md or todo/done link}}
- Related overview: [README.md](README.md)
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)

## Architecture Goals

- {{Goal 1}}
- {{Goal 2}}
- {{Constraint}}

## Architecture Views

Use C4-style views or an equivalent explicit view model. Keep views high-level; detailed class/interface design belongs in `README_DetailDesign.md`.

### C4 Level 1: System Context View

```text
{{Primary actor}} -> {{System}} -> {{External system or dependency}}
```

### C4 Level 2: Container View

```text
{{System}}
  {{Container 1}} -> {{Container 2}} -> {{Container 3}}
```

### C4 Level 3: Component View

```text
{{Container}}
  {{Component 1}} -> {{Component 2}} -> {{Component 3}}
```

### Runtime Execution View

```text
{{Trigger}} -> {{Decision point}} -> {{Runtime step}} -> {{State/trace output}}
```

### Deployment View

| Deployment Mode | Runtime Boundary | Primary Adapter | Notes |
| --- | --- | --- | --- |
| {{Mode}} | {{Boundary}} | {{Adapter}} | {{Constraint/trade-off}} |

## Module Boundaries

| Module | Responsibility | Public Surface | Owned Data |
| --- | --- | --- | --- |
| {{Module}} | {{Responsibility}} | {{API/command/file}} | {{Data/state}} |

## Dependencies

| Dependency | Direction | Reason | Risk |
| --- | --- | --- | --- |
| {{Dependency}} | {{A -> B}} | {{Why needed}} | {{Risk or mitigation}} |

## Data Flow

```text
{{Input}} -> {{Component}} -> {{Output}}
```

## Embedded and Digital Media Architecture Points

Embedded software points:

- Hardware boundary: {{MCU/SoC/peripheral/driver boundary}}
- RTOS/task boundary: {{task/thread/ISR/timer ownership}}
- DMA/cache/bus path: {{DMA buffer, cache coherency, bus bandwidth risk}}
- Power/clock domain: {{sleep, wake, clock, reset, watchdog constraints}}

digital video/audio points:

- Media pipeline: {{capture/demux/decode/process/encode/render path}}
- Buffer topology: {{ring buffer, frame queue, audio queue, ownership handoff}}
- Format boundary: {{codec, sample format, pixel format, color space, container}}
- Sync boundary: {{PTS/DTS, clock source, A/V sync, jitter tolerance}}

## Key Decisions

| Decision | Rationale | Alternatives Considered | Status |
| --- | --- | --- | --- |
| {{Decision}} | {{Why}} | {{Alternative}} | {{Proposed/Accepted/Superseded}} |

## Risks and Constraints

- {{Risk or constraint}}
- {{Mitigation or follow-up}}

## Usage Example

Run from the repository root to instantiate this architecture template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_ArchDesign.md"
cp slashCommands/templates/README_ArchDesignTemplate.md "$TMP_DOC"
sed -n '1,100p' "$TMP_DOC"
```

Expected result: the temporary file shows architecture sections for views, boundaries, dependencies, data flow, and decisions.

## Review Checklist

- Architecture decisions are traceable to a user story or project constraint.
- C4-style context, container, component, runtime, and deployment views are present or explicitly marked not applicable.
- Module boundaries are explicit enough for implementation and review.
- Dependency direction and risks are visible.
