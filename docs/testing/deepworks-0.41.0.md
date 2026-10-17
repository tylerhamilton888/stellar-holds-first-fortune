# Deepworks 0.41.0 verification
Godot 4.4.1 Linux, isolated XDG_DATA_HOME for all save-writing tests. Tests run against the integrated main game, not a separate prototype.

| Gate | Result |
|---|---|
| Pre-change Git fsck, original bundle verification, new full bundle verification | Passed; baseline 69ffe5131b23102f21788e36953ac00b8212cd5c; pre-deepworks-20261017 |
| Deepworks model and actual main-game flow | 45 passed, 0 failed |
| Native rendered held mouse/key/UI-button flow | 8 passed, 0 failed |
| Pinewood | 53 passed, 0 failed |
| Campaign | 43 passed, 0 failed |
| Existing smoke suite | Title, continuity, slots, granular, controller, opening, outpost, industry passed; prior 220 counted checks plus slot assertions |
| Native visual review | Entrance, grip/contact, debris, lower survey, geode, ruins, build board, Pinewood and both sexes/four directions inspected |
| Windows PCK export | Passed |
| Exported PCK native Linux mine boot and capture | Passed |

The flow test starts a fortune in main.gd, enters the mine through arrive_region, moves without gravity, mines coal/iron with inventory rewards, carves/traverses matching stairs through five depths, encounters a cavern, returns through basin travel, smelts and sells resources, reloads independent terrain/links/discoveries/fixtures/damage/position, verifies Pinewood, migrates a synthetic legacy save with an exact backup, recruits existing workers/automaton and tests physical descent to an assigned depth, reloads assignments, and checks slagcaster energy/slag production. Rare discoveries cannot reward twice.

Native input test injects a held mouse button into the real viewport and runs main._process; releasing it stops mining. It drives diagonal movement, opens V, emits the actual board's Carve button, waits the 1.2-second operation, uses E/Shift+E, then saves and reloads its position. Thus parsing alone is not the release criterion.

Initial model-test comparisons reported failures because JSON restores integers as floats. Comparisons now normalize JSON numeric representation; no save data was discarded to pass them. A random basalt landing correctly blocked a non-steel test dwarf; the deep-chain fixture now equips steel before that progression gate. One campaign fixture used obsolete side-view entrance coordinates and now uses Deepworks.ENTRY. Test purposes remain intact.

Legacy terrain and routes are retained as archived data, not converted into the new active mine. Synthetic legacy data was tested; no real user's historical save was available. Existing ObjectDB/resource-in-use warnings occur on some shutdowns (recorded in logs); no active-play script error appeared in selected tests. Windows execution, actual-speaker audio, exhaustive fresh campaign completion, stress-scale industry and player acceptance remain unverified.
