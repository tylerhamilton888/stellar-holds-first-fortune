# Hands of the Dwarf 0.49.0 verification
Native Godot 4.4.1, isolated saves, X11/software OpenGL; 1280×720 window and actual game scenes.

- input_handworks49: 32 checks passed. Player-paid placement of all six facilities, overlap/no-charge, E pickup, Q drop, typed deposit, hold-E reservation and processing, interrupted-job save/reload, nearby output pallet, actual floor construction, cart loading/following/withdrawal, workshop UI, no handling XP, shoulder upgrade persistence, actual Pinewood held felling/log pickup and actual Deepworks raw extraction without duplicate stone.
- Deepworks 45, masonry 25 and campaign 43 passed. Existing workers/automata still use real multi-Z routes and save assignments; old masonry worker production remains functional.
- Native surface regression: 35 passed. It uses a conservation assertion including physical loose stone as well as haulage, matching the new explicit yield ownership.
- input_stock49: 4 passed. Full 12-load racks and 8-load cart, overflow refusal, one-record withdrawal and save/reload. Empty, half-full and full views inspected; heaps tapered to avoid rectangular towers. Raw items retain the same scale on every owner. Processed pallets use 20-unit bundles. Total: 184 checks passed.
- Visual inspection covers shoulder stone, loaded/empty station, stonebreaking, sawing, cart, workshop board and Pinewood log. Replaced baked-in station workpieces and old plain fallen-log drawing with canonical shared material art. Improved worker reach, actual-held hotbar labels and quiet interaction prompts.

Scope is A–C first stage. Full quality/smithing/mastery/geodes/new-station workers are deferred in the backlog. General handcarts do not cross zones/Z; legacy mine wheelbarrows retain their existing stair behavior. No claim that these are all implemented.

Recovery: baseline bundle verified before changes; full-history release bundle restored and fsck checked; final archive CRC and native exported-pack boot required. Windows .exe execution and audible mix remain player checks. Known engine shutdown resource warnings are not counted as gameplay script errors.
