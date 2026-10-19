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

## Earlier milestones

# Walkable Keldrath — 0.50.0
Updated 2026-10-18. Recovery checkpoint `world-0.50.0`; baseline `pre-world-0.50.0` preserves `style-0.49.2-final` (f572362f38c9bbe02cb117131081aae2e61904ab). The baseline full-history bundle was verified before edits. Previous archives and tags remain; no remote was changed.

Keldrath's three wards now use individual illustrated buildings, stone streets, a civic fountain, planted terraces, visible perimeter walls, matched stairs and a shared lift. Original modular artwork follows the current Dwarf sprites. Ivar's office and the practice hall have distinct facades. King's Gate connects to the traversable High Trail, with a physical river bridge and routes to Pinewood, Old Workings and the existing claim. G provides directions; legacy map navigation is no longer instantiated.

Eighteen ambient citizens (six per ward) use the current directional Dwarf rig, deterministic walking/rest routes and nonmodal local advice. Named service NPCs, their conversations, recruitment and quest progression remain. Interiors now have separate illustrated counters, desks, bookshelves, tables and hearths with matching solid footprints. Eirik remains visibly seated on his throne in the rebuilt royal hall; Borin's hammer/anvil and tavern drinking retain their current animations. The top-down practice hall leads to the existing safe sparring exercise; that exercise's combat movement has not been rewritten.

`world_zones.gd` owns building thresholds, footprint definitions, citizen routes, interior furnishings, rendering and inter-ward arrival points. `surface.gd` integrates them into the existing game. Doors require a centered approach from outside; interior exits work from inside. Interactions check intervening obstacles. Bridge water and full-length rails block movement, while its visible deck is traversable. Stairs return to the same X/Y across ward Z levels. Tracking and quest text use the new locations. The hotbar occupies less useful interior space; nearby tracking captions are suppressed.

Before loading a pre-0.50 save, the exact original file is copied to a unique `.pre-world-50-*.bak`. Additive `surface.world_layout=50` archives previous positions in `legacy_positions` and relocates old ward positions to safe arrivals. Inventory, technology, money, chests, homes, mine layers, structures, crew and cargo are retained. New-layout positions save normally. Rollback requires the matching older build and its untouched backup save.

Validation: 322 checks across native world journey (35), collision/navigation (119), migration (8), physical workshops (32), tavern/cargo (7), industry (76), and Deepworks/crew (45). Visual inspection includes normal gameplay and collision overlays on doors, furniture and bridge rails. Evidence is under `docs/testing/world-0.50.0/`; summary in `docs/testing/world-0.50.0.md`. Windows execution and subjective audio mixing still require player testing; native tests use Linux Godot 4.4.1. Known engine shutdown resource warnings are recorded separately from gameplay errors.

Animation follow-up: directional sprites now use 40 measured source bounds instead of equal atlas cells, preventing clipped hair/feet and neighboring-row fragments. Anatomical hair-color regions include warm shadow pigments while protecting skin, leather and brass. The drinking forearm overlay is narrower to prevent a tunic wedge crossing the beard. Native review covers all ten sculpts in four directions, multiple walking phases, smithing phases, tavern lift/sip/lower and the seated Lord. This refines the existing procedural rig; it is not a replacement with fully hand-drawn action frames.

Boundaries: ambient citizens do not add a full daily economy or new worker jobs. Private Folk homes are labeled private; service buildings are enterable. New raw-material station automation and cross-zone handcarts remain deferred from 0.49. Mining, Pinewood harvesting, player construction and existing industrial progression retain their current systems. No freeform demolition of authored Keldrath or new continent was added.

## Earlier development history

Art-direction authority: current in-world Dwarf models are the gold standard; see ART_DIRECTION.md. Portraits/cutscenes may vary. Final recovery tag `style-0.49.2-final` includes this user direction; `style-0.49.2` preserves the tested code checkpoint.

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

