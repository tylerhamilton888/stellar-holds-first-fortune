# Thaneship recovery — complete

Source PR #109 and delivery PR #110 are merged. Windows 0.95.0 is published after all source and exact-package gates passed. The release ZIP size and SHA-256 agree with its clean build report. See [release receipt](release.json) and [source acceptance](acceptance.json). No further recovery action or rebuild is pending.

Next work is opening-chapter polish: prioritize the immediate journal task, remove the duplicated title footer, and measure normal-speed pacing, combat retries, audio and Windows-device performance. Keep the story endpoint at Thane homecoming; marriage and districts remain future work.

## Recovery history

# Thaneship recovery — source merged, release pending

All five hosted checks passed in attempt 2 at 2026-11-03T19:54:11Z. PR #109 merged as `496ccc9a1a86cf81ce2d2a191cdb7a8652bbc5be`; its tree matches tested source exactly. The four additional exported opener cases passed 325 assertions. Windows release run 41705684539 remains in progress.

Source PR #109: `f2627d5ccd2c24012ae10b7f1123ad2b0aa94cb8`, tree `ec99c3a53f9fe58e7eff88bba0d1c98e6aa1f43f`. Local source commit `d76b4a8` has that identical tree. The runtime is unchanged by this delivery branch.

Native and exact-export chapter acceptance each passed 639 assertions; preceding regressions passed 2,582 native and 2,363 exact-export assertions. All 3,863 PCK entries passed integrity checks. Scene and choice captures remain under `/tmp/thane131-exact-final` and `/tmp/thane131-choice-review` in the recovery environment.

The first hosted validation attempt passed all four gameplay groups. Its people-preview job spent approximately 17 minutes fetching the repository and was cancelled during testing around the 20-minute job limit. Only that job was requested for retry; inspect all five conclusions in run 41695999934 before merging. This delivery branch increases the future people-preview budget to 45 minutes, preserving every test. Parsed YAML comparison confirms that this timeout is the only behavior change in the workflow.

Windows release branch `release/0.95.0` points to `0744f011ebdf09c4c65cf0f6e968b6988d1765fe`. This differs from tested source only in `docs/RELEASE_NOTES.md`; it is eligible for the existing identical-source release gate. Release run 41705684539 will test the complete exported pack and publish only after the full source gate succeeds. Do not replace older releases. Verify final assets and their digest before reporting the build as published.

Recovery opener review uses `/tmp/thane131-recovery-opener`; a prepared finalizer at `/tmp/finalize-thane131-docs.py` requires successful hosted evidence and the actual merge SHA. Final source/delivery records must distinguish source completion, publication and unmeasured human pacing.

## Initial polish findings

Exported title and save-slot screens are legible and hide gameplay HUD. Trial choice buttons and Thane homecoming are readable. The early frontier journal currently presents the future ancestry milestone and general town overview above the immediate first-shift task; prioritize the current task in the next runtime polish pass. This is a presentation issue, not a blocked quest. The title footer also repeats the chapter name. Preserve the validated chapter endpoint and avoid adding marriage or district systems during polish.
