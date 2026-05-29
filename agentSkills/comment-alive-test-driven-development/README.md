# comment-alive-test-driven-development

Write new test files from scratch using CaTDD (Comment-alive Test-Driven Development), where structured comments define verification design before any code is written. Applicable to UnitTesting, SysTesting, and UserTesting in any language.

## What Is CaTDD

**CaTDD** (Comment-alive Test-Driven Development) is a software development methodology created by EnigmaWU (since October 2023) where:

- **Comments ARE Verification Design** — Structured comments (US/AC/TC) define what to verify, not just documentation.
- **LLMs Generate Code** — AI parses structured comments to produce test and production code.
- **Iterate Forward Together** — Design and code evolve as one through human+AI collaboration.

> **Slogan**: *"Comments is Verification Design. LLM Generates Code. Iterate Forward Together."*

The test file becomes the **single source of truth** — readable by humans, parseable by LLMs, and verified by tests.

## What This Skill Does

This skill guides the creation of a brand-new test file using CaTDD methodology by:

1. **Defining scope** — Writing the OVERVIEW (WHAT/WHERE/WHY) and coverage strategy.
2. **Designing verification** — Writing User Stories (US), Acceptance Criteria (AC), and Test Case specifications (TC) as structured comments.
3. **Implementing** — Following the TDD Red→Green cycle for each TC in priority order.
4. **Validating** — Checking traceability, coverage completeness, and test quality.

## CaTDD File Structure

```text
┌──────────────────────────────────────────────────┐
│ OVERVIEW                                         │
│   [WHAT] / [WHERE] / [WHY] / SCOPE / KEY CONCEPTS│
├──────────────────────────────────────────────────┤
│ UNIT TESTING DESIGN                              │
│   ├── Test Case Design Aspects (Priority Framework)│
│   ├── User Story Design (US)                     │
│   ├── Acceptance Criteria Design (AC)            │
│   └── Test Cases Design (TC specs + status)      │
├──────────────────────────────────────────────────┤
│ UNIT TESTING IMPLEMENTATION                      │
│   └── Tests with 4-phase pattern:                │
│       SETUP → BEHAVIOR → VERIFY → CLEANUP        │
├──────────────────────────────────────────────────┤
│ TODO / IMPLEMENTATION TRACKING                   │
│   └── Status: ⚪ TODO → 🔴 RED → 🟢 GREEN        │
└──────────────────────────────────────────────────┘
```

## US/AC/TC Hierarchy

```text
User Story (US) — WHY we need this feature (business value)
    ↓
Acceptance Criteria (AC) — WHAT behavior must be satisfied (GIVEN/WHEN/THEN)
    ↓
Test Case (TC) — HOW to verify the behavior (concrete steps)
```

## Priority Framework

```text
P0 🥇 FUNCTIONAL = ValidFunc(Typical + Edge) + InvalidFunc(Misuse + Fault)
P1 🥈 DESIGN     = State → Capability → Concurrency
P2 🥉 QUALITY    = Performance → Robust → Compatibility → Configuration
P3 🎯 ADDONS     = Demo/Example
```

## Applicable Testing Levels

| Level | Description | Example file names |
| ----- | ----------- | ------------------ |
| UnitTesting | Single module or function | `UT_FeatureName.cxx`, `test_module.py` |
| SysTesting | Component interactions | `ST_ServiceName.go`, `sys_test_*.java` |
| UserTesting | End-to-end user flows | `UAT_Feature.ts`, `user_acceptance_*.py` |

## Usage

### Trigger the Skill

In a conversation with an AI agent, say:

```text
Use CaTDD to write new tests for the UserAuth module in Python.
```

Or:

```text
Create a new CaTDD test file for the EventQueue service, system testing level.
```

Or:

```text
Apply comment-alive test-driven development to design tests for this API: <header file>
```

### Packaged References

The authored skill source keeps only the skill metadata. Run `bash agentSkills/makeSkill.sh` from the repository root to generate a self-contained package under `agentSkills/dist/comment-alive-test-driven-development/`.

| File | Purpose |
| ---- | ------- |
| `references/README_UserGuide.md` | Standalone CaTDD user guide copied from `methodPrompts/README_UserGuide.md` |
| `references/README_UserGuide_ZH.md` | Chinese standalone CaTDD user guide copied from `methodPrompts/README_UserGuide_ZH.md` |
| `references/CaTDD_methodPrompt.md` | Complete methodology specification with priority framework, category definitions, design skeletons, and quality gates copied from `methodPrompts/` |
| `references/CaTDD_ImplTemplate.cxx` | C++ implementation template showing the full CaTDD file structure, copied from `methodPrompts/` and adaptable for any language |
| `slashCommands` | Shared slash command prompts and user guides copied from repository `slashCommands/` |

## Usage Example

Generate the distributable skill package from the repository root:

```bash
bash agentSkills/makeSkill.sh
```

Expected result: `agentSkills/dist/comment-alive-test-driven-development/` contains `SKILL.md`, `README.md`, copied `references/`, and copied `slashCommands/`, with no symlinks.

## Related Skills

- **`UnitTesting-convert2CaTDD`** — Use this when you want to convert *existing* test files to CaTDD format. This skill (`comment-alive-test-driven-development`) is for writing *new* test files from scratch.
- **`user-story-centered-spec-coding`** — Use this when you need a full SpecCoding lifecycle around a user story; it uses CaTDD as the default UnitTesting method but does not replace CaTDD.
- **`test-driven-development`** — Classic TDD Red→Green→Refactor workflow without the CaTDD comment structure.

## Origin

CaTDD was developed by [EnigmaWU](https://github.com/EnigmaWU) in the [MyIOC_inTDD_withGHC](https://github.com/EnigmaWU/MyIOC_inTDD_withGHC) project. This skill packages the full methodology for reuse in any project through the MyCodeAgentSkills system.
