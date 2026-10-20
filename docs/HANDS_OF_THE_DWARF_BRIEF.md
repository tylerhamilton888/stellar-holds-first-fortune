# THE STELLAR HOLDS: THE FIRST FORTUNE
## Development Milestone — Hands of the Dwarf

### Project recovery and continuity

Continue development of our existing Godot 4.4.1 project, **The Stellar Holds: The First Fortune**.

Locate the saved folder `The Stellar Holds - Development` and read `PROJECT_INDEX.md`.

Restore the **latest verified completed checkpoint**, including the integrated top-down, multi-Z-level Deepworks and the latest Pinewood improvements.

Do not automatically revert to version 0.40.0 if a newer completed checkpoint exists.

Read:
- `AGENTS.md`
- `docs/SESSION_HANDOFF.md`
- `docs/CURRENT_STATUS.md`

Consult `GAME_VISION.md`, `DECISIONS.md`, and relevant architecture documentation as needed.

Keep context usage efficient. Inspect only relevant files and dependencies. Do not perform an unnecessary full-project audit or reconstruct old conversations.

**This is an implementation task in the existing game, not a separate prototype.**

Preserve existing functionality, original assets, save compatibility, and previously completed development.

# 1. Primary objective

Implement a cohesive, physically interactive system of Dwarven labor, resource handling, processing, and craftsmanship.

We want players to feel like actual Dwarven miners, masons, foresters, and craftsmen.

Our current mining experience risks feeling like the player simply erases walls and magically acquires resources.

We are changing that.

The player should physically excavate materials, retrieve them, transport them, organize them, process them through relevant workstations, and use the results to build and improve the world.

This creates a natural progression from:

**Manual labor → Better tools → Better transportation → Skilled craftsmanship → Hired workers → Machinery → Industrial automation.**

The experience should be tactile, charming, visually satisfying, purposeful, and enjoyable.

**We want meaningful effort, not tedious repetition.**

# 2. Physical raw material extraction

Begin by implementing two complete resource workflows:

**Stone:** Mine → Recover raw chunk → Haul → Stockpile → Process → Use.

**Timber:** Fell tree → Recover log → Haul → Stockpile → Process → Use.

These two workflows should establish reusable foundations for ores, crystals, agricultural goods, industrial materials, and future planetary extraction.

## Stone extraction

When the player mines a suitable section of stone in the Deepworks:

1. The Dwarf performs a convincing pickaxe or chisel interaction.
2. The stone displays visible cracking and impact feedback.
3. A substantial raw stone chunk breaks free.
4. The chunk becomes a persistent physical object on the ground.
5. The player may pick it up, leave it, or arrange for it to be hauled later.
6. The terrain remains excavated and persists normally.

Distinguish common stone, ore-bearing stone, and exceptional geological specimens where practical.

Not every removed terrain tile must generate a full-size chunk. Use sensible yield rules so the world does not become overwhelmed with loose objects.

Raw chunks must be represented visually and as actual persistent items within the resource economy.

Avoid duplicating resources through both automatic inventory collection and physical item spawning.

## Timber extraction

Integrate the equivalent workflow with the existing Pinewood forestry system.

When a tree is felled:

1. Play appropriate falling and cutting animations.
2. Generate one or more recoverable logs or suitable raw timber objects.
3. Allow the player to carry, store, transport, and process them.
4. Preserve appropriate tree regrowth, woodland management, and existing forestry progression.

Do not unnecessarily redesign the Pinewood environment.

Reuse the same physical-material framework used by stone where sensible.

# 3. Carrying and placing raw materials

Create a clear, satisfying carrying system.

### Basic carrying

The Dwarf should initially be able to lift and carry one substantial raw item, such as a rock chunk or log.

Requirements:

- Press the normal interaction key to pick up a nearby valid item.
- Play a purposeful lifting animation.
- Display the object carried over one shoulder or in another visually appropriate position.
- Use an appropriate carrying animation while walking.
- Allow the player to put the object down.
- Allow direct delivery to a stockpile or compatible workstation.
- Preserve reliable collision and movement controls.

