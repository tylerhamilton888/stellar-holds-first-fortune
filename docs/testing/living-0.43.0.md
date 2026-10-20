# Living Works 0.43.0 verification
Godot 4.4.1 Linux, 2026-10-18. Native GL compatibility renderer under Xvfb, 1280×720 window. Tests instantiate the actual main scene/controller; construction and mining use the integrated existing game.

| Suite | Result | What it establishes |
|---|---|---|
| test_living43.gd | 37 / 0 failed | Excavate chamber and deliver real stone/ore; geometry, costs, rejection/idempotence, furniture collision/refund, tech gating, quality, physical Brann routing, crafting bonus, rest, one-time opportunity, save/load and 0.42-shaped additive compatibility; hammer/selective mining and occupied lower landing |
| input_living43.gd | 11 / 0 failed | Actual O/button/mouse designation, timed hammer furniture and held floor work, forge interaction, crew arrival, opportunity and save/load |
| input_deepworks41.gd | 15 / 0 failed | Existing native movement/mining/stair/haulage controls |
| test_deepworks41.gd | 45 / 0 failed | Integrated layered mining, travel, resources, geological features, routes, migration and persistence |
| test_haul42.gd | 34 / 0 failed | Material ownership/conservation, cart/pile/depth persistence and economy integration |
| test_forestry40.gd | 53 / 0 failed | Independent Pinewood trees, timber, controls and persistence |
| test_campaign.gd | 43 / 0 failed | Existing progression, crafting, trading and settlement behavior |
| tools/smoke.py | 8 stages pass | Boot, continuity, slots, granular, controller, opening, outpost, industry |

Native construction fixture clears a chamber and supplies a construction budget to isolate UI. The separate model/integration suite excavates through actual mining, collects cargo and delivers it before building; construction budgets are explicit fixtures, not shipped cheats. Existing automation routes and stair navigation are reused, including furniture collision.

Images in `living-0.43.0/` show a working chamber, room quality board, ancestral finish, material ledger and furnished bedroom. Original project art and new authored canvas shapes only. Visual review found and fixed a misleading workbench hint in bedrooms and replaced the workshop miner's pick animation with a hammer. Lantern positions contribute to terrain and floor illumination. Construction cancellation clears pending impact, and parked carts block furniture placement.

The release PCK is exported and booted with the native Linux engine. The bundled Windows engine/launcher are not executed on this host. Final bundle restore/fsck, package hashes and archive integrity are in the release recovery verification JSON. Known ObjectDB/resource-in-use warnings during teardown are not claimed resolved. Audio event routing is tested; speaker listening and human gameplay/balance acceptance remain open.
