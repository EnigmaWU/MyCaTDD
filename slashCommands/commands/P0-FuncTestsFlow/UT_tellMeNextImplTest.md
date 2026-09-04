# UT_tellMeNextImplTest

## Purpose

Select the next test case to implement from existing CaTDD skeletons.

Use this command when the developer already has Typical, Edge, Misuse, Fault, or later category skeletons and wants a clear next implementation step.

## CoT Pattern

**ToT** — Tree of Thoughts. Several TCs are usually implementable at once, and file order is not the right answer. This command must enumerate the ready candidates, score them against CaTDD category priority, status, and risk, then commit to exactly one.

### ToT Execution

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
```

Expected result:

- **Generate**: three non-GREEN TCs. `TC-FAULT-009` is `BLOCKED` on a missing sandbox credential → preconditions unmet.
- **Evaluate**: `TC-002` is Typical (highest CaTDD priority). `TC-EDGE-004` is Edge (lower). `TC-FAULT-009` rejected, not deferred — its blocker is reported separately.
- **Select**: `TC-002`.
- **Verify**: no other Typical TC is ready and unimplemented → nothing higher was skipped → selection stands.
- Reported: `TC-002` next because Typical precedes Edge in CaTDD priority, plus a note that `TC-FAULT-009` needs a credential before it can be selected. `next_command = UT_implTestCase`.

## Inputs

- `test_file_or_files`: files containing CaTDD skeletons.
- `current_status`: known TODO, RED, GREEN, ISSUES, or BLOCKED markers.
- `focus`: optional category or user story to prioritize.

## Method References

- [P0-FuncTestsFlow](../../flows/P0-FuncTestsFlow.md)
- [CaTDD_methodPrompt](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- One selected TC to implement next.
- Reason for selection based on category priority, risk, and current status.
- Required command to run next, usually `UT_implTestCase`.
- Preconditions or blockers if no TC is ready.

## Conflict Guard

Selection follows CaTDD category priority from `methodPrompts`, not file order alone.
