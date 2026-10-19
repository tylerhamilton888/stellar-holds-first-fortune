# Cave landmark repair — 0.55.1
Updated 2026-10-19 UTC. Checkpoint `landmarks-0.55.1`. Pre-edit tag `pre-landmarks-0.55.1` preserves verified .55 commit `8d92c92f6ff745fe34c2fb4884381f68e93d9a76`. The full recovery chain was restored and fsck-checked before edits. Prior releases and backups remain intact.

## Current result
Fixed crystals changing into oath pillars after JSON reload: normalize saved type numbers before selecting artwork. `deepworks.gd` now owns cached per-depth landmark anchors and physical bases shared by movement, crew navigation, tool reach, placement and `deepworks_play.gd` rendering. Props sort with actors so the Dwarf can walk behind tall artwork but cannot walk through its base. Survey reveals terrain independently of upright props; discovery still respects actual rock walls.

Old saves receive exact `.pre-landmarks-551-*.bak` copies before load. Terrain is never regenerated. Embedded old player positions resolve locally on the same depth. Landmarks overlapping legacy stairs/furniture/equipment seek nearby clear floor and persist corrected anchors; passage coordinates and player property remain. New stairs/furniture/workstations reject landmark overlap. The bounded legacy correction can leave an overlap if an exceptionally dense site has no clear candidate within 320 units; preserve the backup for individual recovery in that case.

The .55 mining balance, physical raw loads, field dressing, workstations, carts, Miner mastery, five depths and lode notes are unchanged. Pinewood, inventories, crafting, NPCs, quests and existing automation remain integrated. Existing larger-world/interior/animation and raw-workstation NPC backlog remains out of scope.

## Evidence / next entry points
Read `testing/landmarks-0.55.1.md`. 235 completed checks passed: 60 landmark source, 38 mining, 32 material/Pinewood, 45 geology/crew/model, 60 final exported-pack checks. Before/after reload images are pixel-identical. Native source/exported visual review covered crystal and pillar front/behind views. Native tests use Linux editor Godot 4.4.1, software OpenGL and Dummy audio; Windows/audio remain player checks. Retained-resource shutdown warnings persist.

All 2,670 PCK entries were audited. Windows EXE remains the unchanged official template. New antivirus scanning could not complete because signature downloads returned HTTP 403; do not inherit the old build's antivirus result or claim Defender clearance.

`deepworks.gd`: normalized type, landmark cache, base intersection, navigation, local recovery and legacy overlaps. `deepworks_play.gd`: shared prop depth sort/inscription. `living_works.gd`: placement rejection. `state.gd`: exact backup and additive revision. `tests/landmarks551.gd` and external `tests/pack551.gd`: regression entry points. Use isolated save data and sequential native displays. Current workspace: `/workspace/scratch/a447fc5d46ab/stellar-holds`; durable recovery is authoritative if scratch expires.

Standalone Windows ZIP plus .55.1 incremental source/Git update. Retain the .51 full baseline and .52/.53/.53.1/.54/.55 chain. Recovery.txt records exact hashes and restore commands. No remote was changed or pushed.
