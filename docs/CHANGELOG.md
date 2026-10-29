# 0.87.0 — A place to begin: Windows playtest delivered

Title → First visit to the hold → choose an empty normal save slot and create a Dwarf. Five small tasks teach movement, pack, lifting, stocking and real bench work. A one-time repair allowance introduces the old cutters’ bay; longer optional ambitions track Ivar’s reference, charter, hold and ship. Guidance can be paused. Standard new fortunes and existing saves retain their original openings.

Clean Windows ZIP: firstvisit99-final-build/Stellar-Holds-First-Fortune-0.87.0-playtest-Windows.zip (767,260,893 bytes; SHA256 648425881202d385384b693c5b4a66d4a6b7b65023e7253d193d5a144d0661ea). Local runtime cf43450ddc71752ff359be88181d252b6c69c4b9 and hosted c425c183caa36c087a725972aadd96f72534b88c have identical tree 564da75096587cbd8ea2eb7fd3a5ca1b050b874c. Draft PR #67 contains the earlier expedition/workplace previews too; not merged or stable-published.

Focused native checks passed 131 assertions; final exported ambient and first-visit cases passed 33. The immediately preceding export also passed workplace98’s 23 assertions. Final one-line journal cleanup is covered by exported first-visit input/save/delivery tests. Title, slots and journal captures reviewed. All 3,351 PCK entries and the complete ZIP passed integrity checks. Human pacing/enjoyment and Windows hardware/audio remain playtests. See testing/firstvisit99.md and testing/firstvisit99/preview.json. Keep previous backups and previews.

# 0.86.1-preview — The old cutters’ bay

- Discover an abandoned bay, reopen its supply passage and restore its hearth with ordinary construction.
- Odrin follows real routes, processes real raw stock, takes a midday break and responds to lost access or heat. Work history and material ownership persist.
- Includes a separate test save; existing mines and normal fortunes are preserved. This preview includes the expedition prototype and is not a stable-release replacement.

# 0.85.1 — Workbench clearance

The Mine views & depth routes test bench now has room for the dwarf to hammer. Hold **E** beside a supplied stonebreaker to approach its working position and process the chunk; finished materials go straight to your pack.

New bench placements require a clear working position. If an existing bench becomes obstructed, its prompt explains the blockage and its unfinished input stays safe. Clear space behind and beside it, or return the unfinished input from Shift+B before recovering an empty player-built bench.


# 0.85.0 — A Dwarf’s Eye View

- Mine exploration now defaults to captured mouse-look: continuous orbit/tilt, camera-relative WASD and dodge, central reticle aiming and wheel zoom. Close zoom uses shoulder framing.
- Alt frees the cursor. Books, survey, construction, window focus loss and leaving the mine release capture. Held UI clicks cannot become attacks on returning to play.
- F7 adds mouse-look/free-cursor choice, sensitivity, invert vertical look and reset. Settings persist separately from fortunes. F6 still restores traditional overhead; RMB remains guard/parry.
- Camera turns update existing wall cutaways without rebuilding terrain batches every frame. Original sprites, gameplay, saves and zero-energy combat remain intact.

# 0.84.0 — Depth & Perspective

- F6 toggles traditional overhead and mine exploration with painted 2D characters in 3D terrain. Brackets rotate the camera; movement, dodge and mouse targeting follow the view. The choice is remembered separately from your save.
- Z opens a paused floor map with D1–D5 browsing, adjacent explored-floor ghosts, stair markers and gold routes through actual known passages. Cart routes respect ladder restrictions.
- Mining, encounters, cargo, stairs and save data use the existing simulation. Workstation prompts, geological survey and enemy warnings remain visible. Precise construction temporarily returns to overhead.
- Dev Testing adds a separate two-floor exploration preset. The prototype covers mines; towns and interiors retain their existing views. Combat still consumes no work energy.

# 0.83.0 — Steel in Your Hands

- Individually saved weapon/armor pieces and equipped selections; legacy owned gear migrates at unchanged strength with an exact rollback backup.
- Forge standard or tempered equipment at Borin’s workbench. Precision forging and additional materials unlock +6 weapon damage or +8 protection points; previous pieces stay owned.
- Gear shows material, workmanship and stat differences; forge previews compare both grades before paying.
- Work energy never gates combat. Drawn weapons suspend background hauling/handwork drain; zero-energy attack and defense regressions cover the live combat controller.

# 0.82.0 — The Hold’s Handbook

Menus now share a warm parchment frame and a consistent tab bar: Pack, Gear, Skills, People, Craft, Journal, Map, Calendar and Options. Page Up / Page Down changes tabs; the familiar I/B/Y/N/J/G shortcuts and Escape still work.

The pack uses compact item slots with quantities, search and a selected-item panel for pinning supplies to slots 6–0. Skills open to a progress overview, then reveal techniques and research when selected. People combine portraits, relationship progress, known tastes and location actions in one directory. Conversations sit lower on screen with a painted portrait and ordered responses. Gear uses side-by-side cards, and Craft offers a recipe catalogue without bypassing workstations.

Existing artwork, supplies, purchases, skill requirements, local NPC interactions and saves are preserved. The design takes inspiration from Stardew Valley’s menu organization while retaining Keldrath’s own characters and systems.

Extract the complete Windows ZIP into a fresh folder. Windows hardware/audio and subjective readability need hands-on playtesting.

# 0.81.0 — The Turning Year

The hold now keeps a saved clock and calendar: a 40-minute active day, four 28-day seasons and a repeating year. Click the date beneath the location heading, or open Calendar from your pack or Energy menu. Browse seasons and select dates without advancing time.

Outdoor light moves smoothly through dawn, daylight, dusk and readable blue nights. Lamps give a soft warm glow. Interiors, Keldrath's underground wards and mines keep their own lighting; services remain available at night.

Sleep at a bed until 08:00, or nap for two game hours. Planted crops and every queued crafting recipe advance while you rest. Manual work, actors and combat are not simulated during the skip. Crops never wither when the season changes. Energy recovery remains forgiving, with no forced collapse or offline fatigue.

Four annual celebrations last three days each: First Hearth (Spring 7–9), Forgefire (Summer 14–16), Barleywake (Autumn 21–23) and Ancestor's Vigil (Winter 26–28). Visit Hedrik's welcoming table at the Copper Kettle or the serving counter at Wayfarer's Hearth to share a feast and toast. Existing tables carry seasonal dishes and ale. Each celebration gives a remembered journal entry plus modest food and work comfort once per year. Missed invitations stay available after the holiday; there are no entry costs, expiring rewards or required chores.

# 0.80.0 — Supper & Slumber

Work energy, active-time tiredness, diminishing food recovery, hold ale and bedside sleep/naps. New saves and old fortunes begin rested; no offline fatigue. Zero energy slows demanding work by 20%, without restricting movement or combat. Click the Energy HUD or open it from the pack. Calendar, holidays and day/night remain future work.

# 0.78.0 — Grip, Guard & Craft

- Whole axe/shield poses for all fourteen saved identities; consistent combat weapon, forearm grip, guard and impact states; shared Borin practice poses.
- Eight original hammer crops now include the whole hammer head instead of clipping it into a blade-like sliver.
- Six independent roadside furnishing components with shared art, costs, previews, collision and save behavior.
- Depth-sorted roadside signs stand clear of portal approaches; decorative crates and barrels are explicitly labelled.
- Dedicated native visual, combat-state and decor transaction regression case included in source and exact-pack gates.

