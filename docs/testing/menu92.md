# Menu pass — delivered in 0.82.0

Reference: Stardew Valley's Player Menu (https://stardewvalleywiki.com/Player_Menu) and visual references for its inventory, skill overview and lower-screen portrait dialogue. This adopts navigation and information hierarchy, not artwork or game code. Existing painted Dwarfs, item art, progression and transactions remain authoritative.

## Changes

- Shared parchment, walnut and muted green presentation, with fixed Pack / Gear / Skills / People / Craft / Journal / Map / Calendar / Options tabs. Page Up/Down switches peer tabs; existing shortcuts, Tab focus, Enter activation and Escape back/close remain.
- Compact icon/quantity inventory slots, search, carried/all filter and a selected-item panel with quick-bar pin actions. Existing stack counts and hotbar remain the only owners of supplies.
- Skill overview with progress toward the next actual technique; select a discipline to learn techniques or research with existing prerequisites and costs. Brewing remains explicitly unavailable.
- People directory combines portraits, familiarity, discovered tastes, location and local conversation/track actions. No remote NPC interaction or invented friendship data.
- Lower-screen portrait dialogue with a single ordered response list; quest/service/friendship callbacks remain unchanged.
- Read-only recipe catalogue available anywhere, with real material/research requirements. Manufacturing stays at the existing forge/kitchen interfaces.
- Equipment choices use two-column cards. The shared skin also applies to journals, settings, construction and contextual service screens.

## Validation

Baseline native menu case: 9 assertions passed. Initial candidate: 31 menu assertions passed; screenshots reviewed and density subsequently refined. Final density/layout case: 35 passing assertions. The six existing menu/discipline/people/quest/calendar/energy cases passed 607 assertions before the last spacing and recipe-layout refinements; the full hosted source/export gates subsequently passed on the final combined source. Final inventory, skills, recipe, dialogue, people, gear, calendar, journal and settings captures reviewed. Inventory/character summary and all thirteen skill rows fit without vertical scrolling at the 960×540 game viewport. `tests/menu92.gd` covers real menu shortcuts, tab cycling, inventory search, pinning conservation, technique learning, dialogue locality, viewport bounds and save/reload. It is included in full source and exact-export gates. The existing discipline test explicitly opens its detail view before using Learn, matching the revised interaction.

Native tests use Godot 4.4.1 with isolated saves. This execution environment uses a TCP-loopback Xvfb display because UNIX display sockets are unavailable; the rendering backend remains native OpenGL/llvmpipe. No acceptance gate is skipped.

No drag-and-drop inventory, controller remapping, equipment instances or new crafting mechanics are claimed. Windows hardware, audio and subjective readability remain hands-on review.

## Final local package review

A clean export from the identical runtime tree passed all 35 menu checks from an empty working directory and isolated save folder. Its inventory, skills, conversation and crafting captures are byte-identical to the reviewed source captures. The package inventory contains 3,339 entries and excludes developer tests, documentation and test output. Five additional contextual layout checks passed for forge, market, research, architecture and energy; their native captures, settings controls and save-slot screen were reviewed. See menu92/local-export.json for source-tree and image hashes. The hosted release remains the delivery authority.

## Published delivery

PR #55 merged as 6a42eec3f151a46c04a5a9b1e9753829007e87a4, with the identical runtime tree to source/tag 93048fecc7ccc8209ab4b0bc0f53a5bce464a19c. Source run 40727028182 passed all 35 gameplay cases plus people-preview; release run 40727027814 passed all 25 exact-export cases / 1,850 assertions. Release: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.82.0 .

Downloaded build report and exported evidence pass their published SHA256 checks. ZIP metadata matches the clean build report; the full ZIP was not independently redownloaded. All four hosted exported menu images match the reviewed source images byte-for-byte. See menu92/delivery.json for hashes and evidence. Windows hardware/audio remain hands-on checks.
