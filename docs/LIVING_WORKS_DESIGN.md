# Meaningful Dwarven labor
Design direction accepted for the existing Living Works; this is not a crafting-system rewrite.

The experience: **I worked for this, I made this, and my Folk are better off because of it.**

- Keep mining and construction physical: contact-aligned swings, material sounds and visible persistent results. Routine work remains quick and held-input friendly.
- Give a workstation a visible purpose. Existing usable benches/anvils connect to the real crafting queue; future smithing, woodworking and brewing should extend those systems rather than invent parallel inventories.
- Quality should follow useful materials, equipment, knowledge and eventually relevant skill. Current finished surfaces, furnishings and research improve room craft/comfort/heritage; staffing gives capped production benefits.
- Reward practical projects and discoveries. Brann's workshop opportunity is the current model: improve a real workplace to earn knowledge. Do not add repeat-action XP requirements.
- Make worker/machine delegation visibly replace familiar labor. Preserve recruited miners, physical routes and existing automation. New specialist assignments must have a clear manual equivalent and readable output before expansion.
- Preserve short supply chains, no punishing stamina and no mandatory repetitive minigames. Optional precision may deepen future masterwork creation; routine goods should stay quick.
- Connect output to the settlement: functional rooms, beautiful furnishings, Folk morale and industrial capacity. Display the actual benefit without showering the player in UI.

0.44.0 implements material-specific construction contact and actual room-quality gain feedback. Existing room/research/staff/opportunity systems already provide the bounded foundation. This release does not claim new brewing, NPC expertise levels or masterwork minigames.

## Implemented in 0.45.0: dressed stone
Implemented flow: chisel a rough block from suitable exposed stone, haul it through existing cargo/stockpiles, then dress it at a mason's bench into quality building stone. Ordinary rubble remains usable for basic construction. Give the extra step a real quality/yield benefit, not a universal tax. A short manual hammer/chisel action should later be replaceable by an assigned mason who visibly collects blocks and deposits finished stone. Reuse existing stockpile conservation and room routes; no separate inventory, forced stamina or long intermediate chain. This flow now ships in 0.45.0, with a mason’s bench, dressed floors and a practical teaching quest.

The work-board lesson teaches the masonry loop through a useful NPC repair/furnishing project: extract block, place in marked stockpile, dress at the nearby bench, install the result and observe the room benefit. Later introduce NPC delegation using that same demonstrated route. Quest checks must observe actual conserved transfers and completed work, credit eligible prior work, preserve completion across reload, and never require bulk trivial production. Contextual prompts and short journal objectives should replace intrusive tutorials.

Original procedural animation now covers score lines, braced chisel contacts, flying chips, held stone, pickup/set-down arcs, a visible bench workpiece and NPC fetch/work/return. Future animation refinements must retain contact/event alignment and short routine actions.