# 0.77.0 — Stone, Timber & Tradition

- Three compatible architectural collections with independently selectable masonry, roofs, trim and floor finishes.
- Proportioned annex walls and windows; complete original façades preserved; extra floors use set-back upper rooms instead of arbitrary image slicing.
- Painted oak, basalt and granite floors, matching room walls and perimeter detailing.
- Visual plan, furnishing and structure catalogues; real building previews, explicit material studies and transactional refinishing.
- Additive saved finishes preserve rooms, stairs, furniture, storage and paid shell recovery.

# 0.76.0 — The Builders of Keldrath: published, verified and merged

All 22 prepared designs now share plans, exterior rendering, room geometry and player furnishing components. The Building Book offers furnished plans or empty shells, editable interiors, side/rear bays, five connected floors, rename/relocate/recover, private storage and real household/workshop services. Original painted fronts and household identities remain intact. Eastern building grounds have matching river/cliff boundaries. Existing construction and normal/test saves are preserved; older saves receive an exact pre-architecture backup.

Runtime source ff840c816d451e75babaf1fecdc3c776c8b8a1e2 and PR #43 merge 6ff9dc03b56624903d46debdd79990d8b1de97c9 share tree 2ae39e202456a24fab98af2df25f8d286a28fb72. Local native architecture verification passed 301 assertions; seven focused cases passed 343; the five-storey keyboard walkthrough passed 20. Original/player buildings, furnishings, menus and the eastern river boundary were visually reviewed. Source run 40249460487 passed all 30 gameplay cases plus people-preview.

Release run 40249459330 passed the package audit and all 20 exact-export cases (1,550 assertions), including all 301 architecture checks. Exported catalogue and royal-hall captures were reviewed. Downloaded build report and verification evidence match their GitHub digests; verified source, clean build report and uploaded ZIP metadata agree.

Download: https://github.com/tylerhamilton888/stellar-holds-first-fortune/releases/tag/v0.76.0
Windows ZIP: 729,897,845 bytes; SHA256 1478b9f514d8e050de5e7160727fb368b110fdb5bd4b7e7a5fedc1610a588cf4. Extract the complete archive into a fresh folder. Windows device performance/audio remain hands-on testing. Painted façades remain reusable architectural styles; arbitrary per-window façade editing and NPC business/household assignment are not added here.

Try Title > Dev Testing > Construction & decorating. F9 offers the Building Book and eastern-grounds shortcuts. In normal play, O on the claim opens home improvements and the book; O inside a player building opens renovation. E uses stairs; Shift+E descends. Reopen F9 after a test-location shortcut.

Verified local architecture86-ground-verified.bundle and confirmed remote recovery/architecture86-ground-verified preserve the runtime source. The incremental bundle requires cf6fe48459d6c9a5c44707b57c1cb35c5c1ea25e and 217991b75e3878d047e643fba4097dcfcdc323a9, retained in the full dev-testing85-native-verified.bundle. Preserve all earlier backups/releases. Delivery documentation is separate from the verified runtime. See testing/architecture86.md.

# 0.75.0 — The Testing Grounds: delivered

Added four standalone title-screen testing presets with immediate locations, unlocks and supplies: combat, construction/decorating, mining/workstations and farming/fishing/cooking. F9 inside tests exposes reset/restock, enemy selection and hitboxes, building/work plans, and garden/river/kitchen shortcuts. Existing gameplay rules are reused. A dedicated marked test save preserves all normal slots; normal gameplay does not expose the test shortcut. One build flag hides the temporary entry points.

PR #41 merged after native visual review, 80 focused local assertions, all 29 source cases plus people-preview, and 19 exact-export cases / 1,249 assertions. Release 0.75.0 is published. See CURRENT_STATUS.md and testing/dev-testing85.md for source, evidence and hashes.

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

# 0.71.0 — Beneath the Stone Crown

Expanded royal hall; consistent royal walking and sit/stand poses; top-down audience in the actual room. Mounted trade signs, bedrock surroundings, fitted architectural texture crops and a north-wall King’s Gate replace floating labels and detached scenery. Existing progression, saves, households and Great Stairs preserved.

# 0.70.0 — Hearth & Homestead (candidate)

Four forgiving crops with soil preparation, planting, watering, optional tending and readable growth. Three fishing locations with local catches and forgiving bite feedback. Four shared meals connect home comfort, ordinary provisions and modest temporary benefits. Hearthkeeping plans and three mastery techniques reward useful work. Orla trades all ingredients and meals; Hedrik offers one optional welcoming-table favor. Existing garden timers, saves, artwork, industry and quests are preserved.

# 0.69.0 — Stone & Hearth

- Nine distinct household fronts, resident nameplates and individual room arrangements across the three wards.
- Separate survey office, foreman's office and practice hall artwork.
- Monumental structural piers and practical street drainage reinforce the mountain hold.
- Hall of Names opens the former unused Crownward frontage with a household register.
- Hedrik and Orla share upstairs quarters and one proper double bed; family upper rooms gain double beds.
- Existing room IDs, doors, resident routes, saves, characters and work systems remain compatible.

# 0.68.1 — Honest Work

- Removed the redundant player bucket and legacy rock overlay while retaining saved cargo.
- Redrew five fixed work props with level front edges and upright supports.
- Completed player bench output enters the pack automatically; E recovers older bench output.
- Preserved storage ownership, unfinished jobs, yields, mastery bonuses, saves and approved character artwork.
- Updated the first-shift lesson and work prompts for automatic collection.

# 0.68.0 — Roads & Hearths

- Walk through path edges, mine arches and real doors; optional directions keep control in the world.
- Stonebridge wayside services and mine staging, Pinewood loan processing, Greenhearth allotments and farm services.
- Real local deliveries, cooking/storage/rest and canonical local residents.
- Existing artwork, excavation, saves, resource ownership and earlier releases preserved.
- Full cold validation and release budgets expanded; all existing verification and publication gates remain enforced.

# 0.67.1 — Familiar Faces

- Town contacts inherit current canonical beard/hair corrections instead of old PNG paths.
- Shared whole-character previews and generic NPC rendering; creator pose and turn controls.
- Measured hair pigment and passing-pose scale calibration, two complete walk redraws, and corrected greatbeard utility crops.
- Versioned derived cache refresh; saved identities and gameplay systems remain intact.

# 0.67.0 — A Good Day’s Work

- Outdoor equipment has solid bases and reachable work poses; woodcutting stops when moving or blocked from its stance.
- First-shift prompts explain the current physical task, timber allowance and material ownership; placement previews show nearby compatible stockpile connections.
- Starting quarters support eight existing furnishing plans, safe placement, moving, recovery and persistent comfort progress. Bed, chest and letter remain physical interactions.
- Interaction queries avoid repeated obstacle reconstruction; rooms warm only relevant residents. Compatible animation caches survive ordinary releases, and bulk chest transfers save once.

# 0.66.0 — Hearth & Stone

- Shared complete side-walk passing poses and shorter distance-calibrated stride.
- Honest building front draw order, painted roof/side/rear volume, bedrock boundaries.
- Purposefully grouped domestic furniture and original woven rugs without resizing saved rooms.
- Selected peer tabs, Skills navigation, pack search, keyboard scroll and consistent personal-menu pause.

