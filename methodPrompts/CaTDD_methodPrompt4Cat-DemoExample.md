# CaTDD method prompt for Category: DemoExample

Use this prompt when designing P3 Addons tests that demonstrate an end-to-end workflow for documentation, tutorials, onboarding, or visible examples.

## Position

DemoExample belongs to P3 Addons testing.

```text
P3 Addons = Demo/Example
```

DemoExample proves that a user-visible workflow can be followed and observed as documented.

P3 Addons is a learning surface only. DemoExample evidence never substitutes for P0 Functional, P1 Design, or P2 Quality verification, and behavior that must be guaranteed belongs to those classes regardless of how well the demo documents it.

## Use When

- You need a tutorial, user guide demo, sample workflow, or onboarding example.
- The scenario should show how to use the feature, not just assert internals.
- Documentation needs an executable or manually verifiable companion.

## Do Not Use When

- The scenario is required for functional correctness; use P0 categories first.
- The scenario verifies architecture or quality attributes; use P1/P2 categories.
- The example would invent behavior not present in the user guide or requirements.

## Design Focus

- Anchor every demo to a real UserGuide or README section.
- Define setup, run, visible output, and cleanup explicitly.
- Show that the demo exercises already-proven P0/P1/P2 behavior instead of replacing it.
- Label simulated, recorded, or manual steps honestly.

## TestPointsInMind

First apply the source inventory and applicable sweep in [CaTDD_methodPrompt-testPointDiscovery.md](CaTDD_methodPrompt-testPointDiscovery.md). Record candidates in `discovery_ledger`; apply the Discovery Gate before implementation. Domain examples are optional prompts, not requirements or coverage quotas; use source-defined limits and oracles.

When this category applies, consider test points such as:

- The smallest copy-exec workflow from the UserGuide or README that demonstrates real user value.
- Setup, command/API call, expected visible output, generated files, cleanup, and re-run behavior.
- A demo path that exercises already-proven P0/P1/P2 behavior without replacing those required tests.
- Documentation drift checks: command flags, output snippets, filenames, examples, and expected status stay aligned with the guide.
- New-user ergonomics: prerequisites are explicit, failure output is understandable, and the example can be followed without hidden local state.
- Domain-specific questions:
  - *Embedded Linux*: Does the guide identify whether a loopback/device example needs a host fixture, simulator, or target board, with explicit manual observations and cleanup?
  - *Microservices*: Can the documented setup/request/cleanup workflow produce the specified response and status, including any intentional nonzero error example?
  - *LLM Agents*: Does the walkthrough distinguish fake/recorded dependencies from live calls, state permissions and cost prerequisites, and expose the promised result without substituting a mock for the declared SUT?

## Design Skeleton

```text
// @[Class]: P3 Addons
// @[Category]: DemoExample
// @[Intent]: Demonstrate a complete user-visible workflow.
// @[UseWhen]: A guide, tutorial, or onboarding path needs executable evidence.
// @[AvoidWhen]: The scenario is required functional, design, or quality verification.
// @[GuidePath]: [README/UserGuide section]
// @[VisibleOutput]: [files, logs, UI, command output]
// @[TC]: verifyDemo_by[Workflow]_expect[DocumentedOutput]
```

## US/AC/TC Pattern

```text
US-n: As a new user,
      I want [documented workflow] to run as written,
      So that I can learn the feature by following the guide.

AC-n: GIVEN [documented prerequisites and setup],
      WHEN [the guide's workflow is executed as written],
      THEN [the documented visible output appears],
       AND [cleanup and re-run leave a repeatable state].

TC-n:
  @[Name]: verifyDemo_by[Workflow]_expect[DocumentedOutput]
  @[Purpose]: Validate the user-visible documented workflow.
  @[Brief]: Follow the guide step by step, capture the promised output, then clean up.
  @[Expect]: Output matches the guide; prerequisites and any simulation are explicit.
```

## Naming Examples

```text
verifyDemo_byQuickStartWalkthrough_expectDocumentedCliOutput
verifyOnboarding_bySampleConfigRun_expectGeneratedFilesListed
verifyExample_byCopyExecCommands_expectSameResultAsGuide
verifyTutorial_byCleanupAndRerun_expectRepeatableState
```

## Checklist

- Does the demo map to a real user guide section?
- Are setup, run, expected output, and cleanup clear?
- Does the demo avoid replacing required P0/P1/P2 tests?
- Can a new user understand the feature by reading or running it?

## Common Mistakes

- Using the demo as a substitute for required functional or quality tests.
- Letting the guide and the runnable example drift out of sync.
- Presenting simulated or recorded dependencies as live behavior.
- Omitting prerequisites, cleanup, or re-run behavior.
