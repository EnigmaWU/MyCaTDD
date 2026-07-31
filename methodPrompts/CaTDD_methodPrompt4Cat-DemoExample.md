# CaTDD method prompt for Category: DemoExample

Use this prompt when designing P3 Addons tests that demonstrate an end-to-end workflow for documentation, tutorials, onboarding, or visible examples.

## Position

DemoExample belongs to P3 Addons testing.

```text
P3 Addons = Demo/Example
```

DemoExample proves that a user-visible workflow can be followed and observed as documented.

## Use When

- You need a tutorial, user guide demo, sample workflow, or onboarding example.
- The scenario should show how to use the feature, not just assert internals.
- Documentation needs an executable or manually verifiable companion.

## Do Not Use When

- The scenario is required for functional correctness; use P0 categories first.
- The scenario verifies architecture or quality attributes; use P1/P2 categories.
- The example would invent behavior not present in the user guide or requirements.

## TestPointsInMind

When this category applies, consider test points such as:

- The smallest copy-exec workflow from the UserGuide or README that demonstrates real user value.
- Setup, command/API call, expected visible output, generated files, cleanup, and re-run behavior.
- A demo path that exercises already-proven P0/P1/P2 behavior without replacing those required tests.
- Documentation drift checks: command flags, output snippets, filenames, examples, and expected status stay aligned with the guide.
- New-user ergonomics: prerequisites are explicit, failure output is understandable, and the example can be followed without hidden local state.

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

## Checklist

- Does the demo map to a real user guide section?
- Are setup, run, expected output, and cleanup clear?
- Does the demo avoid replacing required P0/P1/P2 tests?
- Can a new user understand the feature by reading or running it?