# 0.65.0 — Work & Knowledge

Thirteen discipline tabs are integrated into the existing game. Open with Y, the inventory, pause menu or Survey Office. Y deliberately leaves underground U unloading and T crew assignment intact. The menu pauses play, keeps its discipline tabs separate from the scrolling details, supports keyboard focus and uses thirteen original vector emblems. Each technique displays its effect, work threshold, research and prerequisite. Learning retains lifetime experience; there is no universal spendable XP currency.

Twelve paths have live work sources; Brewing is explicitly reserved for a future dedicated work loop, with no fake unlocks. Thirteen optional techniques improve physical recovery, processing output, production efficiency, farming/fishing yield, dodge recovery, crew capacity or cart capacity. The eight existing research methods are also shown in their relevant paths and still unlock the existing equipment, construction and industry. Existing research costs and access remain intact. This is an expandable first tier, not a complete endgame tree.

HoldDisciplines owns definitions, eligibility, one-time migration and saved progress in hauling.disciplines. Completed-work hooks stay in gameplay owners. Legacy Miner/Mason/Forester/Smith counters and automatic hauling unlocks remain; the historically combined forestry counter seeds both Forestry and Woodworking once. Existing harvests, catches, cleared threats and crew counts receive credit. New sawing awards Woodworking separately from felling. Overseer mastery is separate from civic appointment and grants no communal stock permission.

Pre-edit local tag/bundle pre-disciplines71 preserves e5759a89376a3d1e08fe0c5c5ef616ca264d37c4 (bundle requires pre-ancestral70). GitHub recovery/pre-disciplines71 preserves remote main 87cc8846a8681e044230ed2853680041927aa072. Old releases and backups remain intact. Read testing/disciplines71.md for verification status. The published Windows release remains v0.64.0 until separately verified and published.

# 0.64.0 — The Hold of Three Hearths

- Kept conversation responses inside the scrollable panel so research and investiture choices stay accessible.
- Added The Stone Remembers: physical crew rescue, evidence-based tablet research, ancestral Overseer appointment and development-gated investiture as Thane. Existing claims and communal ownership are preserved.

- Added a practical mine lesson with loan benches, player-excavated loads and real stockpile/processing/construction steps.
- Added a protected hold crew work order; hold stock and output are unavailable to the player. Ivar may issue a small explicit timber allowance.
- Matched mine equipment bases to collision and improved automatic work approaches. Added soft ward lighting and subtle industrial motion.

- Composed the existing wards around an oath court, common hearth and iron terrace; added household details and original distant mountain works.
- Added shared craft/place catalogue art for a memorial, orrery, notice board, pressure display and training rack. Freight chests retain real contents through existing storage saves.
- Reframed interior exits above the hotbar with painted open thresholds and physical side leaves.
- Removed automatic floating door/name/destination captions and large interaction rings; retained nearby E cues, contextual HUD and guide.
- Kept Great Stairs, NPC routes, existing quests, player walk and previous save progress.

# 0.63.0 — The Living Terraces

- Connected all three Keldrath wards with continuous walking along painted Great Stairs; preserved camera, gait, saves and loaded handcarts at crossings.
- Added deterministic home/work/tavern journeys for nine household residents, using actual doors and stairs and the saved world clock.
- Enlarged Borin's workshop interior and exterior wing with shared masonry, modestly scaled benches, storage and painted work poses.
- Added craftable/placable carved pillars and low workshop tables through the existing furniture system.
- Updated directions and quest markers; kept enclosed service stairs and lift shortcuts, existing stories, player art, mining, timber and industrial systems.
- Kept adjacent-ward residents visible on shared stair flights without duplicate drawing or changes to saved ownership.
- Published one complete verified Windows ZIP; preserved all previous releases and recovery points.
- Added native route/contact/export coverage; fixed tutorial test timing to wait for the visible loader after skipping the escort.

## 0.62.1
- NPC-only whole-character passing poses; shared distance-based gait, preserving the player walk.
- Solid facade wall coverage and collision-checked streets/door approaches.
- Bedside access and an optional, persistent first letter home at writing desks.
- Visible stair traversal at matching Z landings; lower-ward architectural cutaways.
- Verified single-ZIP Windows delivery with official runtime and exported-game gates.

## 0.62.0 (source)
- Extend all three Keldrath wards with bridged residential galleries and additional inter-ward stairs.
- Nine furnished family homes with connected upstairs rooms, persistent location and distinct neighbors.
- Align painted stair rails and physical footprints; block shaft edges; prioritize doors over passing citizens.
- Check building sides/corners, bridge movement and all household entrances/returns.
- Replace repeated floor-atlas strips with continuous staggered timber/stone surfaces and subtle grain.

## 0.61.3 (source)
- Build-only snapped grid, translucent preview and green/red placement footprint.
- Material/access-aware construction previews, including house route protection.
- Move owned furniture and filled storage chests without rebuilding; tighter storage rows.
- Shared tea-table/counter dressing for town and player furniture.
- Wall-slide facing follows actual travel and blocked movement stops walking.

New fortunes now begin with a randomized editable Dwarven name and appearance; existing characters retain their identity.

## 0.61.2
- Current whole-character title artwork and clearer menu labels.
- Illustrated preparation screen, rotating hints and actual job progress above HUD/cutscenes.
- Versioned on-disk prepared animation cache; unchanged save format.

# 0.61.1 — Development foundation

Behavior-preserving menu presentation extraction, canonical native fixture and current suite manifest, single build metadata source, repeatable checked packaging, concise contributor/testing documentation and completed GitHub source import/CI. 201 local passing checks including exact exported pack; source migration, clean-checkout validation and hosted CI completed; details in CURRENT_STATUS. No art, mining balance or save-schema changes.

# 0.61.0 — Life in the Hold

Escort loading/timing fix; clearer distance-based citizen gait; painted fire animation shared by crafted/town hearths; animated fountain water and removed plaza outline; Orla Copperkettle. 87 current checks passed. See testing/ambient61.md.

# 0.60.0 — 2026-10-20 · Faces of the Hold
- Fifteen complete painted portraits matching current identities, including the enthroned Lord.
- Saved natural palette rendering before filtering; corrected dark-hair/skin fringe while preserving coloured clothes.
- Unified creator/dialogue/roster/story portraits. Current whole figures replace retired audience actors.
- Fresh Windows export includes the completed whole-character motion work. Native portrait, gameplay and exact-PCK checks passed; verified recoverable checkpoint. No save or gameplay balance change.

# Unreleased — complete equipped and shoulder-cargo motion

- Added four-key complete-figure gaits for all fourteen identities, four camera views and eleven equipment/supply/cargo states; stopping keeps the same artwork.
- Preserved full male beards and saved natural palettes. Repaired reviewed beard/braid/bun/topknot continuity and mixed-load ordering.
- Integrated actual supply contents behind painted tray rims/hands; kept physical load ownership, controls and save format.
- Added native eight-direction, pickup/drop/reload, palette and motion-capture coverage. See testing/motion59.md for the final results and boundaries.
- Preserved original paintings and all prior recovery points. This is an integrated source checkpoint, not a new Windows release.

