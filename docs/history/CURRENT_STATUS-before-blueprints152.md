# Current status — 2026-11-10

## Windows 0.106.0 delivered

[Download and release notes](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.106.0).

The first-hour pass is merged in PR #150 and published. Ivar welcomes the player to their room before explaining the first shift. Lodge conversations use the lower dialogue shell with a fixed portrait and scrolling choices. The journal, HUD and shift book follow one immediate lead through first pay and the forge. Furnishing can wait; an alternate trade can be chosen explicitly. Forge guidance respects inspection, practical processing, carried coal and partial deposits.

Existing saves, costs, wages, rewards and progression requirements are unchanged. Wider town systems remain accessible on request. See [FIRST_HOUR.md](FIRST_HOUR.md) for scope and [PLAYTEST_GUIDE.md](PLAYTEST_GUIDE.md) for the current route.

Source: 686a2d3ce914a257168d6798d8a8f11affee787c; merge: 7341b784b2424bf906a270c48ae8c4938ff7afeb. [Release run 42912965464](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/42912965464) passed all 80 native scenarios, 70 exact-package scenarios / 14,184 assertions, integrity verification and publication. Published build.json and release-summary.json agree on source, PCK and ZIP hashes; ZIP size is 964,651,997 bytes. Permanent evidence is attached to the release.

Local acceptance covered six scenarios / 238 assertions and 42 tooling tests. Visual review caught a deferred dialogue-height issue; it was fixed and the affected lodge/menu/opening cases rerun successfully. Human Windows input/audio review and actual first-hour pacing remain playtest feedback.

Next: play a fresh empty slot from arrival through first pay and the forge; also check existing saves. Preserve previous builds and saves. No rebuild without a new change or concrete failure.

## Conversation-size safeguards

Bounded output, file-only capture, safe diagnostics, CI evidence and current-document budgets remain enforced. These controls reduce repository hazards; they cannot guarantee ChatGPT backend reliability. See CONVERSATION_OUTPUT.md. Previous delivery status is preserved in [history](history/CURRENT_STATUS-before-0.106.0.md).
