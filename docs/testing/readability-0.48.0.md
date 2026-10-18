# 0.48.0 — integrated readability verification
Godot 4.4.1, native X11 display with software OpenGL, 1280×720 window / 960×540 game canvas; isolated test save directories.

- Dedicated native input run: **20 checks passed**. real game launch, four tool keys, all five supply keys, locked slagcaster, assigning ore, menu input exclusion, mouse slot selection, save/reload, held mining, field collection and supply-mode work exclusion. Directional, axe, mine anticipation/contact/recovery, forge and Pack captures accompany the log.
- Existing native surface regression: 35 checks passed (doors, quests, forge, Lord, stairs/lift, Pinewood, mining, trading, crafting, home/chest ownership and migration).
- Deepworks: 45 passed, including worker/automaton Z routes and saved assignments.
- Masonry: 25 passed, including blocks, stockpile, production, quest and worker cargo persistence.
- Campaign: 43 passed.
- Visual inspection prompted adaptive toolbar placement and extra clearance above the mine depth line. Consistent original directional bodies replace old side/work swaps. Contact frames and readable menu assignment controls were inspected.

References consulted: official Stardew Valley media/inventory and Graveyard Keeper official media site. These informed readable selection, compact equipment presentation and work anticipation/contact; no reference-game assets were imported.

Recovery: pre-change 0.47.0 bundle verified before edits; new complete-history bundle restored into a fresh bare repository and fsck checked. Final source/Windows/docs archives CRC checked; exported game pack booted with native display. Windows .exe execution and audio remain human acceptance checks. Shutdown ObjectDB/resource warnings remain; no gameplay script errors accepted.