# Unreleased — male beards and character quality

- Gave the moustache-only male a full beard across the active complete-figure poses; preserved saved sculpt identity and palettes.
- Corrected male axe strokes, selected topknot/cropped-nape/loose-wave continuity, a handling extraction fragment and the raised pick's neighboring tool fragment.
- Integrated 356 selected keys from thirteen new source paintings, preserving originals and prior rear corrections.
- Passed 97 focused native creator, movement, material handling, Pinewood, mining, stairs and save/reload checks. See testing/quality58.md for palette and native art evidence.
- This focused milestone does not close carry/gait or broader visual release gates; no new Windows build.

# Unreleased — selective animation refinement

- Integrated reviewed whole-frame rear equipment, bun/bob axe, spade, rifle-boot and fishing-recovery corrections. Preserved original sources and the verified hair palette.
- Repaired selected atlas extraction at real silhouette/gutter boundaries; attached rifle and fishing effects to drawn tool contours.
- Rejected duplicated-tool and inconsistent carry generations. Full animation release gate still fails; no new Windows build. See testing/refinement58.md.

# Unreleased — residual hair pigment correction

- Corrected purple source coverage for red-violet shadows and muted highlights. Resolve colors before resizing and remove mauve introduced by warm/grey hair-fringe mixing.
- Preserved painted sources, selected palettes and intentional purple clothing. Added full-sheet native color audit and corrected previews covering all identities/natural palettes.
- Previous delivered palette preview was faulty and is superseded. This correction does not close the existing animation release blockers or create a new Windows build.

# Unreleased — whole-character integration milestone

- Activated complete painted figures through the existing player/NPC/work/equipment/portrait paths, preserving all fourteen identity families and saved material palettes. No active separate-head fallback.
- Added original core, utility, handling and equipped sources plus correction sheets and exact prompts. Measured frame registration and extraction exclude neighboring fragments; corrected reviewed core boot clipping.
- Verified that source-purple hair becomes selected natural colors. Added required frame JSON to export configuration and marked the source title as development.
- Passed 98 native mechanical checks and captured core/equipment/interior/moving gameplay evidence. No terrain, save schema, balance or quest changes.
- **Not released:** carry continuity, hairstyle/facing drift, clipped/wrong source keys, material parity, tattoos, contacts and gait polish remain explicit blockers. This does not complete the requested polished animation replacement.

# Unreleased — whole-character art study

- User rejected .57's detached heads and skin-circle coloring; complete painted character frames are now the target.
- Added original whole male/female core studies, an eight-frame front correction study, native single-frame rendering/registration checks and review captures.
- Recorded remaining facing/foot-cycle/identity/action work. Production renderer and .57 playable remain unchanged; no new release or save migration.

# 0.57.0 — Drawn grips and compact Folk
- 48 complete equipped body/tool/hand drawings across two body types and four facings; removed active surface/mine/combat held-tool icon overlays.
- Shorter, broader bodies and corresponding drawn footwork; unchanged identity head scales and anatomical attachment. Corrected female collar overlap and stray rear-hair crop fragment.
- Raised-tool wind-ups pass behind the head, removing the clipped shaft/arm strip across faces and beards.
- Selected pack supplies in a small supported tray with finger/rim occlusion. Empty stacks show no false material; busy physical handling overrides selected equipment.
- Equipped turn/selection textures prepare during scene transitions. No inventory, mining balance, save schema, terrain or quest changes.
- Native input/gameplay, visual and exported-pack verification; recovery after .56 with all prior versions preserved. See testing/grips-0.57.0.md.

# 0.56.0 — Folk and furnishing repair
- Anatomical head/shoulder registration, face shading, stable idle/walk tool grip and complete mug/hand foregrounds. Creator portraits fit actual hair bounds.
- New drawn contact/passing boot keys across walking, carrying and pushing; matched boot scale/material, preserved fingertips and prewarmed texture cache.
- Shared transparent furniture catalogue for rooms, claim/home construction, previews, collisions, full building occupancy and exact refunds. Smaller separate mugs/kettles; accessible tavern counter and door routes.
- Pinewood uses a grounded remaining-trunk scale, shared raw-log art, staged depletion and actual fir-bark stump.
- Focused names/footer prompts reduce labels covering the Dwarf. Unique exact old-save backups; no mine/quest/inventory reset.
- Native gameplay/visual tests and verified incremental recovery; see testing/art-0.56.0.md for evidence and limits.

# 0.55.1 — Stable, solid cave landmarks
- Fixed JSON numeric-type mismatch turning crystals into oath pillars after load.
- Shared visual anchors/collision bases; actor depth sorting; movement, crew, reach and placement respect landmarks.
- Exact old-save backup, same-depth local recovery, preserved old stair/equipment coordinates.
- 235 completed source/exported checks and native visual review; see testing/landmarks-0.55.1.md.

# 0.55.0 — Working the Mountain
More substantial planted excavation and persistent fracture stages; physical ore/stone loads integrated with existing Handworks; full-yield field dressing; rack/cart batch gathering; mineral-aware stonebreaking and powered bench processing; useful lamps/supports, stronger Miner handling and controlled section work; continuous-lode notes. Fixed bench focus/stance and loose-cargo passage priority. Updated existing quest guidance. Exact pre-.55 save backup, 146 passing final checks, native visual review and new verified recovery artifacts. See testing/mining-0.55.0.md for scope and limitations.

# Reference-led Folk — 0.54.0
Updated 2026-10-19 UTC. Checkpoint `reference-0.54.0`. The verified pre-edit tag `pre-reference-0.54.0` preserves `packaging-0.53.1` at `5ac23fed34c03ac4f3a224bd158fbec9c54edd65`. Prior archives, tags, original artwork and saves remain intact. No remote was changed or pushed.

The October 19 user board is the new art authority. The integrated game now uses seven male beard/hair designs and seven female hairstyles, 264 registered drawn head/body/work keys, consistent palettes, held-tool sockets, supported single/double/mixed cargo and a newly seated Lord. Creator busts, dialogue and the live world share identity; enlarged previews use source-resolution art. Cosmetic marks and fittings remain available. Original source art is retained.

Dwarfs are smaller relative to doors, stairs and stonework. Unladen travel is 150 units/s, handcarts 135 and wagons 120. Walking keys and footfalls follow actual distance. Ordinary rock takes two deliberate contacts with the starting pick; soil one, coal two, iron three. Held mining repeats a 0.64-second cycle with anticipation, damage cracks and a short impact hold. The player plants their feet and is never automatically pulled into a new wall. Hard materials, steel progression, existing yields, five geological levels and saved partial damage remain. Pinewood has a matching 0.64-second axe cadence; workbench approaches and reach are aligned to the smaller Dwarf.

Keldrath has six new illustrated service facades and a great mountain vault. Existing door locations/quests remain. Visible tiles and citizens are culled, static footprints and per-frame citizen data cached, and an incorrect citizen route-wrap duration corrected. Small recolored poses are cached and prepared behind a short loading screen before controls resume. The surface header is slimmer; the mine hotbar leaves the depth label clear.

Native source checks passed: 35 integrated journey, 121 collision/navigation, 65 mining/identity registration, 32 workshop/material, 32 transport/tutorial/combat, 20 escort/settling, 5 old-save preservation and 45 geology/crew/automation checks (355 total). Creator palette/normalization assertions and native visual review also passed. See `testing/reference-0.54.0.md` for exact evidence, performance and exported-pack results.

