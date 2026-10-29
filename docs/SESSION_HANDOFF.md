# Old cutters’ bay — playable preview in verification

An abandoned workplace now connects discovery, physical repair, warmth, actual stock processing and a persistent resident. New hold mines only; existing excavations are preserved. Use Dev Testing → The old cutters bay. See testing/workplace98.md for scope and verification.

# Expedition loop preview — in verification

Implemented Ivar’s fresh-ore expedition, handcart-material reward and crystal follow-up, plus a separate First expedition test save. See testing/expedition97.md. Pacing remains a playtest question; no new authored dungeon or combat-energy changes.

# 0.85.1 — Workbench clearance: published and merged

Published https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.85.1. Release source f4dada8c4c09c6c723fd1b719a7c5e0090347ffb; PR #63 merged as dbd3ee4a7fe76f878dfc8791154c2a13ca60ab55 with identical tree 9381465166b9efbfbbd0b2de39d52c0c9759301b. Source run 40896041513 passed all 39 gameplay cases plus people-preview. Release run 40896319756 passed all 29 exact-export cases / 1,976 assertions and published successfully. Local focused checks passed 144 assertions; local exported bench96 passed six. See testing/bench96.md.

The exploration test bench now has room for its working stance. New bench placement requires working clearance; an obstructed existing bench explains the blockage and preserves its unfinished input. Hold E to work. Existing 0.85.0 exploration test saves need F9 reset or the wall mined clear. Normal fortunes and energy-free combat are unchanged.

# 0.85.0 — A Dwarf’s Eye View: published and merged

Published https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.85.0. Runtime/release/tag source 76d0c5195bf95d74dbb8c0fed54b52213d490190; PR #61 merge 09dda3c57f6fc0d2a69f0c2e1e1e3d4e07dbaff7 has the same runtime tree 7e20f238fea428591c3a81da60a151b94394ff82. Source run 40800423957 passed all 38 gameplay cases plus people-preview. Release run 40800559860 passed all 28 exact-export cases / 1,970 assertions. Local focused checks passed 197 assertions; final mouse-look passed 46; the local final exported view/navigation checks passed 77.

F6 chooses overhead or mine exploration. Mouse motion now rotates/tilts the camera continuously; WASD and Space dodge follow the camera, the reticle aims mining/combat and the wheel zooms. Close zoom eases over the shoulder. Billboard roots remain anchored as pitch changes, and the dwarf stays readable at nearby rock faces. RMB remains guard/parry. Combat still costs no work energy.

Hold Alt for the cursor. Menus, Z depth planning, surveying, placement, focus loss and mine exit release capture. In mouse-look, held UI clicks cannot become attacks on returning to play. F7 opens paused Camera & controls: Mouse look / Free cursor, sensitivity, invert vertical look and reset. Preferences stay in user://view_settings94.cfg, separate from fortunes. The original cursor-and-brackets option remains available; towns/interiors retain their existing view.

Try Title > Dev Testing > Mine views & depth routes, then F6. Read testing/mouselook95.md and testing/mouselook95/delivery.json. Native and exact-export orbit, close angles, camera options, reticle mining/combat and original props were reviewed. All seven final local native/export mouse-look captures were byte-identical. Hosted export matches all seven final native mouse-look captures; the evidence report records each hash.

Downloaded build report and verification archive match their GitHub SHA256 digests. Clean report, source and tag agree. Uploaded ZIP size 767188145 and SHA256 a399a27c679dfa5e73971720ed53844d4ef82bfd34b2808e1accb62904646bc6 match the report; the full ZIP was not independently redownloaded. Extract into a fresh folder. Windows hardware/audio and subjective mouse comfort remain owner playtests. This remains a single-floor mine presentation sharing the existing simulation.

Continue from master. Runtime is preserved on exploration/mouselook95, release/0.85.0 and recovery/mouselook95-final, plus verified mouselook95-final-checkpoint.bundle requiring d31a4dd8970957c38bdeba574b00ce6dd6c5e985. Earlier backups/releases remain intact. Next: owner feedback on mouse sensitivity, zoom/pitch, character visibility and targeting before expanding this presentation to towns/interiors.

# 0.84.0 — Depth & Perspective: published and merged

Published https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.84.0. Runtime/release/tag source b579fdea477b9779dbe23a1104d97c8b4d0fefdc; PR #59 merge e365b67d7eebbb55bcdd31dab38ad543af8b360a has the same tree 71fed7cc923ea5e435ddbee1d47513574e04383e. Source run 40772786202 passed all 37 gameplay cases plus people-preview. Release run 40772781053 passed all 27 exact-export cases / 1,924 assertions. Local regressions passed 197 assertions; the final highlight adjustment passed 31 navigation assertions and visual review. The earlier local export also passed 31 navigation assertions.

F6 switches mines between traditional overhead and a perspective camera using the original painted Folk and actual saved tunnels. Brackets turn the camera; movement and dodge follow it. Mining and combat use projected mouse aiming. The view choice is stored separately from fortunes. Precise construction temporarily uses overhead and restores the preferred view afterward. Combat remains usable at zero work energy.

Z opens a paused depth map. Browse D1–D5 or Page Up/Down, optionally show adjacent explored-floor ghosts, and click known ground for a gold route through real stair links. Hitched carts cannot route down ladders. Return to dwarf changes only the browsed floor. Routes guide manual movement; E/Shift+E still travel at actual stairs. No auto-walking, teleport or map-based reveal is added.

Try Title > Dev Testing > Mine views & depth routes: two connected floors, a bench, raw ore and a marked route in the separate test save. F9 supplies reset/reload, map/view controls and an optional goblin. Read testing/navigation94.md and testing/navigation94/delivery.json. Reviewed source and exported map, perspective, props, mining selection, survey and combat warnings. Byte-identical source/export captures: depth-map.png, exploration-preset.png, route-map.png. Other captures vary and are not claimed identical.

Downloaded build report and verification evidence match GitHub SHA256 digests. Clean report, source and tag agree. Uploaded ZIP size 767179080 and SHA256 976bddc0feb78115e6a8b36373f9a945e747d52da86556434b58b7ebb7aa77d5 match the report; the full ZIP was not independently redownloaded. Extract into a fresh folder. The prototype covers mines, one physical floor at a time, with quarter-turn cameras. Towns/interiors and construction finish detail retain their overhead workflows. Local timing remained steady in the test mine; Windows device performance/audio and subjective camera comfort remain owner playtests.

Continue from master. Runtime is preserved on exploration/depth94, release/0.84.0 and recovery/navigation94-final, with verified navigation94-final-checkpoint.bundle requiring f9f2a8c2a57b0d83c81053cdd39c59cc6b92612a. Earlier navigation94-hosted and all prior backups remain intact. Next: owner feedback on camera height, wall obstruction, controls and route readability before expanding perspective rendering to towns/interiors or free orbit.

# 0.83.0 — Steel in Your Hands: published and merged

Published https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.83.0 . Runtime/release source 621b54bbebae0b05a95ab6ca3a0a8ca870f37a37; PR #57 merge 50422c0001528b69abab33837c026b3f2f3496b0 has identical tree ed01948e715d742b9fb777d5168cefe421f4cd8f. Source run 40760152166 passed all 36 gameplay cases plus people-preview. Release run 40760151380 passed all 26 exact-export cases / 1,893 assertions. Local focused source checks passed 146 assertions; the local exported equipment case passed 43.

B opens Weapons / Armor / Forge gear. Each piece has a stable saved identity, and comparisons show differences from equipped gear. Standard equipment keeps its original stats; Precision forging plus extra materials unlocks tempered weapons (+6 damage) and armor (+8 protection points). Commissioning another piece keeps the previous one. Old ownership migrates without losing items or strength, with an exact pre-equipment93 save backup. Existing art and combat roles are preserved.

Combat never spends work energy. Attacks, guard, parry, dodge, shove and movement remain usable at zero; guns still require ammunition. Drawn weapons suspend background hauling/handwork energy drain. There is no energy-based collapse or inability to defend yourself.

HoldEquipment93 owns combat.gear93 normalization, IDs, effective stats and forge transactions. Both combat controllers use effective damage/protection. Purchases recheck locality, research and payment at activation. Read testing/equipment93.md and testing/equipment93/delivery.json. Equipment, all five forge recipes and energy UI were reviewed; hosted exported weapon/armor/forge menu pixels match the reviewed source. Whole captures differ only in background forge animation and are not claimed identical.

Downloaded build report and verification evidence match published SHA256 digests. Clean build, tag and source agree. Uploaded ZIP size 767154215 and SHA256 b043fa352778111a2ebe4b56a3fd01f6be0cc92b716a67c9df11e2bf6016a04b match the report; the full ZIP was not independently redownloaded. Extract into a fresh folder. Windows hardware/audio and subjective balance remain hands-on playtest checks.

