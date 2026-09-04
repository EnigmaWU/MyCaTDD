# UT_implTestCase

## Purpose

Implement one selected CaTDD test case while preserving the comment-alive design skeleton.

Use this command after `UT_tellMeNextImplTest` has selected a TC or the developer has explicitly named one TC.

## CoT Pattern

**ReACT** — Reasoning + Acting. This command must locate the selected TC, implement it for the requested TDD stage, and check the result against the strict CaTDD layout and the meaning of the stage — a RED that fails for the wrong reason is not RED, and a GREEN reached by editing the test is not GREEN. Those checks are the loop's back-edges.

### ReACT Execution

Repeat for the one selected TC only.

1. **Thought** — Locate `selected_tc` and its linked US/AC. Decide the stage: `RED` when behavior is missing, `GREEN` only after RED is meaningful, `REFACTOR` only after the TC is GREEN.
2. **Action** — Implement that stage:
   - `RED`: write the test body with the strict 4-phase layout.
   - `GREEN`: write the minimal production code. Never edit the test to manufacture a pass.
   - `REFACTOR`: apply the ordered cleanup in the Refactor Order below.
3. **Observation** — Check the stage's own gate:
   - `RED` must fail for the missing product behavior, not a fixture, import, or environment error → otherwise back to **Action**.
   - The body must have visible `SETUP`/`BEHAVIOR`/`VERIFY`/`CLEANUP` markers, with key assertions in `VERIFY` written as `VERIFY_KEYPOINT_xyz` → otherwise back to **Action**.
   - If a missing behavior, edge case, or acceptance point surfaces, stop expanding this TC and ask the developer for a new TC.
4. **Stop** — Exit when the stage's gate passes. Update the TC status marker without deleting design comments, and report the verification result.

#### Refactor Order

1. Refine and clear design comments: follow the CaTDD template, preserve US/AC/TC markers, make key points glance-readable.
2. Refactor test code for readability without changing TC purpose, AC meaning, coverage intent, or expected behavior.
3. Refactor production code for readability and local structure only — no behavior, API, contract, or observable state change.
4. Rerun the focused TC and the relevant regression scope; the final state must be GREEN before REFACTOR is complete.

### Worked Example

Implementing one selected TC in RED stage:

```text
/UT_implTestCase
selected_tc: TC-002 verifyAuthorize_byValidCard_expectApproved
test_file: services/payment/SysTests/UT_Gateway.ts
source_files: services/payment/gatewayPort.ts
stage: RED
```

Expected result:

- **Thought**: TC-002 links to US-01/AC-02. `gatewayPort.ts` has no `authorize` yet → RED is the correct stage.
- **Action**: test body written with the four phase markers.
- **Observation**: first run fails on `Cannot find module './fixtures/card'` — a fixture error, not missing product behavior → not meaningful RED → back to **Action** → fixture path fixed.
- **Observation**: rerun fails on missing `authorize` → meaningful RED. But two key assertions are raw `assert.equal` outside `VERIFY` → layout gate fails → back to **Action** → moved into `VERIFY` as `VERIFY_KEYPOINT_authorizeApproved`.
- **Stop**: gate passes. TC-002 marked `RED`, design comments untouched. Only TC-002 was touched — TC-EDGE-004 was left alone.

## Inputs

- `selected_tc`: TC identifier and name.
- `test_file`: file to update.
- `source_files`: production files related to the behavior.
- `stage`: optional `RED`, `GREEN`, or `REFACTOR` focus.

## Method References

- [../../flows/P0-FuncTestsFlow.md](../../flows/P0-FuncTestsFlow.md)
- [../../../methodPrompts/CaTDD_methodPrompt.md](../../../methodPrompts/CaTDD_methodPrompt.md)

## Output Contract

- Test implementation for exactly one selected TC.
- Preserved US/AC/TC comments and status markers.
- Minimal production changes only when needed for the requested TDD stage.
- For REFACTOR stage, an ordered no-behavior-change cleanup report covering design comments, test code, production code, and final GREEN regression proof.
- Verification command or manual check result when available.
- STRICT style conformance in implemented TC body:
 	- Explicit `//===>>> SETUP <<<===`, `//===>>> BEHAVIOR <<<===`, `//===>>> VERIFY <<<===`, and `//===>>> CLEANUP <<<===` blocks.
 	- In `VERIFY` block, use `VERIFY_KEYPOINT_xyz` macros instead of raw `ASSERT_/EXPECT_` for key assertions when those macros are available in the project; if not available, add a local compatibility mapping and still write `VERIFY_KEYPOINT_xyz` in test code.
 	- Optional phase `printf` traces are allowed and recommended when they improve diagnosability.

## Conflict Guard

Do not batch unrelated TCs. CaTDD implementation should move one selected TC at a time unless the developer asks for a batch.
REFACTOR must not smuggle new behavior into an existing TC; missing points require a new TC or explicit developer approval.
Do not mark REFACTOR complete if the selected TC body is missing strict 4-phase markers or key `VERIFY_KEYPOINT_xyz` assertions.
