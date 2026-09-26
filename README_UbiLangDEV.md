# CaTDD Ubiquitous Language - DEV View

Companion: [README_UbiLangUSER.md](README_UbiLangUSER.md) holds the vocabulary for teams using CaTDD on their own project. This file is the canonical meaning contract for the terms you need **to create and evolve CaTDD itself**: which layer owns what, how terms are named and retired, and where borrowed concepts are allowed to live.

## Who

- Method maintainers evolving `methodPrompts/`.
- Flow maintainers evolving `slashCommands/`.
- Code-agent maintainers evolving `codeAgents/` and `agentSkills/`.
- Anyone adding, renaming, or retiring a CaTDD term.

## What

### Ownership Vocabulary

| Layer | Responsibility |
| --- | --- |
| `methodPrompts/` | Source of truth for category semantics and CaTDD method constraints. |
| `slashCommands/` | Portable command/flow wrappers over method semantics. |
| `codeAgents/` | Goal-driven orchestration and execution policy. |
| `agentSkills/` | Packaged skills for non-native code agents. |

### Adapter and Install Surfaces

| Term | Meaning |
| --- | --- |
| agent instruction surface | The repository file that tells a code agent how to work in the project: `AGENTS.md`, plus `AGENTS.override.md` where a directory overrides it. `SPEC_initProjectContext` records each file with its path, scope, provenance, ownership by region, and a one-line summary; `SPEC_updateProjectContext` reconciles them. Provenance comes from the file itself: managed region only = `catdd-created`, hand-written text only = `pre-existing`, both = `mixed`, empty = `present-empty`. Ownership follows the region: the CaTDD-managed markers are regenerable and CaTDD-owned, everything else is project-owned. Authority is capped at operating conventions, so `AGENTS.md` never overrides method semantics, category meaning, gate rules, traceability, or project facts. The installer-generated adapters (`.github/instructions/*.md`, `.clinerules/*.md`, `.continue/rules/*.md`, `.antigravityrules/*.md`) and generated trees are rewritten wholesale and stay out of this model. |

### Naming Authority and Superseded Names

- Canonical category and file-name tokens are owned by `methodPrompts/CaTDD_methodPrompt-fileNaming.md`.
- `ModuleTesting` is a retired level name and is never used. Module-level scope is `SysTesting` when the module is the declared SUT.
- `RED/IMPLEMENTED` is a superseded status alias: a test that exists but has not executed is not RED.
- Codex skill names accept lowercase letters, numbers, and hyphens only, so `UT_convertDemoToTypical` installs as `$ut-convert-demo-to-typical`; the canonical command name stays in the wrapper description and body.

### Term Governance

- Add new domain terms here before spreading them to other docs.
- Keep wording stable for status and category names used by tools.
- Reject synonyms that change semantics; do not rename categories casually.
- A term earns a definition only if it names a CaTDD artifact, command, state, or value, **or** takes a common word and binds a narrowed sense a reader would otherwise get wrong. Anything else is reference material.
- A borrowed name is marked *(borrowed)* and is defined only far enough to fix which CaTDD value it maps to; the concept itself stays with its source.
- This file owns meaning. The commands own procedure. Do not restate procedure as definition.

## References (not this contract)

Concepts borrowed from other work are cited here, not defined as CaTDD terms.

| Concept | Source | Why it matters here |
| --- | --- | --- |
| Closed-Loop Regeneration Budget ($B$) | SGRM, Algorithm 1 (arXiv:2607.16680) | The formal safety bound on stochastic generation retries that `slashCommands/flows/Px-SpecFlow.md` aligns its loop bounds with. Default $B \le 3$; on exhaustion the agent rolls back unverified mutations, marks the TC `🚫 BLOCKED`, and escalates to human governance. |
| Spec-First / Spec-Anchored / Spec-as-Source | The capability ladder described by the SpecTDD book | Borrowed names used as `maturity_level` values in the USER view; their definitions belong to that source. |

## When

Use this glossary when:

- designing or evolving `methodPrompts/`, `slashCommands/`, `codeAgents/`, or `agentSkills/`,
- naming new `UT_*`/`SPEC_*`/`HARNESS_*` commands,
- retiring or superseding a term,
- reviewing wording drift across EN/ZH or across adapters.

## Why

CaTDD is method-driven. If key words drift, behavior drifts — and the drift is cheapest to catch here, before it reaches generated prompts, installed adapters, and target projects.

## How

1. Add a new term to the USER view or this file before spreading it to other docs.
2. Keep wording stable for status and category names used by tools.
3. Reject synonyms that change semantics.
4. Keep borrowed concepts in References unless CaTDD binds them to one of its own values.

## Usage Example

Check vocabulary consistency before release:

```bash
rg -n "Typical|Edge|Misuse|Fault|State|Capability|Interaction|Concurrency|Performance|Robust|Compatibility|Configuration|Diagnosis|Security|Demo/Example|US/AC/TC|SpecCoding|VibeCoding|Source-First|TestEvidenceChain|SUT|TestLevel|TestScope|UnitTesting|SysTesting|UserTesting|mockSysRtm|realSysRtm|ArchVerifyDesign|DetailVerifyDesign|UT|TP|TC|manualMode|autonomousMode|analysis_mode|ONE-MORE-THING|status_signal|completeness_level|maturity_level|integrity_level|level_evidence|level_gap|testPassOnMock|discovery_ledger|Spec-First|Spec-Anchored|Spec-as-Source" README*.md methodPrompts slashCommands codeAgents agentSkills
```

Expected result: terms are used with the same meanings as defined in this file and the USER view.
