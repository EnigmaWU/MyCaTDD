# utCodeAgentCLI — AC Status Dashboard

Each AC carries a `PENDING` | `TODO` | `DOING` | `DONE` | `SUSPEND` | `ABORT` status marker.
See `README_UserStory.md` for the state transition diagram and rules.

This file is the authoritative AC lifecycle dashboard for `utCodeAgentCLI`; per-story documents carry matching status markers and stable AC IDs.

---

## Status Totals

| Story | Source | PENDING | TODO | DOING | DONE | SUSPEND | ABORT | Total |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| US-USER-01 | [USs/USER-01](USs/README_UserStory4USER-01.md) | 0 | 0 | 0 | 32 | 0 | 0 | **32** |
| US-USER-02 | [USs/USER-02](USs/README_UserStory4USER-02.md) | 20 | 0 | 0 | 0 | 0 | 0 | **20** |
| US-USER-03 | [USs/USER-03](USs/README_UserStory4USER-03.md) | 17 | 0 | 0 | 0 | 0 | 0 | **17** |
| US-USER-04 | [USs/USER-04](USs/README_UserStory4USER-04.md) | 15 | 0 | 0 | 0 | 0 | 0 | **15** |
| US-USER-05 | [USs/USER-05](USs/README_UserStory4USER-05.md) | 18 | 0 | 0 | 0 | 0 | 0 | **18** |
| US-USER-06 | [USs/USER-06](USs/README_UserStory4USER-06.md) | 9 | 0 | 0 | 0 | 0 | 0 | **9** |
| US-USER-07 | [USs/USER-07](USs/README_UserStory4USER-07.md) | 7 | 0 | 0 | 0 | 0 | 0 | **7** |
| US-USER-08 | [USs/USER-08](USs/README_UserStory4USER-08.md) | 8 | 0 | 0 | 0 | 0 | 0 | **8** |
| US-USER-09 | [USs/USER-09](USs/README_UserStory4USER-09.md) | 15 | 0 | 0 | 0 | 0 | 0 | **15** |
| US-USER-10 | [USs/USER-10](USs/README_UserStory4USER-10.md) | 14 | 0 | 0 | 0 | 0 | 0 | **14** |
| US-INVENTOR-01 | [USs/INV-01](USs/README_UserStory4INVENTOR-01.md) | 0 | 15 | 0 | 1 | 0 | 0 | **16** |
| US-SPECFLOW-REPAIR-01 | [active lifecycle repair](../../.catdd/spec/doingUS/20260830-utCodeAgentCLI-partial-closure-reconciliation-UserStory.md) | 0 | 0 | 5 | 0 | 0 | 0 | **5** |
| US-INVENTOR-02 | [USs/INV-02](USs/README_UserStory4INVENTOR-02.md) | 17 | 0 | 0 | 0 | 0 | 0 | **17** |
| US-INVENTOR-03 | [USs/INV-03](USs/README_UserStory4INVENTOR-03.md) | 6 | 0 | 0 | 0 | 0 | 0 | **6** |
| US-DEV-01 | [USs/DEV-01](USs/README_UserStory4DEVELOPER-01.md) | 15 | 0 | 0 | 0 | 0 | 0 | **15** |
| US-DEV-02 | [USs/DEV-02](USs/README_UserStory4DEVELOPER-02.md) | 6 | 0 | 0 | 0 | 0 | 0 | **6** |
| US-DEV-03 | [USs/DEV-03](USs/README_UserStory4DEVELOPER-03.md) | 6 | 0 | 0 | 0 | 0 | 0 | **6** |
| US-DEV-04 | [USs/DEV-04](USs/README_UserStory4DEVELOPER-04.md) | 17 | 0 | 0 | 0 | 0 | 0 | **17** |
| US-DEV-05 | [USs/DEV-05](USs/README_UserStory4DEVELOPER-05.md) | 18 | 0 | 0 | 0 | 0 | 0 | **18** |
| **Total** | | **208** | **15** | **5** | **33** | **0** | **0** | **261** |

> Click a story ID to view its AC detail with per-AC status markers.
>
> `US-INVENTOR-01` is partially closed: AC-01 is accepted DONE evidence, while AC-02 through AC-16 remain TODO and are owned by [US-INVENTOR-01-FOLLOWUP-01](../../.catdd/spec/todoUS/20260830-utCodeAgentCLI-US-INVENTOR-01-remaining-delegation-UserStory.md).
