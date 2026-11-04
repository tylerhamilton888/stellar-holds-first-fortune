# THE STELLAR HOLDS: THE FIRST FORTUNE
## Opening Campaign, Community Restoration, Contest Progression & The Road to Thane

**Godot 4 | Existing GitHub Repository | Major Development & Integration Directive**

### PRIMARY OBJECTIVE

Continue developing our existing *The Stellar Holds: The First Fortune* project.

We are building a cozy, character-driven Dwarven life-simulation RPG with meaningful mining, crafting, gathering, hauling, homesteading, combat, exploration, friendships, and an authored narrative campaign.

Our immediate objective is to deliver a cohesive opening campaign, beginning with the player as a humble worker in a communal bunkhouse and culminating in their recognition as a Thane.

**The central progression system should feel structurally similar to Stardew Valley's Community Center.**

Players should constantly encounter interesting contributions, restoration projects, material collections, personal goals, and satisfying unlocks. Completing these activities should improve the world, introduce new gameplay systems, develop characters, and advance the story.

Our contest narrative provides the motivation and dramatic framework for these accomplishments.

Do not start a new project, unnecessarily rewrite existing systems, discard established lore, or replace working functionality.

Inspect the actual repository and build upon what already exists.

---

# PART I — THE CENTRAL GAMEPLAY PHILOSOPHY

## 1. The Community Center Model

The core gameplay progression should evoke the satisfying experience of completing Stardew Valley's Community Center bundles.

In Stardew Valley, players naturally explore different professions and activities because the Community Center provides tangible reasons to do so.

Collecting resources, exploring, fishing, farming, and processing materials gradually produces meaningful rewards and permanently changes the world.

**We want that same underlying experience, adapted to Dwarven civilization.**

Instead of restoring a Community Center, players will gradually restore, strengthen, and enrich their Dwarven settlement while earning recognition through the contest.

Examples include:

- Restoring an abandoned forge.
- Reopening a collapsed mining route.
- Repairing bridges and transportation infrastructure.
- Supplying community storehouses.
- Constructing workshops and industrial facilities.
- Improving communal housing.
- Developing farms, fishing operations, and food production.
- Recovering ancient Dwarven artifacts.
- Establishing defenses.
- Restoring ancestral monuments.

These should be substantial, rewarding projects with clear objectives and visible outcomes.

The progression should continually encourage players to try different activities without demanding they master everything.

### The Desired Daily Gameplay Loop

The player wakes up at home and checks their objectives.

Perhaps the forge needs iron bars, the storehouse requires preserved fish, and an old bridge needs timber and stone.

The player chooses what interests them.

They spend the day mining, gathering, crafting, exploring, or interacting with NPCs.

Along the way, they discover new materials, unlock recipes, improve skills, develop relationships, or encounter interesting events.

They return to town, contribute resources, and see meaningful progress.

Completing a major project unlocks new facilities, locations, characters, quests, or narrative developments.

The next day presents new opportunities.

**The desired feeling is: "I'll just play one more day. I'm almost finished with that project."**

The story gives these activities significance, but the moment-to-moment gameplay must remain satisfying independently.

---

# PART II — THE HOLD'S LEDGER

## 2. The Central Progression Interface

Create or refine a distinctively Dwarven progression interface called the **Hold's Ledger**.

This is our equivalent of the Community Center collection interface, integrated with the contest.

The ledger should feel like an actual object within Dwarven society rather than a generic video-game quest menu.

Visual direction:

- Stone or carved wooden framing.
- Brass fittings.
- Parchment or engraved project notices.
- Profession and ancestral emblems.
- Clear contribution slots and quantities.
- Visible completed-project recognition.
- Satisfying completion animations and feedback.
- Readable, polished, Stardew-inspired interface design.

The ledger should be accessible in an appropriate community location, with a convenient means of reviewing objectives elsewhere.

### Three Layers of Progression

Organize the system into three interacting layers.

#### A. Major Community Restoration Projects

These are substantial projects that change the settlement and advance the opening campaign.

