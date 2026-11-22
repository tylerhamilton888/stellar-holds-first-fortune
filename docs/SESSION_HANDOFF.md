# Stonebridge · 0.125.0

The integrated source starts from the room stages and Cottage Grounds changes. It carries the subsequent Stonebridge campaign and settlement work into the normal game entry point. No external Cottage Grounds pack is required. Painted textures read by the custom terrain and pose renderers are included in the Windows export.

Menu work lives in scripts/player_book.gd, menu_view.gd, item_art.gd and equipment93.gd. Stable item and hotbar identifiers are shared with the existing game. The new atlas is assets/stonebridge_ui/goods.webp. The first sixteen painted goods have distinct atlas cells.

Use Godot 4.4.1. The menu92, menu_quality100 and pack_catalogue tests cover navigation, inspection, filters, recipe locks and save integrity. For the campaign use tests/contest_opening.gd from a fresh profile and run tests/contest_resume.gd against its saved midpoint. See the release workflow for Windows packaging and native verification.

[PR #194](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/194) is merged and [Windows 0.125.0](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.125.0) is published. The equipment book fits upgraded weapon names. Forge components fit on one page. The lodge guide clears the HUD, and both generated timber-yard layouts leave space to approach Torvik. The normal New Game opening and a fresh-process reload of Skarrin’s saved dialogue beat passed. The release used source `84d2dfadb623`. See CURRENT_STATUS.md for the verified download, source and package evidence. BACKLOG.md lists the next player playtest.

The 0.125.1 playtest pass separates the Pinewood and Ledger approaches, corrects the player stride and northern treeline, and connects the Ledger to the player book. Check both walking directions at the south fork, the empty-handed and equipped contacts, and the delivery controls from town and from a distance.
