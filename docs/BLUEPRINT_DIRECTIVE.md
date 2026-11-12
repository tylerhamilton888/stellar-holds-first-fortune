# THE STELLAR HOLDS: THE FIRST FORTUNE
## Unified Blueprinting, Room Design & Dwarven Homestead Construction

**Development Directive — Major Building System Improvement**

**Project:** The Stellar Holds: The First Fortune  
**Repository:** `tylerhamilton888/stellar-holds-first-fortune`  
**Engine:** Godot 4.4.1  
**Baseline:** Current verified development branch and published release

---

# 1. OVERARCHING OBJECTIVE

Develop a more intuitive, flexible, and satisfying construction system that allows players to design and gradually build their own Dwarven homes, workshops, great halls, underground complexes, and eventually substantial personal strongholds.

Our inspiration is the attachment players develop toward their farms in *Stardew Valley* and their homes in *Valheim*.

However, our game should express this through distinctly Dwarven activities:

- Excavating and shaping solid rock.
- Constructing durable stone buildings.
- Developing workshops and productive industry.
- Creating halls, chambers, stairways, and interconnected levels.
- Improving architectural styles through craftsmanship and research.
- Furnishing and personalizing one's household.
- Gradually transforming a modest homestead into a magnificent stronghold.

**The player should be able to envision an entire estate through blueprinting, then spend many enjoyable hours making that vision real.**

Construction must remain permanently meaningful. A player's first humble cottage should be capable of evolving into part of a much larger estate without being forcibly replaced by new story structures.

The completed system should eventually support both conventional aboveground manors and extensive subterranean complexes, including multiple levels extending beneath the original home.

# 2. CORE ARCHITECTURAL PHILOSOPHY

Adopt the following hierarchy:

**Architecture → Designation → Construction → Furnishing → Function → Quality**

Every room has three especially important characteristics:

### A. Physical architecture

A room exists as a physical space defined by:

- Location and dimensions.
- Vertical level.
- Floor and wall geometry.
- Entrances and connections.
- Ceiling or roof.
- Structural materials.
- Underground excavation where applicable.

### B. Intended designation

The player may designate a space as a Bedroom, Kitchen, Forge, Workshop, Storehouse, Great Hall, Corridor, Barracks, Treasury, or other supported function.

A designation informs:

- Suggested materials.
- Sensible architectural defaults.
- Recommended furnishings.
- Appropriate safety and structural requirements.
- Room quality assessment.
- Possible worker assignments and specialist bonuses.

**Designation must remain optional.**

An undesignated room may still function through the equipment installed within it.

### C. Actual function

The equipment and physical conditions determine what a room can do.

Examples:

- Beds provide sleeping accommodations.
- Furnaces provide supported smelting operations.
- Anvils permit relevant metalworking.
- Cooking stations enable food preparation.
- Chests and pallets provide actual storage.
- Installed machinery provides its existing production functions.

Designating an empty room as a Forge must not magically create functional equipment.

Likewise, placing a usable bed in an undesignated chamber must not make sleeping impossible.

**Room identity is a planning convenience, not an artificial permission system.**

# 3. A NEW PRIMARY BUILDING INTERFACE

Create a unified player-facing building interface called the **Blueprint Book**, or another similarly appropriate Dwarven term consistent with the game's writing.

The central action should be **Plan Your Holding**.

The player should be able to enter an overhead planning view and establish the layout of a structure or connected estate.

### Essential interactions

Allow players to:

1. Choose a floor or vertical level.
2. Select a room designation or leave the space undesignated.
3. Click and drag to establish rectangular dimensions.
4. Place adjacent rooms and corridors.
5. Add and relocate doorways.
6. Plan stairwells and connections between levels.
7. Select structural materials and architectural finishes.
8. Preview requirements and construction costs.
9. Save an unfinished blueprint.
10. Modify unbuilt plans without unnecessary material loss.
11. Begin construction when ready.
12. Inspect completed rooms and change their designation or finishes.

Blueprint outlines should distinguish planned, partially constructed, completed, inaccessible, and obstructed spaces.

Use clear, attractive visual presentation appropriate to our top-down Dwarven art direction.

Provide useful visual previews without obscuring the player or requiring excessive menu navigation.

## Preserve three construction modes

**Blueprint Mode:** Design rooms, halls, corridors, and structural connections.

**Furnishing Mode:** Arrange actual furniture, workshops, equipment, lighting, and decorative details.

**Fine Construction Mode:** Retain manual placement of individual floors, walls, doors, partitions, and other architectural components.

The new blueprinting system should become the preferred approach for larger construction.

The existing individual-piece system should remain available for detailed customization.

Do not remove established functionality or render existing player buildings obsolete.