Raw stockpiles show one visible object per stored record, including all 12 slots; processed pallets build up in 20-unit bundles with exact quantity readouts. Stockpiles have typed input limits (12 large loads); handcarts carry 8. E can gather nearby loose items into a cart in a batch and unload compatible cart cargo to a nearby rack. C pushes/parks. Carts stay in their local zone/depth on travel; shoulders travel with the Dwarf. Existing mine wheelbarrows and their stair navigation are retained separately. This first-stage general handcart does not yet travel through zone portals or Z links.

Visual continuity is explicit: one raw_sprite renderer draws the SAME rock or log texture at the SAME scale on the ground, shoulders, rack, cart and workstation. Station bases are empty artwork; actual input is overlaid only when present. The fallen trunk shares the timber illustration. Hotbar labels distinguish carrying, pushing and working; conflicting local prompts quiet during labor. Original generated atlas and exact prompts are in assets/handworks-v49.

This is a coherent A–C milestone, not completion of the full attached brief. Deferred: optional precision smithing/quality grades; complete Miner/Mason/Forester/Smith progression trees and blueprint unlocks; raw ore/geode/specimen processing; new station operation by workers; generic cart portal/Z navigation; craftable standalone forge/furnace blueprints. Existing forge, masonry bench, research, worker production, hauling and automation remain functional. Do not mark deferred work complete.

# Build 0.48.0 — Clear tools, consistent Dwarfs
Updated 2026-10-18 UTC. Checkpoint `readability-0.48.0`.

## Readability and animation consistency — 0.48.0
Ten visual slots use keyboard 1–0 or mouse selection. 1–4 select pick, shovel, axe and hammer; 5 is the existing unlock-gated slagcaster. Slots 6–0 pin carried supplies, reassigned beside resources in I → Pack. Icons, live quantities, empty/locked states, a gold selection border and a Holding label show current equipment. Supplies remain references to pack inventory: no duplication, remote chest access or new consumption mechanics. Materials are used through existing workstations/trading/storage. Assignments and selection persist additively under surface.hotbar. Selecting a supply stops tool work; selecting a tool cancels stale pending work. Menus suppress hotkeys; clicking the bar does not mine/build behind it. The bar moves above the player near the lower screen and avoids the depth readout. The redundant text resource strip is hidden.

A single rig now renders the original 0.47 directional artwork for all eight movement directions, player mining/chopping/construction/carrying, and surface/underground Folk. Sideways movement uses the matching three-quarter view instead of switching to a legacy silhouette. Segmented arms and boots animate anticipation, contact/recovery and grounded stepping; tools attach to the same rig's palm, while existing world contact and production clocks remain authoritative. Idle equipped tools and selected supplies are visible on the character. Five male/female sculpts and palette customization are retained. No new borrowed game assets. The authored throne, story slides and separate practice-bay combat remain specialized art paths; this release does not claim a top-down combat rewrite or fully hand-drawn per-direction frame atlases.

Native verification: dedicated hotbar/save/input/held-mining run, surface regression 35, Deepworks 45, masonry 25 and campaign 43 checks; see testing/readability-0.48.0.md. Full Windows launcher execution and subjective audio remain human checks. Prior releases and the verified pre-readability-0.48.0 checkpoint remain recoverable.

# Current status
Updated 2026-10-18 UTC. Build **0.47.0**, checkpoint **hearthcraft-0.47.0**.

## Hearthcraft and directional Dwarfs — 0.47.0
Freeform building is integrated into the existing claim yard via O → Build a house. Paint stone/oak foundations, walls, windows, operable doors and roofs; furnish with beds, tables, lamps and local chests. Costs come from the carried pack. Hold LMB builds without repeated charges on an existing tile. Recovery returns paid materials, with contents, occupancy, route and support checks.

