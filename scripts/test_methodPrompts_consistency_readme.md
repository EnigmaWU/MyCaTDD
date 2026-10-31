# Test Case: Method Prompt Consistency

## Purpose

Maintainers run this check after changing CaTDD method prompts to detect drift in category sections, naming, status markers, language templates, project-wide traceability guidance, and the checked Action example.

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
- The main/discovery prompts and all four language templates require exactly one covering TC per TP and one-or-more TPs per TC, without retaining superseded one-TP-to-many-TCs wording.
- All P0 design commands reference the complete US/AC/TP/TC contract; the full P0 gate rejects unassigned or multiply assigned TPs and TCs without TPs.
- Discovery reports failed cardinality when the expanded in-scope ledger contains unassigned TPs.
- The Action chapter's three full-queue TC identities retain their behavior names, matching trace IDs, and one two-scope status per tracked case.
- Permanent StoryIdAlias/CreatedAt metadata, alias-prefixed child IDs, and authoritative TP ownership in verification-design documents.
- Execution of the documented alias-creation snippet: its UTC+08:00 timestamp and alias must describe the same instant.
- Parsing the canonical requirements/TP-ledger/TC example as a graph: AC ownership, sole covering TC per TP, complete reverse TP lists, and literal-search trace rows.
- Literal `grep -F` lookup across isolated registry, hidden story, verification-design, and test-file artifacts; a todo-to-doing move must preserve identity and creation time. Legacy references remain resolvable through a mapping without rewriting the archived source.
- Acceptance of one TC covering multiple TPs, including TPs owned by different ACs.
- Ten invalid fixtures reject duplicate aliases, aliases shadowing another Story ID, unknown creation times, alias/time mismatches, unknown ACs, unassigned TCs, duplicate TP definitions, two TCs claiming the same TP, omitted TP coverage, and wrong trace rows.

## Manual

Run the command below from the repository root with Bash, Python 3, and standard command-line utilities. Review the ID allocation, collision, and legacy-handling guidance separately for semantic completeness. Vendored skill references, generated installations, and other book examples remain outside this check's scope; run related guide, review-gate, and bilingual-mirror checks when those surfaces change.

## Usage Example

```bash
bash scripts/test_methodPrompts_consistency.sh
```

Expected: the script exits zero when all checked contracts are present; otherwise it reports the missing or inconsistent contract.