Examples:
- The Cold Forge.
- The Winter Stores.
- The Old Road.
- The Great Lift.
- The Deepworks Expedition.
- A major communal building.
- An ancestral restoration project.

These projects teach important systems, provide major rewards, and unlock new chapters of gameplay.

Not every project needs to be completed to advance. However, some foundational milestones and a reasonable degree of community contribution should be required.

#### B. Optional Collections and Commissions

These are smaller bundles that give players reasons to explore individual professions.

Examples:

**The Miner’s Contribution**
- Copper ore.
- Iron ore.
- Stone.
- A rare mineral.

**The Hearthkeeper's Contribution**
- Prepared meals.
- Preserved provisions.
- Cooking ingredients.
- Specialty dishes.

**The Woodworker's Contribution**
- Timber.
- Planks.
- Wooden fittings.
- Crafted furniture.

**The Angler's Contribution**
- Common freshwater fish.
- An uncommon fish.
- A prepared fish dish.
- A special catch.

**The Smith's Contribution**
- Metal bars.
- Forged fittings.
- Tools.
- A crafted weapon or utility item.

These collections should have interesting rewards, including recipes, furnishings, money, equipment, friendship opportunities, cosmetics, crafting improvements, and special recognition.

They should not all be mandatory.

Where practical, add themed collections for farming, exploration, combat, construction, and other existing gameplay systems.

Avoid collections requiring enormous quantities of repetitive materials without meaningful purpose.

#### C. Personal Ambitions

The player should also have personal objectives running alongside community contributions.

Examples:

- Establishing a home.
- Expanding and decorating the homestead.
- Building a personal workshop.
- Upgrading equipment.
- Developing friendships.
- Courting and potentially marrying another Dwarf.
- Improving professional skills.
- Exploring dangerous locations.
- Acquiring unusual treasures.
- Learning the player's ancestry.

These do not all need to feed directly into contest scoring.

Some activities are worth pursuing simply because they make life in the world richer.

---

## 3. Major Projects Should Have Multiple Stages

Unlike Stardew Valley's predominantly item-based bundles, our major projects can incorporate physical labor, exploration, construction, and authored quests.

For example:

### The Great Lift

**Stage 1: Investigation**
- Inspect the abandoned lift.
- Learn why it stopped functioning.
- Meet the Dwarfs responsible for restoring it.

**Stage 2: Material Contributions**
- Supply timber.
- Provide iron fittings.
- Gather stone for reinforcements.

**Stage 3: Reconstruction**
- Work with the appropriate craftsmen.
- Repair mechanisms.
- Install supporting structures.

**Stage 4: Securing the Route**
- Explore the lower landing.
- Deal with environmental hazards.
- Defeat or drive away hostile creatures.

**Completion Rewards**
- The lift becomes permanently operational.
- New areas of the Deepworks become accessible.
- New ores and materials become available.
- NPCs begin using the lift.
- Additional commissions appear.
- The player earns substantial recognition.

This should feel like completing an important public works project, not simply checking boxes.

Some projects should be simpler. Others may become major adventures.

**Scale project complexity according to its narrative and mechanical importance.**

---

# PART III — REQUIRED EXPERIENCES AND PLAYER FREEDOM

## 4. Guided Introductions Without Endless Tutorials

A central benefit of the Community Center approach is that it gives players a reason to learn different systems.

We should exploit this deliberately.

For example, restoring the forge provides a natural reason to teach:

1. Mining ore.
2. Transporting resources.
3. Smelting metal.
4. Crafting basic equipment.
5. Contributing materials to construction.

Once introduced, these systems should become increasingly flexible.

Later projects might allow the player to provide materials through mining, crafting, trading, hauling, or suitable NPC assistance.

We want players to experience the breadth of Dwarven life without requiring identical playstyles.

### The Foundation and Specialization Model

Major projects may have two kinds of requirements.

**Foundational requirements:** Short, guided experiences that teach essential mechanics.

**Specialized contributions:** Larger objectives that allow players to pursue their preferred activities.