Houses have real persistent Z-levels. A roof creates a corresponding walkable roof-floor one level above; stairs and ladders connect matching XY landings. E climbs, Shift+E descends. Upper construction requires supporting tiles beneath it. Z0–Z4 are building storeys and Z5 is the accessible top roof deck. Upper edges prevent walking into unsupported air. Current Z, every level's cells, doors, links and level-specific furniture/chest contents survive reload. Removing occupied/supporting floors or the access to an established upper storey is refused. Clear an upper storey before recovering its passage. Roofs fade from below, and lower-level floor context remains visible from above.

Keldrath's three existing walkable wards are explicitly labeled by elevation: Hearthward Z0, Crownward Z+1, Forgeward Z-1, with their existing connected stairs, lift, interiors and NPC quests. These are authored protected city zones, not player-demolishable house grids. Navigation wording now uses the actual gates/trails; the journal includes a practical house-building lesson that credits construction, shelter, ascent and return. Existing mine depths remain independent geological areas entered through their established mine mouths; there is no arbitrary basement-to-mine teleport.

Forty original view drawings cover front, rear and diagonal views across all five male and five female sculpts. Mirrored diagonals and the retained original side views give eight-direction locomotion. New views use a procedural grounded gait with boot lifts/body motion, not newly hand-drawn full walk-frame sequences. Hair/cloth/skin palette choices and sculpt identity remain in the profile. Existing side-view contact, carrying, smithing and combat frames remain for those specialized actions. Original new stone/oak/slate textures and a carved bed extend the existing style.

The starter cottage and all previous progression remain. Building data is additive under surface.homes[claim].building; prior furniture defaults to Z0. No new stamina, production chain, remote storage spending or automatic demolition. The sparring practice bay retains its older mechanics.

See testing/hearthcraft-0.47.0.md for native verification and scope. Windows execution remains a player check.

## Walkable world and homestead — 0.46.0
The same character now walks freely through Hearthward, Crownward, Forgeward, the High Trail, Pinewood, the claim yard and building interiors. Doors, stair landings and the hold lift connect local areas. G gives directions instead of swapping to a world-map avatar. Normal settlement/trail movement is eight-directional with collision and footsteps; the separate practice bay retains its existing sparring mechanics.

Claim ownership supplies a small cottage, bed and one local storage chest. I shows carried supplies; E at a chest transfers actual quantities, and remote crafting/selling cannot spend stored items. O at home opens a short practical checklist, a cottage improvement and placement of chests, tables and lamps. Clear paths around entrances are protected. Empty chests and placed decorations can be recovered. Existing mine buckets, carts, stockpiles, rooms, masonry and workers retain their separate ownership rules.

Original customizable Dwarf animation frames are retained at a consistent scale, with shadows and foreground ordering; eight-direction locomotion currently uses the existing left/right-facing artwork. Original painted rooms, throne hall and transparent props extend the oak/slate/teal visual style. The Lord remains visibly seated on his throne. Pinewood uses its original tree/log art and yields, now with top-down axe targeting. Quiet contextual prompts replace map instructions; existing quest objectives lead through actual doors and stairs.

Additive state.surface saves area/return area, local positions, homes, chest contents, decorations and introduction facts. Pre-homestead saves are copied to a timestamped .pre-homestead-*.bak file before migration; backup failure stops loading. Inventory, claims, research, mines and all earlier progression remain. This is a starter homestead and furnishing system, not unrestricted house construction or a full directional sprite redraw.

Verification: native homestead35, Deepworks45 and masonry25 pass. Native visual captures cover 12 areas/menu states. See testing/homestead-0.46.0.md. Windows execution and subjective audio remain human checks.

## Masonry visual pass — 0.45.1
Compact original mason’s mallet replaces the full mining hammer at the bench. Its raised pose stays beside the face, the striking face meets the chisel cap at the material-contact phase, and worker sound/chips follow the saved job clock. Duplicate worker chisel rendering is removed. The bench has a bevelled slab, braced timber legs and iron fixings; partial dressing now reads the correct bench cell before the drawing offset. Existing menus remain bounded with fixed tabs and scrolling.

