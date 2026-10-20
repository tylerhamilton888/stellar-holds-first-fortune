# World 0.50.0 verification

Godot 4.4.1, native Linux/OpenGL software rendering, isolated test saves. No live player saves used.

| Suite | Checks | Evidence |
|---|---:|---|
| input_world50.gd | 35 | world50.log, journey/ |
| collision_world50.gd | 119 | collision50.log, collision/ |
| migration_world50.gd | 8 | migration50.log, title.png, citizen-directions.png |
| regression_hands50.gd | 32 | hands50.log, handworks/ |
| test_industry30.gd | 76 | industry50.log |
| test_deepworks41.gd | 45 | deep50.log |
| regression_tavern50.gd | 7 | tavern50.log, tavern/ |

322 total checks. Native visual review includes furniture depth ordering, seated Lord, citizens, separate facades, actual door approaches, stair landings and bridge-deck/rail overlays. The journey uses real input and existing dialogue/button callbacks for progression, mining, forestry, trading, crafting and saves. Collision testing uses flood-fill reachability plus actual movement-controller traversal; it checks side-wall door rejection and interior south exits. Migration checks byte-exact backups and preservation of inventory, technology, money, storage, homes, workers and cargo.

Corrections made during QA: interior exits must accept approaches from inside; bridge rail ends extend beyond the water strip; gate pillar footprints match their full painted bases; tracking uses the departure ward's available stair; captions no longer overlap the player near tracked doors. Original test fixtures were adjusted for new coordinates and JSON numeric normalization. Final tests have no gameplay script errors. Known ObjectDB/resource warnings at engine shutdown remain.

Exported PCK boot and archive/bundle verification are recorded with release logs. Windows executable execution and subjective audio are not verified here. Ambient citizens are not new production workers; dedicated sparring retains the existing combat mode.

Animation follow-up: directional sprites now use 40 measured source bounds instead of equal atlas cells, preventing clipped hair/feet and neighboring-row fragments. Anatomical hair-color regions include warm shadow pigments while protecting skin, leather and brass. The drinking forearm overlay is narrower to prevent a tunic wedge crossing the beard. Native review covers all ten sculpts in four directions, multiple walking phases, smithing phases, tavern lift/sip/lower and the seated Lord. This refines the existing procedural rig; it is not a replacement with fully hand-drawn action frames.

