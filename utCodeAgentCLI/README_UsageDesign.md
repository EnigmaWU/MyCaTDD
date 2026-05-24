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
  --diagMethodPrompts  Emit DIAG log messages showing which method prompts the agent resolved.
  --diagSlashCommands  Emit DIAG log messages showing which slash commands the agent resolved.
```

## Argument Reference

| Argument | Type | Values | Required | Description |
| --- | --- | --- | --- | --- |
| `--target` | string | `TestCase` \| `TestFile` \| `InterfaceFile` \| `ProtocolFile` | yes | Selects the CaTDD artifact or scope the agent should act on. |
| `--behave` | string | `implTestCase` \| `implTestFile` \| `designTypical` \| `designEdge` \| `designSkeleton` \| `designAllSkeleton` \| `designAndImplTest` | yes | Selects the CaTDD workflow behavior the agent applies to the target. |
| `--diagMethodPrompts` | flag | — | no | Emits DIAG-class log messages listing the method prompts the agent resolved for this invocation. Confirms correct CaTDD methodPrompt selection at runtime. |
| `--diagSlashCommands` | flag | — | no | Emits DIAG-class log messages listing the slash commands the agent resolved for this invocation. Confirms correct CaTDD slashCommand selection at runtime. |

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
| `implTestCase` | Implement a single test case in the target, following the RED step of CaTDD. Adds executable test code. |
| `implTestFile` | Implement all test cases in a target test file, following the RED step of CaTDD. Adds executable test code. |
| `designTypical` | Design test cases using the CaTDD **Typical** category. Produces a category skeleton with US/AC/TC entries appropriate for core happy-path scenarios. Does **not** add implementation test code. |
| `designEdge` | Design test cases using the CaTDD **Edge** category. Produces a category skeleton with US/AC/TC entries for valid boundary values, limits, and mode variations. Does **not** add implementation test code. |
| `designSkeleton` | Design a single-category test skeleton: US/AC/TC comments are placed in the target file but **no implementation test code** is written. Use when only the skeleton structure is needed before deciding which specific CaTDD category to fill. |
| `designAllSkeleton` | Design skeletons for all applicable CaTDD categories (Typical, Edge, and others). US/AC/TC comments for every category are placed in the target file, but **no implementation test code** is written. |
| `designAndImplTest` | Design all category skeletons **and** implement their test cases in one combined step. Both US/AC/TC structure and executable test code are produced. |

> **Key distinction**: `designTypical`, `designEdge`, and other category-named values use a specific CaTDD-defined category to drive the design content. `designSkeleton` and `designAllSkeleton` produce the US/AC/TC skeleton structure without any implementation test code, regardless of category.

## Behavior Matrix

| `--target` | `--behave` | Expected behavior |
| --- | --- | --- |
| `TestCase` | `implTestCase` | Implement one test case. Adds executable test code. Preserves CaTDD comment skeleton and RED status. |
| `TestFile` | `implTestFile` | Implement all test cases in the file. Adds executable test code. Preserves CaTDD status discipline. |
| `TestFile` | `designTypical` | Design Typical category content using the CaTDD Typical category definition. Places US/AC/TC for core happy-path scenarios. No implementation test code. |
| `TestFile` | `designEdge` | Design Edge category content using the CaTDD Edge category definition. Places US/AC/TC for boundary values and valid limits. No implementation test code. |
| `TestFile` | `designSkeleton` | Place a single-category US/AC/TC skeleton in the test file. No implementation test code. |
| `TestFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all applicable CaTDD categories in the test file. No implementation test code. |
| `TestFile` | `designAndImplTest` | Design all category skeletons and implement them. Produces both US/AC/TC structure and executable test code. |
| `InterfaceFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all interface functions or methods. No implementation test code. |
| `InterfaceFile` | `designAndImplTest` | Design all skeletons for interface functions and implement their test cases. |
| `ProtocolFile` | `designAllSkeleton` | Place US/AC/TC skeletons for all protocol message or field cases. No implementation test code. |
| `ProtocolFile` | `designAndImplTest` | Design all skeletons for protocol cases and implement their test cases. |

## Invocation Examples

```bash
# Design all test skeletons for a test file
utCodeAgentCLI --target TestFile --behave designAllSkeleton

# Implement a single test case
utCodeAgentCLI --target TestCase --behave implTestCase

# Design and implement tests from an interface file
utCodeAgentCLI --target InterfaceFile --behave designAndImplTest

# Emit DIAG log messages showing resolved method prompts during execution
utCodeAgentCLI --target TestFile --behave designAllSkeleton --diagMethodPrompts

# Emit DIAG log messages showing resolved slash commands during execution
utCodeAgentCLI --target TestFile --behave designAndImplTest --diagSlashCommands
```

## Error and Edge Handling

- `--target` missing -> Print usage and exit with a non-zero status code.
- `--behave` missing -> Print usage and exit with a non-zero status code.
- `--target` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--behave` given an unrecognized value -> Print supported values and exit with a non-zero status code.
- `--target TestCase` combined with `--behave designAllSkeleton` -> Unsupported combination. Print error and exit; `designAllSkeleton` requires a file-level target.
- `--diagMethodPrompts` and `--diagSlashCommands` both provided -> Emit DIAG log messages for both during execution.

## Open Questions

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
