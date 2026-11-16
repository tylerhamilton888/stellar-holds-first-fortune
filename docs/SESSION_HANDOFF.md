# Session handoff — 0.123.0 delivered

Read CURRENT_STATUS.md and AGENTS.md. Owner requested pre-playtest polish, especially visibility and reasonable building sizes. Routine checked source merge and verified Windows delivery are authorized.

## Completed

0.123.0 is published; source PR #185 merged at 880d847ed4bea7d0537d3fca8c78c96e771ab61b. Release source 78394c0fce379bfbf76e7498741b1f59a39dc346. PR run 43921480366 and all 11 release jobs in run 43922798661 passed. Public metadata and asset digests were verified. See CURRENT_STATUS.md for exact hashes and counts.

Opening rooms now follow the player with cast-friendly headroom; north-wall fixtures can be revealed. Established room exits retain their clear framing. Tall foreground furnishings fade over the player without altering collision. Compact new workshops and older saved layouts retain their sizes and belongings. Native captures reviewed rooms, cottage, wards and entrances. See VISIBILITY185.md for scope and the camera regressions caught and corrected before release.

## Follow-up validation

PR #187 adds replay seeds and per-failure world/carrier/cargo snapshots to the existing freight case. It does not claim to resolve the intermittent failure or change the published build. See TESTING.md for replay instructions; use the PR checks for its validation state.

## Next work

Owner and wife playtest the first hours using the latest Windows ZIP. Check opening visibility, north-wall furnishings, exits above the hotbar, tall-prop cutaways, readable approaches and saved belongings. Then gather pacing/discoverability feedback before another feature batch. Windows hardware, input, audio and performance remain human tests.

Preserve the owner's direction: dwarves are perfectionists; approval follows sound workmanship. No story, economy or progression changes in this pass. Capture seed and worker/route state if the intermittent freight issue recurs.

Delivery documentation is maintained separately from the tested release source; do not change release/0.123.0 for documentation-only edits.

[Previous handoff](history/SESSION_HANDOFF-before-visibility185.md).
