# Current milestone: 0.43.0 — The Living Works
Integrated workshops, bedrooms and craftsmanship in the existing Deepworks. See docs/CURRENT_STATUS.md and docs/PROJECT_INDEX.md. O opens the works board underground.

# Current build: The Weight of the Mountain 0.42.0
Read docs/CURRENT_STATUS.md and docs/SESSION_HANDOFF.md. This is the integrated existing game; open project.godot with Godot 4.4.1.

> Development entry point: [docs/SESSION_HANDOFF.md](docs/SESSION_HANDOFF.md), then [docs/CURRENT_STATUS.md](docs/CURRENT_STATUS.md). Checkpoint: weight-0.42.0; gameplay 0.42.0. Older notes below may describe superseded behavior.

# The Stellar Holds: The First Fortune

Original Godot 4.4.1 game, version 0.42.0. Windows x64.

## Play on Windows — no separate Godot installation needed

1. Extract the **entire** ZIP into a normal folder.
2. Open `PLAY-WINDOWS.bat` in the extracted folder.
3. Choose **Begin a new fortune**, select an empty save slot, name and customize your dwarf, then begin.
   Use **Choose a fortune** and the slot’s **Continue** button on later visits. Existing saves still work; begin a new fortune to experience the employment opening.

Do not launch from inside the ZIP. `Engine/Godot.exe` is the unmodified official
Godot 4.4.1 Windows editor/runtime, bundled for convenience. The launcher runs
`FirstFortune.pck` directly; it does not open the editor or install anything.
The Windows launcher is supplied but has not been executed on Windows here.
The game and packaged data were tested with Godot 4.4.1 on Linux.

The editable project is supplied separately as `Stellar-Holds-0.42.0-Source.zip`.
Extract that archive and import `stellar-holds/project.godot` in Godot 4.4.1.
Python is not required to play. Source art, material maps and the offline animation
baker are included in the source archive.

## Changes in 0.42.0
Deepworks now has physical breakup, graded ore, a 64-unit bucket and a positioned 320-unit wheelbarrow. H opens haulage, C takes/parks the cart, U delivers or caches bulk, Shift+U loads piles, L tracks a project. Overflow is saved. Deliver at the entrance to use ore in existing crafting and trade. Crews keep their delivery service. Five-depth mining, stairs and survey remain integrated; Pinewood is unchanged. Rails are the next milestone. Read current status for compatibility limits.

## Changes in 0.40.0
Pinewood now has painted forest scenery, seven marked firs and a field board. Equip axe [3], stand beside a trunk and hold LMB over it. Recover timber from fallen logs too. Each full fir yields 22 timber; existing cuts and recovered logs stay saved. G opens basin travel. No automatic regrowth; Orla remains a timber fallback.

## Previous changes in 0.39.1

- Removed the exchange artwork strips that were repeated on both sides of every standard indoor room. Each room now fills the width using its own artwork at a uniform scale, anchored to its painted floor. Hearth and instrument light positions follow the resized artwork.

## Changes in 0.38.1

- Upward mining uses the raised-arm work drawings, their hand socket and an upward reach check. Tool size and grip remain fixed; the first solid surface still blocks mining through walls.
- The mine has opaque backing under every original surface column, with world-anchored rock texture. It no longer depends on triangulating a large moving silhouette over the sky.
- Removed the placeholder royal stair inside Ivar's office and its interaction. Enter the King's hall on Crownward; leaving returns to that same district, including older saves with the office shortcut recorded.
- Commission, lesson and local errand screens use consistent portrait/dialogue/response layouts. Journal views remain factual outside a conversation. Removed errand offers from unrelated service menus; returning to conversation clears stale menu history.
- Existing saves and WIP labels are retained.

## Changes in 0.38.0

- Unimplemented hold wings are marked **WIP** on the floor and overview, with an explanation when approached. **Build status · WIP** in Pause or Guide lists unfinished features. Ship menus explicitly distinguish the playable construction/launch milestone from unimplemented interstellar travel. Marriage, children and succession are also marked WIP in the chronicle. Quest and resource requirements remain distinct.

- Eirik now has a unique world sprite at dwarf scale. His painted portrait remains in conversation and the royal audience.
- Crownward, Hearthward and Forgeward have matching painted districts. Stairs, lift landings, doors and solid fixtures use measured map positions. Older map positions migrate to a valid landing.
- Speaking to residents opens a portrait, dialogue and response choices. Gold diamonds mark quest choices; ordinary questions and services have separate responses.
- Orla and Hedrik offer separate secret gift requests in their own workplaces. Only accepted gifts appear in the journal. Whoever receives the second finished gift invites you to the exchange with a different line. Existing gift progress is retained.
- The concourse and Hearthward expedition tables open basin travel. Hold, trail and mine no longer blend together at walking edges. Return to the mine entrance to travel home; underground escape restrictions still apply.
- The pickaxe keeps a fixed grip and size at every reach. Mining takes priority over airborne poses and uses the same scale for body, hand, tool and foreground fingers.

## Focused playtest

1. Speak to Ivar, then visit Orla or Hedrik. Check the conversation choices and the separate secret requests.
2. Press G in Keldrath. Explore each district, use stairs or the lift, then visit the expedition table beside the eastern gate.
3. Walk to Old Workings on the basin map and enter with E. Try close and distant mining, both directions, including a strike while falling.
4. Walk back to the mine entrance and use E or G to set out. Finish the spouses' gifts in either order; the second host invites you to the exchange.

## Changes in 0.37.1


- Corrected hair pigment spilling into shaded neck skin beneath ears, alongside braids and below beards.
- Protected neck coverage applies to portraits and all source pose families, including the already baked walking frames. Existing walk drawings, stride, gear sockets and controller settings are unchanged.
- Recoloring keeps those shaded pixels in the skin material, so they also follow the selected complexion correctly.

## Changes in 0.37.0

- Every walking cycle keeps the same head, beard and braids throughout its sixteen frames. Moving forearms pass in front of the braid; the hairstyle no longer changes with the arm pose.
- Shorter steps and slimmer boot spacing reduce the broad stance. Normal walking speed is now 160 units per second, with the same acceleration and braking. Distance-driven foot contacts and carried-gear sockets remain in use.
- Portraits now use separate, continuous material coverage for hair, skin, clothing and fittings at 512 pixels. Coverage follows the painted boundaries and preserves shading through those edges. Raw coverage data bypasses texture alpha processing, which is inappropriate for material channels.
- All five male and five female designs, shared hair/beard color, current saves and the opening quests remain available.

## Changes in 0.36.0

This replaces the 0.35 walking experiment after visual review exposed repeated
poses, coarse sampling and incorrect material boundaries. The previous structural
checks did not establish the quality of the resulting animation.

- Sixteen whole-frame poses per design and equipment state. The stance foot moves backward as the character advances; the opposite boot lifts, passes and returns. Boots preserve their painted shape, and the two steps exchange front/back leg order.
- Walking is tied to distance traveled. Footstep sounds use the two contact frames. Carried weapons and their finger overlays use the new pose's hand socket.
- Original source detail is retained at twice the former sampling resolution; walking frames render from 3x textures. Removed the extra small sprite-atlas bake and enlarged the creator preview's render target. Fractional edge alpha is retained.
- Rebuilt material maps distinguish hair cores, shaded hair edges, exposed complexion and fittings. Reviews include dark and pale palettes, shaved temples, braid highlights and braid ends. Hair and beard still share one color selection, and all five male and five female designs remain available.
- This update includes the illustrated opening, single-location NPC registry, and western gallery from 0.35.
- Validation includes source and exported-pack loading, foot-contact checks, complexion/hairline regressions and all ten palette sheets. Actual gameplay and enlarged inspection views were rendered on Linux. The Windows runtime has not been executed here.

