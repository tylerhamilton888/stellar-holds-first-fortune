# Ledger integration in progress — source 0.98.0

First batch: partial project deliveries, staged Cold Forge, personal-home checklist and welcoming Skarrin. See [LEDGER137](great-claim/LEDGER137.md). Source validation/visual review are in progress; do not claim a new Windows release. Published download remains 0.97.2. Preserve the existing finale and later story gates until their dedicated campaign batches.

# The Stellar Holds — current recovery handoff

## Source and playable build

- Repository: https://github.com/tylerhamilton888/stellar-holds-first-fortune; integration branch: `master`; engine: Godot 4.4.1; game version: 0.97.2.
- [Windows 0.97.2](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.97.2) is published. Release source: `b305023db9889d46ce5fb244bb2b48f0f6b6bcf2`. All 61 exported cases passed; published ZIP size/digest match the clean build report. [Receipt](testing/polish135/release.json).
- Polish PR #117 merged after all five native jobs passed; its source was `35eb33a39abf247d96f8b774a39b87f53c859f32`. Includes compact HUD, contextual prompts, illustrated guidance, room handoff, top-down item art, masonry/gallery dressing, corrected royal axe/shoulder carry and giant trolls.
- Pipeline PR #119 merged as `a398cb54ea0d5a1fa8ca9a638666f3bf102c0051`; the tested source is `a18252bef72b98b79e66d3132e78324f53ba41dd`, tree `cbcbc8bd6bf0fb6dc594d692a7fa375157b0cf37`. No runtime/art/version changes.

## Release process

Four independent runners test one verified Windows candidate. Every exported case is required exactly once, with matching source and package hashes. Both the complete native gate and packaged-game gate must pass before publication. The measured package stage fell from 66m 50s to 14m 59s; the complete PR rehearsal took 30m 29s. All 61 cases/13,706 assertions and 13 local pipeline safety tests passed. See [workflow and retry guidance](RELEASE_PIPELINE.md) and [benchmark](testing/release136/benchmark.json).

When a release is requested, start its reviewed candidate while the source PR's native gate runs; let the two stages overlap. Do not restart an existing release merely because a chat disconnected. Only `release/<version>` branches publish. Existing releases and saves remain preserved. No release is pending from this task.

## Next work

Owner playtest: First visit to the hold in an empty fortune slot, Ivar, first paid shift, mining/crafting, room/home progression, readability, combat feel, audio and device performance. Automated results do not establish human pacing or enjoyment. Opening expansion stops at the Thane homecoming; marriage/district development remain deferred.

Read [CURRENT_STATUS.md](CURRENT_STATUS.md), then task-relevant code/docs. Preserve original art, paths, UIDs and saves. Follow AGENTS.md, DEVELOPMENT.md and TESTING.md. Owner authorization includes routine merge/delivery after required checks. Keep handoffs concise; [prior full history](https://github.com/tylerhamilton888/stellar-holds-first-fortune/blob/b305023db9889d46ce5fb244bb2b48f0f6b6bcf2/docs/SESSION_HANDOFF.md) remains in Git.