The first teaches the player how the world functions.

The second lets the player decide what kind of Dwarf they want to become.

Where alternate paths exist, they should provide genuinely equivalent narrative eligibility, though they need not require identical time or resources.

Avoid allowing the player to bypass nearly every system by repeatedly using one overly efficient activity.

Equally, avoid requiring exhaustive mastery of every profession.

### Pacing

Maintain three overlapping levels of motivation:

- **Short-term:** A useful accomplishment achievable in a single play session.
- **Medium-term:** A restoration project, important upgrade, or relationship milestone.
- **Long-term:** A new campaign act, major discovery, permanent facility, or eventual recognition as Thane.

Allow multiple projects to remain active simultaneously.

Partial contributions should be retained and displayed clearly.

A player should be able to complete several small achievements without advancing the main storyline.

Do not punish players for enjoying fishing, farming, home decoration, relationships, or exploration at their own pace.

---

# PART IV — THE CONTEST IS THE NARRATIVE WRAPPER

## 5. Do Not Build a Real Competition Simulator

**This is critically important.**

The contest is smoke and mirrors.

It is a storytelling mechanism disguising authored acts, benchmarks, quests, and progression gates.

We do not need a simulated economy in which competitors independently collect resources and calculate scores.

Instead, the contest provides public recognition for the player's achievements.

The ledger, contribution marks, rival standings, announcements, and ceremonies help frame the player's development.

Skarrin's apparent contest progression should follow authored narrative milestones.

The eventual apparent tie and public trial can be predetermined.

However, the presentation must make the outcome believable.

Recognition should correspond to accomplishments the player actually completed. Avoid sudden unexplained score adjustments, contradictory standings, or obvious manipulation.

The player should feel that their hard work earned their position.

The contest should never become a stressful countdown.

**The player is progressing through an RPG campaign, not racing an NPC spreadsheet.**

---

# PART V — THE EIGHT DEEDS

## 6. Organizing Dwarven Accomplishments

Use the established eight-god Dwarven religious structure as thematic inspiration for eight broad categories of contribution.

Suggested categories:

1. **Stone:** Mining, excavation, and delving.
2. **Flame:** Smithing, craftsmanship, and industry.
3. **Hearth:** Housing, cooking, and homesteading.
4. **Harvest:** Farming, fishing, and provisions.
5. **Road:** Exploration, trade, and transportation.
6. **Shield:** Combat, protection, and rescue.
7. **Kin:** Friendship, family, and community.
8. **Oath:** Honor, ancestry, tradition, and legacy.

These are not eight mandatory skill trees.

They provide thematic organization for the ledger, achievements, public recognition, and quest design.

Allow achievements to involve multiple categories.

For example, restoring a mine might involve Stone, Flame, Road, and Shield.

The player should feel that all forms of honest Dwarven work belong within a unified civilization.

Our established pantheon recognizes the interconnected nature of these activities, without forcing the player to select one patron deity.

Preserve established religious lore and actual deity names wherever they already exist.

---

# PART VI — THE FIVE-ACT OPENING CAMPAIGN

## ACT I — A PLACE OF YOUR OWN

The player begins in a communal worker hub with miners, bunks, and modest facilities.

Introduce:
- Basic movement and interaction.
- Mining and resource gathering.
- Physical carrying and storage.
- Construction.
- Energy, sleep, and daily routines.
- The Hold's Ledger.
- Basic commissions.
- NPC relationships.

The player's first major personal ambition is to claim and restore a modest home.

Ivar and other established characters introduce community life.

Skarrin is initially welcoming.

The player begins making small contributions and establishes their place in the hold.

**End milestone:** A personal home and initial recognition.

## ACT II — HANDS OF THE HOLD

Focus on productive life and community restoration.

Introduce:
- Smelting and smithing.
- Improved equipment.
- Larger material contributions.
- More advanced hauling.
- Farming and fishing.
- Cooking and provisions.
- Restoration of significant facilities.
- Friendship storylines.

The player becomes increasingly recognized.

Skarrin congratulates the player, although his comments become subtly condescending.

