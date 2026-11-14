# Session handoff — 2026-11-13

Read this and CURRENT_STATUS.md first. User authorized routine source changes, PR, checked merge and verified release; do not request repeated permission.

## Completed delivery

**0.112.0 is published:** https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.112.0

Feature PR #163 merged. Release source `0333a54554592847579b4e211798ce625da7e321`, tree `25f92aa50fd96396c23a73bd2acdc5c8ad76fbc8`, merge `94486969f7da5b9920b42afa49bd6657dc6bc73f`. Release run 43538478196 passed all 11 jobs: 87 native source cases and 77 exact-package cases / 14,528 assertions. PR run 43538483052 passed. Public JSON digests, clean source, PCK/ZIP hashes and asset size were checked after publication; CURRENT_STATUS holds the hashes.

Freight is in **O → Plan Your Holding → Freight for the household**. Existing recruited miners carry selected stack items between marked mine stockpiles and household chests, in either direction, through actual passages and stairs. Loads are capped at 32. Stop, resume, return and finish-delivery controls preserve interrupted cargo; blocked/missing stores do not delete it. Provisions, masonry jobs, berths, work assignments, pack and chest ownership stay with their existing systems. Wheelbarrows stay underground.

Implementation: scripts/estate_freight.gd; integration in estate_workers, deepworks_play, deep_haul, room_blueprint_view, surface and mine_view94. Orders/cargo live additively in the claim building's freight162 dictionary; worker location remains in the existing crew record. Paths are transient. tests/freight162.gd is included in source/package coverage. Native preflight passed 43 freight, 33 worker and 49 cellar assertions; tooling passed 42 tests. Book, upstairs cargo and perspective cargo were visually reviewed. See FREIGHT162.md.

## Next piece

Core connected estate travel and automated porter freight are delivered. Provisional Old Stonewright's Rise/property-story introduction remains the next blueprint follow-up, then normal Windows playtesting and polish. New depths, automated excavation, Handworks raw-load freight and cart-sized household stairs are separate scope. Preserve existing possessions and progression.

## Recovery safeguards

Recover from current master or the release source, not an older ZIP. Source and release evidence are in GitHub. General Actions listings briefly lagged; branch-filtered queries and the live page confirmed the jobs. Do not restart merely for stale status displays.

Use pinned Godot 4.4.1, bounded capture and selected diagnostic excerpts. Keep source/assets out of large encoded tool payloads. Preserve original art, saves and releases. No sub-agents unless requested. Follow RELEASE_PIPELINE.md; documentation-only changes do not rebuild the game.
