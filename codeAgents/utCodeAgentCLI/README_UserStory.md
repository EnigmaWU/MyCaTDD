# utCodeAgentCLI Requirements

utCodeAgentCLI is the CaTDD-native CLI that turns a natural language goal, source code, and a User Story into traceable test artifacts. Its core promise: **design → review → implement CaTDD test cases, with full traceability from story to skeleton to executable code, without ever redefining CaTDD method semantics.**

This is the master requirements index. Role-specific stories are in companion files:

| Role | File | Contains |
| --- | --- | --- |
| **USER** | [README_UserStory4USER.md](README_UserStory4USER.md) | 10 requirements — guided discovery (NEW-USER) and surgical control (EXPERIENCED-USER) |
| **INVENTOR** | [README_UserStory4INVENTOR.md](README_UserStory4INVENTOR.md) | 3 requirements — method delegation, traceability, and diagnostic proof |
| **DEVELOPER** | [README_UserStory4DEVELOPER.md](README_UserStory4DEVELOPER.md) | 4 requirements — error messages, logging, interactive mode, adapter interface |

> **Implementation status**: `utCodeAgentCLI` does not yet have a runnable binary. The [UsageDesign](README_UsageDesign.md) specifies the CLI interface contract. The [UserGuide](README_UserGuide.md) documents invocation-plan patterns.

---

## USER Journeys

```
NEW-USER (guided discovery):
  validate → designAllSkeleton → review all tiers → pick next → designAndImplTest
  US-USER-01    US-USER-02         US-USER-03        US-USER-04    US-USER-08

EXPERIENCED-USER (surgical control):
  validate → single-category design → tier review → impl one TC → review impl
  US-USER-01       US-USER-02        US-USER-03   US-USER-05   US-USER-09
  → pick next → impl all → review all impl / batch multi-file
    US-USER-04   US-USER-06   US-USER-10       US-USER-07
```

All paths produce a machine-readable trace (US-INVENTOR-02) and validate CaTDD method delegation (US-INVENTOR-01).

---

## Test File State Model

```
@[Status:PLANNED]  ──(implTestCase)──►  @[Status:RED]  ──(user fixes prod code)──►  @[Status:GREEN]
```

The CLI owns `PLANNED → RED`. `RED → GREEN` is user-owned — CLI reads GREEN but never writes it.

| File State | Description |
| --- | --- |
| **EMPTY** | No CaTDD skeleton TCs |
| **DESIGNED** | All TCs `@[Status:PLANNED]` |
| **PARTIAL** | Mix of PLANNED, RED, GREEN |
| **FULLY_RED** | All TCs RED or GREEN, no PLANNED |
| **ALL_GREEN** | All TCs GREEN |

### Behavior State Contract

| `--behave` | Requires file state | Produces TC state | Produces file state |
| --- | --- | --- | --- |
| `design*Skeleton` | Any | New TCs → PLANNED | DESIGNED or PARTIAL |
| `reviewFuncTestsSkeleton` | DESIGNED, PARTIAL, FULLY_RED | No change | No change |
| `reviewDesignTestsSkeleton` | DESIGNED or PARTIAL | No change | No change |
| `reviewQualityTestsSkeleton` | DESIGNED or PARTIAL | No change | No change |
| `reviewImplTestCase` | Target TC is RED or GREEN | No change | No change |
| `tellMeNextImplTest` | Has ≥1 PLANNED TC | No change | No change |
| `implTestCase` | Target TC is PLANNED | Target TC → RED | PARTIAL or FULLY_RED |
| `implTestFile` | Has ≥1 PLANNED TC | All PLANNED → RED | FULLY_RED |
| `designAndImplTest` | Any | All TCs → RED | FULLY_RED |

**State Preservation Guarantees**
1. Never downgrade status (RED → PLANNED never happens).
2. Never overwrite an implemented TC without explicit intent.
3. State-mismatched behaviors exit with clear errors.
4. Every state transition recorded in execution trace (US-INVENTOR-02).

---

### Priority Scale

| Priority | Meaning |
| --- | --- |
| **P0 Critical** | v0.1 cannot ship without this. |
| **P1 Important** | v1.0 needs this for a complete CaTDD workflow. |
| **P2 Valuable** | v1.x+ extends capability. |


> Full AC detail in role-specific sub-files. Status tracking in [README_UserStoryStatus.md](README_UserStoryStatus.md).

---

## Requirement Dependency Graph

```
US-USER-01 (parse & validate)
  ├──► US-DEV-01 (error messages)
  ├──► US-DEV-02 (logging)
  ├──► US-DEV-03 (interactive)
  ├──► US-INVENTOR-02 (execution traces)
  │
  ├──► US-USER-02 (design skeletons) ← US-INVENTOR-01
  │       ├──► US-USER-03 (review design, all tiers)
  │       ├──► US-USER-04 (pick next)
  │       └──► US-USER-07 (batch design)
  │
  ├──► US-USER-05 (implement one TC) ← US-INVENTOR-01
  │       ├──► US-USER-09 (review one impl)
  │       └──► US-USER-06 (implement all)
  │               └──► US-USER-10 (review all impl)
  │
  └──► US-USER-08 (design+implement) ← US-INVENTOR-01
          post-review via US-USER-03 + US-USER-10

US-INVENTOR-01 → required by U02, U05, U06, U08, U09, U10
US-INVENTOR-03 → runtime proof of US-INVENTOR-01
US-DEV-04 → P2, independent
```

---

## Non-Requirements

| Capability | Owned by |
| --- | --- |
| Define CaTDD categories, discipline rules, or method meaning | `methodPrompts/` |
| Define portable slash-command execution logic | `slashCommands/` |
| Wrap CaTDD as a generic CodeAgent skill | `agentSkills/` |
| Compile, run, or verify test code | User's build system |
| Generate production/source code | CLI produces test code only |
| Manage git branches, commits, or version control | User's workflow |
| Parse or validate source code language | Delegated to slash commands |
| Transition TC from RED to GREEN | User's TDD workflow |

---

## Traceability

| Artifact | Relationship |
| --- | --- |
| [README_UsageDesign.md](README_UsageDesign.md) | CLI argument contract. `--behave` aliases including `review*Skeleton` and `reviewImpl*`. Error handling. |
| [README_UserGuide.md](README_UserGuide.md) | Invocation-plan workflow. Behavior Selection Guide maps intent to all USER requirements. |
| [README.md](README.md) | WHAT/WHY of the CLI layer. |
| `methodPrompts/` | Category semantics (US-INVENTOR-01). Required by all design/implementation. |
| `slashCommands/` | Portable command execution (US-INVENTOR-01). Every `--behave` resolves here. |
| [../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md](../../.catdd/spec/analyzedNews/20260529-assemble-utCodeAgentCLI-user-stories-Issue.md) | Original request. |

---

## Open Questions

- Trace file output directory and naming convention?
- `--log-level trace` for raw prompt/response logging?
- First adapter runtime target: TypeScript CLI, Copilot-native, or OpenCode?
- `--target-file` as alternative to comma-separated inline paths?
- `--interactive-slash-commands` timeout for unattended CI?

---

## Maintenance Rule

Add a new requirement when a user need cannot be traced to any existing US-* ID. Downstream docs implement these requirements — they do not drive them.