Continue from master. Runtime is preserved on equipment/forge93, recovery/equipment93-hosted and release/0.83.0, plus verified equipment93-hosted.bundle; prerequisite ce6d79f9ad22a61a6c10489aeeec696d256afa5f remains in master history. Keep earlier recovery branches, bundles and releases. Next: owner equipment/forge playtest feedback, then salvage/study, persistent schematics and the signature expedition with peaceful acquisition alternatives. No durability or stamina rewrite is introduced.

# 0.82.0 — The Hold’s Handbook: published and merged

Published https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.82.0 . Runtime/release source 93048fecc7ccc8209ab4b0bc0f53a5bce464a19c; PR #55 merge 6a42eec3f151a46c04a5a9b1e9753829007e87a4 has identical tree 9911e8cf70ac8dabf1210177618563a1cf5c3375. Source run 40727028182 passed all 35 gameplay cases plus people-preview. Release run 40727027814 passed all 25 exact-export cases / 1,850 assertions. Final local source and clean export each passed 35 menu assertions; five additional contextual layout checks passed.

This pass adds shared parchment tabs, compact pack and recipe grids, a thirteen-skill overview with technique details, combined people rows, lower portrait dialogue and equipment cards. I opens Pack; Page Up/Down cycles tabs. Existing art, transactions, locality and saves remain authoritative. Recipe browsing does not manufacture remotely. Inventory and all thirteen skills fit without scrolling at 960×540.

Read testing/menu92.md. HoldMenuView owns the shell and tabs; HoldPlayerBook owns pack/people/recipes; HoldDisciplineView owns overview/detail. The four reviewed inventory, skills, conversation and recipe captures are byte-identical in local source, local export and hosted exact-export evidence. No drag-and-drop, controller remapping or equipment instances are claimed.

Downloaded build report and verification evidence match their GitHub SHA256 digests. Clean report, tag and source agree. Uploaded ZIP size 767151469 and SHA256 c69658ae50e6eee3fb09c0e24da4f27b2fb5e0f82c6f065daf1899cc1fc00145 match the report; the full ZIP was not independently redownloaded. See testing/menu92/delivery.json. Extract into a fresh folder. Windows hardware/audio and subjective readability remain hands-on playtest checks.

Continue from master; next is owner playtest feedback on these menus. Runtime is preserved on ui/menu92, release/0.82.0 and recovery/menu92-hosted, plus verified menu92-hosted.bundle. Its prerequisite 6b9e65e88133d2f4514ec0f2bd53f08618abd4f1 is preserved on master. Keep earlier recovery branches, bundles and releases. Delivery documentation is separate from verified runtime.

# 0.81.0 — The Turning Year: published and merged

Published https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.81.0 . Runtime/release source 458104d585d7aa145d062c17720358f4968a619d; PR #53 merge d846107c2cfc3f1af914f9920f17ad6f45c7ca36 has identical tree 76056c9724acd63d15e2367fe0062a8d7259abd1. Source run 40572335280 passed all 34 gameplay cases plus people-preview. Release run 40572553976 passed all 24 exact-export cases / 1,815 assertions. Focused local checks passed 230 assertions. Native and exported calendar, feast, lighting and developer controls reviewed; the two month grids and feast panel are byte-identical between hosted source and export. Other world captures vary and are not claimed identical.

Click the HUD date, or Calendar in Pack/Energy. A day lasts 40 active minutes; four 28-day seasons repeat yearly. Menus pause time and there is no offline advance. Sleep reaches 08:00; naps advance two game hours. Crops and every queued recipe progress during sleep, without simulating combat or manual work. Outdoor dawn/dusk/night stays readable; indoor and underground lighting is preserved.

Four three-day annual feasts add food, ale and remembered toasts at the Copper Kettle and Wayfarer's Hearth. Invitations remain available after the date, with modest once-per-year food/work comfort. No forced collapse, crop loss, service curfews or expiring quests. Seasonal terrain/snow, weather, NPC schedules and holiday minigames remain future work.

Try Title > Dev Testing > Calendar & celebrations; F9 jumps to times of day, each feast, a host or a bed. Test saves remain separate. Existing fortunes initialize at Spring 1, Year 1, 08:00.

Downloaded build.json matches GitHub SHA256 153154c913da9efa1cce4d9048dc81791d04de78feea702acef9e9b4fbd80ea5. Clean report, tag and source agree. Uploaded ZIP size 767128253 and SHA256 cff818887b3ce9606dd758b6f0abba6805669e226e44a0cdf64452e2043c9ab2 match the report; the full ZIP was not independently redownloaded. Downloaded exact-export evidence matches its uploaded checksum. See testing/calendar91.md and testing/calendar91/delivery.json. Extract into a fresh folder. Windows hardware/audio and subjective pacing remain hands-on checks.

Continue from master. Runtime is preserved on feature/calendar91, release/0.81.0 and recovery/calendar91-hosted, plus the verified calendar91-hosted-checkpoint.bundle. Its prerequisite 30a9b877e7a4e71cc521b18a4ed35f4502045db4 is preserved by the prior energy90-delivered-checkpoint.bundle; retain the older recovery chain. Delivery documentation is separate from the verified runtime.

# 0.80.0 — Supper & Slumber: published and merged

Published https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.80.0 . Runtime source 0802f021a441309058ec2efafa14960864caf350; PR #51 merge ace5ed7cc11091e229086c7b385be76a470f2a52 has the identical tree. Release source 44fd344ba41779bd5197804254886f231095f09b differs only in release notes. Full source run 40557642059 and exact-package release run 40558582380 passed: 33 source cases plus people-preview, 23 exported cases / 1,780 assertions, and 163 local assertions. The three final energy UI captures are byte-identical across local, hosted-source and exported runs.

Click Energy on the HUD, or open it from I, for meals, ale and nearby bed actions. Manual work spends energy; food restores less after 60/90/120 active minutes awake. Sleep fully restores energy and tiredness; naps offer partial recovery. Ale gives modest work comfort. Zero energy slows demanding work 20%; movement and combat remain unrestricted. Menus pause tiredness and there is no offline drain. No calendar, day/night, holidays or time-skipping sleep is added.

The downloaded clean build report matches its GitHub SHA256 026bd9d7124cd133772f4cd9c0253760e2c7073484c502ab6656c1b7b2404bf6. Uploaded ZIP size 767115737 and SHA256 60437f23c07d59fcd242a7dcc19694aa152a9fa96623d7643e9088a3b70b04ac match that report; the full ZIP was not independently redownloaded. Downloaded export evidence also matches its uploaded checksum. See testing/energy90.md and testing/energy90/delivery.json. Extract into a fresh folder. Windows hardware/audio and subjective energy pacing remain hands-on checks.

# 0.79.0 — Steel & Footwork: published and merged

Published https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.79.0 . Source 185b857904d23bc3787341eefd8e1cad722f90db; PR #49 merge 6027a012f1850449692dd17e3de24cb11d199128. Full source run 40511521050 and exact-package release run 40512193437 passed. Local updated combat/drill suites passed 93 assertions; native HUD, drill menu, visible wall and shove preparation/contact/recovery reviewed.

Space dodges. RMB guards/parries; RMB+LMB shoves with axe/shield. F9 combat drills: Flanking, Stagger, Parry, Wall impact. Shove uses existing whole equipped guard/recoil drawings, not a new atlas. No destructible furnishings. Windows hardware/audio and subjective feel remain hands-on checks.

Downloaded build.json SHA256 matches GitHub a8d503d02a9da7ae428ec4939b4be183adb4b6614e31fb2e2f759d7a4108fba2. Clean report identifies the source above. Uploaded ZIP size 767105423 and SHA256 00a664492134b02524fdcf7ce8a72bdc2029062d04986c8ac17f495bf9e3037c match the build report; ZIP was not independently redownloaded. Previous releases remain intact. Release and combat/steel-footwork89 branches preserve verified source. Extract into a fresh folder.

# 0.79.0 release preparation

Shove now has a .36-second preparation/contact/recovery sequence using whole equipped guard/recoil drawings, with contact after .16 seconds. Moving, dodging or stowing cancels/controls its state as implemented; no detached shield is drawn. F9 combat adds Flanking, Stagger, Parry and Wall impact drills. New tests cover delayed contact and isolated drill setup. Fresh checkout restored from GitHub 06e34b52; native import and verification in progress. No new release is published yet.

# Combat feel — implementation candidate