Loading a pre-.54 save creates a unique byte-for-byte `.pre-folk-54-*.bak` before any autosave. Existing appearance indices map to the closest new designs; names, inventories, charter, quests, terrain, structures, storage, cargo and automation data are retained. The new selectors save independently. Original terrain is not regenerated.

This is a playable reference-art, scale, weight and performance milestone. It does not complete the requested larger connected overworld, all interior/prop modernization, a full armor wardrobe, eight authored work directions or new NPC production jobs. Some side work/pushing views are shared. Windows execution, audio balance and subjective visual/feel acceptance remain player checks. Known test-only shutdown resource-retention warnings are recorded separately from gameplay failures.

Recovery is a standard standalone Windows EXE/PCK ZIP plus incremental source and Git updates after .53.1. Preserve the .51 full baseline and .52/.53/.53.1 recovery chain. New recovery instructions include exact commit/tree/hash verification. The official Windows runtime remains byte-identical to the verified Godot 4.4.1 template. No editor, installer or batch launcher is shipped. The earlier Defender detection remains unresolved; current package checks cannot certify a Defender verdict.

## Resume here
Read AGENTS.md, ART_DIRECTION.md and testing/reference-0.54.0.md. `folk.gd` owns the active registered character renderer/cache; `frames.json` owns measured bounds and sockets. `drawn_animation.gd` routes active callers to it and preserves old source helpers. `deepworks_play.gd` owns planted mining cadence; `world_zones.gd` owns shared door/footprint layout and cached/culling presentation. Keep functional quests and passage coordinates stable while extending the world.

## Earlier releases

# Standard Windows release — 0.53.1
Updated 2026-10-19 UTC. Checkpoint `packaging-0.53.1`; baseline `pre-packaging-0.53.1` preserves `playability-0.53.0` (40185112021128584cdba21fc58ad914ca3c0b79). Prior archives and recovery files remain intact.

Packaging-only update after a reported Defender `Trojan:Win32/MalUri.A!cl` detection on the .53.0 ZIP during download. The trigger is unresolved; do not label it a confirmed false positive. The new build uses `FirstFortune.exe` plus `FirstFortune.pck`, removing the editor and batch launcher. Extract completely and open FirstFortune.exe. Gameplay, art, save paths and save format remain unchanged; only the displayed version changed in runtime code.

The official Godot 4.4.1 export-template archive and Linux build tool were verified against published SHA-512 sums. The shipped Windows executable matches the official release template byte for byte. A fresh source copy was imported/exported with no previous import cache. All 2,639 PCK entries passed path/bounds/checksum validation and were unpacked for local antivirus inspection. Source review found no process execution, shell launch, network API calls or native extensions. These checks are evidence, not a malware-free guarantee.

ClamAV 1.5.3 reported zero detections in 2,796 component/source/original-archive files and in a separate scan of the final download. Official daily signatures are dated October 11, 2026; they are over seven days old. This is not a current Defender clearance.

Native Linux **release runtime** checks passed title rendering, combat poses, working rest, new game, mine travel, exact stairs down/up, and depth/resource save-reload. Windows execution and Defender detection are not tested here. See `testing/packaging-0.53.1.md` for antivirus results, definition dates and the retained shutdown-warning boundary.

Recovery: standalone Windows ZIP, small source update and incremental Git bundle relative to .53.0. Source/Git recovery requires .51 baseline, .52, .53.0, then .53.1. No Git remote was changed or pushed.

## Previous gameplay milestone

# Connected work, clear footing — 0.53.0
Updated 2026-10-19 UTC. Recovery tag `playability-0.53.0`; pre-edit checkpoint `pre-playability-0.53.0` preserves `labor-0.52.0` (9762ca65e9e82608ec545b52b4c3c6dd97063ac6). The existing incremental bundle was verified before edits. Previous archives, tags, original art and saves remain. No remote was changed or pushed.

General handcarts and freight wagons now retain their identity, raw loads, processed cargo and hitch through connected outdoor routes and mine stairs. C parks/takes the handles; E remains usable at doors and landings. An empty-handed player can use a doorway beside a parked cart. Wagons park outside interiors; handcarts enter ordinary rooms but park before sparring. House stairs require parking; mine ladders reject attached carts. Handcarts move at 175 units/s, wagons at 155, unladen Dwarfs at 185. Existing mine wheelbarrows and their stair handling remain.

Settling-in keeps Ivar's actual street/quarters escort and the two practical tasks. The objective names the unfinished bed/chest step. Rest takes 1.1 seconds with a warm fade; moving cancels without healing or credit. Completion restores health, saves and advances the existing introduction sequence. Either task order, skipped/interrupted escort and progressed saves remain supported.

Borin's practice is now part of the ordinary top-down interior renderer, with the current drawn Dwarf, a marked sparring floor and a report bench. WASD moves in eight normalized directions; the mouse faces, held LMB repeats attacks, RMB guards in front, a short timed guard parries, and Q dodges in the chosen movement direction. Dodge uses normal collision. Amber arcs show locked enemy attack direction before contact. No stamina or practice injuries. Training requires three hits, a guard/parry and evasion of an actual telegraphed attack. E at the bench reports the lesson and unlocks the existing deeper encounter progression.

The same controller handles sparse persistent encounters below the first mine layer. Axe, hammer, carbine, ammunition, armor reduction, salvage and rescue use existing equipment/economy data. Walls stop attacks; rear attacks bypass guard; hammer/riposte stagger; menus pause combat; rapid guard tapping cannot continually reopen parry. Wounds and cleared IDs persist, and cleared encounters do not respawn. Enemy sites are deterministic and stored per geological layer. Legacy combat progress is retained under its original IDs. The hotbar names the drawn weapon and gun ammunition without falsely highlighting a tool. Combat advice has a contrasting background. Existing enemy frames now use measured sprite bounds, removing adjacent-frame fragments.

Validation: 142 unique gameplay/model assertions across focused loops (32), intro (20), weapon edges (10), complete world journey (35), and existing Deepworks/crew regression (45). Native Linux Godot 4.4.1 input/rendering, real save/reload, screenshot review and exported-pack boot. See `testing/playability-0.53.0.md`. Windows execution, audio balance and subjective feel remain player acceptance checks.

Recovery: standalone Windows ZIP; incremental source ZIP and Git bundle relative to .52. Source/Git restoration requires the preserved .51 baseline plus .52 update, then .53. Exact restoration and hashes are in `Stellar-Holds-0.53.0-Recovery.txt`; previous versions are not overwritten.

Boundaries: transport uses existing player collision and authored passages, not full wheelbase/turning-radius physics. House stairs do not carry carts. Guard/gun ready poses and hostile creatures reuse existing art; this is not a new eight-direction combat animation set. New raw-station/farm NPC jobs, convoy routing and additional enemy types remain deferred. Existing automation and unrelated labor systems remain intact.

## Earlier milestones

# A Place to Begin — 0.52.0
Updated 2026-10-18 UTC. Recovery tag `labor-0.52.0`; baseline `pre-animation-0.52.0` / `labor-0.51.0` at `c02adc0bf08c34b064a1ba21f1108a00579c7f17`. The baseline full-history bundle was verified before edits. Prior tags, archives, original assets and save formats remain. No remote was changed or pushed.

