# Mineworks districts — Windows 0.102.0

The original five Deepworks levels remain unchanged. A marked passage near each site's entrance leads to three lateral mineworks, each an independent 80 × 64 map with a small arrival bay and mostly unexcavated rock. Existing terrain, stairs, rooms, furnishings, raw loads and cargo keep their owners and coordinates.

| Worksite | Access | Character |
| --- | --- | --- |
| Stonewright Delve | Enter the passage beside the original mine landing | Stone, coal and copper; an old eastern heading and broad untouched rock for districts |
| Blackvein Reach | Research Tempered steel and physically mine the basalt seal at the eastern heading | Hard basalt and iron; a fault divides the map |
| Farbank Works | Research Stoneworking and rebuild Blackvein's bridge with 12 timber, 4 iron and 8 stone; walk across to the adit | Broad stone reserves and crystal seams for a later worksite |

Adits are local E interactions, with permanent return links. Locked connections are excluded from map and crew routing. The fault is impassable across its entire north–south extent until the bridge is restored. Repair checks locality, research and supplies again when the button is pressed, spends once, and changes real collision. Lateral annexes cannot be reached by carving vertical stairs from the original deepest level. Personal cargo and attached carts retain their existing records when crossing.

## Player districts

O → Districts names and reserves a rectangle from 6 × 6 to 30 × 30 tiles. Select Craft, Store or Hearth, click the first corner, walk closer to the opposite corner and click it. Purposes organize the player's plan; real rooms, fixtures and staffing provide functionality. Plans may include unexcavated rock and do not clear it or award resources. Plans cannot overlap, extend beyond workable terrain, or occupy the fault and freight landings. Up to 24 plans belong to one site.

District summaries derive excavation percentage, enclosed room count and worksite equipment count from actual saved terrain and objects. Their boundaries appear on the worksite map and while planning. The current district name appears in the mine HUD. Removing a plan preserves every room, furnishing, stored load and excavated tile.

Use existing 4 × 4 to 9 × 9 rooms for workshops and bedrooms, O for furnishings/finishes, and Shift+B for stockpiles, breakers and carts. The room limit is sixteen per worksite. Hired workers use physical open connections; unavailable routes grant no staffed benefit. Existing recruitment rules still determine which site's crew the player controls. Painted household furniture is reused at the mine furniture's one-cell scale.

## Ownership and migration

`HoldMineworks143` owns additive `deepworks[site].mineworks143` metadata: entrance coordinate, opened seal/bridge, visited worksites, district definitions and next ID. Annex terrain is appended lazily as layer indexes 5–7 on the first passage entry; existing layer indexes 0–4 are never reseeded. `Deepworks.DEPTHS` remains five for geological generation and vertical stairs. `Deepworks.NAMES` also names the three lateral maps.

Existing depth-scoped LivingWorks, Handworks, DeepHaul, combat and save owners store all actual player work. The shared `Deepworks.connections` graph enumerates stairs and unlocked adits for map/crew travel. Old saves choose a vacant reachable entrance position clear of equipment without moving player property. Nearby work targets keep their E interaction when closer; standing directly on the adit gives travel priority, even beside a parked cart. New construction keeps landings clear.

## Acceptance

The focused `mineworks143` case covers original-layer preservation, lazy map creation, real E entry, tool and construction gates, stale/remote callbacks, real bridge movement, cart ownership, district/room construction, worker travel, removal and JSON save/reload. It is registered in full source validation and the exact-package catalogue. Mining, navigation94 and workplace98 provide affected regressions; firstshift, firstvisit99, lodge100 and polish135 protect the established work, wage and room-handoff interactions. Review native bridge/room/board views and the optional perspective view; human pacing and layout enjoyment remain playtest questions.

[Windows 0.102.0 is published](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.102.0) after all 75 native and 66 exported scenarios passed. This feature does not add a new campaign requirement or expand the Thane storyline.
