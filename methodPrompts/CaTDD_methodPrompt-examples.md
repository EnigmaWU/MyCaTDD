# CaTDD Method Prompt - Examples

This subtopic keeps illustrative material out of the main method prompt while preserving examples developers and agents can copy from.

## IOC Event System Coverage Dimensions

| Dimension | Values |
| --- | --- |
| Service Role | EvtProducer, EvtConsumer, Mixed |
| Client Role | EvtConsumer, EvtProducer, Mixed |
| Mode | Callback, Pull/Poll, Both |

Example scenario mapping:

| Service Role | Client Role | Mode | Scenario |
| --- | --- | --- | --- |
| EvtProducer | EvtConsumer | Callback | Async event flow |
| EvtProducer | EvtConsumer | Pull | Sync event flow |
| EvtConsumer | EvtProducer | Callback | Reversed flow |

## State Machine Coverage Dimensions

| Dimension | Values |
| --- | --- |
| State | Init, Ready, Running, Stopped, Error |
| Operation | Start, Stop, Pause, Resume, Reset |
| Edge | First call, last call, max transitions |

Example scenario mapping:

| State | Operation | Expected Category |
| --- | --- | --- |
| Init | Start | `funcValidTypical` or `designState` depending on source |
| Running | Pause | `designState` |
| Stopped | Resume | `funcInvalidMisuse` when caller requests invalid transition |
| Error | Reset | `funcInvalidFault` or `designState` depending on source |

## Concurrent Queue Coverage Dimensions

| Dimension | Values |
| --- | --- |
| Concurrency | Single-thread, multi-thread, high-contention |
| Resource | Empty, partial, full, overflow |
| Operation | Push, pop, peek, clear |

Example scenario mapping:

| Concurrency | Resource | Operation | Expected Category |
| --- | --- | --- | --- |
| Single-thread | Partial | Push | `funcValidTypical` |
| Single-thread | Full | Push | `funcValidEdge` when full is valid boundary behavior |
| Multi-thread | Partial | Push/Pop | `designConcurrency` |
| High-contention | Full | Push/Pop loop | `qualityRobust` or `qualityPerformance` when measuring envelope |

## CLI Coverage Dimensions

| Dimension | Values |
| --- | --- |
| Invocation | valid command, missing required arg, unknown option |
| Input Source | CLI arg, env var, config file, stdin |
| Output | stdout, stderr, exit code, output file |

Example scenario mapping:

| Scenario | Expected Category |
| --- | --- |
| Valid command writes expected output | `funcValidTypical` |
| Empty-but-valid input is accepted | `funcValidEdge` |
| Missing required argument is rejected | `funcInvalidMisuse` |
| Config file is unreadable while caller provided valid path | `funcInvalidFault` |
| Config precedence differs by environment | `qualityConfiguration` |
| Failure emits actionable stderr with a stable cause code | `qualityDiagnosis` |
| Secret value is not printed in stderr or logs | `qualitySecurity` |

## Microservice Coverage Dimensions

| Dimension | Values |
| --- | --- |
| Endpoint | GET, POST, event consumer, health |
| Caller State | authorized, unauthorized, wrong tenant |
| Dependency State | healthy, slow, unavailable |
| Contract Version | current, deprecated, unsupported |

Example scenario mapping:

| Scenario | Expected Category |
| --- | --- |
| Authorized current-version request succeeds | `funcValidTypical` |
| Deprecated but supported request succeeds with warning | `qualityCompatibility` |
| Unauthorized request is rejected | `funcInvalidMisuse` |
| Dependency timeout returns deterministic failure | `funcInvalidFault` |
| Readiness endpoint reflects dependency state | `qualityRobust` or `qualityConfiguration` depending on source |
| Trace includes request ID and dependency timeout cause | `qualityDiagnosis` |
| Cross-tenant request is denied without data leakage | `qualitySecurity` |

## Category Placement Examples

| Test Point | Correct Category | Why |
| --- | --- | --- |
| Invalid CLI flag is rejected | `funcInvalidMisuse` | Caller violated the contract |
| Missing dependency file is reported | `funcInvalidFault` | Caller may be valid; resource/world failed |
| Closed cannot transition to Running | `designState` | Protects state model |
| Adapter translates payload before dispatch | `designInteraction` | Protects collaborator sequence and handoff design |
| Two writers do not corrupt shared cache | `designConcurrency` | Protects ownership/synchronization model |
| Same operation under sustained load meets budget | `qualityPerformance` | Proves operating envelope |
| Failure report includes correlation ID and remediation | `qualityDiagnosis` | Proves actionable evidence |
| Unauthorized actor cannot read protected data | `qualitySecurity` | Proves protection property |
| README command remains executable | `addonDemoExample` | Proves learning surface |
