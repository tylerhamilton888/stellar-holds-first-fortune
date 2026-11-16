# Pre-playtest visibility review

Scope: room framing, foreground props, workshop scale and reachable services. No save migration, art replacement, construction cost or room-size changes.

## Findings and changes

- The bunkhouse and starter quarters used a fixed camera at y=160. North-wall art began under the HUD, and the exit overlapped the hotbar. They now use the shared room camera, following the player north and south.
- Shared room framing now permits a northern y=65 camera position. Approaching the north wall reveals the wall, doors and tall fixtures below the top HUD band. Larger rooms still scroll; the throne retains its bespoke framing.
- Tall furnishings previously remained opaque over a player walking behind them. Foreground opacity now uses the furnishing silhouette, physical height above its base, player body bounds and draw order. Low furniture and non-overlapping props stay opaque. Footprints never change.
- New communal forge: 820 x 520 floor; starter workshop: 640 x 385; old grand forge: 1020 x 650. Keep these distinct sizes. Shrinking old rooms would displace existing furnishings and stocked chests.

## Verification

Pending focused native review: living_forges148, lodge100, opening146 and forge147. Existing cases check real station access, material transactions and saved storage. Added regression coverage checks north-wall visibility, pillar overlap, preserved collision and opaque non-overlapping furniture.

Full source and exact-package gates remain required before release. Human Windows input, audio, performance and first-hours pacing remain playtest items.