## Changes in 0.35.0

- The western concourse now ends in a supported stone stair gallery. Press E at the threshold to explore Keldrath; returning uses the same entrance.

- Opening arrival now uses three original illustrated panels with click-to-continue text and brief fades. No scrolling camera or walking puppet behind narration.
- Walking uses 160 complete baked frames across ten designs, ordinary and axe/shield equipped. The old cut-and-rotate leg renderer has been removed from playback. Painted knee/boot poses, stable body landmarks and attached equipment replace it. Footstep timing follows the new cycle.
- Hair material masks now include pale-gold fringe pixels in portraits and all original poses. The new walking frames inherit those masks. Hair and beard remain one color selection.
- Orla keeps her crown braids, copper hair, blue clothing and female silhouette across sprite, portrait and anniversary art. Her authored copper palette has its own cache identity.
- Named residents appear inside their workplaces, with quest markers on the actual entrances. They are no longer also drawn on the concourse or hold map. Visitors still walk outdoors and can be addressed where they stand. Available crew at the Kettle can be addressed at their seats.
- A shared presence registry drives indoor rendering, introduction checks and tracking. Recruited crew leave the tavern. Hold residents are not copied into claim workshops.
- Validation: 539 navigation/presence/pose checks and 1,001 palette checks passed. Rendered opening panels, all ten walking designs and Orla's interior appearance reviewed on Linux. Windows runtime is supplied but not executed here.

## Changes in 0.34.0

Keldrath now has a walkable district map. Press G in the hold to explore Crownward, Hearthward and Forgeward. WASD explores north, south, east and west within each tier; E uses stairs and the eastern lift. Click a door to mark a route and press E nearby to enter. Escape pauses travel; G toggles the illustrated whole-hold overview.

- Original illustrated three-tier architecture, familiar residents and quest markers.
- Ten destinations connect existing rooms, the main concourse and the basin. Leaving a map-entered room returns to its landing.
- The King's Gate on Hearthward opens the basin map after your introductions. Royal audiences and combat training retain their quest requirements.
- Lift/stair travel is saved with each fortune. Older saves work without migration prompts. Floor position is preserved.
- Indoor maps are surveys until you leave the room. Mining remains local and persistent; no map escape from deep workings was added.
- This expands navigation around the existing playable rooms and street. The distant illustrated homes and vaults are scenery, not hundreds of newly simulated rooms.
- Validation: 71 district navigation/save/gating checks and 53 opening-flow checks passed; rendered map, lift, room entry and return reviewed on Linux. Windows runtime is bundled but not executed here.

## Changes in 0.33.0

- One hair color controls hair, eyebrows, mustache and beard. Old saves use their hair choice for both.
- Replaced runtime color guessing with 330 saved material masks: ten portraits and 320 ordinary/armed poses.
- Corrected hairline, exposed neck, braid-tip and attack-pose boundaries. Neutral shading removes the yellow cast from dark and grey palettes.
- Creator retains all ten designs and eight hair colors. Female designs remain beardless.
- Checked all pose masks, palette response and unchanged non-hair pixels (1,001 checks); existing grip tests passed (148 checks). Reviewed rendered contact sheets and live creator refresh on Linux Godot 4.4.1. Windows runtime is included but was not executed here.

## Changes in 0.32.2

Opening directions now consistently use the regional map: Old Workings for coal,
Pinewood for timber. Introductions track the next unmet host and Hedrik's dialogue
respects whether you have met Orla. The journal explains the first trip, return
route, royal stair and follow-up commission. Survey-only maps explain whether
introductions, a building exit, the mine mouth or landing is required. Arrival
messages and handbook combat guidance now match the current quest order.
The mine approach lamp now has a visible post and foot anchored to the trail.

## Changes in 0.32.1

Ivar’s voice playback is removed pending a better recording. His dialogue remains
readable, and the handbook now correctly describes the foreman-first opening.

## New in 0.32.0

The anniversary now uses six illustrated couple poses: Hedrik's kettle reveal,
Orla's table reveal, admiration, the player's shared secret, the steam joke,
and a toast. The same hall, table and kettle are reused across shots. Dialogue
is rendered by the game with refreshed speaker portraits. The sequence uses
pose changes, fades, a short kettle placement and animated steam. It remains
player-paced, skippable and replayable without duplicate rewards.

Recurring hold characters now have fixed identities across fortunes. Hedrik is
a young adult dwarf with chestnut hair, a high knot, a forked beard and a red coat.
His portrait and sprite recolor masks have also been corrected at the hairline.

Four additional recruits are generated and saved with each fortune, alongside
the existing named candidates. They have authored personality lines, roles,
personal projects and normal crew assignments. Claim business connects authored
stories to real work: a founding supper, a discovered seam, workshop improvements
and a freight order. Decisions persist in the Chronicle and can add furnishings,
survey markers and modest crew trust bonuses. Open Manage > Claim business.
There are no hidden timers or penalties for declining these requests.

Existing saves can use these additions. Named cast appearances are deliberately
updated to the canonical designs. A new fortune is only needed to replay the
employment opening naturally. See `docs/GUIDED-SANDBOX-32.md` for the implemented
scope and `docs/ART-32.md` for illustration provenance and shot continuity.

## Controls

| Input | Action |
|---|---|
| A / D or left / right | Walk |
| Space | Jump |
| Mouse + hold left button | Aim and repeatedly use your tool |
| 5 | Equip the slagcaster after fabrication; cells load on contact |
| Shift + left button | Single-grain precision cut |
| X / K | Chip a field sample / open field notebook |
| 1 / 2 / 3 / 4 | Pickaxe / shovel / axe / hammer |
| E | Interact / enter a building |
| G | Enter regional travel from the surface; toggle survey while travelling |
| W / S or up / down, in mine | Climb a placed ladder |
| R, in mine | Confirm paid emergency extraction |
| F | Draw / stow weapon |
| Right mouse | Guard; time the press to parry |
| Q | Dodge (no stamina) |
| B | Equipment |
| V | Build stairs, platforms, ladders or supports |
| N | People roster and location tracking |
| C | Character name and appearance |
| J | Work journal and charter progress |
| I | Shared inventory |
| Tab / Shift+Tab | Move menu focus |
| M | Crew assignments |
| F1 | In-game handbook |
| F5 | Save |
| Escape | Close a menu / settings |

The pause/settings panel includes volume and gentle camera-shake controls.
Production and crew continue while menus are open. Returning to the title
stops the simulation. Closing the window saves automatically.

## Your character

Choose a male or female dwarf, type your name, and cycle through complete designs, linked hair color,
clothing, colors, complexion, runic tattoos and fittings. Use the Face & hair
and Clothes & markings tabs. The portrait and animated preview update together.
Randomize Look preserves your name and gender. Suggest Name is separate.
Baseline Look restores the reference-inspired male or female appearance while
preserving your given name, family name and gender.

Press C in-game or use your quarters to change your name and appearance.
Apply saves the result; Cancel discards it. NPCs get stable randomized looks
shared by their portraits and sprites. Meet the hold in your quarters to see
the residents, or talk to townsfolk between the buildings with E.