# 4. ROOM DESIGNATIONS AND INTELLIGENT DEFAULTS

Room designations should make attractive architecture easy to create without preventing creative freedom.

Examples:

### Bedroom

Suggested features:

- Comfortable floor material.
- Appropriate wall treatments.
- Space for beds and storage.
- Suitable lighting.

Functional sleeping requires actual accessible beds.

### Forge

Suggested features:

- Durable fire-safe hearth surroundings.
- Broad equipment access.
- Space for raw materials and storage.
- Appropriate ventilation where supported by gameplay.

Actual equipment enables smelting, smithing, or other production.

Do not arbitrarily prohibit all wooden flooring in an entire workshop. Restrictions should be localized to physically relevant equipment and fire-safety areas.

### Kitchen

Suggested features:

- Cooking hearth location.
- Preparation surfaces.
- Food storage.
- Appropriate floor materials.

Actual cooking equipment provides production functionality.

### Great Hall

Suggested features:

- Wide entrances.
- Columns or arches.
- Central hearth opportunities.
- Decorative architectural focal points.

The room may be used for gatherings, household activity, or prestige without requiring a particular decorative arrangement.

### Storehouse

Suggested features:

- Broad doors.
- Strong floors.
- Shelving and pallet positions.
- Suitable freight access.

Only actual physical storage increases storage capacity.

### Undesignated Space

Allow unrestricted compatible furnishing and equipment placement.

A player should be able to create a mixed-use hearthroom containing a bed, kitchen, table, and workbench.

Avoid forcing a small starter household to construct six separate specialist rooms.

# 5. BLUEPRINTS ARE PLANS, NOT INSTANT CONSTRUCTION

Separate planning from physical construction.

A player should be able to sketch an ambitious future great hall before having sufficient resources to construct it.

Plans should remain persistent across saving and reloading.

Construction requires actual work and material expenditure.

### Aboveground construction

Physical progress may include:

- Clearing the designated area.
- Preparing foundations.
- Laying floors.
- Raising structural walls.
- Installing doors and stairways.
- Roofing.
- Applying finishes and furnishings.

Use appropriate existing systems where possible.

Avoid requiring individual placement of every routine wall tile when a complete room blueprint can construct the same geometry.

### Underground construction

Underground planning must preserve the game's physical mining mechanics.

A player may designate a room inside solid rock.

However, the rock must actually be excavated.

The blueprint should provide a useful guide to the excavation work while preserving:

- Geological materials.
- Rock hardness.
- Ore veins.
- Mining yields.
- Obstacles.
- Existing excavations.
- Structural requirements.
- Physical transport routes.

Do not instantly delete rock or award free mining resources.

Allow the player to excavate manually or eventually assign suitable workers to approved projects, using existing worker and excavation systems.

Partially excavated blueprints must survive interruption and reload.

# 6. CONSTRUCTION COSTS AND RESOURCE ACCOUNTING

Room costs should derive from physical dimensions and construction choices.

Use formulas based on:

- Floor area.
- Exterior perimeter.
- Shared partitions.
- Material selection.
- Roof or ceiling requirements.
- Structural supports.
- Doorways.
- Staircases.
- Decorative finish coverage.
- Underground excavation conditions.

Adjacent rooms should share structural walls when appropriate.

Do not double-charge a common wall.

Underground excavated bedrock should not require the same fabricated shell as an aboveground structure.

Excavation, structural stabilization, surface finishing, and furnishing should be accounted for separately.

Provide cost estimates before construction begins.

Allow contributions to unfinished plans in stages, without duplicating payments or spending unavailable resources.

Maintain material conservation and authoritative inventory ownership.

Use existing production, hauling, construction, and transaction systems instead of creating duplicate economies.

Previously completed construction should be recognized.

# 7. ARCHITECTURAL STYLES AND QUALITY

Separate **room purpose** from **architectural style**.

A Forge is a purpose.

Frontier Stonework is a style.

The player should be able to apply compatible styles to any suitable room.

Build upon the existing architecture styles, room finishes, and research systems.

Potential progression:

**Frontier Stonework**
- Rough stone.
- Timber framing.
- Practical masonry.
- Basic floors and hearths.

**Master Stonewright**
- Fitted ashlar masonry.
- Improved flagstones.
- Carved arches.
- Decorative columns.
- Better structural craftsmanship.

**Ancestral Grandeur**
- Ornamental knotwork.
- Copper and precious-metal inlays.
- Monumental architecture.
- Heraldic ornament.
- Advanced carved stonework.

These are illustrative categories. Reconcile them with existing implemented styles rather than duplicating established content.

Higher styles should generally require appropriate research, craftsmanship, and materials.

## Room quality

Build upon the existing LivingWorks quality model.