The player should visibly appear strong and capable.

Carrying must feel substantial without making movement painfully slow.

The animation should work in the existing top-down perspective and remain readable in all relevant facing directions.

### Improved carrying

Add a skill or technology upgrade that allows the Dwarf to carry two appropriate objects, one over each shoulder.

This upgrade should have a meaningful gameplay benefit and distinct visual presentation.

Architect the carrying system so future equipment can support larger items, special handling requirements, and assisted lifting.

Do not build elaborate rigid-body physics.

Use reliable character-attached item visuals and persistent item data.

# 4. Physical stockpiles

Implement usable, visible stockpiles.

Stockpiles should be areas or facilities in the world with:

- A defined physical location.
- Finite capacity.
- Accepted item categories.
- Visible material accumulation.
- Simple deposit and withdrawal interactions.
- Persistent contents.
- Support for later worker and automaton access.

Initial stockpile categories:

- Raw stone.
- Raw timber.
- General processed materials.

Use existing storage systems if present and extend them rather than implementing an unrelated parallel inventory.

### Placement and interaction

The player should be able to establish a stockpile in an appropriate location.

Stockpiles should be easy to configure and understand.

A basic stone stockpile may hold a fixed number of large chunks, with capacity eventually improved by expanding its area or researching more efficient storage methods.

Different stockpiles should visibly contain different materials.

Depositing an item should be quick and satisfying, with minimal menu interaction.

Loose materials may also remain on the ground for later retrieval.

### Performance

Do not create expensive active physics simulations for every material item across every Z-level.

Nearby items should be visibly represented.

Distant piles can use efficient, persistent item records or aggregated representations while preserving actual material quantities.

Avoid resource loss or duplication during save/load, scene transitions, and stockpile transfers.

# 5. Manual hauling progression

Create a reusable hauling system that can support progressively more advanced equipment.

The long-term progression is:

**Shoulder carrying → Wheelbarrow → Wagon → Minecart railway → Powered vehicles → Automated hauling.**

For this milestone, fully implement basic carrying and at least one useful manual hauling vehicle.

## Wheelbarrow or handcart

Create a functional, original Dwarven wheelbarrow or handcart.

It should:

- Carry several chunks or logs.
- Be visually represented in the world.
- Be positioned conveniently near work sites.
- Accept compatible materials.
- Display its current load.
- Move with the player when pushed or operated.
- Unload efficiently at stockpiles and workstations.
- Persist appropriately.

Use intuitive, forgiving controls.

Avoid irritating collision behavior, narrow navigation problems, or laborious individual-item loading.

A single interaction may transfer multiple items where appropriate.

### Future transport technology

Prepare extensible data structures for wagons, rail carts, lifts, powered industrial vehicles, and automatons.

Do not attempt to implement all of these in this milestone.

Later equipment should fundamentally change how material transport works, not merely provide progressively larger invisible inventory capacities.

# 6. Workstations and physical processing

Create a shared workstation system that supports physical interaction, recipes, material inputs, processing duration, output quality, and eventual automation.

Initial stations:

- Stonebreaker.
- Masonry/carving station.
- Wood chopping or sawing station.
- Existing forge/furnace where appropriate.

Reuse functioning workstations already in the project whenever practical.

## Stonebreaker workflow

The player transports a raw stone chunk to a stonebreaking station.

The station accepts the chunk either directly from the carried item or from accessible nearby storage.

The player holds **E** to process it.

During processing:

- The Dwarf visibly strikes the stone several times.
- Hammer impacts align correctly with the stone.
- Appropriate sound and fracture effects occur.
- The stone progressively breaks apart.
- Processing completes within a short, satisfying work sequence.
- Finished materials appear visibly or enter a designated workstation output buffer.

Example outputs:

- Usable stone.
- Rubble or aggregate.
- Mineral fragments from ore-bearing chunks.
- Occasional geodes or geological specimens.

