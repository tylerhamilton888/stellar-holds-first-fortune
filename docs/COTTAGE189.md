# Cottage189 — Under your own roof

Owner direction: bring the starter cottage up to the surrounding buildings' standard while retaining coherent modular construction; replace proximity roof cutaways with deliberate entry into the house.

## Implementation

HoldHouseView189 derives enclosed rooms from the saved claim construction. Doors join internal rooms or become exterior portals. E at an exterior door passes through with the existing transition, a clear-landing check and repeat guard. Hitched carts must be parked. Interior doors retain ordinary controls. Loading a save resumes the view implied by the actual player position and floor.

The interior uses the same floor plan, objects, coordinates, paid finishes and stairs. Workers and freight retain their existing routing and ownership; only the player's exterior threshold collision and presentation change. Layout edits invalidate the derived room cache. Unenclosed floor regions remain outdoors.

HoldHouseArt189 composes the existing Hearthstone/Forgehold/Oathhall atlas at consistent material scale. Continuous pitched slate slopes, a raised ridge, masonry gable and restrained timber framing replace per-tile roof borders and repeated posts. Built upper walls render above the lower structure; bare supporting roof decks do not become fictitious storeys. Inside, foreground walls are lowered and other buildings/grounds are excluded. No new stock or furnishings are granted.

## Review and evidence

The first broad PR gate caught the older frontier test expecting a walk-through exterior threshold. Its regression now verifies collision plus real E exit/re-entry; the new candidate must repeat full source/package acceptance.

Pinned Godot 4.4.1 native runs, isolated saves, software OpenGL. Local evidence: test-results/cottage189 (not committed). Reviewed starter exterior/interior, expanded interior, upper interior and two-storey exterior beside the player. The first drafts exposed repeated side-wall posts and incomplete corner grouping; both were corrected before delivery.

Cottage acceptance covers explicit E entry/exit, blocked threshold walking, transition repeat prevention, blocked landing, save/load indoors, unchanged construction/belongings, all four corners, expansion, connected partitions and enclosed upper floors. Existing opening, upper construction, room blueprint, cellar, worker and freight cases check integration. The 42 Python tooling checks passed. Full source and exact-package gates remain mandatory for publication; CURRENT_STATUS.md records the verified delivery.

Limits: normal-speed Windows input/audio/performance and aesthetic preference remain playtest checks. This is a presentation of existing editable construction, not a new furnishing/customization feature or a second copied house.
