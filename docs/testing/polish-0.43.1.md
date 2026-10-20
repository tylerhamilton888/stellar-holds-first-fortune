# Visual/menu polish 0.43.1
Godot 4.4.1, Linux native GL compatibility display, 1280×720 with 960×540 logical viewport.

- `input_polish431.gd`: 14 passing checks; actual room designation, tab selection, furniture/finish hammer impact, workbench crafting, recruited worker arrival, opportunity, save/reload, and compact panel bounds for Furnish/Finishes/Folk.
- `test_living43.gd`: 37 passing checks; unchanged construction costs, quality, connectivity, saves/migration and mining methods.
- `tools/smoke.py`: eight existing stages pass.
- Native inspection: title, working workshop, bedroom, Rooms/Furnish/Finishes/Folk, crafting, inventory, research, haulage, ledger, settlement and Pinewood. Furnish catalog shows all nine entries without scrolling; navigation and close controls remain fixed outside content scroll. Research rows preserve actual unlock/cost logic.
- New original canvas details: bed stitching, table cup/joinery, staggered stone joints, varied timber grain and warm lantern halos. No imported third-party art.
- Release PCK exported and booted natively. Full recovery bundle restored and fsck checked; verification JSON accompanies release documentation. Existing 0.43.0 backups retained.

This is a presentation patch, not a new gameplay milestone. Extensive 0.43.0 gameplay regression counts are documented separately, not claimed rerun in this patch. Known engine teardown ObjectDB/resource warnings remain. Windows execution, speaker listening and human aesthetic/game-feel acceptance remain unverified.
