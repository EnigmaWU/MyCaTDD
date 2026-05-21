# {{ProjectName}} User Guide

Practical guide for {{target readers}} using {{ProjectName}}.

This is the SpecCoding template for project-root `README_UserGuide.md`. Create or update it from `SPEC_takeDetailDesign` when a story needs user-facing or developer-facing usage guidance.

For WHAT the project or module is and WHY it exists, read [README.md](README.md). This guide owns HOW, WHO, WHEN, WHERE, and runnable examples.

## Who

Use this guide if you are:

- {{Reader role 1}}
- {{Reader role 2}}
- {{Reader role 3}}

## What

This guide explains how to {{main user outcome}}.

It covers:

- {{Capability or workflow 1}}
- {{Capability or workflow 2}}
- {{Validation or expected result}}

## When

Use this guide when:

- {{Use case 1}}
- {{Use case 2}}
- {{Use case 3}}

## Where

The main repository paths are:

```text
{{path/to/user-facing-entrypoint}}
{{path/to/config-or-output}}
```

## Why

This workflow matters because {{why the reader should follow it}}.

It helps preserve:

- {{Quality or traceability goal}}
- {{Reuse or automation goal}}
- {{Boundary or maintenance goal}}

## How

1. {{Step 1}}
2. {{Step 2}}
3. {{Step 3}}
4. {{Validation step}}

## Usage Example

Run from the repository root to instantiate this user-guide template into a temporary file:

```bash
TMP_DOC="$(mktemp -d)/README_UserGuide.md"
cp slashCommands/templates/README_UserGuideTemplate.md "$TMP_DOC"
sed -n '1,100p' "$TMP_DOC"
```

Expected result: the temporary file shows the user-guide structure, including 5W1H sections and this usage example.

## Quality Checklist

- Replace every `{{placeholder}}`.
- Keep commands copy-executable.
- Keep WHAT / WHY details in `README.md`, not duplicated here.
- Link to `README_DetailDesign.md` or `README_VerifyDesign.md` only when users need design or verification context.
