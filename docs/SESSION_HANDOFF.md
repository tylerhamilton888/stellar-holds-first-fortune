# Working the Mountain — 0.55.0
Updated 2026-10-19 UTC. Checkpoint `mining-0.55.0`. Pre-edit tag `pre-mining-0.55.0` preserves `reference-0.54.0` (`7d73bf78483982d0a6418990f2206dc9f5b03136`). Verified .54 ZIP/bundle hashes before editing; previous canonical backups remain intact. No remote was changed or pushed.

## Integrated result
Mining remains the same top-down, five-level Deepworks reached from the existing High Trail. Solid stone now takes about four basic pick contacts, with stronger damage stages, angular fracture debris and a short impact hold. Held input repeats; WASD immediately interrupts work and retains 150-unit/s unladen travel. More exposed faces improve leverage. Hammer work becomes effective after 40% fracture; controlled section breaking releases at most one additional exposed, weakened, reachable face beside an existing masonry support.

Stone and basalt yield four units per physical load. Mineral grade yields 3/5/8 units; crystal yields three. All use existing Handworks `kind:"stone"` records with an additive `item` field; old records still resolve to stone/log correctly. The same raw image and mineral markings appear on ground, shoulders, racks, vehicles and the stonebreaker. Exactly one owner retains each record. Miner practice is awarded only for a freed manual face, not pickup/drop loops.

For convenient prospecting, hold Shift+E away from equipment beside a raw load or while carrying one: three 0.7-second field blows deliver its entire original item yield through existing DeepHaul cargo. Progress is stored on the raw record. Stonebreakers process batches from nearby racks in three 0.42-second strokes, accept all mineral loads, and use existing powered-workshop production bonuses. E at a rack or parked raw cart gathers compatible loose loads within 90 units with clear sight. Shift+E collects processed output. Existing bulk wheelbarrows and crew delivery continue to work.

A lamp within 180 units helps careful recovery and clean contacts. Existing Living Works pillars/runes within 160 units strengthen joint fractures; a steel tool or master Miner enables supported section splitting. No support upkeep/cave-ins or new stamina system. Miner 12 unlocks stronger shoulders and joint reading; Miner 40 adds section mastery and four raw loads to cart/wagon capacity. Existing masonry/forestry shoulder progression is retained. The V ledger tracks the existing dipping formations across worked depths, without regenerating terrain. Introductory instructions, smelting/survey/tool lessons and research descriptions explain the revised loop.

Bench approach validates the full player footprint and tries the other side beside walls. Bench focus remains through work and immediate collection, then releases on movement. Exact stair landings take interaction priority over loose chunks.

## Persistence and recovery
Before an older save can autosave, `state.gd` makes a unique byte-exact `.pre-mining-55-*.bak`; failure aborts loading. `hauling.mining_revision=55` is additive. Terrain, partial damage, links, discoveries, inventories, charter, NPCs, quests, equipment, existing cargo and automation remain. Use the preserved backup when returning to an older executable, which cannot interpret new mineral metadata safely.

The standalone Windows ZIP is separate EXE/PCK, using the unchanged official 4.4.1 runtime. New source/Git updates are incremental after .54; keep the .51 full baseline and .52/.53/.53.1/.54 chain. Recovery.txt includes exact commit/tree/hashes and restore commands.

## Evidence and next entry points
Read `testing/mining-0.55.0.md` and `PLAYTEST_GUIDE.md`. Final checks: 38 focused mining, 32 material/Pinewood, 45 geology/crew/model, 17 natural-route, 14 exported-pack; 146 total. The natural route opened 51 faces, established logistics, followed a formation over two depths and persisted 47 remaining loads. Native visuals were inspected. Component and final-ZIP scans reported zero detections using October 11 definitions; Windows Defender and native Windows/audio acceptance remain unverified.

`deepworks.gd`: resistance, exposure, grade yields and additive prospect notes. `deepworks_play.gd`: planted contacts, worksite advantages, bounded section breaking and mine presentation. `handworks.gd`: raw item identity, field/bench processing, batch loading, mastery capacity and safe stance/focus. `folk.gd`: one shared raw material drawing at all ownership stages. Keep .54 reference art and all resource paths intact. Do not rerun historical two-contact assertions unchanged; current test entry points end in `55.gd`.

The human 10–15 minute satisfaction goal still needs the player's judgement. Do not expand this refinement into a crafting/world rewrite. Raw-workstation NPC operation, broader logistics jobs, remaining interior art and the larger connected world remain backlog; existing automated miners and industrial production are preserved.
