# Current status
Updated 2026-10-18 UTC. Build **0.43.0**, checkpoint **living-0.43.0**.

The Living Works adds functional workshops and bedrooms directly to the existing five-layer Deepworks. Previous physical mining, bucket/wheelbarrow/stockpiles, discoveries, same-location stairs, settlement travel, economy, NPCs, automation and Pinewood remain integrated.

## Play the loop
Excavate a clear 4×4 to 9×9 chamber. Press **O**, choose workshop or bedroom, then click two floor corners. Use the same board to select furniture or finishes; aim nearby and hold LMB to work with the hammer. Right mouse cancels. Costs use delivered supplies. Keep the perimeter aisle clear; solid furnishings cannot disconnect the floor, occupy stairs, actors or parked carts. Dismantling returns the exact furnishing materials.

A workshop needs an accessible joiner's bench, forge hearth/anvil and lantern. A bedroom needs bed and lantern. Nine furnishings and seven finishes provide timber, flagstone, smooth/masonry walls, runic inlay and earned ancestral carving. Stoneworking, Fine Masonry and Dwarven Furnishings extend existing research. Lanterns illuminate rooms. E near a functional workbench opens existing crafting.

Quality reports comfort, functionality, craftsmanship and heritage, with diminishing returns and a clutter penalty. Recruit an existing mining Dwarf in your claimed mountain, then assign him a workplace or bedroom. He follows actual floor routes and stairs, works/rests, and receives modest morale benefits. Release him on O to resume excavation. Best staffed workshop speeds existing craft queues by at most 10%; rooms do not stack bonuses. Improved bedrooms offer a short rest benefit. Brann, Dagr and Osvik retain architectural/interests/drink preferences; drinks are descriptive for now. Brann's improved workshop offers an optional carving opportunity, rewarding an architectural finish and two machine parts once.

Pick remains versatile. Hammer [4] exploits existing cracks; fresh faces resist it. Shift+pick gives slower selective extraction with one additional unit of existing ore. Existing tool gates, material sounds, visible fracture/contact, cargo conservation and crew delivery remain.

## Saves and recovery
Additive `deepworks[site].living` holds room geometry, finishes, furniture/costs, assignments, preferences, morale and opportunity. Older worlds receive empty room data without regenerating terrain or changing inventory. Existing schema, global hauling, independent layers, links and archived legacy terrain remain. Preserve matching prior saves for rollback to older versions.

## Verified and remaining
Godot 4.4.1 Linux: Living Works model/integrated checks 37, native construction/UI 11, previous native controls 15, existing Deepworks 45, hauling 34, Pinewood 53, campaign 43 and all eight smoke stages pass. Tests exercise costs, geometry, collision, actual crew movement, existing crafting, rewards, save/load and additive compatibility. Native rendered inspection covers workshop, masonry, furniture, lanterns and room/ledger UI. See testing/living-0.43.0.md for release evidence.

This is a reusable first habitat milestone: rectangular workshops/bedrooms only, maximum 16 per mine. No pressure/enclosure/ventilation model, tavern/brewing simulation, surface room construction or full society simulation. Crew has a simple 120-second work/rest cycle without a player bedtime. Offscreen staffing uses persisted presence; no whole-world continuous NPC travel. Dedicated eight-facing character art, rails, powered haulage, fluids and deeper streaming remain future. Windows execution, speaker listening, historical player-save acceptance and human balance/feel remain unverified. Existing shutdown ObjectDB/resource warnings remain.