## Your first session — Beneath the Crown of Stone

You arrive at Lord Eirik's mountain hold, Keldrath, with 45 crowns, basic
tools and a room in the workers' quarters. A short arrival scene follows your
coming of age. Introduce yourself to Ivar, then meet Borin, Orla and Hedrik.
Your first coal delivery earns an audience in the throne room. Only then does
Eirik explain mountain charters. Return to Ivar for the lift commission and
the first-season lessons. You keep surplus ore; there is no rent or hunger timer.

Three paid commissions from Foreman Ivar introduce the economy:

1. **A cold hearth:** deliver 8 coal for 65 crowns. Borin's lower forge relights.
2. **The weight of the mountain:** deliver 16 stone and 8 timber for 95 crowns.
   The repaired freight cage starts moving.
3. **Copper in the veins:** deliver 5 iron and 3 copper ingots for 135 crowns.
   The aether conduits light up and Eirik signs your charter reference.

Press **J** to review live requirements. Deliver at Ivar's office, east of
Borin's forge and just west of the pithead. The mine entrance is farther east.
In the mine, hold left mouse toward nearby rock. Rust means iron, orange means
copper, dark blue means coal, and mint green means aether. Use W/S for the
placed ladders. V builds stairs and supports; R confirms paid rescue. Walk west through the mouth to leave.

At Borin's forge, two ore and one coal make an ingot. Work continues while you
explore. His lower hearth must be restored before you can use it.

Walk to the far eastern King's Gate to reach the road. Marked fir trees can
be chopped with the axe (3); the terrace has a mountain survey table. Charters
are permanent choices, with a confirmation before purchase:

- **Old Delving — 260 crowns:** extra shallow iron, a longer starter gallery,
  and an inherited foundation.
- **Copper Ridge — 290 crowns:** extra copper and aether; build from bare ground.
- **Wayfarer's Rise — 240 crowns:** poorer concentrated ore, but freight
  contracts pay an extra 10 crowns.

The three wages plus starting savings total 340 crowns before other spending.
You can also sell surplus and complete Orla's repeatable freight contracts.
You do not need to buy research or hire a worker before purchasing a charter.

Travel to your claim from the gate or survey menu. At its founding stones,
equip the hammer (4), lay the foundation, build a workshop, then commission a
freight beacon. The final stage needs machine parts: research Precision
forging at Keldrath's survey office. Buildings appear as you construct them.
Old Delving skips the foundation stage because it already has one.

**Establishing this independent hold is the opening milestone.** You may then
recruit Brann, develop automation, and build the First Fortune at your own
launchyard. Keldrath remains available for trade, research and fellowship.
The ship retains its three construction stages and launch sequence. Flight
between planets is not implemented in this version.

Keldrath's mine and your claim are separate excavations. Both remember all
removed rock and partial damage. Hired crew excavate your claim while you are
there; assignments pause when you visit Keldrath or the King's Road.

## Art and places

The starting hold is **Keldrath**. Original 2D panoramas establish the ancestral
hall, King's Road valley, and independent ridge. The distant scenery uses a
restrained atmospheric treatment so playable buildings and characters remain
clear. Original illustrated forge, tavern, office, pithead and beacon sprites
now share substantial stone arches, bronze fittings and warm windows. Worn
paving, retaining masonry, contact shadows and local character color shifts
anchor the playable terrace.

Each customized dwarf uses complete illustrated full-body animation frames,
cached into eight-frame rows for idle, walking, working, and player tool use.
Walking and working have eight distinct poses. Idle adds gentle breathing.
The default male and female use intact original artwork; other styles use
complete bald, clean-shaven bodies with fitted hair and beard overlays.
Female dwarfs never render facial hair. Portraits keep their separate artwork.
The player's tool follows the animated grip and reaches the targeted rock.

Fine slate artwork spans the destructible mountain continuously. Mineral
inclusions form winding veins, while chipped lips and shaded undersides update
at excavated edges. Water has small moving surface reflections. All this art
uses the same seven-pixel excavation grid, including in existing saved worlds.

These are connected playable zones, not a seamless planet. The three charter
choices share the independent-ridge art but have different generated geology
and starting advantages. Distant halls and mountains are scenery rather than
individually accessible locations. The full source includes asset provenance,
generation prompts, and runtime animation sheets in docs/screenshots.

## Saving

One slot, with a confirmation before New Game replaces it. Auto-save every
45 seconds, on travel, major purchases, research, window close and launch.

Windows save location:
`%APPDATA%\Godot\app_userdata\The Stellar Holds — The First Fortune\first_fortune_v1.json`

Campaign jobs, charter choice, founding works, separate mines, road timber,
inventory, crowns, geology (including partial damage), research, production
jobs, market supply, trees, worker ownership and ship progress are saved.
The file is written to a temporary file and renamed to avoid partial saves.
No offline production. Worker positions and partial fuel cycles reset at
reload and when changing sites, consuming fresh fuel. Earlier saves migrate
as independent freeholds with their original excavation, appearance, money,
and ship progress intact. They skip the new employment chapter.

## Contents

- `FirstFortune.pck`: ready-to-run packed game.
- `Engine/Godot.exe`: official Godot Windows runtime/editor.
- `Source/`: complete editable project, assets, scenes, scripts, tests and docs.
- `Source/docs/screenshots/`: actual Godot runtime captures.
- `Source/docs/DEVELOPMENT.md`: features, limitations, testing and next milestone.
- `Source/docs/ASSET-PROVENANCE.md`: how all game assets were authored.
- `Source/docs/GODOT-LICENSE.txt` and `GODOT-COPYRIGHT.txt`: engine notices.

This is a first playable prototype, not a finished commercial release.

### 0.6 visual update
Illustrated modular dwarf bodies, hair and beards now use shaded cloth, leather, bronze, and skin. Clothing colors and saved identities remain editable. Matching tools appear in the hotbar and work animations; resource pickups, inventory/market icons, crates and barrels use the new item atlas. Existing saves remain compatible.

### 0.7 first-playtest preparation
Portraits retain their detailed illustrated artwork. World actors use independently drawn full-body pixel sprites with matching appearance choices. Mining uses flat, fine-grained strata, twelve seeded chambers, depth-biased ore veins, edible root beds and sealed springs. The shovel extracts these soft gathering deposits efficiently. All deposits are finite; broken tiles and partial damage persist between visits and across saves. W/S climbs placed ladders; R requests paid emergency extraction.

Start a new game to see the new generation. Existing saves keep their excavated maps intact rather than replacing them. The current prototype has bounded procedural claims, not infinite terrain or fluid simulation. Windows runtime remains unverified here; import, Linux boot, rendered screenshots, seed checks, campaign, economy and save tests passed.

### 0.7.1 creator correction
Portraits now have dedicated bust composition using the same artwork and palette as world sprites. Full beards, hair and shoulders fit the frame without world limbs or tools. The separate sprite preview no longer overlaps the portrait. Face/hair and clothing/markings tabs replace the clipped scrolling form. Existing character choices and saves remain compatible.

### 0.7.2 character alignment audit
Portrait and sprite hair, beard, tattoo and jewelry now share facial placement definitions. The braided goatee uses an actual braid; earrings sit at the ear, and amber pendants and distinct tattoo patterns appear in both views. Portraits retain their separate bust composition. Female dwarfs use feminine faces and hairstyles and cannot have facial hair: creator, randomization, normalization, legacy-save migration and renderers enforce this rule.