**End milestone:** Recognition as a capable, dependable contributor.

## ACT III — BENEATH THE MOUNTAIN

Shift toward deeper exploration and danger.

Introduce:
- Advanced excavation.
- Mining hazards and support structures.
- More demanding material transportation.
- Better equipment and provisions.
- Combat challenges.
- Dangerous expeditions.
- Valuable underground discoveries.

Include a major rescue or dangerous expedition demonstrating the player's character and competence.

Begin meaningful hints toward the player's ancestry.

Skarrin recognizes the player as a serious contender.

**End milestone:** A major heroic accomplishment and increasing public prestige.

## ACT IV — THE WEIGHT OF AN OATH

Focus on responsibility, accomplishment, and legacy.

Introduce:
- Prestigious community projects.
- Advanced production chains.
- Major construction and restoration.
- Substantial homestead development.
- Deeper relationship milestones.
- Ancestral exploration and discoveries.
- Specialized contributions representing the player's preferred accomplishments.

Skarrin's resentment becomes increasingly public.

The player's ancestry complicates the contest.

**End milestone:** Eligibility for the final recognition and trial.

## ACT V — THE THANE'S TRIAL

Resolve the opening campaign.

Bring together:
- The player's major accomplishments.
- Their relationships.
- The contest.
- Their ancestry.
- Skarrin's rivalry.
- Their demonstrated worth as a Dwarf.

The final contest result leads to an apparent tie or dispute, followed by an authored public trial.

The climactic sequence should incorporate meaningful gameplay and narrative choices rather than merely comparing points.

The player ultimately earns recognition as a Thane.

The journey to Keldrath and the elevation to Thane conclude the opening campaign.

**Becoming Thane should open future opportunities rather than conclude the game itself.**

---

# PART VII — SKARRIN'S EVOLVING CHARACTER ARC

## 7. Begin With a Welcoming Skarrin

Skarrin should initially appear friendly, generous, and welcoming.

He sees the player as a humble newcomer who might admire him, support his ambitions, and join his social circle.

He enjoys presenting himself as a defender of ordinary workers and a champion of fairness.

His generosity can occasionally be genuine, particularly when he believes himself superior to its recipient.

### Stage I — The Generous Comrade

Skarrin welcomes the player, provides advice, and perhaps offers modest assistance establishing their home.

He appears to be a perfectly reasonable potential friend.

### Stage II — The Condescending Friend

Skarrin begins minimizing the player's accomplishments through patronizing compliments.

He may suggest that the player support his own contest ambitions.

He remains outwardly friendly.

### Stage III — The Threatened Rival

After an important public achievement, Skarrin recognizes the player as a legitimate competitor.

His friendliness begins slipping.

Jealousy, passive aggression, and insecurity become noticeable.

### Stage IV — The Aggrieved Reformer

Skarrin portrays himself as the victim of an unfair social order.

He complains about established families, hereditary privilege, favoritism, and the contest's rules.

He is a hypocrite who was perfectly comfortable with those arrangements when he expected to benefit.

His supposed devotion to fairness conceals resentment toward those he considers above himself.

### Stage V — The Open Antagonist

Skarrin openly challenges the player and the legitimacy of the contest.

The player's ancestry becomes a focus of his resentment.

He considers himself righteous and misunderstood, never recognizing how much of his downfall he has caused.

### Critical Character Requirements

The player must be able to remain courteous toward Skarrin.

Positive conversations, gifts, and assistance should remain possible where narratively appropriate.

However, he cannot be permanently won over through friendship points.

His fundamental problem is his inability to tolerate the player's success.

His changing attitude should be tied to story milestones.

One important recurring detail: an early gift or favor he initially provides freely may become something he repeatedly cites as proof the player owes him gratitude and loyalty.

Give Skarrin believable early friendship interactions before revealing his true nature.

**We want the player to discover his hypocrisy themselves.**

---

# PART VIII — CHARACTER RELATIONSHIPS AND STORY EVENTS

## 8. Integrate Relationships Into Progression

