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
