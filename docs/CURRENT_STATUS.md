# Current status
Updated 2026-10-18 UTC. Build **0.46.0**, checkpoint **homestead-0.46.0**.

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
