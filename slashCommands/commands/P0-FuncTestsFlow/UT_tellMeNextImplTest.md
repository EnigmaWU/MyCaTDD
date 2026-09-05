# UT_tellMeNextImplTest

## Purpose

Select the next test case to implement from existing CaTDD skeletons.

Use this command when the developer already has Typical, Edge, Misuse, Fault, or later category skeletons and wants a clear next implementation step.

## CoT Pattern

**ToT** — Tree of Thoughts. Several TCs are usually implementable at once, and file order is not the right answer. This command must enumerate the ready candidates, score them against CaTDD category priority, status, and risk, then commit to exactly one.

### ToT Execution

Before selecting a P0 TC, resolve current `review_evidence` from the caller or linked design comments: declared scope/source references, the discovery ledger, and the `UT_reviewFuncTestsSkeleton` result (or equivalent standalone Discovery Gate review). Require both gates to pass and `ready_for_implementation: yes` for that scope. Missing evidence, unresolved discovery findings, or changed sources/skeleton behavior since review returns to design/review rather than selecting a TC. Do not infer readiness from TODO/RED markers. Ordinary TC execution progress does not invalidate otherwise current design review.

1. **Generate** — Read all TC status markers and list every TC that is `TODO` or `RED` and whose dependencies are met. That is the candidate set.
2. **Evaluate** — Score each candidate by CaTDD category priority from `methodPrompts` (not file order), current status, and risk. Reject candidates whose preconditions are unmet; a `BLOCKED` TC is rejected, not deferred.
3. **Select** — Choose exactly one unless the developer asked for a batch. If two candidates tie on priority and risk, present both and ask.
4. **Execute** — Report the selected TC and why it is next.
5. **Verify** — Confirm no higher-priority category has a ready TC that was skipped. If one exists, return to **Select**.

Do not implement anything here; wait for the developer to invoke `UT_implTestCase`.

### Worked Example

Picking the next TC from a partially implemented file:

```text
/UT_tellMeNextImplTest
test_file_or_files: services/payment/SysTests/UT_Gateway.ts
current_status: TC-001 GREEN, TC-002 TODO, TC-EDGE-004 TODO, TC-FAULT-009 BLOCKED
review_evidence: current source/ledger review passed for this scope; ready_for_implementation: yes
```

Expected result:

- **Gate**: the reviewed functional design is current. TC-FAULT-009's missing credential is an execution prerequisite, not an unresolved source/oracle question; it blocks that TC, not the completed discovery review.
- **Generate**: three non-GREEN TCs. `TC-FAULT-009` is `BLOCKED` on a missing sandbox credential → preconditions unmet.
- **Evaluate**: `TC-002` is Typical (highest CaTDD priority). `TC-EDGE-004` is Edge (lower). `TC-FAULT-009` rejected, not deferred — its blocker is reported separately.
- **Select**: `TC-002`.
- **Verify**: no other Typical TC is ready and unimplemented → nothing higher was skipped → selection stands.
- Reported: `TC-002` next because Typical precedes Edge in CaTDD priority, plus a note that `TC-FAULT-009` needs a credential before it can be selected. `next_command = UT_implTestCase`.

## Inputs

- `test_file_or_files`: files containing CaTDD skeletons.
- `current_status`: known TODO, RED, GREEN, ISSUES, or BLOCKED markers.
- `focus`: optional category or user story to prioritize.
- `review_evidence`: current P0 source/ledger review result, supplied or resolved from design comments; missing or stale evidence blocks P0 selection.

## Method References

- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)
- [CaTDD_methodPrompt-testPointDiscovery](../../../methodPrompts/CaTDD_methodPrompt-testPointDiscovery.md)

## Output Contract

- One selected TC to implement next, or no selection with a design/review blocker when P0 readiness evidence is missing, stale, or failing.
- Reason for selection based on category priority, risk, and current status.
- Required command to run next, usually `UT_implTestCase`.
- Preconditions or blockers if no TC is ready.

## Conflict Guard

Selection follows CaTDD category priority from `methodPrompts`, not file order alone.