### 0.7.4 connected character artwork
Replaced the disconnected head/torso composition with original connected male and female bust bases. Hair and beard artwork was rebuilt to match their shallow near-frontal viewing angle, with individually fitted hairlines, cheek roots and mouth openings. World sprites use compact proportions without vertically stretching the bust; legs, arms and belts overlap the body. Portraits retain dedicated framing and contain no world limbs. Female facial-hair restrictions remain enforced.

### 0.7.4 — A name to build upon
Separate given and family names, saved house identity and founder, legacy name migration, and a personalized arrival at Keldrath. Family names remain fixed after founding; wardrobe and given-name changes preserve the house. Dynasty succession gameplay is not yet implemented. The opening menu features the great hall, warm drifting embers, and a framed title.


### 0.8.0 — Stone, hearth, and sound
- Three original 64-second musical arrangements for the hold, rooms, and mine; crossfades between spaces.
- Six ambience beds: wind, distant machinery, hearth crackle, and underground water. Material-specific impacts have three non-repeating takes, with separate break layers and surface footsteps.
- Separate music, environment, and effects sliders under Escape. Audio is synthesized; there are no recorded voices.
- Mining has a synchronized contact pause, persistent cracks, small debris, dust, heavier break feedback, and briefly scattering resources before collection. Camera shake remains optional.
- Enter six buildings with E, walk to the host/workbench on the right, then press E to interact. Walk left and press E to leave. Interior saves resume at the exterior doorway.
- Original illustrated interiors include a visibly cold forge that comes alive after the first commission.
- Ask Eirik about the rockfall or mountain charters before accepting employment. Ivar responds to each stage of the restoration.

Audio data and loop boundaries were checked, but subjective headphone/speaker listening is still needed. Windows execution remains untested here. Existing saves migrate automatically.

### 0.9.0 — Characters and granular excavation

- Dedicated full-body pixel actors with eight-frame walks and tool swings, smaller heads, visible clothing, articulated arms and planted boots. Portraits are unchanged; only appearance choices are shared.
- Terrain cells shrink from 28 to 7 world pixels: sixteen independently destructible pieces in each former block. Flat contiguous strata replace deep beveled rock tiles.
- Pick strokes cut a small visible surface patch. Hold Shift for one-grain precision; shovel clears a broader patch of earth and roots. Hidden layers cannot be struck through the surface.
- Disturbed loose earth settles under gravity. Breached springs release water that falls and spreads sideways; dig channels or scoop it with a shovel. Solid rock remains stable. This is a bounded cellular simulation, not a full fluid or structural engineering model.
- Resource fragments accumulate into inventory units without multiplying ore yields. Remainders, moving materials, and damage persist in saves. Older 28-pixel excavations migrate into the finer grid at their original world positions.
- Existing worlds keep their old geography. Start a new fortune for the revised fine contours and introductory reservoir.

Visual references: Stardew Valley's separation between expressive portraits and compact gameplay actors, and Sandustry's fine destructible material fields. All new sprite and terrain drawing is original; no reference-game assets are included.

### 0.10.0 — The mountain takes shape

- Original illustrated, stocky full-body dwarf sprites replace the simple geometric actors. All hair/beard styles and outfit colors remain selectable; portraits are unchanged.
- Eight-frame walks, work swings and idle sequences use connected limbs and consistent foot anchors. Illustrated picks follow the hand and strike point.
- Coherent slate formations and winding mineral lodes replace the patchwork mine. Carved king doorways, copper-braced timberwork, lanterns and distant cavern walls give the entry a sense of place.
- Seven-pixel digging, precision cuts, loose-earth gravity, flowing springs and resource-fragment conservation remain intact.
- Existing saves retain their mined terrain. Start a new fortune to see the new winding ore distribution and rounded starter reservoir.

Extract the whole package and run PLAY-WINDOWS.bat. No separate installation is needed.

### 0.11.0 — Whole characters and finer stone

- Complete male and female animation frames replace separately assembled body parts. The approved reference remains the visual target; actual runtime samples are in docs/screenshots/baseline-board.png.
- Fitted hairstyles and beards, clothing colors, and NPC randomization remain available. Female facial hair stays disabled. Portrait artwork is unchanged.
- Baseline Look in the creator restores the teal-and-honey starting appearance without changing names or gender.
- Fine slate texture replaces oversized boulder faces. Ore has irregular mineral inclusions; fresh cuts expose chipped edges. Earth, roots and water use quieter textures.
- Fine digging, persistent cracks, falling soil, released springs, resource yields, opening quests and audio remain intact. Existing excavations are preserved.

The packaged game and mechanics are checked on Linux. The supplied Windows launcher has not been run on Windows here.

### 0.12.0 — Layered mountains and tool contact

- Seed-driven folded rock beds, varied stone palettes, textured parallax pillars, faint light shafts and dust deepen the mine environment.
- Small crystals, roots and rock chips attach to suitable exposed material and disappear with their supporting terrain.
- Visible terrain sections are cached independently; excavation updates neighboring faces, including across section boundaries.
- New holds and claims use reproducible region addresses with saved generation metadata. Existing excavations remain intact. See docs/GALACTIC-ENVIRONMENT.md for implemented foundations and the streaming roadmap.
- Picks use their points, axes their cutting edges, hammers their faces, and shovels their blades as contact landmarks. Handles pass through the grip with the original fingers rendered in front. Tools mirror with facing direction. Shovels use a shorter thrust sequence, and tree strikes target the actual trunk.
- This remains a bounded regional prototype, not an infinite or playable galactic sandbox.


## 0.14.0 — Armed expeditions and return routes

You start with a holdguard axe and shield. Press **F** to ready them, **LMB** to
attack, **RMB** to guard (press just before a blow for a parry), and **Q** to
dodge. There is no stamina. A parry grants a 1.75x counterattack. The axe is quick;
the piston warhammer staggers and ignores beetle shell resistance; the brasslock
carbine fires aimed shots stopped by rock. Forge the latter two after researching
precision forging. Cartridges are crafted from iron and coal. Press **B** to equip.

Riveted mail reduces damage by 25%; rune-plated harness reduces it by 45%.
Both visibly change the world sprite on male and female characters. Forge them
at Borin's restored workbench. Portrait artwork retains the character's identity.

Up to three finite encounters per mine, placed in open chambers beyond the safe
starter gallery, introduce Goblin scavengers and cave beetles. They give clear
windups, have short chase ranges, and pause while menus are open. Cleared
encounters stay cleared. Goblin scrap and iron-rich carapaces refine into ingots
for the hold. No recurring enemy-spawn timer or mandatory combat commission.

**V** opens construction: timber stairs, platforms, ladders and braced roof
frames. Point within reach and click to build; 1–4 returns to tools. W/S climbs
near a ladder; unrestricted survey-winch flight has been removed. Supports
physically catch loose earth. Hired miners avoid built timber. Hard-rock
structural stress and random cave-ins are not simulated.

**R** opens an emergency rescue confirmation. Rescue costs the greater of 25
crowns or 20% of your purse. Unpaid fees become debt settled from future income.
Combat defeat uses the same paid rescue. Equipment and resources remain intact;
you return to the gallery with 65 health. Rest outside the mine to heal.

**N** opens the people roster. Cards show locations instead of hair/clothing
labels. Track a workplace or moving visitor to see direction and distance.
Existing saves receive compatible equipment, construction and rescue defaults.


## 0.15.0 — Coherent customizable animation

