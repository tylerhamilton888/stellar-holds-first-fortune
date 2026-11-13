# Session handoff — 2026-11-13

Read this and [CURRENT_STATUS.md](CURRENT_STATUS.md) first. Avoid historical archives unless needed. User authorized routine source changes, PRs, merge and release; do not repeatedly request approval.

## Completed delivery

**0.111.1 is published:** https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.111.1

Feature PR #160 and legacy-site fix #161 are merged. Release source `fdf56920468474950488aa3051e4b780754ace55`, tree `89c980e85154f0b5d81f084aba280695e7e987ab`, merge `ce1c022c6fdffd392ff2211e598cfa45afe69b73`. Release run 43501138113 passed all 11 jobs: 86 native source cases and 76 exact-package cases / 14,485 assertions. PR run 43501138451 passed. Post-upload verification run 43506857764 passed; public JSON digests, clean source, PCK/ZIP hashes and asset size agree. See CURRENT_STATUS for hashes.

Workers receive real beds through **O → Plan Your Holding → A bed for your crew**. They walk the existing mine/cellar/upper-stair route, rest at the bedside with provisions, and return to existing assignments. Saved location and commute intent survive reload. Obstacles block travel; no remote rest, excavation or storage transfers. Legacy workers outside the claim are explicitly excluded from household navigation.

Implementation: scripts/estate_workers.gd; integration in deepworks_play.gd, surface.gd, room_blueprint_view.gd and estate_cellar.gd. Additive home building.worker_homes160 and crew estate_*160 fields preserve existing owners. tests/workers160.gd is in source/package coverage. Original 31-assertion headless/native preflight and 42 tooling tests passed; the final case adds two legacy-site checks. Native berth/resident presentation was reviewed.

## Next piece

Automated freight across the household/mine boundary is the remaining core blueprint slice. Carts currently stay parked at household stairs. Respect existing inventory, cargo, worksite and save ownership; do not add hidden remote spending or duplicated stores. Story integration and ordinary Windows playtesting are separate follow-up work. See BACKLOG and WORKERS160.

## Recovery safeguards

The local execution environment became unavailable during delivery. Source, tests and releases are in GitHub. Final validation ran in CI. Recover from current master; do not overwrite it with an older recovery ZIP.

Use Godot 4.4.1, bounded command capture and diagnostic excerpts. Do not dump large API payloads, logs, diffs, binary data or asset trees into conversation. Preserve assets, saves and prior releases. Documentation-only updates require no game rebuild.

verify/workers160-legacy-delivery is a separate post-upload evidence branch, not gameplay source; do not merge it. Do not rebuild the verified release for documentation-only changes.
