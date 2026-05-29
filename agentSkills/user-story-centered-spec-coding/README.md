# user-story-centered-spec-coding

Run a user-story-centered SpecCoding lifecycle from incoming issue or feature input to detail design, testing, implementation, review, commit, CI, and closure.

## What This Skill Does

This skill packages the `Px-SpecFlow` lifecycle as a reusable CodeAgent workflow.

It helps a developer or agent move work through:

```text
pendingNews -> todoUS -> doingUS -> doneUS
```

The skill is about story-centered lifecycle orchestration. It is not the CaTDD methodology itself.

## Boundary with CaTDD

- `comment-alive-test-driven-development` is CaTDD.
- `user-story-centered-spec-coding` is the SpecCoding flow.
- SpecCoding's UnitTesting defaults to CaTDD.
- SpecCoding may use typical TDD or another project-specific testing method when requested.
- CaTDD may be used by this SpecCoding flow, another SpecCoding flow, or non-SpecCoding test work.

In short:

```text
SpecCoding flow -> may use CaTDD
CaTDD -> does not depend on SpecCoding
```

## Lifecycle

| State | Purpose |
| --- | --- |
| `pendingNews` | Imported issue, bug, feature request, or product idea waiting for analysis. |
| `todoUS` | Analyzed user story ready to be opened. |
| `doingUS` | Active user story under design, test, implementation, or review. |
| `doneUS` | Completed story after review, commit, CI handling, and closure. |

## Core Flow

1. Establish or update project context.
2. Import issue or feature input into pending work.
3. Analyze pending input into a user story.
4. Open a selected story for active work.
5. Produce detail design and acceptance criteria.
6. Review story quality.
7. Design unit tests, defaulting to CaTDD when no other testing method is requested.
8. Implement tests and product code.
9. Review product code and traceability.
10. Route quality failures back to the correct phase.
11. Commit completed work.
12. Trigger or verify CI.
13. Close the user story and move it to done.

## Packaged References

Run `bash agentSkills/makeSkill.sh user-story-centered-spec-coding` from the repository root to generate a self-contained package under `agentSkills/dist/user-story-centered-spec-coding/`.

| File | Purpose |
| --- | --- |
| `SKILL.md` | Machine-readable workflow definition. |
| `README.md` | Human-readable overview of this skill. |
| `slashCommands/flows/Px-SpecFlow.md` | Source lifecycle flow for SpecCoding. |
| `slashCommands/commands/Px-SpecFlow/` | Concrete `SPEC_*` command steps. |
| `slashCommands/templates/README_*Template.md` | Project-root README SPEC doc templates, including ErrorDesign, ResourceDesign, StateDesign, PerfDesign, and DiagnosisDesign, used by `SPEC_takeDetailDesign` and related commands. |
| `slashCommands/README_UserGuide.md` | Practical slashCommands usage guide. |
| `references/README_UserGuide.md` | CaTDD user guide for default UnitTesting. |
| `references/CaTDD_methodPrompt.md` | CaTDD method contract when CaTDD is selected. |

## Usage Example

Generate the distributable SpecCoding skill package from the repository root:

```bash
bash agentSkills/makeSkill.sh user-story-centered-spec-coding
```

Generate into a temporary output directory for validation:

```bash
OUT_ROOT="$(mktemp -d)"
bash agentSkills/makeSkill.sh user-story-centered-spec-coding --output "$OUT_ROOT"
test -f "$OUT_ROOT/user-story-centered-spec-coding/SKILL.md"
test -f "$OUT_ROOT/user-story-centered-spec-coding/slashCommands/flows/Px-SpecFlow.md"
test -f "$OUT_ROOT/user-story-centered-spec-coding/slashCommands/templates/README_DetailDesignTemplate.md"
echo "$OUT_ROOT"
```

Expected result: the output directory contains `user-story-centered-spec-coding/SKILL.md`, copied CaTDD references, copied README SPEC templates, and copied `slashCommands/`, with no symlinks.

## Related Skills

- **`comment-alive-test-driven-development`** - Use when designing or implementing CaTDD-style comment-alive tests directly.
- **`test-driven-development`** - Use when a project asks for ordinary Red-Green-Refactor TDD without CaTDD comment structure.
- **`write-user-story`** and **`improve-user-story`** - Useful for story drafting or improvement, but this skill owns the larger SpecCoding lifecycle.

## Origin

This skill packages EnigmaWU's user-story-centered SpecCoding flow as implemented by `Px-SpecFlow` in MyCaTDD. It uses CaTDD as the default UnitTesting method without making CaTDD depend on this flow.
