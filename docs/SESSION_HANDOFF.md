# Stonebridge · 0.125.0

The integrated source starts from the room stages and Cottage Grounds changes. It carries the subsequent Stonebridge campaign and settlement work into the normal game entry point. No external Cottage Grounds pack is required. Painted textures read by the custom terrain and pose renderers are included in the Windows export.

Menu work lives in scripts/player_book.gd, menu_view.gd, item_art.gd and equipment93.gd. Stable item and hotbar identifiers are shared with the existing game. The new atlas is assets/stonebridge_ui/goods.webp. The first sixteen painted goods have distinct atlas cells.

Use Godot 4.4.1. The menu92, menu_quality100 and pack_catalogue tests cover navigation, inspection, filters, recipe locks and save integrity. For the campaign use tests/contest_opening.gd from a fresh profile and run tests/contest_resume.gd against its saved midpoint. See the release workflow for Windows packaging and native verification.

PR #194 recovery reconciles the equipment catalogue with the book viewport and tests the selected forge, home and paid-work leads through the journal. Named idle tests check the twelve-frame directional rows. Lodge arrival, the cottage doorway, the compact communal forge and lateral mineworks have targeted checks. The release/0.125.0 branch runs source and exported-package validation before publication.