All ten beard choices, all six hairstyles per gender, hair/beard colors, skin, markings and equipment remain available. Portraits are unchanged. Movement and work use the same modular appearance, with per-pose jaw anchors, head rotation, flexible lower lengths and foreground-arm occlusion. These compositions are baked into animation frames.

Axe-and-shield combat now uses complete original male/female one-handed combat drawings, with the shield supported by its own arm. Carrying equipment matches that design and follows the drawn hands. Hammer, gun and mining actions retain their existing complete body animations with the improved appearance rig.

Validation includes in-engine frame boards for every beard choice and female hairstyle, left/right motion, armor, live shield parry and counterattack, combat checks and packaged startup. Windows execution itself has not been tested.


## 0.15.1 — Equipped axe grip

Stationary axe users now retain the complete drawn axe-and-shield ready stance. Walking and other carried tools repaint the full visible fist over the handle, replacing the small palm-only overlap. Checked male/female idle and all eight walking frames in both directions.


## 0.16.0 — Unified holdguard rig

- Axe and shield remain one equipment selection and now use complete coordinated body drawings for ready, walk, strike, guard, block recoil and parry/recovery.
- Walking uses four distinct poses per gender. Guarded movement keeps moving legs; impact briefly plants the stance. Both directions mirror the entire rig.
- Nine beard artworks (plus clean-shaven) use measured bounds instead of incorrect equal-cell crops. Upper moustache anchors stay fixed; only lower lengths sway.
- All existing hair, beard/color, skin/marking and armor choices remain available. Female dwarfs remain beardless. Portrait artwork is unchanged.
- Original generated walk/guard source sheets and full prompts are included in assets/actors-v16 and docs/rig-v16-art-prompts.txt.
- Validation: rendered all beard choices and female hairstyles; recorded in-game walk/ready/attack/guard/block/parry sequences in both directions. Combat and appearance tests and packaged boot checked on Linux Godot 4.4.1. Windows runtime is bundled but has not been executed in this environment.


## 0.17.0 — Complete dwarf designs and grounded movement

The creator now selects complete dwarf designs: swept greatbeard, long twin braids, or the feminine crown-braided dwarf. Hair, beard, head and body are drawn together in ordinary and armed frames. The previous independent hairstyle/beard geometry selectors are replaced by this design choice. Hair/beard colors, complexion, markings, armor, and given/family names remain. Original portrait artwork remains, using the corresponding design's hair/beard choices. Old saves migrate to the closest design without resetting their world or inventory.

Movement now resolves the final fraction of a step to the terrain face instead of discarding it. A shared 44x76 standing body governs collision, building exclusion and falling-grain exclusion. Feet are the common rendering/physics origin; extended weapons, moving hands and sweeping boots are outside the standing body. Narrow passages must clear the body. Old wall-adjacent saves receive a local overlap correction of at most 14 pixels when loaded.

The hold's floating facade bars were removed and the exposed service conduit moved onto supported foundations. The trail entrance uses a grounded carved arch. The former mine-level bedrock strip no longer cuts through it or blocks jumps at the boundary. Camera height stays continuous at the entrance and follows actual descent below the concourse.

Validation: 148 palette/complete-sprite checks, 29 appearance/save checks, 47 combat checks; floor/wall contact at 30/60/120 FPS; 77px versus 70px tunnel clearance; complete hold-trail-mine round trip. Rendered and inspected all three designs, palette variants, both directions, mining/armed movement/attack/guard/parry, plus hold and entrance captures. The Windows package includes source and original assets. Runtime validation uses Linux Godot 4.4.1; Windows itself is not exercised here.

Original art prompts and selected asset provenance: docs/sculpts-v17-art-prompts.txt. Contact/visual harnesses: tests/test_contact17.gd, test_sculpt_contract17.gd, test_sculpts17.gd, test_motion17.gd, test_world17.gd.


## 0.18.0 — A mountain to make your own

- Five complete male and five complete female dwarf designs, with color customization and pose-specific equipment sockets for future gear.
- Mountain-shaped soil and rock, winding mineral seams, connected natural caves, roots and springs. The starter adit ends in a diggable dirt face.
- P toggles shovel sifting: slower, smaller strokes recover mineral traces and clues to real nearby seams.
- Grounded roof frames, connected timber structures and anchored ladder chains. Undermining their support recovers them instead of leaving floating structures.
- Given and family names remain separate. Your character begins as an individual; an established clan or dynasty is not assumed.
- Earlier mine layouts are regenerated on loading/revisiting. Existing character progression and possessions remain; a saved underground character returns to the entrance.

Rig and generation details: docs/rig-and-mountain-v18.md. Windows package includes the runtime and full Godot source.

## 0.19.0 — Consistent character identities

All ten designs now use a shared animation-source registry. Armed movement, attacks and guards were revised against each design's ordinary movement reference. Removed extra female chest/rear braids, corrected the swept greatbeard guard silhouette, and preserved the bob across actions. Hair colors remain customizable. The bald crown no longer receives the hair tint, and long rear hair receives its selected color.

Visual review uses 32 unique poses per design (walk, work, attack, armed walk and guard), in gold and raven palettes, plus actual gameplay captures with armor and both facings. Source includes the review harness and reference descriptions. Pose drawings still vary naturally with perspective; future helmet/outfit assets require the same review. Existing equipment sockets remain available.

## 0.20.0 — Rune armor and responsive movement

Rune armor now carries a small angular engraving positioned on its shoulder plate. It is clipped by the painted garment mask, so it cannot draw over skin, hair or shields. Removed the full-height luminous stripes. Ordinary armor has no glowing rune.

Movement integrates at 120 Hz independently of rendering: stronger acceleration, faster reversal and braking, 120 ms jump buffering, 90 ms coyote time and variable jump height. Tap Space for a short hop; hold for the full jump. Holding Space never auto-repeats jumps. Mining impact pauses no longer freeze locomotion. Single-cell steps require clear headroom; ground contact uses a quarter-pixel probe. Camera/world draw offsets share a pixel grid.

Fixed the sprite cache fallback ignoring indoor zoom and lighting; cached and direct draws now match within one sampling pixel at 1.5x. Newly built atlases are not used before their first rendered frame. Native pose scale remains fixed within each source family; crouching and arm movement do not dynamically resize the character. Feet remain the visual and collision origin.

Verification: 18 controller checks (30/60/120 FPS, braking, reversal, buffered/coyote/tap jumps, ceiling clearance and dodge-wall collision), eight cached/direct scale comparisons, floor/wall contact regression and 47 combat checks. Actual ten-dwarf gameplay captures reviewed with armor and both facings. Linux Godot runtime tested; Windows package not executed here.

## 0.20.1 — Pre-playtest review

Escape now freezes the whole simulation, including production, geology, enemies and timers. Losing window focus opens this pause screen, even from another menu; returning focus does not resume automatically. Character customization also freezes simulation. Ordinary inventory/trade screens retain their existing production behavior; use Escape or switch windows when stepping away.

Opening employment acceptance and current commission requirements/reward/delivery now appear before the longer narrative and character card. J remains the work journal and N the people tracker.

Reviewed 12 rendered screens: title, creator, introduction, hold, commission, equipment, research, approach, mine mouth, mine, forge and pause. Current journey regression passed, mountain validation passed 527 checks, sound/spaces/mining passed 66 checks. These supplement the 0.20.0 controller, scale and combat checks. Focus-exit signal and persistent pause behavior were exercised. Audio checks validate assets/routing, not subjective listening quality. The review capture harness reports one resource retained at shutdown; packaged boot is tested separately.