Extends Space-dodge branch with early windup aim adjustment, late recovery guard cancel, goblin flanking during allied commitments, decaying visible poise pressure and stagger breaks, cooldown-limited RMB+LMB shield shove, and wall-stop feedback/pressure. Existing orc/troll timings, armor, riposte and stagger immunity remain. No stamina or save-schema change. Shield shove reuses the complete braced/recoil pose; no new art. Terrain scope is wall-safe knockback and wall impacts, not destructible furnishings. Native combat suite: 43 passing assertions. Enemy/hitbox suite: 97 passing assertions, including early steering and committed contact. HUD capture reviewed. Evidence: test-results/combat-feel-verified and combat-feel-enemies-final. No new release or merge; subjective feel and bespoke shove animation still need review.

# Spacebar dodge — source update

Combat dodge now uses Space through a named input action. Q remains material set-down. HUD, training dialogue and equipment/help instructions match. The legacy armed input route consumes Space before jump buffering. Six real-event checks extend combat83; playability54 uses the new key. Native combat-preview passed all 37 assertions with zero errors; updated HUD reviewed at gameplay scale. Evidence: test-results/space-dodge-native2. No new Windows release yet.

The five proposed combat improvements are an agreed direction; they are not implemented by this binding change. Audit existing buffering, riposte, stagger protection and enemy behaviors before extending them.

# 0.78.0 — Grip, Guard & Craft: published, verified and merged

Axe-and-shield combat now uses complete equipped drawings for all fourteen saved identities, including walking, strikes, guard and block reactions. The shield stays on the painted forearm and grip; practice Borin uses the same poses. Eight original hammer crops now retain their complete heads. Damage, hitboxes, timing, original assets and saved appearance choices remain preserved.

Rune-stones, timber signs, lantern posts, barrels, crates and plinths are separate world/player furnishings. Each has an individual catalogue card, price, collision base, placement, movement and recovery. Signs stand clear of travel thresholds and sort correctly with actors. Barrel/crate pieces are explicitly decorative.

Runtime source b2ce75a095c6aefe801b1cdb46f648448e40253d and PR #47 merge fe060bf55202a59011ac30ae8fbdbc3f0cb00f94 share tree 9575060eb5e44fbaeab8d0784f0210f1803f89e1. Native verification passed 494 focused assertions. Source run 40334541809 passed all 32 gameplay cases plus people-preview. Release run 40334541656 passed all 22 exact-export cases, with 1,733 assertions. All fourteen shield/weapon boards, live practice poses, catalogue and world props were reviewed. All 29 exported character/prop boards are byte-identical to their native counterparts; exported shield, hammer, prop and recoil captures were also reviewed.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.78.0
Windows ZIP: 767,100,400 bytes; SHA256 583a5e070dddad84854d2ac747f9edc1a2a1fea6528d39dfde43f450d8295cb3. Downloaded build report and verification archive match their GitHub digests; the release tag, clean report and uploaded ZIP metadata agree. Extract the complete archive into a fresh folder. Windows-device performance, audio and subjective combat feel remain hands-on checks.

Try Title > Dev Testing > Combat arena; B selects equipment, LMB strikes, RMB guards and Q dodges. For decor: Construction & decorating > F9 > Building book > Furniture & details > Roadside. Rear guard/recoil sometimes share a braced drawing; mirroring retains apparent-handedness limitations. Original hammer strokes retain their authored directional coverage.

Continue from master. Runtime is preserved on recovery/combat88-native-verified and in the verified combat88-published-native-verified.bundle. The incremental bundle requires 32822157cc76f4f2f954bad7d848794adab8456a, preserved on recovery/pre-combat88. Keep earlier native/hammer bundles, recovery branches and releases. Delivery documentation is separate from the verified runtime. See testing/combat88.md and testing/combat88/delivery.json.

# 0.77.0 — Stone, Timber & Tradition: published, verified and merged

Three compatible architectural collections are available: Hearthstone (oak and warm limestone), Forgehold (basalt and copper), and Oathhall (carved granite, teal and brass). Mix masonry, roofs, trim and room finishes independently. Annexes retain measured bay widths and full-size masonry; added storeys form a set-back upper block behind the intact original frontage. All 22 familiar designs remain buildable.

Visual building, furniture and structure catalogues show real painted components. Plan details show the original silhouette and furnished/shell cost. Renovation previews show the current building; material studies explicitly show an example wing and upper room. Applying finishes quotes the cost first. Rooms and freeform construction share the collections. Optional saved finishes preserve old saves, room geometry, stairs, furniture, stored goods and paid shell recovery.

Runtime source 52e90de84fe2df330347fefbee98825cba1d96c3 and PR #45 merge ce49bfe6b68383a28ae8f5304113b8eac28eb67f share tree 19a8d8b9d23d5dba33a4bb1c221aeca49ac87cda. Final local verification passed 539 assertions: 60 collection/UI checks and 479 focused regressions. Source run 40261718443 passed all 31 gameplay cases plus people-preview. Release run 40261717625 passed all 21 exact-export cases (1,610 assertions). Native catalogues, all collections, mixed finishes and five-storey buildings were reviewed; exported material and Hearthstone/Oathhall room captures were also reviewed.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.77.0
Windows ZIP: 733,838,675 bytes; SHA256 c4b874b7fc401afd597672a44fd8d39c60cf87aeb80491f843d620b4f54ad1b5. Downloaded build report and verification evidence match their GitHub digests; release tag, clean source report and uploaded ZIP metadata agree. Extract the complete archive into a fresh folder. Windows-device performance/audio remain hands-on testing.

Try Title > Dev Testing > Construction & decorating > F9 > eastern building grounds. Reopen F9 for Building Book. O at a player building or inside its room opens renovation; choose Materials & finishes. The original front remains a signature component; arbitrary per-window exterior editing and NPC business assignment remain future scope.

Continue from master. Runtime is retained in architecture87-native-verified.bundle and recovery/architecture87-native-verified. Pre-edit architecture87-before.bundle and recovery/pre-architecture87 preserve f62bf8fcfeccd5b47cfab0ac61c741911777860a. Delivery documentation is separate from the verified runtime. Preserve all older bundles, recovery branches and releases. See testing/architecture87.md and testing/architecture87/delivery.json.

# 0.76.0 — The Builders of Keldrath: published, verified and merged

All 22 prepared designs now share plans, exterior rendering, room geometry and player furnishing components. The Building Book offers furnished plans or empty shells, editable interiors, side/rear bays, five connected floors, rename/relocate/recover, private storage and real household/workshop services. Original painted fronts and household identities remain intact. Eastern building grounds have matching river/cliff boundaries. Existing construction and normal/test saves are preserved; older saves receive an exact pre-architecture backup.

Runtime source ff840c816d451e75babaf1fecdc3c776c8b8a1e2 and PR #43 merge 6ff9dc03b56624903d46debdd79990d8b1de97c9 share tree 2ae39e202456a24fab98af2df25f8d286a28fb72. Local native architecture verification passed 301 assertions; seven focused cases passed 343; the five-storey keyboard walkthrough passed 20. Original/player buildings, furnishings, menus and the eastern river boundary were visually reviewed. Source run 40249460487 passed all 30 gameplay cases plus people-preview.

Release run 40249459330 passed the package audit and all 20 exact-export cases (1,550 assertions), including all 301 architecture checks. Exported catalogue and royal-hall captures were reviewed. Downloaded build report and verification evidence match their GitHub digests; verified source, clean build report and uploaded ZIP metadata agree.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.76.0
Windows ZIP: 729,897,845 bytes; SHA256 1478b9f514d8e050de5e7160727fb368b110fdb5bd4b7e7a5fedc1610a588cf4. Extract the complete archive into a fresh folder. Windows device performance/audio remain hands-on testing. Painted façades remain reusable architectural styles; arbitrary per-window façade editing and NPC business/household assignment are not added here.

Try Title > Dev Testing > Construction & decorating. F9 offers the Building Book and eastern-grounds shortcuts. In normal play, O on the claim opens home improvements and the book; O inside a player building opens renovation. E uses stairs; Shift+E descends. Reopen F9 after a test-location shortcut.

Verified local architecture86-ground-verified.bundle and confirmed remote recovery/architecture86-ground-verified preserve the runtime source. The incremental bundle requires cf6fe48459d6c9a5c44707b57c1cb35c5c1ea25e and 217991b75e3878d047e643fba4097dcfcdc323a9, retained in the full dev-testing85-native-verified.bundle. Preserve all earlier backups/releases. Delivery documentation is separate from the verified runtime. See testing/architecture86.md.

# 0.75.0 — The Testing Grounds: published, verified and merged

Title screen > Dev Testing launches four standalone presets: combat, construction/decorating, mining/workstations and farming/fishing/cooking. Each supplies the location, unlocks and materials for immediate hands-on play. F9 and the DEV TEST badge open paused controls inside test sessions, including reset/restock and relevant shortcuts. The launcher refuses to replace active normal gameplay. One dedicated test save is separate from all three normal fortune slots. Combat encounters restart on reload; construction persists until reset. HoldBuild.DEV_TESTING can hide the temporary entry points later.