Assess relevant characteristics such as:

- Functional equipment.
- Comfort.
- Accessibility.
- Craftsmanship.
- Structural suitability.
- Decoration.
- Heritage.
- Clutter and usable space.

Better rooms should provide sensible benefits without making basic rooms useless.

An ordinary bedroom should remain perfectly suitable for sleeping.

A magnificent bedroom may provide greater comfort or resident satisfaction.

A well-designed workshop may improve worker conditions or production where appropriate.

Do not introduce arbitrary room levels or repetitive decoration requirements simply to increase scores.

Allow existing rooms to be renovated without destroying their layout, equipment, or contents.

# 8. VERTICAL CONSTRUCTION AND CONNECTED ESTATES

The long-term design goal is a unified, multilevel Dwarven holding.

Players should ultimately be able to build:

- Traditional aboveground cottages.
- Multi-storey manors.
- Attached workshops.
- Underground cellars.
- Excavated galleries.
- Deep workshops and storehouses.
- Underground great halls.
- Connected stairwells and freight routes.
- Large vertically organized strongholds.

The system should support a holding extending both **above and below ground level**.

A player may build a manor beside an existing mine, connect the two, and gradually develop chambers underneath the surface estate.

A sufficiently ambitious player should be able to construct something resembling an inverted skyscraper: a deep, interconnected structure with multiple occupied levels.

## Essential engineering requirements

Do not simply represent underground floors as unrelated rooms.

A connected estate needs meaningful:

- Vertical coordinates.
- Stair and lift connections.
- Floor-specific spatial layouts.
- Player travel.
- Worker travel.
- Equipment access.
- Storage ownership.
- Collision and pathfinding.
- Save/reload persistence.
- Structural and excavation restrictions.

Review the existing surface construction, building interiors, Deepworks, LivingWorks, and Mineworks systems before choosing an architecture.

Avoid introducing an enormous new world simulation when a bounded shared spatial model can reuse existing systems.

The result must remain performant.

Support additional levels conservatively and expand validated limits as the implementation matures.

Never silently truncate old construction or remove existing player property.

# 9. DWARVEN ARCHITECTURAL CHARACTER

Rectangular planning should make construction accessible, not visually sterile.

We do not want a collection of generic rectangular boxes.

Support attractive composite layouts through connected rectangles, corridors, alcoves, entrances, and architectural features.

Allow larger rooms to develop distinctive visual identities through:

- Columns.
- Arches.
- Vaulting.
- Carved wall details.
- Stone flooring.
- Timber framing.
- Hearths.
- Lighting.
- Runes.
- Banners.
- Decorative stonework.
- Appropriate industrial features.

Prefer original artwork consistent with the established in-world Dwarf character and environment style.

Evaluate new construction at actual gameplay scale and top-down perspective.

Do not introduce inconsistent perspective, placeholder rectangles, excessive floating text, or visually disconnected architecture.

The player should be able to create a handsome Dwarven home without spending hours manually decorating every surface.

Provide optional furnishing suggestions or presets, while preserving individual placement and customization.

# 10. HOMESTEAD AND CAMPAIGN INTEGRATION

The primary narrative purpose is to support the player's permanent personal homestead at Stonebridge.

Our intended fiction is the **Old Stonewright's Rise**, an abandoned quarry holding offered provisionally by Ivar to a promising worker.

The site offers potential for:

- A modest household.
- Outdoor workshops.
- Gardens.
- Storage and freight facilities.
- Stoneworking.
- Underground expansion.
- An eventual personal great hall.

Do not award an elaborate finished estate.

The player should develop it through their own work.

Preserve the existing permanent household charter and property continuity through Thaneship.

Early provisional use and later ownership should be handled as a separate, compatible story/progression adjustment where necessary.

**The estate should remain the same persistent player-owned place throughout the campaign.**

Do not replace it with a standardized noble residence when Thaneship is awarded.

## Relationship to the Hold's Ledger

A player should be able to improve their estate extensively without constantly advancing the campaign.

Equally, civic projects should offer worthwhile benefits that support the development of the player's household and enterprise.

Where appropriate, recognize significant player construction as evidence of craftsmanship, prosperity, and commitment to Stonebridge.

Avoid making players demolish and reconstruct existing achievements to satisfy narrative milestones.

The Ledger should encourage and reward building, not reduce construction to a temporary tutorial.

# 11. IMPLEMENTATION STRATEGY

This is a substantial architectural improvement. Implement it in controlled, verifiable stages rather than attempting a risky rewrite.

## Stage A — Unified room blueprinting

**Highest immediate priority.**

Deliver:

- Rectangular room and corridor planning.
- Optional room designation.
- Material and style choices.
- Clear cost previews.
- Saved unfinished plans.
- Connected doorways.
- Automated construction of ordinary structural components.
- Existing furniture and equipment integration.
- Manual fine-detail customization.
- Existing-save compatibility.

Begin with player-owned surface property.

The initial acceptance example should be a connected small manor consisting of a hall, bedroom, kitchen, workshop, and storage space.

A player should be able to plan, build, furnish, use, save, and reload this building without manipulating every individual wall section.

## Stage B — Underground blueprinting

Extend the planning model into actual excavated stone.

Deliver:

- Saved excavation plans.
- Room and corridor outlines.
- Meaningful mining progress.
- Appropriate rock and obstruction validation.
- Underground room finishing.
- Workstation and storage integration.
- Physical stair connections within supported mine levels.
- Suitable existing worker integration where technically justified.

Preserve mining yields and existing mine development.

## Stage C — Unified multilevel estates

Connect surface buildings and underground holdings through an integrated system.

Deliver:

- Physical transitions between estate levels.
- Aboveground and underground building relationships.
- Connected stairwells and appropriate freight routes.
- Valid player and worker navigation.
- Save-compatible vertical expansion.
- Support for extensive personal strongholds.

Do not announce this stage as complete until actual connected travel and persistence are demonstrated.

### Important staging rule

Complete and validate each stage before substantially expanding the next.

If an architectural obstacle makes a stage unsafe or impractical, document the exact blocker and implement the largest safe, coherent subset.

Do not leave half-connected systems that compromise established construction.

# 12. QUALITY ASSURANCE AND REGRESSION PROTECTION

Inspect the actual current repository before implementation.

Relevant existing owners include:

- `architecture.gd`
- `architecture_view.gd`
- `building_plans.gd`
- `hearthcraft.gd`
- `living_works.gd`
- `mineworks143.gd`
- `deepworks.gd`
- `surface.gd`
- Existing furniture, room-layout, state, and inventory systems.

Use established tests and extend the relevant cases.

Essential acceptance scenarios:

1. Plan a rectangular bedroom.
2. Change its designation before construction.
3. Modify its dimensions without spending materials.
4. Connect it to another room.
5. Verify the displayed costs.
6. Build the room using actual supplies.
7. Confirm correct material expenditure.
8. Furnish and use the completed room.
9. Leave a room undesignated and verify its supported equipment still works.
10. Upgrade its architectural finishes.
11. Save and reload unfinished blueprints.
12. Save and reload completed buildings and furnished rooms.
13. Confirm existing buildings, chests, and equipment remain intact.
14. Reject blocked, overlapping, or inaccessible construction.
15. Verify connected stair travel.
16. Verify underground excavation preserves rock yields and terrain.
17. Prevent duplicate payments, refunds, and production rewards.
18. Ensure ordinary player navigation and worker access remain valid.

Add relevant visual inspection at actual gameplay scale.

Do not rely exclusively on direct state manipulation.

Preserve existing saves, resource records, constructed buildings, NPC assignments, and previous releases.

# 13. DEVELOPMENT AND DELIVERY REQUIREMENTS

Follow the existing repository instructions, development conventions, release pipeline, and owner-approved delivery process.

Avoid unrelated changes.

Keep output bounded and retain full diagnostics in files.

Preserve original assets and resource dependencies.

Maintain recovery checkpoints.

Do not perform destructive repository operations or replace previous releases.

Use focused checks while iterating, followed by the existing full validation gates before publication.

Update relevant documentation, current status, backlog, and playtest guidance to reflect verified implementation.

Do not claim an unimplemented stage has been delivered.

Avoid publishing a release that contains an unusable partial conversion of the construction system.

# 14. DEFINITION OF SUCCESS

The finished blueprinting experience should allow a player to begin with a modest holding and gradually transform it into an impressive, personalized Dwarven estate.

They should be able to:

- Draw out the rooms they want.
- Choose their intended functions.
- Build with actual gathered resources.
- Customize appearance and furnishings.
- Make useful domestic and industrial spaces.
- Connect structures meaningfully.
- Expand vertically over time.
- Preserve and improve everything they have built.

A casual player should find room construction intuitive and produce attractive results.

An enthusiastic builder should retain detailed creative control.

A miner should eventually be able to carve an enormous personal stronghold into the mountain without having to treat each individual wall or floor tile as an independent construction task.

## Guiding principle

**Plan at the scale of rooms and halls. Work at the scale of stone and craftsmanship. Customize at the scale of individual details.**

The Stellar Holds should not merely let players place structures.

It should let them envision, construct, inhabit, and gradually perfect a Dwarven home that remains meaningful throughout their entire adventure.

**Implement Stage A as the first concrete deliverable, then proceed through the underground and multilevel stages with verified, save-safe checkpoints.**