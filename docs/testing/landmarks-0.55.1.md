# Cave landmark repair — 0.55.1
2026-10-19 UTC. Baseline `mining-0.55.0`; checkpoint `landmarks-0.55.1`.

## Reproduced cause and repair
Godot 4.4.1 confirmed that JSON restores the landmark type as a float. The previous `f.type in [0,1]` membership was false after reload and chose the oath-pillar branch. Types are now normalized explicitly. A cached per-depth landmark definition supplies the artwork anchor, dimensions, elliptical base and depth-sort position together.

The player and crew collide with the bases, including undiscovered ones. Tall silhouettes remain walkable behind and are sorted with actors. Tool targeting, nearby hauling and workstation approach cannot reach through a solid base. Survey visibility still follows rock walls, so the floor beneath a prop does not turn into a fog-of-war wall. Discovery remains possible from clear approaches. Furniture/workstation placement and new lower stair landings reject obstructed bases.

Old saves receive a unique byte-exact `.pre-landmarks-551-*.bak` before loading. Excavations, inventories, quests, raw loads and automation are retained. An old embedded player moves to nearby clear ground on the same depth. If existing stairs/furniture/equipment overlap a previously decorative landmark, the landmark seeks nearby clear floor (within 320 units), saves its corrected anchors, and moves its drawing, base and inscription together. Player property and passage coordinates do not move. If no clear candidate exists in that bounded search, the landmark remains in place; densely built pathological overlap saves may need individual recovery. New placement rules prevent creating these overlaps.

## Actual checks
- 60 native source checks: all five depths, discovery, all three landmark variants, eight-direction approaches, clear routes, tool reach, construction, same-location Z passages, local unsticking and real repeated save/reload.
- 38 native mining regression checks.
- 32 native material-handling/Pinewood regression checks.
- 45 headless geology, crafting/trading, crew and save checks.
- 60 checks repeated against the final exported PCK, using the standalone external `tests/pack551.gd` harness.

235 completed checks passed. Before/after crystal captures are pixel-identical in both source and exported-pack runs. Native front/behind views of crystals and oath pillars were inspected beside the Dwarf. Evidence is in `landmarks-0.55.1/` including `exported/`.

The native environment is Linux Godot 4.4.1, Xvfb, Mesa llvmpipe and Dummy audio. Exported data was exercised using the Linux editor runtime, not a Windows executable or Linux release template. Windows execution and audible balance remain untested here. Existing shutdown resource-retention warnings remain (7–9 resources); no gameplay/script errors occurred in the completed passing runs. An initial handworks attempt exited without a completion marker and is excluded; the repeat completed all 32 checks.

## Package checks and recovery
All 2,670 PCK entries passed checksum, bounds, relative-path and executable-extension checks. ZIP members and CRC are verified during packaging. The Windows runtime is byte-identical to the previously verified official Godot 4.4.1 executable (`b493c1d53fb915f7805f360cfe42d1c3126e720dfc234a4b0f2feb99200f9a4b`). There is no installer or batch launcher.

A fresh ClamAV 1.5.3 scanner was acquired, but official signature downloads returned HTTP 403. No new antivirus result is claimed. The earlier .55 scan applies to that earlier package only; this build has no Windows Defender verdict. Do not disable security software to run it.

The entire .51 baseline plus .52/.53/.53.1/.54/.55 bundle chain was restored and checked with `git fsck --full`, matching .55 commit `8d92c92f6ff745fe34c2fb4884381f68e93d9a76`. Pre-edit tag `pre-landmarks-0.55.1` preserves it. Release recovery files record the new commit/tree and independent bundle verification. Old backups/releases remain intact; no remote was changed or pushed.