Verdict: ready for an initial hands-on acceptance playtest. Final art approval remains open: terrain edges are visibly modular, some independently painted poses vary in proportions, and Windows hardware performance and subjective control/audio feel require playtesting. The planned galactic sandbox and family systems are not complete prototype deliverables.


## 0.21.0 — Ten painted portrait identities

Each of the five male and five female complete sprite designs now owns a custom, single-piece pixel portrait. Hair silhouette, beard shape and braid count follow the corresponding sprite design. Women have no facial hair. The portraits remain detailed busts rather than enlarged sprite heads.

Hair and beard colors remain independent for male characters; female portraits follow hair color. Complexion, clothing palette and optional cheek markings/jewelry are retained. Portraits use 192-pixel render targets and redraw only when a profile changes, avoiding generic blinking overlays and continuous repainting. Creator, dialogue, people cards and player cards all use the same ten-design selection.

Source paintings: assets/portraits-v21/*.png. Prompt/reference record: docs/portrait21-prompts.json. Generated with the built-in image tool, then integrated with runtime palette/material regions. Final review includes all ten designs in honey, raven, snow and mixed-color/detail variants, plus the live creator and dialogue screens. These portraits do not change gameplay animation, movement or collision.

Validation: 278 portrait checks covering every hair palette, fixed dimensions, face/backdrop protection, bald-crown protection and source immutability; 29 appearance/save-migration checks passed. Five ten-character comparison boards and six creator/dialogue captures reviewed. Palette-button refresh and female normalization exercised. Windows runtime has not been executed here; packaged boot is checked with Linux Godot.


## 0.22.0 — Friendlier menus

Shared quick navigation, Back and Close controls, and visible keyboard hints now connect the main menus. Back restores your place; purchases, crafting and equipment changes preserve scroll position. Tab moves keyboard focus; I opens the pack.

Inventory defaults to owned resources. Trading separates Buy, Sell and Contracts with explicit quantities and prices. The forge separates Smelting, Crafting and Tools, and gear separates Weapons and Armor. Missing materials and research requirements explain unavailable actions. People no longer appear twice.

Pause offers six clear actions; audio and camera comfort have their own settings screen. Help is split into four short topics with current combat controls. Help opened from Pause stays paused until you close the menus. Character creation now points to in-world equipment rather than obsolete clothing options.

Validation: 43 graphical layout and interaction checks passed at the 960×540 logical viewport (1280×720 capture), including Back/scroll restoration, paused browsing, roster uniqueness, armor crafting/equipping and blocking tool hotkeys during menus. Reviewed rendered menus. Test teardown reports one retained resource; no script errors occurred. Windows binary is packaged for player testing; validation ran under Linux Godot.


## 0.23.0 — Your soundtrack and synchronized action audio

Four user-supplied music tracks now cover the title, hold/interiors, mountain approaches and mine. The game crossfades between locations and at music restarts. Mountain air and rune machinery use overlap-edited ambient loops. Long-form tracks are loudness-balanced and encoded as Ogg Vorbis.

Six pick contacts, three dirt contacts, four footsteps, two rubble tails and two door clips were extracted from the uploaded recordings. Impact clips have their leading silence removed. Pick/dirt sounds fire from the same terrain contact event as damage and tool-head pose (frame 4), never from a timer or looping recording. Rubble plays only on a successful rock break. Footsteps follow the grounded locomotion clock at plant frames 2 and 5; the body and held equipment share that clock. There are no walking sounds while standing still, airborne, climbing or dodging. Landing has its own contact cue. Door audio is limited to actual building transitions, which currently use a scene fade rather than an animated door leaf.

Ivar's welcome is now text only. His recording is not loaded or exported, and the replay/listen buttons have been removed. Read Ivar's advice from his commission panel. The original source audio is retained for future replacement work. Music and other sounds are unchanged.

Validation: 31 audio-event/integration checks passed, including contact-frame timing, no recovery double-trigger, no out-of-reach impact, grounded footfalls, soundtrack routing, speech ducking/pause/skip and door-only transitions. Welcome screen rendered and reviewed. This is technical timing and waveform validation, not a listening-quality endorsement; player listening remains needed for timbre and balance. Test teardown reports retained resources, without runtime script errors. Windows executable not run in this Linux environment.

Source provenance: the twelve WAVs supplied by the user on October 15, 2026; originals are preserved separately. Edited asset ranges and processing are recorded in docs/audio23-sources.json. Older synthesized effects remain for actions without replacement recordings. Do not run compose_audio.py expecting it to regenerate the supplied music or effects.


## 0.24.0 — Mixer audit and independent sound controls

Sound options are available on the title screen and through Escape > Sound & comfort. Six controls: Master, Music, Environment, Tools & combat, Footsteps and Dialogue. Changes apply immediately and persist in audio_settings.cfg independently of character saves. Zero fully mutes its category. Test-pick/test-footstep buttons and Reset audio defaults are available.

Corrected a deep volume dip in the old decibel-linear crossfade by fading amplitude. Reduced supplied wind/machinery ambient playback by 12/14 dB respectively and gently raised the very quiet older mine/hearth beds. Dialogue and footsteps now have separate mixer buses. A master limiter provides additional overload protection at high slider settings. Resume adventure now resumes a paused welcome instead of dismissing it.

Validation: all 31 contact/voice integration checks and 37 mixer/persistence checks passed (68 total). Three offline overlapping-action mixes at default settings had no clipped samples and measured peaks from -11.93 to -11.09 dBFS before the limiter. The offline mixes are representative simulations, not recordings of every possible gameplay combination. Verified routing, independent mutes, crossfade midpoint, preferences across state instances and voice resume. Reviewed title/settings renders. Test teardown retains resources; no runtime script errors. These checks establish configuration/timing and measured headroom; subjective listening quality and Windows playback still need player confirmation.


## 0.25.0 — The Keldrath Basin expedition pass

Press **G** for the regional map. Keldrath, High Trail, the Old Workings,
Pinewood and the three charter destinations share a connected road network.
The local expedition is the same persistent mountain reached on foot. Travel
preserves cuts, structures and woodland depletion. Underground travel is
blocked: return to the entrance using your own excavation and construction.
Pinewood is the explicit timber destination; use axe [3] beside marked firs.

New terrain has a gently graded haulage adit, a shallow coal working face,
irregular cave pockets, connected mineral seams and substantially deeper
basalt. Encounters begin beyond the starter working face. Existing saves keep
their excavations; shallow basalt migrates to workable stone. Start a new
fortune to see the entire new terrain layout (back up your existing save first).

Walking now articulates the legs independently, with distinct rising/falling
jump poses. Tools retain fixed dimensions regardless of targeting distance.
Ladders have a full-body clearance footprint, wider rails, taller sections and
hold the dwarf when climbing input is released. Uphill camera tracking and
continuous trail/mine crossings no longer force a boundary save hitch.
Male hair and beard recoloring covers the complete designs, including armed
poses, while preserving skin, leather and clothing.

Pick, dirt and boot samples have less bass, lower gain and shorter tails.
All existing separate mixer sliders remain available. Falling grains have a
bounded update budget; terrain redraws patch changed grains and adjacent faces
instead of rebuilding whole chunks.

Verification: 198 expedition assertions, 37 mixer assertions, visual boards for
all ten locomotion/jump designs and all forty male palette combinations in
both working and armed form. A changed grain patched five cells and rebuilt
zero cached chunks. The isolated material test's worst tick was about 1.9 ms;
this is not a full-game FPS guarantee. Automated test teardown reports retained
resources; gameplay boot and script execution are checked separately.

This is a regional travel foundation, not a completed planet or galaxy system.
Travel uses a map route animation; there is not yet free roaming across a fully
simulated top-down planet. Windows execution has not been tested here.


### Three independent save slots
The title menu lists three fortunes by character name, location, played time
and crowns. Each slot owns its world, inventory, character and progression;
autosaves and F5 write only to the active slot. Slot 1 reads the existing legacy
save directly. Slots 2 and 3 start empty. Replacing an occupied slot requires
explicit confirmation and finishing character creation; cancelling preserves it.
Sound preferences are shared across slots. Save/load isolation and replacing
slot 2 without modifying slots 1 or 3 are tested.


## 0.26.0 — Walk the Keldrath Basin

The route-selection panel has been replaced by a playable regional overworld.
Press G from the surface, then steer your actual dwarf with WASD or arrow keys.
Roads lead through painted meadows, pine groves and mountain foothills. Cross
the river on its bridge and approach a landmark; E enters that existing local
location. G toggles the regional overview. Esc pauses the journey; Save & title
preserves your exact regional position. Continue restores it. All three save
slots remain independent. From underground, G is a read-only survey: return to
the entrance before travelling.

The region uses original generated scenery and meadow assets, a scrolling
camera, collision against water/trunks/rock bases, animated walking, footsteps,
subtle river movement and persistent travel coordinates. Roads were tested in
both directions. Local excavations remain intact when entering from the world.

Current scope: authored home-region geography with seeded scenery, seven
existing destinations and free movement within that region. This is not yet an
infinite procedural planet, a fully destructible regional landscape or a ship
piloting system. The existing full local terrain snapshots remain authoritative.
The destination/address/persistence model is the foundation for those layers.

See docs/WORLD-TRAVEL.md for the scale model and expansion plan. Verification
covers road connectivity, river/bridge collision, save/load, resume into the
journey, preserved excavation and prevention of underground escape. Windows
execution remains untested; native Linux rendering and packaged boot are checked.


The user's full mining brief is preserved unchanged in docs/MINING-VISION.md.
Its central benchmark is that personal excavation remains intrinsically enjoyable
even after industrial automation. The regional travel update supports this goal;
it does not claim the entire mining vision is implemented or playtest-approved.


## 0.28.0 — Carved roads and deliberate strikes

The bridge now uses original stone-arch and timber artwork, lanterns, a front
parapet that occludes feet correctly, and a walkable deck matching its crossing.
Waystones and supplies dress regional destinations. The mine entrance supply
cache is shown only while its ground remains. The hold, woodland, entrance,
bridge, strike sequence and a revealed geode were visually inspected.

Mining contact now uses the actual impact-hand reach. Tools keep fixed scale;
the grip moves along the shaft for close work. Head contact, material damage,
sound and particles share the same event. Out-of-range strikes cannot damage
remote terrain. The reticle stays on the committed target during a swing, and
short clicks have a small input buffer. Progressive crack branches communicate
partial damage. Metal and crystal receive quiet material accents.

Newly generated mountains contain three concealed geodes: stone shell, mineable
crystal lining, a small cavity and thin mineral trails. Discovering one awards
20 survey crowns once; discovery state persists. Shift fine cuts preserve twice
as much crystal per grain as broad excavation. Crystal lining now grows visible
facets toward exposed cavity faces. Existing excavations are not regenerated;
new geodes appear in new mountains/fortunes.

Validation: 110 contact/material/discovery assertions; 54 overworld checks;
a 116-swing excavation path removed 206 grains, advanced the dwarf about 109
pixels into a full-body passage and collected 8 stone units. These are technical
and rendered checks, not a claim of a twenty-minute human playtest or subjective
audio approval. Windows execution remains untested here. Some automated visual
harnesses retain resources at shutdown; packaged boot is tested separately.

The full user mining vision remains in docs/MINING-VISION.md. Powered mining,
hauling/logistics, fossils, multiple geological world types and planet-scale
excavation remain future work. This pass improves the current hand-mining core.

### 0.28 — Practical rune-industrial bridge and dry riverbanks
The regional crossing now uses a low steel girder bridge, restrained stone abutments, cyan rune lamps and a power conduit. Its foreground rail overlaps the traveler correctly. Seeded scenery reserves its full rendered bounds along the curved river rather than only checking a trunk point. Hold and woodland landmarks are set back from the water. Existing saves and excavations are retained.

The new field notebook reads real deposits within 36 terrain grains (~252 world pixels), reports broad bearing and signal strength, and retains up to 24 sample locations per mountain. X triggers a fixed-size pick strike; the reading occurs at contact and requires a reachable, exposed surface. K opens notes and lets you track a sampling location. Nearby readings refresh instead of creating duplicate entries. No resources or money are created by repeated sampling. P dirt-sifting remains available. Existing saves gain the notebook immediately.

Validation: 157 regional movement/river/scenery checks and 14 sampling/contact/depletion/snapshot/disk-save checks passed. Bridge and notebook rendered and visually reviewed. Packaged boot tested on Linux; Windows execution remains untested here.

### 0.29 — A founding crew and a guided sandbox

Press **M** for the outpost board: Progress, Crew, Hiring, and Chronicle. Earn a charter through the three opening commissions; foundations provide 2 crew berths, the workshop 4, and the freight beacon 6. Name your outpost and see the materials still needed for its next construction stage. The regional map uses its chosen name.

Six recruitable dwarves have authored core personalities, distinct complete-sprite appearances, seeded secondary interests and personal projects. Five are male and one female. Recruitment is available at the Copper Kettle; a working freight beacon enables remote hiring. Assign Mining, Workshop, Ship engineering, Survey support, or Off duty. Each miner has an independent ore priority and mines actual terrain. Workshop staff accelerate real queued jobs while supplied. A survey assistant extends field samples from 36 to 48 grains. Any crew member can supervise ship engineering once the workshop exists. Specialties strengthen mining/workshop performance, without locking a player into one mandatory hire.

Conversations use 84 new core cast lines, 14 secondary-interest lines, and additional contextual reactions. Voices are authored, with a seeded variation layer; this is not unrestricted generated dialogue. The chronicle records actual recruiting, role changes, worked seams, provision shortages, completed personal projects, founding, and ship construction. Personal projects earn trust and improve mining/workshop contributions. Names, traits, projects, talk progress, crew reserves and chronicles persist in the save.

Mining takes one provision per 192 excavated grains. Workshop staff share one provision per 120 productive seconds. Engineering and survey support do not consume ongoing supplies. No starvation or recurring wage penalty; empty stores suspend the relevant work. Mining runs only while the claim is loaded, workshop queues continue during travel, and neither runs while the game is paused/closed. Path searches are budgeted and retried after a delay when no seam is reachable.

Ship construction now requires the actual launchyard, hammer, materials, and an assigned engineer. Launch remains the first playable chapter's endpoint; free galactic travel, population simulation, marriage and family expansion remain future work.

Validation: 67 outpost/progression/persistence/crew checks, 110 mining checks, 162 regional checks and 14 field-survey checks passed (353 total). Actual menus, crew sprites and outpost rendered and reviewed. The progression test supplies fixture materials to exercise gates and transactions; it does not establish a 45–60 minute human playthrough or balance approval. Linux Godot runtime tested; Windows execution not tested here.

Naming audit: retired Oakenshield → Fellcopper and Farsight → Farspan from generated/player-facing names, including legacy save migration. Current built-in cast and dialogue use independently authored names/text. This is a content audit, not formal clearance or a guarantee that no name is used elsewhere.


### 0.30 — Industry with purpose

Visit a forge's **Industry** tab to review and install machinery. Keldrath and your claim have independent installations. Existing saves start at their existing founding appearance; upgrades are earned rather than granted.

| Benchmark | Installation | Benefit |
|---|---|---|
| Claim workshop (or all three Keldrath restoration jobs), plus Clockwork industry research | Powered workshop: 10 iron, 6 copper, 5 parts, 75 crowns | 1.5× production; enables slagcaster fabrication after thermal research |
| Powered workshop, freight beacon, ship keel, Pressure engineering research | Sealed engineering bay: 14 iron, 8 copper, 8 parts, 1 assembly, 120 crowns | 2× production; new cells hold 24 pulses; claim bay saves 20% of remaining ship materials, rounded up |

The best installed workshop supplies shared production; town and claim bonuses do not multiply. Crew bonuses still apply. Upgrades change workshop facades, gate fittings and (at the claim) freight-yard equipment. Production mechanisms move while a queue is active. These are optional investments; the existing first-ship route remains available.

**Slagcaster:** research Runic thermal extraction after Clockwork industry. Fabricate at a powered workshop for 8 iron, 6 copper, 6 parts, 2 crystals and 120 crowns. Craft three energy cells from 1 crystal, 1 copper and 2 coal. Equip with **5**, then hold left mouse. A standard cell lasts 16 pulses; an engineering bay boosts newly loaded cells to 24. No idle drain. Remaining charge persists across saves. Range 180 pixels; radius 18; one exposed layer per 0.24-second pulse; basalt is cut without a steel pick.

The gun recovers iron/copper as slag (quench 2 slag + 1 water into 1 ingot). Heat destroys coal and roots, and yields half as much crystal as single-grain pick work. Water, constructed timber and claim boundaries stop the beam. Keep the free hand tools for precise, efficient extraction. The gun is an excavation tool, not a combat weapon.

Validation: targeted industry/extraction/save tests; existing mining and outpost regressions; native rendered workshop/yard/weapon checks; packaged Linux boot and all audio streams. Windows runtime and full economy pacing still need player testing. Artwork prompts/provenance are in `docs/INDUSTRY-ART.md`.


### 0.30.2 — People of the hold

Dialogue and singular character references resolve male/female pronouns from the actual character profile. This includes charter recommendations, crew seam records and tracking descriptions. Existing seam chronicle entries are migrated. Original supplied voice recordings and their transcripts are unchanged; new cultural dialogue is text.

The cast has authored male/female social asides: some miners express surprise at a woman joining the workings, others offer practical welcome or familiar brother/sister address. A speaker gets at most one such aside per fortune, with a shared minimum of eight advanced conversations between asides. Browsing portraits and refreshing menus never consumes or rerolls dialogue.

After the first coal commission, **Around the hold** offers one optional introduction:
- Female: Orla's common dining-room project. Deliver 8 stone + 4 timber; receive 6 timber + 4 provisions.
- Male: Hedrik's freight introduction. Deliver 4 copper ore + 4 timber; receive 2 copper ingots + 4 provisions.

Both grant three minutes of favorable trading terms. The market/tavern and work journal link to the dedicated errand page; physically visit the host to deliver. The chosen errand and one-time reward persist across saves and appearance changes. These are small supply-and-social variants, not combat/mining stat penalties or gender-exclusive professions. Generated visitor demographics remain approximately 85% male / 15% female.

Added validation: 130 culture checks for pronouns, dialogue cadence, stable menu rendering, save migration, both errand branches, correct payment and duplicate prevention; native male/female menu screenshots. Detailed progression playtesting remains the next tuning step.


### 0.32.2: A first season in Keldrath

New fortunes begin with a skippable, player-paced arrival scene. Report to
Ivar, meet Borin, Orla and Hedrik, bring home the first eight coal, then take
the royal stair inside Ivar's office. Lord Eirik has a new painted throne,
floor-length braided beard and a full audience hall. His audience introduces
claims and the longer road toward a ship. Return to Ivar before starting the
lift commission or the local stories. Existing fortunes keep their access.

J links to the First Season journal. Fifteen optional, authored lessons cover
timber, building an escape route, smelting, sampling, research, the steel pick,
freight, combat practice, salvage, charters, recruiting and assigning crew,
your workshop, powered industry, the slagcaster and the first ship keel.
Progress follows actual actions, equipment and research. Report to the host
in person; each reward is paid once. Some dialogue differs by player gender;
requirements and rewards are equal. Most conversations remain about the work.

New fortunes meet no hostiles until completing Borin's practice quest. It opens
after the lift repairs and Ivar's return-route lesson. The practice bay uses
real combat: three attack contacts, one block or parry, and one dodge. The
padded striker cannot cause wounds or produce loot. Return to Borin to finish,
then explore the deeper encounters. B opens weapon and armor choices afterward.

Orla and Hedrik are married, and their fiftieth anniversary is still early.
Each has a secret gift. Help both prepare them, choose the kettle's inscription
and the table's motif, and gather at the Copper Kettle for a short gift exchange.
Male and female routes differ in dialogue and material distribution but total
exactly the same supplies. The gifts become a permanent carved tea table and
rune-heated kettle outside the tavern. Reward: 50 crowns and four provisions.
Refill there for two provisions once per twenty minutes of active play. The
matching commemorative mugs stay with the furnishing. Replay or skip the scene
without changing the reward; there is no duplicate payout. New scenes have text
dialogue, not new voice recordings. Existing supplied audio is retained.

Quest signs use shapes as well as colors: gold ! for offers, gray dots for work
in progress, green check for a ready return, and a loop for repeatable freight.
They appear above relevant dwarves and in character menus. They cover opening
introductions, commissions, local stories, first-season lessons and crew projects.

Borin's hammer, billet and painted anvil share a contact point at indoor and
outdoor scale. His two measured blows are followed by an inspection pause.
Quiet metal audio and sparks occur on contact. Tavern patrons and Hedrik now
hold mugs and occasionally raise them to drink. Hand sockets and foreground
fingers keep the mug attached; all ten character designs were rendered for review.

Start a new save slot to test the full opening. Existing slots retain their
mines, progression, equipment and combat access, and can do the new side stories.
See docs/FIRST-SEASON-31.md for the progression gates and verification details.

## Changes in 0.39.1

- Field notebook explains the two distinct actions: X reads a mineral bearing; P sifts dirt for bonus ore.
- Persistent mine HUD shows the last sample and sifting progress. K pauses the world and lets you select a mineral.
- Sifting sixteen excavated dirt grains near a seam recovers one bonus ore. Progress is saved per mineral and per mountain. No repeat reward for sampling the same rock.
- One mineral scan per shovel stroke, instead of per dirt grain.

## Changes in 0.39.1

- Downward mining uses a lower contact pose and a reachable surface point, with unchanged tool size and grip.
- Aim below your boots to work across the remaining footing, avoiding a narrow hole that catches the body. Each strike still checks line of sight, reach and material hardness. Shift keeps precise single-grain cutting.