New fortunes retain the illustrated arrival, then meet Ivar at King's Gate in the actual top-down hold. He leads the player along clear streets to the existing northwestern workers' quarters, explains the wards and local routes, walks inside, identifies the bed and personal chest, and departs through the door. Dialogue advances with Space/Enter or the button; Esc skips the walk safely. The camera follows the two actors; gameplay prompts and held tools stay out of the scene.

The first objective is now to rest at the bed and check the chest, in either order. This unlocks the existing Borin/Orla/Hedrik introductions, then the coal commission. No supplies must be spent or stored to complete orientation. The borrowed chest persists independently of the claim cottage and cannot be dismantled. Pending escort and settle flags live under existing `outpost.onboarding`; a save interrupted during the walk resumes it. Existing progressed saves without these flags retain their stage, pack and world.

Movement uses drawn contact/pass/recovery leg keys registered to drawn torsos, with fresh side/rear walking bodies and four-view single/two-shoulder cargo poses. Customized heads and hair remain intact. Gait and footsteps follow actual distance, including work approaches; blocked movement plants the feet. Idle returns to a planted stance with the selected tool held at a measured hand socket. Clothes share a consistent palette across standing, walking, carrying and work. Carrying while moving stops the pickup pose; dropping one of two loads keeps the remaining load supported. NPC miners face their path and mining target. The legacy `locomotion.gd` and its UID are preserved; new playback is `drawn_locomotion.gd`.

Validation: 143 gameplay/model assertions across the current native suite, plus identity/work/sip/Lord visual review and exported-pack boot. See `testing/animation-0.52.0.md` for exact coverage and evidence. Native Linux Godot 4.4.1 validation; Windows execution, audio balance and subjective feel remain player acceptance checks.

Recovery is a full playable Windows ZIP plus an incremental source ZIP and incremental Git bundle. Source/Git recovery REQUIRES the preserved 0.51.0 baseline; `Stellar-Holds-0.52.0-Recovery.txt` gives exact restoration commands and hashes. This avoids duplicating the large unchanged history. Earlier backups are not overwritten.

Remaining boundaries: there are four authored viewing families mirrored for eight-way movement, not eight separately drawn work cycles. Side working stances remain for some benches, timber and cart pushing. The dedicated practice bay retains its existing combat system. General handcarts/wagons remain local to a zone/depth; the existing mine wheelbarrow uses connected stairs. New raw-station/farm NPC jobs and further farming/fishing species remain deferred. This pass is a reviewed playable improvement, not a claim that every historical asset is final.

## Earlier milestones

# Dwarven labor and drawn poses — 0.51.0
Updated 2026-10-19 UTC. Recovery checkpoint `labor-0.51.0`; baseline `pre-animation-0.51.0` preserves 0.50.0 (`728e05dfdeb8b2f360b01ac5a2e1b039c9be1955`). Its full-history bundle was verified before mining changes. Earlier tags, archives and original assets remain intact. No remote was changed or pushed.

The active top-down game now uses complete drawn body poses for mining, chopping, hammering, sawing, drinking, lifting, carrying and cart handling, retaining the saved customized heads and colors. Idle has a planted stance; held tools use drawn ready poses and measured walking hand sockets. Work does not rotate arm cutouts. Pick/hammer have front, back and side contact poses. Hair masks preserve dark curls and braids. Tavern tables/bar are smaller, and terrace boundaries use substantial illustrated masonry. The seated Lord is retained. Source artwork and prompt provenance: `assets/animation-v51/PROMPTS.md`.

Mining renders connected world-space rock strata with exposed cut faces and damage fractures instead of individual boulder silhouettes. Existing deterministic veins, caverns, discoveries, five persistent levels, passages, tools and yields remain. A short actual approach closes tool reach; no visual-only player lunge. Pinewood contacts occur at the drawn axe impact, with a clear working stance. Existing felling, trunk cutting and raw-log ownership remain.

Raw chunks/logs have supported lifting and carrying drawings, with single-load, double-stone, double-log and mixed two-shoulder poses. Q has a brief set-down pose without changing the single-owner save model. Eight productive masonry/forestry credits still earn Strong Shoulders. This also unlocks a craftable freight wagon (12 timber + 4 iron, 24 raw loads), alongside the existing eight-load handcart and mine wheelbarrow. Empty vehicles draw empty; actual cargo builds visible piles and retains exact counts. Workstations, racks and raw/processed props use new matching artwork. Benches reserve real input, approach a working stance and draw the tool above the work surface.

Optional River & Root is linked from J and the homestead board. Craft field tools for 3 timber + 1 iron, including four turnip seeds. Build/place garden beds on the claim for 3 timber + 1 stone. E plants one seed, E waters with one pack water, and E harvests after 180 seconds of active world time. Crops never wither, return seed and persist across travel/reload. Eight harvests improve yield. At the High Trail river bank north of the bridge, hold E to cast/wait/reel; walking cancels freely. Catch and turnips enter the existing pack, chest and market systems; Borin's Crafting tab cooks them into existing crew provisions. First harvest + first catch rewards three provisions once.

Save additions are under `surface.fieldwork`; raw facilities and skills remain under existing hauling data. Before loading a save without fieldwork, its exact bytes are copied to a unique `.pre-labor-51-*.bak`; backup failure stops loading. Mine terrain, cargo, houses, unlocks and other progress are preserved. Rollback needs the matching older executable and backup save.

Validation and evidence: `docs/testing/labor-0.51.0.md`. Native tests cover the real world journey, doors/bridges/stairs, physical workshops, farming/fishing, save/reload and tool contacts. Deepworks/crew and industry model regressions pass. Native visual review covers all ten heads/four views, work poses, tavern drinking, the seated Lord and gameplay contacts. Windows execution and subjective audio/feel remain player checks.

Boundaries: this is a playable integrated milestone, not a certification that every legacy asset or animation is final. Four-frame walking/hauling cycles still need animation refinement, and most work/carry poses use a mirrored three-quarter stance. The dedicated sparring mode retains its existing combat implementation. General handcarts/wagons remain local to their zone/depth; the existing mine wheelbarrow still follows connected stairs. New raw-station worker jobs, farm workers, seasons, further crop/fish species and wagon portal travel are not implemented. Existing automated mining/industry remain tested and functional. Do not mark deferred work complete.

## 0.50.0 — Walkable Keldrath

Animation follow-up: directional sprites now use 40 measured source bounds instead of equal atlas cells, preventing clipped hair/feet and neighboring-row fragments. Anatomical hair-color regions include warm shadow pigments while protecting skin, leather and brass. The drinking forearm overlay is narrower to prevent a tunic wedge crossing the beard. Native review covers all ten sculpts in four directions, multiple walking phases, smithing phases, tavern lift/sip/lower and the seated Lord. This refines the existing procedural rig; it is not a replacement with fully hand-drawn action frames.

Rebuilt three wards with modular original architecture, connected stairs/lift and gate, eighteen ambient citizens, distinct workplaces and modular furnished interiors. Added a physically bounded trail bridge, measured collision/thresholds, safe old-save position migration and clearer UI/tracking. Preserved seated Eirik, services, quests, Deepworks, forestry, homes and industry. See testing/world-0.50.0.md.