### Geological discoveries

Where practical, determine special contents during geological generation or material extraction rather than rerolling unpredictably whenever processing is repeated.

A raw chunk can carry metadata identifying its source material, grade, and possible contents.

Geodes should be recoverable objects that can later be cracked open to reveal gems or crystals.

Ensure that special finds are infrequent enough to remain exciting but not so rare that discovery becomes irrelevant.

## Timber processing

Implement a comparable physical workflow:

Raw log → Sawing/chopping workstation → Usable timber and appropriate byproducts.

The Dwarf should perform a purposeful sawing or chopping animation.

The process should feel different from stonebreaking, rather than simply changing the resource icons on the same progress bar.

## Workstation usability

Workstations must support:

- Clear accepted inputs.
- Readable recipe selection.
- Visible material requirements.
- Hold-E routine processing.
- Appropriate work animations.
- Reliable output handling.
- Useful tooltips.
- Later worker and machine operation.

If materials are available in a designated nearby input stockpile, do not require the player to manually move each item into a recipe slot.

Preserve the importance of transport while avoiding unnecessary menu interactions.

# 7. Craftsmanship and optional skill interactions

Not every workstation should use identical mechanics.

Routine production should be approachable and quick.

Specialized craftsmanship should provide opportunities for greater skill and better results.

Implement a foundational work-quality system supporting:

- Standard work.
- Skilled work.
- Exceptional or masterwork results.

Do not build a complex minigame for every profession yet.

## Smithing interaction

Introduce or refine a simple optional smithing minigame.

The player selects a recipe and begins working at the forge.

A timing indicator moves across a bar containing green, yellow, and red zones.

The player presses **E** at appropriate moments during several forging strikes.

Possible results:

- Green: Precise work, improving item quality.
- Yellow: Acceptable work, ordinary progress.
- Red: Imperfect work, reducing potential quality or efficiency.

Poor timing should not routinely destroy expensive ingredients.

Make the interaction forgiving, readable, and responsive.

The Dwarf's Smith skill can improve the minigame through wider successful zones, better control, or additional opportunities to correct mistakes.

Routine crafting should still be possible through a basic hold-E interaction.

Advanced craftsmanship should be optional except for genuinely exceptional projects requiring special care.

## Future crafting interactions

Design the shared framework so smithing, masonry, woodworking, brewing, farming, and other professions can eventually have distinct forms of interactive workmanship.

Do not implement a large collection of shallow minigames now.

# 8. Paths of Dwarven Mastery

Introduce the foundation of a multi-discipline character progression system.

The player should gain experience through meaningful actions performed in the world.

Proposed disciplines:

- Path of the Miner.
- Path of the Smith.
- Path of the Mason.
- Path of the Forester.
- Path of the Warrior.
- Path of the Brewer.
- Path of the Farmer.
- Path of the Manager.
- Path of the Lord.

These paths represent individual mastery and should remain separate from civilization-wide research and technological development.

## Initial implementation

Fully integrate a small number of paths relevant to the current game:

**Miner**
- Experience from meaningful extraction and geological discoveries.
- Improved extraction capabilities.
- Better understanding of mineral deposits.
- Useful mining techniques or equipment unlocks.

**Mason**
- Experience from processing stone, carving, and construction.
- Improved workmanship.
- Better stone yields or material efficiency.
- Unlockable masonry techniques and architectural blueprints.

**Forester**
- Experience from felling and processing timber.
- Improved timber handling.
- Better cutting and woodworking efficiency.
- Unlockable tools or forestry capabilities.

**Smith**
- Experience from refining and crafting metal goods.
- Improved smithing quality and precision.
- More forgiving skilled-work interactions.
- New crafting blueprints and techniques.

Create visible but compact skill progression interfaces.

Provide several meaningful unlocks rather than many insignificant percentage modifiers.

## Experience rules

