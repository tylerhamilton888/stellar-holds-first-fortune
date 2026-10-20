# Dwarven Labor 0.51.0 verification

Godot 4.4.1, Linux native OpenGL/llvmpipe under Xvfb; separate test user directories, no live player save used. Source baseline: `pre-animation-0.51.0` / `world-0.50.0` (728e05d). Original full-history bundle verified before edits.

| Run | Result | What it establishes |
|---|---|---|
| labor51.gd | 25 passed | Tool costs, placed beds, plant/water/growth/harvest, actual reload, fishing/reeling/cancel, reward once, provisions/trade, earned wagon and mixed two-shoulder cargo |
| regression_hands51.gd | 32 passed | Raw extraction and one-owner transfers, craftable benches/racks/pallet/cart, real partial-job reload, processing output, house use, carrying mastery, Pinewood felling |
| collision_world51.gd | 119 passed | Authored doors, streets, furniture, bridge rails/water, stairs/lift and reciprocal Z landings |
| input_world51.gd | 35 passed | Actual title/new game, walking/NPC quests, interiors, mine entry, excavation, stairs, return, craft/sell, home/chest and reload/migration |
| test_deepworks41.gd | 45 passed | Persistent layers, deterministic geology, real connections, discoveries, resource economy, physical crew/automaton routes and save |
| test_industry30.gd | 76 passed | Existing industrial production/progression regression |
| contacts51.gd | 5 passed | Actual held contacts damage four cardinal rock faces and one tree; native snapshots also show breaker/saw contact |
| migration_labor51.gd | 8 passed | Exact pre-upgrade save bytes backed up, inventory/technology/homes/chests/crew/cargo preserved, new positions reload |
| final_review51.gd | 4 passed | Set-down owner/visual lifetime, re-lifting and 24-load wagon overflow conservation; final menu captures |

Total: 349 assertions. Head/pose review scripts additionally render the ten customized sculpts, four directions, action phases, sipping, smithing and seated Lord. Visual evidence and per-run logs are in `animation-0.51.0/`. Known ObjectDB/resource messages occur on test teardown; they are distinct from script/runtime failures. No unexpected script errors remain in passing runs.

Corrections from review: connected strata replace boulder faces; south/side working reach closes through actual movement; timber damage occurs at contact; stations approach a working stance; stale house hammer no longer overrides saw work; tool foreground draws over the actual work surface; no rotating arm strips; tools/loads have drawn grips; idle no longer freezes a running stride; shared rock/log props replace mismatched stock/workshop material; exact profile heads retained; dark female curls no longer become transparent holes; table/bar scale reduced; duplicate fishing float removed; full wagon loads pack in three low tiers inside the bed rather than stacking into a tower. The first harvest fixture was outside interaction range after grid snapping; its position now derives from the actual bed. Cart parking moves its anchor off the player's feet so nearby loose pickup keeps priority.

Scope limits: four-frame gait silhouettes and additional directional work/haul poses remain refinement work. Historical art outside this pass is not declared uniformly final. General handcarts/wagons remain zone/depth-local; mine wheelbarrows keep existing stair behavior. No new raw-station/farm worker automation, seasons or broad crafting rewrite. Native checks do not establish Windows launcher execution or subjective audio/feel.

Release integrity: the exported PCK is booted separately from source. Versioned ZIPs receive CRC checks; the Git bundle is verified and restored into an isolated bare checkout, with the release commit/tree compared to source. Exact hashes and reassembly commands are recorded in the release's Recovery.txt.
