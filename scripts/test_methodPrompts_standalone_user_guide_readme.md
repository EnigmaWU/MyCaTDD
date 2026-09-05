# Test Case: standalone method and discovery contract

## Purpose

Maintainers run [test_methodPrompts_standalone_user_guide.sh](test_methodPrompts_standalone_user_guide.sh) after changing standalone method prompts or their P0 command consumers. SUT: `methodPrompts`, with P0 command integration checks. The script checks documentation contracts, not whether an agent can discover every real-world test point.

## Status

Discovery regression checks implemented. The initial run failed on the missing Behavior Inventory; the readiness handoff extension separately failed on missing selector review evidence. Existing guide checks are preserved. Run from the repository root with Bash and standard command-line utilities. No deployment, credentials, or external services are needed.

## Covered

- Existing standalone guide structure, EN/ZH references, category prompts, naming, and templates.
- US-DISCOVERY-01: As a method user, I want source-first discovery and explicit coverage gaps so structurally valid skeletons are not mistaken for complete verification design.
- AC-DISCOVERY-01 / TC-DISCOVERY-01: The method requires a behavior inventory, P0 discovery sweep, and test-point ledger.
- AC-DISCOVERY-02 / TC-DISCOVERY-02: The method separates accounted-for points from readiness, preserves unknowns, and includes escaped-bug learning and an actionable example.
- The report-consistency guard checks for explicit guidance after an illustrative agent run found intended gaps but miscounted dispositions, weakened an explicit shared rejection rule into a question, and reported GAPS despite unresolved scope applicability. This is evidence for the added audit, not a claim that prompt outputs are deterministic.
- AC-DISCOVERY-03 / TC-DISCOVERY-03: Main entry, workflow, structure, agent checkpoints, and P0 deep dives route to the discovery gate.
- AC-DISCOVERY-04 / TC-DISCOVERY-04: Full P0 design/review commands require discovery evidence, explicit readiness, and findings without an already-existing TC ID; next-TC selection requires current review evidence.
- AC-DISCOVERY-05 / TC-DISCOVERY-05: Both standalone guides expose the discovery ledger and readiness contract.

These are text-contract regression checks. They cannot prove semantic coverage, test correctness, or fewer deployment bugs. Review the self-contained exporter example in the discovery prompt separately: a missing normal preview path must fail review even when the four existing categories have valid US/AC/TC links; an unspecified timeout must remain a question, not become invented behavior.

Two bounded illustrative agent exercises detected the missing preview workflow, valid lower/invalid upper boundaries, and partial-write fault. The replay correctly kept explicit shared rejection rules and reported BLOCKED, but still proposed an unjustified extra mid-range case and inconsistently labeled scope/referral details. The method now explicitly permits justified equivalence representatives; agent compliance and deployment defect reduction remain unproven. Do not interpret passing keyword checks as a passing behavioral benchmark.

## Manual

1. Run the checks below after editing prompts or commands.
2. Confirm failures name the missing contract and file rather than a tooling error.
3. Review source-to-test reconciliation, valid/invalid boundary routing, and unresolved-question handling semantically; keyword checks alone are insufficient.
4. No test-generated files require cleanup.

## Usage Example

```bash
bash scripts/test_methodPrompts_standalone_user_guide.sh
bash scripts/check_readme_mirror.sh
bash scripts/test_slashcommands_complete.sh
```

Expected: each command exits zero after the discovery contract is implemented. During RED, the first command must report the missing discovery contract.
