# Source 0.98.0 — Hold’s Ledger integration awaiting final validation

The first campaign-restructuring batch adds saved partial deliveries, staged forge restoration, a home milestone checklist and Skarrin’s welcoming gift/recognition dialogue. Existing homes, forge unlocks, projects and story progress remain authoritative. See [scope and remaining work](great-claim/LEDGER137.md). Native checks are underway; no new Windows release has been started.

# Current status — 0.97.2 published; faster releases verified

The opening through the Thane homecoming is implemented and polished. [Windows 0.97.2 is published](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.97.2). Its clean build passed all 61 exact-package cases in [run 41761990982](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/41761990982); the published ZIP size and digest match the build report. See [release receipt](testing/polish135/release.json).

[PR #119](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/119) merged the faster release pipeline as `a398cb54ea0d5a1fa8ca9a638666f3bf102c0051`, with a tested matching tree. Package checks now run on four separate runners: **66m 50s → 14m 59s** in the measured trial, all 61 cases and 13,706 assertions passing. The whole non-publishing build/validation trial took 30m 29s. Source validation runs alongside package work, and final publication requires complete matching proof. See [release process](RELEASE_PIPELINE.md) and [benchmark](testing/release136/benchmark.json).

No new gameplay or art changes accompany the pipeline work. Next: owner playtests First visit to the hold in an empty slot—first shift, mining/crafting, earning a room/home, readability, combat, audio and Windows performance. Human pacing and enjoyment remain playtest questions. Stop expansion at the Thane homecoming; marriage and district expansion remain deferred.

[Recovery handoff](SESSION_HANDOFF.md) records exact source/build refs and the current workflow. No release is pending from this task.