Experience should primarily reward completed productive work, successful craftsmanship, new discoveries, and meaningful accomplishments.

Do not reward exploitative repeated button presses or useless cycles of material handling.

Avoid making players repeatedly process worthless items solely to gain levels.

Allow the player to become skilled in multiple disciplines over time.

## Future paths

Establish definitions or extension points for the remaining disciplines, but do not fully implement unrelated combat, agriculture, brewing, or leadership systems solely to populate the skill interface.

# 9. Personal skill versus technology

Maintain a distinction between:

**Individual skill:** The Dwarf's growing competence through experience.

**Technological research:** The knowledge and machinery available to the player's settlement or civilization.

For example:

A skilled miner extracts a mineral seam more efficiently.

A researched industrial drill allows the mine to operate at a scale impossible with ordinary hand tools.

A master smith produces exceptional craftsmanship.

An advanced forge enables materials and manufacturing processes that traditional equipment cannot support.

Both forms of advancement should matter.

The game's research tree should eventually unlock carts, railways, industrial machinery, advanced workstations, automatons, and larger construction capabilities.

Use existing technology and progression architecture where practical.

# 10. Workers, delegation, and automation

The physical resource system must be designed for use by NPC workers and machinery.

Eventually, a hired Dwarf should be able to:

1. Identify loose material assigned for collection.
2. Pick it up.
3. Carry it to a suitable stockpile.
4. Retrieve material needed by a workstation.
5. Perform a processing job.
6. Deposit finished products into storage.

For this milestone, integrate a basic version with at least one existing worker system if technically practical.

Use a shared job/task model where possible rather than hardcoding different rules for player and worker processing.

Do not rewrite the entire NPC system unless necessary.

### Important design principle

**Automation should use the same underlying resources and production rules as manual labor.**

When an operation is delegated, it should not magically generate resources independently of the world economy.

Local operations should visibly move and process resources where reasonably practical.

Distant operations can eventually be simulated in aggregate for performance.

# 11. Integrate labor with construction and room quality

The products of mining and craftsmanship must have meaningful uses.

Connect processed stone and timber to existing or planned construction systems.

Where supported by the current project, allow the player to use these materials for:

- Walls.
- Flooring.
- Workstations.
- Storage facilities.
- Decorative masonry.
- Basic furnishings.
- Workshop improvements.

Do not launch a complete construction-system redesign unless the current implementation requires modest integration work.

The desired larger loop is:

**Excavate → Haul → Process → Craft → Construct → Improve living conditions → Increase prosperity → Unlock new ambitions.**

Skillful workmanship should be capable of improving finished object quality, which may influence room quality, NPC satisfaction, trade value, or prestige.

# 12. Game feel and visual quality

This feature depends heavily on animation quality.

Create polished, original 2D/cartoon-style animations for:

- Mining stone.
- Rock breaking free.
- Loose raw chunks.
- Picking up heavy materials.
- Carrying objects over the shoulder.
- Carrying two objects if unlocked.
- Placing and dropping items.
- Loading and unloading stockpiles.
- Pushing a wheelbarrow.
- Breaking raw stone at a workstation.
- Chopping or sawing timber.
- Smithing at a forge.

Animations should align with the relevant targets and equipment.

Tools must visually contact their work surfaces.

Prioritize excellent movement, sound synchronization, and readable silhouettes.

The Dwarf should feel strong, competent, industrious, and proud of his work.

Maintain our established original Dwarven aesthetic, with practical equipment, robust craftsmanship, carved details, and charming visual personality.

# 13. Avoid unnecessary grind

This is a nonnegotiable design requirement.

Do not make players:

- Walk excessive distances solely to deposit materials.
- Repeatedly open menus for trivial transfers.
- Individually collect dozens of tiny fragments.
- Perform identical timing minigames for every routine item.
- Wait through excessively long animations.
- Repeatedly process intermediate items with no meaningful decisions.
- Constantly manage restrictive stamina or weight limits.
- Perform manual work forever after appropriate automation has been unlocked.

