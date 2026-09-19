# {{ProjectName}} Verification Design Index

This is the SpecCoding template for project-root `README_VerifyDesign.md` while it serves as a routing index. Verification design is split into `README_ArchVerifyDesign.md` (`SysTesting`, `UserTesting`) and `README_DetailVerifyDesign.md` (`UnitTesting`); this file exists to give developers and CodeAgents one entry point and to keep existing links working during migration.

`README_VerifyDesign.md` is a pointer artifact, not a design artifact. It must not carry strategy, category coverage, TP design, or US/AC/TC status. Retire it once every "Related verification design" link in the other README SPEC docs points directly at the pair.

## Routing Table

| Artifact | Owner commands | Scope | Link |
| --- | --- | --- | --- |
| `README_ArchVerifyDesign.md` | create/update `SPEC_takeArchDesign`; revise `SPEC_updateArchDesign`; gate `SPEC_reviewArchDesign` | `SysTesting` and `UserTesting` strategy: verification topology, level-and-boundary map, target runtime environment, double credibility, evidence and equipment ownership. | [README_ArchVerifyDesign.md](README_ArchVerifyDesign.md) |
| `README_DetailVerifyDesign.md` | create/update `SPEC_takeDetailDesign`; revise `SPEC_updateDetailDesign`; gate `SPEC_reviewDetailDesign` | `UnitTesting` strategy: behavior inventory, `discovery_ledger`, Discovery Gate, CaTDD category x quadrant coverage, submodule strategy, fixtures and oracles. | [README_DetailVerifyDesign.md](README_DetailVerifyDesign.md) |
| Dynamic status location (optional) | updated by the working step that ran the verification | Live TP/TC status, commands, run results, temporary gaps: `README_VerifyStatusTraces.md` when the project keeps one, otherwise story TASKs or test-file comments. | {{path, story TASKs, or test-file comments}} |

## Rules

- The index duplicates no design content. Content that starts explaining strategy belongs in one of the two design documents instead.
- Route by `TestLevel`: `UnitTesting` -> detail design; `SysTesting`/`UserTesting` -> architecture design; promotion preserves the TP ID.
- A link that does not resolve, or a design surface with no owner, is a GAP recorded here until it is routed.
- Keep live status out of this file; point at the project's dynamic status location (`README_VerifyStatusTraces.md`, story TASKs, or test-file comments).
- On retirement, migrate every "Related verification design" link to the specific half and leave the tombstone note in project context.

## Migration State

- {{Where this repository is in the index -> pair migration.}}
- {{Which inbound links still point at this index, and what happens to them next.}}
- {{Approval reference for the retirement, or "not yet approved".}}

## Usage Example

Run from the repository root to instantiate this index template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_VerifyDesign.md"
cp slashCommands/templates/README_VerifyDesignTemplate.md "$TMP_DOC"
sed -n '1,120p' "$TMP_DOC"
```

Expected result: the temporary file shows the routing table, rules, and migration state only — no verification strategy, category coverage, TP design, or US/AC/TC status.

## Review Checklist

- The index routes to both design documents and to the dynamic status companion.
- No design, category, or status content is duplicated here.
- Every remaining inbound link to this index has a named migration step.
- Retiring the index is an explicit decision with an approval reference, not a silent deletion.