Native input workflow: 12 passed; masonry model: 25 passed. Lift/contact/recovery captures and menu/worker views inspected. No save schema, costs, production time or yield changes. Windows execution and audible mixing remain human checks. See testing/polish-0.45.1.md.

## Meaningful stonework — 0.45.0
A complete optional masonry loop is integrated into O → Masonry and the underground journal. Chisel a sound block from ordinary stone with three held contacts (basalt retains its forged-steel gate). Rough blocks enter existing bucket/cart/pile ownership. Place a mason's bench for 3 timber + 2 stone inside any designated room, then mark/cache masonry within three tiles on a reachable floor route. E at the bench opens its work choices. Three quick contacts convert one rough block into two dressed stone, or four ordinary stone; Fine Masonry raises dressed output to three. Output stays in the physical stockpile. Shift+U loads it; U at the entrance delivers it for construction.

Dressed floor costs one delivered dressed stone per tile and contributes craftsmanship 2, with a pale bevelled finish. Basic construction still accepts ordinary stone. Brann's four-step work-board lesson records actual extraction, marked stockpiling, dressing and installation, credits prior work and rewards delegation knowledge plus one machine part once per site. The follow-up asks you to prove a worker handover. Recruit a Dwarf normally and provide a functional workshop (joiner's bench, forge/anvil, lantern) plus mason's bench. Assign on the Masonry tab: the actual Dwarf fetches a block, carries it to the bench, dresses it, returns output and consumes existing provisions. Release returns any held material to the pile; Folk release also restores normal mining duties.

Original code-drawn block/stack/bench details, quarry score lines, chisel hand, contact chips, carrying poses, arcing pickup/set-down transfers and targeted worker bench strokes extend existing character animation. Bench foreground ordering keeps the work visible. Work-mode cancellation clears residual swings; refreshed Living Works panels retain their bounded scroll area and fixed tabs.

Site-local additive `living.masonry` persists cuts, partial bench contacts, lesson facts, reward state, worker phase and carried input/output. Existing rooms, layers, links, stores and progression remain intact. No new stamina, XP grind, compulsory production chain or brewing system. See testing/masonry-0.45.0.md and PLAYTEST_GUIDE.md.

## Routes, story art and meaningful labor — 0.44.0
V offers a two-timber ladder shaft or carved stairs at matching XY across depths. Ladder landings occupy one lower tile; stairs open a cross-shaped landing. Upgrade ladders from above. Hitched carts and MOTE machines require stairs; Dwarfs and buckets can use ladders. Ivar's route lesson requires a descent and return; legacy built-route credit remains valid. X surveying below satisfies the geological lesson once per site. F1 opens full help again.

Lord Eirik now sits on an original substantial throne. The anniversary has six consistent storybook compositions with expressive reactions, detailed carved oak and hammered copper gifts, selected inscription/motif captions and a matching permanent tea station. Existing local-host gates, choices, costs, skip/replay and once-only rewards remain.

Living Works construction uses timber, stone or metal contact sounds and reports actual room-quality gains only after successful work. Existing physical placement, research/material quality, accessible workstations, staffed craft-time benefits and Brann's opportunity express meaningful labor without adding stamina, experience grinding or intermediate recipes. Brewing and broader specialist crafting remain future work. See LIVING_WORKS_DESIGN.md and PLAYTEST_GUIDE.md.

## Visual and menu polish — 0.43.1
Compact, pinned Living Works tabs replace the long single menu. All nine furnishings fit in a three-column catalog; finishes show real costs and research locks. Room selection uses a dropdown, with construction markings visible only while planning. Research is grouped into Mining & Industry, Craftsmanship and Starflight; construction links open Craftsmanship directly.

