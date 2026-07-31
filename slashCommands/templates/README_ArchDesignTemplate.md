# {{ProjectName}} Architecture Design

This is the SpecCoding template for project-root `README_ArchDesign.md`. Create or update it from `SPEC_takeArchDesign` when a story changes module-context architecture, consuming-system context, architecture views, module boundaries, dependencies, data flow, runtime placement, or key decisions.

## Context

- Story link: {{.catdd/spec/doingUS/YYYYMMDD-UserStory.md or todo/done link}}
- Related overview: [README.md](README.md)
- Related detail design: [README_DetailDesign.md](README_DetailDesign.md)

## Module Context

| Item | Description |
| --- | --- |
| Target module | {{Module name}} |
| Module mission | {{What this module owns and why it exists}} |
| Public surface | {{API/commands/events exposed by this module}} |
| Out-of-module responsibilities | {{What this module explicitly does not own}} |

## Consuming-System Context

| Consumer System | Interaction | Contract Boundary | Failure/Trust Boundary |
| --- | --- | --- | --- |
| {{System A}} | {{How it uses this module}} | {{API/protocol/version boundary}} | {{error propagation, retry, ownership}} |
| {{System B}} | {{How it uses this module}} | {{API/protocol/version boundary}} | {{error propagation, retry, ownership}} |

## Architecture Goals

- {{Goal 1}}
- {{Goal 2}}
- {{Constraint}}

## Stakeholders and Concerns

<!-- How: Identify who needs this architecture view and which concern each view answers.
  Cover at least users, developers, maintainers, operators, and support when relevant.
  (→ SKILL: design-architecture-viewpoints) -->

| Stakeholder | Primary Concern | Viewpoint Needed | Design Response |
| --- | --- | --- | --- |
| {{Users / clients}} | {{capability, workflow, reliability}} | {{Context / Functional / Operational}} | {{how the architecture addresses it}} |
| {{Developers}} | {{module ownership, integration, testability}} | {{Functional / Development}} | {{how the architecture addresses it}} |
| {{Operators}} | {{deployment, observability, recovery}} | {{Deployment / Operational}} | {{how the architecture addresses it}} |

## Architecturally Significant Requirements

<!-- How: Extract quality and structural drivers before choosing patterns or technologies.
  Use measurable response measures; do not keep vague goals such as "fast" or "robust".
  (→ SKILL: apply-architectural-tactics + define-architectural-drivers) -->

| ASR ID | Quality / Driver | Source | Scenario (Source, Stimulus, Environment, Response, Measure) | Priority |
| --- | --- | --- | --- | --- |
| ASR-{{n}} | {{Availability / Performance / Security / Modifiability / Testability / Usability / Constraint}} | {{story/design/source}} | {{source; stimulus; environment; response; response measure}} | {{H/M/L value, H/M/L difficulty}} |

## Tactics and Tradeoffs

| ASR | Selected Tactic / Pattern | Why This Tactic | Sensitivity Point | Tradeoff Point | Risk / Non-Risk |
| --- | --- | --- | --- | --- | --- |
| ASR-{{n}} | {{tactic or pattern}} | {{why it satisfies the measurable scenario}} | {{decision variable that strongly affects outcome}} | {{quality attributes affected in opposite directions}} | {{risk or non-risk statement}} |

## Px-SpecFlow Architecture-Oriented Coverage

Declare how this architecture design handles the architecture-oriented SPEC surfaces defined by Px-SpecFlow. Mark each concern as covered here, delegated to an existing document, deferred to a later SPEC doc, or not applicable.

| Surface | Handling | Follow-up Trigger |
| --- | --- | --- |
| `README_UsageDesign.md` | {{covered/delegated/deferred/not applicable}} | {{When to create or update}} |
| `README_ErrorDesign.md` | {{covered/delegated/deferred/not applicable}} | {{When to create or update}} |
| `README_ResourceDesign.md` | {{covered/delegated/deferred/not applicable}} | {{When to create or update}} |
| `README_PerfDesign.md` | {{covered/delegated/deferred/not applicable}} | {{When to create or update}} |
| `README_CompatDesign.md` | {{covered/delegated/deferred/not applicable}} | {{When to create or update}} |
| `README_DiagnosisDesign.md` | {{covered/delegated/deferred/not applicable}} | {{When to create or update}} |
| `README_VerifyDesign.md` | {{covered/delegated/deferred/not applicable}} | {{When to create or update}} |
| `README_StateDesign.md` or ArchDesign state chapter | {{covered/delegated/deferred/not applicable}} | {{When to create or update}} |

## Architecture Views

Use Mermaid-renderable C4-style views or an equivalent explicit view model. Keep views high-level; detailed class/interface design belongs in `README_DetailDesign.md`.

### C4 Level 1: System Context View

```mermaid
flowchart LR
  actor["{{Primary actor}}"] --> system["{{System}}"]
  system --> dependency["{{External system or dependency}}"]
```

### C4 Level 2: Container View

```mermaid
flowchart TB
  subgraph system["{{System}}"]
    container1["{{Container 1}}"] --> container2["{{Container 2}}"] --> container3["{{Container 3}}"]
  end
```

### C4 Level 3: Component View

```mermaid
flowchart LR
  subgraph container["{{Container}}"]
    component1["{{Component 1}}"] --> component2["{{Component 2}}"] --> component3["{{Component 3}}"]
  end
```

### Runtime Execution View

```mermaid
flowchart LR
  trigger["{{Trigger}}"] --> decision["{{Decision point}}"] --> runtimeStep["{{Runtime step}}"] --> output["{{State/trace output}}"]
```

### Deployment View

```mermaid
flowchart TB
  system["{{System}}"] --> mode["{{Deployment Mode}}"]
  mode --> boundary["{{Runtime Boundary}}"]
  boundary --> adapter["{{Primary Adapter}}"]
  adapter --> notes["{{Constraint/trade-off}}"]
```

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

## Inter-View Consistency Checks

<!-- How: Check that architecture views agree before detail design starts.
  Every external system should map to an interface; every logical component should map to a
  development module; every runtime process should map to deployment/operation evidence. -->

| Check | Result | Follow-up |
| --- | --- | --- |
| Context vs Functional | {{all external systems map to interfaces / gap}} | {{follow-up if any}} |
| Functional vs Development | {{components map to modules/packages / gap}} | {{follow-up if any}} |
| Functional vs Concurrency | {{runtime execution maps to process/thread/task model / gap}} | {{follow-up if any}} |
| Concurrency vs Deployment | {{processes/tasks map to deployment nodes or runtime modes / gap}} | {{follow-up if any}} |
| Deployment vs Operational | {{deployment has monitoring, diagnosis, install, and recovery hooks / gap}} | {{follow-up if any}} |

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

| Decision | Selected Option | Rationale | Alternatives Considered | Implications | Status |
| --- | --- | --- | --- | --- | --- |
| {{Decision}} | {{Option}} | {{Why}} | {{Alternative}} | {{effect on modules, tests, operations, or compatibility}} | {{Proposed/Accepted/Superseded}} |

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
- Stakeholders and concerns map to the selected viewpoints.
- At least three ASRs use measurable quality-attribute scenario format when architecture quality is in scope.
- Selected tactics trace to ASRs and expose sensitivity/tradeoff points.
- Mermaid-renderable C4-style context, container, component, runtime, and deployment views are present or explicitly marked not applicable.
- Px-SpecFlow architecture-oriented surfaces are covered, delegated, deferred, or marked not applicable.
- Inter-view consistency checks are explicit before detail design starts.
- Module boundaries are explicit enough for implementation and review.
- Dependency direction and risks are visible.
