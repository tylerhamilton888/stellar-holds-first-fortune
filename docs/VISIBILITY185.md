# Pre-playtest visibility review

Scope: room framing, foreground props, workshop scale and reachable services. No save migration, art replacement, construction cost or room-size changes.

## Findings and changes

- The bunkhouse and starter quarters used a fixed camera at y=160. North-wall art began under the HUD, and the exit overlapped the hotbar. They now use the shared room camera, following the player north and south.
- Shared room framing now permits a northern y=65 camera position. Approaching the north wall reveals the wall, doors and tall fixtures below the top HUD band. Larger rooms still scroll; the throne retains its bespoke framing.
- Tall furnishings previously remained opaque over a player walking behind them. Foreground opacity now uses the furnishing silhouette, physical height above its base, player body bounds and draw order. Low furniture and non-overlapping props stay opaque. Footprints never change.
- New communal forge: 820 x 520 floor; starter workshop: 640 x 385; old grand forge: 1020 x 650. Keep these distinct sizes. Shrinking old rooms would displace existing furnishings and stocked chests.

## Verification

Focused native review passed: living_forges148 (42 assertions), lodge100 (59), opening146 (66), forge147 (24) and civic (65). The final civic/lodge replay passed all 124 assertions after restoring established rooms' exit framing. The 42 Python tooling tests passed.

Native captures covered the opening cast, northern furnishings, restored and cold forges, starter workshop, legacy forge, pillar cutaway, upstairs quarters, cottage roof cutaway, ward approaches and room exits. Existing tests protect real station access, material transactions and saved storage. Added checks cover Ivar's headroom, north-hearth visibility, pillar overlap, preserved collision and opaque non-overlapping furniture.

The initial following-camera change obscured Ivar; the native lodge assertion caught it. Broader civic validation then caught exits under the hotbar in established rooms. Welcome-specific following offsets and established-room southern framing corrected both issues; the final native replay passed.

PR #185 merged after all required checks. Release run 43922798661 passed all 11 jobs, including 87 source cases and 77 package cases / 14848 assertions. Public 0.123.0 metadata and asset digests match the reviewed source and tested ZIP. See CURRENT_STATUS.md. Human Windows input, audio, performance and first-hours pacing remain playtest items.