Keep our existing friendship and romance direction.

Important NPCs should feature:
- Individual personalities.
- Distinct routines.
- Friendship milestones.
- Personal questlines.
- Small authored scenes.
- Suitable rewards.
- Dialogue responding to campaign progress.

Relationships should occasionally provide useful alternative routes through community projects.

For example, befriending Borin might unlock help with a difficult smithing requirement.

Helping a miner's family might reveal a useful resource location.

A trusted merchant might offer a special procurement opportunity.

Relationships should have genuine mechanical and narrative value without becoming universally mandatory.

Preserve the craftable courtship item system and established romance mechanics.

### Memorable Story Moments

Include authored scenes at major campaign turning points.

Examples:
- The player receives their first home.
- A major facility is restored.
- Skarrin publicly congratulates the player while privately resenting them.
- A dangerous rescue demonstrates the player's character.
- The player's ancestry becomes significant.
- The contest enters its final stage.
- The public trial determines the player's future.

Preserve our proposed Maren tavern confrontation.

In this scene, she confronts rude miners, potentially associated with Skarrin, overturns their table, and declares:

"If you're going to act like orcs, you can eat like orcs!"

Ensure that scenes suit the personalities and circumstances of the characters.

Avoid unnecessarily lengthy cutscenes or dialogue that interrupts gameplay too frequently.

---

# PART IX — THE WORLD MUST VISIBLY IMPROVE

## 9. Permanent Changes Matter

One of the most important rewards for completing major projects should be seeing the results.

The world must visibly respond to community restoration.

Examples:

**Restore the forge:** Furnaces operate, NPCs work, crafting becomes available, and new commissions appear.

**Repair a bridge:** A previously inaccessible route becomes usable.

**Reopen a mine:** New mineral deposits, working miners, and underground activities become available.

**Improve a storehouse:** The building changes, supplies appear, and residents use the improved facility.

**Restore the Great Lift:** Its mechanisms become operational, and the Deepworks become accessible.

These changes must persist through saving and loading.

NPC schedules, dialogue, and activities should update where appropriate.

Do not rely solely on text announcements or invisible progress flags.

The player should be able to look around the hold and recognize the results of their work.

---

# PART X — IMPLEMENTATION AND DEVELOPMENT PROCESS

## 10. Inspect Before Building

Begin by examining the actual project.

Identify:
- Existing quest and campaign systems.
- Existing contest mechanics.
- Current NPC relationships.
- Dialogue and cutscene systems.
- Existing mining, crafting, gathering, farming, fishing, hauling, combat, and exploration functionality.
- Save/load structures.
- Existing locations and restoration opportunities.
- Current progression blockers or inconsistencies.

Distinguish clearly between what is already implemented, partially implemented, and missing.

Do not assume everything described in this directive already exists.

Reuse functional systems whenever possible.

## 11. Build a Reusable Contribution System

The Hold's Ledger should use reusable project data and state rather than being hardcoded for each individual quest.

Where compatible with our existing architecture, support:

- Project identifiers and categories.
- Unlock prerequisites.
- Required materials and quantities.
- Partial contributions.
- Multi-stage objectives.
- Alternative contribution routes.
- Completion rewards.
- World-state changes.
- NPC relationship consequences.
- Campaign milestone triggers.
- Save/load persistence.

Allow new collections and projects to be created without major code changes.

Design project tracking so the same material or objective is not accidentally consumed twice.

Prevent accidental completion, repeated reward claims, broken prerequisites, and progression softlocks.

### Campaign State

The five acts should operate as authored story milestones.

Use clear conditions that determine when story events, new projects, and narrative chapters become available.

Skarrin's progression should be attached to these conditions rather than an independent competitive simulation.

### Interface Requirements

Provide readable distinctions between:

- Available projects.
- Locked projects.
- Projects in progress.
- Completed projects.
- Optional collections.
- Personal ambitions.
- Important narrative objectives.

Show material requirements, progress, rewards, and unlock information clearly.

Use satisfying visual and audio feedback for contributions and major completions.