Tavern follow-up: original copper/brass tankard and oak/iron bucket sprites replace simple geometric props. Drinking uses a dedicated smooth lift/sip/lower arm override on the existing directional rig, correct facing/handle alignment, a foreground forearm and staggered guest timing. Empty buckets no longer draw; buckets with real cargo are hidden during active mining or shoulder/workstation carrying without altering their contents. Walking and existing work retain the unified procedural rig; this is not a full hand-drawn frame-animation replacement. Asset provenance and exact built-in imagegen prompts: assets/tavern-v492/PROMPTS.md.

# Visual continuity — 0.49.2
Mine face detail now uses the same original stone artwork as carried raw chunks, with four irregular silhouettes and saved-damage fracture bands. Corrected workshop atlas slice bounds remove neighboring-object fragments; original PNGs remain intact. Mine haulage carts, ground stockpiles and entrance stores reuse workshop art and existing resource icons instead of flat triangle cargo. Quantity and ownership rules are unchanged. Entrance beams/treads use the home's oak/stone textures, with matching storage chests and lantern props.

Shift+B now presents six illustrated equipment cards in the established teal/gold palette. All six craft buttons fit without scrolling; detailed advice, recovery and the lesson remain below. Removed duplicate menu navigation and prototype wording from the title credit. These are targeted mining/workshop visual improvements, not a claim of replacing every historical visual in the whole game. Deferred gameplay remains deferred.

# Mine rock forms — 0.49.1
Four seed-stable, irregular rock-face silhouettes replace square face outlines. Original slate texture, mineral colors and geology remain. Broad facets, undercut edges, chipped outlines and three damage bands reflect the existing saved damage/resistance ratio. Hairlines widen into branching fractures and loosened edge chips; existing particles and settling fragments complete breakthrough. Target highlighting follows the rock outline.

No added strikes, resistance changes, resource changes or save migration. Ordinary stone stays quick; surviving hard faces and adjacent fracture damage show the intermediate states. The navigation/collision grid remains unchanged beneath the irregular artwork. Canonical loose chunks, shoulder cargo and workshop/stockpile artwork remain shared.

# Build 0.49.0 — Hands of the Dwarf
Checkpoint `hands-0.49.0`.

## Hands of the Dwarf: first playable stage — 0.49.0
Player-built stonebreakers, sawbenches, stone/log stockpiles, processed-material pallets and handcarts are integrated into the existing game. Shift+B opens the workshop board; J links its practical checklist. Crafting spends real pack materials only after valid local placement. Homes, claim grounds, Pinewood and clear Deepworks floors accept equipment. Doors, stairs, other facilities and authored town buildings remain protected. House floor recovery checks the new facilities at their own Z.

Some ordinary stone tiles deterministically release a persistent raw chunk instead of bucket stone. The actual felling stroke and subsequent trunk cuts in Pinewood release raw logs instead of duplicate pack timber. Other small yields and existing automation remain as before. Each raw record has one owner and retains its ID, kind, source and explicit yield: ground → shoulders → rack/cart → reserved station input → output. E lifts/deposits; Q drops; Shift+E withdraws. One substantial load initially; eight productive forestry/masonry credits unlock two shoulders. Handling/deposit loops award no experience.

Hold E at a supplied stonebreaker or sawbench for three 0.42-second work strokes. Input can come from shoulders, the bench or a compatible local rack/cart within 150 world units and a clear route. Mid-job input and progress save safely. Stonebreaking has cracks/hammer contact, timber processing a reciprocating saw, with sound at the contact phase. Output remains in a local buffer or nearby pallet until collected into the existing inventory. Processed stone was used in a real house floor during native testing. No stamina or new intermediate-resource tax.

Raw racks show one object per stored load and carts show their load; processed pallets build up in bundles. Stockpiles have typed input limits (12 large loads); handcarts carry 8. E can gather nearby loose items into a cart in a batch and unload compatible cart cargo to a nearby rack. C pushes/parks. Carts stay in their local zone/depth on travel; shoulders travel with the Dwarf. Existing mine wheelbarrows and their stair navigation are retained separately. This first-stage general handcart does not yet travel through zone portals or Z links.

Visual continuity is explicit: one raw_sprite renderer draws the SAME rock or log texture at the SAME scale on the ground, shoulders, rack, cart and workstation. Station bases are empty artwork; actual input is overlaid only when present. The fallen trunk shares the timber illustration. Hotbar labels distinguish carrying, pushing and working; conflicting local prompts quiet during labor. Original generated atlas and exact prompts are in assets/handworks-v49.

This is a coherent A–C milestone, not completion of the full attached brief. Deferred: optional precision smithing/quality grades; complete Miner/Mason/Forester/Smith progression trees and blueprint unlocks; raw ore/geode/specimen processing; new station operation by workers; generic cart portal/Z navigation; craftable standalone forge/furnace blueprints. Existing forge, masonry bench, research, worker production, hauling and automation remain functional. Do not mark deferred work complete.

# Build 0.48.0 — Clear tools, consistent Dwarfs
Updated 2026-10-18 UTC. Checkpoint `readability-0.48.0`.

## Readability and animation consistency — 0.48.0
Ten visual slots use keyboard 1–0 or mouse selection. 1–4 select pick, shovel, axe and hammer; 5 is the existing unlock-gated slagcaster. Slots 6–0 pin carried supplies, reassigned beside resources in I → Pack. Icons, live quantities, empty/locked states, a gold selection border and a Holding label show current equipment. Supplies remain references to pack inventory: no duplication, remote chest access or new consumption mechanics. Materials are used through existing workstations/trading/storage. Assignments and selection persist additively under surface.hotbar. Selecting a supply stops tool work; selecting a tool cancels stale pending work. Menus suppress hotkeys; clicking the bar does not mine/build behind it. The bar moves above the player near the lower screen and avoids the depth readout. The redundant text resource strip is hidden.

A single rig now renders the original 0.47 directional artwork for all eight movement directions, player mining/chopping/construction/carrying, and surface/underground Folk. Sideways movement uses the matching three-quarter view instead of switching to a legacy silhouette. Segmented arms and boots animate anticipation, contact/recovery and grounded stepping; tools attach to the same rig's palm, while existing world contact and production clocks remain authoritative. Idle equipped tools and selected supplies are visible on the character. Five male/female sculpts and palette customization are retained. No new borrowed game assets. The authored throne, story slides and separate practice-bay combat remain specialized art paths; this release does not claim a top-down combat rewrite or fully hand-drawn per-direction frame atlases.

Native verification: dedicated hotbar/save/input/held-mining run, surface regression 35, Deepworks 45, masonry 25 and campaign 43 checks; see testing/readability-0.48.0.md. Full Windows launcher execution and subjective audio remain human checks. Prior releases and the verified pre-readability-0.48.0 checkpoint remain recoverable.

# 0.47.0 — Build upward from your own hearth

## Hearthcraft and directional Dwarfs — 0.47.0
Freeform building is integrated into the existing claim yard via O → Build a house. Paint stone/oak foundations, walls, windows, operable doors and roofs; furnish with beds, tables, lamps and local chests. Costs come from the carried pack. Hold LMB builds without repeated charges on an existing tile. Recovery returns paid materials, with contents, occupancy, route and support checks.