Mine HUD now has one controls footer, a compact cargo indicator and contextual room quality. The remote objective and project list no longer obscure excavation; J/L still open their existing interfaces. Modal menus dim the mine and suppress duplicate HUD labels. Warm lantern halos, staggered floor joints, timber variation and furniture joinery/textile details preserve the existing original style. Updated F1 help describes current top-down mining and Living Works controls.

The Living Works adds functional workshops and bedrooms directly to the existing five-layer Deepworks. Previous physical mining, bucket/wheelbarrow/stockpiles, discoveries, same-location stairs, settlement travel, economy, NPCs, automation and Pinewood remain integrated.

## Play the loop
Excavate a clear 4×4 to 9×9 chamber. Press **O**, choose workshop or bedroom, then click two floor corners. Use the same board to select furniture or finishes; aim nearby and hold LMB to work with the hammer. Right mouse cancels. Costs use delivered supplies. Keep the perimeter aisle clear; solid furnishings cannot disconnect the floor, occupy stairs, actors or parked carts. Dismantling returns the exact furnishing materials.

A workshop needs an accessible joiner's bench, forge hearth/anvil and lantern. A bedroom needs bed and lantern. The original nine furnishings and seven finishes provide timber, flagstone, smooth/masonry walls, runic inlay and earned ancestral carving. Stoneworking, Fine Masonry and Dwarven Furnishings extend existing research. Lanterns illuminate rooms. E near a functional workbench opens existing crafting.

Quality reports comfort, functionality, craftsmanship and heritage, with diminishing returns and a clutter penalty. Recruit an existing mining Dwarf in your claimed mountain, then assign him a workplace or bedroom. He follows actual floor routes and stairs, works/rests, and receives modest morale benefits. Release him on O to resume excavation. Best staffed workshop speeds existing craft queues by at most 10%; rooms do not stack bonuses. Improved bedrooms offer a short rest benefit. Brann, Dagr and Osvik retain architectural/interests/drink preferences; drinks are descriptive for now. Brann's improved workshop offers an optional carving opportunity, rewarding an architectural finish and two machine parts once.

Pick remains versatile. Hammer [4] exploits existing cracks; fresh faces resist it. Shift+pick gives slower selective extraction with one additional unit of existing ore. Existing tool gates, material sounds, visible fracture/contact, cargo conservation and crew delivery remain.

## Saves and recovery
Additive `deepworks[site].living` holds room geometry, finishes, furniture/costs, assignments, preferences, morale and opportunity. Older worlds receive empty room data without regenerating terrain or changing inventory. Existing schema, global hauling, independent layers, links and archived legacy terrain remain. Preserve matching prior saves for rollback to older versions.

## Verified and remaining
0.43.1 focused verification: native construction/menu flow 14 checks, room model 37 checks, eight smoke stages, plus rendered review of title, rooms, furniture, finishes, Folk, forge, inventory, research, haulage, project ledger, settlement and Pinewood.

0.43.0 baseline — Godot 4.4.1 Linux: Living Works model/integrated checks 37, native construction/UI 11, previous native controls 15, existing Deepworks 45, hauling 34, Pinewood 53, campaign 43 and all eight smoke stages pass. Tests exercise costs, geometry, collision, actual crew movement, existing crafting, rewards, save/load and additive compatibility. Native rendered inspection covers workshop, masonry, furniture, lanterns and room/ledger UI. See testing/living-0.43.0.md for release evidence.

This is a reusable first habitat milestone: rectangular workshops/bedrooms only, maximum 16 per mine. No pressure/enclosure/ventilation model, tavern/brewing simulation, surface room construction or full society simulation. Crew has a simple 120-second work/rest cycle without a player bedtime. Offscreen staffing uses persisted presence; no whole-world continuous NPC travel. Dedicated eight-facing character art, rails, powered haulage, fluids and deeper streaming remain future. Windows execution, speaker listening, historical player-save acceptance and human balance/feel remain unverified. Existing shutdown ObjectDB/resource warnings remain.