Maintain our established top-down, Stardew-inspired aesthetic.

Avoid floating placeholder text, generic debug interfaces, inconsistent icons, and poorly scaled menus.

---

# PART XI — DEVELOPMENT PRIORITIES

Implement this direction in manageable, testable batches.

### Milestone 1 — Campaign and Ledger Foundation

- Audit existing systems.
- Establish consistent campaign state.
- Implement or refine the contribution framework.
- Create the Hold's Ledger interface.
- Verify partial contributions and saving/loading.

### Milestone 2 — The Opening Experience

- Refine the worker hub and introductory experience.
- Establish the first home restoration.
- Add appropriate introductory projects and collections.
- Introduce Skarrin as a friendly character.
- Connect accomplishments to the early contest narrative.

### Milestone 3 — Productive Dwarven Life

- Develop meaningful restoration projects.
- Integrate crafting, mining, hauling, fishing, farming, and provisioning.
- Add permanent world improvements.
- Expand friendship interactions and Skarrin's early rivalry.

### Milestone 4 — Exploration and Major Story Events

- Integrate deeper mining and exploration.
- Develop the major rescue.
- Add ancestry discoveries.
- Expand project specialization.
- Develop Skarrin's increasingly hostile narrative.

### Milestone 5 — The Road to Thane

- Complete the late-campaign restoration milestones.
- Integrate the ancestry revelation.
- Implement the contest's resolution and trial.
- Deliver the recognition as Thane.
- Preserve meaningful post-campaign progression.

### Milestone 6 — Polish and Validation

- Test the full campaign progression.
- Review pacing and resource requirements.
- Verify multiple contribution routes.
- Validate all rewards and persistent world changes.
- Check NPC dialogue and cutscene triggers.
- Resolve visual inconsistencies and unnecessary placeholders.
- Confirm reliable save/load behavior.

Use development tools to test milestone transitions without manually replaying the entire campaign repeatedly.

**Avoid enormous, fragile release operations.**

Commit and validate changes in manageable increments. Use the established release pipeline, eliminate unnecessary build steps where practical, and prioritize reliable, testable deliveries.

Do not spend excessive time on unrelated refactoring.

---

# PART XII — THE EXPERIENCE WE ARE TRYING TO CREATE

The player should experience a satisfying progression from humble newcomer to established Dwarf.

They should have meaningful reasons to:

- Mine deeper.
- Craft better equipment.
- Learn new professions.
- Build a better home.
- Restore community facilities.
- Explore unfamiliar areas.
- Develop friendships.
- Pursue romance.
- Confront dangerous enemies.
- Discover ancient history.
- Earn the respect of their people.

These experiences should reinforce one another.

A day spent mining should advance a community project.

A community project should unlock useful equipment.

Better equipment should make new adventures possible.

Adventures should reveal valuable materials and interesting characters.

Those discoveries should create new crafting, relationship, and homesteading opportunities.

The player should continually experience this interconnected growth.

The contest provides direction and dramatic stakes, but does not dominate every activity.

Skarrin's increasingly bitter rivalry provides a personal narrative counterpoint to the player's success.

The Hold's Ledger gives accomplishments tangible form.

Restoration makes the world visibly richer.

And the final recognition as Thane brings the opening campaign to a satisfying conclusion.

**The player's accomplishments should be visible not merely in a score or title, but in the home they built, the characters they befriended, the dangers they overcame, and the community they helped transform.**

That is the heart of this design.

## IMMEDIATE EXECUTION DIRECTIVE

Inspect our current repository and integrate this consolidated direction into the existing game.

Prioritize the reusable Hold's Ledger framework, opening projects, first-home progression, and Skarrin's initial friendship arc.

Preserve and incorporate existing narrative, gameplay, lore, and assets wherever appropriate.

Proceed with implementation rather than stopping at a design document.

Work in small, cohesive, validated increments, and report precisely what was implemented, what was tested, and what remains.

Our goal is a playable, engaging, cohesive opening campaign—not an ever-expanding collection of disconnected features.
