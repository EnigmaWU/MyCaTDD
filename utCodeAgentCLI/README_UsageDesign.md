# utCodeAgentCLI Usage Design

This document captures the CLI interface design for `utCodeAgentCLI`. It is based on [`slashCommands/templates/README_UsageDesignTemplate.md`](../slashCommands/templates/README_UsageDesignTemplate.md).

- Story: Usage design for utCodeAgentCLI
- Source artifact: GitHub issue — "Usage design for utCodeAgentCLI"
- Related overview: [README.md](README.md)
- Related user guide: [README_UserGuide.md](README_UserGuide.md)

## CLI Interface

```text
utCodeAgentCLI [OPTIONS]

Options:
  --target   <value>   Select the CaTDD work target.
  --behave   <value>   Select the behavior to apply to the target.
  --diagMethodPrompts  Print method prompts used for this invocation.
  --diagSlashCommands  Print slash commands used for this invocation.
```

## Argument Reference

| Argument | Type | Values | Required | Description |
| --- | --- | --- | --- | --- |
| `--target` | string | `TestCase` \| `TestFile` \| `InterfaceFile` \| `ProtocolFile` | yes | Selects the CaTDD artifact or scope the agent should act on. |
| `--behave` | string | `implTestCase` \| `implTestFile` \| `designTypical` \| `designEdge` \| `designSkeleton` \| `designAllSkeleton` \| `designAndImplTest` | yes | Selects the CaTDD workflow behavior the agent applies to the target. |
| `--diagMethodPrompts` | flag | — | no | Prints the method prompts resolved for this invocation before executing, then exits. Use for diagnosis and transparency. |
| `--diagSlashCommands` | flag | — | no | Prints the slash commands resolved for this invocation before executing, then exits. Use for diagnosis and transparency. |

### `--target` values

| Value | Meaning |
| --- | --- |
| `TestCase` | A single test case (one test function or method inside a test file). |
| `TestFile` | A whole test file containing multiple test cases. |
| `InterfaceFile` | An interface declaration file (e.g., a header, API contract, or abstract class). |
| `ProtocolFile` | A protocol or message-format file (e.g., a network protocol definition, IDL, or schema). |

### `--behave` values

| Value | Meaning |
| --- | --- |
| `implTestCase` | Implement a single test case in the target, following the RED step of CaTDD. |
| `implTestFile` | Implement all test cases in a target test file, following the RED step of CaTDD. |
| `designTypical` | Design a P0 Typical category test skeleton for the target. |
| `designEdge` | Design a P1/P2 Edge category test skeleton for the target. |
| `designSkeleton` | Design a single-category test skeleton for the target. |
| `designAllSkeleton` | Design all category test skeletons (Typical, Edge, and further) for the target. |
| `designAndImplTest` | Design all category skeletons and implement them in one combined step. |

## Behavior Matrix

| `--target` | `--behave` | Expected behavior |
| --- | --- | --- |
| `TestCase` | `implTestCase` | Implement one test case. Preserves CaTDD comment skeleton and RED status. |
| `TestFile` | `implTestFile` | Implement all test cases in the file. Preserves CaTDD status discipline. |
| `TestFile` | `designTypical` | Design P0 Typical skeleton inside the test file. |
| `TestFile` | `designEdge` | Design P1/P2 Edge skeleton inside the test file. |
| `TestFile` | `designSkeleton` | Design a single-category skeleton inside the test file. |
| `TestFile` | `designAllSkeleton` | Design all category skeletons inside the test file. |
| `TestFile` | `designAndImplTest` | Design all skeletons and implement them, maintaining RED then GREEN discipline. |
| `InterfaceFile` | `designAllSkeleton` | Design test skeletons for all interface functions or methods. |
| `InterfaceFile` | `designAndImplTest` | Design and implement tests for the interface in one step. |
| `ProtocolFile` | `designAllSkeleton` | Design test skeletons for all protocol message or field cases. |
| `ProtocolFile` | `designAndImplTest` | Design and implement tests for the protocol in one step. |

## Invocation Examples

```bash
# Design all test skeletons for a test file
utCodeAgentCLI --target TestFile --behave designAllSkeleton

# Implement a single test case
utCodeAgentCLI --target TestCase --behave implTestCase

# Design and implement tests from an interface file
utCodeAgentCLI --target InterfaceFile --behave designAndImplTest

# Print method prompts used for the invocation (diagnostic, no execution)
utCodeAgentCLI --target TestFile --behave designAllSkeleton --diagMethodPrompts

# Print slash commands used for the invocation (diagnostic, no execution)
utCodeAgentCLI --target TestFile --behave designAndImplTest --diagSlashCommands
```

## Error and Edge Handling

- `--target` missing -> Print usage and exit with a non-zero status code.
- `--behave` missing -> Print usage and exit with a non-zero status code.
- `--target` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--behave` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--target TestCase` combined with `--behave designAllSkeleton` -> Unsupported combination. Print error and exit; `designAllSkeleton` requires a file-level target.
- `--diagMethodPrompts` and `--diagSlashCommands` both provided -> Print both, then exit before execution.

## Open Questions

- Should `--diagMethodPrompts` and `--diagSlashCommands` execute the behavior after printing, or always exit early?
- Should `designEdge` and `designSkeleton` be merged into a single `designCategory <name>` value to support arbitrary CaTDD category names?
- Should `--target` accept a file path argument in addition to the type selector?

## Usage Example

Run from the repository root to inspect this usage design without changing source files:

```bash
TMP_DOC="$(mktemp -d)/README_UsageDesign.md"
cp utCodeAgentCLI/README_UsageDesign.md "$TMP_DOC"
grep -E '^##|--target|--behave|--diag' "$TMP_DOC"
```

Expected result: the temporary file path is printed, and the grep output shows all CLI argument names and section headings.

## Review Checklist

- Every argument has a type, value set, and clear description.
- Every supported combination in the behavior matrix has an expected outcome.
- Unsupported combinations have explicit error behavior.
- Open questions are visible before implementation begins.
- No runnable CLI implementation is claimed before it exists.