Retain enough effort for accomplishment to feel earned.

Improve convenience through meaningful progression rather than removing all interaction from the beginning.

Consider allowing workstations to queue repeat jobs and pull resources from nearby designated storage.

The player should remain free to personally work materials even after extensive automation becomes available.

# 14. Implementation priorities

Implement in coherent stages within the existing project.

**Stage A — Physical resource extraction**
- Raw stone chunks and logs.
- Persistent physical world items.
- Pick-up, carrying, placing, and dropping.

**Stage B — Storage and material handling**
- Functional typed stockpiles.
- Reliable transfer interactions.
- Wheelbarrow or handcart.

**Stage C — Material processing**
- Stonebreaker.
- Timber-processing station.
- Physical work animations.
- Useful output resources and occasional discoveries.

**Stage D — Craftsmanship**
- Routine hold-E processing.
- Optional skilled smithing interaction.
- Workmanship quality.

**Stage E — Discipline progression**
- Miner, Mason, Forester, and Smith.
- Experience and meaningful unlocks.

**Stage F — Existing-system integration**
- Construction and crafting.
- Resource economy.
- Worker job compatibility.
- Save/load.
- Existing areas and progression.

Prioritize complete, playable workflows over numerous unfinished features.

If the task exceeds practical limits, complete a stable, coherent subset and record the remaining stages in the project handoff.

Do not claim unimplemented systems are complete.

# 15. Acceptance test

At completion, the player should ideally be able to:

1. Enter the existing Deepworks.
2. Mine a stone formation and produce a persistent raw chunk.
3. Pick up the chunk and visibly carry it.
4. Leave it on the ground and reclaim it later.
5. Deliver it to a stone stockpile.
6. Use a wheelbarrow or equivalent hauling equipment to move multiple chunks.
7. Retrieve stone from storage or supply a workstation.
8. Hold E to smash the raw chunk into useful material.
9. Occasionally discover a geode or mineral specimen.
10. Use processed stone for an existing construction or crafting purpose.
11. Gain Miner or Mason experience from the work.
12. Unlock a meaningful improvement through progression.
13. Repeat an equivalent logging and timber-processing workflow in Pinewood.
14. Use an existing forge to create a standard item or attempt higher-quality workmanship.
15. Save and reload without losing terrain changes, raw items, stockpile contents, skill progress, or equipment.

Test the actual interactions and visually inspect the relevant animation sequences.

Verify that material quantities are conserved through extraction, carrying, storage, processing, and crafting, subject to explicit recipe outputs and byproducts.

Confirm that existing trading, construction, NPCs, mining automation, Pinewood gameplay, and normal progression still function.

# 16. Delivery and checkpoint

Maintain the existing project and original assets.

Use normal version control and recovery checkpoint procedures, preserving older completed builds.

Update:
- `docs/SESSION_HANDOFF.md`
- `docs/CURRENT_STATUS.md`
- Relevant architecture documents.
- `PROJECT_INDEX.md`

Save a verified completed checkpoint that can be restored in a future Work session.

Provide a concise completion report distinguishing implemented, tested, incomplete, and deferred features.

Avoid excessive narrative progress reports.

# FINAL CREATIVE STANDARD

We want our Dwarf to feel like a working craftsman.

He digs a block of stone from the mountain.

He hefts it onto his shoulder.

He carries it to his workshop.

He breaks it apart with his hammer.

He discovers a beautiful crystal inside.

He uses the stone to improve his home and the crystal to create something magnificent.

As he grows more capable, he invents better tools, carts, machines, and systems that perform more of the repetitive labor for him.

He eventually commands an industrial empire capable of dismantling entire planetary systems.

But the physical satisfaction of handling materials, mastering crafts, and creating things remains a fundamental pleasure throughout the game.

**Make the Dwarf feel strong. Make the work feel real. Make the results matter.**

Implement this directly into our existing game, preserving established functionality and prioritizing enjoyable, complete systems.