Houses have real persistent Z-levels. A roof creates a corresponding walkable roof-floor one level above; stairs and ladders connect matching XY landings. E climbs, Shift+E descends. Upper construction requires supporting tiles beneath it. Z0–Z4 are building storeys and Z5 is the accessible top roof deck. Upper edges prevent walking into unsupported air. Current Z, every level's cells, doors, links and level-specific furniture/chest contents survive reload. Removing occupied/supporting floors or the access to an established upper storey is refused. Clear an upper storey before recovering its passage. Roofs fade from below, and lower-level floor context remains visible from above.

Keldrath's three existing walkable wards are explicitly labeled by elevation: Hearthward Z0, Crownward Z+1, Forgeward Z-1, with their existing connected stairs, lift, interiors and NPC quests. These are authored protected city zones, not player-demolishable house grids. Navigation wording now uses the actual gates/trails; the journal includes a practical house-building lesson that credits construction, shelter, ascent and return. Existing mine depths remain independent geological areas entered through their established mine mouths; there is no arbitrary basement-to-mine teleport.

Forty original view drawings cover front, rear and diagonal views across all five male and five female sculpts. Mirrored diagonals and the retained original side views give eight-direction locomotion. New views use a procedural grounded gait with boot lifts/body motion, not newly hand-drawn full walk-frame sequences. Hair/cloth/skin palette choices and sculpt identity remain in the profile. Existing side-view contact, carrying, smithing and combat frames remain for those specialized actions. Original new stone/oak/slate textures and a carved bed extend the existing style.

The starter cottage and all previous progression remain. Building data is additive under surface.homes[claim].building; prior furniture defaults to Z0. No new stamina, production chain, remote storage spending or automatic demolition. The sparring practice bay retains its older mechanics.

# 0.46.0 — A home beside the claim

## Walkable world and homestead — 0.46.0
The same character now walks freely through Hearthward, Crownward, Forgeward, the High Trail, Pinewood, the claim yard and building interiors. Doors, stair landings and the hold lift connect local areas. G gives directions instead of swapping to a world-map avatar. Normal settlement/trail movement is eight-directional with collision and footsteps; the separate practice bay retains its existing sparring mechanics.

Claim ownership supplies a small cottage, bed and one local storage chest. I shows carried supplies; E at a chest transfers actual quantities, and remote crafting/selling cannot spend stored items. O at home opens a short practical checklist, a cottage improvement and placement of chests, tables and lamps. Clear paths around entrances are protected. Empty chests and placed decorations can be recovered. Existing mine buckets, carts, stockpiles, rooms, masonry and workers retain their separate ownership rules.

Original customizable Dwarf animation frames are retained at a consistent scale, with shadows and foreground ordering; eight-direction locomotion currently uses the existing left/right-facing artwork. Original painted rooms, throne hall and transparent props extend the oak/slate/teal visual style. The Lord remains visibly seated on his throne. Pinewood uses its original tree/log art and yields, now with top-down axe targeting. Quiet contextual prompts replace map instructions; existing quest objectives lead through actual doors and stairs.

Additive state.surface saves area/return area, local positions, homes, chest contents, decorations and introduction facts. Pre-homestead saves are copied to a timestamped .pre-homestead-*.bak file before migration; backup failure stops loading. Inventory, claims, research, mines and all earlier progression remain. This is a starter homestead and furnishing system, not unrestricted house construction or a full directional sprite redraw.

## 0.45.1 — Masonry visual pass
Compact original mason’s mallet replaces the full mining hammer at the bench. Its raised pose stays beside the face, the striking face meets the chisel cap at the material-contact phase, and worker sound/chips follow the saved job clock. Duplicate worker chisel rendering is removed. The bench has a bevelled slab, braced timber legs and iron fixings; partial dressing now reads the correct bench cell before the drawing offset. Existing menus remain bounded with fixed tabs and scrolling.
Human checks remaining: Windows launcher, audible impact balance and subjective animation feel.

## 0.45.0 — A sound block, a lasting floor
Integrated rough-block quarrying, physical stockpile/bench conversion, dressed-floor construction and Brann's practical lesson. Existing miners can take over fetching, dressing and returning stone through real routes; carried job materials survive reload/release. Original procedural chiseling/carrying/bench animation and new material/finish visuals. No stamina or mandatory recipe rewrite. Fix residual construction swing cancellation and refreshed Living Works menu bounds.

## 0.44.0 — Routes and stories worth keeping
Real ladder shafts and cart-ready stairs, safe upgrades and round-trip quest proof; below-layer survey lesson with legacy credit retained. Enthroned Lord Eirik. Six expressive anniversary plates and matching tea station. Material-specific successful construction feedback with actual room-quality gains. Save-compatible, no recipe or stamina rewrite.

## 0.43.1 — Visual and menu polish
Pinned Living Works tabs, complete furniture catalog, grouped research, concise current help, quieter mine HUD and planning-only room markings. Warmer lanterns and original floor/furniture details. Existing economy/saves unchanged.

## 0.43.0 — The Living Works
Functional workshops/bedrooms, nine furnishings, seven finishes, three research capabilities, physical crew occupancy, capped room benefits, persistent preferences and Brann carving opportunity. Fracture hammer and selective extraction extend existing mining. Additive save compatibility and focused native tests.

# Changelog
Historical detail remains in DEVELOPMENT.md and versioned reviews. This is the concise current record.

| Build/checkpoint | Date | Change / compatibility |
|---|---|---|
| 0.38.1 | 2026-10-17 session record | Overhead mining, opaque cave background, dialogue/quest layout, removal of Royal Stair office shortcut; legacy throne return repaired. |
| 0.38.2 | 2026-10-17 | Removed repeated edge strips; room artwork fills width with floor anchor preserved. |
| 0.39.0 | 2026-10-17 | Persistent mineral bearings, mineral selection, paused notebook, deterministic bonus sifting with mountain-local saved progress. Existing save schema retained. |
| 0.39.1 | 2026-10-17 | Lower downward contact pose and footing-aware targeting; Shift retains precise cuts. Existing saves supported by unchanged schema. |
| continuity-1 | 2026-10-17 | Documentation, isolated smoke runner, Git baseline/checkpoint and portable recovery. Gameplay version stays 0.39.1. No runtime scripts, assets, scenes, settings or save format changed. |

| 0.40.0 / pinewood-0.40.0 | 2026-10-18 UTC | Pinewood forest art and seven firs; two-stage timber recovery, grounded reach/aim checks, progress and saved logs; useful field board and map travel. Existing five tree-cut values retained, two new trees added. Additive forestry save field; schema remains 1. |

| 0.41.0 / deepworks-0.41.0 | 2026-10-18 UTC | Integrated top-down, five-layer excavation; same-XY stairs, below-layer survey, connected veins/caverns, discoveries, lamps, physical multilevel crew and existing economy/slagcaster. Additive saves and mandatory legacy backup; old terrain/structures archived. Pinewood retained. |

| 0.42.0 / weight-0.42.0 | 2026-10-18 UTC | Physical fracture/breakup, conserved bucket/cart/pile transfers, actual movable wheelbarrow, graded ores and new iron lenses, existing-cost project ledger. Additive cargo saves; preexisting inventory/terrain unchanged. Crews retain delivery advantage. Rails deferred. |

