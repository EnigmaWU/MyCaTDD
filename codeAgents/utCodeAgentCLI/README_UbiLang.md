# utCodeAgentCLI Ubiquitous Language

This document defines the shared domain language for `utCodeAgentCLI`.
Use these terms consistently across user stories, design docs, implementation, and review output.

## Who

- USER: The direct CLI caller. Includes NEW-USER and EXPERIENCED-USER sub-roles.
- INVENTOR: The method owner who ensures CaTDD semantics and delegation integrity.
- DEVELOPER: The implementer and maintainer of CLI runtime behavior and adapters.

## What

`utCodeAgentCLI` is a CaTDD-native orchestration layer that turns goal + context + target + behavior into traceable test-design and test-implementation actions.

### Core Terms

| Term | Meaning | Notes |
| --- | --- | --- |
| Goal | The user-intended outcome, passed by `--goal`. | Required for every invocation. |
| User Story | Requirement narrative used for traceability, passed by `--goalStory` or `--goalStoryFile`. | Use exactly one source. |
| Input Context | Source material used for design/implementation hints, passed by `--input` or `--inputFile`. | Use exactly one source. |
| Target | Test-space scope operated by CLI, passed by `--target`. | TestCase-in-TestFile, TestFile, or TestFiles list. |
| Behavior | Operation selected by `--behave`. | Resolves to one CLI behavior alias or portable `UT_*` command. |
| Skeleton | Comment-alive test design block containing `@[US]`, `@[AC-*]`, `@[TC-*]`, `@[Category]`, and `@[Status]`. | Design artifact only, no executable assertions yet. |
| Implemented TC | A TC with executable test code generated from a skeleton. | CLI owns `PLANNED -> RED`. |
| Trace | Machine-readable record of planning/execution/review outcomes. | Required for method governance and auditing. |

### Status Vocabulary

| Status | Meaning |
| --- | --- |
| `PLANNED` | Skeleton exists, executable test code not generated yet. |
| `RED` | Executable test exists and is expected to fail before production changes. |
| `GREEN` | Test passes after product-code changes (user-owned transition). |

### File-State Vocabulary

| State | Meaning |
| --- | --- |
| EMPTY | No CaTDD skeleton TCs found. |
| DESIGNED | All TCs are `PLANNED`. |
| PARTIAL | Mix of `PLANNED`, `RED`, and/or `GREEN`. |
| FULLY_RED | No `PLANNED` TCs remain; all are `RED` or `GREEN`. |
| ALL_GREEN | All TCs are `GREEN`. |

### Category Vocabulary

| Tier | Categories |
| --- | --- |
| P0 Functional | Typical, Edge, Misuse, Fault |
| P1 Design | State, Capability, Concurrency |
| P2 Quality | Performance, Robust, Compatibility, Configuration |

## When

Use this document when:

- Writing or updating USER/INVENTOR/DEVELOPER user stories.
- Naming new `--behave` values or reviewing behavior aliases.
- Implementing parser/validator/review output text.
- Reviewing skeleton integrity and state-transition logic.
- Resolving term ambiguity across README files.

## Where

Primary scope: `codeAgents/utCodeAgentCLI/`.

Terms here should stay consistent with:

- [README_UserStory.md](README_UserStory.md)
- [README_UsageDesign.md](README_UsageDesign.md)
- [README_ArchDesign.md](README_ArchDesign.md)
- [README_DetailDesign.md](README_DetailDesign.md)
- [README_UserGuide.md](README_UserGuide.md)

## Why

Without a single vocabulary source, documentation and implementation drift: behavior names diverge, status semantics blur, and traceability weakens.

This UbiLang file keeps all stakeholders aligned on exactly what each term means before code or tests are changed.

## How

Apply this checklist whenever adding or changing CLI capability:

1. Confirm every new term maps to an existing term in this file; if not, add it here first.
2. Keep parameter semantics strict: exactly one of each mutually exclusive pair.
3. Preserve status semantics (`PLANNED -> RED` by CLI; `RED -> GREEN` by user workflow).
4. Keep `--target` test-space only; source/context belongs in `--input` or `--inputFile`.
5. Ensure review outputs use vocabulary from this file verbatim.

## Usage Example

Use this quick consistency check before updating docs or CLI behavior text:

```bash
cd codeAgents/utCodeAgentCLI
rg -n "PLANNED|FULLY_RED|tellMeNextImplTest|designAllSkeleton|reviewImplTestFile" README*.md
```

Expected result: terms found in requirement/design docs use consistent spelling and semantics aligned with this file.