Runtime source cf6fe48459d6c9a5c44707b57c1cb35c5c1ea25e and PR #41 merge 6922ad02060ce4d1c2476efdcb90472e93f24052 share tree 79de1b7391d5f4a670b0734f382153f4b3a9830f. Local native verification passed 80 assertions: developer testing 40, combat 31 and menus 9, with zero engine errors. Title, launcher, combat controls, arena, building, workshops and gardens were visually reviewed. Source run 40229901070 passed all 29 gameplay cases and people-preview.

Release run 40229901891 passed the pack audit and all 19 exact-export cases (1,249 assertions), including all 40 developer-testing checks. Exported launcher and combat-control captures were reviewed. Downloaded build report and verification evidence match their GitHub digests; report, verified source and uploaded ZIP metadata agree. This is a clean 0.75.0 build.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.75.0
Windows ZIP: 729,865,829 bytes; SHA256 efa6b172edeab7cdfa994c24c3d413d9ef7ee79d00286da3ebb204c8ec2c63d3. Extract the complete archive into a fresh folder. Normal saves remain supported. Windows hardware performance/audio and subjective gameplay feel remain hands-on testing.

Verified local dev-testing85-native-verified.bundle and confirmed remote recovery/dev-testing85-native-verified preserve the runtime source. Preserve all earlier remote backups and releases. This session began from a fresh checkout; historical local bundle paths below are not claims that those older local files still exist here. See testing/dev-testing85.md. Equipment instances, schematics and the signature crafting expedition remain the next Steel & Spoils milestone.

# 0.74.0 — Foes Beneath the Hold: published, verified and merged

Combat now uses explicit ground-plane body circles (player 10 px; goblin 12, beetle 14, orc 17, troll 26), shared sector geometry for hits and telegraphs, and a 3 px carbine projectile radius. Damage lands on the authored contact key at 52% of the action, once per strike, with direction locked through recovery. Brief 25–70 ms combat-only hit-stop, bounded wall-safe recoil, sparks and existing impact audio distinguish hits, blocks and parries. Hammers recoil farther; trolls resist displacement and retain stagger protection. F8 toggles a live hitbox inspection overlay. No global slowdown or camera shake is added.

New goblin, orc and cave-troll whole-character sheets include movement, anticipation, impact and fallen poses in front/side/rear views. New encounter records persist a mixed fantasy roster; old identities, wounds and cleared passages remain supported. Orc armor rewards hammers; trolls have a longer, slower heavy blow with clear warnings and a long opening afterward. Ranged hits now alert distant enemies. Safe first-level and Borin practice remain intact.

Runtime source 2c8919320ece292cb8760454bc5e58a617b0e99b and PR #39 merge f45c61eed282466da3c6e8e284bdbc14d087016f share tree 3d61bfdfe8dc98b12a0fd6d6c5751fdaccddd34a. Source run 40150630929 passed all 28 gameplay cases and people-preview. Local native verification passed 96 enemy/hitbox assertions and 31 combat assertions with zero script errors. A current-entry practice probe also passed held attacks, timed parry, directional dodge and harmless practice damage (5 checks). All 54 enemy poses, in-world scale, heavy warning/contact, movement keys, actual hitbox outlines and impact feedback were visually reviewed.

Release run 40150628875 passed the pack audit and all 18 exact-export cases (1209 assertions). Exported hitbox and impact captures were reviewed. Downloaded build report and verification evidence match their GitHub asset digests; report, source and uploaded ZIP metadata agree.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.74.0
Windows ZIP: 729,852,489 bytes; SHA256 06781dfbd4cae4ae9a0b5d3c7d4ec42963077e2b557531804f5c8be1d069094b. Existing saves and cleared encounters remain supported. Extract the complete archive into a new folder. Windows hardware performance/audio and subjective combat pacing remain hands-on playtesting.

Verified enemies84-impact-checkpoint.bundle and remote recovery/enemies84-impact-native-verified retain the runtime source. Preserve enemies84-checkpoint.bundle, recovery/enemies84-native-verified and all earlier backups/releases too. Equipment instances, schematics and the signature crafting expedition remain the next Steel & Spoils milestone. See testing/enemies84.md; art production and exact prompts are in assets/enemies84/PRODUCTION.md.

# 0.73.0 — Steel & Footwork: published, verified and merged

Live Warrior credit and Sure footing now work in top-down combat. New deep encounter records can contain a fast scavenger and a slower armored beetle, with spacing and one nearby committed attack at a time. Amber telegraphs match hit geometry. Shield blocking, reduced-damage bracing, bounded hammer stagger, narrower hammer arcs and nearest-target carbine shots distinguish existing weapons. Equipment changes cancel live strikes; the gear panel fits the screen and scrolls to every choice.

Runtime source fc356766975c33af15440220a993bb430f946d10 and PR #37 merge 2b812f197a05531405c6b60f75c963724270b908 share tree 1bb1bebda840b49a30d62de4b8b38a303349923a. Source run 40144076473 passed all 27 gameplay cases and people-preview. Final local combat verification passed 31 assertions with zero script errors. Pair/shield, hammer, carbine and scrolling equipment views were reviewed at 1280×720.

Release run 40144104224 passed the 3,269-entry PCK audit and all 17 exact-export cases: 1,113 assertions, including 31 combat assertions. Exported pair/shield and equipment screenshots were also reviewed. Downloaded build report and verification evidence match their GitHub digests; report, source and uploaded ZIP metadata agree.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.73.0
Windows ZIP: 725,152,730 bytes; SHA256 9d6b7d736cdfa990610d3124a6e3a2436d64f7e15526ac06c18694d3d616a2bc. Existing saves and recorded encounters are preserved. New companions are created only with first-time encounter records. Windows hardware performance/audio and player feedback on pacing remain hands-on testing.

This is the combat foundation of Steel & Spoils. Equipment instances, schematics, salvage processing and the signature crafting expedition remain the next milestone. No stamina system or artwork replacement. Verified combat73-checkpoint.bundle and remote recovery/combat73-native-verified retain the source; preserve all older backups and releases. See testing/combat83.md.

# 0.72.0 — Faces of the Hold: published, verified and merged

Twelve authored characters now have motives, concerns, tastes and personal dialogue; the countryside cast adds twelve local story topics. Dagna staffs the Wayfarer's Hearth inside. Gifts, paid favors, familiar greetings and the People notebook preserve relationship history. Other residents retain stable generated personalities. Four future romance candidates have dormant metadata only; dating and marriage remain disabled.

Mine entrances now have readable masonry openings, lamps and approach tracks aligned with walkable collision. Pick rest/recovery frames keep the approved pick silhouette. Final regression fixes normalize saved story counters and repair invalid prerelease item preferences without rerolling valid tastes or earned history.

Runtime source f241aee9c728e317572b67c294c45d657185c80d and PR #35 merge c512e9ec1c1d3a1fbd8dfd5df1a751794719a372 share tree 86fe3856349df5323a019124543e8fc5f7520cb9. Continue from master, the current default branch.

Source run 40137875448 passed all 26 gameplay cases and people-preview. Local focused native verification passed 380 assertions with zero script errors. Both entrances, seven male pick sequences, conversations, gift picker, favor terms, notebook, Dagna's story/familiar welcome and staffed Hearth were visually reviewed. Release run 40137928083 passed the 3,269-entry package audit and all 16 exact-export cases (1,082 assertions, including 380 people assertions).

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.72.0
Windows ZIP: 725,151,889 bytes; SHA256 13666ead4d977760da6cb05f6eb2dd44d36847e755536a892b331cfec343381d. Uploaded size/digest match the clean build report. Downloaded build report and verification evidence match their uploaded digests. Existing saves are supported; Windows device performance and audible quality remain player testing.

The repository is public and the Actions capacity blocker no longer prevents these runs. Full current source is available locally in stellar-full; stellar-full-verified-people.bundle is a verified complete current checkout with shallow history. Remote recovery/people72-native-verified retains the verified source. Preserve all older bundles, recovery branches and releases. See testing/people82.md and COUNTRYSIDE_CAST.md.

# 0.71.2 — Your First Worksite: published and verified

Ivar offers an optional workstation quest before the first mine trip, with one-time starter timber. A saved checklist follows real lifting, stocking, processing/output and equipment construction. Guidance can be paused and resumed; a gold marker identifies the current load or station. Completed journals stay within the viewport. Existing saves, terrain, equipment, material ownership and original artwork are preserved.

