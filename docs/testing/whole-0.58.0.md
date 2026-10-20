# Whole-character integration verification — unreleased

2026-10-19 · `whole-integration-wip-58`. Active source milestone, not a new Windows package. **Mechanical checks pass; visual acceptance fails.** See [specific visual blockers](../art/whole-integration-58.md). Do not infer polished animation from these counts.

## Actual execution

Godot 4.4.1 official Linux runtime, Xvfb 1280×720, software OpenGL Compatibility and Dummy audio. Native runs were sequential, with isolated save directories. Final logs are in `whole-0.58.0/logs/`. Completion markers and zero failed checks were verified, not merely successful process launch.

| Harness | Result | What it exercised |
|---|---|---|
| grips58 | 18 passed, 0 failed | Real 1–0 selection, walking, empty/actual supply, carry priority, independent cargo ownership, inventory and reload, rifle selection, prewarming |
| mining55 | 38 passed, 0 failed | Actual held mining, resistance/fracture progression, physical recovery, stockpiles/cart, worksite/mastery benefits, mineral depth continuity, crafting, stairs and exact save preservation |
| handworks55 | 32 passed, 0 failed | Physical input ownership, interrupted/completed station work, output collection, building, timber racks/cart, mastery, held axe felling and persistent logs |
| combat_edges53 | 10 passed, 0 failed | Facing guard, armor, dodge, parry interval, blocked/clear shots, ammo, hammer resistance, menu pause |

**98 mechanical checks passed.** Portrait review (`creator58`) also completed its live-palette refresh and female-profile assertions, then captured the creator, opening and foreman. The core/equipment/interior capture harnesses completed. Native motion58 recorded 180 frames at 15 frames per simulated second: 12 seconds covering pick, axe, supply and physical shoulder load in both horizontal directions. Representative original PNGs remain under `whole-0.58.0/motion`; the companion MP4 is unedited native frame playback, not a claim of animation acceptance.

## Visual observations

Inspected native palette, core, equipment, creator, tavern, mine carry and station captures plus representative movement frames. Hair is correctly recolored from source purple to selected natural colors. Complete figures remove the old head/body gap and skin circle. The reviewed core crops now retain boots and no longer pull neighboring boot fragments into those frames.

Remaining release blockers include unstable carry shoulders; changing tool/hairstyle/facing; clipped source keys; limited two-key equipped gait; missing mineral visual parity, supply tray occlusion, tattoos and uncalibrated directional sockets. Creator identity names also need comparison with the new paintings. The seated Lord remains the previous dedicated throne artwork. Source review found problems not shown by the baseline identity capture sheets. Full details are in the linked art review.

## Limits and next verification

No Windows execution, exported-PCK verification, audible sound test, hardware-performance benchmark, full world art acceptance or complete-frame acceptance across all variants is claimed. No new executable/ZIP was produced. VSync-change warnings are expected under the software display; final native logs contain no script errors. Headless import succeeded.

No movement speed, balance, world generation, save schema or quests changed. Existing terrain and progression are not regenerated. Old tests overwrote historical capture paths during regression runs; new captures were retained in this version's evidence and the earlier tracked evidence was restored byte-for-byte.

Correct the explicitly identified complete-frame sequences and materials first. Then review normal-speed native movement/work/handling and contact placement for each affected identity/facing; repeat only the relevant ownership/input regressions. A new export must include `assets/whole-v58/frames.json` (preset updated), pass independent pack checks, and retain official runtime packaging and prior backups.
