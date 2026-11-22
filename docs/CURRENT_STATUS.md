# Stonebridge campaign and menus · 0.125.0

[Windows release 0.125.0](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.125.0) is public. Extract the complete Windows ZIP and run FirstFortune.exe. [PR #194](https://github.com/tylerhamilton888/stellar-holds-first-fortune/pull/194) merged the campaign and menu update into master.

[Release validation](https://github.com/tylerhamilton888/stellar-holds-first-fortune/actions/runs/44972906930) passed all four source groups and all four Windows-package groups. The exported game passed 79 cases and 14,962 assertions. The published ZIP is 998,253,682 bytes. Its SHA-256 matches the published release summary and build manifest.

Source `84d2dfadb6233e75d9c41bcb3c98c699294ddef2`

ZIP SHA-256 `f046433f4da95ec89d7e9240e63a8627c45f228cb82c5c82eb9dcf3de3b11c97`

PCK SHA-256 `4609fb518af1182230370168305b9025fd221482bfa0976e286d57fda24ec0ae`

The normal title screen starts the contest for Thane. The Stonebridge campaign, Old Stonewright’s Rise, the cottage yard, indoor ramps, neighboring workshops, excavation and the deep courts are in the Godot project. Run main.tscn in Godot 4.4.1. The Windows export uses the same entry point. The campaign keeps the Stonebridge Campaign save directory used by the previous campaign launcher.

The pack has carried and catalogue views, category and name filters, selected-item uses, and individually painted supplies. Known recipes list their names and show ingredient shortages. See [pack](stonebridge-menus/pack.jpg), [pickhead](stonebridge-menus/pickhead.jpg) and [recipes](stonebridge-menus/recipes.jpg).

See SESSION_HANDOFF.md for verification and archive/BEFORE_STONEBRIDGE_MENUS.md for the previous source checkpoint.
