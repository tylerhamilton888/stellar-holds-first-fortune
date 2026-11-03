# Thaneship recovery checkpoint

Source PR #109: `f2627d5ccd2c24012ae10b7f1123ad2b0aa94cb8`, tree `ec99c3a53f9fe58e7eff88bba0d1c98e6aa1f43f`. Local source commit `d76b4a8` has that identical tree. The runtime is unchanged by this delivery branch.

Native and exact-export chapter acceptance each passed 639 assertions; preceding regressions passed 2,582 native and 2,363 exact-export assertions. All 3,863 PCK entries passed integrity checks. Scene and choice captures remain under `/tmp/thane131-exact-final` and `/tmp/thane131-choice-review` in the recovery environment.

The first hosted validation attempt passed all four gameplay groups. Its people-preview job spent approximately 17 minutes fetching the repository and was cancelled during testing around the 20-minute job limit. Only that job was requested for retry; inspect all five conclusions in run 41695999934 before merging. Increase the future people-preview job budget to 45 minutes after this source delivery, preserving every test.

Windows release branch `release/0.95.0` points to `0744f011ebdf09c4c65cf0f6e968b6988d1765fe`. This differs from tested source only in `docs/RELEASE_NOTES.md`; it is eligible for the existing identical-source release gate. Release run 41705684539 will test the complete exported pack and publish only after the full source gate succeeds. Do not replace older releases. Verify final assets and their digest before reporting the build as published.

Recovery opener review uses `/tmp/thane131-recovery-opener`; a prepared finalizer at `/tmp/finalize-thane131-docs.py` requires successful hosted evidence and the actual merge SHA. Final source/delivery records must distinguish source completion, publication and unmeasured human pacing.

## Initial polish findings

Exported title and save-slot screens are legible and hide gameplay HUD. Trial choice buttons and Thane homecoming are readable. The early frontier journal currently presents the future ancestry milestone and general town overview above the immediate first-shift task; prioritize the current task in the next runtime polish pass. This is a presentation issue, not a blocked quest. The title footer also repeats the chapter name. Preserve the validated chapter endpoint and avoid adding marriage or district systems during polish.