Source run 40124472557 passed all 25 gameplay cases plus the focused worksite-preview job. Offer, briefing, marker and completed-journal screenshots were reviewed. Release run 40124470758 passed the 3,263-entry PCK audit and all 15 exact-export cases. Release source a663393419275d7e7410f960cec98f20ffb32972 and PR #33 merge d0813ded310c057a8bef60ae07b82fbc72b3e646 share tree 45743125c13397db767d75b6de2d4a51effac7ca.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.71.2
Windows ZIP: 725,127,977 bytes; SHA256 ec368d4e2b1038d5e4f1deba6a14406d005d17b0c1a4a387df6a966576acc276, matching the build report and uploaded digest. Verification evidence accompanies the release. Windows device performance/audio remain player testing. Prior releases and recovery branches remain intact.

# 0.71.1 — A Clearer Path: published and verified

Quest journal hierarchy, status-grouped lessons, correct introduction targets, ancestral contact markers, paused quest browsing and readable footer are implemented. Existing saves/rewards and original artwork are preserved. Local final focused verification passed 117 assertions; journal, pack and settings screenshots reviewed at 1280×720. Hosted source run 40046866977 passed all 25 gameplay cases; release run 40046874975 passed the 3,263-entry PCK audit and all 15 exact-export cases.

Published: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.71.1
PR #31 merged as d88ff6fb236d8817ccc59d70329366668bdac852. Its tree c9bd0fd80b0e0fbce51fe67fbb04a425caf852fa matches tested release source e610b426b81642f778094e10a037a13a97f9c162. Windows ZIP: 725,124,683 bytes; SHA256 794ef4d6ca5f1810319f2f40198b0041639bbf9990ace12cac01ca9ff4099a75, matching clean build report and uploaded digest. Release includes verification evidence. Local menu80-final.bundle preserves the runtime checkpoint; prior releases/backups remain intact. Windows device performance and audio remain player testing.

# 0.71.0 — Beneath the Stone Crown: published, verified and merged

The expanded King's Hall, Eirik's whole-character walk/stand/sit poses, actual top-down royal audience, mounted signs, grounded ward surrounds and northern King's Gate are complete. Advancing audience dialogue preserves the player's position. Existing saves, progression and original artwork remain intact. General lying-down poses remain future work.

PR #29 merged at 9d992e0f3abe38d49bf05ca72d4c250f9d76eb1c. Its tree f280a3b4ceeca5282fd5e3bc099c1c1448771988 matches verified release source 56260aa1d4b1204ec695b5dd171108e74799f8c3. Hosted source run 40038598002 passed import and all 24 gameplay cases. Release run 40038600939 passed the 3,263-entry PCK audit and all 15 exact-export cases. One complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.71.0. Its 725,124,940 bytes and SHA256 540fe880913e2658f7c8f903b7e5034b5032a305d87813fe2542fb71e00447c4 match the hosted build report and uploaded asset digest.

Local native royal verification passed 72 assertions; the complete local exact-export gate passed 693. Hall, audience, seated king, gate and ward visuals were reviewed. Actions artifact storage was full, so exported verification evidence is retained with the release; all gameplay checks remained mandatory. Continue from GitHub main. Prior releases and recovery checkpoints remain intact. See testing/royal79.md for evidence and limitations.

# 0.70.0 — Hearth & Homestead: published, verified and merged

