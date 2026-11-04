# The Stellar Holds — current recovery handoff

## Authoritative source and delivery

- Repository: https://github.com/tylerhamilton888/stellar-holds-first-fortune; integration branch: `master`.
- Game/engine: 0.97.2 / Godot 4.4.1. Opening development stops at the Thane homecoming.
- Polish PR: [#117](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/117), source `35eb33a39abf247d96f8b774a39b87f53c859f32`, tree `33666dc62525121009ead56fecb49a57c6b0c3dc`.
- [Source validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41760487374): all five jobs passed. PR #117 merged as `83444ee7141417ce677c8592fb3a708c5e51df54`; the merged tree exactly matches the tested source.
- [Windows release](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41761990982): running from `release/0.97.2`, commit `b305023db9889d46ce5fb244bb2b48f0f6b6bcf2`. Runtime is identical to the source PR; only delivery documentation differs. This workflow runs all 61 exported cases before publishing. Do not start a duplicate run.
- Last confirmed published download: 0.97.0. Do not claim 0.97.2 is published until the workflow and release assets are verified.

## Completed work

Compact HUD and contextual prompts; clearer illustrated first-shift/journal guidance; first-wage-to-room handoff; 26 painted material/food/workshop sprites matching the top-down camera; painted masonry and royal gallery dressing. Includes Eirik's straight royal axe, shoulder-rest grip and alternating return steps, plus giant trolls and the full Thaneship chapter. Saves, transactions and progression are preserved.

## Verification and next action

Final local native checks: 172 assertions. Final exact-pack checks: 811 assertions across polish, menus, homestead and invasion. All 3,893 package entries verified. Earlier regressions and final records: [acceptance](testing/polish135/acceptance.json). A concurrent native homestead process exited -9; sequential native/exported replays passed.

Source validation and merge are complete. Verify Windows publication and record the ZIP digest. Then owner playtests First visit to the hold in an empty slot: Ivar, first shift, mining/crafting, room/home progression, readability, combat feel, audio and device performance. Human pacing and Windows performance are not established by automated checks.

## Continue safely

Read [CURRENT_STATUS.md](CURRENT_STATUS.md), then only task-relevant files. Preserve original art, resource paths, UIDs and save compatibility. Follow [DEVELOPMENT.md](DEVELOPMENT.md) and [TESTING.md](TESTING.md). Owner authorization includes routine merge and delivery after required checks; no separate confirmation is needed. Do not expand beyond Thaneship without a new request.

[Full prior handoff](https://github.com/tylerhamilton888/stellar-holds-first-fortune/blob/b305023db9889d46ce5fb244bb2b48f0f6b6bcf2/docs/SESSION_HANDOFF.md) remains preserved in Git history. Old checkpoints are historical, not instructions to restore over current source.
