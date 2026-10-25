# Developer Testing Grounds

Temporary player-facing test access is controlled by HoldBuild.DEV_TESTING. Set it false to hide the title/pause/F9 entry points. HoldDevTesting owns the presets and controls; normal combat, placement, work and harvesting implementations are reused.

Title screen > Dev Testing. Inside a test session, pause > Dev Testing / F9 reopens controls. Testing is a separate session; its launcher refuses to replace active normal gameplay. Starting a preset creates a fresh disposable world and uses user://dev_testing85.json. Slot numbers 1–3 are never repurposed. The save carries a developer marker; the normal loader rejects developer-marked data. Returning to title and all normal starts restore normal routing. Global audio preferences remain shared.

Presets:
- Combat: an excavated arena, all weapons/armor and ammunition. Spawn a goblin, beetle, orc, troll or mixed pair; inspect hitboxes; heal/restock. Damage and defense use normal balance. Combat encounters restart on test reload.
- Construction: an owned claim/cottage, research and supplies. Normal house/furniture tools, costs, footprints and collision apply. Construction persists in the dedicated test save.
- Mining/workstations: exposed mineral wall, stonebreaker, sawbench, two racks, handcart and raw mineral/timber loads. Normal processing and material ownership apply.
- Farming/fishing/cooking: four garden stages, field kit, seeds and ingredients. Shortcuts to the real riverbank and home kitchen; optionally ripen planted beds.

Reset replaces only the current test preset. Starting a different preset replaces the prior test save; Resume last test restores it. F9 and a persistent DEV TEST badge expose the controls. Test menus pause the world. This is not a normal-game cheat menu.

Acceptance: dev-preview runs developer access/save isolation plus combat and menu regressions. The developer fixture is also included in full source and exact-export verification. It snapshots all three normal saves and proves their bytes survive every preset, playing, reset and test save/reload. It also verifies actual incoming damage, species selection, foundation/stair/furniture placement, collisions, persisted construction, stockpile transfer, crop stages, river access and cooking. Native title/menu, arena, building, workshop and garden captures require visual review. Local native dev-preview passed: developer testing 40 assertions, combat 31, menus 9; zero engine errors. Title, launcher, combat controls, arena, construction, workshops and gardens were visually reviewed. Full source run 40229901070 passed all 29 gameplay cases and people-preview. Exact-export run 40229901891 passed all 19 cases (1,249 assertions), including the 40 developer-testing assertions, with no engine errors. Exported launcher and combat controls were visually reviewed. Release 0.75.0 is published; PR #41 is merged. CURRENT_STATUS.md records source, download, checksum and recovery details.
