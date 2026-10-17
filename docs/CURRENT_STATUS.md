# Current status
Updated **2026-10-18 UTC** (October 17 evening locally). Gameplay build **0.40.0**, checkpoint/tag **pinewood-0.40.0**. Current work: Pinewood timber gathering.

## Implemented
- Pinewood: painted forest/camp background, seven marked firs, contact-timed chopping, full-size felling, fallen-log recovery, progress indicators, field board and basin travel. Old cuts survive; new `forestry` save dictionary records logs, fall times and direction. No automatic regrowth.
- Native side-view Godot game with character creator, five designs per sex, portraits, names, three save slots and audio settings.
- Guided arrival, introductions, commissions, royal audience, separate anniversary gift quests/cinematic, quest markers and NPC location tracking.
- Hold floor map, interiors, basin travel and map-table expeditions. Persisted mountain excavation, ore/terrain drops, pick/shovel, steel requirement, dirt/water simulation and construction/return routes.
- Survey bearings and mineral selection; dirt-sifting bonus with saved progress; lower downward strikes and footing-aware targeting.
- Inventory, smelting/crafting, supply-sensitive trade, research, mountain claims, outpost recruitment/roles, physical crew mining, industrial upgrades and energy-fed mining gun.
- Weapons/armor, attack/block/parry/dodge, practice and finite hostile salvage encounters. These are implemented; not all combat/content branches were rerun in this infrastructure task.

## Partial / future
Ship construction and launch progression are scaffolding, not a finished interstellar game. Procedural address seeds and encounters are not full civilizations or galaxy simulation. Family names/dynasty metadata exist; marriage, descendants, succession and immortal Greatbeard play remain future. Personal skill XP is not an established completed system. Closed destinations must remain WIP.

## Problems and uncertainty
- Latest downward mining and prospecting still need user acceptance for feel/balance. No new gameplay blocker was reproduced in this task.
- Title and integration-test shutdown report ObjectDB/resource-in-use warnings. Import and the other selected tests were clean. Do not describe this as a warning-free build.
- Windows launcher and real historical player-save migration were not tested here. Synthetic save slots passed; legacy loading can regenerate old mountain metadata.
- Historical docs/tests can be stale; use these current references and actual code first. Some visual harnesses contain absolute capture paths.
- Repeated past risk areas: hair/skin recoloring, walk silhouettes, grip/head contact, NPC location parity and menu clarity. Preserve fixes; inspect affected views after relevant edits.

## Objective and next three tasks
Current milestone: a reliable first season with satisfying mining.
1. Player-test 0.39.1 downward/overhead mining and return-route building (MINE-01).
2. Player-test whether a newcomer understands and benefits from sampling/sifting (MINE-02).
3. Complete a fresh opening plus a copied real-save reload on Windows (OPEN-01, SAVE-01, QA-01).

Unresolved: detailed family/immortality rules; galaxy simulation granularity and streaming; interstellar economy; progression balance after player feedback. Do not invent these as already decided.

## Latest verification: 0.40.0
Godot 4.4.1 Linux. Import and export passed. Forestry: 53 checks; campaign: 43 checks; existing smoke suite: 220 counted checks plus three-slot assertions. Native rendered arrival, both ends of coupe, axe/log contact, 12 fall stages and paused field board inspected. Exported PCK boot verified. Windows execution and listening on speakers remain unverified. See `testing/pinewood-0.40.0.md`.

Historical expedition25: 194 pass, 2 fail because it still requires continuous mine/trail walking, intentionally removed earlier. This is recorded, not called a clean suite. Existing shutdown resource warnings remain.

## Previous verification: continuity-1
Godot **4.4.1**, Linux headless, isolated temporary user data. Import and title boot passed. Seven selected test scripts passed: integration smoke (10 checks), granular mining (36), controller (18), opening (13), outpost (67), industry (76), and three-slot save/reload assertions. Total: **220 counted checks plus save-slot assertions**, zero test failures. Teardown warnings noted above. Results: `docs/testing/continuity-1-smoke.json`.

All **5,621** original source-archive files remain present. Only original README content changed (entry pointer); original runtime scripts/scenes/settings/assets/audio and existing tests are unchanged. Literal runtime preload/load references exist, and Godot import found no fatal reference/parse errors. Integrity record: `docs/testing/continuity-1-integrity.json`.

Prior session: 0.39.1 downward suite 494 checks and contact screenshots; 0.39.0 survey/UI checks; six interiors visually checked for 0.38.2. Those visuals were not rerendered here because graphics were unchanged. This is a focused continuity audit, not exhaustive gameplay certification.
