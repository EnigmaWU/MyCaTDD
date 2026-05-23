# SPEC_refactorIssue

## Purpose

Route failed quality, unclear design, or implementation debt back into a focused correction loop.

## CoT Pattern

**ToT** — Tree of Thoughts. This command must inspect the review findings and changed files, generate candidate correction loops (update design, redesign tests, fix product code, or ask developer), evaluate each against the smallest correction that can make quality pass without hiding the finding, and select the best routing decision. Multiple correction paths may appear valid; ToT allows the assistant to reason over them before recommending one.

## Inputs

- `review_findings`: findings from story, test, product-code, or CI review.
- `changed_files`: files involved in the issue.
- `doing_user_story`: active story under `.catdd/spec/doingUS/`.

## Method References

- [../../flows/Px-SpecFlow.md](../../flows/Px-SpecFlow.md)
- [../../../methodPrompts/README.md](../../../methodPrompts/README.md)

## Output Contract

- Refactor or correction plan recorded in local gitignored active story context unless it becomes a new team-shared work item.
- Routing decision: update design, redesign tests, fix product code, or ask developer.
- Next recommended command.

## Prompt Template

Ask the assistant to identify the smallest correction loop that can make quality pass without hiding the original finding.

## Conflict Guard

Do not use refactoring to add new requirements. New requirements should become a new work item.

ONE-MORE-THING: ask developer if something not sure
