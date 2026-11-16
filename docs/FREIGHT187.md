# Freight corner review — 0.123.1

## Reproduced problem

A miner reassigned between cell centres could repeatedly collide with a tight tunnel corner. Pathfinding began at the centre of the current cell; movement began at the actual saved position. Clearing the blocked route and planning again chose the same first step.

The original native baseline failed the second pickup and the subsequent missing-destination assertion. Replay seed 162 reproduced both failures, with world seed 20388 and the carrier near (2164.47, 1571.06), off-centre in cell (54, 39). The adjacent rock corner blocked the diagonal first step. The diagnostic snapshots retained the empty carried load, intact route order, map and crew state. This is distinct from the earlier unrecorded lower-level failure; that older report remains unconfirmed.

## Change and preservation

Freight walks to the current cell centre before following a newly planned route. Normal collision checks remain active for every step; this does not teleport a carrier or change terrain. Existing pickup, delivery, return, cargo, storage, stair and save owners are unchanged.

The existing freight case now starts a route from a safe off-centre position at an excavated right-angle bend. It also records a replay seed and saves failure-NN.json before later assertions change state. Diagnostic data stays in files. The helper has a distinct name because exact-package tests inline the shared fixture.

## Local evidence

- Baseline: native and fixed-seed runs failed the same two assertions.
- Fixed replay: 41 headless assertions passed.
- Native freight: 44 assertions passed; mine and upstairs carrier/cargo captures reviewed.
- Opening, first visit and forge: 113 assertions passed. Welcome, cottage and Old Workings scene captures reviewed.
- Python tooling: 42 tests passed.
- Package harness: the first release attempt caught a duplicate function caused by fixture inlining. Renamed the diagnostic helper, verified the flattened script parses in Godot 4.4.1, and exercised all 44 assertions in that form. The direct local flattened run used ALSA fallback; clean hosted package validation remains authoritative.

Full source/package release evidence belongs in CURRENT_STATUS.md after publication. Local investigation files are under test-results/resume186; release evidence retains hosted test logs and captures. Normal-speed Windows input, audio and performance remain human checks.