Continue from main f058b996473324ad15f7edfc6956c6fdad86c3f0 (PR #26). Its tree 35109513bc14533c7cb3ccd2e10229e28e2af3d4 matches verified source 6f595bac649ac266c989a1fe2e3d45c0bed52fb9. Rivers replace the proposed isolated pools: fish along accessible banks at the claim, Stonebridge and Greenhearth. Four forgiving crops, four meals, home comfort, mastery techniques and Hedrik's optional supper favor are implemented. Existing saves and approved characters remain intact.

Hosted source run 39979630313 passed import and all 23 gameplay cases. Release run 39980955955 attempt 2 passed all 14 exact-export cases and published one complete Windows ZIP. Uploaded size 719,947,148 bytes and SHA256 61f85acd1c343c2b9386c0a7842adbc265f719ea9aa4a108562cc32ef0b7d2d2 match the hosted build report and release asset digest. Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.70.0. The first attempt's GitHub HTTP 500 was resolved by retrying; no old release was replaced.

Local focused/regression checks passed 492 assertions across 12 cases; exact-export homestead passed 69. Hosted export gardening, watering, riverbank, kitchen and home visuals reviewed. Downloaded attempt-1 evidence SHA256: 8c6be951b8e79feeb515ae3d89f086fac7bb29439d9e34bcd1c571fc06a3adb7. Prior checkpoints remain intact. See testing/homestead78.md for recovery and limitations.

# 0.69.0 — Stone & Hearth: published and merged

Source run 39963593854 and release run 39963621454 passed. Published single Windows ZIP: 719,902,750 bytes; SHA256 d08e3a3d73a07fc5935b2afe1fd90709fcfdb8df310507c99b72025ceb0054fb, matching hosted build report and asset digest. PR #25 merged at 80edbc423f50de8e3cedaa80f47f72a719149660; tree 6d79f1670a2e8fcd3f9ec3f64b850f37f733f469 matches the locally reviewed source/export. The earlier upload block was resolved by explicit owner approval. Recovery/pre-homestead78 and local pre-homestead78 preserve the complete released source; prior recovery archives/bundles remain intact.

# 0.68.1 — Honest Work: published, verified and runtime merged

The extra player bucket and legacy rock/arm overlay are removed. Existing personal cargo, shoulder loads and approved whole-character artwork remain intact. Five fixed workshop props now have level fronts and upright supports, shared by live equipment, construction previews and the workshop board.

Player-operated stonebreakers and sawbenches deliver completed output directly into the pack, including normal mastery bonuses. Plain E collects older output left on a bench. Racks, pallets and carts retain deliberate storage transfers; hold crew materials remain protected. Partial jobs, recipes, work credit and saves keep their existing records. First-shift guidance advances on automatic collection.

One complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.68.1. Its 714,596,045 bytes and SHA-256 af5774d5d3379fe4fd72fbda0767ab1adb8774bf7227dd597b7e1665e9af22bd match the clean hosted build report and uploaded asset digest. Tag v0.68.1 preserves source 6da44ffe28fb6b4cf8f1f639293b872285944ac4, tree 8e253d392ad1a6423a3ba6ab916e80f96b073309.

Hosted source run 39879928695 passed import and all 21 gameplay cases: 810 assertions. Release run 39880976032 passed the 3,219-entry PCK audit and all 12 exact-package cases: 503 assertions. Downloaded evidence digests were verified and accepted logs contain no script errors or leaks. Local focused verification passed 314 assertions and local exact-package verification passed 503. Native source, local export and hosted export visuals were reviewed. See testing/work76.md and testing/work76.

PR #23 merged at 045486ddeb1e560eebccb052143b96377d5ffcf0 with the identical verified runtime tree 8e253d392ad1a6423a3ba6ab916e80f96b073309. Continue from GitHub main after integrating the separate delivery documentation. On 2026-10-23 the owner explicitly authorized merging directed work after required testing and review; no separate routine merge confirmation is needed.

Baseline: local pre-work76 at 53cdc61845e8eaebacc65a4d6ac287fc832bb8f3; its verified incremental bundle requires 209408538d2fe62773175b27d6313a17db8a8cff. Final delivery checkpoint: verified-work76-delivery, with a local incremental bundle requiring pre-work76 and a persistent GitHub recovery branch. Earlier checkpoints/releases remain intact. Windows hardware performance/audio and final visual acceptance remain player testing.

Latest player feedback: Keldrath buildings feel repeated. The audit confirms repeated household names/fronts/interior templates and two shared public-façade pairs; public service doors are unique. See KELDRATH_IDENTITY_AUDIT.md. This diagnosis is recorded for a focused town identity pass, not claimed fixed by Honest Work.

# 0.68.0 — Roads & Hearths: published and verified

The giant-avatar travel map is no longer part of play. Walk through character-scale paths, gates, mine arches and ordinary doorways; G opens directions. Stonebridge has a wayside hearth, kitchen/storage, bridge supplies and mine staging; Pinewood adds loan processing and timber orders; Greenhearth adds a permanent four-bed allotment, farmhouse services and produce orders. Six residents use the approved whole-character artwork. Existing saves, excavation, inventory, cargo, claims and progression are preserved.

One complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.68.0. Its 709,006,709 bytes and SHA-256 6381876c2532a492dfe3ebc0ebca5d3b9ef93c61340cc31d598eb6a8a139284b match the clean hosted build report and uploaded asset digest. Tag v0.68.0 preserves source a64af2e41dd5d645833173f1020ecafe452fe649. PR #21 merged at ea38817cb27fe90ae531b1f037926b0be2af2c73 with identical tree 441ba3da8dfa177cb546e6e3888d2aa10a80730d.

Hosted source run 39870961710 passed import and all 20 gameplay cases: 784 assertions. Release run 39870964362 passed the 3,208-entry PCK audit and all 11 exact-package cases: 477 assertions. Native visuals were reviewed, and nine supplementary local exported kitchen/lease/cargo checks passed. Clean hosted logs contain no script errors or leak messages. Earlier runs hit execution time limits; final gates passed after increasing only CI budgets. See testing/roads75.md and testing/roads75.

Continue from GitHub main. Recovery/pre-world75 preserves the pre-change main checkpoint 1e2374f2cd87f9a4830923c4dc31136e0638eb03. Final recovery: verified-world75-delivery (separately verified local incremental bundle requiring pre-world75, plus a persistent GitHub recovery branch). Older releases/checkpoints remain intact. Scenes still load individually; local residents are ambient. Next: player review of crossing readability, countryside density and work pacing. The work-board keyboard-help footer can extend below 1280×720; its primary controls remain visible and tested. Windows hardware performance/audio remain device playtesting.

# 0.67.1 — Familiar Faces: published and verified

One complete Windows ZIP is available at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.67.1. Its 708,989,468 bytes and SHA256 a521b291b52e43789d6d61905868c8390ce2a987fa6ad916273a93c106c72bdb match the clean hosted build report.

Town walk contacts now inherit canonical corrected artwork, preventing retired beard/hair drawings from reappearing. Measured hair and passing-pose calibration, complete bare-crown/high-ponytail side walks, corrected greatbeard utility crops and shared whole-character rendering preserve identity. Character creation previews standing, walking, working and carrying with turn controls. Existing saves, names, sculpts, inventories and work mechanics are unchanged; corrected derived artwork prepares a new cache on first use.

Native appearance checks passed 64 assertions and related core checks passed 104; the same 64 appearance checks also passed against the local exported PCK. All fourteen identity boards plus creator, town and tavern scenes were visually reviewed. Hosted source run 39837733726 passed 704 checks across 19 cases. Release run 39837735551 attempt 2 passed 10 exact-package cases (397 checks) and published successfully. Release source e6f23d7829ad121b82475350bc4edbe6c4588d85 and PR #19 merge e9b8239f9a959e4ff2fbc6895aec9a6d79271a88 share tree 96510cc5e2023b03aa82011e17e919fba9a720fd.

Continue from GitHub main. Pre-change recovery/pre-appearance74 and all older versions remain intact. Final recovery checkpoint: verified-appearance74-delivery (separately verified local incremental bundle requiring pre-firsthour73, plus persistent GitHub recovery branch). Evidence: testing/appearance74. Windows device performance, sound and final artistic acceptance remain player testing. This repairs source selection and specific poses; it is not a redraw of the entire animation library.

# 0.67.0 — A Good Day’s Work: published and verified

One complete Windows ZIP is available at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.67.0. Its 707,638,184 bytes and SHA256 d77216cc175bc2f3729ced90c666aa27c8678fbdf4397ab14e00b26aa0d5951b match the clean hosted build report.

Includes physical outdoor workstations and safe work approaches; contextual first-shift guidance and stockpile connection previews; eight starter-quarter furnishing plans (O); reduced interaction and animation-preparation overhead. Existing saves, work yields and approved whole-painted actors are preserved.

Hosted source run 39795166172 passed 640 checks across eighteen cases. Release run 39795998750 attempt 2 passed all nine exact-package cases and published successfully. Local verification passed 401 targeted checks and 333 exact-package checks; native visuals were inspected. The release tag preserves e94f475ca66d363149a89a776728833fa4e2b496. PR #17 merged at 977a1d9b571eb0fef45525f4246e2070f19878b7 with identical tree 5716fad4574e715b134f36b733f9ae19307f3d12.

Continue from GitHub main. Recovery/pre-firsthour73, prior releases and archives remain intact. Final recovery: verified-firsthour73-delivery (local incremental bundle and persistent GitHub branch). Evidence: testing/firsthour73 and testing/firsthour73.md. Next: player feedback on work approaches, lesson clarity, furnishing and repeat transitions. Windows device performance/audio remain playtest items.

# 0.66.0 — Hearth & Stone: published and verified

One complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.66.0. Uploaded size 707,549,210 bytes and SHA256 5a1312685202057d74448d759e487770868aa5e0725d25adcdea137a63f31d4a match the clean hosted build report. Tag v0.66.0 points to release source 5af5f8e546546b4e0b06940516afa4aa5b4f57fd. PR #15 merged at 87afd5ee79dbae4b17bcb13bfdf1e58dd5e7da46 with the identical verified tree.

Hosted source run 39707677406 passed import and all seventeen gameplay cases. Release run 39707717931 passed all 3,199 PCK integrity entries and all eight exact-export cases. Local verification passed 311 source checks and 315 exact-package checks; gameplay-scale native visuals were inspected. Evidence: testing/polish72. Windows hardware performance/audio and artistic acceptance remain player-device testing.

Continue from GitHub main. Final local recovery tag verified-polish72-delivery has a separately verified incremental bundle requiring pre-polish72. Earlier backups and releases remain intact. The release tag preserves the delivered source. The user explicitly approved the original texture-sheet upload and isolated import workflow within the agreed scope; import run 39707494879 verified its hashes. Transfer helpers remain on asset/hold72 and are excluded from main and the runtime.

Next: player feedback on free-hand side-walk cadence, front-door collision/readability, room composition and menu navigation. This pass refines existing complete action frames; it does not redraw the entire animation library. No new roof-access gameplay or textile economy was introduced.

# 0.66.0 — implementation record

Local baseline pre-polish72 preserves b8859ccd38b86adc099fdb37af0e85c3e0115514; verified recovery/pre-polish72.bundle requires pre-disciplines71. GitHub recovery/pre-polish72 preserves e9ce5175679b5295fe1e9ab79b8c6396fa4a1ad4. Earlier releases remain untouched. Work branch polish/hold72.

Player and resident free-hand side walking now share the complete passing drawings. Distance-driven stride is 57.2 units per cycle (formerly 78), retaining movement speed, tools and whole painted actors. Building draw order follows the physical front edge so a player outside the wall remains visible. Painted slate roofs, side masonry and rear coping show the existing full collision envelope; mountain bedrock anchors the outer boundaries. Rooms retain their dimensions and saved placements, gaining grouped seating, shelves, lighting and original woven rugs.

Menus have consistent selected peer tabs including Skills, shallow peer navigation, ordinary Back for nested screens, pack search, keyboard-following scroll and explicit personal-menu pause behavior. Art provenance and exact prompt: assets/hold-kit72/README.md. Native targeted suite passed 311 checks, including all wards, representative interiors, escort, resident routes, stairs, held equipment, menus, disciplines and reload. Visuals inspected at gameplay scale. Exact export and hosted delivery subsequently passed; see the verified delivery record above.

# 0.65.0 — Work & Knowledge: published and verified

The complete Windows ZIP is published at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.65.0. Uploaded size 705,326,179 bytes and SHA-256 f6899cf79ba4696720bbe74734fdba052efb4cdcdbfc4a94c49d369eb01b815f match the clean hosted build report. Tag v0.65.0 points to release source 29f73c9ea10630503df56e5c79822e4788f70f44. Runtime PR #13 merged at 29099653e6566003cbf8ee93bc4fbcfc2e28462f with the identical verified tree.

Full hosted source validation 39696445457 passed import and all sixteen gameplay cases. Release run 39696891128 passed the 3,197-entry package audit and all seven exact-export cases. Local verification passed 193 targeted source checks and 240 exact-package checks, with native menu visual review. See testing/disciplines71 for evidence. Windows hardware performance/audio and player acceptance remain device testing.

Continue from GitHub main. Final local checkpoint verified-disciplines71-delivery has a separately verified incremental bundle requiring pre-disciplines71; earlier bundles and releases remain intact. The release tag preserves complete delivered source. Next: player feedback on work pacing, unlock clarity and menu navigation; future dedicated Brewing production and deeper branches remain scoped follow-up work.

# Implemented progression

Thirteen discipline tabs are integrated into the existing game. Open with Y, the inventory, pause menu or Survey Office. Y deliberately leaves underground U unloading and T crew assignment intact. The menu pauses play, keeps its discipline tabs separate from the scrolling details, supports keyboard focus and uses thirteen original vector emblems. Each technique displays its effect, work threshold, research and prerequisite. Learning retains lifetime experience; there is no universal spendable XP currency.

Twelve paths have live work sources; Brewing is explicitly reserved for a future dedicated work loop, with no fake unlocks. Thirteen optional techniques improve physical recovery, processing output, production efficiency, farming/fishing yield, dodge recovery, crew capacity or cart capacity. The eight existing research methods are also shown in their relevant paths and still unlock the existing equipment, construction and industry. Existing research costs and access remain intact. This is an expandable first tier, not a complete endgame tree.

HoldDisciplines owns definitions, eligibility, one-time migration and saved progress in hauling.disciplines. Completed-work hooks stay in gameplay owners. Legacy Miner/Mason/Forester/Smith counters and automatic hauling unlocks remain; the historically combined forestry counter seeds both Forestry and Woodworking once. Existing harvests, catches, cleared threats and crew counts receive credit. New sawing awards Woodworking separately from felling. Overseer mastery is separate from civic appointment and grants no communal stock permission.

Pre-edit local tag/bundle pre-disciplines71 preserves e5759a89376a3d1e08fe0c5c5ef616ca264d37c4 (bundle requires pre-ancestral70). GitHub recovery/pre-disciplines71 preserves remote main 87cc8846a8681e044230ed2853680041927aa072. Old releases and backups remain intact. Read testing/disciplines71.md for verification status. The published Windows release is v0.65.0.

# 0.64.0 — Published and verified

One complete [Windows ZIP](https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/download/v0.64.0/Stellar-Holds-First-Fortune-0.64.0-Windows.zip) is published. Size: 705,278,506 bytes; SHA-256 `717d5ba55b3bf01be61731b247901b51157601db8b630b45e9979ace35b79f46` matches the clean hosted build report. Release tag v0.64.0 points to verified source c9958797c2a453bbc26934c5832d1db3d36c0f3d. All fifteen hosted gameplay cases and all six exact-export cases passed. Source run 39679087059; release run 39679089395. PR #11 merged at 3bb211b335c940ddd877c8103e788fbf320af9da with an identical tree. Earlier releases remain intact.

Includes the Three Hearths civic refinement, the practical mine worksite with protected hold stock, and The Stone Remembers: physical rescue, Eldric's evidence-based charter research, Overseer appointment and development-gated investiture as Thane. Existing purchased mountains, excavation and other progress remain preserved. Research and appointment use the existing conversations and journal. Local verification included 239 related source checks, 23 quest/UI checks and 203 exact-package checks. Windows hardware performance/audio and artistic acceptance still require the player's device.

Next: discuss experience gains and readable personal development trees/charts. Current work counters and nine research methods are preserved; no full skill-tree redesign is implemented. See PROGRESSION_NEXT.md, PLAYTEST_GUIDE.md and testing/ancestral70.

Continue from GitHub main. Local history is a recovery graph; never force-replace the remote. Pre-ancestral70 / b2df6bb1eaa541150eaa08c4e87a6e60e939ee37 and earlier bundles are preserved. Verified-ancestral70-pack / 6998163ceb56fc889e229f4b61b03906afa0448c records source/local evidence. The final delivery checkpoint adds hosted evidence and is saved separately as verified-ancestral70-delivery with an incremental bundle requiring pre-ancestral70. The persistent release tag preserves complete delivered source.

Efficiency: finish the exact-pack harness before launching the cold hosted gates. Fixture inlining cannot retain a duplicate helper name; firstshift69 uses press(), leaving the shared key() helper intact. Do not push docs onto an active runtime PR: its diff retriggers full validation. Final evidence belongs in a separate docs-only PR after runtime validation. Cold import plus the complete suite took about 30 minutes; publication ran the six package cases after reusing that exact-source gate. Do not claim pending checks passed.

# Ancestral charter — Overseer to Thane

The Stone Remembers is an additive quest stored in outpost.ancestral_claim. Ivar offers a rescue after the first paid shift and initial audience/next-work conversation. The quest uses an existing depth-1 hold cavern and never overwrites excavated terrain. Open a continuous walkable bypass, speak to the miners with E, and keep their route clear until both reach the entrance. Saved positions/path progress support mid-rescue reloads. The recovered slab then goes to Eldric.

Eldric preserves the tablet; the Lord supplies an archive comparison and Ivar the family registration. Eldric authenticates the ancestral reclamation right to nearby Old Delving, not Keldrath. The Lord appoints an Overseer without a charter purchase. Existing saves keep their selected claim and camp stage. Commercial charters remain an alternative. Complete the workshop/beacon, recruit two Folk and hold 12 food plus 12 water to petition for investiture as Thane. Recognition grants no access to communal stock. This is a playable staged conversation and fieldwork quest, not a bespoke cinematic or a new political simulation.

Personal progression audit: Handworks saves miner/mason/forester/smith counters. Mining awards productive faces; processing awards masonry/forestry jobs. Strong shoulders unlock at 12 miner faces or 8 masonry/forestry jobs; Miner 40 adds controlled section work and cart capacity. The smith counter has no comparable developed branch yet. Technology has nine existing prerequisite-linked methods. Neither is currently a comprehensive personal skill tree. Preserve counters when designing the next progression pass.

New test: ancestral70 in the full gameplay and exact-pack gates. It exercises actual excavation/path connectivity, walking evacuation, mid-rescue saves, evidence prerequisites, local-only interactions, appointment, investiture and old-claim preservation. Verification results must be recorded before release.

# 0.64.0 candidate — First shift and final civic polish

Continue from polish/keldrath68 / PR #11. Pre-edit local tag pre-firstshift69 and recovery/pre-firstshift69.bundle preserve e928483c79f8ff112ba509c027f1344d10d0c5ec. Do not overwrite earlier bundles or force-replace remote history.

FirstShift extends the existing Ivar commission owner, retaining its original panel. The real hold mine now establishes loan Handworks benches and a separate hold-owned crew bay once, without replacing occupied equipment or excavated terrain. New worlds have a larger clear entrance bay; old cell arrays are preserved. The lesson records actual lifting, stocking, processing, collecting and construction events in existing Handworks saves. Ivar can explicitly issue a once-only timber allowance in person. Crew stock, work orders and output remain hold property; no early Lord authority or public reserve access is implemented.

The two painted workers move finite raw records through a real rack and breaker, then rest. This is a bounded demonstration, not a new economy or renewable giveaway. Player benches exclude hold-owned inputs. Visible facility bases participate in player/navigation collision; work approaches go around them. Soft authored lamp pools and restrained vent motion finish the civic composition. Fake inventory-mirroring mine storage art and overlapping context bars were removed.

Run suite firstshift and the exact-pack checker, which now includes the practical introduction. Review all wards, mine work and the J lesson. Source tests, package verification and release publication must be recorded before claiming delivery. The earlier hosted civic gate was cancelled, not passed. v0.63.0 remains the last published build until the new release is verified.

# 0.64.0 — The Hold of Three Hearths (source verified)

Work branch polish/keldrath68; start local 84141d65c35c4bed6f593d736dbfb096b50674dc, remote main 2130a077612d3a70c0e67e01ac4db2c30539f97f. Pre-edit tag pre-keldrath68 and verified incremental recovery/pre-keldrath68.bundle preserve the baseline; previous backups are untouched. Never force-push restored local history over GitHub.

Read CURRENT_STATUS and testing/civic68.md. HoldWardDesign owns authored ward pockets, stable distant painting and cached stone paving. HoldCivicArt owns original atlas crops and exit side geometry. Furnishings shares new prop art/cost/footprints with player construction. Surface adds fixed freight storage using existing chest records, notices, and restrained interaction cues. Latest user direction: reduce captions; architecture must communicate doors and routes. Preserve the approved player gait and functional Great Stairs.

Run suite civic and the exact-pack checker (now includes civic68). Verify Ivar's escort after moving the quarters lamp away from his route. Test freight deposit/reload/recovery from a valid approach, five interior exits, all wards and resident/public routes. Native visual captures are local QA artifacts, not runtime assets. New art provenance and exact prompts live in assets/hold-kit68.

Native source verification passed all 315 checks. A clean Windows export passed the audit of all 3,165 packed entries; all 161 exact-pack gameplay checks also passed. Local verified-civic68 and recovery/verified-civic68.bundle preserve this source/evidence, requiring pre-keldrath68 / 84141d65. GitHub PR #11 preserves runtime e9fc82ac86bfea87f9cc68e25639923c1bcae14f; all 34 changed paths match local blob hashes. Hosted validation 39671981253 is still pending; do not claim it passed or merge before checking. No new release is published. Publication remains pending. GitHub main and v0.63.0 are the previous verified delivery. Large image transfer is isolated on an asset branch; verify content hashes before using binary blobs in the runtime tree. Do not include transfer chunks in the game branch.

# 0.63.0 — Living terraces (published and verified)

Published v0.63.0: one complete Windows ZIP at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.63.0. Release source 472e12bf47c0784c84f3e763da7778dc9cbe740e; hosted run 39656676389 passed all publication gates. The uploaded ZIP is 701,152,760 bytes and SHA-256 f273ba088776f8a8bd52ae56ae7c941d3b2c68ff614cd34b98791734ee975eb3; both match the clean hosted build report. Tag target matches the build source. See testing/living67/hosted-build.json and delivery.json. Earlier releases are preserved.

Base milestone PR #8 merged at 09666eaf2ba6f06598b3f0ac52249615243d3be2. Final visual review caught an adjacent-ward resident hidden by shared stair artwork; PR #9 corrected foreground sorting without duplicate actors or ownership changes. Full corrected source gate 39656307242 passed all twelve gameplay cases and import; PR #9 merged at e8a62f08f9ea6a950ba0176bc0bd071927292707 with an identical runtime tree. Native correction checks: 51 passed. The corrected local exact PCK passed 97 checks; the hosted exact-pack ambient, continuity and living cases also passed. Earlier local packages are superseded.

Continue from GitHub main. Local recovery tag verified-living67-delivery and the new verified-living67-delivery.bundle preserve final source/evidence, requiring pre-living-hold67 / 1401303d8bfd0bda6ccd4e8a30244580aae49f3a. Earlier verified-living67-visibility / 13f1043dce58845757b76103233b04e7d1bda8a7 and all previous bundles remain intact. Local restored history differs from GitHub; never force-replace remote history. The persistent release tag preserves the complete published source.

HoldTerraces connects three saved wards in continuous projected space (stride 1740), preserving camera/gait and loaded carts across normal movement. HoldRoutines compiles nine home/work/tavern journeys per seed, samples saved elapsed time and releases navigation grids. Only active/visible adjacent architecture and residents draw. Public rovers and story hosts retain previous behavior. HoldRoomLayout owns the larger forge; HoldMasonryArt uses assets/hold-kit67. Carved pillars and low workshop tables share the existing build/collision/save catalogue; tables are decoration, not another processing system.

Preserve the approved player walk: only preparation changed, not player artwork/descriptors. Distinct interiors, service stairs/lift, mining, forestry, economy and save schema remain. This is bounded terraced architecture, not arbitrary 3D occlusion or a complete population/economic simulation. Read testing/living67.md, testing/living67/visibility.md and PLAYTEST_GUIDE.md. Windows hardware/audio and artistic acceptance still need the player's machine.

Release orchestration prepares the package while an identical-source gate runs, requires successful source and exact-pack tests before publishing, and allows 55 minutes for cold import and verification. Earlier publisher runs were intentionally cancelled before publication. Large art transfers and a transient local exec interruption were recovered; no previous backup or release was replaced.

# 0.62.1 session handoff

Published release v0.62.1: one Windows ZIP at https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.62.1. Release source 7c51669f17b94ceb835b99fa9572f03e75cad880; hosted build report and published digest are verified in testing/continuity66/hosted-build.json. The release job completed all gameplay and exact-pack gates. Continue from GitHub main; preserve the player walk and this release.

Runtime merged through PR #6: 285a2bc41c827b415a51ce3c284e3335b5342d43. Full hosted gameplay validation 39611887147 passed. Work: polish/continuity66. Verified starting remote main: a669d925f27f6f04b9bffdae88efafc72cf9ddac (0.62.0); hosted validation 39497203974 succeeded. Local pre-continuity66 preserves the restored baseline d720885 and all older recovery bundles remain untouched. Remote history must not be force-replaced by the local restored history.

Read CURRENT_STATUS and testing/continuity66.md. New personal story: letters.gd, surface points, onboarding journal. Facade rectangles and lower-floor projection: world_zones.gd. Stair geometry and residential layout: hold_neighborhood.gd; timed traversal and bedside approach: surface.gd. NPC-only passing keys: assets/town-walk66 and the town_walk descriptor; normal player/core/motion assets are unchanged. The user's latest instruction explicitly approved the player walk and identified townsfolk as the problem. Do not replace the player walk.

Verified source checkpoint: remote 7d7e7d75c4e07de37ed49b0c1817441f48b5158b (PR #6), local verified-continuity66 / aa75c504. All 46 changed remote paths matched local Git blob hashes. 254 distinct source checks plus 35 final repeats and 46 exact-pack checks passed. Incremental recovery bundle verified without replacing older backups.

Run tools/check.py suites continuity and locomotion; exports additionally use tools/check_pack.py from empty working/save folders. Include town-walk66/frames.json in exports. Bump HoldBuild.VERSION for any later art/cache changes. Cutaway cost is bounded to one adjacent ward's clipped facades, with no second viewport or NPC simulation. Further continuous floor occlusion/architectural overlap remains backlog.

Windows release workflow builds only a deliberate release/<version> branch. It verifies the official runtime hash, full gameplay, PCK inventory, ZIP integrity and exact exported gameplay before creating a new versioned release. An already successful full source gate can be reused only after tracked-file equality is checked (documentation and release orchestration excluded); a running matching gate is awaited. It refuses to replace an existing release. No personal saves or credentials belong in the repository.

# 0.62.0 source handoff

Current branch: world/keldrath65. Pre-edit local tag pre-keldrath65 preserves 31dd944; prior modular PR #4 passed hosted CI and merged at a5535e144e298756016152eaa289d3f6ad8dfc11. Older releases and source bundle remain untouched.

Read CURRENT_STATUS and testing/hold65.md. hold_neighborhood.gd owns residential coordinates, homes, stair rail geometry and resident schedules. world_zones.gd integrates those with existing wards. floor_pattern.gd caches original continuous wood/stone meshes and restrained surface grain. surface.gd handles household room links, correct upstairs exits, expanded ward bounds and interaction priority. New IDs are additive room:folk_<ward>_<family>_<floor>; existing save schema, inventory and claimed construction are unchanged. Area IDs carry household level; HUD reports ward-relative absolute Z.

Run tools/check.py --suite hold with isolated native saves. New full gameplay case: tests/hold65.gd. Building bases are explicit physical footprints; painted roofs remain occluding/fading art. Private legacy houses are still closed; nine added family homes are enterable. Resident routines are simple deterministic street/hearth cycles, not a full job/day simulation. No Windows release exported for this source milestone.

# 0.61.3 source handoff

Continue modular placement work on polish/modular64; pre-modular64 preserves local 0.61.2. Read CURRENT_STATUS and testing/modular64.md. Shared grid/footprint renderer: scripts/build_preview.gd. Furniture validation/repositioning: surface.gd. House eligibility: hearthcraft.ready_to_build. Equipment eligibility: handworks.placement_ready. Native gate: tools/check.py --suite modular. Keep previews and commit rules aligned, and preserve chest record identity during moves.

This is an incremental building/collision polish pass, not acceptance of every outstanding animation/art issue. No new Windows release yet. Existing v0.61.2 remains available. Update branch/PR status after integration; do not replace older releases.

# 0.61.2 handoff

Continue from GitHub main. PR #3 merged at `d539cb535fad79fb2bd141ed73e5c3a848ad9bf0`; release `v0.61.2` preserves complete runtime source `4169069d9f80e6fae3dc33deee855c8b16a13916`. The clean local build used `1ab53f235b345ae7a1d5520962fa2ef20d920b95` with matching runtime files. Local `pre-loading63` preserves the prior checkpoint; older releases and the complete foundation source recovery bundle are untouched.

Read CURRENT_STATUS.md, DEVELOPMENT.md and testing/loading63.md. AGENTS.md applies. Title/loading implementation: scripts/loading_view.gd, main.gd and whole_frames.gd. Metadata is HoldBuild.VERSION 0.61.2. The loader uses existing original Keldrath art, job-count progress and a short completion fade. It sits on canvas layer 100 above Ivar and all menus. Existing input/scene gates are retained.

Animation PNGs are derived cache data under user://animation-cache/<version>/. **Bump the build version whenever source artwork, frame metadata or recoloring logic changes.** Do not change or delete saves to clear caches. Cold preparation, engine startup and synchronous world generation remain performance follow-ups. New-character creation randomizes from the canonical appearance/name pools; defaults() remains stable for save migration, and wardrobe mode retains saved identity.

Verification: 190 existing gameplay checks plus 19 final feature checks; the same 19 checks passed against the exported pack. Hosted gameplay CI also passed (39484028846). See testing/loading63 for screenshots, logs, regression summary and build metadata. The initial 11-check loading case was superseded by the 19-check case and is not counted twice. All 3,134 PCK entries and ZIP integrity passed. GitHub asset size/SHA match local. Native Windows and audible mix have not been tested.

Use tools/check.py with tests/suites.json, sequential native rendering and isolated save data. tools/build.py exports one complete Windows ZIP using the pinned official runtime. Full editable source is in GitHub; do not rerun the one-time import workflow or rewrite release tags. Earlier complete bundle remains in release foundation-0.61.1. Further changes should use focused branches and regression evidence.

