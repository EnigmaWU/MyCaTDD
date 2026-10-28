# Test Case: Method Prompt Consistency

## Purpose

Maintainers run this check after changing CaTDD method prompts to detect drift in category sections, naming, status markers, language templates, and project-wide traceability guidance.

## Status

Implemented. The ID checks were observed failing before the contract was added and pass after it. This script checks documented contracts; it does not prove that an agent follows them or that project IDs are actually unique.

## Covered

- Category-prompt sections, canonical test-file names, and status vocabulary.
- Every category skeleton carries US, AC, TP, and TC metadata and references the project-wide ID contract.
- Required metadata in language templates and consistency of method README claims.
- A project-wide ID contract for User Stories and their AC, TP, and TC identifiers.
- Issue analysis and the todo-story template propagate registered Story IDs into AC declarations.
- Feature analysis, story import, abort recovery, and story opening reference the same ID contract and registry.
- Discovery, test-design and product-code handoffs, and all four language templates carry qualified US/AC/TP/TC examples.
- Planning and design templates plus lifecycle review, closure, and merge commands preserve registered identities.

## Manual

Run the command below from the repository root with Bash and standard command-line utilities. Review the ID allocation, collision, and legacy-handling guidance separately for semantic completeness.

## Usage Example

```bash
bash scripts/test_methodPrompts_consistency.sh
```

Expected: the script exits zero when all checked contracts are present; otherwise it reports the missing or inconsistent contract.
