# Metaspec Workspace Resolution

Every CaTDD slash command MUST resolve its metaspec workspace before reading or writing workflow state. `metaspec` is the meta-level control model used to create, trace, review, and evolve the complete `SPEC`; it is not the `SPEC` itself.

## Supported Workspaces

The following project-relative locations are supported:

| Workspace | Role |
| --- | --- |
| `.catdd/metaspec` | Canonical location for new installations and migrated projects. |
| `.agents/metaspec` | Supported agent-owned alternate location. |
| `.catdd/spec` | Legacy compatibility location for existing projects. |

Documentation and new worked examples use `.catdd/metaspec`. Existing projects MAY continue to use either alternate location.

## Persistent Declaration

The selected workspace MUST be declared in the root `projectContext.md`:

```text
metaspec_root: .catdd/metaspec
```

Only one value from the supported-workspace table is valid. Paths are relative to the project root and must not escape it.

## Resolution Procedure

1. If the command receives an explicit `metaspec_root`, validate that it is one of the supported relative paths and use it only to locate the candidate `projectContext.md`.
2. Inspect these candidate context files:
   - `.catdd/metaspec/projectContext.md`
   - `.agents/metaspec/projectContext.md`
   - `.catdd/spec/projectContext.md`
3. If exactly one candidate context exists, read its `metaspec_root`. If the field is absent, infer the value from the context file's physical parent. If the declared value disagrees with that parent, stop with configuration drift.
4. If no project context exists and exactly one workspace contains lifecycle content, select that workspace.
5. If no project context exists and no workspace contains lifecycle content, a write-capable command creates `.catdd/metaspec`.
6. If multiple project-context files or multiple populated workspaces exist, mutating commands MUST stop and request reconciliation through [HARNESS_migrateMetaspec](commands/Px-HarnessKits/HARNESS_migrateMetaspec.md). Read-only status and diagnosis commands MAY inspect every populated workspace and MUST report the ambiguity without repairing it.

## Read and Write Rules

- Resolve once at command start and reuse the selected root for the entire invocation.
- Read lifecycle artifacts only from the resolved root, except for read-only ambiguity diagnosis that explicitly reports every candidate root.
- Write lifecycle artifacts only to the resolved root.
- Never merge, relocate, or duplicate lifecycle artifacts across multiple roots during normal command execution.
- Treat `projectContext.md` as the durable declaration after bootstrap; do not store a workspace snapshot or absolute host path.
- Report the resolved root whenever a path is ambiguous or a command result includes generated lifecycle paths.

ONE-MORE-THING: when the workspace declaration, physical context location, and populated roots disagree, stop and ask the developer which workspace is authoritative.
